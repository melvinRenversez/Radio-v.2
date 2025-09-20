// fichier: db.mjs
import mysql from 'mysql2/promise'; // version promise pour async/await

// Configuration de la base
const connection = await mysql.createConnection({
    host: 'localhost',      // Adresse du serveur MySQL
    user: 'ton_utilisateur',// Nom d'utilisateur MySQL
    password: 'ton_mdp',    // Mot de passe
    database: 'nom_db'      // Nom de la base de données
});

// Test de connexion
try {
    await connection.connect(); // pas obligatoire avec mysql2/promise
    console.log('Connecté à la base MySQL !');
} catch (err) {
    console.error('Erreur de connexion :', err);
}

// Exemple de requête
const [rows] = await connection.execute('SELECT * FROM ta_table LIMIT 5');
console.log(rows);

// Fermer la connexion
await connection.end();
