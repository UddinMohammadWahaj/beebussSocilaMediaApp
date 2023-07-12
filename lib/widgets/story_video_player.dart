// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';

import '../models/expanded_story_model.dart';

class StoryVideoPlayerAutoPlay extends StatefulWidget {
  StoryVideoPlayerAutoPlay(
      {Key? key,
      required this.url,
      required this.setController,
      this.volume,
      this.allFiles})
      : super(key: key);

  final String url;
  final Function setController;
  FileElement? allFiles;
  bool? volume;

  @override
  _StoryVideoPlayerAutoPlayState createState() =>
      _StoryVideoPlayerAutoPlayState();
}

class _StoryVideoPlayerAutoPlayState extends State<StoryVideoPlayerAutoPlay> {
  late VideoPlayerController controller;

  bool continueWatching = false;

  @override
  void initState() {
    print(widget.url + "  urllllllllll of video");
    controller = VideoPlayerController.network(widget.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    controller.initialize().then((_) {
      setState(() {});
      controller.pause();
      if (widget.volume!)
        controller.setVolume(1);
      else
        controller.setVolume(0);
      controller.setLooping(true);
      widget.setController(controller);
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
                  onVisibilityChanged: (visibility) async {
                    if (visibility.visibleFraction > 0.8) {
                      controller.play();
                    } else {
                      controller.pause();
                    }
                  },
                  child: Stack(
                    children: [
                      GestureDetector(
                        onLongPress: () {},
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
                  color: Colors.black,
                )),
    );
  }
}

class StoryVideoPlayerPaused extends StatefulWidget {
  StoryVideoPlayerPaused(
      {Key? key, required this.url, required this.setController})
      : super(key: key);

  final String url;
  final Function setController;

  @override
  _StoryVideoPlayerPausedState createState() => _StoryVideoPlayerPausedState();
}

class _StoryVideoPlayerPausedState extends State<StoryVideoPlayerPaused> {
  late VideoPlayerController controller;

  bool continueWatching = false;

  @override
  void initState() {
    print(widget.url + "  urllllllllll of video");
    controller = VideoPlayerController.network(widget.url);
    controller.initialize().then((_) {
      setState(() {});
      controller.pause();
      controller.setLooping(true);
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
              ? Stack(
                  children: [
                    GestureDetector(
                      onLongPress: () {},
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
                )
              : Container(
                  color: Colors.black,
                )),
    );
  }
}
