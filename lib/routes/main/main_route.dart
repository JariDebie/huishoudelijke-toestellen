import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/main/listing/listing_route.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.explore), label: "View Listing"),
          NavigationDestination(icon: Icon(Icons.add_home_rounded), label: "Sell Appliance"),
          NavigationDestination(icon: Icon(Icons.person), label: "Manage Profile")
        ],
      ),
      body: <Widget>[
        // Listing
        const MainListingRoute(),

        // Sell Appliance
        const Text("Appliance"),

        // Profile
        const Text("Profile")
      ][pageIndex]
    );
  }
}
