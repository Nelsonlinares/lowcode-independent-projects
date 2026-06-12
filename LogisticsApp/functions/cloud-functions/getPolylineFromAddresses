const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');
const cors = require('cors')({ origin: true });

const GOOGLE_API_KEY_DIRECTIONS = process.env.API_KEY_DIRECTIONS;

exports.getPolylineFromAddresses = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const { locations, travelMode = 'driving', docPath } = req.body;

      if (!locations || locations.length < 2) {
        return res.status(400).json({ error: 'At least two locations are required' });
      }

      const origin = locations[0];
      const destination = locations[locations.length - 1];
      const waypointsList = locations.slice(1, -1);

      const params = {
        origin: `${origin.lat},${origin.lng}`,
        destination: `${destination.lat},${destination.lng}`,
        mode: travelMode,
        key: GOOGLE_API_KEY_DIRECTIONS,
      };

      if (waypointsList.length) {
        params.waypoints = waypointsList.map(p => `${p.lat},${p.lng}`).join('|');
      }

      const response = await axios.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        { params }
      );

      const route = response.data.routes?.[0];
      if (!route || !route.overview_polyline) {
        return res.status(500).json({ error: 'No route found' });
      }

      const polyline = route.overview_polyline.points;
      const points = decodePolyline(polyline);

      // 👉 Generar imagen del mapa
      const size = 'size=600x400';
      const path = `path=color:0x000000|weight:2|enc:${polyline}`;

      const markers = locations.map((p, i) => {
        const color = i === 0 ? 'green' : (i === locations.length - 1 ? 'red' : 'blue');
        return `markers=color:${color}|${p.lat},${p.lng}`;
      }).join('&');

      const mapUrl = `https://maps.googleapis.com/maps/api/staticmap?${size}&${path}&${markers}&key=${GOOGLE_API_KEY_DIRECTIONS}`;

      const imageResponse = await axios.get(mapUrl, { responseType: 'arraybuffer' });
      const buffer = Buffer.from(imageResponse.data, 'binary');

      const fileName = `map_${Date.now()}_${Math.floor(Math.random() * 100000)}.png`;
      const bucket = admin.storage().bucket();
      const file = bucket.file(`static_maps/${fileName}`);

      await file.save(buffer, {
        metadata: { contentType: 'image/png' },
        public: true,
      });

      const imageUrl = `https://storage.googleapis.com/${bucket.name}/static_maps/${fileName}`;

      /* 👉 Guardar URL en el documento Firestore si viene docPath
      if (docPath) {
        await admin.firestore().doc(docPath).update({ staticMapUrl: imageUrl });
      }*/

      return res.json({ polyline, points, imageUrl });
    } catch (err) {
      console.error(err);
      return res.status(500).json({ error: 'Internal server error' });
    }
  });
});

function decodePolyline(encoded) {
  let poly = [];
  let index = 0, len = encoded.length;
  let lat = 0, lng = 0;

  while (index < len) {
    let b, shift = 0, result = 0;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    const dlat = (result & 1) ? ~(result >> 1) : (result >> 1);
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    const dlng = (result & 1) ? ~(result >> 1) : (result >> 1);
    lng += dlng;

    poly.push({ lat: lat / 1e5, lng: lng / 1e5 });
  }

  return poly;
}
