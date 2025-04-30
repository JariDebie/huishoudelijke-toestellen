import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/map.dart';

class ListingMapRoute extends StatelessWidget {
  const ListingMapRoute({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listing Map")),
      body: const Center(
        child: OpenStreetMap()
      ),
    );
  }
}