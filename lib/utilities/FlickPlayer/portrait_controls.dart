import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import 'flick_multi_manager.dart';

class FeedPlayerPortraitControls extends StatelessWidget {
  const FeedPlayerPortraitControls(
      {Key? key,
      this.flickMultiManager,
      this.flickManager,
      this.showIconCenter})
      : super(key: key);

  final FlickMultiManager? flickMultiManager;
  final FlickManager? flickManager;
  final String? showIconCenter;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: FlickToggleSoundAction(
              toggleMute: () {
                flickMultiManager!.toggleMute();
                displayManager.handleShowPlayerControls();
              },
            ),
          ),
          FlickAutoHideChild(
            autoHide: true,
            showIfVideoNotInitialized: false,
            child: showIconCenter == "yes"
                ? GestureDetector(
                    onTap: () {
                      flickMultiManager!.toggleMute();
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 80.0.h,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlickSoundToggle(
                              toggleMute: () => flickMultiManager!.toggleMute(),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: FlickSoundToggle(
                          toggleMute: () => flickMultiManager!.toggleMute(),
                          color: Colors.black,
                        ),
                      ),
                      // FlickFullScreenToggle(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
