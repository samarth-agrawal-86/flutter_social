// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' as cni;

class CachedNetworkImageFn extends StatelessWidget {
  final String postUrl;
  const CachedNetworkImageFn({required this.postUrl});

  @override
  Widget build(BuildContext context) {
    return cni.CachedNetworkImage(
      imageUrl: postUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.black38),
      errorWidget: (context, url, error) =>
          Icon(Icons.error, color: Colors.red),
    );
  }
}
