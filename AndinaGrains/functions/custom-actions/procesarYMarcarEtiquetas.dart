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

Future<ResultadoProcesoEtiquetasStruct> procesarYMarcarEtiquetas(
    List<DocumentReference>? pedidosAProcesar) async {
  // Add your function code here!
  // --- FASE 1: VALIDACIÓN DE ENTRADA ---
  if (pedidosAProcesar == null || pedidosAProcesar.isEmpty) {
    print('procesarYMarcarEtiquetas INFO: La lista de pedidos está vacía.');
    return ResultadoProcesoEtiquetasStruct(
      zplString: 'INFO: No hay pedidos seleccionados.',
      fueExitoso: true, // No es un error, simplemente no hay nada que hacer.
    );
  }

  print(
      'procesarYMarcarEtiquetas INFO: Iniciando procesamiento de ${pedidosAProcesar.length} documentos.');

  try {
    // --- FASE 2: OBTENER DATOS ---
    // Obtenemos todos los documentos de una sola vez para ser eficientes.
    final snapshots =
        await Future.wait(pedidosAProcesar.map((ref) => ref.get()));

    // --- FASE 3: FILTRAR Y PREPARAR ---
    // Aquí separamos los pedidos que realmente se van a procesar.
    final List<String> zplCodesValidos = [];
    final List<DocumentReference> refsParaActualizar = [];

    for (var doc in snapshots) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Usamos el nombre de la columna en Firestore: 'cod_ZPL'
        final zpl = data['cod_ZPL'] as String? ?? '';

        // La misma lógica de validación de getCodigosZPL
        if (zpl.isNotEmpty && zpl.startsWith('^XA')) {
          zplCodesValidos.add(zpl);
          refsParaActualizar.add(doc.reference);
        } else {
          print(
              'procesarYMarcarEtiquetas ADVERTENCIA: Pedido ${doc.id} tiene un ZPL inválido. Será omitido.');
        }
      }
    }

    if (refsParaActualizar.isEmpty) {
      print(
          'procesarYMarcarEtiquetas INFO: No se encontraron pedidos con etiquetas válidas.');
      return ResultadoProcesoEtiquetasStruct(
        zplString: 'INFO: No se encontraron etiquetas válidas para imprimir.',
        fueExitoso: false,
      );
    }

    // --- FASE 4 y 5: EJECUTAR Y PERSISTIR (Transacción Atómica) ---
    print(
        'procesarYMarcarEtiquetas INFO: ${refsParaActualizar.length} pedidos válidos encontrados. Actualizando BD...');
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    for (var docRef in refsParaActualizar) {
      batch.update(docRef, {'etiquetaImpresa': true});
    }

    await batch.commit(); // Todas las escrituras ocurren juntas aquí.

    print(
        'procesarYMarcarEtiquetas INFO: Actualización completada. Concatenando ZPLs.');
    final String zplFinal = zplCodesValidos.join('\n');

    return ResultadoProcesoEtiquetasStruct(
      zplString: zplFinal,
      fueExitoso: true,
    );
  } catch (e) {
    print('procesarYMarcarEtiquetas ERROR: Ocurrió una excepción. Error: $e');
    return ResultadoProcesoEtiquetasStruct(
      // 👇 PUEDES CAMBIAR ESTE TEXTO POR EL QUE QUIERAS 👇
      zplString: 'ERROR: Ocurrió un problema al procesar las etiquetas.',
      fueExitoso: false,
    );
  }
}
