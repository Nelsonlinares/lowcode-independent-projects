// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class MapaEstaticoRutaMapBoxPolyline extends StatefulWidget {
  const MapaEstaticoRutaMapBoxPolyline({
    Key? key,
    required this.latlongorigen,
    required this.latlongdestino,
    required this.geometria,
    this.width,
    this.height,
  }) : super(key: key);

  final LatLng latlongorigen;
  final LatLng latlongdestino;
  final String geometria;
  final double? width;
  final double? height;

  @override
  _MapaEstaticoRutaMapBoxPolylineState createState() =>
      _MapaEstaticoRutaMapBoxPolylineState();
}

class _MapaEstaticoRutaMapBoxPolylineState
    extends State<MapaEstaticoRutaMapBoxPolyline> {
  @override
  Widget build(BuildContext context) {
    String accessToken =
        'ACCESS_TOKEN'; 

    String origen =
        '${widget.latlongorigen.longitude},${widget.latlongorigen.latitude}';
    String destino =
        '${widget.latlongdestino.longitude},${widget.latlongdestino.latitude}';
    String encodedGeometria = Uri.encodeComponent(widget.geometria);
    //String dimension = widget.width.toString() + 'x' + widget.height.toString();
    String dimension =
        '${widget.width?.toString() ?? '400'}x${widget.height?.toString() ?? '1200'}';

    String url =
        //'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-s-a+000($origen),pin-s-b+000($destino),path-3+e41111-1($encodedGeometria)/auto/$dimension@2x?padding=120%2C120%2C120%2C120&access_token=$accessToken';
        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-s-a+000($origen),pin-s-b+000($destino),path-3+e41111-1($encodedGeometria)/$dimension@2x?&access_token=$accessToken';

    return Image.network(
      url,
      //width: 800,
      //height: 800,
      width: widget.width,
      height: widget.height,
    );
  }
}
