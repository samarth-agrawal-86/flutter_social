// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as fb_firestore;
import 'package:cached_network_image/cached_network_image.dart' as cni;
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/screens/edit_profile_page.dart';
import 'package:flutter_social/screens/home_page.dart';
import 'package:flutter_social/widgets/cached_network_image.dart';
import 'package:flutter_social/widgets/header.dart';
import 'package:flutter_social/widgets/profile_widget.dart';
import 'package:flutter_social/widgets/progress.dart';

class ProfilePage extends StatefulWidget {
  final String profileId;
  ProfilePage({Key? key, required this.profileId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserId = currentUser!.id;
  bool isLoading = false;
  int postsCount = 0;
  int following = 0;
  int followers = 0;
  String postOrientation = 'grid';
  bool? isLiked;

  handleLikePost() {}

  buildProfileHeader() {
    // if it is profile owner then show edit profile button else show folllow user button
    bool isProfileOwner = currentUserId == widget.profileId;

    return FutureBuilder<fb_firestore.DocumentSnapshot>(
      future: usersCollection.doc(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgress();
        } else {
          User user = User.fromDocument(snapshot.data!);
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            cni.CachedNetworkImageProvider(user.photoUrl),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildProfileCountsWidget(
                                widgetText: 'posts',
                                count: postsCount,
                              ),
                              buildProfileCountsWidget(
                                widgetText: 'followers',
                                count: followers,
                              ),
                              buildProfileCountsWidget(
                                widgetText: 'following',
                                count: following,
                              ),
                            ],
                          ),
                          isProfileOwner
                              ? TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfilePage(
                                            currentUserId: currentUserId),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    //backgroundColor: Colors.blue,
                                  ),
                                  child: Container(
                                    width: 250,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Center(
                                      child: Text(
                                        'Edit Profile',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    //backgroundColor: Colors.blue,
                                  ),
                                  child: Container(
                                    width: 250,
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Center(
                                      child: Text(
                                        'Follow',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 14),
                  child: Text(
                    user.username,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    user.displayName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4),
                  child: Text(user.bio.toString()),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context: context, titleText: 'Profile', isAppTitle: false),
      body: ListView(
        children: [
          buildProfileHeader(),
          //Divider(thickness: 1, color: Colors.grey.shade300),
          Container(height: 2, color: Colors.grey.shade200),
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
              //VerticalDivider(thickness: 2, color: Colors.grey),
              Container(
                color: Colors.grey.shade200,
                height: 50,
                width: 2,
              ),
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
          Container(height: 2, color: Colors.grey.shade200),
          //Divider(thickness: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
