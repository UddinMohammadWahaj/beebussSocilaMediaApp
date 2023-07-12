import 'package:bizbultest/models/Properbuz/properbuz_feeds_model.dart';
import 'package:bizbultest/widgets/discover_video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class ExpandedVideoPlayerTest extends StatefulWidget {
  var video;
  ExpandedVideoPlayerTest({Key? key, this.video}) : super(key: key);

  @override
  State<ExpandedVideoPlayerTest> createState() =>
      _ExpandedVideoPlayerTestState();
}

class _ExpandedVideoPlayerTestState extends State<ExpandedVideoPlayerTest> {
  FlickManager? flickmanager;
  var video;
  @override
  void initState() {
    video = widget.video;
    print("flick video=${video}");

    flickmanager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
      '${widget.video}',
    ));
    flickmanager!.flickVideoManager!.addListener(() {
      if (flickmanager!.flickVideoManager!.isVideoInitialized) {
        print("video initialised from flick");
      }
    });
    flickmanager!.flickDisplayManager!.addListener(() {
      if (flickmanager!.flickVideoManager!.isVideoInitialized) {
        print("video initialised");
      }
      if (!flickmanager!.flickVideoManager!.isPlaying) {
        print("video paused");
      }
      if (flickmanager!.flickVideoManager!.isBuffering) {
        print("video buffereing");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 30.0.h,
        width: 100.0.w,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child:

              //  Chewie(
              //   controller: ChewieController(
              //     showOptions: true,
              //     showControls: true,
              //     aspectRatio: 16 / 9,
              //     videoPlayerController: VideoPlayerController.network(video),
              //   ),
              // )

              FlickVideoPlayer(
            flickManager: flickmanager!,
            flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                controls: FlickPortraitControls(),
                aspectRatioWhenLoading: 16 / 9,
                playerLoadingFallback: Center(child: CircularProgressIndicator()
                    // child: CachedNetworkImage(
                    //   fit: BoxFit.cover,
                    //   imageUrl: thumbnail,
                    // ),
                    )),
          ),
        ),
      ),
    );
  }
}
