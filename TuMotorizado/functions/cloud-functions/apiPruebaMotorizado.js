const functions = require('firebase-functions');
const admin = require('firebase-admin');
// To avoid deployment errors, do not call admin.initializeApp() in your codeconst functions = require('firebase-functions');
const express = require('express');

exports.apiPruebaMotorizado = functions.https.onRequest((req, res) => {
    // Verificar si la solicitud es un POST
    if (req.method !== 'POST') {
        return res.status(405).send({ error: 'Método no permitido. Solo se permite POST.' });
    }

    // Obtener el header de autorización
    const authHeader = req.headers.authorization;

    // Verificar si el header está presente y es válido
    if (!authHeader || authHeader !== 'Bearer miTokenSeguro123') {
        return res.status(401).send({ error: 'No autorizado. Header de autorización inválido o faltante.' });
    }

    // Procesar los datos si la autenticación es correcta
    const data = req.body;
    console.log('Datos recibidos:', data);

    // Obtener el mensaje y la fecha actual
    const mensaje = data.mensaje;
    const fechaRecepcion = admin.firestore.Timestamp.now();

    // Guardar los datos en Firestore en la colección 'Webhooks'
    const webhookRef = admin.firestore().collection('Webhooks').doc();
    webhookRef.set({
        mensaje: mensaje,
        fechaRecepcion: fechaRecepcion
    })
    .then(() => {
        console.log('Datos guardados correctamente en Firestore');
        res.status(200).send({ message: 'Datos recibidos y guardados correctamente', receivedData: data });
    })
    .catch((error) => {
        console.error('Error al guardar en Firestore:', error);
        res.status(500).send({ error: 'Error al guardar los datos en Firestore' });
    });
});
