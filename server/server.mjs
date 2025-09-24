import express from "express";
import path from "path";
import { fileURLToPath } from 'url';
import { parseFile } from "music-metadata";
import mysql from "mysql2/promise";
import cors from "cors";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(cors());

var currentTrack = {};

app.use(express.static(__dirname));



// ---------- ROUTE ---------- 

app.get("/getTime", (req, res) => {
   res.json(currentTrack.currentTime);
   console.log("get time")
});

app.get("/getCurrentTrack", (req, res) => {
   res.json(currentTrack);
   console.log("get current track")
});

app.get("/", (req, res) => {
   res.sendFile(path.join(__dirname, "index.html"));
});

app.listen(3000, '0.0.0.0', () => {
   console.log("Server running on http://localhost:3000");
});



// ---------- FUNCTION ---------- 


async function getTitres() {


   const conn = mysql.createConnection({
      host: "91.168.244.154",
      port: 51336,
      user: "testradio",
      password: "testRadio%123",
      database: "testRadio"
   });

   const query = `
         SELECT 
            t.id,
            t.titre,
            t.url,
            al.libelle AS album,
            al.annee,
            al.pochette,
            ar.nom AS artiste
         FROM titres t
         JOIN albums al ON al.id = t.fk_album
         JOIN artistes ar ON ar.id = al.fk_artiste
         WHERE t.id NOT IN (
            SELECT fk_titre 
            FROM (
               SELECT fk_titre 
               FROM historiques 
               ORDER BY played_at DESC 
               LIMIT 10
            ) AS h_recent
         )
         ORDER BY t.titre ASC;
         `;


   const [rows] = await (await conn).query(query);
   const track = rows[Math.floor(Math.random() * (rows.length))];

   currentTrack.id = track.id;
   currentTrack.titre = track.titre;
   currentTrack.url = track.url;
   currentTrack.album = track.album;
   currentTrack.annee = track.annee;
   currentTrack.pochette = track.pochette;
   currentTrack.artiste = track.artiste;

   getTimeTrack(track.url)
   addHistoriques(track.id);
}

async function addHistoriques(id) {
   const conn = await mysql.createConnection({
      host: "91.168.244.154",
      port: 51336,
      user: "testradio",
      password: "testRadio%123",
      database: "testRadio"
   });

   try {
      const query = "INSERT INTO historiques (fk_titre) VALUES (?);";
      const [result] = await conn.execute(query, [id]);
      console.log(`Titre ajouté à l'historique : id = ${id}`);
   } catch (err) {
      console.error("Erreur lors de l'ajout à l'historique :", err);
   } finally {
      await conn.end();
   }
}


async function getTimeTrack(track) {
   const filePath = path.join(__dirname, "Music", track);
   try {
      const metadata = await parseFile(filePath);
      const duration = metadata.format.duration; // en secondes
      console.log(`Durée du fichier : ${duration.toFixed(2)} secondes`);

      currentTrack.duree = Math.floor(duration);

      // Optionnel : formater en mm:ss
      const minutes = Math.floor(duration / 60);
      const seconds = Math.floor(duration % 60);
      console.log(`Durée formatée : ${minutes}:${seconds.toString().padStart(2, "0")}`);
   } catch (err) {
      console.error("Erreur lors de la lecture du MP3 :", err);
   }


   console.log(currentTrack)
   playTrack();
}

function playTrack() {

   if (currentTrack == {}) return

   const duree = currentTrack.duree;
   currentTrack.currentTime = 0;


   const interval = setInterval(() => {
      currentTrack.currentTime += 1;
      const minutes = Math.floor(currentTrack.currentTime / 60);
      const seconds = Math.floor(currentTrack.currentTime % 60);
      console.log(`Durée formatée : ${minutes}:${seconds.toString().padStart(2, "0")} :: ${currentTrack.currentTime}`);
      // console.log(currentTrack)
      if (currentTrack.currentTime >= duree) {
         currentTrack.currentTime = 0;
         currentTrack = {};
         clearInterval(interval);
         getTitres();
      }
   }, 1000);

}


getTitres();