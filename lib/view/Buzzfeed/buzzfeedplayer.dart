import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SamplePlayer extends StatefulWidget {
  File? url;
  SamplePlayer({Key? key, this.url}) : super(key: key);

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;
  var controller;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: true,
      videoPlayerController: VideoPlayerController.file(
        widget.url!,
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0.h,
      width: 75.0.w,

      // key: Key('${widget.url}'),

      child: FlickVideoPlayer(
        flickManager: flickManager,
      ),
    );
  }
}
