import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String displayName;
  final String email;
  final String password;
  final String username;
  String? id;

  User({
    required this.displayName,
    required this.email,
    required this.password,
    required this.username,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? opt) {
    final data = doc.data()!;
    return User(
      displayName: data['display_name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      username: data['username'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'display_name': displayName,
      'email': email,
      'password': password,
      'username': username,
    };
  }
}