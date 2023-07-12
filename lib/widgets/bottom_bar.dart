import 'package:bizbultest/widgets/take_photo_button.dart';
import 'package:camerawesome/models/capture_modes.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'camera_buttons.dart';

class BottomBarWidget extends StatelessWidget {
  final String? lastPhotoPath;
  final Animation<Offset>? previewAnimation;
  final ValueNotifier<CameraOrientations>? orientation2;
  final AnimationController rotationController;
  final ValueNotifier<CameraOrientations> orientation;
  final ValueNotifier<CaptureModes> captureMode;
  final bool isRecording;
  final Function onZoomInTap;
  final Function onZoomOutTap;
  final Function onCaptureTap;
  final Function onCaptureModeSwitchChange;

  const BottomBarWidget({
    Key? key,
    required this.rotationController,
    required this.orientation,
    required this.isRecording,
    required this.captureMode,
    required this.onZoomOutTap,
    required this.onZoomInTap,
    required this.onCaptureTap,
    required this.onCaptureModeSwitchChange,
    this.lastPhotoPath,
    this.previewAnimation,
    this.orientation2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        height: 45.0.h,
        child: CameraButton(
          lastPhotoPath: lastPhotoPath!,
          orientation: orientation2,
          previewAnimation: previewAnimation!,
          key: ValueKey('cameraButton'),
          captureMode: captureMode.value,
          isRecording: isRecording,
          onTap: () => onCaptureTap?.call(),
        ),
      ),
    );
  }
}
