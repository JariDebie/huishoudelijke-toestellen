import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/sell_form.dart';

class SellFormRoute extends StatelessWidget {
  const SellFormRoute({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Details of New Appliance")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            SellForm(
              onSubmit: (description, price, category , imageUrl, availableFrom, availableUntil) async {
                return (false, "Not implemented yet");
              },
            )
          ],
        )
      ),
    );
  }
}