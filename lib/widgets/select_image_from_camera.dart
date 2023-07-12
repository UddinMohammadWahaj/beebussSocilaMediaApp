import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/preview_card.dart';
import 'package:bizbultest/widgets/top_bar.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imgUtils;
// import 'package:rxdart/rxdart.dart';

import 'package:path_provider/path_provider.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

import 'bottom_bar.dart';

class PictureFromCamera extends StatefulWidget {
  // just for E2E test. if true we create our images names from datetime.
  // Else it's just a name to assert image exists
  final bool randomPhotoName;

  PictureFromCamera({this.randomPhotoName = true});

  @override
  _PictureFromCameraState createState() => _PictureFromCameraState();
}

class _PictureFromCameraState extends State<PictureFromCamera>
    with TickerProviderStateMixin {
  late String _lastPhotoPath, _lastVideoPath;
  bool _focus = false, _fullscreen = true, _isRecordingVideo = false;

  ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<double> _zoomNotifier = ValueNotifier(0);
  ValueNotifier<Size> _photoSize = ValueNotifier(Size(0, 0));
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<bool> _enableAudio = ValueNotifier(true);
  ValueNotifier<CameraOrientations> _orientation =
      ValueNotifier(CameraOrientations.PORTRAIT_UP);

  /// use this to call a take picture
  PictureController _pictureController = new PictureController();

  /// use this to record a video
  VideoController _videoController = new VideoController();

  /// list of available sizes
  late List<Size> _availableSizes;

  late AnimationController _iconsAnimationController,
      _previewAnimationController;
  late Animation<Offset> _previewAnimation;
  late Timer _previewDismissTimer;
  // StreamSubscription<Uint8List> previewStreamSub;
  late Stream<Uint8List> previewStream;

  @override
  void initState() {
    super.initState();
    _iconsAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _previewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _previewAnimation = Tween<Offset>(
      begin: Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _previewAnimationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _iconsAnimationController.dispose();
    _previewAnimationController.dispose();
    // previewStreamSub.cancel();
    _photoSize.dispose();
    _captureMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.clear,
                    size: 4.0.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.5.w),
                    child: Text(
                      AppLocalizations.of(
                        "Photo",
                      ),
                      style: blackBold.copyWith(fontSize: 17.0.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildSizedScreenCamera(),
          BottomBarWidget(
            lastPhotoPath: _lastPhotoPath,
            orientation: _orientation,
            previewAnimation: _previewAnimation,
            onZoomInTap: () {
              if (_zoomNotifier.value <= 0.9) {
                _zoomNotifier.value += 0.1;
              }
              setState(() {});
            },
            onZoomOutTap: () {
              if (_zoomNotifier.value >= 0.1) {
                _zoomNotifier.value -= 0.1;
              }
              setState(() {});
            },
            onCaptureModeSwitchChange: () {
              if (_captureMode.value == CaptureModes.PHOTO) {
                _captureMode.value = CaptureModes.VIDEO;
              } else {
                _captureMode.value = CaptureModes.PHOTO;
              }
              setState(() {});
            },
            onCaptureTap: _takePhoto,
            rotationController: _iconsAnimationController,
            orientation2: _orientation,
            isRecording: _isRecordingVideo,
            captureMode: _captureMode,
          ),
        ],
      ),
    );
  }

  Widget _buildInterface() {
    return Stack(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: TopBarWidget(
              isFullscreen: _fullscreen,
              isRecording: _isRecordingVideo,
              enableAudio: _enableAudio,
              photoSize: _photoSize,
              captureMode: _captureMode,
              switchFlash: _switchFlash,
              orientation: _orientation,
              rotationController: _iconsAnimationController,
              onFlashTap: () {
                switch (_switchFlash.value) {
                  case CameraFlashes.NONE:
                    _switchFlash.value = CameraFlashes.ON;
                    break;
                  case CameraFlashes.ON:
                    _switchFlash.value = CameraFlashes.AUTO;
                    break;
                  case CameraFlashes.AUTO:
                    _switchFlash.value = CameraFlashes.ALWAYS;
                    break;
                  case CameraFlashes.ALWAYS:
                    _switchFlash.value = CameraFlashes.NONE;
                    break;
                }
                setState(() {});
              },
              onAudioChange: () {
                this._enableAudio.value = !this._enableAudio.value;
                setState(() {});
              },
              onChangeSensorTap: () {
                this._focus = !_focus;
                if (_sensor.value == Sensors.FRONT) {
                  _sensor.value = Sensors.BACK;
                } else {
                  _sensor.value = Sensors.FRONT;
                }
              },
              onResolutionTap: () => _buildChangeResolutionDialog(),
              onFullscreenTap: () {
                this._fullscreen = !this._fullscreen;
                setState(() {});
              }),
        ),
        BottomBarWidget(
          onZoomInTap: () {
            if (_zoomNotifier.value <= 0.9) {
              _zoomNotifier.value += 0.1;
            }
            setState(() {});
          },
          onZoomOutTap: () {
            if (_zoomNotifier.value >= 0.1) {
              _zoomNotifier.value -= 0.1;
            }
            setState(() {});
          },
          onCaptureModeSwitchChange: () {
            if (_captureMode.value == CaptureModes.PHOTO) {
              _captureMode.value = CaptureModes.VIDEO;
            } else {
              _captureMode.value = CaptureModes.PHOTO;
            }
            setState(() {});
          },
          onCaptureTap: _takePhoto,
          rotationController: _iconsAnimationController,
          orientation: _orientation,
          isRecording: _isRecordingVideo,
          captureMode: _captureMode,
        ),
      ],
    );
  }

  _takePhoto() async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String filePath = widget.randomPhotoName
        ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'
        : '${testDir.path}/photo_test.jpg';
    await _pictureController.takePicture(filePath);
    // lets just make our phone vibrate
    HapticFeedback.mediumImpact();
    _lastPhotoPath = filePath;
    setState(() {});
    if (_previewAnimationController.status == AnimationStatus.completed) {
      _previewAnimationController.reset();
    }
    _previewAnimationController.forward();
    print("----------------------------------");
    print("TAKE PHOTO CALLED");
    final file = File(filePath);
    print("==> hastakePhoto : ${file.exists()} | path : $filePath");
    final img = imgUtils.decodeImage(file.readAsBytesSync());
    print("==> img.width : ${img!.width} | img.height : ${img!.height}");
    print("----------------------------------");
  }

  _buildChangeResolutionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => ListTile(
          key: ValueKey("resOption"),
          onTap: () {
            this._photoSize.value = _availableSizes[index];
            setState(() {});
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.aspect_ratio),
          title: Text(
              "${_availableSizes[index].width}/${_availableSizes[index].height}"),
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: _availableSizes.length,
      ),
    );
  }

  _onOrientationChange(CameraOrientations? newOrientation) {
    _orientation.value = newOrientation!;
    if (_previewDismissTimer != null) {
      _previewDismissTimer.cancel();
    }
  }

  _onPermissionsResult(bool? granted) {
    if (!granted!) {
      AlertDialog alert = AlertDialog(
        title: Text(
          AppLocalizations.of(
            'Error',
          ),
        ),
        content: Text(
          AppLocalizations.of(
              "It seems you doesn't authorized some permissions. Please check on your settings and try again."),
        ),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      print("granted");
    }
  }

  // /// this is just to preview images from stream
  // /// This use a bufferTime to take an image each 1500 ms
  // /// you cannot show every frame as flutter cannot draw them fast enough
  // /// [THIS IS JUST FOR DEMO PURPOSE]
  // Widget _buildPreviewStream() {
  //   if (previewStream == null) return Container();
  //   return Positioned(
  //     left: 32,
  //     bottom: 120,
  //     child: StreamBuilder(
  //       stream: previewStream.bufferTime(Duration(milliseconds: 1500)),
  //       builder: (context, snapshot) {
  //         print(snapshot);
  //         if (!snapshot.hasData || snapshot.data == null) return Container();
  //         List<Uint8List> data = snapshot.data;
  //         print(
  //             "...${DateTime.now()} new image received... ${data.last.lengthInBytes} bytes");
  //         return Image.memory(
  //           data.last,
  //           width: 120,
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget buildFullscreenCamera() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Center(
        child: CameraAwesome(
          onPermissionsResult: _onPermissionsResult,
          selectDefaultSize: (availableSizes) {
            this._availableSizes = availableSizes;
            return availableSizes[0];
          },
          captureMode: _captureMode,
          photoSize: _photoSize,
          sensor: _sensor,
          enableAudio: _enableAudio,
          switchFlashMode: _switchFlash,
          zoom: _zoomNotifier,
          onOrientationChanged: _onOrientationChange,
          // imagesStreamBuilder: (imageStream) {
          //   /// listen for images preview stream
          //   /// you can use it to process AI recognition or anything else...
          //   print("-- init CamerAwesome images stream");
          //   setState(() {
          //     previewStream = imageStream;
          //   });

          //   imageStream.listen((Uint8List imageData) {
          //     print(
          //         "...${DateTime.now()} new image received... ${imageData.lengthInBytes} bytes");
          //   });
          // },
          onCameraStarted: () {
            // camera started here -- do your after start stuff
          },
        ),
      ),
    );
  }

  Widget buildSizedScreenCamera() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 40.0.h,
              width: MediaQuery.of(context).size.width,
              child: CameraAwesome(
                onPermissionsResult: _onPermissionsResult,
                selectDefaultSize: (availableSizes) {
                  this._availableSizes = availableSizes;
                  return availableSizes[0];
                },
                captureMode: _captureMode,
                photoSize: _photoSize,
                sensor: _sensor,
                fitted: true,
                switchFlashMode: _switchFlash,
                zoom: _zoomNotifier,
                onOrientationChanged: _onOrientationChange,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TopBarWidget(
                    isFullscreen: _fullscreen,
                    isRecording: _isRecordingVideo,
                    enableAudio: _enableAudio,
                    photoSize: _photoSize,
                    captureMode: _captureMode,
                    switchFlash: _switchFlash,
                    orientation: _orientation,
                    rotationController: _iconsAnimationController,
                    onFlashTap: () {
                      switch (_switchFlash.value) {
                        case CameraFlashes.NONE:
                          _switchFlash.value = CameraFlashes.ON;
                          break;
                        case CameraFlashes.ON:
                          _switchFlash.value = CameraFlashes.AUTO;
                          break;
                        case CameraFlashes.AUTO:
                          _switchFlash.value = CameraFlashes.ALWAYS;
                          break;
                        case CameraFlashes.ALWAYS:
                          _switchFlash.value = CameraFlashes.NONE;
                          break;
                      }
                      setState(() {});
                    },
                    onAudioChange: () {
                      this._enableAudio.value = !this._enableAudio.value;
                      setState(() {});
                    },
                    onChangeSensorTap: () {
                      this._focus = !_focus;
                      if (_sensor.value == Sensors.FRONT) {
                        _sensor.value = Sensors.BACK;
                      } else {
                        _sensor.value = Sensors.FRONT;
                      }
                    },
                    onResolutionTap: () => _buildChangeResolutionDialog(),
                    onFullscreenTap: () {
                      this._fullscreen = !this._fullscreen;
                      setState(() {});
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
