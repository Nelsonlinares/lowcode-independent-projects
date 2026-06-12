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

Future<List<DocumentReference>> reOrdenar(
  int oldIndex,
  int newIndex,
  List<DocumentReference> listaReOrdenada,
) async {
  // Add your function code here!

  if (oldIndex < newIndex) {
    newIndex -= 1;
  }

  DocumentReference itemToMove = listaReOrdenada.removeAt(oldIndex);
  listaReOrdenada.insert(newIndex, itemToMove);

  return listaReOrdenada;
}
