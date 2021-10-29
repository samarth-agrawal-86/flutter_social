import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String postUrl;
  final String description;
  final String ownerId;
  final String username;
  final String location;
  final Map? likes;
  final DateTime timestamp;

  Post(
      {required this.postId,
      required this.postUrl,
      required this.description,
      required this.ownerId,
      required this.username,
      required this.location,
      required this.likes,
      required this.timestamp});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
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

  int getLikesCount(Map? likes) {
    int count = 0;

    if (likes == null) {
      count = 0;
    }

    for (var val in likes!.values) {
      if (val == true) {
        count = count + 1;
      }
    }
    return count;
  }
}
