import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? bio;
  final String displayName;
  final String id;
  final String email;
  final String photoUrl;
  final String username;
  final DateTime? createdAt;

  User(
      {required this.id,
      this.bio,
      required this.displayName,
      required this.email,
      required this.photoUrl,
      required this.username,
      this.createdAt});

  // create a method. that will be specifically for de serialization
// that will be responsible for taking a document snapshot and turning into an instance of User Class

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.get('id'),
      bio: doc.get('bio'),
      displayName: doc.get('display_name'),
      email: doc.get('email'),
      photoUrl: doc.get('photo_url'),
      username: doc.get('username'),
      createdAt: doc.get('created_at').toDate(),
    );
  }
}
