import 'package:bizbultest/widgets/MainVideoWidgets/video_seek_controls.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PotraitControls extends StatelessWidget {
  final VoidCallback? fullscreen;
  final bool? isFullscreen;
  final VoidCallback? backward;
  final VoidCallback? forward;

  const PotraitControls(
      {Key? key,
      this.fullscreen,
      this.isFullscreen,
      this.backward,
      this.forward})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BackwardSeek10s(backwardSeek: backward),
                        SizedBox(
                          width: 7.0.w,
                        ),
                        FlickPlayToggle(
                          size: 50,
                          color: Colors.white,
                          padding: EdgeInsets.all(12),
                        ),
                        SizedBox(
                          width: 7.0.w,
                        ),
                        ForwardSeek10s(forwardSeek: forward)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: 23.0.h,
          child: FlickAutoHideChild(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlickCurrentPosition(
                            fontSize: 10.0.sp,
                          ),
                          FlickAutoHideChild(
                            child: Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0.sp),
                            ),
                          ),
                          FlickTotalDuration(
                            fontSize: 10.0.sp,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      GestureDetector(
                          onTap: fullscreen ?? () {},
                          child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0.w, right: 2.0.w),
                                child: !isFullscreen!
                                    ? Icon(
                                        Icons.fullscreen,
                                        size: 2.5.h,
                                      )
                                    : Icon(
                                        Icons.fullscreen_exit,
                                        size: 2.5.h,
                                      ),
                              )))
                    ],
                  ),
                ),
                FlickVideoProgressBar(
                  flickProgressBarSettings: FlickProgressBarSettings(
                    height: 4,
                    handleRadius: 6,
                    curveRadius: 0,
                    backgroundColor: Colors.white24,
                    bufferedColor: Colors.white38,
                    playedColor: Colors.red,
                    handleColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LandscapeControls extends StatelessWidget {
  Future<bool> Function()? onPress;

  LandscapeControls({Key? key, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: onPress!,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FlickShowControlsAction(
              child: FlickSeekVideoAction(
                child: Center(
                  child: FlickVideoBuffer(
                    child: FlickAutoHideChild(
                      showIfVideoNotInitialized: false,
                      child: FlickPlayToggle(
                        size: 50,
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: FlickAutoHideChild(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            FlickCurrentPosition(
                              fontSize: 12.0.sp,
                            ),
                            FlickAutoHideChild(
                              child: Text(
                                ' / ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0.sp),
                              ),
                            ),
                            FlickTotalDuration(
                              fontSize: 12.0.sp,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Icon(Icons.expand_less_outlined)
                      ],
                    ),
                  ),
                  FlickVideoProgressBar(
                    flickProgressBarSettings: FlickProgressBarSettings(
                      height: 4,
                      handleRadius: 7,
                      curveRadius: 0,
                      backgroundColor: Colors.white24,
                      bufferedColor: Colors.white38,
                      playedColor: Colors.red,
                      handleColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
