import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/types/user.dart';
import 'package:latlong2/latlong.dart';

class Appliance {
  final String authorId;
  User? _author;
  final String description;
  final String imageUrl;
  final double price;
  final LatLng location;
  final DateTime availableFrom;
  final DateTime availableUntil;

  Appliance({
    required this.description,
    required this.authorId,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.availableFrom,
    required this.availableUntil
  });

  Future<User?> getAuthor() async {
    if (_author != null) return _author;
    try {
      CollectionReference users = FirebaseFirestore.instance
          .collection("users")
          .withConverter<User>(
            fromFirestore: User.fromFirestore,
            toFirestore: (User u, _) => u.toFirestore()
          );
      DocumentSnapshot userDoc = await users.doc(authorId).get();

      if (userDoc.exists) {
        User user = userDoc.data() as User;
        _author = user;
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}