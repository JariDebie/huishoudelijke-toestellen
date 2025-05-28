import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ListingLocationSelectRoute extends StatefulWidget {
  final MapController mapController = MapController();
  final LatLng? initialLocation;
  final void Function(LatLng? newLocation, double? distance) selectLocation;

  ListingLocationSelectRoute({
    super.key,
    this.initialLocation,
    required this.selectLocation,
  });

  @override
  State<ListingLocationSelectRoute> createState() =>
      _ListingLocationSelectRouteState();
}

class _ListingLocationSelectRouteState
    extends State<ListingLocationSelectRoute> {
  final List<double> _distanceMarkers = [1, 2.5, 5, 10, 25, 50, 100];
  LatLng? _location;
  int _distanceIndex = 0;

  @override
  Widget build(BuildContext context) {
    LatLng location;
    if (_location == null) {
      location = widget.initialLocation ?? LatLng(51.23016715, 4.4161294643975015);
    } else {
      location = _location!;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Select Location and Distance")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            SizedBox(
              height: 300,
              child: FlutterMap(
                mapController: widget.mapController,
                options: MapOptions(
                  initialCenter: location,
                  initialZoom: 14.0,
                  interactionOptions: InteractionOptions(
                    flags:
                        InteractiveFlag.drag |
                        InteractiveFlag.pinchMove |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.doubleTapZoom |
                        InteractiveFlag.scrollWheelZoom,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'edu.ap.flutter_map',
                  ),
                  MarkerLayer(
                    markers: [
                        Marker(
                          point: location,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: location,
                        radius: _distanceMarkers[_distanceIndex] * 1000, // Convert km to meters
                        useRadiusInMeter: true,
                        color: Colors.blue.withAlpha(50),
                        borderColor: Colors.blue,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                  Center(
                    child: Icon(Icons.close, color: Colors.black45, size: 40),
                  ),
                ],
              ),
            ),
            Slider(
              min: 0,
              max: _distanceMarkers.length - 1,
              divisions: _distanceMarkers.length - 1,
              label: _distanceMarkers[_distanceIndex].toString(),
              value: _distanceIndex.toDouble(),
              onChanged: (value) {
                setState(() {
                  _distanceIndex = value.toInt();
                });
              },
            ),
            Text(
              'Search radius: ${_distanceMarkers[_distanceIndex]} km',
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    _location = widget.mapController.camera.center;
                  });
                },
                child: const Text("Select Location"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.selectLocation(
                    widget.mapController.camera.center,
                    _distanceMarkers[_distanceIndex],
                  );
                },
                child: const Text("Confirm"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.selectLocation(null, null);
                },
                child: const Text("Reset"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
