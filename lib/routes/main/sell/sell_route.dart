import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/main/sell/sell_form_route.dart';
import 'package:flutter_application_1/types/user.dart';

class SellRoute extends StatelessWidget {
  final User user;

  const SellRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sell Appliance")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            const Text("Manage your currently available appliances here"),
            const Divider(height: 8, thickness: 1),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SellFormRoute(user: user)));
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
                child: const Text("Offer New Appliance For Sale"),
              ),
            )
          ]
        ),
      ),
    );
  }
}