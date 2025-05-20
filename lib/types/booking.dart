import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/types/appliance.dart';
import 'package:flutter_application_1/types/user.dart';

class Booking {
  final String applianceId;
  Appliance? _appliance;
  final String renterId;
  User? _renter;
  final DateTime reservedFromDate;
  final DateTime reservedToDate;
  String? id;

  Booking({
    required this.applianceId,
    required this.renterId,
    required this.reservedFromDate,
    required this.reservedToDate,
    this.id,
  });

  Future<User?> getRenter() async {
    if (_renter != null) return _renter;
    try {
      CollectionReference<User> users = FirebaseFirestore.instance
          .collection("users")
          .withConverter<User>(
            fromFirestore: User.fromFirestore,
            toFirestore: (User u, _) => u.toFirestore(),
          );
      DocumentSnapshot<User> userDoc = await users.doc(renterId).get();

      if (userDoc.exists) {
        User? user = userDoc.data();
        _renter = user;
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Appliance?> getAppliance() async {
    if (_appliance != null) return _appliance;
    try {
      CollectionReference<Appliance> appliances = FirebaseFirestore.instance
          .collection("appliances")
          .withConverter<Appliance>(
            fromFirestore: Appliance.fromFirestore,
            toFirestore: (Appliance u, _) => u.toFirestore(),
          );
      DocumentSnapshot<Appliance> applianceDoc =
          await appliances.doc(applianceId).get();

      if (applianceDoc.exists) {
        Appliance? appliance = applianceDoc.data();
        _appliance = appliance;
        return appliance;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

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
      id: doc.id,
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
