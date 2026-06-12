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

import 'package:excel/excel.dart' as xls;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'package:share_plus/share_plus.dart';

Future<FFUploadedFile> generadorPruebaExcelCopy(
  List<ViajesDesglosadosRecord> viajesAsignadosRecords,
  String? nombreConductor,
  String? nombreCliente,
  DateTime? fechaInicio,
  DateTime? fechaFin,
) async {
  final excel = xls.Excel.createExcel();
  final sheet = excel['Reporte'];
  final bold = xls.CellStyle(bold: true);
  int currentRow = 0;

  // Fecha
  String fechaTexto;
  if (fechaInicio != null && fechaFin != null) {
    final formato = DateFormat('d/M/y');
    fechaTexto =
        'Desde: ${formato.format(fechaInicio)} hasta: ${formato.format(fechaFin)}';
  } else {
    fechaTexto = DateFormat('d/M/y').format(DateTime.now());
  }

  sheet.appendRow(['Fecha:', fechaTexto]);
  sheet
      .cell(
          xls.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
      .cellStyle = bold;
  currentRow++;

  // Cliente
  if (nombreCliente != null && nombreCliente.isNotEmpty) {
    sheet.appendRow(['Cliente:', nombreCliente]);
    sheet
        .cell(xls.CellIndex.indexByColumnRow(
            columnIndex: 0, rowIndex: currentRow))
        .cellStyle = bold;
    currentRow++;
  }

  // Conductor
  if (nombreConductor != null && nombreConductor.isNotEmpty) {
    sheet.appendRow(['Conductor:', nombreConductor]);
    sheet
        .cell(xls.CellIndex.indexByColumnRow(
            columnIndex: 0, rowIndex: currentRow))
        .cellStyle = bold;
    currentRow++;
  }

  // Espacio
  sheet.appendRow([]);
  currentRow++;

  // Cabecera
  final headers = ['Origen', 'Destino', 'Pasajeros', 'Cliente', 'Monto'];

  final headerStyle = xls.CellStyle(
    bold: true,
    topBorder: xls.Border(borderStyle: xls.BorderStyle.Thin),
    bottomBorder: xls.Border(borderStyle: xls.BorderStyle.Thin),
  );

// Agrega la fila sin estilo primero
  sheet.appendRow(headers);

// Aplica el estilo a cada celda recién insertada (en `currentRow`)
  for (int i = 0; i < headers.length; i++) {
    sheet
        .cell(xls.CellIndex.indexByColumnRow(
            columnIndex: i, rowIndex: currentRow))
        .cellStyle = headerStyle;
  }
  currentRow++;

  // Datos
  int totalMonto = 0;
  for (final viaje in viajesAsignadosRecords) {
    final origen =
        "${viaje.direccionOrigenNueva?.direccionSimple ?? 'N/A'}, ${viaje.direccionOrigenNueva?.comuna ?? 'N/A'}";
    final destino =
        "${viaje.direccionDestinoNueva?.direccionSimple ?? 'N/A'}, ${viaje.direccionDestinoNueva?.comuna ?? 'N/A'}";
    final monto = (viaje.monto ?? 0).toInt();
    totalMonto += monto;

    sheet.appendRow([
      origen,
      destino,
      viaje.numeroDePasajeros?.toString() ?? 'N/A',
      viaje.nombreCliente ?? 'N/A',
      monto.toString()
    ]);
    currentRow++;
  }

  // Total
  sheet.appendRow(['', '', '', 'Total', totalMonto.toString()]);
  sheet
      .cell(
          xls.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRow))
      .cellStyle = bold;
  sheet
      .cell(
          xls.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: currentRow))
      .cellStyle = bold;

  final bytes = excel.encode();
  if (bytes == null) throw Exception('No se pudo generar el archivo Excel');

  final fileName = 'viajes_report.xlsx';
  final byteList = Uint8List.fromList(bytes);
  final uploadedFile = FFUploadedFile(bytes: byteList, name: fileName);

  try {
    if (kIsWeb) {
      final blob = html.Blob([byteList]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..download = fileName
        ..style.display = 'none';
      html.document.body?.append(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(byteList);
      final xFile = XFile(file.path,
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          name: fileName);
      await Share.shareXFiles([xFile],
          text: 'Aquí tienes tu reporte de viajes en Excel.');
    }
  } catch (e) {
    print('Error al descargar/compartir el Excel: $e');
  }

  return uploadedFile;
}
