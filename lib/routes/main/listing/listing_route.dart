import 'package:flutter/material.dart';

class MainListingRoute extends StatelessWidget {
  const MainListingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appliances Listing")),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, user!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Some additional information here."),
            Divider(height: 8, thickness: 1),
            Text("Add some page content here.")
          ],
        )
      )
    );
  }
}