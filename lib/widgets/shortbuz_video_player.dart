import 'dart:async';
import 'package:bizbultest/models/shortbuz/shortbuz_video_list_model.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:bizbultest/models/shortbuz_model.dart';

import 'Shortbuz/display_shortbuz_tags_and_stickers.dart';

class ShortbuzVideoPlayer extends StatefulWidget {
  ShortbuzVideoPlayer(
      {Key? key,
      this.title,
      required this.url,
      this.index,
      this.image,
      this.stickerList,
      this.positionList,
      this.isHidden})
      : super(key: key);
  final String? title;
  final int? index;
  final String url;
  final String? image;
  final List<StickerVideo>? stickerList;
  final List<Position>? positionList;
  final bool? isHidden;

  @override
  _ShortbuzVideoPlayerState createState() => _ShortbuzVideoPlayerState();
}

class _ShortbuzVideoPlayerState extends State<ShortbuzVideoPlayer> {
  late VideoPlayerController controller;

  bool setMute = true;
  bool? isMute = true;

  @override
  void initState() {
    print('url of the shortbuz vide=${widget.url} ${widget.title}');
    controller = VideoPlayerController.network(widget.url);
    controller.initialize().then((_) {
      isMute = null;
      setState(() {});
      controller.pause();
      controller.setLooping(true);
      if (CurrentUser().currentUser.shortbuzIsMuted == true) {
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
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Container(
        height: 100.0.h,
        width: 100.0.w,
        child: (controller.value != null && controller.value.isInitialized)
            ? Stack(
                children: [
                  Container(
                    height: 100.0.h,
                    width: 100.0.w,
                    child: VisibilityDetector(
                      key: ObjectKey(controller),
                      onVisibilityChanged: (visibility) {
                        if (visibility.visibleFraction > 0.8) {
                          print("yes true short");
                          Wakelock.enable();
                          controller.play();
                          if (CurrentUser().currentUser.shortbuzIsMuted ==
                              true) {
                            controller.setVolume(0);
                          } else {
                            controller.setVolume(1);
                          }
                        } else {
                          print("yoho");
                          Wakelock.disable();
                          controller.pause();
                          if (CurrentUser().currentUser.shortbuzIsMuted ==
                              true) {
                            controller.setVolume(0);
                          } else {
                            controller.setVolume(1);
                          }
                        }
                      },
                      child: Container(),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          if (controller.value.volume == 0) {
                            setState(() {
                              CurrentUser().currentUser.shortbuzIsMuted = false;
                              isMute = false;
                            });
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                isMute = null;
                              });
                            });

                            controller.setVolume(1);
                          } else if (controller.value.volume == 1) {
                            setState(() {
                              CurrentUser().currentUser.shortbuzIsMuted = true;
                              isMute = true;
                            });

                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                isMute = null;
                              });
                            });
                            controller.setVolume(0);
                          }
                        },
                        child: Stack(
                          children: [
                            SizedBox.expand(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                  width: controller.value.size?.width ?? 0,
                                  height: controller.value.size?.height ?? 0,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                            ),
                            widget.stickerList!.length > 0
                                ? Stack(
                                    children: widget.stickerList!
                                        .map((e) => DisplayShortbuzStickers(
                                              s: e,
                                            ))
                                        .toList(),
                                  )
                                : Container(),
                            widget.positionList!.length > 0
                                ? Stack(
                                    children: widget.positionList!
                                        .map((e) => DisplayShortbuzTags(
                                              e: e,
                                            ))
                                        .toList(),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // isMute == true
                  //     ? Positioned.fill(
                  //         child: Align(
                  //             alignment: Alignment.center,
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                   color: Colors.black.withOpacity(0.5),
                  //                   shape: BoxShape.circle),
                  //               child: Padding(
                  //                 padding: EdgeInsets.all(1.5.h),
                  //                 child: Icon(
                  //                   CustomIcons.mute,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             )),
                  //       )
                  //     : isMute == false
                  //         ? Positioned.fill(
                  //             child: Align(
                  //                 alignment: Alignment.center,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                       color: Colors.black.withOpacity(0.5),
                  //                       shape: BoxShape.circle),
                  //                   child: Padding(
                  //                     padding: EdgeInsets.all(1.5.h),
                  //                     child: Icon(
                  //                       CustomIcons.volume,
                  //                       color: Colors.white,
                  //                     ),
                  //                   ),
                  //                 )),
                  //           )
                  //         : Container(),
                ],
              )
            : Container(
                child: ClipRect(
                  child: Container(
                    child: Transform.scale(
                      scale: controller.value.aspectRatio / size.aspectRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: Image.network(
                            widget.image!,
                            colorBlendMode: BlendMode.softLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
