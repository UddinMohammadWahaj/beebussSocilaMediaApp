import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/view/expanded_video_page.dart';
import 'package:bizbultest/widgets/discover_video_player.dart';
import 'package:bizbultest/widgets/discover_video_player_bigvideo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

import 'MainVideoWidgets/video_bottom_tile.dart';

class VideoCard extends StatelessWidget {
  final VideoListModelData? video;
  final int? index;
  final VoidCallback? onPress;

  VideoCard({Key? key, this.video, this.index, this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.grey.shade800,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            context: context,
            builder: (BuildContext bc) {
              return VideoBottomTile(
                onPress: onPress!,
                video: video!,
                index: index!,
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: 1.0.w, bottom: 2.5.h, right: 1.0.w, top: 1.0.w),
        child: Column(
          children: [VideoImageCard(image: video!.image, video: video!.video)],
        ),
      ),
    );
  }
}

class VideoImageCard extends StatelessWidget {
  final String? image;
  String? video;
  VideoImageCard({Key? key, this.image, this.video = ""}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 25.0.w,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                //  DiscoverVideoPlayerBigVideo(
                //   image: image,
                //   url: video,
                // )

                Image(
              image: CachedNetworkImageProvider(image!),
              fit: BoxFit.cover,
              height: 20.0.h,
            )),
      ),
    );
  }
}
