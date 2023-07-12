import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'detailed_video_view.dart';

class DetailedImageView extends GetView<ProperbuzFeedController> {
  final int? index;
  final int? val;

  const DetailedImageView({
    Key? key,
    this.index,
    this.val,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          backgroundColor: Colors.black,
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
              itemCount: controller.getFeedsList(val!)[index!].images!.length,
              itemBuilder: (context, imageIndex) {
                return Container(
                  child: Image(
                    fit: BoxFit.fitWidth,
                    image: CachedNetworkImageProvider(controller
                        .getFeedsList(val!)[index!]
                        .images![imageIndex]),
                    width: 100.0.w,
                  ),
                );
              }),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        Icons.close,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    UserCard(
                      index: index!,
                      val: val!,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        Icons.close,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    UserCard(
                      index: index!,
                      val: val!,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
