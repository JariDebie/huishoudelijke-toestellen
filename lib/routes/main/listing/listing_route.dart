import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/main/listing/listing_map_route.dart';

class MainListingRoute extends StatelessWidget {
  const MainListingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appliances Listing")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome, user!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Some additional information here."),
            const Divider(height: 8, thickness: 1),
            const Text("Add some page content here."),
            FilledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListingMapRoute()));
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.indigo),
                foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
              child: const Text("View Listings on Map"),
            ),
          ],
        )
      )
    );
  }
}