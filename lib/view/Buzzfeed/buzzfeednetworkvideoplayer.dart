import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BuzzfeedNetworkVideoPlayer extends StatefulWidget {
  String url;
  BuzzfeedNetworkVideoPlayer({Key? key, this.url = ''}) : super(key: key);

  @override
  _BuzzfeedNetworkVideoPlayerState createState() =>
      _BuzzfeedNetworkVideoPlayerState();
}

class _BuzzfeedNetworkVideoPlayerState
    extends State<BuzzfeedNetworkVideoPlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.url,
      ),
    );
    flickManager.flickVideoManager!.videoPlayerController!.setVolume(100);
    flickManager.flickVideoManager!.videoPlayerController!.setLooping(true);
    print("flickmanager init ${widget.url}");
  }

  @override
  void dispose() {
    print("flickr manager dispose ${widget.url}");
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45.0.h,
        width: 95.0.w,
        color: Colors.white,
        child:
            //  VisibilityDetector(
            //   key: ObjectKey(flickManager),
            //   onVisibilityChanged: (visibility) {
            //     if (visibility.visibleFraction > 0.5) {
            //       print("visible");
            //       flickManager.flickVideoManager.videoPlayerController.setVolume(0);
            //       flickManager.flickVideoManager.videoPlayerController.play();
            //     } else {
            //       print("notvisible");
            //       flickManager.flickVideoManager.videoPlayerController.setVolume(0);
            //       flickManager.flickVideoManager.videoPlayerController.pause();
            //     }
            //   },
            //   child:
            FlickVideoPlayer(
          flickManager: flickManager,
        ),
        // ),
      ),
    );
  }
}
