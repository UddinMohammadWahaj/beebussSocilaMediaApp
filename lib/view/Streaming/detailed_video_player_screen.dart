import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/widgets/Streaming/detailed_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailedVideoPlayerScreen extends StatefulWidget {
  final String? video;
  final String? title;

  const DetailedVideoPlayerScreen({Key? key, this.video, this.title})
      : super(key: key);

  @override
  _DetailedVideoPlayerScreenState createState() =>
      _DetailedVideoPlayerScreenState();
}

class _DetailedVideoPlayerScreenState extends State<DetailedVideoPlayerScreen> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: DetailedVideoPlayer(
        video: widget.video!,
        title: widget.title,
      ),
    );
  }
}
