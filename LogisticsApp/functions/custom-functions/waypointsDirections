import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

/// Se utilizara esta custom function para armar el string que será utilizado
/// en la API de directions y poder obtener la respuesta necesaria.
String waypointsDirections(
  List<DireccionDeServicioStruct> listaDeDirecciones,
  bool optimizacion,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Si la lista tiene 2 o menos elementos, devolver string vacío
  if (listaDeDirecciones.length <= 2) {
    return '';
  }

  // Tomar solo las direcciones intermedias (excluir primero y último)
  List<String> direcciones = listaDeDirecciones
      .asMap()
      .entries
      .where((entry) =>
          entry.key != 0 && entry.key != listaDeDirecciones.length - 1)
      .map((entry) => entry.value.direccionCompleta)
      .where((direccion) => direccion.isNotEmpty) // Filtrar direcciones vacías
      .toList();

  // Unir las direcciones con el separador '|'
  String direccionesString = direcciones.join('|');

  // Si optimizacion es true, agregar 'optimize:true|' al inicio
  if (optimizacion) {
    return 'optimize:true|$direccionesString';
  }

  // Si optimizacion es false, devolver solo las direcciones
  return direccionesString;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
