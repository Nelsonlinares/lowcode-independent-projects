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

int conteoDePasajerosEnServicio(
  List<DireccionDeServicioStruct> listadoCantidadParadas,
  bool calcularSuben,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  int totalPasajeros = 0;

  for (var parada in listadoCantidadParadas) {
    if (calcularSuben) {
      // Sum passengers boarding, default to 0 if field is null or missing
      totalPasajeros += parada.numeroDePasajerosEnDireccionQueSuben ?? 0;
    } else {
      // Sum passengers disembarking, default to 0 if field is null or missing
      totalPasajeros += parada.numeroDePasajerosEnDireccionQueBajan ?? 0;
    }
  }

  // Return the total
  return totalPasajeros;
