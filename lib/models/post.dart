// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart' as fb_firestore;
import 'package:cached_network_image/cached_network_image.dart' as cni;

import 'package:flutter/material.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/screens/home_page.dart';
import 'package:flutter_social/widgets/cached_network_image.dart';
import 'package:flutter_social/widgets/progress.dart';

// Here's the benefit of including a model along with the widget.
// We can add methods to this before we pass the results to our state class
// to be displayed within our build function

class Post extends StatefulWidget {
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

  factory Post.fromDocument(fb_firestore.DocumentSnapshot doc) {
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

  @override
  _PostState createState() => _PostState(
        postId: postId,
        postUrl: postUrl,
        description: description,
        ownerId: ownerId,
        username: username,
        location: location,
        likes: likes,
        timestamp: timestamp,
        likesCount: getLikesCount(likes),
      );
}

class _PostState extends State<Post> {
  final String? postId;
  final String? postUrl;
  final String? description;
  final String? ownerId;
  final String? username;
  final String? location;
  final Map? likes;
  final DateTime? timestamp;
  final int? likesCount;

  _PostState({
    this.postId,
    this.postUrl,
    this.description,
    this.ownerId,
    this.username,
    this.location,
    this.likes,
    this.timestamp,
    this.likesCount,
  });
  bool _isLiked = false;

  buildPostHeader() {
    return FutureBuilder<fb_firestore.DocumentSnapshot>(
        future: usersCollection.doc(ownerId!).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgress();
          } else {
            User user = User.fromDocument(snapshot.data!);
            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: cni.CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                '${user.username}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(location!),
              trailing:
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            );
          }
        });
  }

  buildPostImage() {
    return Center(
      child: Container(
        child: CachedNetworkImageFn(postUrl: postUrl!),
        height: 250,
      ),
    );
  }

  buildPostFooter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
                size: 28,
                color: Colors.pink,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.comment_rounded,
                  size: 28, color: Colors.blue.shade900),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text('$likesCount likes', textAlign: TextAlign.left),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text('0 comments', textAlign: TextAlign.left),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}
