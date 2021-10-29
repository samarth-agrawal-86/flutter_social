import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/widgets/progress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot>? searchResultsFuture;
  TextEditingController searchController = TextEditingController();

  buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search for a User...',
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                searchController.clear();
              });
            },
            icon: Icon(
              Icons.clear,
              color: Colors.grey,
            ),
          ),
        ),
        onFieldSubmitted: (String query) {
          Future<QuerySnapshot> searchUsers = usersCollection
              .where('display_name',
                  isGreaterThanOrEqualTo: searchController.text)
              .get();
          setState(() {
            searchResultsFuture = searchUsers;
          });
        },
      ),
    );
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          // Imp because when keyboard opens up to remove the overflow error
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300 : 200,
            ),
            const Text(
              'Find Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60),
            )
          ],
        ),
      ),
    );
  }

  buildSearchedResult() {
    return FutureBuilder<QuerySnapshot>(
        future: searchResultsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgress();
          }

          var userStream = snapshot.data!.docs
              .map((DocumentSnapshot doc) => User.fromDocument(doc));

          var userStreamList = userStream.toList();

          //print('Search - $userStreamList');
          return ListView.builder(
            itemCount: userStreamList.length,
            itemBuilder: (context, int index) {
              return InkWell(
                onTap: () => print('tapped'),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              NetworkImage(userStreamList[index].photoUrl)),
                      title: Text(userStreamList[index].displayName),
                      subtitle: Text(userStreamList[index].username),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body: searchResultsFuture == null
          ? buildNoContent()
          : buildSearchedResult(),
    );
  }
}
