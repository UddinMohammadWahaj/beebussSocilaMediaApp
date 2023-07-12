import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';

import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';

class PreviewVideoPlayer extends StatefulWidget {
  final String? url;
  final FlickManager? flickManager;

  const PreviewVideoPlayer({Key? key, this.url, this.flickManager}) : super(key: key);

  @override
  _PreviewVideoPlayerState createState() => _PreviewVideoPlayerState();
}

class _PreviewVideoPlayerState extends State<PreviewVideoPlayer> {
 late FlickManager _flickManager;

  Widget _toggleItemCard(double top, double left, double right, Alignment alignment, Widget button) {
    return Positioned.fill(
      top: top,
      right: right,
      left: left,
      child: Align(
        alignment: alignment,
        child: FlickShowControlsAction(
          child: FlickSeekVideoAction(
            child: FlickVideoBuffer(
              child: FlickAutoHideChild(showIfVideoNotInitialized: false, child: button),
            ),
          ),
        ),
      ),
    );
  }

  Widget _toggle() {
    return Stack(
      children: <Widget>[
        _toggleItemCard(
          0,
          0,
          0,
          Alignment.center,
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlickPlayToggle(
                  size: 8.0.h,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        /* _toggleItemCard(26.0.h, 90.0.w, 1.0.w, Alignment.bottomRight, IconButton(
          splashRadius: 4.0.w,
          onPressed: () {
            print("maximizeeee");
          },
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.fullscreen,
            size: 7.0.w,
          ),
        ),),*/
        _toggleItemCard(
          27.0.h,
          2.5.w,
          0,
          Alignment.bottomLeft,
          Container(
            color: Colors.transparent,
            width: 97.5.w,
            child: Row(
              children: [
                Container(
                  width: 85.0.w,
                  child: FlickVideoProgressBar(
                    flickProgressBarSettings: FlickProgressBarSettings(
                      height: 3,
                      handleRadius: 8,
                      curveRadius: 0,
                      backgroundColor: Colors.white24,
                      bufferedColor: Colors.white38,
                      playedColor: Colors.red.shade700,
                      handleColor: Colors.red.shade700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("maximizeeeeee");
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 12.5.w,
                    child: Icon(
                      Icons.fullscreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    _flickManager = new FlickManager(
      autoPlay: true,
      autoInitialize: true,
      videoPlayerController: VideoPlayerController.network(widget.url!),
    );
    _flickManager.flickVideoManager!.videoPlayerController!.setVolume(0);
    _flickManager.flickVideoManager!..videoPlayerController!.pause();
    super.initState();
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0.h,
      width: 100.0.w,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FlickVideoPlayer(
              wakelockEnabled: true,
              wakelockEnabledFullscreen: false,
              flickManager: _flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                  videoFit: BoxFit.contain,
                  aspectRatioWhenLoading: 16 / 9,
                  playerLoadingFallback: Center(child: customCircularIndicator(4, Colors.white)),
                  controls: _toggle()),
              flickVideoWithControlsFullscreen: Container(),
            ),
          ),
          Positioned.fill(
            left: 10,
            bottom: 10,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                      child: Text(
                        AppLocalizations.of(
                          "Preview",
                        ),
                        style: TextStyle(fontSize: 10.0.sp, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ))),
          ),
        ],
      ),
    );
  }
}
