// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<ResultadoProcesoEtiquetasStruct> procesarYMarcarUnaEtiqueta(
    DocumentReference? pedidoAProcesar) async {
  // Add your function code here!
  // --- FASE 1: VALIDACIÓN DE ENTRADA ---
  if (pedidoAProcesar == null) {
    print('procesarYMarcarUnaEtiqueta INFO: La referencia del pedido es nula.');
    return ResultadoProcesoEtiquetasStruct(
      zplString: 'INFO: No se proporcionó un pedido válido.',
      fueExitoso: true, // No es un error, no hay nada que hacer.
    );
  }

  print(
      'procesarYMarcarUnaEtiqueta INFO: Iniciando procesamiento para el documento ${pedidoAProcesar.id}.');

  try {
    // --- FASE 2: OBTENER DATOS ---
    final docSnapshot = await pedidoAProcesar.get();

    if (!docSnapshot.exists) {
      print(
          'procesarYMarcarUnaEtiqueta ERROR: El documento ${pedidoAProcesar.id} no existe.');
      return ResultadoProcesoEtiquetasStruct(
        zplString: 'ERROR: El pedido seleccionado ya no existe.',
        fueExitoso: false,
      );
    }

    // --- FASE 3: FILTRAR Y PREPARAR ---
    final data = docSnapshot.data() as Map<String, dynamic>;
    final zpl = data['cod_ZPL'] as String? ?? '';

    // Validamos que el código ZPL sea válido.
    if (zpl.isEmpty || !zpl.startsWith('^XA')) {
      print(
          'procesarYMarcarUnaEtiqueta ADVERTENCIA: Pedido ${pedidoAProcesar.id} tiene un ZPL inválido. No se procesará.');
      return ResultadoProcesoEtiquetasStruct(
        zplString: 'ERROR: La etiqueta de este pedido no es válida.',
        fueExitoso: false,
      );
    }

    // --- FASE 4 y 5: EJECUTAR Y PERSISTIR ---
    // Como es un solo documento, una actualización directa es suficiente y segura.
    print(
        'procesarYMarcarUnaEtiqueta INFO: Pedido ${pedidoAProcesar.id} es válido. Actualizando BD...');

    await pedidoAProcesar.update({'etiquetaImpresa': true});

    print('procesarYMarcarUnaEtiqueta INFO: Actualización completada.');

    // --- FASE 6 y 7: NOTIFICAR Y AVANZAR (Retorno) ---
    return ResultadoProcesoEtiquetasStruct(
      zplString: zpl, // Devolvemos el código ZPL único.
      fueExitoso: true,
    );
  } catch (e) {
    print(
        'procesarYMarcarUnaEtiqueta ERROR: Ocurrió una excepción para el pedido ${pedidoAProcesar.id}. Error: $e');
    return ResultadoProcesoEtiquetasStruct(
      zplString: 'ERROR: No se pudo procesar la etiqueta.',
      fueExitoso: false,
    );
  }
}
