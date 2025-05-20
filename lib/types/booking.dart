import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String applianceId;
  final String renterId;
  final DateTime reservedFromDate;
  final DateTime reservedToDate;

  const Booking({
    required this.applianceId,
    required this.renterId,
    required this.reservedFromDate,
    required this.reservedToDate,
  });

  factory Booking.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? opt,
  ) {
    final data = doc.data()!;
    return Booking(
      applianceId: data['applianceId'] ?? '',
      renterId: data['renterId'] ?? '',
      reservedFromDate: (data['reservedFromDate'] as Timestamp).toDate(),
      reservedToDate: (data['reservedToDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'applianceId': applianceId,
      'renterId': renterId,
      'reservedFromDate': reservedFromDate,
      'reservedToDate': reservedToDate,
    };
  }
}
