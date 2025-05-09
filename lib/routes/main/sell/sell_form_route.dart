import 'package:flutter/material.dart';

class SellFormRoute extends StatelessWidget {
  const SellFormRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details of New Appliance")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            const Text("Enter the details of the appliance you want to sell"),
            const Divider(height: 8, thickness: 1),
            const TextField(
              decoration: InputDecoration(
                labelText: "Appliance Name",
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: "Price",
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: "Condition",
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // Handle form submission
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}