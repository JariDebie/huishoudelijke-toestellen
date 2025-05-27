import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/types/appliance.dart';

class ApplianceDetailRoute extends StatefulWidget {
  final Appliance appliance;

  const ApplianceDetailRoute({Key? key, required this.appliance})
    : super(key: key);

  @override
  _ApplianceDetailRouteState createState() => _ApplianceDetailRouteState();
}

class _ApplianceDetailRouteState extends State<ApplianceDetailRoute> {
  late Future<List<BookingWithRenter>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = _fetchBookingsWithRenters();
  }

  Future<List<BookingWithRenter>> _fetchBookingsWithRenters() async {
    final bookingsSnapshot =
        await FirebaseFirestore.instance
            .collection('bookings')
            .where('applianceId', isEqualTo: widget.appliance.id)
            .get();

    if (bookingsSnapshot.docs.isEmpty) return [];

    List<BookingWithRenter> bookingsWithRenters = [];

    for (var doc in bookingsSnapshot.docs) {
      final data = doc.data();
      final renterId = data['renterId'] as String;

      // Haal renter data op
      final renterDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(renterId)
              .get();
      final renterData = renterDoc.data();

      if (renterData == null) continue;

      bookingsWithRenters.add(
        BookingWithRenter(
          reservedFromDate: (data['reservedFromDate'] as Timestamp).toDate(),
          reservedToDate: (data['reservedToDate'] as Timestamp).toDate(),
          renterName: renterData['username'] ?? 'Unknown',
          renterEmail: renterData['email'] ?? 'Unknown',
        ),
      );
    }

    return bookingsWithRenters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appliance.description)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info + afbeelding in een rij
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Category: ${widget.appliance.category.name}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Price: \$${widget.appliance.price.toStringAsFixed(2)}",
                      ),
                      Text(
                        "Available from: ${DateFormat('dd/MM/yyyy').format(widget.appliance.availableFrom)}",
                      ),
                      Text(
                        "Available until: ${DateFormat('dd/MM/yyyy').format(widget.appliance.availableUntil)}",
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.appliance.imageUrl,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              "Bookings:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<BookingWithRenter>>(
                future: _futureBookings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No bookings found"));
                  }

                  final bookings = snapshot.data!;
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Links: naam en e-mail
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Renter Name: ${booking.renterName}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "Renter Email: ${booking.renterEmail}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Rechts: datums
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "From: ${DateFormat('dd/MM/yyyy').format(booking.reservedFromDate)}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "To: ${DateFormat('dd/MM/yyyy').format(booking.reservedToDate)}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

class BookingWithRenter {
  final DateTime reservedFromDate;
  final DateTime reservedToDate;
  final String renterName;
  final String renterEmail;

  BookingWithRenter({
    required this.reservedFromDate,
    required this.reservedToDate,
    required this.renterName,
    required this.renterEmail,
  });
}
