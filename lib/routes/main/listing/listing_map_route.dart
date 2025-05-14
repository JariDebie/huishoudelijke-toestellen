import 'package:flutter/material.dart';

class ListingMapRoute extends StatelessWidget {
  const ListingMapRoute({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listing Map")),
      body: Center(
        child: const Text("Map")
      ),
    );
  }
}