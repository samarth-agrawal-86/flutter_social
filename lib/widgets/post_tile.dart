import 'package:flutter/material.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/widgets/cached_network_image.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => print('Showing post'),
        child: CachedNetworkImageFn(postUrl: post.postUrl));
  }
}
