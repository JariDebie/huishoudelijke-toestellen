import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/landing/landing_route.dart';
import 'package:flutter_application_1/routes/login/login_route.dart';
import 'package:flutter_application_1/routes/register/register_route.dart';
import 'package:flutter_application_1/routes/main/main_route.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home Appliances",
      initialRoute: "/",
      routes: {
        "/": (context) => const LandingRoute(),
        "/login": (context) => const LoginRoute(),
        "/register": (context) => const RegisterRoute(),
        "/main": (context) => const MainRoute(),
      },
    );
  }
}
