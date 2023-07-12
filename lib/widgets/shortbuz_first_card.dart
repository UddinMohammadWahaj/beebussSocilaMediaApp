import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_like_unline_post_model.dart';
import 'package:bizbultest/models/shortbuz_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/scolling_music.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/shortbuz_comment_page.dart';
import 'package:bizbultest/widgets/shortbuz_report_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/shortbuz_video_player.dart';
import 'package:dio/dio.dart' as dio;

class ShortBuzFirstCard extends StatefulWidget {
  final DiscoverPostsModel video;

  ShortBuzFirstCard({Key? key, required this.video}) : super(key: key);

  @override
  _ShortBuzFirstCardState createState() => _ShortBuzFirstCardState();
}

class _ShortBuzFirstCardState extends State<ShortBuzFirstCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  //! api updated
  Future<void> likeUnlike(String postType, String postID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postLikeUnlike?action=post_like_data&user_id=${CurrentUser().currentUser.memberID}&post_type=${widget.video.postType}&post_id=${widget.video.postId}";
    print(url);

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    if (response.statusCode == 200) {
      ShortbuzLikeUnlikePostModel _likeUnlikePost =
          ShortbuzLikeUnlikePostModel.fromJson(response.data);
      print("likeUnlikePost");
      setState(() {
        widget.video.postTotalLikes = _likeUnlikePost.totalLike.toString();
        widget.video.postLikeLogo = _likeUnlikePost.imageData;
      });
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ShortbuzVideoPlayer(
            url: widget.video.video!,
          ),
          Positioned.fill(
            left: 1.5.h,
            right: 1.5.h,
            top: 3.0.h,
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shortbuz ",
                      style: whiteBold.copyWith(fontSize: 20.0.sp),
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 4.0.h,
                    )
                  ],
                )),
          ),
          Positioned.fill(
            right: 1.5.h,
            top: 30.0.h,
            child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 6.0.h,
                  height: 7.0.h,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 3.0.h,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(widget.video.postUserPicture!),
                      ),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                // pause button (round)
                                borderRadius: BorderRadius.circular(
                                    50), // change radius size
                                color: primaryBlueColor, //button colour
                                child: InkWell(
                                  splashColor:
                                      primaryBlueColor, // inkwell onPress colour
                                  child: SizedBox(
                                    //customisable size of 'button'
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  onTap: () {}, // or use onPressed: () {}
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                )),
          ),
          Positioned.fill(
            right: 1.5.h,
            top: 40.0.h,
            child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    likeUnlike(widget.video.postType, widget.video.postId!);
                  },
                  child: Column(
                    children: [
                      Icon(
                        CustomIcons.like,
                        size: widget.video.postLikeLogo ==
                                "https://www.bebuzee.com/new_files/Like-Icon-715x715.png"
                            ? 4.7.h
                            : 4.5.h,
                        color: widget.video.postLikeLogo ==
                                "https://www.bebuzee.com/new_files/Like-Icon-715x715.png"
                            ? Colors.red
                            : Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.w),
                        child: Text(
                          widget.video.postNumberOfViews.toString(),
                          style: whiteNormal,
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Positioned.fill(
            right: 1.5.h,
            top: 50.0.h,
            child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    /*   showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                        context: context,
                        builder: (BuildContext bc) {
                          return ShortbuzCommentPage(
                            feed: widget.video,
                          );
                        });*/
                  },
                  child: Column(
                    children: [
                      Icon(
                        CustomIcons.chat,
                        size: 4.5.h,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.w),
                        child: Text(
                          widget.video.postTotalComment.toString(),
                          style: whiteNormal,
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Positioned.fill(
            right: 1.5.h,
            top: 60.0.h,
            child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Share.share(widget.video.postUrl!);
                  },
                  child: Column(
                    children: [
                      Icon(
                        CustomIcons.shareshortbuz,
                        size: 4.5.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )),
          ),
          Positioned.fill(
            right: 1.5.h,
            top: 70.0.h,
            child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        context: context,
                        builder: (BuildContext bc) {
                          return ShortbuzReportMenu();
                        });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.more_vert_outlined,
                        size: 4.5.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )),
          ),
          Positioned(
            left: 1.5.h,
            right: 1.5.h,
            bottom: 3.0.h,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Text(
                        widget.video.postShortcode!,
                        style: whiteBold.copyWith(fontSize: 10.0.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Text(
                        widget.video.postContent!,
                        style: whiteNormal.copyWith(fontSize: 10.0.sp),
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Row(
                        children: [
                          Icon(
                            CustomIcons.music,
                            color: Colors.white,
                            size: 1.5.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 1.0.h),
                            child: Container(
                              width: 40.0.w,
                              child: MarqueeWidget(
                                direction: Axis.horizontal,
                                child: Text(
                                    AppLocalizations.of(
                                      "The Smiths - 'The Queen Is Dead'",
                                    ),
                                    style: whiteNormal.copyWith(
                                        fontSize: 10.0.sp)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Positioned.fill(
            right: 1.5.h,
            top: 80.0.h,
            child: Align(
                alignment: Alignment.topRight,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/musicLoading.gif",
                      height: 6.0.h,
                    ),
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              AnimatedBuilder(
                                  animation: _controller,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: _controller.value * 2 * math.pi,
                                      child: CircleAvatar(
                                        radius: 1.5.h,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                            widget.video.postUserPicture!),
                                      ),
                                    );
                                  }),
                            ],
                          )),
                    )
                  ],
                )),
          ),
          /*Positioned.fill(
            right: 8.0.h,
            top: 80.0.h,
            child: Align(
                alignment: Alignment.topRight,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/musicLoading.gif",
                      height: 2.0.h,
                    )
                  ],
                )),
          ),*/
        ],
      ),
    );
  }
}
