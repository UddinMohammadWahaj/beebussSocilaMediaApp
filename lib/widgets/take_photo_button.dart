import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/widgets/preview_card.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/material.dart';

class CameraButton extends StatefulWidget {
  final String lastPhotoPath;
  final Animation<Offset> previewAnimation;
  final ValueNotifier<CameraOrientations>? orientation;
  final CaptureModes ?captureMode;
  final bool? isRecording;
  final Function? onTap;

  CameraButton({
    Key? key,
    required this.captureMode,
    required this.isRecording,
    this.onTap,
    required this.lastPhotoPath,
    required this.previewAnimation,
    this.orientation,
  }) : super(key: key);

  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double _scale;
  Duration _duration = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController.value;

    return GestureDetector(
      onTap: () {
        Timer(Duration(seconds: 4), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviewCardWidget(
                        lastPhotoPath: widget.lastPhotoPath,
                        previewAnimation: widget.previewAnimation,
                        orientation: widget.orientation!,
                      )));
        });
      },
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        key: ValueKey(AppLocalizations.of(
              "cameraButton",
            ) +
            ' ' +
            (widget.captureMode == CaptureModes.PHOTO
                ? AppLocalizations.of(
                    'Photo',
                  )
                : AppLocalizations.of('Video'))),
        height: 80,
        width: 80,
        child: Transform.scale(
          scale: _scale,
          child: CustomPaint(
            painter: CameraButtonPainter(
              widget.captureMode ?? CaptureModes.PHOTO,
              isRecording: widget.isRecording!,
            ),
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(_duration, () {
      _animationController.reverse();
    });

    this.widget.onTap?.call();
  }

  _onTapCancel() {
    _animationController.reverse();
  }
}

class CameraButtonPainter extends CustomPainter {
  final CaptureModes captureMode;
  final bool isRecording;

  CameraButtonPainter(
    this.captureMode, {
    this.isRecording = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var bgPainter = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    var radius = size.width / 2;
    var center = Offset(size.width / 2, size.height / 2);
    bgPainter.color = Colors.grey.withOpacity(0.3);
    canvas.drawCircle(center, radius, bgPainter);

    if (this.captureMode == CaptureModes.VIDEO && this.isRecording) {
      bgPainter.color = Colors.red;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                17,
                17,
                size.width - (17 * 2),
                size.height - (17 * 2),
              ),
              Radius.circular(12.0)),
          bgPainter);
    } else {
      bgPainter.color = captureMode == CaptureModes.PHOTO ? Colors.white : Colors.red;
      canvas.drawCircle(center, radius - 8, bgPainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
