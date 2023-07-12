import 'dart:io';

// import 'package:_video_player/_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatExpandedVideoPlayer extends StatefulWidget {
  ChatExpandedVideoPlayer(
      {Key? key, this.file, this.setHeight, this.path, this.from})
      : super(key: key);

  final File? file;
  final Function? setHeight;
  final String? path;
  final String? from;

  @override
  _ChatExpandedVideoPlayerState createState() =>
      _ChatExpandedVideoPlayerState();
}

class _ChatExpandedVideoPlayerState extends State<ChatExpandedVideoPlayer> {
  VideoPlayerController? controller;

  bool continueWatching = false;
  Size size = Size(0, 0);
  var keyText = GlobalKey();
  double h = 0;
  double w = 0;

  void calculateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final RenderObject? box = keyText.currentContext?.findRenderObject();
      final RenderRepaintBoundary? box =
          keyText.currentContext!.findRenderObject() as RenderRepaintBoundary;

      setState(() {
        size = box!.size;
        w = size.width;
        h = size.height;
      });
    });
  }

  @override
  void initState() {
    print(widget.file!.path + " path");

    controller = VideoPlayerController.file(widget.file!);
    controller!.initialize().then((_) {
      setState(() {});

      controller!.pause();
      controller!.setLooping(true);

      print(controller!.value.size.aspectRatio.h.toString() + " height 111");
      print(controller!.value.aspectRatio.h.toString() + " height 222");
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispppppppppppppseeee");
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Container(
      child: controller!.value != null && controller!.value.isInitialized
          ? VisibilityDetector(
              key: ObjectKey(controller),
              onVisibilityChanged: (visibility) async {
                if (visibility.visibleFraction > 0.8) {
                  if (mounted) {
                    setState(() {
                      controller!.play();
                    });
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      controller!.pause();
                    });
                  }
                }
              },
              child: GestureDetector(
                  onTap: () {
                    if (controller!.value.isPlaying) {
                      setState(() {
                        controller!.pause();
                      });
                    } else {
                      setState(() {
                        controller!.play();
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 100.0.w,
                            child: AspectRatio(
                                aspectRatio: controller!.value.aspectRatio,
                                child: VideoPlayer(controller!)),
                          ),
                        ),
                      ),
                      !controller!.value.isPlaying
                          ? Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: new BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 50,
                                      ))),
                            )
                          : Container()
                    ],
                  )),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }
}

class ChatMiniVideoPlayer extends StatefulWidget {
  ChatMiniVideoPlayer(
      {Key? key, this.file, this.setHeight, this.path, this.from})
      : super(key: key);

  final File? file;
  final Function? setHeight;
  final String? path;
  final String? from;

  @override
  _ChatMiniVideoPlayerState createState() => _ChatMiniVideoPlayerState();
}

class _ChatMiniVideoPlayerState extends State<ChatMiniVideoPlayer> {
  VideoPlayerController? controller;

  @override
  void initState() {
    print(widget.from! + " frommmmm");

    controller = VideoPlayerController.file(
        widget.from! == "direct" ? widget.file! : new File(widget.path!));
    controller!.initialize().then((_) {
      setState(() {});
      controller!.pause();
      controller!.setLooping(true);

      print(controller!.value.size.aspectRatio.h.toString() + " height 111");
      print(controller!.value.aspectRatio.h.toString() + " height 222");
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispppppppppppppseeee");
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      body: Center(
        child: controller!.value != null && controller!.value.isInitialized
            ? GestureDetector(
                onTap: () {},
                child: Container(
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller!.value.size?.width ?? 0,
                        height: controller!.value.size?.height ?? 0,
                        child: VideoPlayer(controller!),
                      ),
                    ),
                  ),
                ))
            : Container(
                color: Colors.black,
              ),
      ),
    );
  }
}
