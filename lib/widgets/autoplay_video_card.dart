import 'package:bizbultest/models/autoplay_video_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/expanded_video_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class AutoPlayVideoCard extends StatefulWidget {
  final AutoPlayVideoModel? video;
  final VoidCallback? changeVideo;

  AutoPlayVideoCard({Key? key, this.video, this.changeVideo}) : super(key: key);

  @override
  _AutoPlayVideoCardState createState() => _AutoPlayVideoCardState();
}

class _AutoPlayVideoCardState extends State<AutoPlayVideoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.changeVideo ?? () {},

      /*     onTap: () {
        pushNewScreen(
          context,
          screen: ExpandedVideoPage(
            videoURL: widget.video.videoUrl,
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );

      },*/
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.5.h),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    child: Image.network(
                      widget.video!.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.5.h),
                child: Text(
                  widget.video!.postContent!,
                  style: whiteBold.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Text(
                widget.video!.name!,
                style: whiteNormal.copyWith(fontSize: 10.0.sp),
              ),
              Row(
                children: [
                  Text(
                    widget.video!.numViews!,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.0.w),
                    child: Text(
                      widget.video!.timeStamp!,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
