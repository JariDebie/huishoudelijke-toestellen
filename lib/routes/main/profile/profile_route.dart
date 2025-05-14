import 'package:flutter/material.dart';
import 'package:flutter_application_1/types/user.dart';

class ProfileRoute extends StatelessWidget {
  final User user;

  const ProfileRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Profile")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("abc")
          ],
        )
      )
    );
  }
}