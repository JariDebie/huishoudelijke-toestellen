// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/types/appliance.dart';
import 'package:flutter_application_1/types/booking.dart';
import 'package:flutter_application_1/types/user.dart';

class ListingBookingRoute extends StatefulWidget {
  final Appliance appliance;
  final User currentUser;

  const ListingBookingRoute({
    super.key,
    required this.appliance,
    required this.currentUser,
  });

  @override
  State<ListingBookingRoute> createState() => _ListingBookingRouteState();
}

class _ListingBookingRouteState extends State<ListingBookingRoute> {
  DateTime? reservedFrom;
  DateTime? reservedTo;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final appliance = widget.appliance;

    return Scaffold(
      appBar: AppBar(title: const Text("Book Appliance")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (appliance.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  appliance.imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 16),
            Text(appliance.description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Price: €${appliance.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Category: ${appliance.category.name}'),
            const SizedBox(height: 8),
            Text(
              'Available: ${appliance.availableFrom.day}/${appliance.availableFrom.month}/${appliance.availableFrom.year} '
              'to ${appliance.availableUntil.day}/${appliance.availableUntil.month}/${appliance.availableUntil.year}',
            ),
            const Divider(height: 32),
            const Text(
              "Select rental period:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: reservedFrom ?? appliance.availableFrom,
                        firstDate: appliance.availableFrom,
                        lastDate: appliance.availableUntil,
                      );
                      if (picked != null) {
                        setState(() {
                          reservedFrom = picked;
                          // If reservedTo is before reservedFrom, reset it
                          if (reservedTo != null &&
                              reservedTo!.isBefore(picked)) {
                            reservedTo = null;
                          }
                        });
                      }
                    },
                    child: Text(
                      reservedFrom == null
                          ? "Start date"
                          : "${reservedFrom!.day}/${reservedFrom!.month}/${reservedFrom!.year}",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        reservedFrom == null
                            ? null
                            : () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: reservedTo ?? reservedFrom!,
                                firstDate: reservedFrom!,
                                lastDate: appliance.availableUntil,
                              );
                              if (picked != null) {
                                setState(() {
                                  reservedTo = picked;
                                });
                              }
                            },
                    child: Text(
                      reservedTo == null
                          ? "End date"
                          : "${reservedTo!.day}/${reservedTo!.month}/${reservedTo!.year}",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    (reservedFrom != null && reservedTo != null && !isLoading)
                        ? () async {
                          setState(() => isLoading = true);
                          // Save booking to Firestore
                          final booking = Booking(
                            applianceId: appliance.id!,
                            renterId: widget.currentUser.id!,
                            reservedFromDate: reservedFrom!,
                            reservedToDate: reservedTo!,
                          );
                          await booking.save();
                          setState(() => isLoading = false);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Booking successful!'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                        : null,
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Book"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
