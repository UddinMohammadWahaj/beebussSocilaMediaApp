import 'dart:async';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ShortbuzVideoPlayerDiscover extends StatefulWidget {
  ShortbuzVideoPlayerDiscover({Key? key, this.title, required this.url})
      : super(key: key);
  final String? title;
  final String url;

  @override
  _ShortbuzVideoPlayerDiscoverState createState() =>
      _ShortbuzVideoPlayerDiscoverState();
}

class _ShortbuzVideoPlayerDiscoverState
    extends State<ShortbuzVideoPlayerDiscover> {
  late VideoPlayerController buzController;

  bool setMute = true;
  bool isMute = true;

  @override
  void initState() {
    buzController = VideoPlayerController.network(widget.url);
    buzController.initialize().then((_) {
      //print(widget.url+ " urllllllllllllllllll");
      // isMute = null;
      buzController.pause();
      buzController.setLooping(true);
      if (CurrentUser().currentUser.shortbuzIsMuted == true) {
        buzController.setVolume(0);
      } else {
        buzController.setVolume(1);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    buzController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      body: Center(
          child: buzController.value != null &&
                  buzController.value.isInitialized
              ? VisibilityDetector(
                  key: ObjectKey(buzController),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction > 0.8) {
                      buzController.play();

                      if (CurrentUser().currentUser.shortbuzIsMuted == true) {
                        buzController.setVolume(0);
                      } else {
                        buzController.setVolume(1);
                      }
                    } else {
                      buzController.pause();
                      if (CurrentUser().currentUser.shortbuzIsMuted == true) {
                        buzController.setVolume(0);
                      } else {
                        buzController.setVolume(1);
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (buzController.value.volume == 0) {
                            setState(() {
                              CurrentUser().currentUser.shortbuzIsMuted = false;
                              isMute = false;
                            });
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                // isMute = null;
                              });
                            });

                            buzController.setVolume(1);
                          } else if (buzController.value.volume == 1) {
                            setState(() {
                              CurrentUser().currentUser.shortbuzIsMuted = true;
                              isMute = true;
                            });

                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                // isMute = null;
                              });
                            });
                            buzController.setVolume(0);
                          }
                        },
                        child: ClipRect(
                          child: Container(
                            child: Transform.scale(
                              scale: buzController.value.aspectRatio /
                                  size.aspectRatio,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: buzController.value.aspectRatio,
                                  child: VideoPlayer(buzController),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      isMute == true
                          ? Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(1.5.h),
                                      child: Icon(
                                        CustomIcons.mute,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            )
                          : isMute == false
                              ? Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: EdgeInsets.all(1.5.h),
                                          child: Icon(
                                            CustomIcons.volume,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                )
                              : Container(),
                    ],
                  ),
                )
              : Container(
                  color: Colors.black,
                )

          /*  Container(
                  // padding: EdgeInsets.only(left: 3.0.w),
                  width: 100.0.w,
                  height: 100.0.h,
                  color: Colors.grey[600],
                  child: Stack(
                    children: [
                      Positioned(
                        left: 1.5.h,
                        right: 1.5.h,
                        bottom: 3.0.h,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonAnimation(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1.0.h),
                                  child: Container(
                                    width: 15.0.h,
                                    height: 1.5.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                              SkeletonAnimation(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1.0.h),
                                  child: Container(
                                    width: 20.0.h,
                                    height: 1.5.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                              SkeletonAnimation(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1.0.h),
                                  child: Container(
                                    width: 25.0.h,
                                    height: 1.5.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )*/
          ),
    );
  }
}
