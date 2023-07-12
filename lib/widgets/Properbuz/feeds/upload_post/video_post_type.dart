import 'dart:io';

import 'package:bizbultest/utilities/colors.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPostType extends GetView<ProperbuzFeedController> {
  const VideoPostType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Obx(
      () => Container(
        child: File(controller.videoFile.value.path).existsSync()
            ? GestureDetector(
                onTap: () {
                  if (controller.flickManager.flickVideoManager!.isPlaying) {
                    controller.flickManager.flickControlManager!.pause();
                    controller.isVideoPlaying.value = false;
                  } else {
                    controller.flickManager.flickControlManager!.play();
                    controller.isVideoPlaying.value = true;
                  }
                },
                child: Container(
                    constraints: BoxConstraints(maxHeight: 50.0.h),
                    color: Colors.transparent,
                    width: 100.0.w,
                    child: ClipRRect(
                      child: Stack(
                        children: [
                          PostVideoPlayer(),
                          Positioned.fill(
                            right: 10,
                            top: 10,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  splashRadius: 15,
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.all(5),
                                  onPressed: () {
                                    controller.videoFile.value = File("");
                                  },
                                  icon: Icon(
                                    CupertinoIcons.delete_solid,
                                    color: settingsColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          controller.isVideoPlaying.value
                              ? Container()
                              : Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.play_circle_fill,
                                        color: Colors.black,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    )),
              )
            : Container(),
      ),
    );
  }
}

class PostVideoPlayer extends StatefulWidget {
  const PostVideoPlayer({Key? key}) : super(key: key);

  @override
  _PostVideoPlayerState createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  ProperbuzFeedController controller = Get.put(ProperbuzFeedController());

  @override
  void dispose() {
    controller.flickManager.dispose();
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      wakelockEnabled: false,
      wakelockEnabledFullscreen: false,
      flickManager: controller.flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.cover,
        playerLoadingFallback: Center(
            child: Container(
          color: Colors.black,
          height: 250,
          width: 100.0.w,
        )),
      ),
    );
  }
}
