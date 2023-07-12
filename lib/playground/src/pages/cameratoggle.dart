import 'package:flutter/material.dart';

class CameraMuteWidget extends StatefulWidget {
  final Function toggleMute;
  CameraMuteWidget({required this.toggleMute});
  // const MuteWidget({Key? key}) : super(key: key);s

  @override
  _CameraMuteWidgetState createState() => _CameraMuteWidgetState();
}

class _CameraMuteWidgetState extends State<CameraMuteWidget> {
  bool muted = false;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        setState(() {
          muted = !muted;
        });

        widget.toggleMute();
      },
      child: Icon(
        muted ? Icons.camera_front : Icons.video_camera_back,
        color: Colors.indigo,
        size: 35.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
    );
  }
}
