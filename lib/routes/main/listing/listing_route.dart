// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/main/listing/listing_details_route.dart';
import 'package:flutter_application_1/routes/main/listing/listing_map_route.dart';
import 'package:flutter_application_1/types/category.dart';
import 'package:flutter_application_1/types/user.dart';
// Import your enum

class MainListingRoute extends StatefulWidget {
  final User user;

  const MainListingRoute({super.key, required this.user});

  @override
  State<MainListingRoute> createState() => _MainListingRouteState();
}

class _MainListingRouteState extends State<MainListingRoute> {
  ApplianceCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${widget.user.displayName}!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("Some additional information here."),
            const Divider(height: 8, thickness: 1),
            const Text("Filter by category:"),
            DropdownButton<ApplianceCategory>(
              value: selectedCategory,
              hint: const Text("Select category"),
              items: [
                const DropdownMenuItem<ApplianceCategory>(
                  value: null,
                  child: Text("All"),
                ),
                ...ApplianceCategory.entries.map(
                  (entry) => DropdownMenuItem(
                    value: entry.value,
                    child: Text(entry.label),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ListingMapRoute(category: selectedCategory),
                    ),
                  );
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.indigo),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
                child: const Text("View Listings on Map"),
              ),
            ),
            const SizedBox(height: 8),
            // Appliance List
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('appliances')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  final filteredDocs =
                      selectedCategory == null
                          ? docs
                          : docs.where((doc) {
                            final data = doc.data();
                            return data['category'] == selectedCategory!.name;
                          }).toList();
                  if (filteredDocs.isEmpty) {
                    return const Center(child: Text("No appliances found."));
                  }
                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final data = filteredDocs[index].data();
                      final authorId = data['authorId'];
                      final price = data['price'];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          String authorName = 'Unknown author';
                          if (authorId != null) {
                            final userSnap =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(authorId)
                                    .get();
                            final userData = userSnap.data();
                            authorName =
                                userData?['display_name'] ?? 'Unknown author';
                          }
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ListingDetailsRoute(
                                    imageUrl: data['imageUrl'],
                                    description: data['description'],
                                    price: price,
                                    author: authorName,
                                    category: data['category'],
                                  ),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xF9F6F6FF),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['description'] ??
                                            'Unnamed Appliance',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Text(
                                      '€${(price ?? 0).toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      data['category'] ?? 'No category',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      "Click for more",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
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
