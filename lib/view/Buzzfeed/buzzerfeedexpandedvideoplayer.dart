import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BuzzfeedNetworkVideoPlayerExpanded extends StatefulWidget {
  String url;
  BuzzfeedNetworkVideoPlayerExpanded({Key? key, this.url=''}) : super(key: key);

  @override
  _BuzzfeedNetworkVideoPlayerExpandedState createState() =>
      _BuzzfeedNetworkVideoPlayerExpandedState();
}

class _BuzzfeedNetworkVideoPlayerExpandedState
    extends State<BuzzfeedNetworkVideoPlayerExpanded> {
 late  FlickManager flickManager;
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
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Container(
        height: 100.0.h,
        width: 100.0.w,
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
