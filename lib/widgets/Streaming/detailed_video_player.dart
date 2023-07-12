import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';

class DetailedVideoPlayer extends StatefulWidget {
  final String video;
  final String? title;

  const DetailedVideoPlayer({Key? key, required this.video, this.title})
      : super(key: key);

  @override
  _DetailedVideoPlayerState createState() => _DetailedVideoPlayerState();
}

class _DetailedVideoPlayerState extends State<DetailedVideoPlayer> {
  late FlickManager flickManager;

  Widget _seekButton(IconData icon, VoidCallback onTap) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        icon: Icon(
          icon,
          color: Colors.white,
          size: 50,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onTap);
  }

  Widget _titleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            flickManager.flickControlManager!.exitFullscreen();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
          splashRadius: 20,
        ),
        Text(
          widget.title!,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.transparent,
          ),
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
          splashRadius: 20,
        ),
      ],
    );
  }

  Widget _videoActionsRow() {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _seekButton(CustomIcons.icons8_replay_10_100, () {
            _seekBackward();
          }),
          FlickPlayToggle(
            size: 80,
            color: Colors.white,
          ),
          _seekButton(CustomIcons.icons8_forward_10_100, () {
            _seekForward();
          }),
        ],
      ),
    );
  }

  Widget _videoSeekBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100.0.h - 70,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FlickVideoProgressBar(
              flickProgressBarSettings: FlickProgressBarSettings(
                height: 4,
                handleRadius: 10,
                curveRadius: 0,
                backgroundColor: Colors.white24,
                bufferedColor: Colors.transparent,
                playedColor: Colors.red,
                handleColor: Colors.red,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 40,
          child: FlickLeftDuration(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _controls(BuildContext context) {
    return FlickShowControlsAction(
      child: FlickAutoHideChild(
        showIfVideoNotInitialized: false,
        child: FlickSeekVideoAction(
          child: FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _titleRow(context),
                    _videoActionsRow(),
                    _videoSeekBar(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _seekForward() async {
    print(flickManager.flickDisplayManager!.showPlayerControls);
    Duration? time =
        await flickManager.flickVideoManager!.videoPlayerController!.position;
    time = time! + Duration(seconds: 10);
    flickManager.flickVideoManager!.videoPlayerController!.seekTo(time);
  }

  void _seekBackward() async {
    print(flickManager.flickDisplayManager!.showPlayerControls);
    Duration? time =
        await flickManager!.flickVideoManager!.videoPlayerController!.position;
    if (time! > Duration(seconds: 10)) {
      time = time - Duration(seconds: 10);
    } else {
      time = Duration(seconds: 0);
    }

    flickManager.flickVideoManager!.videoPlayerController!.seekTo(time);
  }

  @override
  void initState() {
    print(widget.video);
    print("video url");
    flickManager = new FlickManager(
      autoPlay: true,
      autoInitialize: true,
      videoPlayerController: VideoPlayerController.network(widget.video),
    );
    flickManager.flickControlManager!.enterFullscreen();
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Container(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: FlickVideoPlayer(
            preferredDeviceOrientationFullscreen: [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            preferredDeviceOrientation: [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            wakelockEnabled: true,
            wakelockEnabledFullscreen: true,
            flickManager: flickManager,
            flickVideoWithControls: Container(),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                aspectRatioWhenLoading: 16 / 9,
                playerLoadingFallback:
                    Center(child: customCircularIndicator(4, Colors.red)),
                controls: _controls(context)),
          ),
        ),
      ),
    );
  }
}
