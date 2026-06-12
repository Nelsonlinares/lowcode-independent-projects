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

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> sendImageToOCR(String base64Image) async {
  // Add your function code here!
  const functionUrl =
      'https://us-central1-transmol-produccion.cloudfunctions.net/ocrFromImage';

  try {
    final response = await http.post(
      Uri.parse(functionUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'imageBase64': base64Image}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['text'] ?? '';
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      final message = errorData['error'] ?? 'Unexpected error';
      throw Exception('OCR failed: $message');
    }
  } catch (e) {
    throw Exception('Failed to call OCR function: $e');
  }
}
