import 'dart:async';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'Newsfeeds/display_feeds_tags_and_stickers.dart';

class FeedsVideoPlayer extends StatefulWidget {
  FeedsVideoPlayer(
      {Key? key,
      this.aspect,
      this.url,
      this.from,
      this.image,
      this.stickerList,
      this.positionList})
      : super(key: key);
  final double? aspect;
  final String? url;
  final String? from;
  final String? image;
  final List<Sticker>? stickerList;
  final List<Position>? positionList;

  @override
  _FeedsVideoPlayerState createState() => _FeedsVideoPlayerState();
}

class _FeedsVideoPlayerState extends State<FeedsVideoPlayer> {
  late VideoPlayerController controller;

  bool? setMute = true;
  bool? continueWatching = false;

  @override
  void initState() {
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: controller.value != null && controller.value.isInitialized
          ? Stack(
              children: [
                VisibilityDetector(
                  key: ObjectKey(controller),
                  onVisibilityChanged: (visibility) {
                    // controller.pause();
                    if (visibility.visibleFraction > 0.4) {
                      if (CurrentUser().currentUser.feedIsMuted == true) {
                        controller.setVolume(0);
                      } else {
                        controller.setVolume(1);
                      }
                      controller.play();
                      // controller.
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
                          // onSecondaryTap: () {
                          //   bool isplay = true;
                          //   print("---onsecondtap----");
                          // },
                          // onTap: () {
                          //   print("-----ontap--");
                          //   // controller.play();
                          //   controller.pause();
                          // },
                          // onTapDown: (val) {
                          onTap: () {
                            // print("------$val");
                            if (controller.value.volume == 0) {
                              if (mounted) {
                                setState(() {
                                  CurrentUser().currentUser.feedIsMuted = false;
                                  setMute = false;
                                });
                              }
                              Timer(Duration(seconds: 2), () {
                                if (mounted) {
                                  setState(() {
                                    setMute = null;
                                  });
                                }
                              });

                              controller.setVolume(1);

                              print(CurrentUser().currentUser.feedIsMuted);
                              print(setMute);
                            } else if (controller.value.volume == 1) {
                              if (mounted) {
                                setState(() {
                                  CurrentUser().currentUser.feedIsMuted = true;
                                  setMute = true;
                                });
                              }

                              Timer(Duration(seconds: 2), () {
                                if (mounted) {
                                  setState(() {
                                    setMute = null;
                                  });
                                }
                              });
                              controller.setVolume(0);

                              print(CurrentUser().currentUser.feedIsMuted);
                              print(setMute);
                            }
                          },
                          child: widget.aspect == null
                              ? ClipRect(
                                  child: AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  ),
                                )
                              : Stack(
                                  children: [
                                    //   controller == null
                                    //       ? Container(
                                    //           height: 20,
                                    //           color: Colors.blue,
                                    //         )
                                    // :
                                    ClipRRect(
                                      child: SizedBox.expand(
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: SizedBox(
                                            height:
                                                controller.value.size.height,
                                            width: controller.value.size.width,
                                            child: AspectRatio(
                                              child: VideoPlayer(controller),
                                              aspectRatio: widget.aspect!,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    widget.stickerList!.length > 0
                                        ? Stack(
                                            children: widget.stickerList!
                                                .map((e) => DisplayFeedStickers(
                                                      s: e,
                                                    ))
                                                .toList(),
                                          )
                                        : Container(),
                                    widget.positionList!.length > 0
                                        ? Stack(
                                            children: widget.positionList!
                                                .map((e) => DisplayFeedTags(
                                                      e: e,
                                                    ))
                                                .toList(),
                                          )
                                        : Container(),
                                  ],
                                )),
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
                ),
              ],
            )
          : Container(
              // child: loadingAnimation(),
              child: widget.image == null || widget.image == ""
                  ? Container(
                      height: 20.h,
                      color: Colors.yellow,
                    )
                  : Image(
                      image: CachedNetworkImageProvider(widget.image!),
                      fit: BoxFit.cover),
            ),
    );
  }
}
