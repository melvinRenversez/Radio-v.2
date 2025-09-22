import { ElevenLabsClient } from '@elevenlabs/elevenlabs-js';
import fs from 'fs';

const elevenlabs = new ElevenLabsClient({
    apiKey: 'd788204117611473d47da38c67e3c7fd43985069ebde3f3f19ddd3d2693d7c8e',
});

async function main() {
    const audioStream = await elevenlabs.textToSpeech.stream('a5n9pJUnAhX4fn7lx3uo', {
        text: "Bienvenuuue sur RadioMel, Nouveau morceau de la journnée Mass hysteria avec l'enfer des dieux",
        modelId: 'eleven_v3',
    });

    const writeStream = fs.createWriteStream('output.mp3');
    for await (const chunk of audioStream) {
        writeStream.write(chunk);
    }
    writeStream.end();

    console.log('Audio saved as output.mp3');
}

main();
