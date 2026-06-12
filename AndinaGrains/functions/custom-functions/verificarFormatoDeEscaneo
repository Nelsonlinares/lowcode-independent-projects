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

String verificarFormatoDeEscaneo(String? numeroFacturaEscaneada) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // 1. Manejo de Nulos: Si la entrada es nula o vacía, es inválida.
  if (numeroFacturaEscaneada == null || numeroFacturaEscaneada.isEmpty) {
    return 'FORMATO_INVALIDO';
  }

  try {
    // 2. Intentar decodificar como JSON.
    final decodedJson = json.decode(numeroFacturaEscaneada);

    // 3. Verificación de Formato Específico: Buscamos un mapa con una clave 'id' de tipo String.
    if (decodedJson is Map<String, dynamic>) {
      final idValue = decodedJson['id'];

      if (idValue is String && idValue.isNotEmpty) {
        return idValue; // ÉXITO: Devolvemos el ID extraído del JSON.
      }
    }

    // Si la decodificación JSON fue exitosa, pero no es el formato esperado
    // (un Map con 'id' de tipo String no vacío), o si el JSON decodificado
    // no es un mapa (ej: "null", "123", "[...]"), entonces lo tratamos como
    // texto plano y devolvemos la entrada original.
    return numeroFacturaEscaneada;
  } catch (e) {
    // 4. Si json.decode falla (no es un JSON válido en absoluto),
    // asumimos que es texto plano y devolvemos la entrada original.
    return numeroFacturaEscaneada;
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
