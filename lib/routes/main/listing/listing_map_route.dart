import 'package:flutter/material.dart';
import 'package:flutter_application_1/types/category.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingMapRoute extends StatelessWidget {
  final ApplianceCategory? category;
  const ListingMapRoute({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listing Map")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('appliances').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final markers = <Marker>[];

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            // Filter by category if selected
            if (category != null && data['category'] != category!.name) {
              continue;
            }
            final location = data['location'];
            if (location is GeoPoint) {
              final lat = location.latitude;
              final lng = location.longitude;
              markers.add(
                Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(lat, lng),
                  child: const Icon(Icons.location_on, color: Colors.red),
                ),
              );
            }
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter:
                  markers.isNotEmpty ? markers.first.point : LatLng(51.5, 4.4),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
