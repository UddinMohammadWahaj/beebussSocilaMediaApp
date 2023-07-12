import 'dart:io';

import './flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class FlickMultiPlayer extends StatefulWidget {
  const FlickMultiPlayer({
    Key? key,
    required this.url,
    this.flickMultiManager,
    this.showIconCenter,
  }) : super(key: key);

  final File url;

  final FlickMultiManager? flickMultiManager;
  final String? showIconCenter;

  @override
  _FlickMultiPlayerState createState() => _FlickMultiPlayerState();
}

class _FlickMultiPlayerState extends State<FlickMultiPlayer> {
  FlickManager? flickManager;
  bool isDisposed = false;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(widget.url)
        ..setLooping(true),
      autoPlay: false,
    );
    widget.flickMultiManager!.init(flickManager!);

    //print(flickManager.flickVideoManager.videoPlayerController.value.duration.toString() + " is duration");

    super.initState();
  }

  @override
  void dispose() {
    widget.flickMultiManager!.remove(flickManager!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        // print(flickManager.flickVideoManager.videoPlayerController.value.duration);

        if (visibility.visibleFraction > 0.9) {
          if (isDisposed) {
            setState(() {
              flickManager = FlickManager(
                videoPlayerController: VideoPlayerController.file(widget.url)
                  ..setLooping(true),
                autoPlay: false,
              );
              isDisposed = false;
            });

            //widget.flickMultiManager.init(flickManager);
            widget.flickMultiManager!.play(flickManager!);
          } else {
            widget.flickMultiManager!.play(flickManager!);
          }
          //debugPrint(visibility.visibleFraction.toString() + " visibility");
          // print("is video playing " + flickManager.flickVideoManager.toString());
        } else if (visibility.visibleFraction < 0.8) {
          if (isDisposed) {
            setState(() {
              flickManager = FlickManager(
                videoPlayerController: VideoPlayerController.file(widget.url)
                  ..setLooping(true),
                autoPlay: false,
              );
              isDisposed = false;
            });

            // widget.flickMultiManager.init(flickManager);
            widget.flickMultiManager!.pause();
          } else {
            widget.flickMultiManager!.pause();
          }
        } else if (visibility.visibleFraction <= 0.2) {
          widget.flickMultiManager!.remove(flickManager!);
          setState(() {
            isDisposed = true;
          });
        }
      },
      child: Container(
        child: isDisposed
            ? Container()
            : FlickVideoPlayer(
                flickManager: flickManager!,
                flickVideoWithControls: FlickVideoWithControls(
                  videoFit: BoxFit.cover,
                  backgroundColor: Colors.black,
                  playerLoadingFallback: Positioned.fill(
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: Container(
                          color: Colors.black,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
