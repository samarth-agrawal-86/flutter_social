// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print
import 'package:flutter/material.dart';

import 'dart:io' as io;
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:image_picker/image_picker.dart' as img_picker;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image/image.dart' as im;
import 'package:uuid/uuid.dart' as uuid;

import 'package:flutter_social/screens/home_page.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/widgets/progress.dart';

class UploadPage extends StatefulWidget {
  final User? currentUser;
  UploadPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  io.File? postFile;
  bool isUploading = false;
  final picker = img_picker.ImagePicker();
  String postId = uuid.Uuid().v4();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  handleTakePicture() async {
    Navigator.pop(context);
    var image = await picker.pickImage(
      source: img_picker.ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );

    setState(() {
      postFile = io.File(image!.path);
    });
  }

  handleUploadPicture() async {
    Navigator.pop(context);
    var image = await picker.pickImage(
      source: img_picker.ImageSource.gallery,
    );
    if (image == null) {
      return CircularProgress();
    } else {
      setState(() {
        postFile = io.File(image.path);
      });
    }
  }

  handleSubmit() async {
    // set this for a) showing progress bar and b) disable 'post' button
    setState(() {
      isUploading = true;
    });

    // compress image
    final tempDir = await path_provider.getTemporaryDirectory();
    final path = tempDir.path;

    im.Image? imageFile = im.decodeImage(postFile!.readAsBytesSync());

    final compressedImageFile = io.File('$path/img_$postId.jpg')
      ..writeAsBytesSync(im.encodeJpg(imageFile!, quality: 85));

    setState(() {
      postFile = compressedImageFile;
    });

    // upload image in firebase storage
    String postUrl = await storageRef
        .child("post_$postId.jpg")
        .putFile(postFile!)
        .then((taskSnapshot) {
      return taskSnapshot.ref.getDownloadURL();
    });

    //print(postUrl);

    // create post in firestore
    postsCollection
        .doc(widget.currentUser!.id)
        .collection('usersPosts')
        .doc(postId)
        .set({
      'postId': postId,
      'ownerId': widget.currentUser!.id,
      'username': widget.currentUser!.username,
      'postUrl': postUrl,
      'description': captionController.text,
      'location': locationController.text,
      'timestamp': timestampVar,
      'likes': {},
    });
// clear off all the text controllers and initialized variables
    captionController.clear();
    locationController.clear();
    setState(() {
      postFile = null;
      isUploading = false;
      postId = uuid.Uuid().v4();
    });
  }

  buildSplash() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          svg.SvgPicture.asset(
            "assets/images/upload.svg",
            height: 260,
          ),
          SizedBox(height: 40),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              primary: Colors.white,
              elevation: 4,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text('Create post'),
                      children: [
                        SimpleDialogOption(
                          onPressed: handleTakePicture,
                          child: Text('Take a picture'),
                        ),
                        SimpleDialogOption(
                          onPressed: handleUploadPicture,
                          child: Text('Upload from Gallery'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  });
            },
            child: const Text(
              'Upload Image',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  buildUpload() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            setState(() {
              postFile = null;
            });
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Caption Post',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              'Post',
              style: TextStyle(
                  color: isUploading ? Colors.grey : Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          isUploading ? LinearProgress() : Text(''),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
                child: AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(postFile!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            //margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(widget.currentUser!.photoUrl),
              ),
              title: Container(
                width: 250,
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: 'Write a caption',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            //margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: ListTile(
              leading: Icon(
                Icons.pin_drop,
                color: Colors.orange,
                size: 35.0,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                      hintText: 'Enter your location',
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
          Container(
            width: 170,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: TextButton.icon(
              onPressed: () async {
                geoloc.Position position =
                    await geoloc.Geolocator.getCurrentPosition(
                        desiredAccuracy: geoloc.LocationAccuracy.high);

                List<geocoding.Placemark> placemarks =
                    await geocoding.placemarkFromCoordinates(
                        position.latitude, position.longitude);
                geocoding.Placemark placemark = placemarks[0];
                print('Placemarks');
                print('------------');
                print(placemarks);
                print('Placemark');
                print('------------');
                print(placemark);

                String formattedAddress =
                    '${placemark.locality}, ${placemark.country}';

                locationController.text = formattedAddress;
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              icon: Icon(Icons.my_location),
              label: Text(
                'Use current location',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return postFile == null ? buildSplash() : buildUpload();
  }
}
