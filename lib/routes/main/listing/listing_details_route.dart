import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'listing_booking_route.dart';
import 'package:flutter_application_1/types/appliance.dart';
import 'package:flutter_application_1/types/user.dart';

class ListingDetailsRoute extends StatelessWidget {
  final Appliance appliance;
  final User author;
  final User currentUser;

  const ListingDetailsRoute({
    super.key,
    required this.appliance,
    required this.author,
    required this.currentUser
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appliance Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top: Details and image
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Details on the left
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appliance.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text('Price: €${appliance.price.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text('Author: ${author.displayName}'),
                      const SizedBox(height: 8),
                      Text('Category: ${appliance.category.name}'),
                      const SizedBox(height: 8),
                      Text(
                        'Available from: ${appliance.availableFrom.day}/${appliance.availableFrom.month}/${appliance.availableFrom.year}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Available until: ${appliance.availableUntil.day}/${appliance.availableUntil.month}/${appliance.availableUntil.year}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Image on the right
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    appliance.imageUrl,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bottom: Map
            SizedBox(
              height: 350,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: appliance.location,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: appliance.location,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Book Now Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ListingBookingRoute(
                            appliance: appliance,
                            currentUser: currentUser,
                          ),
                    ),
                  );
                },
                child: const Text("Book Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
