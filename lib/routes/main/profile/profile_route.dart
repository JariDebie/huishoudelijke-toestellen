import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/types/user.dart';
import 'package:flutter_application_1/types/appliance.dart';
import 'package:flutter_application_1/types/booking.dart';
import 'package:intl/intl.dart';

class ProfileRoute extends StatefulWidget {
  final User user;

  const ProfileRoute({super.key, required this.user});

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final bookingSnapshot =
        await FirebaseFirestore.instance
            .collection('bookings')
            .where('renterId', isEqualTo: widget.user.id)
            .get();

    if (bookingSnapshot.docs.isEmpty) return [];

    List<Map<String, dynamic>> bookings = [];
    for (var bookingDoc in bookingSnapshot.docs) {
      final booking = Booking.fromFirestore(
        bookingDoc as DocumentSnapshot<Map<String, dynamic>>,
        null,
      );

      final applianceSnapshot =
          await FirebaseFirestore.instance
              .collection('appliances')
              .doc(booking.applianceId)
              .get();

      if (!applianceSnapshot.exists) continue;

      final appliance = Appliance.fromFirestore(applianceSnapshot, null);

      final authorSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(appliance.authorId)
              .get();

      final authorData = authorSnapshot.data();
      final author = User(
        id: authorSnapshot.id,
        displayName: authorData?['display_name'] ?? 'Unknown',
        email: authorData?['email'] ?? '',
        password: '',
        username: authorData?['username'] ?? '',
      );

      bookings.add({
        'booking': booking,
        'appliance': appliance,
        'author': author,
      });
    }

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Profile")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Bookings", style: const TextStyle(fontSize: 18)),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchBookings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading bookings"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No bookings found"));
                  }

                  final bookings = snapshot.data!;
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final bookingData = bookings[index];
                      final booking = bookingData['booking'] as Booking;
                      final appliance = bookingData['appliance'] as Appliance;
                      final author = bookingData['author'] as User;

                      return Card(
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
                                      appliance.description,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    "From: ${DateFormat('dd/MM/yyyy').format(booking.reservedFromDate)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "Category: ${appliance.category.name}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "To: ${DateFormat('dd/MM/yyyy').format(booking.reservedToDate)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Author: ${author.displayName}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
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
