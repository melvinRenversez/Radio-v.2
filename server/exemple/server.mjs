import express from "express";
import http from "http";
import path from "path";
import { WebSocketServer } from "ws";
import fs from "fs";
import { parseFile } from "music-metadata";
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const server = http.createServer(app);
const wss = new WebSocketServer({ server });

const musicFolder = path.join(__dirname, "Music");
if (!fs.existsSync(musicFolder)) {
    fs.mkdirSync(musicFolder, { recursive: true });
}

const logFile = path.join(__dirname, "server.log");

function log(message) {
    const timestamp = new Date().toISOString();
    const fullMessage = `[${timestamp}] ${message}`;
    console.log(fullMessage);
    fs.appendFileSync(logFile, fullMessage + "\n");
}

let tracks = [];

function refreshTrackList() {
    try {
        tracks = fs.readdirSync(musicFolder).filter(file => file.endsWith(".mp3"));
        log(`🔄 Liste des musiques mise à jour (${tracks.length} pistes disponibles).`);
    } catch (err) {
        log(`❌ Erreur lors de la lecture du dossier Music : ${err.message}`);
    }
}

function scheduleTrackRefresh() {
    const now = new Date();
    const msUntilNext5Min =
        (5 - (now.getMinutes() % 5)) * 60 * 1000 -
        now.getSeconds() * 1000 -
        now.getMilliseconds();

    setTimeout(() => {
        refreshTrackList();
        setInterval(refreshTrackList, 5 * 60 * 1000);
    }, msUntilNext5Min);
}

refreshTrackList(); // Initial refresh
scheduleTrackRefresh();

let currentTrack = "";
let currentTimeTrack = 0;
let totalTimeTrack = 0;
let lastTracks = [];
let nbLastTracks = 5;
let nbConnected = 0;

app.use(express.static(__dirname));

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

app.get("/getTime", (req, res) => {
    res.json({ currentTime: currentTimeTrack });
});

app.get("/getListMusic", (req, res) => {
    res.json({ data: tracks });
});

server.listen(51003, () => {
    log("✅ Serveur lancé sur http://localhost:51003");
});

wss.on("connection", (ws, req) => {
    const ip = req.socket.remoteAddress;
    log(`🟢 Nouveau client connecté : ${ip}`);
    nbConnected++;
    ws.send(JSON.stringify({ currentTrack: currentTrack, duree: currentTimeTrack }));
    broadcastNbConnected();

    ws.on("close", () => {
        nbConnected--;
        broadcastNbConnected();
        log(`🔴 Client déconnecté : ${ip}`);
    });
});

setInterval(() => {
    if (!currentTrack) return;

    currentTimeTrack++;

    const minutes = Math.floor(currentTimeTrack / 60);
    const seconds = currentTimeTrack % 60;
    const totalMinutes = Math.floor(totalTimeTrack / 60);
    const totalSeconds = totalTimeTrack % 60;

    const format = (n) => n.toString().padStart(2, '0');

    log(`🎵 Lecture : ${format(minutes)}:${format(seconds)} / ${format(totalMinutes)}:${format(totalSeconds)} - ${currentTrack}`);
}, 1000);

function broadcastNbConnected() {
    wss.clients.forEach(client => {
        if (client.readyState === 1) {
            client.send(JSON.stringify({ nbConnected }));
        }
    });
}

function broadcastTrack() {
    wss.clients.forEach(client => {
        if (client.readyState === 1) {
            client.send(JSON.stringify({ currentTrack, duree: 0 }));
        }
    });
}

async function getRandomTrack() {
    try {
        const authorizedTracks = tracks.filter(track => !lastTracks.includes(track));
        if (authorizedTracks.length === 0) {
            lastTracks = [];
        }

        const finalTracks = tracks.filter(track => !lastTracks.includes(track));
        const track = finalTracks[Math.floor(Math.random() * finalTracks.length)];

        const metadata = await parseFile(path.join(musicFolder, track));
        totalTimeTrack = Math.floor(metadata.format.duration) + 1;
        currentTrack = track;
        currentTimeTrack = 0;

        if (lastTracks.length >= nbLastTracks || lastTracks.length >= tracks.length - 1) {
            lastTracks = [];
        }
        lastTracks.push(track);

        log(`▶️ Nouvelle piste : ${track} (${totalTimeTrack} secondes)`);
        broadcastTrack();

        setTimeout(getRandomTrack, totalTimeTrack * 1000);
    } catch (error) {
        log(`❌ Erreur lors de la sélection de la piste : ${error.message}`);
        setTimeout(getRandomTrack, 5000); // Réessaie dans 5 sec
    }
}

getRandomTrack();

