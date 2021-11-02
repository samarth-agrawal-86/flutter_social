// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' as cni;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/widgets/cached_network_image.dart';
import 'package:flutter_social/widgets/progress.dart';

import 'home_page.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserId;

  const EditProfilePage({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  bool isLoading = false;
  User? user;
  bool _displayNameValid = true;
  bool _bioValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc =
        await usersCollection.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    _displayNameController.text = user!.displayName;
    _bioController.text = user!.bio as String;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.done, size: 30, color: Colors.green))
        ],
      ),
      body: isLoading
          ? CircularProgress()
          : ListView(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.orange,
                        backgroundImage:
                            cni.CachedNetworkImageProvider(user!.photoUrl),
                      ),
                      SizedBox(height: 24),
                      TextField(
                        controller: _displayNameController,
                        decoration: InputDecoration(
                          labelText: 'Display Name',
                          hintText: 'John Doe',
                          errorText: _displayNameValid
                              ? null
                              : 'Display name too short',
                        ),
                      ),
                      SizedBox(height: 14),
                      TextField(
                        controller: _bioController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          hintText: 'Live, Love & Laugh',
                          errorText: _bioValid ? null : 'Bio too long',
                        ),
                      ),
                      SizedBox(height: 14),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _displayNameController.text.trim().length < 3 ||
                                    _displayNameController.text.isEmpty
                                ? _displayNameValid = false
                                : _displayNameValid = true;

                            _bioController.text.trim().length > 100 ||
                                    _bioController.text.isEmpty
                                ? _bioValid = false
                                : _bioValid = true;
                          });

                          if (_displayNameValid && _bioValid) {
                            Map<String, Object> data = {
                              'display_name': _displayNameController.text,
                              'bio': _bioController.text
                            };
                            usersCollection.doc(user!.id).update(data);
                            final snackBar =
                                SnackBar(content: Text("Profile updated"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            //Timer(Duration(seconds: 1), () {Navigator.pop(context);});
                          }
                        },
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 24),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          primary: Colors.red,
                        ),
                        icon: Icon(Icons.cancel_rounded),
                        onPressed: () {
                          googleSignIn.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        label: Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
