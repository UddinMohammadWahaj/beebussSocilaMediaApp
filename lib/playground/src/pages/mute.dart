import 'package:flutter/material.dart';

class MuteWidget extends StatefulWidget {
  final Function toggleMute;
  MuteWidget({required this.toggleMute});
  // const MuteWidget({Key? key}) : super(key: key);

  @override
  _MuteWidgetState createState() => _MuteWidgetState();
}

class _MuteWidgetState extends State<MuteWidget> {
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
        muted ? Icons.mic_off : Icons.mic,
        color: muted ? Colors.white : Colors.indigo,
        size: 35.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: muted ? Colors.indigo : Colors.white,
      padding: const EdgeInsets.all(15.0),
    );
  }
}
