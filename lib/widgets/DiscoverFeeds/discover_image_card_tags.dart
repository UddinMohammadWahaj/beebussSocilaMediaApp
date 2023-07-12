import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DiscoverTagsImageCard extends StatelessWidget {
  final VoidCallback? onPress;
  final NewsFeedModel? feed;

  const DiscoverTagsImageCard({Key? key, this.onPress, this.feed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("hashtag aah enter bia");
    print("hashtag aah image=${feed!.postImgData}");
    return GestureDetector(
      onTap: onPress ?? () {},
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              child: Image(
                  image: CachedNetworkImageProvider(
                      feed!.postsmlImgData!.split("~~")[0]),
                  fit: BoxFit.cover),
            ),
          ),
          feed!.postMultiImage == 1
              ? Positioned.fill(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.0, right: 3),
                        child: Image.asset(
                          "assets/images/multiple.png",
                          height: 1.0.h,
                        ),
                      )),
                )
              : Container(),
          /*  Positioned.fill(
            child: Align(
                alignment: Alignment.topRight,
                child: Text(feed.postId,style: TextStyle(color: Colors.yellowAccent),)),
          ),*/
        ],
      ),
    );
  }
}
