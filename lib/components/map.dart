import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMap extends StatefulWidget {
  const OpenStreetMap({super.key});

  @override
  State<OpenStreetMap> createState() => _OpenStreetMapState();
}

class _OpenStreetMapState extends State<OpenStreetMap> {
  final MapController _mapController = MapController();
  double _currentZoom = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(51.23016715, 4.4161294643975015),
          initialZoom: _currentZoom,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.drag | InteractiveFlag.pinchMove | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom | InteractiveFlag.scrollWheelZoom,
          )
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'edu.ap.flutter_map',
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.zoom_in),
            onPressed: () {
              setState(() {
                _currentZoom = _mapController.camera.zoom + 1.0;
                _mapController.move(_mapController.camera.center, _currentZoom);
              });
            },
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            child: const Icon(Icons.zoom_out),
            onPressed: () {
              setState(() {
                _currentZoom = _mapController.camera.zoom - 1.0;
                _mapController.move(_mapController.camera.center, _currentZoom);
              });
            },
          ),
        ],
      )
    );
  }
}
