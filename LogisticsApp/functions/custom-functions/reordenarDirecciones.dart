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

List<DireccionDeServicioStruct> reordenarDirecciones(
  List<DireccionDeServicioStruct> listaDeDirecciones,
  List<int> indices,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Verificar que la lista no esté vacía
  if (listaDeDirecciones.isEmpty) {
    return listaDeDirecciones;
  }

  // Verificar que el primer elemento tenga numeroDePasajerosEnDireccionQueBajan == 0
  if ((listaDeDirecciones.first.numeroDePasajerosEnDireccionQueBajan ?? 0) !=
      0) {
    return listaDeDirecciones;
  }

  // Verificar que el último elemento tenga numeroDePasajerosEnDireccionQueSuben == 0
  if ((listaDeDirecciones.last.numeroDePasajerosEnDireccionQueSuben ?? 0) !=
      0) {
    return listaDeDirecciones;
  }

  // Verificar que la lista de índices sea válida
  if (indices.length != listaDeDirecciones.length ||
      indices.any((i) => i < 0 || i >= listaDeDirecciones.length)) {
    return listaDeDirecciones; // Devolver la lista original si los índices son inválidos
  }

  // Crear una nueva lista reordenada según los índices
  List<DireccionDeServicioStruct> listaReordenada = List.generate(
    indices.length,
    (i) => listaDeDirecciones[indices[i]],
  );

  return listaReordenada;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
