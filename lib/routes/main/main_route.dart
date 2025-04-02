import 'package:flutter/material.dart';

class MainRoute extends StatelessWidget {
  const MainRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Appliances")),
      body: Center(
        child: Text("Main app content here"),
      )
    );
  }
}