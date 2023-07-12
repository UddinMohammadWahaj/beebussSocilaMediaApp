// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:bizbultest/widgets/video_sdk.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;

import 'feedpost_video_editor.dart';

class CaptureVideo extends StatefulWidget {
  final Function? back;
  final Function? refresh;

  const CaptureVideo({Key? key, this.back, this.refresh}) : super(key: key);

  @override
  _CaptureVideoState createState() {
    return _CaptureVideoState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CaptureVideoState extends State<CaptureVideo>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  AnimationController? _flashModeControlRowAnimationController;
  Animation<double>? _flashModeControlRowAnimation;
  AnimationController? _exposureModeControlRowAnimationController;
  Animation<double>? _exposureModeControlRowAnimation;
  AnimationController? _focusModeControlRowAnimationController;
  Animation<double>? _focusModeControlRowAnimation;
  double? _minAvailableZoom;
  double? _maxAvailableZoom;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  List<CameraDescription> cameras = [];
  bool initialized = false;

  Future<void> main() async {
    // Fetch the available cameras before initializing the app.
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();

      controller = CameraController(
        cameras[0],
        ResolutionPreset.veryHigh,
        enableAudio: enableAudio,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      try {
        await controller!.initialize();
        await Future.wait([
          controller!
              .getMinExposureOffset()
              .then((value) => _minAvailableExposureOffset = value),
          controller!
              .getMaxExposureOffset()
              .then((value) => _maxAvailableExposureOffset = value),
          controller!
              .getMaxZoomLevel()
              .then((value) => _maxAvailableZoom = value),
          controller!
              .getMinZoomLevel()
              .then((value) => _minAvailableZoom = value),
        ]);
        setState(() {
          initialized = true;
          camera = controller!.value;
          scale = size.aspectRatio * camera.aspectRatio;

          // to prevent scaling down, invert the value
          if (scale < 1) scale = 1 / scale;
        });
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    } on CameraException catch (e) {
      logError(e.code, e.description!);
    }
  }

  @override
  void initState() {
    main();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController!.view,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController!.view,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController!.view,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController!.dispose();
    _exposureModeControlRowAnimationController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {}
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var camera;
  var scale;
  var size;
  Timer? _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 60) {
          onStopButtonPressed();

          if (mounted) {
            setState(() {
              timer.cancel();
              _start = 0;
            });
            // onStopButtonPressed();
          }
        } else {
          if (mounted) {
            setState(() {
              _start++;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Text(
            AppLocalizations.of(
              'Video',
            ),
            style: TextStyle(color: Colors.black, fontSize: 15.0.sp),
          ),
        ),
      ),
      body: initialized
          ? WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                widget.back!();
                return true;
              },
              child: Stack(
                children: <Widget>[
                  controller == null || !controller!.value.isInitialized
                      ? Container()
                      : Transform.scale(
                          scale: scale,
                          child: Center(
                            child: CameraPreview(controller!),
                          ),
                        ),
                  controller!.value.isRecordingVideo && _start > 0
                      ? Positioned.fill(
                          top: 3.0.h,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 0.8.h,
                                ),
                                SizedBox(width: 2.0.w),
                                Text(
                                  _start > 9
                                      ? "00:" + _start.toString()
                                      : _start > 59
                                          ? "01:" + "00"
                                          : "00:0" + _start.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0.sp),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Positioned.fill(
                    bottom: 15.0.h,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 100.0.w,
                        child: LinearProgressIndicator(
                          backgroundColor:
                              _start > 0 ? Colors.amber : Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.red,
                          ),
                          value: ((10 / 6) * _start) / 100,
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 100.0.w,
                        height: 15.0.h,
                        color: Colors.black.withOpacity(0.3),
                      )),
                  Positioned.fill(
                      bottom: 2.5.h,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _captureControlRowWidget())),
                  controller == null || !controller!.value.isInitialized
                      ? Container()
                      : Positioned.fill(
                          bottom: 4.0.h,
                          right: 4.0.w,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: _modeControlRowWidget()),
                        ),
                  controller == null || !controller!.value.isInitialized
                      ? Container()
                      : Positioned.fill(
                          bottom: 4.0.h,
                          left: 4.0.w,
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: IconButton(
                                onPressed: () async {
                                  if (controller!.description.lensDirection ==
                                      CameraLensDirection.back) {
                                    if (mounted) {
                                      setState(() {
                                        controller = CameraController(
                                          cameras[1],
                                          ResolutionPreset.veryHigh,
                                          enableAudio: enableAudio,
                                          imageFormatGroup:
                                              ImageFormatGroup.jpeg,
                                        );
                                      });
                                    }
                                    try {
                                      await controller!.initialize();
                                      await Future.wait([
                                        controller!.getMinExposureOffset().then(
                                            (value) =>
                                                _minAvailableExposureOffset =
                                                    value),
                                        controller!.getMaxExposureOffset().then(
                                            (value) =>
                                                _maxAvailableExposureOffset =
                                                    value),
                                        controller!.getMaxZoomLevel().then(
                                            (value) =>
                                                _maxAvailableZoom = value),
                                        controller!.getMinZoomLevel().then(
                                            (value) =>
                                                _minAvailableZoom = value),
                                      ]);
                                      setState(() {
                                        camera = controller!.value;
                                        scale = size.aspectRatio *
                                            camera.aspectRatio;

                                        // to prevent scaling down, invert the value
                                        if (scale < 1) scale = 1 / scale;
                                      });
                                    } on CameraException catch (e) {
                                      _showCameraException(e);
                                    }
                                  } else {
                                    if (mounted) {
                                      setState(() {
                                        controller = CameraController(
                                          cameras[0],
                                          ResolutionPreset.veryHigh,
                                          enableAudio: enableAudio,
                                          imageFormatGroup:
                                              ImageFormatGroup.jpeg,
                                        );
                                      });
                                    }
                                    try {
                                      await controller!.initialize();
                                      await Future.wait([
                                        controller!.getMinExposureOffset().then(
                                            (value) =>
                                                _minAvailableExposureOffset =
                                                    value),
                                        controller!.getMaxExposureOffset().then(
                                            (value) =>
                                                _maxAvailableExposureOffset =
                                                    value),
                                        controller!.getMaxZoomLevel().then(
                                            (value) =>
                                                _maxAvailableZoom = value),
                                        controller!.getMinZoomLevel().then(
                                            (value) =>
                                                _minAvailableZoom = value),
                                      ]);
                                      setState(() {
                                        camera = controller!.value;
                                        scale = size.aspectRatio *
                                            camera.aspectRatio;

                                        // to prevent scaling down, invert the value
                                        if (scale < 1) scale = 1 / scale;
                                      });
                                    } on CameraException catch (e) {
                                      _showCameraException(e);
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.flip_camera_ios_rounded,
                                  color: Colors.white,
                                  size: 4.0.h,
                                ),
                              )),
                        ),
                ],
              ),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return Text(
        AppLocalizations.of(
          'Tap a camera',
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom!, _maxAvailableZoom!);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null && imageFile == null
                ? Container()
                : SizedBox(
                    child: (videoController == null)
                        ? Image.file(File(imageFile!.path))
                        : Container(
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      videoController!.value.size != null
                                          ? videoController!.value.aspectRatio
                                          : 1.0,
                                  child: VideoPlayer(videoController!)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                          ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  /// Display a bar with buttons to change the flash and exposure modes
  Widget _modeControlRowWidget() {
    return Container(
      child: controller?.value?.flashMode == FlashMode.off
          ? IconButton(
              icon: Icon(
                Icons.flash_off,
                size: 4.0.h,
              ),
              color: Colors.white,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            )
          : controller?.value?.flashMode == FlashMode.torch
              ? IconButton(
                  icon: Icon(
                    Icons.flash_on,
                    size: 4.0.h,
                  ),
                  color: Colors.white,
                  onPressed: controller != null
                      ? () => onSetFlashModeButtonPressed(FlashMode.off)
                      : null,
                )
              : IconButton(
                  icon: Icon(
                    Icons.flash_off,
                    size: 4.0.h,
                  ),
                  color: Colors.white,
                  onPressed: controller != null
                      ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                      : null,
                ),
    );
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation!,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(Icons.flash_off),
              color: controller?.value?.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.flash_auto),
              color: controller?.value?.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.flash_on),
              color: controller?.value?.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.always)
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.highlight),
              color: controller?.value?.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Container(
      child: controller != null &&
              controller!.value.isInitialized &&
              !controller!.value.isRecordingVideo
          ? InkWell(
              onTap: () {
                onVideoRecordButtonPressed();
                startTimer();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/images/circle-cropped.png",
                  fit: BoxFit.cover,
                  height: 10.0.h,
                ),
                /*child: CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  radius: 3.8.h,
                ),*/
              ),
            )
          : controller != null &&
                  controller!.value.isInitialized &&
                  controller!.value.isRecordingVideo
              ? InkWell(
                  onTap: () {
                    onStopButtonPressed();
                    // onStopButtonPressed();
                    _timer!.cancel();
                    setState(() {
                      _start = 0;
                    });
                  },
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 4.5.h,
                      child: Icon(
                        Icons.stop,
                        color: Colors.red,
                        size: 4.5.h,
                      )),
                )
              : InkWell(
                  onTap: () {
                    onVideoRecordButtonPressed();
                    startTimer();
                  },
                  child: CircleAvatar(
                    radius: 4.5.h,
                    child: Image.asset(
                      "assets/images/circle-cropped.png",
                      fit: BoxFit.cover,
                      height: 9.0.h,
                    ),
                    /*child: CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  radius: 3.8.h,
                ),*/
                  ),
                ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use

    ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        // ignore: unnecessary_null_comparison
        if (file != null)
          showInSnackBar(AppLocalizations.of(
                'Picture saved to',
              ) +
              ' ${file.path}');
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController!.value == 1) {
      _flashModeControlRowAnimationController!.reverse();
    } else {
      _flashModeControlRowAnimationController!.forward();
      _exposureModeControlRowAnimationController!.reverse();
      _focusModeControlRowAnimationController!.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController!.value == 1) {
      _exposureModeControlRowAnimationController!.reverse();
    } else {
      _exposureModeControlRowAnimationController!.forward();
      _flashModeControlRowAnimationController!.reverse();
      _focusModeControlRowAnimationController!.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController!.value == 1) {
      _focusModeControlRowAnimationController!.reverse();
    } else {
      _focusModeControlRowAnimationController!.forward();
      _flashModeControlRowAnimationController!.reverse();
      _exposureModeControlRowAnimationController!.reverse();
    }
  }

  void onCaptureOrientationLockButtonPressed() async {
    if (controller != null) {
      if (controller!.value.isCaptureOrientationLocked) {
        await controller!.unlockCaptureOrientation();
        showInSnackBar(
          AppLocalizations.of(
            'Capture orientation unlocked',
          ),
        );
      } else {
        await controller!.lockCaptureOrientation();
        showInSnackBar(AppLocalizations.of(
              "Capture orientation locked to",
            ) +
            ' ${controller!.value.lockedCaptureOrientation.toString().split('.').last}');
      }
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar(AppLocalizations.of(
            "Exposure mode set to",
          ) +
          ' ${mode.toString().split('.').last}');
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar(AppLocalizations.of(
            "Focus mode set to",
          ) +
          ' ${mode.toString().split('.').last}');
    });
  }

  List<File> finalFiles = [];

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FeedPostVideoEditor(
                  from: "capture",
                  refresh: widget.refresh,
                  file: newFile,
                )));*/
    stopVideoRecording().then((file) async {
      if (mounted) setState(() {});
      if (file != null) {
        videoFile = file;
        var newFile = await File(file.path).create(recursive: true);
        List<File> finalFiles = [];
        print("dharmik vio${newFile}");
        finalFiles.add(newFile);

        Get.dialog(ProcessingDialog(
          title: AppLocalizations.of(
            "Processing...",
          ),
          heading: "",
        ));
        VideoPlayerController videoController =
            VideoPlayerController.file(newFile);
        videoController.initialize().then((value) {
          setState(() {});
          videoController.pause();
          videoController.setLooping(true);
          videoController.setVolume(0);
        });
        Uint8List? unit8list;
        unit8list = await vt.VideoThumbnail.thumbnailData(
          video: newFile.path,
          imageFormat: vt.ImageFormat.JPEG,
          // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 50,
        );

        log("dharmik${unit8list}");
        Get.back();
        Get.to(()=>UploadPost(
                      unit8list: unit8list!,
                       hasVideo: 1,
                      
                      crop: 1,
                     
                      from: 'editor',
                      // refresh: widget.refresh!,
                      finalFiles: finalFiles,
                     
                      clear: () {
                        setState(() {
                          finalFiles.clear();
                        });
                      },
                      videoHeight: videoController.value.size.height.toInt(),
                      videoWidth: videoController.value.size.width.toInt(),
                    ));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => UploadPost(
        //               unit8list: unit8list!,
        //               crop: 1,
        //               hasVideo: 1,
        //               from: 'editor',
        //               refresh: widget.refresh!,
        //               finalFiles: finalFiles,
        //               clear: () {
        //                 setState(() {
        //                   finalFiles.clear();
        //                 });
        //               },
        //               videoHeight: videoController.value.size.height.toInt(),
        //               videoWidth: videoController.value.size.width.toInt(),
        //             ))).then((value) {
        //   videoController.dispose();
        // });
      }
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    if (!controller!.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (controller!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await controller!.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller!.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vController =
        VideoPlayerController.file(File(videoFile!.path));
    videoPlayerListener = () {
      if (videoController != null && videoController!.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  Future<XFile?> takePicture() async {
    if (!controller!.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await controller!.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description!);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
