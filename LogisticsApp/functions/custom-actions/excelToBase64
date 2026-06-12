// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';

Future<String> excelToBase64(
  FFUploadedFile archivoExcel,
  String nombreArchivo,
  String nombreColeccion,
) async {
  try {
    final bytes = archivoExcel.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Archivo vacío o no válido');
    }

    // Usar el nombre real del archivo si está disponible
    final finalFileName =
        (archivoExcel.name != null && archivoExcel.name!.isNotEmpty)
            ? archivoExcel.name!
            : nombreArchivo;

    // Convertir a base64 sin prefijo "data:..."
    final base64String = base64Encode(bytes);

    print('📤 Enviando archivo: $finalFileName a colección: $nombreColeccion');
    print('📊 Tamaño del archivo: ${bytes.length} bytes');

    // Llamar Cloud Function onCall
    final callable =
        FirebaseFunctions.instance.httpsCallable('cargaMasivaExcel');
    final response = await callable.call(<String, dynamic>{
      'fileBase64': base64String,
      'fileName': finalFileName, // ← Usar el nombre correcto
      'collectionName': nombreColeccion,
      'sheetIndex': 0,
    });

    print('📥 Respuesta de Cloud Function: ${response.data}');

    // ✅ Verificar que la respuesta sea exitosa
    if (response.data != null && response.data is Map) {
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] == true) {
        final message = responseData['message'] ?? 'Procesado exitosamente';
        final documentsProcessed = responseData['documentsProcessed'] ?? 0;

        print('✅ Éxito: $message - Documentos procesados: $documentsProcessed');
        return 'Éxito: $message. Documentos procesados: $documentsProcessed';
      } else {
        throw Exception(
            'La función reportó un error: ${responseData['message'] ?? 'Error desconocido'}');
      }
    } else {
      throw Exception('Respuesta inválida de la Cloud Function');
    }
  } catch (e) {
    print('❌ Error en excelToBase64: $e');

    // Manejar errores específicos de Cloud Functions
    if (e is FirebaseFunctionsException) {
      final code = e.code;
      final message = e.message ?? 'Error desconocido';
      final details = e.details;

      print(
          '❌ Firebase Functions Error - Code: $code, Message: $message, Details: $details');
      throw Exception('Error de Cloud Function [$code]: $message');
    }

    throw Exception('Error al procesar el archivo: ${e.toString()}');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
