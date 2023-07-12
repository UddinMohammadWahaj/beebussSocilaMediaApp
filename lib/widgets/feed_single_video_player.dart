import 'dart:async';

import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';

class FeedsSingleVideoPlayer extends StatefulWidget {
  FeedsSingleVideoPlayer({Key? key, this.url, this.image, e}) : super(key: key);

  final String? url;

  final String? image;

  @override
  _FeedsSingleVideoPlayerState createState() => _FeedsSingleVideoPlayerState();
}

class _FeedsSingleVideoPlayerState extends State<FeedsSingleVideoPlayer> {
  late VideoPlayerController controller;

  bool? setMute = true;
  bool? isMute = true;
  bool? continueWatching = false;

  @override
  void initState() {
    print(widget.url! + "  urllllllllll of video");
    controller = VideoPlayerController.network(widget.url!);
    controller.initialize().then((_) {
      setMute = null;
      setState(() {});
      controller.pause();
      controller.setLooping(true);
      if (CurrentUser().currentUser.feedIsMuted == true) {
        controller.setVolume(0);
      } else {
        controller.setVolume(1);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispppppppppppppseeee");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      body: Center(
          child: controller.value != null && controller.value.isInitialized
              ? VisibilityDetector(
                  key: ObjectKey(controller),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction > 0.6) {
                      if (CurrentUser().currentUser.feedIsMuted == true) {
                        controller.setVolume(0);
                      } else {
                        controller.setVolume(1);
                      }
                      controller.play();
                    } else {
                      if (CurrentUser().currentUser.feedIsMuted == true) {
                        controller.setVolume(0);
                      } else {
                        controller.setVolume(1);
                      }

                      controller.pause();
                    }
                  },
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller.value.volume == 0) {
                            setState(() {
                              CurrentUser().currentUser.feedIsMuted = false;
                              setMute = false;
                            });
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                setMute = null;
                              });
                            });

                            controller.setVolume(1);

                            print(CurrentUser().currentUser.feedIsMuted);
                            print(setMute);
                          } else if (controller.value.volume == 1) {
                            setState(() {
                              CurrentUser().currentUser.feedIsMuted = true;
                              setMute = true;
                            });

                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                setMute = null;
                              });
                            });
                            controller.setVolume(0);

                            print(CurrentUser().currentUser.feedIsMuted);
                            print(setMute);
                          }
                        },
                        child: SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size?.width ?? 0,
                              height: controller.value.size?.height ?? 0,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        ),
                      ),
                      setMute == true
                          ? Positioned.fill(
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 1.0.w, bottom: 1.0.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: EdgeInsets.all(0.7.h),
                                        child: Icon(
                                          CustomIcons.mute,
                                          color: Colors.white,
                                          size: 1.5.h,
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                          : setMute == false
                              ? Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 1.0.w, bottom: 1.0.w),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              shape: BoxShape.circle),
                                          child: Padding(
                                            padding: EdgeInsets.all(0.7.h),
                                            child: Icon(
                                              CustomIcons.volume,
                                              color: Colors.white,
                                              size: 1.5.h,
                                            ),
                                          ),
                                        ),
                                      )),
                                )
                              : Container(),
                      /*      continueWatching == true
                          ? Positioned.fill(
                              bottom: 1.0.w,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 100.0.w,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      shape: BoxShape.rectangle,
                                      border: new Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(1.5.w),
                                      child: Text(
                                        "Continue Watching",
                                        style: whiteBold.copyWith(fontSize: 11.0.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),
                            )
                          : Container()*/
                    ],
                  ),
                )
              : Container(
                  height: 50.0.h,
                  width: 100.0.w,
                  child: widget.image != null
                      ? Image(
                          image: CachedNetworkImageProvider(widget.image!),
                          fit: BoxFit.cover)
                      : Container(
                          color: Colors.black,
                        ),
                )),
    );
  }
}
