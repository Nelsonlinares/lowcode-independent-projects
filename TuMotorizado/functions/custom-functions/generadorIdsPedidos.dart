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

String generadorIdsPedidos(List<TrabajosRecord> listaIds) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  const letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final random = math.Random();
  String nuevoId;

  // Generar un nuevo ID hasta que sea único
  do {
    // Generar las primeras 4 letras
    final primeraParte =
        List.generate(4, (_) => letras[random.nextInt(letras.length)]).join();

    // Generar las segundas 4 cifras numéricas
    final segundaParte = List.generate(4, (_) => random.nextInt(10)).join();

    // Combinar ambas partes
    nuevoId = '$primeraParte-$segundaParte';

    // Verificar si ya existe un documento con este idPedidoRastreo
  } while (listaIds.any((doc) => doc.idPedidoRastreo == nuevoId));

  return nuevoId;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
