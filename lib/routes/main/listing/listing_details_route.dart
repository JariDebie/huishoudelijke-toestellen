import 'package:flutter/material.dart';

class ListingDetailsRoute extends StatelessWidget {
  final String? imageUrl;
  final String? description;
  final double? price;
  final String? author;
  final String? category;

  const ListingDetailsRoute({
    super.key,
    this.imageUrl,
    this.description,
    this.price,
    this.author,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appliance Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
              ),
            const SizedBox(height: 16),
            Text(
              description ?? 'No description',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Price: €${(price ?? 0).toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Author: ${author ?? "Unknown"}'),
            const SizedBox(height: 8),
            Text('Category: ${category ?? "Unknown"}'),
          ],
        ),
      ),
    );
  }
}
