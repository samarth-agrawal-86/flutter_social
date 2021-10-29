import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/widgets/header.dart';
import 'package:flutter_social/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
          context: context, titleText: 'FlutterSocial', isAppTitle: true),
      body: Center(child: Text('Timeline Page')),
    );
  }
}
//Center(child: Text('Timeline Page')),
//StreamBuilder<QuerySnapshot>(
//           stream: usersCollection.snapshots(), // This gives stream of data
//           builder: (context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return CircularProgress();
//             } else {
//               List childrenList =
//                   snapshot.data!.docs.map((user) => user['user_name']).toList();
//
//               List<Text> children = [];
//               for (var u in childrenList) {
//                 children.add(Text(u));
//               }
//               return ListView(
//                 children: children,
//               );
//             }
//           }),
