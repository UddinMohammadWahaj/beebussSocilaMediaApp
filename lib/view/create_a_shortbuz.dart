// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/widgets/Shortbuz/add_tags_shortbuz.dart';
import 'package:bizbultest/widgets/Shortbuz/shortbuz_video_editor.dart';
import 'package:bizbultest/widgets/Shortbuz/upload_shortbuz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:bizbultest/widgets/Stories/multiple_story_files.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CreateShortbuz extends StatefulWidget {
  final Function? refreshFromShortbuz;
  final Function? back;
  final Function? refresh;
  final Function? setNavbar;
  final bool? from;

  CreateShortbuz(
      {Key? key,
      this.back,
      this.refresh,
      this.setNavbar,
      this.refreshFromShortbuz,
      this.from})
      : super(key: key);

  @override
  _CreateShortbuzState createState() {
    return _CreateShortbuzState();
  }
}

class AssetCustom {
  late AssetEntity asset;
  bool selected = false;
  int selectedNumber = 0;
  late int assetIndex;
  late int indexNumber;
  bool isCropped = false;
  late File croppedFile;

  AssetCustom(asset, selected) {
    this.asset = asset;
    this.selected = selected;
  }
}

List<File> allFiles = [];

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CreateShortbuzState extends State<CreateShortbuz>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  List<Uint8List> thumbs = [];

  late CameraController controller;
  late XFile imageFile;
  late XFile? videoFile;
  late VideoPlayerController? videoController;
  late VoidCallback videoPlayerListener;
  bool enableAudio = true;
  late AnimationController _flashModeControlRowAnimationController;
  late AnimationController _exposureModeControlRowAnimationController;
  late AnimationController _focusModeControlRowAnimationController;
  late double _minAvailableZoom;
  late double _maxAvailableZoom;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  bool isMultiSelection = false;
  int selectedIndex = 0;

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
        await controller.initialize();
        await Future.wait([
          controller
              .getMaxZoomLevel()
              .then((value) => _maxAvailableZoom = value),
          controller
              .getMinZoomLevel()
              .then((value) => _minAvailableZoom = value),
        ]);
        setState(() {
          initialized = true;
          camera = controller.value;
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
    _fetchAssets();
  }

  void openGallery() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        //isScrollControlled:true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
                  child: Text(
                    AppLocalizations.of(
                      "Gallery",
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 16.0.sp),
                  ),
                ),
                Container(
                  height: 70.0.h,
                  child: Stack(
                    children: [
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3,
                            childAspectRatio: 9 / 16),
                        itemCount: assets.length,
                        itemBuilder: (context, index) {
                          return AssetThumbnail(
                            isMultiOpen: isMultiSelection,
                            onTap: () async {
                              var file = await assets[index].asset.file;
                              if (assets[index].asset.videoDuration >
                                  new Duration(seconds: 120)) {
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(
                                    "Video must be less than or equal to 2 minutes",
                                  ),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.7),
                                  textColor: Colors.white,
                                  fontSize: 15.0,
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddTagsShortbuz(
                                              refreshFromShortbuz:
                                                  widget.refreshFromShortbuz,
                                              file: file,
                                              flip: false,
                                              from: widget.from,
                                            )));
                              }
                            },
                            asset: assets[index],
                            setNavbar: widget.setNavbar!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

/*
  Future<void> askPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      print("granted");
    }
    else {
     Navigator.pop(context);
    }
  }
*/

  @override
  void initState() {
    main();

    WidgetsBinding.instance.addObserver(this);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var camera;
  var scale;
  var size;
  late Timer _timer;
  int _start = 0;

  List<AssetCustom> assets = [];

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.video);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    List<AssetCustom> data = [];
    recentAssets.forEach((element) {
      if (element.type.toString() == "AssetType.video" ||
          element.type.toString() == "AssetType.image") {
        data.add(AssetCustom(element, false));
      }
    });

    // Update the state and notify UI
    setState(() => assets = data);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 150) {
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

  List<AssetCustom> multiList = [];
  List<File> files = [];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // final deviceRatio = size.width / size.height;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation

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
                widget.setNavbar!(false);
                return true;
              },
              child: Stack(
                children: <Widget>[
                  controller == null || !controller.value.isInitialized
                      ? Container()
                      : Container(
                          height: 80.0.h,
                          width: 100.0.w,
                          child: Transform.scale(
                            scale: 1,
                            child: new AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: new CameraPreview(controller),
                            ),
                          ),
                        ),
                  controller == null || !controller.value.isInitialized
                      ? Container()
                      : Positioned.fill(
                          top: 2.0.h,
                          //right: 4.0.w,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: _modeControlRowWidget()),
                        ),
                  Positioned.fill(
                    top: 1.3.h,
                    right: 6.0.w,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          constraints: BoxConstraints(),
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 4.0.h,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  controller.value.isRecordingVideo && _start > 0
                      ? Positioned.fill(
                          bottom: 23.0.h,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 0.8.h,
                                ),
                                SizedBox(width: 2.0.w),
                                Text(
                                  _start > 9 && _start < 58
                                      ? "00:" + _start.toString()
                                      : _start > 59 && _start < 60
                                          ? "01:" + "00"
                                          : _start > 60 && _start <= 69
                                              ? "01:" +
                                                  "0" +
                                                  (_start % 60).toString()
                                              : _start > 69 && _start <= 119
                                                  ? "01:" +
                                                      (_start % 60).toString()
                                                  : _start > 119 && _start < 121
                                                      ? "02:" + "00"
                                                      : _start > 121 &&
                                                              _start < 130
                                                          ? "02:0" +
                                                              (_start % 60)
                                                                  .toString()
                                                          : _start >= 130 &&
                                                                  _start < 150
                                                              ? "02:" +
                                                                  (_start % 60)
                                                                      .toString()
                                                              : _start == 150
                                                                  ? "02:30"
                                                                  : "00:0" +
                                                                      _start
                                                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0.sp),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Positioned.fill(
                    bottom: 20.0.h,
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
                        height: 20.0.h,
                        color: Colors.black,
                      )),
                  Positioned.fill(
                      bottom: 5.0.h,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _captureControlRowWidget())),
                  assets.isNotEmpty
                      ? Positioned.fill(
                          bottom: 7.0.h,
                          left: 6.0.w,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                shape: BoxShape.rectangle,
                                border: new Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              height: 4.5.h,
                              width: 9.0.w,
                              child: FutureBuilder<Uint8List?>(
                                future: assets[0].asset.thumbnailData,
                                builder: (_, snapshot) {
                                  final bytes = snapshot.data;
                                  // If we have no data, display a spinner
                                  if (bytes == null)
                                    return GestureDetector(
                                      onTap: () => openGallery(),
                                      child: Container(
                                          color: Colors.black,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 0.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.grey)))),
                                    );
                                  // If there's data, display it as an image
                                  return InkWell(
                                    onTap: () {
                                      openGallery();
                                    },
                                    child: Stack(
                                      children: [
                                        // Wrap the image in a Positioned.fill to fill the space
                                        Positioned.fill(
                                          child: Image.memory(bytes,
                                              fit: BoxFit.cover),
                                        ),
                                        // Display a Play icon if the asset is a video
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.black,
                          height: 4.5.h,
                          width: 9.0.w,
                        ),
                  controller == null || !controller.value.isInitialized
                      ? Container()
                      : Positioned.fill(
                          bottom: 7.0.h,
                          right: 4.0.w,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: () async {
                                  if (controller.description.lensDirection ==
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
                                      await controller.initialize();
                                      await Future.wait([
                                        controller.getMaxZoomLevel().then(
                                            (value) =>
                                                _maxAvailableZoom = value),
                                        controller.getMinZoomLevel().then(
                                            (value) =>
                                                _minAvailableZoom = value),
                                      ]);
                                      setState(() {
                                        camera = controller.value;
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
                                      await controller.initialize();
                                      await Future.wait([
                                        controller.getMaxZoomLevel().then(
                                            (value) =>
                                                _maxAvailableZoom = value),
                                        controller.getMinZoomLevel().then(
                                            (value) =>
                                                _minAvailableZoom = value),
                                      ]);
                                      setState(() {
                                        camera = controller.value;
                                        scale = size.aspectRatio *
                                            camera.aspectRatio;

                                        // to prevent scaling down, invert the value
                                        if (scale < 1) scale = 1 / scale;
                                      });
                                    } on CameraException catch (e) {
                                      _showCameraException(e);
                                    }
                                  }

                                  print(controller.description.lensDirection);
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
    return Listener(
      onPointerDown: (_) => _pointers++,
      onPointerUp: (_) => _pointers--,
      child: CameraPreview(
        controller,
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

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller.setZoomLevel(_currentScale);
  }

  Widget _modeControlRowWidget() {
    return Container(
      child: controller?.value?.flashMode == FlashMode.off
          ? IconButton(
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.flash_off,
                size: 3.5.h,
              ),
              color: Colors.white,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            )
          : controller?.value?.flashMode == FlashMode.torch
              ? IconButton(
                  padding: EdgeInsets.all(0),
                  constraints: BoxConstraints(),
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
                  padding: EdgeInsets.all(0),
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.flash_off,
                    size: 3.5.h,
                  ),
                  color: Colors.white,
                  onPressed: controller != null
                      ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                      : null,
                ),
    );
  }

  Widget _captureControlRowWidget() {
    return Container(
      child: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isRecordingVideo
          ? InkWell(
              onTap: () {
                onVideoRecordButtonPressed();
                startTimer();
              },
              child: CircleAvatar(
                radius: 4.5.h,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 4.1.h,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 3.8.h,
                    child: Image.asset(
                      "assets/images/circle-cropped.png",
                      fit: BoxFit.cover,
                      height: 10.0.h,
                    ),
                  ),
                ),
              ))
          : controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? InkWell(
                  onTap: () {
                    onStopButtonPressed();
                    // onStopButtonPressed();
                    _timer.cancel();
                    setState(() {
                      _start = 0;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 4.5.h,
                    child: Image.asset(
                      "assets/images/circle-cropped.png",
                      fit: BoxFit.cover,
                      height: 4.5.h,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    onVideoRecordButtonPressed();
                    startTimer();
                  },
                  child: CircleAvatar(
                    radius: 4.5.h,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 4.1.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 3.8.h,
                        child: Image.asset(
                          "assets/images/circle-cropped.png",
                          fit: BoxFit.cover,
                          height: 10.0.h,
                        ),
                      ),
                    ),
                  )),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.

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
    controller.setExposurePoint(offset);
    controller.setFocusPoint(offset);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar(AppLocalizations.of('Camera error') +
            ' ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      await Future.wait([
        controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
        controller.getMinZoomLevel().then((value) => _minAvailableZoom = value),
      ]);
      setState(() {
        camera = controller.value;
        scale = size.aspectRatio * camera.aspectRatio;

        // to prevent scaling down, invert the value
        if (scale < 1) scale = 1 / scale;
      });
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) async {
      if (mounted) {
        setState(() {
          imageFile = file!;
          videoController?.dispose();
          videoController = null;
        });
        File rotatedImage =
            await FlutterExifRotation.rotateImage(path: file!.path);
        allFiles.add(rotatedImage);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultipleStoriesView(
                      clear: () {
                        allFiles.clear();
                      },
                      filesList: allFiles,
                      file: rotatedImage,
                      path: file.path,
                      type: "image",
                      flip: controller.description.lensDirection ==
                              CameraLensDirection.back
                          ? false
                          : true,
                    )));
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) async {
      if (mounted) setState(() {});
      if (file != null) {
        videoFile = await file;
        var newFile = await File(videoFile!.path).create(recursive: true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTagsShortbuz(
                      refreshFromShortbuz: widget.refreshFromShortbuz,
                      file: newFile,
                      flip: true,
                      from: widget.from,
                    )));

        /* Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadShortbuz(
                      from: "camera",
                      refreshFromShortbuz: widget.refreshFromShortbuz,
                      video: result.hasChanges ? finalFile : newFile,
                    )));*/
      }
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar(
        AppLocalizations.of(
          'Video recording paused',
        ),
      );
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar(
        AppLocalizations.of('Video recording resumed'),
      );
    });
  }

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar(
        AppLocalizations.of(
          'Error: select a camera first.',
        ),
      );
      return;
    }

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await controller.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<Future<XFile>?> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar(
        AppLocalizations.of(
          'Error: select a camera first.',
        ),
      );
      return null;
    }

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await controller.takePicture();
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

class AssetThumbnail extends StatefulWidget {
  final Function? setNavbar;
  final VoidCallback? onTap;
  final bool? isMultiOpen;

  const AssetThumbnail({
    Key? key,
    required this.asset,
    this.setNavbar,
    this.onTap,
    this.isMultiOpen,
  }) : super(key: key);

  final AssetCustom asset;

  @override
  _AssetThumbnailState createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  late Future<Uint8List?> future;

  @override
  void initState() {
    future = widget.asset.asset.thumbnailDataWithSize(
        ThumbnailSize(
          640,
          480,
        ),
        quality: 60);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: future,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null)
          return Container(
              color: Colors.black,
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))));
        // If there's data, display it as an image
        return InkWell(
          onTap: widget.onTap ?? () {},
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (widget.asset.asset.type == AssetType.video)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 1.0.w, bottom: 1.0.w),
                    child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.5.w,
                          ),
                          child: Text(
                            widget.asset.asset.videoDuration
                                .toString()
                                .split('.')
                                .first
                                .padLeft(8, "0"),
                            style: whiteBold.copyWith(fontSize: 10.0.sp),
                          ),
                        )),
                  ),
                ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 1.5.w, top: 1.5.w),
                    child: CircleAvatar(
                      radius: 1.0.h,
                      foregroundColor: Colors.white,
                      backgroundColor: widget.isMultiOpen!
                          ? widget.asset.selected &&
                                  widget.asset.assetIndex != null
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.5)
                          : Colors.transparent,
                      child: widget.isMultiOpen!
                          ? widget.asset.selected &&
                                  widget.asset.assetIndex != null
                              ? Center(
                                  child: Text(
                                      widget.asset.indexNumber.toString(),
                                      style: whiteNormal.copyWith(
                                          fontSize: 8.0.sp)))
                              : Text("")
                          : Text(""),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MiniThumbnails extends StatefulWidget {
  const MiniThumbnails({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetCustom asset;

  @override
  _MiniThumbnailsState createState() => _MiniThumbnailsState();
}

class _MiniThumbnailsState extends State<MiniThumbnails> {
  late Future<Uint8List?> future;

  @override
  void initState() {
    future = widget.asset.asset.thumbnailData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: future,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null)
          return Container(
              color: Colors.black,
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))));
        // If there's data, display it as an image
        return Stack(
          children: [
            // Wrap the image in a Positioned.fill to fill the space
            Positioned.fill(
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
            // Display a Play icon if the asset is a video
          ],
        );
      },
    );
  }
}
