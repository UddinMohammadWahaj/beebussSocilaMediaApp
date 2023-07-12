import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class ForwardSeek10s extends StatefulWidget {
  final VoidCallback? forwardSeek;

  ForwardSeek10s({Key? key, this.forwardSeek}) : super(key: key);

  @override
  _ForwardSeek10sState createState() => _ForwardSeek10sState();
}

class _ForwardSeek10sState extends State<ForwardSeek10s> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: widget.forwardSeek ?? () {},
        child: Icon(
          CustomIcons.icons8_forward_10_100,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class BackwardSeek10s extends StatefulWidget {
  final VoidCallback? backwardSeek;

  const BackwardSeek10s({Key? key, this.backwardSeek}) : super(key: key);
  @override
  _BackwardSeek10sState createState() => _BackwardSeek10sState();
}

class _BackwardSeek10sState extends State<BackwardSeek10s> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: widget.backwardSeek ?? () {},
        child: Icon(
          CustomIcons.icons8_replay_10_100,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
