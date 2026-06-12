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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '/flutter_flow/lat_lng.dart' as ff;

class PrecomputedPolylineMap extends StatefulWidget {
  const PrecomputedPolylineMap({
    super.key,
    this.width,
    this.height,
    required this.decodedPolylinePoints,
    required this.routePoints,
    this.polylineColor,
    this.polylineWidth,
  });

  final double? width;
  final double? height;
  final List<ff.LatLng> decodedPolylinePoints;
  final List<ff.LatLng> routePoints;
  final Color? polylineColor;
  final double? polylineWidth;

  @override
  State<PrecomputedPolylineMap> createState() => _PrecomputedPolylineMapState();
}

class _PrecomputedPolylineMapState extends State<PrecomputedPolylineMap>
    with SingleTickerProviderStateMixin {
  late gmaps.GoogleMapController _mapController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<gmaps.LatLng> _polylinePoints = [];
  List<gmaps.LatLng> _displayedPoints = [];
  Set<gmaps.Polyline> _polylines = {};
  Set<gmaps.Marker> _markers = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(_onAnimate);

    _initializePolyline();
  }

  Future<void> _initializePolyline() async {
    if (widget.decodedPolylinePoints.length < 2) {
      setState(() => _loading = false);
      return;
    }

    try {
      final rawPoints = widget.decodedPolylinePoints
          .map((p) => gmaps.LatLng(p.latitude, p.longitude))
          .toList();

      _polylinePoints = _interpolatePoints(rawPoints);
      _addMarkers();

      _animationController.reset();
      setState(() {
        _polylines = {
          gmaps.Polyline(
            polylineId: const gmaps.PolylineId('route'),
            points: _polylinePoints,
            color: widget.polylineColor ?? Colors.blue,
            width: (widget.polylineWidth ?? 5).toInt(),
          ),
        };
        _loading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitCameraToPolyline();
        _animationController.forward();
      });
    } catch (e) {
      debugPrint('Error animando la polilínea: \$e');
      setState(() => _loading = false);
    }
  }

  void _onAnimate() {
    final count = (_animation.value * _polylinePoints.length)
        .clamp(0, _polylinePoints.length)
        .round();
    if (_displayedPoints.length != count) {
      setState(() {
        _displayedPoints = _polylinePoints.sublist(0, count);
        _updateProgressMarker();
        if (_displayedPoints.isNotEmpty) {
          _moveCamera(_displayedPoints.last);
        }
      });
    }
  }

  List<gmaps.LatLng> _interpolatePoints(List<gmaps.LatLng> pts) {
    final List<gmaps.LatLng> result = [];
    for (var i = 0; i < pts.length - 1; i++) {
      final start = pts[i];
      final end = pts[i + 1];
      result.add(start);
      final latDiff = end.latitude - start.latitude;
      final lngDiff = end.longitude - start.longitude;
      for (var j = 1; j <= 4; j++) {
        result.add(gmaps.LatLng(
          start.latitude + latDiff * j / 5,
          start.longitude + lngDiff * j / 5,
        ));
      }
    }
    result.add(pts.last);
    return result;
  }

  void _addMarkers() {
    final originalPoints = widget.routePoints;
    _markers = originalPoints.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      final color = index == 0
          ? gmaps.BitmapDescriptor.hueGreen
          : (index == originalPoints.length - 1
              ? gmaps.BitmapDescriptor.hueRed
              : gmaps.BitmapDescriptor.hueAzure);
      final label = index == 0
          ? 'Origen'
          : (index == originalPoints.length - 1 ? 'Destino' : 'Intermedio');
      return gmaps.Marker(
        markerId: gmaps.MarkerId('punto_\$index'),
        position: gmaps.LatLng(point.latitude, point.longitude),
        infoWindow: gmaps.InfoWindow(title: label),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(color),
      );
    }).toSet();
  }

  void _updateProgressMarker() {
    if (_displayedPoints.isEmpty) return;
    final progress = _displayedPoints.last;
    _markers.removeWhere((m) => m.markerId.value == 'progress');
    _markers.add(
      gmaps.Marker(
        markerId: const gmaps.MarkerId('progress'),
        position: progress,
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueBlue,
        ),
      ),
    );
  }

  void _moveCamera(gmaps.LatLng target) {
    _mapController.animateCamera(gmaps.CameraUpdate.newLatLng(target));
  }

  void _fitCameraToPolyline() {
    if (_polylinePoints.isEmpty) return;
    final bounds = _createBounds(_polylinePoints);
    _mapController
        .animateCamera(gmaps.CameraUpdate.newLatLngBounds(bounds, 50));
  }

  gmaps.LatLngBounds _createBounds(List<gmaps.LatLng> pts) {
    var minLat = pts.first.latitude;
    var maxLat = pts.first.latitude;
    var minLng = pts.first.longitude;
    var maxLng = pts.first.longitude;
    for (var p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return gmaps.LatLngBounds(
      southwest: gmaps.LatLng(minLat, minLng),
      northeast: gmaps.LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          gmaps.GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: gmaps.CameraPosition(
              target: gmaps.LatLng(
                widget.decodedPolylinePoints.first.latitude,
                widget.decodedPolylinePoints.first.longitude,
              ),
              zoom: 12,
            ),
            polylines: _polylines,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
