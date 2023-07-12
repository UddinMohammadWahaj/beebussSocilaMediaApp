import 'dart:async';

import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BuzzerFeedPlay extends StatefulWidget {
  BuzzerFeedPlay({Key? key, this.title, this.url, this.from, this.image})
      : super(key: key);
  final String? title;
  final String? url;
  final String? from;
  final String? image;

  @override
  _BuzzerFeedPlayState createState() => _BuzzerFeedPlayState();
}

class _BuzzerFeedPlayState extends State<BuzzerFeedPlay> {
  late VideoPlayerController controller;

  bool setMute = true;
  bool isMute = true;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.url!);
    controller.initialize().then((_) {
      setState(() {});
      controller.pause();
      controller.setLooping(true);
      controller.setVolume(0);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BuzzerFeedPlay oldWidget) {
    controller.dispose();
    print(
        "important did change =${widget.url} and ${oldWidget.url == widget.url} old=${oldWidget.url}, new=${widget.url}");

    controller = VideoPlayerController.network(widget.url!);

    controller.initialize().then((_) {
      setState(() {});
      controller.play();
      controller.setLooping(true);
      controller.setVolume(0);
    });

    // controller.initialize().then((_) {
    //   setState(() {});
    //   controller.play();
    //   controller.setLooping(true);
    //   controller.setVolume(0);
    // });
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("the post id aftyyer refresh 2 url=${widget.url}");
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Container(
      height: 40.0.h,
      width: 78.0.w,
      child: controller.value != null && controller.value.isInitialized
          ? VisibilityDetector(
              key: ObjectKey(controller),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction > 0.8) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      controller.play();
                      controller.setVolume(0);
                    });
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      controller.pause();
                    });
                  });
                }
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Container(
                          color: Colors.grey.shade200,
                          width: controller.value.size?.width ?? 0,
                          height: controller.value.size?.height ?? 0,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
          : Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                      child: Image(
                    image: CachedNetworkImageProvider(widget.image!),
                    fit: BoxFit.cover,
                  )),
                ),
              ],
            ),
    );
  }
}
