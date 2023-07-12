// import 'file:///C:/bebuzee/main/og/bebuzee/lib/widgets/MainVideoWidgets/expanded_video_player.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandedVideoPage extends StatefulWidget {
  final String? videoURL;

  ExpandedVideoPage({Key? key, this.videoURL}) : super(key: key);

  @override
  _ExpandedVideoPageState createState() => _ExpandedVideoPageState();
}

class _ExpandedVideoPageState extends State<ExpandedVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Container(
        child: Text("data"),
        // ExpandedVideoPlayer(
        // ),
      ),
    );
  }
}
