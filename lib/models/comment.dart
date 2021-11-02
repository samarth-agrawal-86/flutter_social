import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String postId;
  final String postUrl;
  final String description;
  final String ownerId;
  final String username;
  final String location;
  final Map? likes;
  final DateTime timestamp;

  Comment(
      {required this.postId,
      required this.postUrl,
      required this.description,
      required this.ownerId,
      required this.username,
      required this.location,
      required this.likes,
      required this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      postId: doc.get('postId'),
      postUrl: doc.get('postUrl'),
      description: doc.get('description'),
      ownerId: doc.get('ownerId'),
      username: doc.get('username'),
      location: doc.get('location'),
      likes: doc.get('likes'),
      timestamp: doc.get('timestamp').toDate(),
    );
  }
}
