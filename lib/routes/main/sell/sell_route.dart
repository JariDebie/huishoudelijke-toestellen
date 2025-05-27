import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/main/sell/ApplianceDetailRoute.dart';
import 'package:flutter_application_1/routes/main/sell/sell_form_route.dart';
import 'package:flutter_application_1/types/appliance.dart';
import 'package:flutter_application_1/types/user.dart';
import 'package:intl/intl.dart';

class SellRoute extends StatelessWidget {
  final User user;

  const SellRoute({super.key, required this.user});

  Future<List<Appliance>> _fetchListings() async {
    final applianceSnapshot =
        await FirebaseFirestore.instance
            .collection('appliances')
            .where('authorId', isEqualTo: user.id)
            .get();

    if (applianceSnapshot.docs.isEmpty) return [];

    return applianceSnapshot.docs
        .map(
          (doc) => Appliance.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>,
            null,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sell Appliance")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Manage your currently available appliances here"),
            const Divider(height: 8, thickness: 1),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellFormRoute(user: user),
                    ),
                  );
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
                child: const Text("Offer New Appliance For Sale"),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Appliance>>(
                future: _fetchListings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading listings"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No listings found"));
                  }

                  final listings = snapshot.data!;
                  return ListView.builder(
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final appliance = listings[index];
                      return Card(
                        color: const Color(0xF9F6F6FF),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ApplianceDetailRoute(
                                      appliance: appliance,
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ... jouw bestaande content van het Card-item ...
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appliance.description,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Category: ${appliance.category.name}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Price: \$${appliance.price.toStringAsFixed(2)}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "From: ${DateFormat('dd/MM/yyyy').format(appliance.availableFrom)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        "To: ${DateFormat('dd/MM/yyyy').format(appliance.availableUntil)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
