import 'dart:io';
import 'package:sizer/sizer.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FlexibleVideoPlayer extends StatefulWidget {
  FlexibleVideoPlayer({Key? key, this.video, this.image, this.setHeightWidth})
      : super(key: key);

  final File? video;
  final int? image;
  final Function? setHeightWidth;

  @override
  _FlexibleVideoPlayerState createState() => _FlexibleVideoPlayerState();
}

class _FlexibleVideoPlayerState extends State<FlexibleVideoPlayer> {
  VideoPlayerController? controller;

  @override
  void initState() {
    controller = VideoPlayerController.file(widget.video!);
    controller!.initialize().then((_) {
      setState(() {});
      controller!.pause();
      controller!.setLooping(true);
      widget.setHeightWidth!(controller!.value.size.height.toInt(),
          controller!.value.size.width.toInt());
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispppppposeeeeeee");
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: controller!.value! != null && controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: VideoPlayer(controller!))
              : Container(
                  height: 50.0.h,
                  width: 100.0.w,
                  color: Colors.black,
                )),
    );
  }
}
