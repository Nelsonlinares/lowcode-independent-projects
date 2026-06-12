const functions = require('firebase-functions');
const admin = require('firebase-admin');
const XLSX = require('xlsx');
const db = admin.firestore();

exports.cargaMasivaExcel = functions.https.onCall(async (data, context) => {
  try {
    console.log('🚀 Función cargaMasivaExcel iniciada');

    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Debes estar autenticado para usar esta función.'
      );
    }

    const {
      fileBase64,
      collectionName = 'CaptacionDatos',
      sheetIndex = 0,
    } = data;

    console.log('📥 Parámetros recibidos:', {
      collectionName,
      sheetIndex,
      base64Length: fileBase64?.length || 0
    });

    if (!fileBase64 || typeof fileBase64 !== 'string') {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'fileBase64 es requerido y debe ser un string.'
      );
    }

    const base64Data = fileBase64.includes(',') ? fileBase64.split(',')[1] : fileBase64;
    const fileBuffer = Buffer.from(base64Data, 'base64');

    const workbook = XLSX.read(fileBuffer, { type: 'buffer' });

    if (!workbook.SheetNames || workbook.SheetNames.length === 0) {
      throw new functions.https.HttpsError('invalid-argument', 'El archivo Excel no contiene hojas.');
    }

    const sheetName = workbook.SheetNames[sheetIndex] || workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];

    if (!worksheet) {
      throw new functions.https.HttpsError('invalid-argument', `No se pudo acceder a la hoja: ${sheetName}`);
    }

    const jsonData = XLSX.utils.sheet_to_json(worksheet, {
      header: 1,
      defval: '',
      raw: false,
    });

    console.log('📄 Datos crudos:', jsonData.length);
    console.log('📄 Primera fila cruda:', jsonData[1]);

    if (!jsonData || jsonData.length < 2) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'El Excel debe tener encabezados y al menos una fila de datos.'
      );
    }

    const headers = jsonData[0];
    const dataRows = jsonData.slice(1);

    console.log('🔎 Headers detectados:', headers);

    const validRows = dataRows.filter(row =>
      Array.isArray(row) &&
      row.some(cell => cell !== null && cell !== undefined && cell.toString().trim() !== '')
    );

    console.log('🔍 Filas válidas detectadas:', validRows.length);
    if (validRows.length > 0) {
      console.log('🔍 Ejemplo de fila válida:', validRows[0]);
    }

    const documents = [];

    for (let i = 0; i < validRows.length; i++) {
      const row = validRows[i];
      console.log(`📊 Procesando fila ${i + 1}:`, row);

      const doc = {
        fechaDeCarga: admin.firestore.FieldValue.serverTimestamp(),
      };

      let fieldCount = 0;

      for (let j = 0; j < headers.length; j++) {
        const rawHeader = headers[j];
        const cellValue = row[j];

        if (typeof rawHeader !== 'string') continue;

        const fieldName = rawHeader
          .toString()
          .trim()
          .toLowerCase()
          .replace(/[^a-zA-Z0-9_]/g, '_')
          .replace(/^_+|_+$/g, '')
          .replace(/_+/g, '_');

        if (!fieldName) continue;

        const value = (cellValue !== null && cellValue !== undefined)
          ? String(cellValue).trim()
          : '';

        if (value !== '') {
          doc[fieldName] = value;
          fieldCount++;
        }
      }

      if (fieldCount > 0) {
        console.log(`✅ Documento ${i + 1} creado con ${fieldCount} campos útiles`);
        if (i === 0) {
          console.log('📄 Ejemplo de documento generado:', JSON.stringify(doc, null, 2));
        }
        documents.push(doc);
      } else {
        console.warn(`⚠️ Fila ${i + 2} ignorada por estar vacía`);
      }
    }

    if (documents.length === 0) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'No se generaron documentos válidos para guardar.'
      );
    }

    console.log(`📦 Guardando ${documents.length} documentos en Firestore...`);

    const batchSize = 500;
    let totalSaved = 0;

    for (let i = 0; i < documents.length; i += batchSize) {
      const batch = db.batch();
      const batchDocs = documents.slice(i, i + batchSize);

      batchDocs.forEach(doc => {
        const docRef = db.collection(collectionName).doc();
        batch.set(docRef, doc);
      });

      await batch.commit();
      totalSaved += batchDocs.length;
    }

    console.log(`🎉 Guardado completado: ${totalSaved} documentos`);

    return {
      success: true,
      message: `Se procesaron ${totalSaved} filas exitosamente`,
      documentsProcessed: totalSaved,
      collection: collectionName,
      sheetName,
      headers: headers.filter(h => h && h.toString().trim()),
    };

  } catch (error) {
    console.error('❌ Error en cargaMasivaExcel:', error);
    throw new functions.https.HttpsError('internal', error.message || 'Error interno del servidor.');
  }
});
