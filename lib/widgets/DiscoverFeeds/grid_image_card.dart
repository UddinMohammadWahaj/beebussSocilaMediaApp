import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class GridImageCard extends StatelessWidget {
  final NewsFeedModel? post;

  const GridImageCard({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        post!.postImgData!,
        fit: BoxFit.cover,
      ),
    );
  }
}
