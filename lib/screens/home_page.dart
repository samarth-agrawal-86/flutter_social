import 'package:cloud_firestore/cloud_firestore.dart' as fb_firestore;
import 'package:firebase_storage/firebase_storage.dart' as fb_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/screens/activity_feed_page.dart';
import 'package:flutter_social/screens/profile_page.dart';
import 'package:flutter_social/screens/search_page.dart';
import 'package:flutter_social/screens/timeline_page.dart';
import 'package:flutter_social/screens/upload_page.dart';
import 'package:flutter_social/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_account_page.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final fb_firestore.CollectionReference usersCollection =
    fb_firestore.FirebaseFirestore.instance.collection('users');
final fb_firestore.CollectionReference postsCollection =
    fb_firestore.FirebaseFirestore.instance.collection('posts');
final DateTime timestampVar = DateTime.now();
User? currentUser;
fb_storage.Reference storageRef = fb_storage.FirebaseStorage.instance.ref();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService service = FirebaseService();

  bool isAuth = false;
  PageController pageController = PageController();

  int pageIndex = 0;

  handleSignIn(GoogleSignInAccount? account) {
    if (account != null) {
      //print('User Signed in - $account.');
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1. check if user already exists in database according to id
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    fb_firestore.DocumentSnapshot doc =
        await usersCollection.doc(user!.id).get();

    // 2. if user doesn't exists then then take them to create account page
    if (!doc.exists) {
      final username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccountPage(),
        ),
      );

      // 3. get username from create account, use it to make new user document in users collection
      usersCollection.doc(user.id).set({
        'id': user.id,
        'username': username,
        'photo_url': user.photoUrl,
        'email': user.email,
        'display_name': user.displayName,
        'bio': "",
        'created_at': timestampVar
      });

      doc = await usersCollection.doc(user.id).get();
    }
    // pulling user data from firestore and deserializing it
    currentUser = User.fromDocument(doc);
    //print(currentUser);
    //print(currentUser!.username);
  }

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount? account) {
        handleSignIn(account);
      },
      onError: (err) {
        print('Error Signing in $err');
      },
    );
    // Re authenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error Signing in $err');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: [
          Timeline(),
          ActivityFeed(),
          UploadPage(currentUser: currentUser),
          SearchPage(),
          ProfilePage(profileId: currentUser!.id),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: (index) {
          pageController.jumpToPage(index);
          //pageController.animateToPage(index,duration: Duration(milliseconds: 40), curve: Curves.easeIn);
        },
        activeColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Flutter Social',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90,
                color: Colors.white,
              ),
            ),
            InkWell(
              onTap: () async {
                await service.signInwithGoogle();
              },
              child: Container(
                height: 60,
                width: 260,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
