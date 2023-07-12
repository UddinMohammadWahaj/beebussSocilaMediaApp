// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Stories/multiple_story_files.dart';
import 'package:bizbultest/widgets/Stories/share_story.dart';
import 'package:bizbultest/widgets/Stories/stickers_page.dart';
import 'package:bizbultest/widgets/Stories/story_widgets.dart';
import 'package:bizbultest/widgets/Stories/timeWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

import '../api/api.dart';

class CreateStory extends StatefulWidget {
  final Function? back;
  final Function? refreshFromMultipleStories;
  final Function? setNavbar;
  final String? whereFrom;
  final String? questionsTextData;

  CreateStory(
      {Key? key,
      this.back,
      this.refreshFromMultipleStories,
      this.setNavbar,
      this.whereFrom,
      this.questionsTextData})
      : super(key: key);

  @override
  _CreateStoryState createState() {
    return _CreateStoryState();
  }
}

class AssetCustom {
  AssetEntity? asset;
  File? imageFromCamera;
  bool? selected = false;
  int? selectedNumber = 0;
  int? assetIndex;
  int? indexNumber;
  bool isCropped = false;
  var durationVideo = '';
  File? croppedFile;
  int isFrom = 1; // 1 -> gallery , 2 -> camera

  AssetCustom(asset, selected, isFrom) {
    this.asset = asset;
    this.selected = selected;
  }
  AssetCustom.fromFile(file, selected, isFrom) {
    this.imageFromCamera = file;
    this.selected = selected;
  }
}

List<File> allFiles = [];

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CreateStoryState extends State<CreateStory>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  List<Uint8List> thumbs = [];
  var thisplayer = AudioPlayer();
  late CameraController controller;
  late XFile imageFile;
  late XFile videoFile;
  late VideoPlayerController? videoController;
  late VoidCallback videoPlayerListener;
  late bool enableAudio = true;
  late double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  late double _minAvailableZoom;
  late double _maxAvailableZoom;
  late double _currentScale = 1.0;
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
              .getMinExposureOffset()
              .then((value) => _minAvailableExposureOffset = value),
          controller
              .getMaxExposureOffset()
              .then((value) => _maxAvailableExposureOffset = value),
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
          scale = (size?.aspectRatio ?? 1.0) * camera.aspectRatio;
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
    tagData = TagsClass(
      offset.dx,
      offset.dy,
      textViewTextController.text,
      1.0,
      selectedColor,
      roboto,
    );

    WidgetsBinding.instance.addObserver(this);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );

    if (widget.questionsTextData != null &&
        widget.questionsTextData != "" &&
        widget.questionsTextData!.split('~~').length == 2) {
      questionsReplyViewData = StickerClass(
        0.0,
        -350.0,
        widget.questionsTextData!.split("~~")[0],
        1.0,
        "-1",
        extraName: widget.questionsTextData!.split("~~")[1],
      );
    }
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          keyboardVisible = visible;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    thisplayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
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
  Timer? _timer;
  int _start = 0;

  List<AssetCustom> assets = [];

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
    List<AssetCustom> data = [];
    recentAssets.forEach((element) {
      if (element.type.toString() == "AssetType.video" ||
          element.type.toString() == "AssetType.image") {
        data.add(AssetCustom(element, false, 1));
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
        if (_start == 60) {
          onStopButtonPressed();

          if (mounted) {
            print("video timer=${timer.tick}");
            setState(() {
              timer.cancel();
              _start = 0;
            });
            // onStopButtonPressed();
          }
        } else {
          if (mounted) {
            print("video timer=${_start}");
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

  // Future<void> uploadStory(
  //     String allTags,
  //     String stickers,
  //     String location,
  //     String mentions,
  //     String hashtag,
  //     String timeView,
  //     String questions,
  //     File file) async {
  //   // String url1 =
  //   // "https://www.upload.bebuzee.com/story_upload_api.php?action=upload_text_story_post&tagged_member=$allTags&questions=$questions&stickers=$stickers&locationtext=$location&mantion=$mentions&hashtag=$hashtag&timeView=$timeView&user_id=${CurrentUser().currentUser.memberID}&storytype=text_story&background_colors=0612FA,E2821E";

  //   // String url = "https://www.bebuzee.com/api/upload_text_story.php";
  //   String url = 'http://www.bebuzee.com/api/storyAdd';
  //   var testdata = {
  //     "tagged_member": allTags,
  //     "questions": questions,
  //     "stickers": stickers,
  //     "locationtext": location,
  //     "mantion": mentions,
  //     "hashtag": hashtag,
  //     "timeView": timeView,
  //     "user_id": CurrentUser().currentUser.memberID,
  //     "storytype": "text_story",
  //     "music": musicViewData != null
  //         ? "${musicViewData.musicdata.songTitle}^^${musicViewData.musicdata.songArtist}^^${musicViewData.musicdata.songImageUrl}^^${musicViewData.musicdata.songUrl}"
  //         : "",
  //     "background_colors": "0612FA,E2821E",
  //     "music_style":
  //         musicViewData != null ? musicViewData.musicdata.style : "liststyle",
  //     "music_data": musicViewData != null
  //         ? musicViewData.name.replaceAll("#", "") +
  //             "^^" +
  //             musicViewData.posx.toString() +
  //             "^^" +
  //             musicViewData.posy.toString() +
  //             "^^" +
  //             musicViewData.scale.toString() +
  //             "^^" +
  //             musicViewData.rotation.toString()
  //         : null,
  //     "user_id": CurrentUser().currentUser.memberID,
  //   };
  //   print("testdata=${testdata}");
  //   var feedController = Get.put(FeedController());
  //   feedController.uploadFeedPost(
  //       [file],
  //       url,
  //       {
  //         "tagged_member": allTags,
  //         "questions": questions,
  //         "stickers": stickers,
  //         "locationtext": location,
  //         "mantion": mentions,
  //         "hashtag": hashtag,
  //         "timeView": timeView,
  //         "storytype": "text_story",
  //         "music": musicViewData != null
  //             ? "${musicViewData.musicdata.songTitle}^^${musicViewData.musicdata.songArtist}^^${musicViewData.musicdata.songImageUrl}^^${musicViewData.musicdata.songUrl}"
  //             : "",
  //         "background_colors": "0612FA,E2821E",
  //         "music_style": musicViewData != null
  //             ? musicViewData.musicdata.style
  //             : "liststyle",
  //         "music_data": musicViewData != null
  //             ? musicViewData.name.replaceAll("#", "") +
  //                 "^^" +
  //                 musicViewData.posx.toString() +
  //                 "^^" +
  //                 musicViewData.posy.toString() +
  //                 "^^" +
  //                 musicViewData.scale.toString() +
  //                 "^^" +
  //                 musicViewData.rotation.toString()
  //             : null,
  //         "user_id": CurrentUser().currentUser.memberID,
  //       });
  // }
  Future<void> uploadStory(
    String allTags,
    String stickers,
    String location,
    String mentions,
    String hashtag,
    String timeView,
    String questions,
  ) async {
    // String url1 =
    // "https://www.upload.bebuzee.com/story_upload_api.php?action=upload_text_story_post&tagged_member=$allTags&questions=$questions&stickers=$stickers&locationtext=$location&mantion=$mentions&hashtag=$hashtag&timeView=$timeView&user_id=${CurrentUser().currentUser.memberID}&storytype=text_story&background_colors=0612FA,E2821E";

    String url = "https://www.bebuzee.com/api/storyAdd";
// https://www.bebuzee.com/api/upload_text_story.php
    var datatoupload = {
      "tagged_person": allTags,
      "questions": questions,
      "stickers": stickers,
      "locationtext": location,
      "mantion": mentions,
      "hashtag": hashtag,
      "timeView": timeView,
      "user_id": CurrentUser().currentUser.memberID,
      "storytype": "text_story",
      "background_colors": "0612FA,E2821E",
      "user_id": CurrentUser().currentUser.memberID,
      "music_style":
          musicViewData != null ? musicViewData!.musicdata!.style : "liststyle",
      "music_data": musicViewData != null
          ? musicViewData!.name!.replaceAll("#", "") +
              "^^" +
              musicViewData!.posx.toString() +
              "^^" +
              musicViewData!.posy.toString() +
              "^^" +
              musicViewData!.scale.toString() +
              "^^" +
              musicViewData!.rotation.toString()
          : null,
    };
    var textstorydata = {
      "tagged_member": allTags,
      "questions": questions,
      "stickers": stickers,
      "locationtext": location,
      "mantion": mentions,
      "hashtag": hashtag,
      "timeView": timeView,
      "user_id": CurrentUser().currentUser.memberID,
      "storytype": "text_story",
      "background_colors": "0612FA,E2821E",
      "user_id": CurrentUser().currentUser.memberID,
      "music_style":
          musicViewData != null ? musicViewData!.musicdata!.style : "liststyle",
      "music_data": musicViewData != null
          ? musicViewData!.name!.replaceAll("#", "") +
              "^^" +
              musicViewData!.posx.toString() +
              "^^" +
              musicViewData!.posy.toString() +
              "^^" +
              musicViewData!.scale.toString() +
              "^^" +
              musicViewData!.rotation.toString()
          : null,
    };
    print("data to upload=${datatoupload}");
    print("data to upload 2=${textstorydata}");
    // var res;
    // try {
    //   var formdata = dio.FormData();
    //   datatoupload.forEach((key, value) {
    //     formdata.fields.add(MapEntry(key, value));
    //   });
    //   res = await ApiProvider()
    //       .fireApiWithParamsPost(url, params: datatoupload)
    //       .then((value) => value);
    //   print("result upload=${res}");
    // } catch (e) {
    //   print("error dio=${e}");
    // }
    // return;

    var feedController = Get.put(FeedController());

    feedController.uploadFeedPost(allFiles, url, textstorydata

        // {
        //   "tagged_member": allTags,
        //   "questions": questions,
        //   "stickers": stickers,
        //   "locationtext": location,
        //   "mantion": mentions,
        //   "hashtag": hashtag,
        //   "timeView": timeView,
        //   "user_id": CurrentUser().currentUser.memberID,
        //   "storytype": "text_story",
        //   "background_colors": "0612FA,E2821E",
        //   "user_id": CurrentUser().currentUser.memberID,
        //   "music_style":
        //       musicViewData != null ? musicViewData.musicdata.style : "liststyle",
        //   "music_data": musicViewData != null
        //       ? musicViewData.name.replaceAll("#", "") +
        //           "^^" +
        //           musicViewData.posx.toString() +
        //           "^^" +
        //           musicViewData.posy.toString() +
        //           "^^" +
        //           musicViewData.scale.toString() +
        //           "^^" +
        //           musicViewData.rotation.toString()
        //       : null,
        // }

        );
  }

  Future<void> uploadStory1(String path) async {
    var request = mp.MultipartRequest();
    request.setUrl(
        "https://www.upload.bebuzee.com/story_upload_api.php?action=upload_story_post&tagged_member=&user_id=${CurrentUser().currentUser.memberID}&tagged_user_ids=");

    request.addFile("files[]", path);
    if (widget.whereFrom == "profile") {
      setState(() {
        CurrentUser().currentUser.storyRequest = request;
        widget.refreshFromMultipleStories!();
      });
    } else {
      widget.refreshFromMultipleStories!(request);
    }
  }

  void publishStory() async {
    List<String> tags = [];
    List<String> stickers = [];
    List<String> mentionsText = [];

    var uint8list = await screenshotController.capture().then((value) => value);
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(uint8list!);

    for (int i = 0; i < tagsList.length; i++) {
      tags.add("video_" +
          (i + 1).toString() +
          "^^" +
          tagsList[i].posx.toString() +
          "^^" +
          tagsList[i].posy.toString() +
          "^^" +
          tagsList[i].name!.replaceAll("#", "@@@") +
          "^^" +
          "${tagsList[i].color!.red.toString() + "," + tagsList[i].color!.green.toString() + "," + tagsList[i].color!.blue.toString()}" +
          "^^" +
          tagsList[i].font!.fontFamily.toString() +
          "^^" +
          tagsList[i].scale.toString() +
          "^^" +
          100.0.h.toString() +
          // tagsList[i].h.toString() +
          "^^" +
          100.0.w.toString());
      // tagsList[i].w.toString());
    }

    for (int i = 0; i < stickerList.length; i++) {
      stickers.add("image_" +
          (0 + 1).toString() +
          "^^" +
          stickerList[i].posx.toString() +
          "^^" +
          stickerList[i].posy.toString() +
          "^^" +
          stickerList[i].name!.replaceAll("#", "@@@") +
          "^^" +
          stickerList[i].id! +
          "^^" +
          stickerList[i].scale.toString());
    }

    for (int i = 0; i < mentionUserList.length; i++) {
      mentionsText.add("mention_" +
          (i + 1).toString() +
          "^^" +
          mentionUserList[i].name!.trim().replaceAll("#", "") +
          "^^" +
          mentionUserList[i].posx.toString() +
          "^^" +
          mentionUserList[i].posy.toString() +
          "^^" +
          mentionUserList[i].scale.toString());
    }

    showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        context: context,
        builder: (BuildContext bc) {
          return ShareStory(
            onTap: () {
              uploadStory(
                tags.join("~~~"),
                stickers.join("~~~"),
                locationViewData != null && locationViewData!.name!.trim() != ""
                    ? "${locationViewData!.name!.trim().replaceAll(", ", "@@@")}^^${locationViewData!.posx}^^${locationViewData!.posy}^^${locationViewData!.scale}^^${locationViewData!.rotation}"
                    : "",
                mentionsText.join("~~~"),
                hashtagViewData != null &&
                        hashtagViewData!.name!.trim().replaceAll("#", "") != ""
                    ? "${hashtagViewData!.name!.trim().replaceAll("#", "")}^^${hashtagViewData!.posx}^^${hashtagViewData!.posy}^^${hashtagViewData!.scale}^^${hashtagViewData!.rotation}"
                    : "",
                timeViewData != null
                    ? "${timeViewData!.name}^^${timeViewData!.posx}^^${timeViewData!.posy}^^${timeViewData!.scale}^^${timeViewData!.rotation}"
                    : "",
                questionsViewData != null
                    ? "${questionsViewData!.name}^^${questionsViewData!.posx}^^${questionsViewData!.posy}^^${questionsViewData!.scale}^^${questionsViewData!.rotation}"
                    : "",
              );
              // uploadStory(
              //     tags.join("~~~"),
              //     stickers.join("~~~"),
              //     locationViewData != null && locationViewData.name.trim() != ""
              //         ? "${locationViewData.name.trim().replaceAll(", ", "@@@")}^^${locationViewData.posx}^^${locationViewData.posy}^^${locationViewData.scale}^^${locationViewData.rotation}"
              //         : "",
              //     mentionsText.join("~~~"),
              //     hashtagViewData != null &&
              //             hashtagViewData.name.trim().replaceAll("#", "") != ""
              //         ? "${hashtagViewData.name.trim().replaceAll("#", "")}^^${hashtagViewData.posx}^^${hashtagViewData?.posy}^^${hashtagViewData?.scale}^^${hashtagViewData.rotation}"
              //         : "",
              //     timeViewData != null
              //         ? "${timeViewData.name}^^${timeViewData.posx}^^${timeViewData.posy}^^${timeViewData.scale}^^${timeViewData.rotation}"
              //         : "",
              //     questionsViewData != null
              //         ? "${questionsViewData.name}^^${questionsViewData.posx}^^${questionsViewData.posy}^^${questionsViewData.scale}^^${questionsViewData.rotation}"
              //         : "",
              //     file);
              Navigator.pop(bc);
              Navigator.pop(bc);
            },
          );
        });
  }

  bool isTextView = false;

  TextEditingController textViewTextController = TextEditingController();

  List<TagsClass> tagsList = [];
  Offset offset = Offset.zero;

  bool showColors = false;
  bool showFonts = true;

  int selectedFontIndex = 5;
  Color selectedColor = Colors.white;
  ScreenshotController screenshotController = new ScreenshotController();
  List<TextStyle> fontsList = [
    GoogleFonts.raleway(),
    GoogleFonts.playfairDisplay(),
    GoogleFonts.openSansCondensed(),
    GoogleFonts.anton(),
    GoogleFonts.bebasNeue(),
    GoogleFonts.roboto(),
    GoogleFonts.dancingScript(),
    // GoogleFonts.amaticaSc(),
    GoogleFonts.sacramento(),
    GoogleFonts.specialElite(),
    GoogleFonts.poiretOne(),
    GoogleFonts.monoton(),
    GoogleFonts.fingerPaint(),
    GoogleFonts.vastShadow(),
    GoogleFonts.flavors(),
    GoogleFonts.ribeyeMarrow(),
    GoogleFonts.jomhuria(),
    GoogleFonts.zillaSlabHighlight(),
    GoogleFonts.monofett()
  ];

  List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.red,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.cyanAccent,
    Colors.teal,
  ];

  TextStyle roboto = GoogleFonts.roboto();
  bool showTextField = false;
  int currentEditingTag = -1;
  bool keyboardVisible = false;

  void onTap() {
    print("showtextfield=$showTextField ${currentEditingTag}");

    setState(() {
      showTextField = !showTextField;
    });
    if (showTextField) {
      //Timer(Duration(milliseconds: 500), () {
      setState(() {
        showFonts = true;
        showColors = false;
        //     .replaceAll("EdgeInsets", "")
        //     .replaceAll("(", "")
        //     .replaceAll(")", "")
        //     .split(", ")[3]);
      });
      print(CurrentUser().currentUser.keyBoardHeight);
      //});
    }

    if (showTextField &&
        textViewTextController.text != "" &&
        currentEditingTag < 0) {
      setState(() {
        showFonts = false;
        showColors = false;
        offset = Offset.zero;
        // tagsList.add(new TagsClass(offset.dx, offset.dy, textViewTextController.text, 1.0, selectedColor, roboto));
        tagsList = [
          TagsClass(offset.dx, offset.dy, textViewTextController.text,
              _baseScaleFactor, selectedColor, roboto)
        ];
        print("taglist=${tagsList}");
        // textViewTextController.text = "";
      });

      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   final RenderBox box = tagsList[tagsList.length - 1].key.currentContext.findRenderObject();
      //   // setState(() {
      //   //   tagsList[tagsList.length - 1].w = box.size.width;
      //   //   tagsList[tagsList.length - 1].h = box.size.height;
      //   // });
      // });
    } else {
      setState(() {
        currentEditingTag = -1;
        tagsList = [
          TagsClass(offset.dx, offset.dy, textViewTextController.text,
              _baseScaleFactor, selectedColor, roboto)
        ];
      });
    }
  }

  late TagsClass tagData;

  double _baseScaleFactor = 1.0;

  bool deleteIconColor = false;

  Offset deletePosition = Offset(0, 0);

  GlobalKey deleteKey = new GlobalKey();

  bool isTagSelected = false;

  void calculatePosition() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final RenderObject? box = deleteKey.currentContext!.findRenderObject();

      final RenderRepaintBoundary? box =
          deleteKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      setState(() {
        deletePosition = box!.localToGlobal(Offset.zero);
      });
    });
  }

  List<StickerClass> stickerList = [];

   StickerClass? mainImageViewData;
   StickerClass? timeViewData;
   StickerClass? hashtagViewData;
   StickerClass? questionsViewData;
   bool ismusicViewAdd = false;
   StickerClass? musicViewData;
  StickerClass? questionsReplyViewData;
   StickerClass? locationViewData;
   List<TagsClass> mentionUserList = [];
   List<String> mentionUserIdList = [];
  bool isTimeViewAdd = false;
  bool ishastagViewAdd = false;
  bool islocationViewAdd = false;
  bool isquestionsViewAdd = false;
  bool ismentionUserViewAdd = false;
  var currentDuration = Duration(seconds: 0);
  void _showStickersPage() {
    showMaterialModalBottomSheet(
        backgroundColor: Colors.black38,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        //isScrollControlled:true,
        context: context,
        builder: (stickerContext) {
          return StickersPage(
            stickerDetails: (name, id) {
              setState(() {
                offset = Offset.zero;
                stickerList
                    .add(new StickerClass(offset.dx, offset.dy, name, 1.0, id));
              });
              Navigator.pop(stickerContext);
            },
            emojiDetails: (name, id) {
              setState(() {
                offset = Offset.zero;
                stickerList
                    .add(new StickerClass(offset.dx, offset.dy, name, 1.0, id));
              });
              Navigator.pop(stickerContext);
            },
            gifsDetails: (name, id) {
              setState(() {
                offset = Offset.zero;
                stickerList
                    .add(new StickerClass(offset.dx, offset.dy, name, 1.0, id));
              });
              Navigator.pop(stickerContext);
            },
            activitySelect: (String type,
                {song_id: '',
                song_image_url: '',
                song_title: '',
                song_artist: '',
                song_url: ''}) {
              if (type == "music") {
                openMusicInputView(
                  song_id: song_id,
                  song_image_url: song_image_url,
                  song_title: song_title,
                  song_artist: song_artist,
                  song_url: song_url,
                );
              }

              if (type == "time") {
                setState(() {
                  isTimeViewAdd = true;
                  timeViewData = StickerClass(offset.dx, offset.dy,
                      DateTime.now().toIso8601String(), 1.0, "-1");
                });
              }
              if (type == "hashtag") {
                openHashTagInputView();
              }
              if (type == "mention") {
                openMentionInputView();
              }
              if (type == "location") {
                openLocationInputView();
              }
              if (type == "questions") {
                openQuestionsInputView();
              }
              Navigator.pop(stickerContext);
            },
          );
        });
  }

  Widget squaremusicCoverTest(String? url) {
    url = url!.replaceFirst('{w}', '200');
    url = url.replaceFirst('{h}', '200');
    print("music url=$url");
    return Container(
      height: 40.0.h,
      width: 40.0.w,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(imageUrl: url),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${musicViewData!.musicdata!.songTitle}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white)),
                    Text(
                      '${musicViewData!.musicdata!.songArtist}',
                      style: TextStyle(
                          fontSize: 1.5.h,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                )),
          )
        ],
      ),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     image: DecorationImage(
      //         fit: BoxFit.cover, image: CachedNetworkImageProvider(url))),
    );
  }

  Widget musicCover(String url) {
    url = url.replaceFirst('{w}', '200');
    url = url.replaceFirst('{h}', '200');
    print("music url=$url");
    return

        // ClipRRect(
        //   borderRadius: BorderRadius.all(Radius.circular(15)),
        //   child:

        ClipRRect(
            borderRadius: BorderRadius.circular(4.0.w),
            child: Container(
                // height: 20.0.h,
                // width: 20.0.w,
                child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain))
            //  Image.asset(
            //   AudioManager.instance.info?.coverUrl ??
            //       "assets/images/disc.png",
            //   width: 120.0,
            //   height: 120.0,
            //   fit: BoxFit.cover,
            // )

            // Card(
            //   color: Colors.black,
            //   shape: RoundedRectangleBorder(),
            //   child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
            // ),
            );
    // );
  }

  void openQuestionsInputView() {
    showDialog(
      context: context,
      builder: (ctx) => QuestionsInputView(
        oldQuestionsText: locationViewData!.name ?? '',
        onDone: (hashtagContext, val) {
          // setState(() {
          isquestionsViewAdd = true;
          questionsViewData =
              StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          // });
          Navigator.pop(hashtagContext);
        },
      ),
    );
  }

  void openLocationInputView() {
    showDialog(
      context: context,
      builder: (ctx) => LocationInputView(
        oldLocation: locationViewData!.name ?? '',
        onDone: (hashtagContext, val) {
          setState(() {
            islocationViewAdd = true;
            locationViewData =
                StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          });
          Navigator.pop(hashtagContext);
        },
      ),
    );
  }

  void openHashTagInputView() {
    showDialog(
      context: context,
      builder: (ctx) => HashTagSelectView(
        oldHashtag: hashtagViewData!.name!.toUpperCase()!,
        onDone: (hashtagContext, val) {
          setState(() {
            ishastagViewAdd = true;
            hashtagViewData =
                StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          });
          Navigator.pop(hashtagContext);
        },
      ),
    );
  }

  void openMusicInputView(
      {song_id: '',
      song_image_url: '',
      song_title: '',
      song_artist: '',
      song_url: ''}) {
    showDialog(
        context: context,
        builder: (ctx) => MusicView(
              songId: song_id,
              songImageUrl: song_image_url,
              songUrl: song_url,
              songTitle: song_title,
              songArtist: song_artist,
              oldQuestionsText: '',
              onDone: (hashtagContext, MusicClass val) async {
                setState(() {
                  ismusicViewAdd = true;

                  musicViewData = StickerClass(
                    offset.dx,
                    offset.dy,
                    '${val.songTitle}',
                    0.4,
                    "-1",
                    musicdata: val,
                  );

                  musicViewData!.h = 100.0.h;
                  musicViewData!.w = 100.0.w;

                  // }

                  print("reached here 2 ${musicViewData!.musicdata!.style}");
                });
                if (thisplayer.isBlank!) {
                  print("music end error");
                } else {
                  try {
                    thisplayer.setUrl(val.songUrl!);
                    thisplayer.setLoopMode(LoopMode.all);
                    thisplayer.play();
                  } catch (e) {
                    print("music end error $e");
                  }
                }
                Navigator.pop(hashtagContext);

                currentDuration = thisplayer.duration!;

                print("music end");
              },
            ));
    //    MusicInputView(
    //     song_id: song_id ?? '',
    //     song_image_url: song_image_url ?? "",
    //     onDone: (hashtagContext, val) {
    //       // setState(() {
    //       ismusicViewAdd = true;
    //       musicViewData=
    //           StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
    //       // });
    //       Navigator.pop(hashtagContext);
    //     },
    //   ),
    // );
  }

  void openMentionInputView() {
    showDialog(
      context: context,
      builder: (ctx) => MentionSelectView(
        // oldHashtag: hashtagViewData?.name?.toUpperCase(),
        onDone: (hashtagContext, val, mentionUserId) {
          setState(() {
            offset = Offset.zero;
            ismentionUserViewAdd = true;
            mentionUserList
                .add(TagsClass(offset.dx, offset.dy, val, 1.0, null, null));
            mentionUserIdList.add(mentionUserId);
            StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          });
          Navigator.pop(hashtagContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // final deviceRatio = size.width / size.height;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  if (isTextView)
                    GestureDetector(
                      onTap: () {
                        print("tap ah");

                        onTap();
                      },
                      child: Stack(
                        children: [
                          Screenshot(
                            controller: screenshotController,
                            child: Container(
                              height: (100.0.h -
                                  (MediaQuery.of(context).viewInsets.bottom +
                                      20.0.h)),
                              width: 100.0.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF0612FA),
                                    Color(0xFFE2821E),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          if (!showTextField)
                            ...tagsList
                                .map((e) => Positioned.fill(
                                      left: e.posx! - 125,
                                      top: e.posy! - 125,
                                      right: -125,
                                      bottom: -125,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: XGestureDetector(
                                            onLongPress: (val) {
                                              setState(() {
                                                // showTextField = !showTextField;
                                                e.h = 100.0.h;
                                                e.w = 100.0.w;
                                              });
                                            },
                                            // onTap: (val) {
                                            //   // onTap();
                                            //   setState(() {
                                            //     showColors = false;
                                            //     showFonts = true;
                                            //     showTextField = true;
                                            //     textViewTextController.text = e.name;
                                            //     roboto = e.font;
                                            //     selectedColor = e.color;
                                            //     _baseScaleFactor = e.scale;
                                            //     currentEditingTag = tagsList.indexOf(e);
                                            //   });
                                            //   /*  setState(() {
                                            //             // showTextField = !showTextField;
                                            //             e.h = 100.0.h;
                                            //             e.w = 100.0.w;
                                            //           });*/
                                            // },
                                            onScaleEnd: () {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (timeStamp) {
                                                // final RenderObject? box = e
                                                //     .key!.currentContext!
                                                //     .findRenderObject();
                                                final RenderRepaintBoundary?
                                                    box = e!.key!.currentContext!
                                                            .findRenderObject()
                                                        as RenderRepaintBoundary;
                                                setState(() {
                                                  e.w = box!.size.width;
                                                  e.h = box!.size.height;
                                                  _baseScaleFactor = e.scale!;
                                                });
                                              });
                                            },
                                            onScaleStart: (details) {
                                              setState(() {
                                                _baseScaleFactor = e.scale!;
                                                e.h = 100.0.h;
                                                e.w = 100.0.w;
                                              });
                                            },
                                            onScaleUpdate: (details) {
                                              setState(() {
                                                e.scale = _baseScaleFactor *
                                                    details.scale;
                                              });
                                            },

                                            onMoveUpdate: (details) {
                                              double xdiff = 0;
                                              double ydiff = 0;
                                              offset = Offset(
                                                  offset.dx + details.delta.dx,
                                                  offset.dy + details.delta.dy);
                                              // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                              ydiff = deletePosition.dy -
                                                  (offset.dy + 20.0.h);
                                              xdiff = (offset.dx) < 0
                                                  ? (-offset.dx)
                                                  : (offset.dx);

                                              print(xdiff);

                                              print(
                                                  deletePosition.dx.toString() +
                                                      " delete pos");
                                              if (((xdiff > 0 && xdiff < 60) ||
                                                      (xdiff < 0 &&
                                                          xdiff >= -1)) &&
                                                  ((ydiff > 0 && ydiff < 100) ||
                                                      (ydiff < 0 &&
                                                          ydiff >= -1))) {
                                                setState(() {
                                                  deleteIconColor = true;
                                                });
                                              } else {
                                                setState(() {
                                                  deleteIconColor = false;
                                                });
                                              }
                                              setState(() {
                                                isTagSelected = true;
                                                calculatePosition();
                                                e.h = 100.0.h;
                                                e.w = 100.0.w;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                e.posy = offset.dy;
                                                e.posx = offset.dx;
                                              });
                                              // print(details.position.toString());
                                              // print(100.0.h);
                                              // print(deletePosition.toString());
                                            },
                                            onMoveEnd: (details) async {
                                              double xdiff = 0;
                                              double ydiff = 0;
                                              offset = Offset(
                                                  offset.dx + details.delta.dx,
                                                  offset.dy + details.delta.dy);
                                              // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                              xdiff = (offset.dx) < 0
                                                  ? (-offset.dx)
                                                  : (offset.dx);
                                              ydiff = deletePosition.dy -
                                                  (offset.dy + 20.0.h);
                                              print(ydiff);
                                              if (((xdiff > 0 && xdiff < 60) ||
                                                      (xdiff < 0 &&
                                                          xdiff >= -1)) &&
                                                  ((ydiff > 0 && ydiff < 100) ||
                                                      (ydiff < 0 &&
                                                          ydiff >= -1))) {
                                                int i = tagsList.indexOf(e);
                                                setState(() {
                                                  tagsList.removeAt(i);
                                                  textViewTextController
                                                      .clear();
                                                  _baseScaleFactor = 1.0;
                                                  deleteIconColor = false;
                                                  isTagSelected = false;
                                                });
                                                var hasVibration =
                                                    await Vibration
                                                        .hasVibrator();
                                                if (hasVibration!) {
                                                  Vibration.vibrate();
                                                }
                                              } else {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) {
                                                  // final RenderObject? box = e
                                                  //     .key!.currentContext!
                                                  //     .findRenderObject();
                                                  final RenderRepaintBoundary? box = e!
                                                          .key!.currentContext!
                                                          .findRenderObject()
                                                      as RenderRepaintBoundary;
                                                  setState(() {
                                                    isTagSelected = false;
                                                    e.w = box!.size.width;
                                                    e.h = box.size.height;
                                                  });
                                                });
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6.0.w,
                                                    vertical: 5.0.h),
                                                child: Container(
                                                  height: e.h,
                                                  width: e.w,
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: onTap,
                                                      child: Text(
                                                        e.name!,
                                                        style: e.font!.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: e.color,
                                                            fontSize: 25),
                                                        textAlign:
                                                            TextAlign.center,
                                                        textScaleFactor:
                                                            e.scale,
                                                        key: e.key,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ))
                                .toList(),
                          Stack(
                            children: stickerList
                                .map(
                                  (e) => Positioned.fill(
                                    left: e.posx! - 125,
                                    top: e.posy! - 125,
                                    right: -125,
                                    bottom: -125,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: XGestureDetector(
                                        onLongPress: (val) {
                                          setState(() {
                                            // showTextField = !showTextField;
                                          });
                                        },
                                        onTap: (val) {
                                          /*  setState(() {
                                                        // showTextField = !showTextField;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });*/
                                        },
                                        onScaleEnd: () {
                                          /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                          final RenderBox box = e.stickerKey.currentContext.findRenderObject();
                                                          setState(() {
                                                            e.w = box.size.width;
                                                            e.h = box.size.height;
                                                          });
                                                        });*/
                                        },
                                        onScaleStart: (details) {
                                          setState(() {
                                            _baseScaleFactor = e.scale!;
                                            /*e.h = 100.0.h;
                                                          e.w = 100.0.w;*/
                                          });
                                        },
                                        onScaleUpdate: (details) {
                                          setState(() {
                                            e.scale = _baseScaleFactor *
                                                details.scale;
                                          });
                                        },
                                        onMoveStart: (details) {
                                          setState(() {
                                            offset = Offset(e.posx!, e.posy!);
                                          });
                                        },
                                        onMoveUpdate: (details) {
                                          double xdiff = 0;
                                          double ydiff = 0;
                                          offset = Offset(
                                              offset.dx + details.delta.dx,
                                              offset.dy + details.delta.dy);
                                          // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                          /*ydiff = deletePosition.dy - offset.dy < 0
                                                            ? offset.dy - deletePosition.dy
                                                            : deletePosition.dy - offset.dy;
*/
                                          xdiff = (offset.dx) < 0
                                              ? (-offset.dx)
                                              : (offset.dx);
                                          ydiff = deletePosition.dy -
                                              (offset.dy + 20.0.h);
                                          // print(e.posy.toInt().toString() + " dy,  " + deletePosition.dy.toInt().toString() + "~~" + (e.posy.toInt() + 200).toString());
                                          if (((xdiff > 0 && xdiff < 60) ||
                                                  (xdiff < 0 && xdiff >= -1)) &&
                                              ((ydiff > 0 && ydiff < 100) ||
                                                  (ydiff < 0 && ydiff >= -1))) {
                                            setState(() {
                                              deleteIconColor = true;
                                            });
                                          } else {
                                            setState(() {
                                              deleteIconColor = false;
                                            });
                                          }
                                          setState(() {
                                            isTagSelected = true;
                                            calculatePosition();
                                            // e.h = 100.0.h;
                                            //e.w = 100.0.w;
                                            offset = Offset(
                                                offset.dx + details.delta.dx,
                                                offset.dy + details.delta.dy);
                                            e.posy = offset.dy;
                                            e.posx = offset.dx;
                                          });
                                        },
                                        onMoveEnd: (details) async {
                                          double xdiff = 0;
                                          double ydiff = 0;
                                          offset = Offset(
                                              offset.dx + details.delta.dx,
                                              offset.dy + details.delta.dy);
                                          // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                          /*ydiff = deletePosition.dy - offset.dy < 0
                                                            ? offset.dy - deletePosition.dy
                                                            : deletePosition.dy - offset.dy;*/
                                          xdiff = (offset.dx) < 0
                                              ? (-offset.dx)
                                              : (offset.dx);
                                          ydiff = deletePosition.dy -
                                              (offset.dy + 20.0.h);

                                          if (((xdiff > 0 && xdiff < 60) ||
                                                  (xdiff < 0 && xdiff >= -1)) &&
                                              ((ydiff > 0 && ydiff < 100) ||
                                                  (ydiff < 0 && ydiff >= -1))) {
                                            int i = stickerList.indexOf(e);
                                            setState(() {
                                              stickerList.removeAt(i);
                                              textViewTextController.clear();
                                              deleteIconColor = false;
                                              isTagSelected = false;
                                            });
                                            var hasVibration =
                                                await Vibration.hasVibrator();
                                            if (hasVibration!) {
                                              Vibration.vibrate();
                                            }
                                          } else {
                                            setState(() {
                                              isTagSelected = false;
                                            });
                                          }
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Transform(
                                            transform: new Matrix4.diagonal3(
                                                new v.Vector3(e.scale!,
                                                    e.scale!, e.scale!)),
                                            alignment: FractionalOffset.center,
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0.w,
                                                    vertical: 4.0.h),
                                                child: Transform(
                                                  transform:
                                                      new Matrix4.diagonal3(
                                                          new v.Vector3(
                                                              e.scale!,
                                                              e.scale!,
                                                              e.scale!)),
                                                  alignment:
                                                      FractionalOffset.center,
                                                  child: Image.network(
                                                    e.name!,
                                                    height: 85,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          Stack(
                            children: [
                              if (isTimeViewAdd)
                                Positioned.fill(
                                  left: timeViewData!.posx! - 0,
                                  top: timeViewData!.posy! - 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: XGestureDetector(
                                      onScaleStart: (details) {
                                        setState(() {
                                          _baseScaleFactor =
                                              timeViewData!.scale!;
                                        });
                                      },
                                      onScaleEnd: () {
                                        setState(() {
                                          timeViewData!.lastRotation =
                                              timeViewData!.rotation;
                                        });
                                      },
                                      onScaleUpdate: (details) {
                                        setState(() {
                                          timeViewData!.rotation =
                                              timeViewData!.lastRotation! -
                                                  details.rotationAngle;
                                          timeViewData!.scale =
                                              _baseScaleFactor * details.scale;
                                        });
                                      },
                                      onMoveStart: (details) {
                                        setState(() {
                                          offset = Offset(timeViewData!.posx!,
                                              timeViewData!.posy!);
                                        });
                                      },
                                      onMoveUpdate: (details) {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        /*ydiff = deletePosition.dy - offset.dy < 0
                                                            ? offset.dy - deletePosition.dy
                                                            : deletePosition.dy - offset.dy;
*/
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);
                                        // print(e.posy.toInt().toString() + " dy,  " + deletePosition.dy.toInt().toString() + "~~" + (e.posy.toInt() + 200).toString());
                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          setState(() {
                                            deleteIconColor = true;
                                          });
                                        } else {
                                          setState(() {
                                            deleteIconColor = false;
                                          });
                                        }
                                        setState(() {
                                          isTagSelected = true;
                                          calculatePosition();
                                          timeViewData!.h = 100.0.h;
                                          timeViewData!.w = 100.0.w;
                                          offset = Offset(
                                              offset.dx + details.delta.dx,
                                              offset.dy + details.delta.dy);
                                          timeViewData!.posy = offset.dy;
                                          timeViewData!.posx = offset.dx;
                                        });
                                      },
                                      onMoveEnd: (details) async {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);
                                        print(ydiff);
                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          // int i = tagsList.indexOf(timeViewData);
                                          setState(() {
                                            // tagsList.removeAt(i);
                                            // textViewTextController.clear();
                                            isTimeViewAdd = false;
                                            timeViewData = null;
                                            _baseScaleFactor = 1.0;
                                            deleteIconColor = false;
                                            isTagSelected = false;
                                          });
                                          var hasVibration =
                                              await Vibration.hasVibrator();
                                          if (hasVibration!) {
                                            Vibration.vibrate();
                                          }
                                        } else {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            // final RenderObject? box = timeViewData
                                            //     !.stickerKey!.currentContext!
                                            //     .findRenderObject();
                                            final RenderRepaintBoundary? box =
                                                timeViewData!
                                                        .stickerKey!.currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            setState(() {
                                              isTagSelected = false;
                                              timeViewData!.w = box!.size.width;
                                              timeViewData!.h = box.size.height;
                                            });
                                          });
                                        }
                                        setState(() {
                                          offset = Offset.zero;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Transform(
                                          transform: new Matrix4.diagonal3(
                                              new v.Vector3(
                                                  timeViewData!.scale!,
                                                  timeViewData!.scale!,
                                                  timeViewData!.scale!))
                                            ..rotateZ(timeViewData!.rotation!),
                                          alignment: FractionalOffset.center,
                                          child: Container(
                                            child: StoryTimeWidget(
                                              key: timeViewData!.stickerKey,
                                              dateData: DateTime.parse(
                                                  timeViewData!.name!),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (ishastagViewAdd)
                                Positioned.fill(
                                  left: hashtagViewData!.posx! - 125,
                                  top: hashtagViewData!.posy! - 125,
                                  right: -125,
                                  bottom: -125,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: XGestureDetector(
                                      onLongPress: (val) {
                                        setState(() {
                                          // showTextField = !showTextField;
                                          hashtagViewData!.h = 100.0.h;
                                          hashtagViewData!.w = 100.0.w;
                                        });
                                      },
                                      onTap: (val) {
                                        setState(() {
                                          // showColors = false;
                                          // showFonts = true;
                                          // showTextField = true;
                                          // _controller.text = e.name;
                                          // roboto = e.font;
                                          // selectedColor = e.color;
                                          // currentEditingTag = tagsList[pageIndex].indexOf(e);
                                        });
                                        /*  setState(() {
                                                        // showTextField = !showTextField;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });*/
                                      },
                                      onScaleEnd: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          // final RenderObject? box = hashtagViewData!
                                          //     .stickerKey!.currentContext!
                                          //     .findRenderObject();

                                          final RenderRepaintBoundary? box =
                                              hashtagViewData!
                                                      .stickerKey!.currentContext!
                                                      .findRenderObject()
                                                  as RenderRepaintBoundary;
                                          setState(() {
                                            hashtagViewData!.lastRotation =
                                                hashtagViewData!.rotation;
                                            hashtagViewData!.w =
                                                box!.size.width;
                                            hashtagViewData!.h =
                                                box!.size.height;
                                          });
                                        });
                                      },
                                      onScaleStart: (details) {
                                        setState(() {
                                          _baseScaleFactor =
                                              hashtagViewData!.scale!;
                                          hashtagViewData!.h = 100.0.h;
                                          hashtagViewData!.w = 100.0.w;
                                        });
                                      },
                                      onScaleUpdate: (details) {
                                        setState(() {
                                          hashtagViewData!.rotation =
                                              hashtagViewData!.lastRotation! -
                                                  details.rotationAngle;
                                          hashtagViewData!.scale =
                                              _baseScaleFactor * details.scale;
                                        });
                                      },
                                      onMoveStart: (details) {
                                        setState(() {
                                          offset = Offset(
                                              hashtagViewData!.posx!,
                                              hashtagViewData!.posy!);
                                        });
                                      },
                                      onMoveUpdate: (details) {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);
                                        print(ydiff);

                                        print(deletePosition.dy.toString() +
                                            " delete pos");
                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          setState(() {
                                            deleteIconColor = true;
                                          });
                                        } else {
                                          setState(() {
                                            deleteIconColor = false;
                                          });
                                        }
                                        setState(() {
                                          isTagSelected = true;
                                          calculatePosition();
                                          hashtagViewData!.h = 100.0.h;
                                          hashtagViewData!.w = 100.0.w;
                                          offset = Offset(
                                              offset.dx + details.delta.dx,
                                              offset.dy + details.delta.dy);
                                          hashtagViewData!.posy = offset.dy;
                                          hashtagViewData!.posx = offset.dx;
                                        });
                                        // print(details.position.toString());
                                        // print(100.0.h);
                                        // print(deletePosition.toString());
                                      },
                                      onMoveEnd: (details) async {
                                        print("on mover end");
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);
                                        print(ydiff);
                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          // int i = tagsList[pageIndex].indexOf(hashtagViewData);
                                          setState(() {
                                            // tagsList[pageIndex].removeAt(i);
                                            // _controller.clear();
                                            ishastagViewAdd = false;
                                            hashtagViewData = null;
                                            deleteIconColor = false;
                                            isTagSelected = false;
                                          });
                                          var hasVibration =
                                              await Vibration.hasVibrator();
                                          if (hasVibration!) {
                                            Vibration.vibrate();
                                          }
                                        } else {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            // final RenderObject? box =
                                            //     hashtagViewData!
                                            //         .stickerKey!.currentContext
                                            //         ?.findRenderObject();
                                            final RenderRepaintBoundary?
                                                box = hashtagViewData!.stickerKey!
                                                        .currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            setState(() {
                                              isTagSelected = false;
                                              hashtagViewData!.w =
                                                  box!.size.width;
                                              hashtagViewData!.h =
                                                  box?.size.height;
                                            });
                                          });
                                        }
                                        setState(() {
                                          offset = Offset.zero;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.0.w,
                                              vertical: 5.0.h),
                                          child: Container(
                                            height: hashtagViewData!.h,
                                            width: hashtagViewData!.w,
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Container(
                                                key:
                                                    hashtagViewData!.stickerKey,
                                                padding: EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.2),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  hashtagViewData!.name!
                                                      .toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.rajdhani()
                                                      .copyWith(
                                                    // color: Colors.pink,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,

                                                    foreground: Paint()
                                                      ..shader = LinearGradient(
                                                        colors: <Color>[
                                                          Colors.orange,
                                                          Colors.pink
                                                        ],
                                                        begin: Alignment
                                                            .bottomLeft,
                                                        end: Alignment.topRight,
                                                      ).createShader(
                                                          Rect.largest),
                                                  ),
                                                  textScaleFactor:
                                                      hashtagViewData!.scale,
                                                ),
                                                // height: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (islocationViewAdd)
                                Positioned.fill(
                                  left: locationViewData!.posx! - 125,
                                  top: locationViewData!.posy! - 125,
                                  right: -125,
                                  bottom: -125,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: XGestureDetector(
                                      onLongPress: (val) {
                                        setState(() {
                                          // showTextField = !showTextField;
                                          locationViewData!.h = 100.0.h;
                                          locationViewData!.w = 100.0.w;
                                        });
                                      },
                                      onTap: (val) {
                                        setState(() {
                                          // showColors = false;
                                          // showFonts = true;
                                          // showTextField = true;
                                          // _controller.text = e.name;
                                          // roboto = e.font;
                                          // selectedColor = e.color;
                                          // currentEditingTag = tagsList[pageIndex].indexOf(e);
                                        });
                                        /*  setState(() {
                                                        // showTextField = !showTextField;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });*/
                                      },
                                      onScaleEnd: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          // final RenderObject? box = locationViewData
                                          //     !.stickerKey!.currentContext!
                                          //     .findRenderObject();
                                          final RenderRepaintBoundary?
                                              box = locationViewData!.stickerKey!
                                                      .currentContext!
                                                      .findRenderObject()
                                                  as RenderRepaintBoundary;
                                          setState(() {
                                            locationViewData!.lastRotation =
                                                locationViewData!.rotation;
                                            locationViewData!.w =
                                                box!.size.width;
                                            locationViewData!.h =
                                                box.size.height;
                                          });
                                        });
                                      },
                                      onScaleStart: (details) {
                                        setState(() {
                                          _baseScaleFactor =
                                              locationViewData!.scale!;
                                          locationViewData!.h = 100.0.h;
                                          locationViewData!.w = 100.0.w;
                                        });
                                      },
                                      onScaleUpdate: (details) {
                                        setState(() {
                                          locationViewData!.rotation =
                                              locationViewData!.lastRotation! -
                                                  details.rotationAngle;
                                          locationViewData!.scale =
                                              _baseScaleFactor * details.scale;
                                        });
                                      },
                                      onMoveStart: (details) {
                                        setState(() {
                                          offset = Offset(
                                              locationViewData!.posx!,
                                              locationViewData!.posy!);
                                        });
                                      },
                                      onMoveUpdate: (details) {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                                        // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
                                        print(ydiff);

                                        print(deletePosition.dy.toString() +
                                            " delete pos");
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);

                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          setState(() {
                                            deleteIconColor = true;
                                          });
                                        } else {
                                          setState(() {
                                            deleteIconColor = false;
                                          });
                                        }
                                        setState(() {
                                          isTagSelected = true;
                                          calculatePosition();
                                          locationViewData!.h = 100.0.h;
                                          locationViewData!.w = 100.0.w;
                                          offset = Offset(
                                              offset.dx + details.delta.dx,
                                              offset.dy + details.delta.dy);
                                          locationViewData!.posy = offset.dy;
                                          locationViewData!.posx = offset.dx;
                                        });
                                        // print(details.position.toString());
                                        // print(100.0.h);
                                        // print(deletePosition.toString());
                                      },
                                      onMoveEnd: (details) async {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);
                                        print(ydiff);
                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          // int i = tagsList[pageIndex].indexOf(locationViewData);
                                          setState(() {
                                            islocationViewAdd = false;
                                            // tagsList[pageIndex].removeAt(i);
                                            // _controller.clear();
                                            locationViewData = null;
                                            deleteIconColor = false;
                                            isTagSelected = false;
                                          });
                                          var hasVibration =
                                              await Vibration.hasVibrator();
                                          if (hasVibration!) {
                                            Vibration.vibrate();
                                          }
                                        } else {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            // final RenderObject? box =
                                            //     locationViewData!
                                            //         .stickerKey!.currentContext!
                                            //         .findRenderObject();
                                            final RenderRepaintBoundary?
                                                box = locationViewData!.stickerKey!
                                                        .currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            setState(() {
                                              isTagSelected = false;
                                              locationViewData!.w =
                                                  box!.size.width;
                                              locationViewData!.h =
                                                  box.size.height;
                                            });
                                          });
                                        }
                                        setState(() {
                                          offset = Offset.zero;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(locationViewData.rotation),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.0.w,
                                              vertical: 5.0.h),
                                          child: Container(
                                            height: locationViewData!.h,
                                            width: locationViewData!.w,
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Container(
                                                key: locationViewData!
                                                    .stickerKey,
                                                padding: EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.2),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: ShaderMask(
                                                  shaderCallback:
                                                      (Rect bounds) {
                                                    return LinearGradient(
                                                      colors: <Color>[
                                                        Colors.purple,
                                                        Colors.pinkAccent
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ).createShader(
                                                        Rect.fromLTWH(0.0, 0.0,
                                                            120.0, 40.0));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      Text(
                                                        locationViewData!.name!
                                                            .toUpperCase(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                                .rajdhani()
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        textScaleFactor:
                                                            locationViewData!
                                                                .scale,
                                                      ),
                                                    ],
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                  ),
                                                ),
                                                // height: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (
                              // musicViewData.length != 0 &&
                              //         musicViewData.length !=
                              //             currentIndex &&
                              //         musicViewData[currentIndex]?.name !=
                              //             "" &&
                              ismusicViewAdd)
                                Positioned.fill(
                                  left: musicViewData!.posx! - 125,
                                  top: musicViewData!.posy! - 125,
                                  right: -125,
                                  bottom: -125,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: XGestureDetector(
                                      onLongPress: (val) {
                                        setState(() {
                                          // showTextField = !showTextField;
                                          musicViewData!.h = 100.0.h;
                                          musicViewData!.w = 100.0.w;
                                        });
                                      },
                                      onTap: (val) {
                                        setState(() {
                                          // showColors = false;
                                          // showFonts = true;
                                          // showTextField = true;
                                          // _controller.text = e.name;
                                          // roboto = e.font;
                                          // selectedColor = e.color;
                                          // currentEditingTag = tagsList[pageIndex].indexOf(e);
                                        });
                                        /*  setState(() {
                                                        // showTextField = !showTextField;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });*/
                                      },
                                      onScaleEnd: () {
                                        setState(() {
                                          musicViewData!.lastRotation =
                                              musicViewData!.rotation;
                                        });
                                      },
                                      onScaleStart: (details) {
                                        setState(() {
                                          _baseScaleFactor =
                                              musicViewData!.scale!;
                                          print(
                                              "-------------___$_baseScaleFactor------------------------------------------------------------------------");
                                        });
                                      },
                                      onScaleUpdate: (details) {
                                        setState(() {
                                          musicViewData!.rotation =
                                              musicViewData!.lastRotation! -
                                                  details.rotationAngle;
                                          musicViewData!.scale =
                                              _baseScaleFactor * details.scale;
                                        });
                                      },
                                      onMoveStart: (details) {
                                        setState(() {
                                          offset = Offset(musicViewData!.posx!,
                                              musicViewData!.posy!);
                                        });
                                      },
                                      onMoveUpdate: (details) {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                                        // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
                                        print(ydiff);

                                        print(deletePosition.dy.toString() +
                                            " delete pos");
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);

                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          setState(() {
                                            deleteIconColor = true;
                                            // musicViewData[currentIndex]
                                            //     ?.name = "";
                                            // offset = Offset.zero;
                                            // Future.delayed(
                                            //     Duration(
                                            //         milliseconds: 1000),
                                            //     () {
                                            // thisplayer.stop();
                                            //   deleteIconColor = false;
                                            // });
                                          });
                                        } else {
                                          setState(() {
                                            deleteIconColor = false;
                                          });
                                        }
                                        setState(() {
                                          isTagSelected = true;
                                          calculatePosition();
                                          musicViewData!.h = 100.0.h;
                                          musicViewData!.w = 100.0.w;
                                          offset = Offset(
                                              offset.dx + details.delta.dx,
                                              offset.dy + details.delta.dy);
                                          musicViewData!.posy = offset.dy;
                                          musicViewData!.posx = offset.dx;
                                        });
                                        // print(details.position.toString());
                                        // print(100.0.h);
                                        // print(deletePosition.toString());
                                      },
                                      onMoveEnd: (details) async {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);
                                        print(ydiff);
                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          // int i = tagsList[pageIndex].indexOf(musicViewData[currentIndex]);
                                          setState(() {
                                            ismusicViewAdd = false;

                                            // tagsList[pageIndex].removeAt(i);
                                            // _controller.clear();
                                            musicViewData!.name = "";
                                            musicViewData = null;

                                            thisplayer.stop();
                                            // musicViewData[
                                            //     currentIndex] = null;
                                            deleteIconColor = false;
                                            isTagSelected = false;
                                          });
                                          var hasVibration =
                                              await Vibration.hasVibrator();
                                          if (hasVibration!) {
                                            Vibration.vibrate();
                                          }
                                        } else {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            // final RenderObject? box = musicViewData
                                            //     !.stickerKey!.currentContext!
                                            //     .findRenderObject();

                                            final RenderRepaintBoundary? box =
                                                musicViewData!
                                                        .stickerKey!.currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            setState(() {
                                              isTagSelected = false;
                                              musicViewData!.w =
                                                  box!.size.width;
                                              musicViewData!.h =
                                                  box.size.height;
                                            });
                                          });
                                        }
                                        setState(() {
                                          offset = Offset.zero;
                                        });
                                      },
                                      child: Transform.scale(
                                        scale: musicViewData!.scale,
                                        child: Container(
                                          color: Colors.transparent,
                                          // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(musicViewData[currentIndex].rotation),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.0.w,
                                                vertical: 5.0.h),
                                            child: Container(
                                              height: musicViewData!.h,
                                              width: musicViewData!.w,
                                              color: Colors.transparent,
                                              child: Center(
                                                child: musicViewData!.musicdata!
                                                                .style !=
                                                            null &&
                                                        musicViewData!
                                                                .musicdata!
                                                                .style !=
                                                            "liststyle"
                                                    ? Container(
                                                        // height: 20.0.h,
                                                        // width: 40.0.w,

                                                        key: musicViewData!
                                                            .stickerKey,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4.0.h,
                                                                horizontal:
                                                                    10.0.w)
                                                        // EdgeInsets.all(7),
                                                        ,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          // image: DecorationImage(
                                                          //     fit: BoxFit.cover,
                                                          //     image: CachedNetworkImageProvider(
                                                          //         'https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/f8/45/5a/f8455a71-8307-aa9a-9c95-3d22efe0804f/886446326146.jpg/200x200bb.jpg')),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          // boxShadow: [
                                                          //   BoxShadow(
                                                          //     color: Colors
                                                          //         .black
                                                          //         .withOpacity(
                                                          //             .2),
                                                          //     offset:
                                                          //         Offset(0, 2),
                                                          //     blurRadius: 3,
                                                          //   ),
                                                          // ],
                                                        ),
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            squaremusicCoverTest(
                                                                musicViewData!
                                                                    .musicdata!
                                                                    .songImageUrl)
                                                            // Container(
                                                            //   decoration:
                                                            //       BoxDecoration(
                                                            //     image: DecorationImage(
                                                            //         fit: BoxFit
                                                            //             .cover,
                                                            //         image: CachedNetworkImageProvider(
                                                            //             musicData
                                                            //                 .songImageUrl)),
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                        // child:

                                                        //     //MUSIC CHILD START
                                                        //     CachedNetworkImage(
                                                        //         imageUrl:
                                                        //             musicData
                                                        //                 .songImageUrl)
                                                        //  ,                                 Stack(
                                                        //                                 clipBehavior:
                                                        //                                     Clip.none,
                                                        //                                 children: [
                                                        //                                   ListTile(
                                                        //                                     shape: RoundedRectangleBorder(
                                                        //                                         borderRadius:
                                                        //                                             BorderRadius.circular(
                                                        //                                                 20)),
                                                        //                                     // contentPadding:
                                                        //                                     //     EdgeInsets
                                                        //                                     //         .all(
                                                        //                                     //             18.0),
                                                        //                                     tileColor:
                                                        //                                         Colors
                                                        //                                             .white,
                                                        //                                     trailing:
                                                        //                                         FittedBox(
                                                        //                                       child: SpinKitPianoWave(
                                                        //                                           color: Colors
                                                        //                                               .deepPurple,
                                                        //                                           size: 3.0
                                                        //                                               .h),
                                                        //                                     ),
                                                        //                                     leading: musicCover(
                                                        //                                         musicData
                                                        //                                             .songImageUrl),
                                                        //                                     title: Text(
                                                        //                                         '${musicData.songTitle}',
                                                        //                                         style: TextStyle(
                                                        //                                             fontSize:
                                                        //                                                 20)),
                                                        //                                     subtitle: Text(
                                                        //                                         '${musicData.songArtist}'),
                                                        //                                   ),
                                                        //                                 ],
                                                        //                               ),

                                                        // height: 30,
                                                      )
                                                    : Container(
                                                        key: musicViewData!
                                                            .stickerKey,
                                                        padding:
                                                            EdgeInsets.all(7),

                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .2),
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child:

                                                            //MUSIC CHILD START

                                                            Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            ListTile(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              // contentPadding:
                                                              //     EdgeInsets
                                                              //         .all(
                                                              //             18.0),
                                                              tileColor:
                                                                  Colors.white,
                                                              trailing:
                                                                  FittedBox(
                                                                child: SpinKitPianoWave(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    size:
                                                                        3.0.h),
                                                              ),
                                                              leading: musicCover(
                                                                  musicViewData!
                                                                      .musicdata!
                                                                      .songImageUrl!),
                                                              title: Text(
                                                                  '${musicViewData!.musicdata!.songTitle}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20)),
                                                              subtitle: Text(
                                                                  '${musicViewData!.musicdata!.songArtist}'),
                                                            ),
                                                          ],
                                                        ),

                                                        // height: 30,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (isquestionsViewAdd)
                                Positioned.fill(
                                  left: questionsViewData!.posx! - 125,
                                  top: questionsViewData!.posy! - 125,
                                  right: -125,
                                  bottom: -125,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: XGestureDetector(
                                      onLongPress: (val) {
                                        setState(() {
                                          // showTextField = !showTextField;
                                          questionsViewData!.h = 100.0.h;
                                          questionsViewData!.w = 100.0.w;
                                        });
                                      },
                                      onTap: (val) {
                                        setState(() {
                                          // showColors = false;
                                          // showFonts = true;
                                          // showTextField = true;
                                          // _controller.text = e.name;
                                          // roboto = e.font;
                                          // selectedColor = e.color;
                                          // currentEditingTag = tagsList[pageIndex].indexOf(e);
                                        });
                                        /*  setState(() {
                                                        // showTextField = !showTextField;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });*/
                                      },
                                      onScaleEnd: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          // final RenderObject? box =
                                          //     questionsViewData!
                                          //         .stickerKey!.currentContext!
                                          //         .findRenderObject();
                                          final RenderRepaintBoundary? box =
                                              questionsViewData!
                                                      .stickerKey!.currentContext!
                                                      .findRenderObject()
                                                  as RenderRepaintBoundary;
                                          setState(() {
                                            //questionsViewData.lastRotation = questionsViewData.rotation;
                                            questionsViewData!.w =
                                                box!.size.width;
                                            questionsViewData!.h =
                                                box!.size.height;
                                          });
                                        });
                                      },
                                      onScaleStart: (details) {
                                        setState(() {
                                          _baseScaleFactor =
                                              questionsViewData!.scale!;
                                          questionsViewData!.h = 100.0.h;
                                          questionsViewData!.w = 100.0.w;
                                        });
                                      },
                                      onScaleUpdate: (details) {
                                        setState(() {
                                          questionsViewData!.rotation =
                                              questionsViewData!.lastRotation! -
                                                  details.rotationAngle;
                                          questionsViewData!.scale =
                                              _baseScaleFactor * details.scale;
                                        });
                                      },
                                      onMoveStart: (details) {
                                        setState(() {
                                          offset = Offset(
                                              questionsViewData!.posx!,
                                              questionsViewData!.posy!);
                                        });
                                      },
                                      onMoveUpdate: (details) {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                                        // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
                                        print(ydiff);

                                        print(deletePosition.dy.toString() +
                                            " delete pos");
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);

                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          setState(() {
                                            deleteIconColor = true;
                                          });
                                        } else {
                                          setState(() {
                                            deleteIconColor = false;
                                          });
                                        }
                                        setState(() {
                                          isTagSelected = true;
                                          calculatePosition();
                                          questionsViewData!.h = 100.0.h;
                                          questionsViewData!.w = 100.0.w;
                                          offset = Offset(
                                              offset.dx + details.delta.dx,
                                              offset.dy + details.delta.dy);
                                          questionsViewData!.posy = offset.dy;
                                          questionsViewData!.posx = offset.dx;
                                        });
                                        // print(details.position.toString());
                                        // print(100.0.h);
                                        // print(deletePosition.toString());
                                      },
                                      onMoveEnd: (details) async {
                                        double xdiff = 0;
                                        double ydiff = 0;
                                        offset = Offset(
                                            offset.dx + details.delta.dx,
                                            offset.dy + details.delta.dy);
                                        // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                        xdiff = (offset.dx) < 0
                                            ? (-offset.dx)
                                            : (offset.dx);
                                        ydiff = deletePosition.dy -
                                            (offset.dy + 20.0.h);
                                        print(ydiff);
                                        if (((xdiff > 0 && xdiff < 60) ||
                                                (xdiff < 0 && xdiff >= -1)) &&
                                            ((ydiff > 0 && ydiff < 100) ||
                                                (ydiff < 0 && ydiff >= -1))) {
                                          // int i = tagsList[pageIndex].indexOf(questionsViewData);
                                          setState(() {
                                            isquestionsViewAdd = false;
                                            // tagsList[pageIndex].removeAt(i);
                                            // _controller.clear();
                                            questionsViewData = null;
                                            deleteIconColor = false;
                                            isTagSelected = false;
                                          });
                                          var hasVibration =
                                              await Vibration.hasVibrator();
                                          if (hasVibration!) {
                                            Vibration.vibrate();
                                          }
                                        } else {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            // final RenderObject? box =
                                            //     questionsViewData!
                                            //         .stickerKey!.currentContext
                                            //         !.findRenderObject();
                                            final RenderRepaintBoundary? box =
                                                questionsViewData!
                                                        .stickerKey!.currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            setState(() {
                                              isTagSelected = false;
                                              questionsViewData!.w =
                                                  box!.size.width;
                                              questionsViewData!.h =
                                                  box.size.height;
                                            });
                                          });
                                        }
                                        setState(() {
                                          offset = Offset.zero;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(questionsViewData.rotation),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.0.w,
                                              vertical: 5.0.h),
                                          child: Container(
                                            height: questionsViewData!.h,
                                            width: questionsViewData!.w,
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Container(
                                                key: questionsViewData!
                                                    .stickerKey,
                                                padding: EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.2),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .70,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          // TextField(
                                                          //   controller: _controller,
                                                          //   enabled: false,
                                                          //   textAlign: TextAlign.center,
                                                          //   textCapitalization: TextCapitalization.sentences,
                                                          //   maxLines: 3,
                                                          //   minLines: 1,
                                                          //   onChanged: (val) {},
                                                          //   style: TextStyle(
                                                          //     fontSize: 20,
                                                          //   ),
                                                          //   decoration: InputDecoration(
                                                          //     border: InputBorder.none,
                                                          //     hintText: "Ask me a question",
                                                          //     hintStyle: TextStyle(
                                                          //       color: Colors.grey,
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        15),
                                                            child: Text(
                                                              questionsViewData!
                                                                  .name!,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade200,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            width:
                                                                double.infinity,
                                                            child: Center(
                                                              child: Text(
                                                                "Viewers respond here",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 0,
                                                      right: 0,
                                                      top: -20,
                                                      child: Center(
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            CurrentUser()
                                                                .currentUser
                                                                .image!,
                                                          ),
                                                          backgroundColor:
                                                              Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // height: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (ismentionUserViewAdd)
                                ...mentionUserList
                                    .map(
                                      (e) => Positioned.fill(
                                        left: e.posx! - 125,
                                        top: e.posy! - 125,
                                        right: -125,
                                        bottom: -125,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: XGestureDetector(
                                            onLongPress: (val) {
                                              setState(() {
                                                // showTextField = !showTextField;
                                                e.h = 100.0.h;
                                                e.w = 100.0.w;
                                              });
                                            },
                                            onTap: (val) {
                                              setState(() {
                                                // showColors = false;
                                                // showFonts = true;
                                                // showTextField = true;
                                                // _controller.text = e.name;
                                                // roboto = e.font;
                                                // selectedColor = e.color;
                                                // currentEditingTag = tagsList[pageIndex].indexOf(e);
                                              });
                                              /*  setState(() {
                                                        // showTextField = !showTextField;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });*/
                                            },
                                            onScaleEnd: () {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (timeStamp) {
                                                // final RenderObject? box = e
                                                //     .key!.currentContext!
                                                //     .findRenderObject();
                                                final RenderRepaintBoundary?
                                                    box = e!.key!.currentContext!
                                                            .findRenderObject()
                                                        as RenderRepaintBoundary;
                                                setState(() {
                                                  // e.lastRotation = e.rotation;
                                                  e.w = box!.size.width;
                                                  e.h = box.size.height;
                                                });
                                              });
                                            },
                                            onScaleStart: (details) {
                                              setState(() {
                                                _baseScaleFactor = e.scale!;
                                                e.h = 100.0.h;
                                                e.w = 100.0.w;
                                              });
                                            },
                                            onScaleUpdate: (details) {
                                              setState(() {
                                                // e.rotation = e.lastRotation - details.rotationAngle;
                                                e.scale = _baseScaleFactor *
                                                    details.scale;
                                              });
                                            },
                                            onMoveStart: (details) {
                                              setState(() {
                                                offset =
                                                    Offset(e.posx!, e.posy!);
                                              });
                                            },
                                            onMoveUpdate: (details) {
                                              double xdiff = 0;
                                              double ydiff = 0;
                                              offset = Offset(
                                                  offset.dx + details.delta.dx,
                                                  offset.dy + details.delta.dy);
                                              // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                              xdiff = (offset.dx) < 0
                                                  ? (-offset.dx)
                                                  : (offset.dx);
                                              ydiff = deletePosition.dy -
                                                  (offset.dy + 20.0.h);
                                              print(ydiff);

                                              print(
                                                  deletePosition.dy.toString() +
                                                      " delete pos");
                                              if (((xdiff > 0 && xdiff < 60) ||
                                                      (xdiff < 0 &&
                                                          xdiff >= -1)) &&
                                                  ((ydiff > 0 && ydiff < 100) ||
                                                      (ydiff < 0 &&
                                                          ydiff >= -1))) {
                                                setState(() {
                                                  deleteIconColor = true;
                                                });
                                              } else {
                                                setState(() {
                                                  deleteIconColor = false;
                                                });
                                              }
                                              setState(() {
                                                isTagSelected = true;
                                                calculatePosition();
                                                e.h = 100.0.h;
                                                e.w = 100.0.w;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                e.posy = offset.dy;
                                                e.posx = offset.dx;
                                              });
                                              // print(details.position.toString());
                                              // print(100.0.h);
                                              // print(deletePosition.toString());
                                            },
                                            onMoveEnd: (details) async {
                                              double xdiff = 0;
                                              double ydiff = 0;
                                              offset = Offset(
                                                  offset.dx + details.delta.dx,
                                                  offset.dy + details.delta.dy);
                                              // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                              xdiff = (offset.dx) < 0
                                                  ? (-offset.dx)
                                                  : (offset.dx);
                                              ydiff = deletePosition.dy -
                                                  (offset.dy + 20.0.h);
                                              print(ydiff);
                                              if (((xdiff > 0 && xdiff < 60) ||
                                                      (xdiff < 0 &&
                                                          xdiff >= -1)) &&
                                                  ((ydiff > 0 && ydiff < 100) ||
                                                      (ydiff < 0 &&
                                                          ydiff >= -1))) {
                                                int i =
                                                    mentionUserList.indexOf(e);
                                                setState(() {
                                                  mentionUserList.removeAt(i);
                                                  mentionUserIdList.removeAt(i);
                                                  print(mentionUserList);
                                                  print(mentionUserIdList);
                                                  // _controller.clear();
                                                  deleteIconColor = false;
                                                  isTagSelected = false;
                                                });
                                                var hasVibration =
                                                    await Vibration
                                                        .hasVibrator();
                                                if (hasVibration!) {
                                                  Vibration.vibrate();
                                                }
                                              } else {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) {
                                                  // final RenderObject? box = e
                                                  //     .key!.currentContext!
                                                  //     .findRenderObject();
                                                  final RenderRepaintBoundary? box = e
                                                          .key!.currentContext!
                                                          .findRenderObject()
                                                      as RenderRepaintBoundary;
                                                  setState(() {
                                                    isTagSelected = false;
                                                    e.w = box!.size.width;
                                                    e.h = box.size.height;
                                                  });
                                                });
                                              }
                                              setState(() {
                                                offset = Offset.zero;
                                              });
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6.0.w,
                                                    vertical: 5.0.h),
                                                child: Container(
                                                  height: e.h,
                                                  width: e.w,
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: Container(
                                                      key: e.key,
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .2),
                                                            offset:
                                                                Offset(0, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        e.name!.toUpperCase(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                                .rajdhani()
                                                            .copyWith(
                                                          // color: Colors.pink,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,

                                                          foreground: Paint()
                                                            ..shader =
                                                                LinearGradient(
                                                              colors: <Color>[
                                                                Colors.orange,
                                                                Colors.amber
                                                              ],
                                                              begin: Alignment
                                                                  .bottomLeft,
                                                              end: Alignment
                                                                  .topRight,
                                                            ).createShader(Rect
                                                                    .largest),
                                                        ),
                                                        textScaleFactor:
                                                            e.scale,
                                                      ),
                                                      // height: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()
                            ],
                          ),
                          isTagSelected
                              ? Positioned.fill(
                                  bottom: 22.0.h,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      key: deleteKey,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: new Border.all(
                                          color: deleteIconColor
                                              ? Colors.red
                                              : Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 22,
                                        child: Icon(
                                          Icons.delete_outline_outlined,
                                          color: deleteIconColor
                                              ? Colors.red
                                              : Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          showTextField || tagsList.isEmpty
                              ? Positioned.fill(
                                  top: 0.0,
                                  bottom: 20.0.h,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      autofocus: true,
                                      cursorColor: Colors.white,
                                      cursorHeight: 5.0.h,
                                      onTap: () {
                                        onTap();
                                      },
                                      onChanged: (val) {
                                        print(
                                            "entered here text $val ${currentEditingTag} ${isTextView}");
                                        if (currentEditingTag >= 0) {
                                          print("entered here text");
                                          setState(() {
                                            tagsList[currentEditingTag].name =
                                                val;
                                            tagsList[currentEditingTag].w =
                                                100.0.w;
                                            tagsList[currentEditingTag].h =
                                                100.0.h;
                                          });
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            print(currentEditingTag);
                                            // final RenderObject? box =
                                            //     tagsList[currentEditingTag]
                                            //         .key!
                                            //         .currentContext!
                                            //         .findRenderObject();
                                            final RenderRepaintBoundary? box =
                                                tagsList[currentEditingTag]
                                                        .key!
                                                        .currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            setState(() {
                                              tagsList[currentEditingTag].w =
                                                  box!.size.width;
                                              tagsList[currentEditingTag].h =
                                                  box.size.height;
                                            });
                                          });
                                        }

                                        // List<String> users = val.split(" ");
                                        //
                                        // if (users[users.length - 1].startsWith("#")) {
                                        //   print("################");
                                        //   getHashtags(users[users.length - 1].replaceAll("#", ""));
                                        //   setState(() {
                                        //     showHashtags = true;
                                        //   });
                                        // } else {
                                        //   setState(() {
                                        //     tags.searchTags = [];
                                        //     showHashtags = false;
                                        //   });
                                        //   print("endddddddddddd");
                                        // }
                                        // print("agaiaaannn");
                                        // if (users[users.length - 1].startsWith("@")) {
                                        //   print("@@@@@@@@@@@@@2");
                                        //   getUserTags(users[users.length - 1].replaceAll("@", ""));
                                        //   setState(() {
                                        //     showUsersList = true;
                                        //   });
                                        // } else {
                                        //   setState(() {
                                        //     tagList.userTags = [];
                                        //     showUsersList = false;
                                        //   });
                                        // }
                                        // print("checkkkkkkkkkkkk");
                                      },
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      controller: textViewTextController,
                                      keyboardType: TextInputType.multiline,
                                      style: roboto.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: selectedColor,
                                          fontSize: 25),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: "Tap to type",
                                        // hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0.sp),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Positioned.fill(
                            top: 1.5.h,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (keyboardVisible)
                                      InkWell(
                                        onTap: () {
                                          print(
                                              'tapped keyboard ${showFonts} ${showColors}');
                                          setState(() {
                                            // showFonts = !showFonts;
                                            showColors = !showColors;
                                            showFonts = !showColors;
                                          });
                                        },
                                        child: showColors
                                            ? Container(
                                                decoration: new BoxDecoration(
                                                  border: new Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    "Aa",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 12.0.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: new Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                height: 20.0.sp + 5,
                                                child: Image.asset(
                                                    "assets/images/gradient.png"),
                                              ),
                                      ),
                                    SizedBox(
                                      width: 4.0.w,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          _showStickersPage();
                                        },
                                        child: Icon(
                                          Icons.emoji_emotions_outlined,
                                          color: Colors.white,
                                          size: 4.0.h,
                                        )),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    controller == null || !controller.value.isInitialized
                        ? Container()
                        : Container(
                            height: 80.0.h,
                            width: 100.0.w,
                            color: Colors.amber,
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
                  ],
                  if (questionsReplyViewData != null)
                    Positioned.fill(
                      left: questionsReplyViewData!.posx! - 125,
                      top: questionsReplyViewData!.posy! - 125,
                      right: -125,
                      bottom: -125,
                      child: Align(
                        alignment: Alignment.center,
                        child: XGestureDetector(
                          onLongPress: (val) {
                            setState(() {
                              // showTextField = !showTextField;
                              questionsReplyViewData!.h = 100.0.h;
                              questionsReplyViewData!.w = 100.0.w;
                            });
                          },
                          onTap: (val) {
                            setState(() {
                              // showColors = false;
                              // showFonts = true;
                              // showTextField = true;
                              // _controller.text = e.name;
                              // roboto = e.font;
                              // selectedColor = e.color;
                              // currentEditingTag = tagsList[pageIndex].indexOf(e);
                            });
                            /*  setState(() {
                                                        // showTextField = !showTextField;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });*/
                          },
                          onScaleEnd: () {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              // final RenderObject? box = questionsReplyViewData
                              //  !   .stickerKey!.currentContext!
                              //     .findRenderObject();
                              final RenderRepaintBoundary? box =
                                  questionsReplyViewData!
                                          .stickerKey!.currentContext!
                                          .findRenderObject()
                                      as RenderRepaintBoundary;
                              setState(() {
                                questionsReplyViewData!.lastRotation =
                                    questionsReplyViewData!.rotation;
                                questionsReplyViewData!.w = box!.size.width;
                                questionsReplyViewData!.h = box.size.height;
                              });
                            });
                          },
                          onScaleStart: (details) {
                            setState(() {
                              _baseScaleFactor = questionsReplyViewData!.scale!;
                              questionsReplyViewData!.h = 100.0.h;
                              questionsReplyViewData!.w = 100.0.w;
                            });
                          },
                          onScaleUpdate: (details) {
                            setState(() {
                              questionsReplyViewData!.rotation =
                                  questionsReplyViewData!.lastRotation! -
                                      details.rotationAngle;
                              questionsReplyViewData!.scale =
                                  _baseScaleFactor * details.scale;
                            });
                          },
                          onMoveStart: (details) {
                            setState(() {
                              offset = Offset(questionsReplyViewData!.posx!,
                                  questionsReplyViewData!.posy!);
                            });
                          },
                          onMoveUpdate: (details) {
                            double xdiff = 0;
                            double ydiff = 0;
                            offset = Offset(offset.dx + details.delta.dx,
                                offset.dy + details.delta.dy);
                            // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                            // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                            // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
                            print(ydiff);

                            print(deletePosition.dy.toString() + " delete pos");
                            xdiff =
                                (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                            ydiff = deletePosition.dy - (offset.dy + 20.0.h);

                            if (((xdiff > 0 && xdiff < 60) ||
                                    (xdiff < 0 && xdiff >= -1)) &&
                                ((ydiff > 0 && ydiff < 100) ||
                                    (ydiff < 0 && ydiff >= -1))) {
                              setState(() {
                                deleteIconColor = true;
                              });
                            } else {
                              setState(() {
                                deleteIconColor = false;
                              });
                            }
                            setState(() {
                              isTagSelected = true;
                              // calculatePosition();
                              questionsReplyViewData!.h = 100.0.h;
                              questionsReplyViewData!.w = 100.0.w;
                              offset = Offset(offset.dx + details.delta.dx,
                                  offset.dy + details.delta.dy);
                              questionsReplyViewData!.posy = offset.dy;
                              questionsReplyViewData!.posx = offset.dx;
                            });
                            // print(details.position.toString());
                            // print(100.0.h);
                            // print(deletePosition.toString());
                          },
                          onMoveEnd: (details) async {
                            double xdiff = 0;
                            double ydiff = 0;
                            offset = Offset(offset.dx + details.delta.dx,
                                offset.dy + details.delta.dy);
                            // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                            xdiff =
                                (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                            ydiff = deletePosition.dy - (offset.dy + 20.0.h);
                            print(ydiff);
                            if (((xdiff > 0 && xdiff < 60) ||
                                    (xdiff < 0 && xdiff >= -1)) &&
                                ((ydiff > 0 && ydiff < 100) ||
                                    (ydiff < 0 && ydiff >= -1))) {
                              // int i = tagsList[pageIndex].indexOf(questionsReplyViewData);
                              setState(() {
                                isquestionsViewAdd = false;
                                // tagsList[pageIndex].removeAt(i);
                                // _controller.clear();
                                // questionsReplyViewData = null;
                                deleteIconColor = false;
                                isTagSelected = false;
                              });
                              var hasVibration = await Vibration.hasVibrator();
                              if (hasVibration!) {
                                Vibration.vibrate();
                              }
                            } else {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                // final RenderObject? box = questionsReplyViewData!
                                //     .stickerKey!.currentContext!
                                //     .findRenderObject();
                                final RenderRepaintBoundary? box =
                                    questionsReplyViewData!
                                            .stickerKey!.currentContext!
                                            .findRenderObject()
                                        as RenderRepaintBoundary;
                                setState(() {
                                  isTagSelected = false;
                                  questionsReplyViewData!.w = box!.size.width;
                                  questionsReplyViewData!.h = box.size.height;
                                });
                              });
                            }
                            setState(() {
                              offset = Offset.zero;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(questionsReplyViewData.rotation),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.0.w, vertical: 5.0.h),
                              child: Container(
                                height: questionsReplyViewData!.h,
                                width: questionsReplyViewData!.w,
                                color: Colors.transparent,
                                child: Center(
                                  child: Container(
                                    key: questionsReplyViewData!.stickerKey,
                                    // padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.2),
                                          offset: Offset(0, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // padding: EdgeInsets.all(20),
                                      width: MediaQuery.of(context).size.width *
                                          .70,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Text(
                                              questionsReplyViewData!.name!,
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            padding: EdgeInsets.all(15),
                                            width: double.infinity,
                                            child: Center(
                                              child: Text(
                                                questionsReplyViewData!
                                                    .extraName!,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // height: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                            Navigator.of(context).pop();
                          }),
                    ),
                  ),
                  showColors && keyboardVisible
                      ? Positioned.fill(
                          bottom: (22.0.h),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 4.5.h,
                              color: Colors.transparent,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: colors.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: selectedColor,
                                          child: Icon(
                                            Icons.brush,
                                            color: selectedColor == Colors.white
                                                ? Colors.black
                                                : Colors.white,
                                            size: 2.0.h,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return StoryColorCard(
                                        color: colors[index - 1],
                                        onTap: () {
                                          if (currentEditingTag < 0) {
                                            setState(() {
                                              selectedColor = colors[index - 1];
                                            });
                                          } else {
                                            setState(() {
                                              selectedColor = colors[index - 1];
                                              tagsList[currentEditingTag]
                                                  .color = colors[index - 1];
                                            });
                                          }
                                        },
                                      );
                                    }
                                  }),
                            ),
                          ),
                        )
                      : Container(),
                  showFonts && keyboardVisible
                      ? Positioned.fill(
                          bottom: (22.0.h),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 4.5.h,
                              color: Colors.transparent,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: fontsList.length,
                                  itemBuilder: (context, index) {
                                    return StoryFontCard(
                                      index: index,
                                      font: fontsList[index],
                                      selectedFontIndex: selectedFontIndex,
                                      onTap: () {
                                        if (currentEditingTag < 0) {
                                          setState(() {
                                            roboto = fontsList[index];
                                            selectedFontIndex = index;
                                          });
                                        } else {
                                          setState(() {
                                            roboto = fontsList[index];
                                            selectedFontIndex = index;
                                            tagsList[currentEditingTag].font =
                                                fontsList[index];
                                          });
                                        }
                                      },
                                    );
                                  }),
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
                          value: ((10 / 1.5) * _start) / 100,
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
                    ),
                  ),
                  Positioned.fill(
                    bottom: 5.0.h,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textViewButton(),
                          _captureControlRowWidget(),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
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
                                future: assets[0].asset!.thumbnailData,
                                builder: (_, snapshot) {
                                  final bytes = snapshot.data;
                                  // If we have no data, display a spinner
                                  if (bytes == null)
                                    return Container(
                                        color: Colors.black,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                                strokeWidth: 0.5,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.grey))));
                                  // If there's data, display it as an image
                                  return InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(
                                                          20.0),
                                                  topRight:
                                                      const Radius.circular(
                                                          20.0))),
                                          //isScrollControlled:true,
                                          context: context,
                                          builder: (BuildContext bc) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10.0.h,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0.w,
                                                            vertical: 1.0.h),
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    16.0.sp),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              multiList.forEach(
                                                                  (element) {
                                                                setState(() {
                                                                  assets[element
                                                                          .assetIndex!]
                                                                      .selected = false;
                                                                });
                                                              });
                                                              if (isMultiSelection) {
                                                                setState(() {
                                                                  isMultiSelection =
                                                                      !isMultiSelection;
                                                                  multiList = [
                                                                    assets[
                                                                        selectedIndex]
                                                                  ];
                                                                  multiList[0]
                                                                          .assetIndex =
                                                                      selectedIndex;
                                                                  assets[selectedIndex]
                                                                      .indexNumber = 1;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  isMultiSelection =
                                                                      !isMultiSelection;
                                                                  //assets[selectedIndex].selected = true;
                                                                  //multiList = [assets[selectedIndex]];
                                                                  multiList =
                                                                      [];
                                                                  //multiList[0].assetIndex = selectedIndex;
                                                                  //assets[selectedIndex].indexNumber = 1;
                                                                });
                                                              }
                                                            },
                                                            child: Container(
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    !isMultiSelection
                                                                        ? Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.3)
                                                                        : Colors
                                                                            .blue,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left:
                                                                          1.0.w,
                                                                      top:
                                                                          0.5.h,
                                                                      bottom:
                                                                          1.0.h,
                                                                      right: 2.0
                                                                          .w),
                                                                  child: Stack(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .crop_square_sharp,
                                                                        color: Colors
                                                                            .white,
                                                                        size: 3.0
                                                                            .h,
                                                                      ),
                                                                      Positioned
                                                                          .fill(
                                                                        top: 1.0
                                                                            .w,
                                                                        left: 1.0
                                                                            .w,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .crop_square_sharp,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              3.0.h,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 70.0.h,
                                                    child: Stack(
                                                      children: [
                                                        GridView.builder(
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      3,
                                                                  crossAxisSpacing:
                                                                      3,
                                                                  mainAxisSpacing:
                                                                      3,
                                                                  childAspectRatio:
                                                                      9 / 16),
                                                          itemCount:
                                                              assets.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return AssetThumbnail(
                                                              isMultiOpen:
                                                                  isMultiSelection,
                                                              LongonTap: () {
                                                                setState(() {
                                                                  isMultiSelection =
                                                                      true;
                                                                });
                                                              },
                                                              onTap: () async {
                                                                var file =
                                                                    await assets[
                                                                            index]
                                                                        .asset!
                                                                        .file;
                                                                print(
                                                                    "video selected ${assets[index].asset!.type}");

                                                                if (assets[index]
                                                                        .asset!
                                                                        .videoDuration >
                                                                    new Duration(
                                                                        seconds:
                                                                            60)) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg:
                                                                        AppLocalizations
                                                                            .of(
                                                                      "Video must be less than or equal to 1 minute",
                                                                    ),
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .CENTER,
                                                                    backgroundColor: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7),
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        15.0,
                                                                  );
                                                                } else {
                                                                  if (isMultiSelection) {
                                                                    if (assets[
                                                                            index]
                                                                        .selected!) {
                                                                      int ind =
                                                                          multiList
                                                                              .indexOf(assets[index]);
                                                                      multiList
                                                                          .removeAt(
                                                                              ind);

                                                                      print(thumbs
                                                                          .length
                                                                          .toString());
                                                                    } else {
                                                                      if (multiList
                                                                              .length <
                                                                          15) {
                                                                        multiList
                                                                            .add(assets[index]);
                                                                        multiList[multiList.length - 1].assetIndex =
                                                                            index;

                                                                        print(thumbs
                                                                            .length
                                                                            .toString());
                                                                      } else {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg: AppLocalizations
                                                                              .of(
                                                                            "The Limit Is 15 Photo or Video",
                                                                          ),
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.CENTER,
                                                                          backgroundColor: Colors
                                                                              .black
                                                                              .withOpacity(0.7),
                                                                          textColor:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              15.0,
                                                                        );
                                                                      }
                                                                    }
                                                                    int cnt = 0;
                                                                    multiList
                                                                        .forEach(
                                                                            (element) {
                                                                      cnt++;
                                                                      setState(
                                                                          () {
                                                                        assets[element.assetIndex!].indexNumber =
                                                                            cnt;
                                                                      });
                                                                    });
                                                                    print(multiList
                                                                        .length);
                                                                    setState(
                                                                        () {
                                                                      selectedIndex =
                                                                          index;
                                                                      assets[index]
                                                                          .selected = !assets[
                                                                              index]
                                                                          .selected!;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      selectedIndex =
                                                                          index;
                                                                      multiList =
                                                                          [
                                                                        assets[
                                                                            index]
                                                                      ];
                                                                      multiList[0]
                                                                              .assetIndex =
                                                                          index;
                                                                      multiList[
                                                                              0]
                                                                          .indexNumber = 1;
                                                                    });
                                                                    allFiles.add(
                                                                        file!);

                                                                    if (assets[index]
                                                                            .asset!
                                                                            .type
                                                                            .toString() ==
                                                                        "AssetType.video") {
                                                                      print(
                                                                          "video selected ${assets[index].asset!.type.toString()}");
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MultipleStoriesView(
                                                                                    assetsList: multiList,
                                                                                    whereFrom: widget.whereFrom,
                                                                                    refreshFromMultipleStories: widget.refreshFromMultipleStories,
                                                                                    file: file,
                                                                                    flip: false,
                                                                                    from: "assets",
                                                                                    questionsReplyTextData: questionsReplyViewData,
                                                                                  )));
                                                                    } else {
                                                                      print(multiList
                                                                          .length);
                                                                      print(
                                                                          "multi");
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MultipleStoriesView(
                                                                                    assetsList: multiList,
                                                                                    whereFrom: widget.whereFrom,
                                                                                    refreshFromMultipleStories: widget.refreshFromMultipleStories,
                                                                                    from: "solo",
                                                                                    clear: () {
                                                                                      allFiles.clear();
                                                                                    },
                                                                                    filesList: allFiles,
                                                                                    file: file,
                                                                                    path: file.path,
                                                                                    type: "image",
                                                                                    flip: false,
                                                                                    questionsReplyTextData: questionsReplyViewData,
                                                                                  )));
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                              asset:
                                                                  assets[index],
                                                              setNavbar: widget
                                                                  .setNavbar!,
                                                            );
                                                          },
                                                        ),
                                                        multiList.length > 0 &&
                                                                isMultiSelection
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .black,
                                                                  height:
                                                                      11.0.h,
                                                                  width:
                                                                      100.0.w,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 1.0
                                                                            .w,
                                                                        right: 2.0
                                                                            .w),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              11.0.h,
                                                                          width:
                                                                              75.0.w,
                                                                          child: ListView.builder(
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemCount: multiList.length,
                                                                              itemBuilder: (context, index) {
                                                                                return Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 1.0.h),
                                                                                  child: Container(
                                                                                      decoration: new BoxDecoration(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                        shape: BoxShape.rectangle,
                                                                                        border: new Border.all(
                                                                                          color: Colors.white,
                                                                                          width: 3,
                                                                                        ),
                                                                                      ),
                                                                                      height: 11.0.h,
                                                                                      width: 10.0.w,
                                                                                      child: MiniThumbnails(asset: multiList[index])),
                                                                                );
                                                                              }),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            for (int i = 0;
                                                                                i < multiList.length;
                                                                                i++) {
                                                                              var file = await multiList[i].asset!.file;
                                                                              allFiles.add(file!);
                                                                            }
                                                                            print("multiple story ${allFiles.length}");
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => MultipleStoriesView(
                                                                                          whereFrom: widget.whereFrom,
                                                                                          refreshFromMultipleStories: widget.refreshFromMultipleStories,
                                                                                          from: "assets",
                                                                                          assetsList: multiList,
                                                                                          clear: () {
                                                                                            allFiles.clear();
                                                                                          },
                                                                                          filesList: allFiles,
                                                                                          flip: false,
                                                                                          questionsReplyTextData: questionsReplyViewData,
                                                                                        )));
                                                                          },
                                                                          child: Container(
                                                                              decoration: new BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                shape: BoxShape.rectangle,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                                                                                child: Text(
                                                                                    AppLocalizations.of(
                                                                                      "Next",
                                                                                    ),
                                                                                    style: blackBold.copyWith(fontSize: 15.0.sp)),
                                                                              )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                          });
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
                                  print("tapped on camera");
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
                                        controller.getMinExposureOffset().then(
                                            (value) =>
                                                _minAvailableExposureOffset =
                                                    value),
                                        controller.getMaxExposureOffset().then(
                                            (value) =>
                                                _maxAvailableExposureOffset =
                                                    value),
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
                                        controller.getMinExposureOffset().then(
                                            (value) =>
                                                _minAvailableExposureOffset =
                                                    value),
                                        controller.getMaxExposureOffset().then(
                                            (value) =>
                                                _maxAvailableExposureOffset =
                                                    value),
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
                  if (isTextView)
                    Positioned.fill(
                      bottom: 7.0.h,
                      right: 0,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            print(
                                'this is the tex=${textViewTextController.text}');
                            // tagsList = [(new TagsClass(offset.dx, offset.dy, textViewTextController.text, 1.0, selectedColor, roboto))];
                            print("this tag list=${tagsList}");

                            publishStory();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: allFiles.length > 1 ? 0 : 10),
                            child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.0.w, vertical: 1.7.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Send to",
                                        style: blackBold.copyWith(
                                            fontSize: 12.0.sp),
                                      ),
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 2.0.h,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }

  Widget textViewButton() {
    return InkWell(
      onTap: () {
        // if (!isTextView) {
        //   FocusScope.of(context).unfocus();
        // }
        print("tapped on Aa");
        setState(() {
          isTextView = true;

          controller.dispose();
        });
      },
      child: Container(
        // padding: EdgeInsets.all(20),
        height: 50,
        width: 50,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
              width: 2,
            )),
        child: Center(
          child: Text(
            "Aa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Georgie',
              fontWeight: FontWeight.w700,
              // fontFamily: "Helvetica Neue",
            ),
          ),
        ),
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
      child: controller.value.flashMode == FlashMode.off
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
          : controller.value.flashMode == FlashMode.torch
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

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Container(
        child: isTextView
            ? InkWell(
                onTap: () async {
                  await main();
                  setState(() {
                    isTextView = false;
                  });
                },
                child: Container(
                  child: CircleAvatar(
                    radius: 4.5.h,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 4.1.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 3.8.h,
                        backgroundImage:
                            AssetImage("assets/images/circle-cropped.png"),
                        child: Center(
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : controller != null && controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      onTakePictureButtonPressed();
                    },
                    onLongPress: () {
                      onVideoRecordButtonPressed();
                      startTimer();
                    },
                    onLongPressEnd: (val) {
                      print("stop press");
                      onStopButtonPressed(duration: _start.toString());
                      // onStopButtonPressed();
                      _timer!.cancel();
                      setState(() {
                        _start = 0;
                      });
                    },
                    child: !controller.value.isRecordingVideo
                        ? CircleAvatar(
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
                          )
                        : CircleAvatar(
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
                          ),
                  )
                : Container());
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
        controller
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        controller
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
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
          videoController!.dispose();
          videoController = null;
        });
        File rotatedImage =
            await FlutterExifRotation.rotateImage(path: file!.path);
        allFiles.add(rotatedImage);
        print("camera click ${allFiles.length}");
        onSetFlashModeButtonPressed(FlashMode.off);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultipleStoriesView(
                      whereFrom: widget.whereFrom,
                      refreshFromMultipleStories:
                          widget.refreshFromMultipleStories,
                      from: "camera",
                      clear: () {
                        allFiles.clear();
                      },
                      filesList: allFiles,
                      file: rotatedImage,
                      path: file!.path,
                      type: "image",
                      flip: controller.description.lensDirection ==
                              CameraLensDirection.back
                          ? false
                          : true,
                      questionsReplyTextData: questionsReplyViewData,
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

  void onStopButtonPressed({duration: '0'}) {
    stopVideoRecording().then((file) async {
      onSetFlashModeButtonPressed(FlashMode.off);
      print("video timer heree= $duration");
      if (mounted) setState(() {});
      if (file != null) {
        videoFile = file;
        var newFile = await File(file.path).create(recursive: true);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultipleStoriesView(
                      whereFrom: widget.whereFrom,
                      refreshFromMultipleStories:
                          widget.refreshFromMultipleStories,
                      file: newFile,
                      flip: false,
                      from: "camera",
                      type: "video",
                      videoDuration: duration,
                      questionsReplyTextData: questionsReplyViewData,
                    )));
      }
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar(
        AppLocalizations.of('Video recording paused'),
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
      showInSnackBar(AppLocalizations.of('Error: select a camera first.'));
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

  Future<XFile?> stopVideoRecording() async {
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
      showInSnackBar(AppLocalizations.of('Error: select a camera first.'));
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
  final VoidCallback? LongonTap;
  final bool? isMultiOpen;

  const AssetThumbnail({
    Key? key,
    required this.asset,
    this.setNavbar,
    this.onTap,
    this.LongonTap,
    this.isMultiOpen,
  }) : super(key: key);

  final AssetCustom asset;

  @override
  _AssetThumbnailState createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  late Future future;

  @override
  void initState() {
    future = widget.asset.asset!
        .thumbnailDataWithSize(ThumbnailSize(640, 480), quality: 60);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<dynamic>(
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
          onLongPress: widget.LongonTap ?? () {},
          onTap: widget.onTap ?? () {},
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (widget.asset.asset!.type == AssetType.video)
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
                            widget.asset.asset!.videoDuration
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
                          ? widget.asset.selected! &&
                                  widget.asset.assetIndex != null
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.5)
                          : Colors.transparent,
                      child: widget.isMultiOpen!
                          ? widget.asset.selected! &&
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
  late Future? future;

  @override
  void initState() {
    future = widget.asset.asset!.thumbnailData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<dynamic>(
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

class MusicView extends StatefulWidget {
  final Function? onDone;
  final String? oldQuestionsText;
  final String? songId;
  final String? songImageUrl;
  final String? songTitle;
  final String? songArtist;
  final String? songUrl;
  const MusicView({
    Key? key,
    required this.onDone,
    this.songId,
    this.songImageUrl,
    this.songArtist,
    this.songTitle,
    this.songUrl,
    this.oldQuestionsText,
  }) : super(key: key);

  @override
  _MusicViewState createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView>
    with SingleTickerProviderStateMixin {
  late Duration currentDuration;
  late TextEditingController _controller;
  late AnimationController _animcontroller;
  var player = AudioPlayer();

  @override
  void initState() {
    _controller = TextEditingController(text: widget.oldQuestionsText ?? '');
    _animcontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 10))
          ..repeat();
    player.setUrl(widget.songUrl!);
    player.setLoopMode(LoopMode.all);
    player.play();

    currentDuration = Duration(seconds: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentStyle = "liststyle".obs;
    double getAngle() {
      var value = _animcontroller.value ?? 0;
      return value * 2 * math.pi;
    }

    Widget musicCover(String url) {
      url = url.replaceFirst('{w}', '200');
      url = url.replaceFirst('{h}', '200');
      print("music url=$url");
      return Container(
        height: 6.0.h,
        width: 10.0.w,
        child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
      );
    }

    Widget squaremusicCover(String url) {
      url = url.replaceFirst('{w}', '200');
      url = url.replaceFirst('{h}', '200');
      print("music url=$url");
      return Container(
        height: 25.9.h,
        width: 20.0.h,

        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(imageUrl: url),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${widget.songTitle}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white)),
                      Text(
                        '${widget.songArtist}',
                        style: TextStyle(
                            fontSize: 1.5.h,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )),
            )
          ],
        ),
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     image: DecorationImage(
        //         fit: BoxFit.cover, image: CachedNetworkImageProvider(url))),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await player.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () async {
                    MusicClass musicdata = MusicClass();
                    print("song artist=${widget.songArtist} ");

                    musicdata.songArtist = widget.songArtist;
                    musicdata.songTitle = widget.songTitle;
                    musicdata.songUrl = widget.songUrl;
                    musicdata.songImageUrl = widget.songImageUrl;
                    musicdata.style = currentStyle.value;
                    print("music style=${musicdata.style} ");
                    widget.onDone!(
                      context,
                      musicdata,
                    );
                    player.stop();
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Obx(
              () => Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  currentStyle.value != "liststyle"
                      ? Center(
                          child: Container(
                          height: 40.0.h,
                          width: 40.0.w,
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              squaremusicCover(widget.songImageUrl!),
                              // ListTile(
                              //     visualDensity: VisualDensity(vertical: -3),
                              //     tileColor: Colors.white,
                              //     title: Text('${widget.songTitle}'),
                              //     subtitle: Text('${widget.songArtist}'))
                              // Container(
                              //   alignment: Alignment.,
                              //   color: Colors.white,
                              //   child: ,
                              // )
                            ],
                          ),
                        ))
                      : Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 6.7.h,
                                  width: 80.0.w,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0.w)),
                                    tileColor: Colors.white,
                                    minVerticalPadding: 1.0.h,
                                    leading: musicCover(widget.songImageUrl!),
                                    title: Text('${widget.songTitle}'),
                                    subtitle: Text('${widget.songArtist}'),
                                    style: ListTileStyle.list,
                                    dense: true,
                                    visualDensity: VisualDensity(vertical: -4),
                                    trailing: FittedBox(
                                      child: FittedBox(
                                        child: SpinKitPianoWave(
                                            color: Colors.deepPurple,
                                            size: 3.0.h),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Positioned(
                      child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0.w)),
                    child: Container(
                        height: 10.0.h,
                        width: 50.0.w,
                        child: NotificationListener<UserScrollNotification>(
                          onNotification: (x) {
                            print('direction=${x.direction}');
                            if (x.direction == ScrollDirection.reverse) {
                              print("direction forawrd left");
                              print(
                                  "forward currentsecond=${player.duration!.inSeconds} and forward ${currentDuration}");
                              // player.durationFuture.then((value) =>value,)
                              setState(() {
                                currentDuration = Duration(
                                    seconds: player.position.inSeconds + 1);
                              });
                              if (currentDuration.inSeconds >
                                  player.duration!.inSeconds) {
                                setState(() {
                                  currentDuration = Duration(
                                      seconds: player.duration!.inSeconds);
                                });
                              }
                              player.seek(
                                  Duration(seconds: currentDuration.inSeconds));
                            } else {
                              print("direction forawrd left");
                              print(
                                  "forward currentsecond=${player.duration!.inSeconds} and forward ${currentDuration}");
                              // player.durationFuture.then((value) =>value,)
                              setState(() {
                                currentDuration = Duration(
                                    seconds: player.position.inSeconds - 1);
                                if (currentDuration.isNegative) {
                                  setState(() {
                                    currentDuration = Duration(seconds: 0);
                                  });
                                }
                              });

                              player.seek(
                                  Duration(seconds: currentDuration.inSeconds));
                            }
                            return true;
                          },
                          child: ListView.builder(
                            itemCount: 20,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Row(
                              children: [
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Container(
                                  height: 5.0.h,
                                  width: 1.0.w,
                                  color: Colors.deepPurpleAccent,
                                ),
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Container(
                                  height: 2.0.h,
                                  width: 1.0.w,
                                  color: Colors.deepPurpleAccent,
                                )
                              ],
                            ),
                          ),
                        ),
                        color: Colors.white.withOpacity(0.8)),
                  )),
                  Positioned(
                    height: 50.0.h,
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                currentStyle.value = 'liststyle';
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                child: Icon(Icons.featured_play_list_outlined),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              currentStyle.value = 'squarestyle';
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Icon(
                                Icons.square_outlined,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 80.0.w,
                      height: 10.0.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: Icon(Icons.play_arrow, color: Colors.white),
                      ))
                ],
              ),
            )),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Material(
            //       type: MaterialType.transparency,
            //       child: ClipRRect(
            //         child: Container(
            //           color: Colors.black.withOpacity(8),
            //           height: 5.0.h,
            //           width: 50.0.w,
            //         ),
            //       )

            //       //  InkWell(
            //       //   onTap: () async {
            //       //     MusicClass musicdata = MusicClass();
            //       //     print("song artist=${widget.songArtist}");
            //       //     musicdata.songArtist = widget.songArtist;
            //       //     musicdata.songTitle = widget.songTitle;
            //       //     musicdata.songUrl = widget.songUrl;
            //       //     musicdata.songImageUrl = widget.songImageUrl;

            //       //     widget.onDone(
            //       //       context,
            //       //       musicdata,
            //       //     );
            //       //     player.stop();
            //       //   },
            //       //   child: Text(
            //       //     "Done",
            //       //     style: TextStyle(
            //       //         color: Colors.white,
            //       //         fontWeight: FontWeight.bold,
            //       //         fontSize: 20),
            //       //   ),
            //       // ),
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}
