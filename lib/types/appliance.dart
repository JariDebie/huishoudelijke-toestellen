import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/types/category.dart';
import 'package:flutter_application_1/types/user.dart';
import 'package:latlong2/latlong.dart';

class Appliance {
  final String authorId;
  User? _author;
  final String description;
  final ApplianceCategory category;
  final String imageUrl;
  final double price;
  final LatLng location;
  final DateTime availableFrom;
  final DateTime availableUntil;

  Appliance({
    required this.description,
    required this.authorId,
    required this.category,
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

  factory Appliance.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? opt) {
    final data = doc.data()!;
    final GeoPoint geoPoint = data['location'];
    
    return Appliance(
      description: data['description'],
      authorId: data['authorId'],
      category: ApplianceCategory.values.firstWhere(
        (c) => c.name == data['category']
      ),
      imageUrl: data['imageUrl'],
      price: (data['price'] as num).toDouble(),
      location: LatLng(geoPoint.latitude, geoPoint.longitude),
      availableFrom: (data['availableFrom'] as Timestamp).toDate(),
      availableUntil: (data['availableUntil'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'authorId': authorId,
      'category': category.name,
      'imageUrl': imageUrl,
      'price': price,
      'location': GeoPoint(location.latitude, location.longitude),
      'availableFrom': Timestamp.fromDate(availableFrom),
      'availableUntil': Timestamp.fromDate(availableUntil),
    };
  }
}