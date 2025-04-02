import 'package:flutter/material.dart';

class LandingRoute extends StatelessWidget {
  const LandingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Appliances")),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: FilledButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: const Text("Login"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: FilledButton.tonal(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/register");
                },
                child: const Text("Register"),
              )
            )
          ],
        ),
      ),
    );
  }
}