// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';

class SimplePlayer extends StatefulWidget {
  SimplePlayer({Key? key, this.title, this.url}) : super(key: key);
  final String? title;
  final String? url;

  @override
  _SimplePlayerState createState() => _SimplePlayerState();
}

class _SimplePlayerState extends State<SimplePlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.url!);
    controller.initialize().then((_) {
      setState(() {});
      controller.setLooping(true);
      controller.setVolume(0);
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
    return Scaffold(
      body: Center(
          child: controller.value != null && controller.value.isInitialized
              ? VisibilityDetector(
                  key: ObjectKey(controller),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction > 0.8) {
                      controller.play();
                    } else {
                      controller.pause();
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRect(
                        child: Container(
                          child: Transform.scale(
                            scale:
                                controller.value.aspectRatio / size.aspectRatio,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: VideoPlayer(controller),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.black,
                )),
    );
  }
}
