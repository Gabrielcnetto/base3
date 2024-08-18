/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require('firebase-functions/v2/https');
const logger = require('firebase-functions/logger');
const functions = require('firebase-functions');
const cors = require('cors')({ origin: true });

const MANYCHAT_API_URL = 'https://api.manychat.com';

exports.manyChatProxy = functions.https.onRequest(async (req, res) => {
    // Utilize o middleware 'cors' para permitir CORS
    cors(req, res, async () => {
        const fetch = (await import('node-fetch')).default; // Importação dinâmica
        
        const url = `${MANYCHAT_API_URL}${req.url}`;
        const options = {
            method: req.method,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer 1438889:178a28fe8cd1db32c7fbd2e27a0c4415', // Substitua pelo seu token do ManyChat
            },
            body: req.method !== 'GET' ? JSON.stringify(req.body) : undefined,
        };

        try {
            const response = await fetch(url, options);
            const data = await response.json();
            
            // Configuração dos headers para lidar com CORS
            res.set('Access-Control-Allow-Origin', '*'); // Permite acesso de qualquer origem
            res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS'); // Métodos permitidos
            res.set('Access-Control-Allow-Headers', 'Authorization, Content-Type'); // Headers permitidos

            res.json(data); // Retorna os dados da resposta
        } catch (error) {
            console.error('Error:', error);
            res.status(500).json({ error: 'Something went wrong' });
        }
    });
});



// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
