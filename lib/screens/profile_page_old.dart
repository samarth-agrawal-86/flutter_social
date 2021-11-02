// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/screens/home_page.dart';
import 'package:flutter_social/widgets/cached_network_image.dart';
import 'package:flutter_social/widgets/header.dart';
import 'package:flutter_social/widgets/profile_widget.dart';
import 'package:flutter_social/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart' as cni;
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final User? currentUser;
  ProfilePage({Key? key, this.currentUser}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserID = currentUser!.id;
  bool isLoading = false;
  int postsCount = 0;
  String postOrientation = 'grid';
  bool? isLiked;

  handleLikePost() {}
  buildPostsLayout() {
    return StreamBuilder<QuerySnapshot>(
      stream: postsCollection
          .doc(currentUserID)
          .collection('usersPosts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgress();
        }
        // snapshot.data!.docs;

        else if (snapshot.data == null) {
          return Container();
        } else if (postOrientation == 'grid') {
          var postStream = snapshot.data!.docs
              .map((DocumentSnapshot doc) => Post.fromDocument(doc));

          var postList = postStream.toList();
          //print(postList[1].getLikesCount(postList[2].likes));
          postsCount = postList.length;
          return Expanded(
              child: GridView.builder(
                  itemCount: postList.length,
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GridTile(
                      child: CachedNetworkImageFn(
                        postUrl: postList[index].postUrl,
                      ),
                    );
                  }));
        } else if (postOrientation == 'list') {
          var postStream = snapshot.data!.docs
              .map((DocumentSnapshot doc) => Post.fromDocument(doc));

          var postList = postStream.toList();
          //print(postList[1].getLikesCount(postList[2].likes));
          postsCount = postList.length;
          return Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(currentUser!.photoUrl),
                          backgroundColor: Colors.grey,
                        ),
                        // TODO: add gesture detector here so that we can show profile later
                        title: Text(currentUser!.displayName),
                        subtitle: Text(postList[index].location.toString()),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert),
                        ),
                      ),
                      // TODO: add clickable feature on the image as well
                      Container(
                        height: 300,
                        child: Center(
                          child: CachedNetworkImageFn(
                            postUrl: postList[index].postUrl,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              bool _isLiked =
                                  postList[index].likes![currentUserID] == true;

                              if (_isLiked == false) {
                                postsCollection
                                    .doc(currentUserID)
                                    .collection('userPosts')
                                    .doc(postList[index].postId)
                                    .update({'likes.$currentUserID': true});
                                setState(() {
                                  isLiked = true;
                                  postList[index].likes![currentUserID] == true;
                                });
                              }

                              if (_isLiked == true) {
                                postsCollection
                                    .doc(currentUserID)
                                    .collection('userPosts')
                                    .doc(postList[index].postId)
                                    .update({'likes.$currentUserID': false});

                                setState(() {
                                  isLiked = false;
                                  postList[index].likes![currentUserID] ==
                                      false;
                                });
                              }
                            },
                            icon: Icon(
                              isLiked == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 28,
                              color: Colors.pink,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.comment_rounded,
                                size: 28, color: Colors.blue.shade900),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                            '${postList[index].getLikesCount(postList[index].likes)} likes',
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('${postList[index].username} comments',
                            textAlign: TextAlign.left),
                      ),
                    ],
                  );
                }),
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context: context, titleText: 'Profile', isAppTitle: false),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: usersCollection.doc(widget.currentUser!.id).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgress();
              }
              currentUser = User.fromDocument(snapshot.data!);
              //print(currentUser);
              return Container(
                height: 230,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.orange,
                            backgroundImage:
                                NetworkImage(currentUser!.photoUrl),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfileCountsWidget(
                                      widgetText: 'posts', count: postsCount),
                                  buildProfileCountsWidget(
                                    widgetText: 'followers',
                                    count: 0,
                                  ),
                                  buildProfileCountsWidget(
                                      widgetText: 'following', count: 0),
                                ],
                              ),
                              // if user is viewing its own profile then edit profile else follow
                              widget.currentUser!.id == currentUserID
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfilePage(
                                                        currentUserId:
                                                            currentUserID)));
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: Container(
                                        width: 250,
                                        height: 14,
                                        child: Text(
                                          'Edit Profile',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                  : Text('Follow'),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 14),
                      child: Text(
                        currentUser!.username,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        currentUser!.displayName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 4),
                      child: Text(currentUser!.bio.toString()),
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      postOrientation = 'grid';
                    });
                  },
                  icon: Icon(
                    Icons.grid_on,
                    color:
                        postOrientation == 'grid' ? Colors.purple : Colors.grey,
                  )),
              IconButton(
                onPressed: () {
                  setState(() {
                    postOrientation = 'list';
                  });
                },
                icon: Icon(
                  Icons.list,
                  color:
                      postOrientation == 'list' ? Colors.purple : Colors.grey,
                ),
              ),
            ],
          ),
          buildPostsLayout(),
        ],
      ),
    );
  }
}
