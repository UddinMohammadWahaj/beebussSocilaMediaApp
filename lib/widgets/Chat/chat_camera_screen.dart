import 'dart:io';
import 'dart:async';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/chat_galley_thumbnails.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/Chat/expanded_file_single.dart';
import 'package:bizbultest/view/create_a_shortbuz.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sizer/sizer.dart';

class GalleryThumbnails {
  AssetEntity? asset;
  bool selected = false;
  int selectedNumber = 0;
  int? assetIndex;
  int? indexNumber;
  bool isCropped = false;
  File? croppedFile;

  GalleryThumbnails(asset, selected) {
    this.asset = asset;
    this.selected = selected;
  }
}

class ChatCameraScreen extends StatefulWidget {
  final String name;
  final String memberId;
  final String? image;
  final Function? sendFile;

  const ChatCameraScreen(
      {Key? key,
      required this.memberId,
      required this.name,
      this.image,
      this.sendFile})
      : super(key: key);

  @override
  _ChatCameraScreenState createState() => _ChatCameraScreenState();
}

class _ChatCameraScreenState extends State<ChatCameraScreen> {
  bool isShowGallery = true;
  bool initialized = false;
  int _cameraIndex = 1;
  PanelController? _panelController;
  late List<GalleryThumbnails> assets = [];
  bool areAssetsLoaded = false;
  bool isMultiSelect = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  CameraController? controller;
  double? _minAvailableZoom;
  double? _maxAvailableZoom;
  List<CameraDescription> cameras = [];

  Timer? _timer;
  int _start = 0;

  List<GalleryThumbnails> multiSelectList = [];
  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.all);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    List<GalleryThumbnails> data = [];
    recentAssets.forEach((element) {
      if (element.type.toString() == "AssetType.video" ||
          element.type.toString() == "AssetType.image") {
        data.add(GalleryThumbnails(element, false));
      }
    });

    // Update the state and notify UI
    if (mounted) {
      setState(() => assets = data);
      setState(() {
        areAssetsLoaded = true;
      });
    }
  }

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

  Future<void> loadCamera() async {
    // Fetch the available cameras before initializing the app.
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();

      controller = CameraController(
        cameras[0],
        ResolutionPreset.veryHigh,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      try {
        await controller!.initialize();
        setState(() {
          initialized = true;
        });
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    } on CameraException catch (e) {
      logError(e.code, e.description!);
    }
    _fetchAssets();
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description!);
    showSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future<void> _toggleCamera() async {
    print(controller!.description.lensDirection);
    if (controller!.description.lensDirection == CameraLensDirection.back) {
      if (mounted) {
        setState(() {
          controller = CameraController(
            cameras[1],
            ResolutionPreset.veryHigh,
            enableAudio: true,
            imageFormatGroup: ImageFormatGroup.jpeg,
          );
        });
      }
      try {
        await controller!.initialize();
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    } else {
      if (mounted) {
        setState(() {
          controller = CameraController(
            cameras[0],
            ResolutionPreset.veryHigh,
            enableAudio: true,
            imageFormatGroup: ImageFormatGroup.jpeg,
          );
        });
      }
      try {
        await controller!.initialize();
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    }
  }

  void clearMultiSelectList(StateSetter setState) {
    if (isMultiSelect) {
      setState(() {
        isMultiSelect = false;
        multiSelectList = [];
        assets.forEach((element) {
          element.selected = false;
        });
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<XFile?> takePicture() async {
    if (!controller!.value.isInitialized) {
      showSnackBar(
        AppLocalizations.of('Error: select a camera first.'),
      );
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

  Future<void> startVideoRecording() async {
    if (!controller!.value.isInitialized) {
      showSnackBar(
        AppLocalizations.of('Error: select a camera first.'),
      );
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

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
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

  void onTakePictureButtonPressed() async {
    controller!.takePicture().then((file) async {
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: file.path);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExpandedFileChatSingle(
                    file: rotatedImage,
                    type: "image",
                    from: "camera",
                    name: widget.name,
                    image: widget.image!,
                    sendFile: widget.sendFile!,
                  )));
    });
  }

  void onVideoRecordButtonPressed() {
    startTimer();
    startVideoRecording().then((_) {});
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) async {
      if (file != null) {
        _timer!.cancel();
        setState(() {
          _start = 0;
        });
        var newFile = await File(file.path).create(recursive: true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpandedFileChatSingle(
                      file: newFile,
                      type: "AssetType.video",
                      from: "camera",
                      name: widget.name,
                      image: widget.image!,
                      sendFile: widget.sendFile!,
                    )));
      }
    });
  }

  Widget _buildCameraControls() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              controller?.value?.flashMode == FlashMode.off
                  ? Icons.flash_off
                  : Icons.flash_on,
              size: 30,
            ),
            color: Colors.white,
            onPressed: initialized
                ? () {
                    if (controller?.value?.flashMode == FlashMode.off) {
                      onSetFlashModeButtonPressed(FlashMode.torch);
                    } else {
                      onSetFlashModeButtonPressed(FlashMode.off);
                    }
                  }
                : null,
          ),
          GestureDetector(
              child: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: controller!.value.isRecordingVideo
                        ? Colors.red
                        : Colors.transparent,
                    foregroundColor: controller!.value.isRecordingVideo
                        ? Colors.red
                        : Colors.transparent,
                  ),
                ),
              ),
              onTap: initialized
                  ? () {
                      print("yessss");
                      if (controller == null ||
                          !controller!.value.isInitialized ||
                          controller!.value.isRecordingVideo) return;
                      onTakePictureButtonPressed();
                    }
                  : null,
              onLongPress: initialized
                  ? () {
                      if (controller == null ||
                          !controller!.value.isInitialized ||
                          controller!.value.isRecordingVideo) return;
                      onVideoRecordButtonPressed();
                    }
                  : null,
              onLongPressUp: initialized
                  ? () {
                      if (controller == null ||
                          !controller!.value.isInitialized ||
                          !controller!.value.isRecordingVideo) return;
                      onStopButtonPressed();
                    }
                  : null),
          IconButton(
            icon: Icon(
              Icons.switch_camera,
              size: 30,
            ),
            color: Colors.white,
            highlightColor: Colors.grey.withOpacity(0.3),
            splashColor: Colors.grey.withOpacity(0.3),
            onPressed: () async {
              if (controller!.description.lensDirection ==
                  CameraLensDirection.back) {
                if (controller != null) {
                  await controller!.dispose();
                }
                if (mounted) {
                  setState(() {
                    controller = CameraController(
                      cameras[1],
                      ResolutionPreset.veryHigh,
                      enableAudio: true,
                      imageFormatGroup: ImageFormatGroup.jpeg,
                    );
                  });
                }
                controller!.addListener(() {
                  if (mounted) setState(() {});
                  if (controller!.value.hasError) {
                    showSnackBar(
                      AppLocalizations.of(
                            'Camera error',
                          ) +
                          " " +
                          "${controller!.value.errorDescription}",
                    );
                  }
                });
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
                } on CameraException catch (e) {
                  _showCameraException(e);
                }
              } else {
                if (controller != null) {
                  await controller!.dispose();
                }
                if (mounted) {
                  setState(() {
                    controller = CameraController(
                      cameras[0],
                      ResolutionPreset.veryHigh,
                      enableAudio: true,
                      imageFormatGroup: ImageFormatGroup.jpeg,
                    );
                  });
                }
                controller!.addListener(() {
                  if (mounted) setState(() {});
                  if (controller!.value.hasError) {
                    showSnackBar(AppLocalizations.of(
                        'Camera error ${controller!.value.errorDescription}'));
                  }
                });
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
                } on CameraException catch (e) {
                  _showCameraException(e);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  _buildGalleryAppbar(StateSetter setState) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  clearMultiSelectList(setState);
                },
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.0.w),
                    child: Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              isMultiSelect
                  ? Text(
                      AppLocalizations.of(
                        "Tap photo to select",
                      ),
                      style: whiteBold.copyWith(fontSize: 20),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              !isMultiSelect && multiSelectList.length == 0
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isMultiSelect = true;
                        });

                        print(isMultiSelect);
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Icon(
                            Icons.check_box_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isMultiSelect = true;
                        });

                        print(isMultiSelect);
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0.w),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
      flexibleSpace: gradientContainer(null),
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildGallery() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Scaffold(
        appBar: _buildGalleryAppbar(setState),
        body: WillPopScope(
          onWillPop: () async {
            if (isMultiSelect) {
              setState(() {
                isMultiSelect = false;
                multiSelectList = [];
                assets.forEach((element) {
                  element.selected = false;
                });
              });
              return false;
            } else {
              Navigator.pop(context);
              return true;
            }
          },
          child: GridView.builder(
              controller: ModalScrollController.of(context),
              addAutomaticKeepAlives: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                return ChatGalleryThumbnailsHorizontal(
                  onTap: () {
                    if (isMultiSelect) {
                      setState(() {
                        assets[index].selected = !assets[index].selected;
                      });
                      if (assets[index].selected) {
                        multiSelectList.add(assets[index]);
                      } else {
                        multiSelectList
                            .removeWhere((element) => element == assets[index]);
                      }

                      print(multiSelectList.length);
                    } else {
                      print("not open");
                    }
                  },
                  grid: true,
                  asset: assets[index],
                );
              }),
        ),
      );
    });
  }

  @override
  void initState() {
    _panelController = PanelController();
    loadCamera();
    super.initState();
  }

  _disposeCamera() async {
    if (controller != null) {
      await controller!.dispose();
    }
  }

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.black,
        ),
      ),
      backgroundColor: Colors.black,
      body: initialized
          ? GestureDetector(
              onTap: () {
                print("mainnnn");
              },
              onVerticalDragUpdate: (details) {
                showMaterialModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    //isScrollControlled:true,
                    context: context,
                    builder: (context) {
                      return _buildGallery();
                    });
              },
              child: Container(
                  height: 100.0.h,
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: CameraPreview(controller!)),
                          ),
                          areAssetsLoaded
                              ? Positioned.fill(
                                  bottom: 125,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 75,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: assets.length,
                                          itemBuilder: (context, index) {
                                            return ChatGalleryThumbnailsHorizontal(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ExpandedFileChatSingle(
                                                              memberId: widget
                                                                  .memberId,
                                                              asset:
                                                                  assets[index],
                                                              name: widget.name,
                                                              image:
                                                                  widget.image!,
                                                              sendFile: widget
                                                                  .sendFile!,
                                                            )));
                                              },
                                              grid: false,
                                              asset: assets[index],
                                            );
                                          }),
                                    ),
                                  ),
                                )
                              : Container(),
                          Positioned.fill(
                            bottom: 210,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Icon(
                                  Icons.keyboard_arrow_up_outlined,
                                  color: Colors.white,
                                  size: 25,
                                )),
                          )
                        ],
                      ),
                      Positioned(
                          bottom: 15,
                          child: Column(
                            children: [
                              _buildCameraControls(),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                  child: Text(
                                AppLocalizations.of(
                                  'Hold for video, tap for photo',
                                ),
                                style: whiteNormal.copyWith(fontSize: 9.0.sp),
                                textAlign: TextAlign.center,
                              ))
                            ],
                          )),
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
                                          color: Colors.white,
                                          fontSize: 12.0.sp),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }
}
