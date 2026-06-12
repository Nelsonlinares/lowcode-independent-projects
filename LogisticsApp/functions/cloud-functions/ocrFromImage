const functions = require('firebase-functions');
const admin = require('firebase-admin');
const vision = require('@google-cloud/vision');
const client = new vision.ImageAnnotatorClient();
const cors = require('cors')({ origin: true });

exports.ocrFromImage = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      if (req.method === 'OPTIONS') {
        return res.status(204).send('');
      }

      const { imageBase64 } = req.body;

      if (!imageBase64) {
        return res.status(400).json({ error: 'Missing imageBase64' });
      }

      const [result] = await client.textDetection({
        image: { content: imageBase64 },
      });

      const detections = result.textAnnotations;
      const fullText = detections.length ? detections[0].description : '';

      return res.status(200).json({ text: fullText });
    } catch (error) {
      console.error('OCR error:', error);
      return res.status(500).json({ error: 'OCR processing failed' });
    }
  });
});
