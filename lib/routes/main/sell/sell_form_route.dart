import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/sell_form.dart';
import 'package:flutter_application_1/types/user.dart';

class SellFormRoute extends StatelessWidget {
  final User user;

  const SellFormRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details of New Appliance")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SellForm(
                onSubmit: (description, price, category, location, imageUrl, availableFrom, availableUntil) async {
                  try {
                    return (true, "");
                  } catch (e) {
                    return (false, "An error occurred. Please try again later.\n$e");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}