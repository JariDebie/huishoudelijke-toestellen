import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/login/login_route.dart';
import 'package:flutter_application_1/routes/register/register_route.dart';

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginRoute()));
                },
                child: const Text("Login"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: FilledButton.tonal(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterRoute()));
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