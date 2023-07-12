import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:math' as math;
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/tags_search_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:bizbultest/widgets/Stories/share_story.dart';
import 'package:bizbultest/widgets/Stories/stickers_page.dart';
import 'package:bizbultest/widgets/Stories/story_widgets.dart';
import 'package:bizbultest/widgets/Stories/timeWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:get/get.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:vibration/vibration.dart';

import '../../api/ApiRepo.dart' as ApiRepo;
import 'add_link.dart';

class MultipleStoriesView extends StatefulWidget {
  final File? file;
  final List<AssetCustom>? assetsList;
  final List<File>? filesList;
  final String? path;
  final String? type;
  final bool? flip;
  final Function? clear;
  final String? from;
  final String? whereFrom;
  final Function? refreshFromMultipleStories;
  final StickerClass? questionsReplyTextData;
  String? videoDuration;
  String? shoppingImage;
  String? shoppingUrl;
  String? shoppingStore;
  String? shoppingItemtitle;
  String? shoppingItemsubtitle;
  String? shoppingItemPrice;

  MultipleStoriesView({
    Key? key,
    this.shoppingItemPrice,
    this.shoppingItemtitle,
    this.shoppingItemsubtitle,
    this.file,
    this.type,
    this.flip,
    this.path,
    this.filesList,
    this.clear,
    this.assetsList,
    this.from,
    this.refreshFromMultipleStories,
    this.whereFrom,
    this.videoDuration = '1',
    this.questionsReplyTextData,
    this.shoppingImage,
    this.shoppingUrl,
    this.shoppingStore,
  }) : super(key: key);

  @override
  _MultipleStoriesViewState createState() => _MultipleStoriesViewState();
}

class TagsClass {
  double? posx;
  double? posy;
  String? name;
  double? scale;
  Color? color;
  TextStyle? font;
  double? h;
  double? w;
  GlobalKey? key = new GlobalKey();

  TagsClass(posx, posy, name, scale, color, font) {
    this.posx = posx;
    this.posy = posy;
    this.name = name;
    this.scale = scale;
    this.color = color;
    this.font = font;
  }
}

class MusicClass {
  String? songArtist;
  String? songTitle;
  String? songUrl;
  String? songImageUrl;
  String? style;
  String? musicStyle;
  MusicClass(
      {this.songArtist,
      this.songTitle,
      this.songUrl,
      this.musicStyle,
      this.songImageUrl,
      this.style}) {
    this.musicStyle = musicStyle;
    this.songArtist = songArtist;
    this.style = style;
    this.songTitle = songTitle;
    this.songUrl = songUrl;
    this.songImageUrl = songImageUrl;
  }
}

class StickerClass {
  double? posx;
  double? posy;
  String? name;
  String? extraName;
  double? scale;
  String? id;
  double? h;
  double? w;
  double? rotation = 0.0;
  double? lastRotation = 0.0;
  MusicClass? musicdata;
  GlobalKey? stickerKey = new GlobalKey();

  StickerClass(posx, posy, name, scale, id,
      {String? extraName, MusicClass? musicdata}) {
    this.posx = posx;
    this.posy = posy;
    this.name = name;
    this.extraName = extraName;
    this.scale = scale;
    this.musicdata = musicdata;
    this.id = id;
  }
}

class _MultipleStoriesViewState extends State<MultipleStoriesView>
    with SingleTickerProviderStateMixin {
  late img.Image image;
  List<AssetCustom> assetsList = [];
  late File finalFile;
  bool showTextField = false;
  PageController pageController = PageController();
  TextEditingController _controller = TextEditingController();
  bool showUsersList = false;
  UserTags tagList = new UserTags([]);
  bool areTagsLoaded = false;
  String userTag = "";
  Offset offset = Offset.zero;
  double angle = 0.0;
  double _baseScaleFactor = 1.0;
  bool rotate = false;
  double h = 50;
  bool isScrollable = true;
  List<File> allFiles = [];
  var keyText = GlobalKey();
  Size size = Size(0, 0);
  Offset position = Offset(100, 100);
  List<String> videoDuration = [];
  double w = 100.0.w;
  List<List<TagsClass>> tagsList = [];
  List<List<TagsClass>> mentionUserList = [];
  List<List<StickerClass>> stickerList = [];
  bool showColors = false;
  bool showFonts = false;
  int selectedFontIndex = 5;
  Color selectedColor = Colors.white;
  GlobalKey _globalKey = new GlobalKey();
  GlobalKey deleteKey = new GlobalKey();
  TextStyle roboto = GoogleFonts.roboto();
  int currentEditingTag = -1;
  int currentIndex = 0;
  List<String> links = [];
  Offset deletePosition = Offset(0, 0);
  bool deleteIconColor = false;
  int duration = 0;
  List abc = [];
  late MusicClass musicData;
  List<MusicClass> musicDataList = [];
  var thisplayer = AudioPlayer();
  var currentDuration = Duration(seconds: 0);
  late StickerClass questionsReplyTextData;
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

  bool inside = false;
  bool keyboardVisible = false;
  List<String> mentionedUsersList = [];
  late Uint8List imageInMemory;
  int selectedIndex = 0;
  bool isTagSelected = false;
  late int postID;

  late String dir;

  Future getDirectory() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/MyImages';
    setState(() {
      dir = myImagePath;
    });
    final myImgDir = await new Directory(myImagePath).create();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  // ignore: missing_return
  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image? image = await boundary!.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      print('png done');
      final newImage = img.decodeImage(pngBytes);
      //var encodeImage = img.encodeJpg(newImage, quality: 100);
      var finalImage = new File("$dir/${generateRandomString(12)}.jpg")
        ..writeAsBytesSync(img.encodeJpg(newImage!, quality: 100));
      print(finalImage.path);
      GallerySaver.saveImage(finalImage.path, albumName: "Bebuzee");
      setState(() {
        imageInMemory = pngBytes;
      });
      return pngBytes;
    } catch (e) {
      return null;
    }
  }

  void onTap(int pageIndex) {
    print("tapped photo");
    setState(() {
      showTextField = !showTextField;
    });
    if (showTextField) {
      Timer(Duration(milliseconds: 0), () {
        setState(() {
          showFonts = true;
          showColors = false;

          showUsersList = false;
          showHashtags = false;
          keyboardVisible = true;
          print(
              "yeah am here $showFonts $showUsersList $showHashtags ${keyboardVisible} ${CurrentUser().currentUser.keyBoardHeight}");
          selectedColor = selectedColor ?? Colors.white;
          roboto = roboto ?? GoogleFonts.roboto();
          selectedFontIndex = selectedFontIndex ?? 5;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            print(EdgeInsets.fromWindowPadding(
                    WidgetsBinding.instance.window.viewInsets,
                    WidgetsBinding.instance.window.devicePixelRatio)
                .toString());
            print(WidgetsBinding.instance.window.viewInsets);
            print(WidgetsBinding.instance.window.devicePixelRatio);
            CurrentUser().currentUser.keyBoardHeight = double.parse(
                EdgeInsets.fromWindowPadding(
                        WidgetsBinding.instance.window.viewInsets,
                        WidgetsBinding.instance.window.devicePixelRatio)
                    .toString()
                    .replaceAll("EdgeInsets", "")
                    .replaceAll("(", "")
                    .replaceAll(")", "")
                    .split(", ")[3]);
          });
        });
        print(CurrentUser().currentUser.keyBoardHeight);
      });
    }
    if (!showTextField && _controller.text != "" && currentEditingTag < 0) {
      setState(() {
        showFonts = false;
        showColors = false;
        //

        //
        offset = Offset.zero;
        if (currentEditingTag < 0) {
          tagsList[pageIndex] = [
            TagsClass(offset.dx, offset.dy, _controller.text, 1.0,
                selectedColor, roboto)
          ];
          // _controller.text = "";
        } else {
          tagsList[pageIndex].add(new TagsClass(offset.dx, offset.dy,
              _controller.text, 1.0, selectedColor, roboto));
          _controller.text = "";
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // final RenderObject? box = tagsList[pageIndex]
        //         [tagsList[pageIndex].length - 1]
        //     .key!
        //     .currentContext
        //     ?.findRenderObject();
        final RenderRepaintBoundary? box = tagsList[pageIndex]
                [tagsList[pageIndex].length - 1]
            .key!
            .currentContext
            ?.findRenderObject() as RenderRepaintBoundary;

        setState(() {
          tagsList[pageIndex][tagsList[pageIndex].length - 1].w =
              box!.size.width;
          tagsList[pageIndex][tagsList[pageIndex].length - 1].h =
              box.size.height;
        });
      });
    } else {
      setState(() {
        currentEditingTag = -1;
      });
    }
  }

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

  void calculatePosition() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderRepaintBoundary? box =
          deleteKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // final RenderBox box = deleteKey.currentContext!.findRenderObject();
      setState(() {
        deletePosition = box.localToGlobal(Offset.zero);
      });
    });
  }

  var timezone;

  Future<String> getTimezone() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    if (mounted) {
      setState(() {
        timezone = locationX["timezone"];
      });
    }

    return "Success";
  }

  Future<void> uploadStory(
      String allTags,
      String stickers,
      String durations,
      String assetImageData,
      String timeViewData,
      String hashtagdata,
      String mentions,
      String location,
      String questions,
      String questionsreply,
      String musicViewData,
      String musicContent,
      {String? musicStyle}) async {
    print("============================================questionsreply");
    print(questionsreply);
    print("final duration=${durations}");
    print("location data=${location}");
    // String url =
    //     "https://www.upload.bebuzee.com/story_upload_api.php?action=upload_story_post&tagged_member=$allTags&questions=$questions&stickers=$stickers&assetImageData=${assetImageData}&user_id=${CurrentUser().currentUser.memberID}&tagged_user_ids=${mentionedUsersList.join(",")}&link=${links.join("~~~")}&video_playtime=$durations&timeView=$timeViewData&hashtag=$hashtagdata&mantion=$mentions&locationtext=$location&questionsReplyData=$questionsreply";
    String url = 'https://www.bebuzee.com/api/storyAdd';

    // ApiRepo.baseUrl + "api/upload_story_post.php";

    print("musicviewdata-----${url}");
    var sendData = {
      "tagged_member": allTags,
      "questions": questions,
      "stickers": stickers,
      "assetImageData": assetImageData,
      "storytype": "story",
      "user_id": CurrentUser().currentUser.memberID,
      "tagged_user_ids": mentionedUsersList.join(","),
      "link": links.join("~~~"),
      "video_playtime": durations,
      "timeView": timeViewData,
      "hashtag": hashtagdata,
      "mantion": mentions,
      "locationtext": location,
      "video_volume": musicData != null ? false : true,
      "music": musicContent
      // musicData == null
      //     ? ""
      //     : "${musicData.songTitle}^^${musicData.songArtist}^^${musicData.songImageUrl}^^${musicData.songUrl}",
      ,
      "music_data": musicViewData,
      "music_style": musicStyle
    };
    print("musiclist=${musicDataList}");
    print("sendStory data=${sendData}");
    var feedController = Get.put(FeedController());
    feedController.uploadFeedPost(allFiles, url, sendData);
  }

  void publishStory() {
    List<String> tags = [];
    List<String?> stickers = [];
    List<String> timeView = [];
    List<String> questionsView = [];
    List<String> mainimageview = [];
    List<String> hashtagview = [];
    List<String> locationview = [];
    List<String> mentionsText = [];
    List<String> musicView = [];
    List<String> musicViewTest = [];
    List<String> musicContent = [];
    List<String> musicStyle = [];

    if (allFiles.length > 1) {
      for (int i = 0; i < tagsList.length; i++) {
        for (int j = 0; j < tagsList[i].length; j++) {
          if (widget.assetsList![i].asset!.type.toString() ==
              "AssetType.video") {
            tags.add("video_" +
                (i + 1).toString() +
                "^^" +
                tagsList[i][j].posx.toString() +
                "^^" +
                tagsList[i][j].posy.toString() +
                "^^" +
                tagsList[i][j].name!.replaceAll("#", "@@@") +
                "^^" +
                "${tagsList[i][j].color!.red.toString() + "," + tagsList[i][j].color!.green.toString() + "," + tagsList[i][j].color!.blue.toString()}" +
                "^^" +
                tagsList[i][j].font!.fontFamily.toString() +
                "^^" +
                tagsList[i][j].scale.toString() +
                "^^" +
                tagsList[i][j].h.toString() +
                "^^" +
                tagsList[i][j].w.toString());
          } else {
            tags.add("image_" +
                (i + 1).toString() +
                "^^" +
                tagsList[i][j].posx.toString() +
                "^^" +
                tagsList[i][j].posy.toString() +
                "^^" +
                tagsList[i][j].name!.replaceAll("#", "@@@") +
                "^^" +
                "${tagsList[i][j].color!.red.toString() + "," + tagsList[i][j].color!.green.toString() + "," + tagsList[i][j].color!.blue.toString()}" +
                "^^" +
                tagsList[i][j].font!.fontFamily.toString() +
                "^^" +
                tagsList[i][j].scale.toString() +
                "^^" +
                tagsList[i][j].h.toString() +
                "^^" +
                tagsList[i][j].w.toString());
          }
        }
      }

      for (int i = 0; i < stickerList.length; i++) {
        for (int j = 0; j < stickerList[i].length; j++) {
          if (widget.assetsList![i].asset!.type.toString() ==
              "AssetType.video") {
            stickers.add("video_" +
                (i + 1).toString() +
                "^^" +
                stickerList[i][j].posx.toString() +
                "^^" +
                stickerList[i][j].posy.toString() +
                "^^" +
                stickerList[i][j].name!.replaceAll("#", "@@@") +
                "^^" +
                stickerList[i][j].id! +
                "^^" +
                stickerList[i][j].scale.toString());
          } else {
            stickers.add("image_" +
                (i + 1).toString() +
                "^^" +
                stickerList[i][j].posx.toString() +
                "^^" +
                stickerList[i][j].posy.toString() +
                "^^" +
                stickerList[i][j].name!.replaceAll("#", "@@@") +
                "^^" +
                stickerList[i][j]!.id! +
                "^^" +
                stickerList[i][j].scale.toString());
          }
        }
      }
      for (int i = 0; i < mentionUserList.length; i++) {
        for (int j = 0; j < mentionUserList[i].length; j++) {
          mentionsText.add("mantion_" +
              (i + 1).toString() +
              "^^" +
              mentionUserList[i][j].name!.trim().replaceAll("#", "") +
              "^^" +
              mentionUserList[i][j].posx.toString() +
              "^^" +
              mentionUserList[i][j].posy.toString() +
              "^^" +
              mentionUserList[i][j].scale.toString());
        }
      }
    } else {
      for (int i = 0; i < tagsList.length; i++) {
        for (int j = 0; j < tagsList[i].length; j++) {
          tags.add("video_" +
              (i + 1).toString() +
              "^^" +
              tagsList[i][j].posx.toString() +
              "^^" +
              tagsList[i][j].posy.toString() +
              "^^" +
              tagsList[i][j].name!.replaceAll("#", "@@@") +
              "^^" +
              "${tagsList[i][j].color!.red.toString() + "," + tagsList[i][j].color!.green.toString() + "," + tagsList[i][j].color!.blue.toString()}" +
              "^^" +
              tagsList[i][j].font!.fontFamily.toString() +
              "^^" +
              tagsList[i][j].scale.toString() +
              "^^" +
              tagsList[i][j].h.toString() +
              "^^" +
              tagsList[i][j].w.toString());
        }
      }

      for (int i = 0; i < stickerList.length; i++) {
        for (int j = 0; j < stickerList[i].length; j++) {
          stickers.add("video_" +
              (i + 1).toString() +
              "^^" +
              stickerList[i][j].posx.toString() +
              "^^" +
              stickerList[i][j].posy.toString() +
              "^^" +
              stickerList[i][j].name!.replaceAll("#", "@@@") +
              "^^" +
              stickerList[i][j].id! +
              "^^" +
              stickerList[i][j].scale.toString());
        }
      }
      for (int i = 0; i < mentionUserList.length; i++) {
        for (int j = 0; j < mentionUserList[i].length; j++) {
          mentionsText.add("mantion_" +
              (i + 1).toString() +
              "^^" +
              mentionUserList[i][j].name!.trim().replaceAll("#", "") +
              "^^" +
              mentionUserList[i][j].posx.toString() +
              "^^" +
              mentionUserList[i][j].posy.toString() +
              "^^" +
              mentionUserList[i][j].scale.toString());
        }
      }
    }

    print(stickers.join("~~~"));

    for (int i = 0; i < timeViewData.length; i++) {
      timeView.add(timeViewData[i].name!.replaceAll("#", "@@@") +
          "^^" +
          timeViewData[i].posx.toString() +
          "^^" +
          timeViewData[i].posy.toString() +
          "^^" +
          timeViewData[i].scale.toString() +
          "^^" +
          timeViewData[i].rotation.toString());
    }

    for (int i = 0; i < mainImageViewData.length; i++) {
      mainimageview.add("image_" +
          (i).toString() +
          "^^" +
          mainImageViewData[i].posx.toString() +
          "^^" +
          mainImageViewData[i].posy.toString() +
          "^^" +
          mainImageViewData[i].scale.toString() +
          "^^" +
          mainImageViewData[i].rotation.toString());
    }

    for (int i = 0; i < hashtagViewData.length; i++) {
      hashtagview.add(
          // "hash_" +
          // (i).toString() +
          // "^^" +
          hashtagViewData[i]!.name!.replaceAll("#", "@@@") +
              "^^" +
              hashtagViewData[i]!.posx.toString() +
              "^^" +
              hashtagViewData[i]!.posy.toString() +
              "^^" +
              hashtagViewData[i]!.scale.toString() +
              "^^" +
              hashtagViewData[i]!.rotation.toString());
    }

    for (int i = 0; i < locationViewData.length; i++) {
      locationview.add(
          // "hash_" +
          // (i).toString() +
          // "^^" +
          locationViewData[i].name!.replaceAll("#", "") +
              "^^" +
              locationViewData[i].posx.toString() +
              "^^" +
              locationViewData[i].posy.toString() +
              "^^" +
              locationViewData[i].scale.toString() +
              "^^" +
              locationViewData[i].rotation.toString());
    }
    for (int i = 0; i < musicViewData.length; i++) {
      musicView.add(
          // "hash_" +
          // (i).toString() +
          // "^^" +
          musicViewData[i].name!.replaceAll("#", "") +
              "^^" +
              musicViewData[i].posx.toString() +
              "^^" +
              musicViewData[i].posy.toString() +
              "^^" +
              musicViewData[i].scale.toString() +
              "^^" +
              musicViewData[i].rotation.toString());
      if (musicViewData[i].name == '') {
        musicContent.add(' ');
        musicStyle.add(' ');
      } else {
        musicViewData[i].musicdata!.songArtist;
        musicViewData[i].musicdata!.songImageUrl;
        musicViewData[i].musicdata!.songUrl;

        musicContent.add(musicViewData[i]!.name! +
            "^^" +
            musicViewData[i].musicdata!.songArtist.toString() +
            "^^" +
            musicViewData[i].musicdata!.songImageUrl.toString() +
            "^^" +
            musicViewData[i].musicdata!.songUrl.toString());
        musicStyle.add(musicViewData[i].musicdata!.style!);
      }
    }

    for (int i = 0; i < questionsViewData.length; i++) {
      questionsView.add(
          // "hash_" +
          // (i).toString() +
          // "^^" +
          questionsViewData[i]!.name!.replaceAll("#", "") +
              "^^" +
              questionsViewData[i]!.posx.toString() +
              "^^" +
              questionsViewData[i]!.posy.toString() +
              "^^" +
              questionsViewData[i]!.scale.toString() +
              "^^" +
              questionsViewData[i]!.rotation.toString());
    }

    showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        context: context,
        builder: (BuildContext bc) {
          print(assetsList.length);
          print("assets");
          return ShareStory(
            asset: widget.assetsList == null
                ? null
                : widget.assetsList![currentIndex].asset,
            stopMusicPlayer: () {},
            cameraFile: widget.file,
            onTap: () {
              thisplayer.dispose();

              if (widget.assetsList != null) {
                if (assetsList.length > 1) {
                  for (int i = 0; i < assetsList.length; i++) {
                    if (assetsList[i].asset!.type.toString() ==
                        "AssetType.video") {
                      videoDuration.add("video_" +
                          (i + 1).toString() +
                          "^^" +
                          assetsList[i]
                              .asset!
                              .videoDuration
                              .inSeconds
                              .toString());
                    }
                  }
                } else {
                  videoDuration.add("video_1" +
                      "^^" +
                      widget.assetsList![0].asset!.videoDuration.inSeconds
                          .toString());
                }
              }

              print(videoDuration.join("~~~"));
              print(tags.join("~~~"));
              print(
                  "sending music pos ${musicViewData[0].posx}  ${musicViewData[0].posy}");
              print(
                  "sending music=contentt ${musicStyle.join('~~~').replaceAll(" ", '')}");
              print("${locationview.join('~~~')}");
              print("sending music pos 2${mentionsText.join("~~~")}");
              uploadStory(
                  tags.join("~~~"),
                  stickers.join("~~~"),
                  widget.type == "video"
                      ? 'video_1^^${widget.videoDuration}'
                      : videoDuration.join("~~~"),
                  mainimageview.join("~~~"),
                  timeViewData != null ? timeView.join("~~~") : "",
                  hashtagViewData != null ? hashtagview.join("~~~") : "",
                  mentionsText.join("~~~"),
                  locationViewData != null ? locationview.join("~~~") : "",
                  questionsViewData != null ? questionsView.join("~~~") : "",
                  questionsReplyTextData != null
                      ? "${questionsReplyTextData.name}~~${questionsReplyTextData.extraName}^^${questionsReplyTextData.posx}^^${questionsReplyTextData.posy}^^${questionsReplyTextData.scale}^^${questionsReplyTextData.rotation}"
                      : "",
                  musicViewData != null ? musicView.join('~~~') : "",
                  musicContent != null
                      ? musicContent.join('~~~').replaceAll(' ', '')
                      : '',
                  musicStyle: musicStyle != null
                      ? musicStyle.join('~~~').replaceAll(" ", '')
                      : '');

              Navigator.pop(bc);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          );
        }).whenComplete(() {
      FeedController feedController = Get.put(FeedController());
      Timer(Duration(milliseconds: 500), () {
        feedController.resetDirectList();
      });
    });
  }

  void _compressFile(File file) async {
    print(file.path);

    if (file.path.toString().contains("_compressed")) {
      print("contains");
      setState(() {
        allFiles.add(file);
      });
    } else {
      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 65, percentage: 60);
      setState(() {
        allFiles.add(compressedFile);
      });
    }
  }

  Future loadSingleFile() async {
    allFiles.add(widget.file!);
    //img.Image drawImage = img.drawString(image, img.arial_48, 250, 250, "Helooooooooooooo");
  }

  Future loadMultipleFiles() async {
    for (int i = 0; i < widget.assetsList!.length; i++) {
      var file = await widget.assetsList![i].asset!.file;
      if (widget.assetsList![i].asset!.type.toString() != "AssetType.video") {
        _compressFile(file!);
        print(file!.path);
        print("compressed");
      } else {
        setState(() {
          allFiles.add(file!);
        });
      }
    }
  }

  Future<void> getUserTags(String searchedTag) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/user/userSearchFollowers", {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": searchedTag
    });

    if (response!.success == 1) {
      UserTags tagsData = UserTags.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          tagList = tagsData;
          areTagsLoaded = true;
        });
      }
    }

    if (response!.data == null ||
        response!.data['data'] == null ||
        response!.data['data'] == []) {
      setState(() {
        areTagsLoaded = false;
      });
    }
  }

  TagPlaces tags = new TagPlaces([]);
  bool hasData = false;
  bool showHashtags = false;

  Future<void> getHashtags(text) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_hashtags_tags_data&user_id=${CurrentUser().currentUser.memberID}&keyword=$text");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/search_hastag_list.php",
        {"user_id": CurrentUser().currentUser.memberID, "keyword": text});

    if (response!.success == 1) {
      TagPlaces tagData = TagPlaces.fromJson(response!.data['data']);
      print(CurrentUser().currentUser.keyBoardHeight);
      if (mounted) {
        setState(() {
          tags = tagData;
          hasData = true;
        });
      }

      if (response!.data == null ||
          response!.data['data'] == null ||
          response!.data['data'] == []) {
        setState(() {
          hasData = false;
        });
      }
    }
  }

  void _showStickersPage() {
    showMaterialModalBottomSheet(
        isDismissible: true,
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
                stickerList[currentIndex]
                    .add(new StickerClass(offset.dx, offset.dy, name, 1.0, id));
              });
              Navigator.pop(stickerContext);
            },
            emojiDetails: (name, id) {
              setState(() {
                offset = Offset.zero;
                stickerList[currentIndex]
                    .add(new StickerClass(offset.dx, offset.dy, name, 1.0, id));
              });
              Navigator.pop(stickerContext);
            },
            gifsDetails: (name, id) {
              setState(() {
                offset = Offset.zero;
                stickerList[currentIndex]
                    .add(new StickerClass(offset.dx, offset.dy, name, 1.0, id));
              });
              Navigator.pop(stickerContext);
            },
            activitySelect: (String type,
                {song_id: '',
                song_image_url: '',
                song_title: '',
                song_artist: '',
                song_url: ''}) async {
              if (type == "music") {
                print("music aha ${song_id} ${song_image_url}");
                openMusicInputView(
                  song_id: song_id,
                  song_image_url: song_image_url,
                  song_title: song_title,
                  song_artist: song_artist,
                  song_url: song_url,
                );

                //    QuestionsInputView(
                //     oldQuestionsText: questionsViewData[currentIndex]?.name ?? '',
                //     onDone: (hashtagContext, val) {
                //       setState(() {
                //         isquestionsViewAdd = true;
                //         questionsViewData[currentIndex] =
                //             StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
                //       });
                //       Navigator.pop(hashtagContext);
                //     },
                //   ),
                // );
                // openMusicInputView(
                //     song_id: song_id, song_image_url: song_image_url);
                // await showBarModalBottomSheet(
                //     context: context,
                //     builder: (ctx) => Container(
                //           height: 40.0.h,
                //           width: 100.0.w,
                //           color: Colors.white,
                //         ));
              }
              if (type == "time") {
                setState(() {
                  isTimeViewAdd = true;
                  offset = Offset.zero;
                  timeViewData[currentIndex] = (StickerClass(offset.dx,
                      offset.dy, DateTime.now().toIso8601String(), 1.0, "-1"));
                  print(
                      "------------------------------------------------------------------------");
                });
              }
              if (type == "hashtag") {
                // setState(() {
                //   ishastagViewAdd = true;
                //   hashtagViewData[currentIndex] = StickerClass(offset.dx, offset.dy, "", 1.0, "-1");
                // });
                print("hastag view");
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

  // void openQuestionsInputView() {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => QuestionsInputView(
  //       oldQuestionsText: questionsViewData[currentIndex]?.name ?? '',
  //       onDone: (hashtagContext, val) {
  //         setState(() {
  //           isquestionsViewAdd = true;
  //           questionsViewData[currentIndex] =
  //               StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
  //         });
  //         Navigator.pop(hashtagContext);
  //       },
  //     ),
  //   );
  // }

  void openLocationInputView() {
    showDialog(
      context: context,
      builder: (ctx) => LocationInputView(
        oldLocation: locationViewData[currentIndex]?.name ?? '',
        onDone: (hashtagContext, val) {
          setState(() {
            islocationViewAdd = true;
            print(
                "currentIndex=$currentIndex musicViewLlength=${locationViewData.length}");
            locationViewData[currentIndex] =
                StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          });
          Navigator.pop(hashtagContext);
        },
      ),
    );
  }

  void openQuestionsInputView() {
    showDialog(
      context: context,
      builder: (ctx) => QuestionsInputView(
        oldQuestionsText: questionsViewData[currentIndex]?.name ?? '',
        onDone: (hashtagContext, val) {
          setState(() {
            isquestionsViewAdd = true;
            questionsViewData[currentIndex] =
                StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          });
          Navigator.pop(hashtagContext);
        },
      ),
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

  void openMusicInputView(
      {song_id: '',
      song_image_url: '',
      song_title: '',
      song_artist: '',
      song_url: ''}) {
    print("music current index=${currentIndex}");
    showDialog(
      context: context,
      builder: (ctx) => MusicView(
        songId: song_id,
        songImageUrl: song_image_url,
        songUrl: song_url,
        songTitle: song_title,
        songArtist: song_artist,
        oldQuestionsText: questionsViewData[currentIndex]?.name ?? '',
        onDone: (hashtagContext, MusicClass val) async {
          setState(() {
            // print(
            //     "reached here= ${currentIndex} len= ${musicViewData[currentIndex].musicdata.songTitle}");
            ismusicViewAdd = true;
            print(
                "currentIndex=$currentIndex musicViewLlength=${musicViewData.length}");

            // if (currentIndex < musicViewData.length) {
            //   musicViewData.add(StickerClass(
            //       offset.dx, offset.dy, ' ', 0.4, "-1",
            //       musicdata: val));
            //   // musicViewData.add(StickerClass(
            //   //     offset.dx, offset.dy, ' ', 0.3, "-1",
            //   //     musicdata: val));
            //   musicViewData[currentIndex].h = 100.0.h;
            //   musicViewData[currentIndex].w = 100.0.w;
            // } else {
            musicViewData[currentIndex] = StickerClass(
              offset.dx,
              offset.dy,
              '${val.songTitle}',
              0.4,
              "-1",
              musicdata: val,
            );
            print(
                "currentIndex=$currentIndex musicViewLlength=${musicViewData.length} aha");
            musicViewData[currentIndex].h = 100.0.h;
            musicViewData[currentIndex].w = 100.0.w;
            print(
                "current height=${musicViewData.first.h} width=${musicViewData.first.w}");
            // }

            musicData = val;
            try {
              musicDataList[currentIndex] = val;
            } catch (e) {
              musicDataList.add(val);
            }
            print("reached here 2");
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

          currentDuration = thisplayer!.duration!;

          print("music end");
        },
      ),

      //  MusicInputView(
      //   song_id: song_id ?? '',
      //   song_image_url: song_image_url ?? "",
      //   onDone: (hashtagContext, val) {
      //     // setState(() {
      //     isquestionsViewAdd = true;
      //     // questionsViewData =
      //     //     StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
      //     // });
      //     Navigator.pop(hashtagContext);
      //   },
      // ),
    );
  }

  void openDataViewMigrate() async {}
  void openHashTagInputView() {
    showDialog(
      context: context,
      builder: (ctx) => HashTagSelectView(
        oldHashtag: hashtagViewData[currentIndex]!.name!.toUpperCase(),
        onDone: (hashtagContext, val) {
          setState(() {
            ishastagViewAdd = true;
            print("on add hashtag name=${offset.dx} ${offset.dy}");
            hashtagViewData[currentIndex] =
                StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          });
          Navigator.pop(hashtagContext);
        },
      ),
    );
  }

  void openMentionInputView() {
    showDialog(
      context: context,
      builder: (ctx) => MentionSelectView(
        // oldHashtag: hashtagViewData[currentIndex]?.name?.toUpperCase(),
        onDone: (hashtagContext, val, mentionUserId) {
          setState(() {
            offset = Offset.zero;
            ismentionUserViewAdd = true;
            mentionUserList[currentIndex]
                .add(TagsClass(offset.dx, offset.dy, val, 1.0, null, null));
            mentionUserIdList[currentIndex].add(mentionUserId);
            StickerClass(offset.dx, offset.dy, val, 1.0, "-1");
          });
          Navigator.pop(hashtagContext);
        },
      ),
    );
  }

  Widget squaremusicCoverTest(String url) {
    url = url.replaceFirst('{w}', '200');
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
                    Text('${musicViewData[currentIndex].musicdata!.songTitle}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white)),
                    Text(
                      '${musicViewData[currentIndex].musicdata!.songArtist}',
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

  @override
  void initState() {
    // getTimezone();
    if (widget.from == "camera") {
      timeViewData.add(StickerClass(offset.dx, offset.dy, "", 0.0, "-1"));
      hashtagViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      questionsViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      musicViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      mentionUserList.add([]);
      print(
          "camera here 1 widget.assetlist=${widget.assetsList} ${widget.videoDuration} ");
    }
    if (widget.from == "assets") {
      loadMultipleFiles();
      for (int i = 0; i < widget.assetsList!.length; i++) {
        assetsList.add(widget.assetsList![i]);
        tagsList.add([]);
        stickerList.add([]);
        timeViewData.add(StickerClass(offset.dx, offset.dy, "", 0.0, "-1"));
        mainImageViewData
            .add(StickerClass(offset.dx, offset.dy, "mainImage", 1.0, "-1"));
        hashtagViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
        locationViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
        musicViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
        questionsViewData
            .add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
        mentionUserList.add([]);
      }
    } else if (widget.from == 'shopbuz') {
      timeViewData.add(StickerClass(offset.dx, offset.dy, "", 0.0, "-1"));
      hashtagViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      questionsViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      musicViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      locationViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      questionsViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      mentionUserList.add([]);
      tagsList.add([]);
      stickerList.add([]);
      print("i am here story shop");
    } else {
      loadSingleFile();
      tagsList.add([]);
      stickerList.add([]);
    }
    getDirectory();
    if (widget.from == "solo") {
      timeViewData.add(StickerClass(offset.dx, offset.dy, "", 0.0, "-1"));
      mainImageViewData
          .add(StickerClass(offset.dx, offset.dy, "mainImage", 1.0, "-1"));
      hashtagViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      musicViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));

      locationViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
      questionsViewData.add(StickerClass(offset.dx, offset.dy, "", 1.0, "-1"));
    }
    mentionUserList.add([]);
    mentionUserIdList.add([]);
    questionsReplyTextData = widget.questionsReplyTextData!;
    print("i am here story shop 2");
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

  List<StickerClass> mainImageViewData = [];
  List<StickerClass> timeViewData = [];
  List<StickerClass?> hashtagViewData = [];
  List<StickerClass?> questionsViewData = [];
  List<StickerClass> musicViewData = [];
  List<StickerClass> locationViewData = [];
  List<List<String>> mentionUserIdList = [];
  bool isTimeViewAdd = false;
  bool ishastagViewAdd = false;
  bool ismusicViewAdd = false;
  bool islocationViewAdd = false;
  bool isquestionsViewAdd = false;
  bool ismentionUserViewAdd = false;
  double _baseScaleFactorHastag = 1.0;
  Offset hastagOffset = Offset.zero;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          widget!.clear!();
          return true;
        },
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Column(
                  children: [
                    RepaintBoundary(
                      key: _globalKey,
                      child: Container(
                        height: 90.0.h,
                        child: PageView.builder(
                            controller: pageController,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                widget.from == "shopbuz" ? 1 : allFiles.length,
                            itemBuilder: (context, pageIndex) {
                              // print("Asset type=${allFiles[pageIndex]}");
                              // return Container(
                              //   child: Image.file(
                              //     allFiles[pageIndex],
                              //     height: 90.0.h,
                              //     width: 100.0.w,
                              //     fit: BoxFit.cover,
                              //   ),
                              // );
                              // return
                              //  Container(
                              //               child: widget.assetsList[pageIndex]
                              //                           .asset.type
                              //                           .toString() ==
                              //                       "AssetType.image"
                              //                   ? Container(
                              //                       child: Image.file(
                              //                         allFiles[pageIndex],
                              //                         height: 90.0.h,
                              //                         width: 100.0.w,
                              //                         fit: BoxFit.cover,
                              //                       ),
                              //                     ):

                              // Container(
                              //   height: 80.0.h,
                              //   width: 80.0.w,
                              //   child: Text(
                              //       'here  ${allFiles.length}   ${widget.assetsList[pageIndex].asset.type.toString()} '),
                              //   color: Colors.pink,
                              // ));
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print("tapa");
                                      onTap(pageIndex);
                                    },
                                    child: widget.from == "shopbuz"
                                        ? Center(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              3.0.w))),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3.0.w)),
                                                child: Container(
                                                    height: 50.0.h,
                                                    width: 70.0.w,
                                                    color: Colors.white10,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                                leading:
                                                                    CircleAvatar(
                                                                  backgroundImage:
                                                                      CachedNetworkImageProvider(
                                                                          widget
                                                                              .shoppingStore!),
                                                                ),
                                                                title: Text(
                                                                  'Adidas',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(3.0
                                                                              .w)),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: CachedNetworkImageProvider(
                                                                          widget
                                                                              .shoppingImage!))),
                                                              height: 30.0.h,
                                                              width: 60.0.w,
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                '${widget.shoppingItemtitle}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              subtitle: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      '${widget.shoppingItemsubtitle}'),
                                                                  SizedBox(
                                                                    height:
                                                                        0.5.h,
                                                                  ),
                                                                  Text(
                                                                      '${widget.shoppingItemPrice}'),
                                                                ],
                                                              ),
                                                              trailing: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(Colors
                                                                              .black)),
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                      'View')),
                                                            ),
                                                          ],
                                                        ))),
                                              ),
                                            ),
                                          )
                                        : widget.assetsList != null
                                            ? Container(
                                                child: widget
                                                            .assetsList![
                                                                pageIndex]
                                                            .asset!
                                                            .type
                                                            .toString() !=
                                                        "AssetType.video"
                                                    ? Container(
                                                        height: 90.0.h,
                                                        width: 100.0.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: FileImage(
                                                                allFiles[
                                                                    pageIndex]),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        // color:Colors.black,
                                                        child: ClipRRect(
                                                          child: BackdropFilter(
                                                            filter: ImageFilter
                                                                .blur(
                                                                    sigmaX: 50,
                                                                    sigmaY: 50),
                                                            child: Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              children: [
                                                                Positioned.fill(
                                                                  left: mainImageViewData[
                                                                              currentIndex]!
                                                                          .posx! -
                                                                      0,
                                                                  top: mainImageViewData[
                                                                              currentIndex]!
                                                                          .posy! -
                                                                      0,
                                                                  right: 0,
                                                                  bottom: 0,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        XGestureDetector(
                                                                      behavior:
                                                                          HitTestBehavior
                                                                              .deferToChild,
                                                                      onScaleStart:
                                                                          (details) {
                                                                        setState(
                                                                            () {
                                                                          _baseScaleFactor =
                                                                              mainImageViewData[currentIndex].scale!;
                                                                        });
                                                                      },
                                                                      onScaleEnd:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          mainImageViewData[currentIndex].lastRotation =
                                                                              mainImageViewData[currentIndex].rotation;
                                                                        });
                                                                      },
                                                                      onScaleUpdate:
                                                                          (details) {
                                                                        print(
                                                                            "scaling image");
                                                                        setState(
                                                                            () {
                                                                          mainImageViewData[currentIndex].rotation =
                                                                              mainImageViewData[currentIndex].lastRotation! - details.rotationAngle;
                                                                          mainImageViewData[currentIndex].scale =
                                                                              _baseScaleFactor * details.scale;
                                                                        });
                                                                      },
                                                                      // onMoveStart:
                                                                      //     (details) {
                                                                      //   setState(
                                                                      //       () {
                                                                      //     offset = Offset(
                                                                      //         mainImageViewData[currentIndex].posx,
                                                                      //         mainImageViewData[currentIndex].posy);
                                                                      //   });
                                                                      // },
                                                                      // onMoveUpdate:
                                                                      //     (details) {
                                                                      //   setState(
                                                                      //       () {
                                                                      //     // isTagSelected = true;
                                                                      //     // calculatePosition();
                                                                      //     // e.h = 100.0.h;
                                                                      //     //e.w = 100.0.w;
                                                                      //     offset = Offset(
                                                                      //         offset.dx + details.delta.dx,
                                                                      //         offset.dy + details.delta.dy);
                                                                      //     mainImageViewData[currentIndex].posy =
                                                                      //         offset.dy;
                                                                      //     mainImageViewData[currentIndex].posx =
                                                                      //         offset.dx;
                                                                      //   });
                                                                      // },
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            Transform(
                                                                          transform: new Matrix4.diagonal3(new v.Vector3(
                                                                              mainImageViewData[currentIndex]!.scale!,
                                                                              mainImageViewData[currentIndex].scale!,
                                                                              mainImageViewData[currentIndex].scale!))
                                                                            ..rotateZ(mainImageViewData[currentIndex].rotation!),
                                                                          alignment:
                                                                              FractionalOffset.center,
                                                                          child:
                                                                              Transform(
                                                                            transform: new Matrix4.diagonal3(new v.Vector3(
                                                                                mainImageViewData[currentIndex].scale!,
                                                                                mainImageViewData[currentIndex].scale!,
                                                                                mainImageViewData[currentIndex].scale!)),
                                                                            alignment:
                                                                                FractionalOffset.center,
                                                                            child:
                                                                                Container(
                                                                              child: Container(
                                                                                height: 90.0.h,
                                                                                width: 100.0.w,
                                                                                alignment: Alignment.center,
                                                                                // color: Colors.black.withOpacity(0.3),
                                                                                child: Image.file(
                                                                                  allFiles[pageIndex],
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 90.0.h,
                                                        width: 100.0.w,
                                                        child: widget.flip!
                                                            ? Transform(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                transform: Matrix4
                                                                    .rotationY(
                                                                        math.pi),
                                                                child:

                                                                    //  musicViewData
                                                                    //             .length >
                                                                    //         0
                                                                    //     ?

                                                                    FittedVideoPlayerStoryMute(
                                                                  video: allFiles[
                                                                      pageIndex],
                                                                  setDuration:
                                                                      (dur) {
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {
                                                                        duration =
                                                                            dur;
                                                                      });
                                                                    }
                                                                    print(
                                                                        duration);
                                                                  },
                                                                )
                                                                // : FittedVideoPlayerStory(
                                                                //     volume:
                                                                //         true,
                                                                //     video: allFiles[
                                                                //         pageIndex],
                                                                //     setDuration:
                                                                //         (dur) {
                                                                //       if (mounted) {
                                                                //         setState(() {
                                                                //           duration = dur;
                                                                //         });
                                                                //       }
                                                                //       print(
                                                                //           duration);
                                                                //     },
                                                                //   ),
                                                                )
                                                            :
                                                            //  musicViewData
                                                            //             .length >
                                                            //         0
                                                            //     ?

                                                            FittedVideoPlayerStoryMute(
                                                                video: allFiles[
                                                                    pageIndex],
                                                                setDuration:
                                                                    (dur) {
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      duration =
                                                                          dur;
                                                                    });
                                                                  }
                                                                  print(
                                                                      duration);
                                                                },
                                                              )
                                                        // : FittedVideoPlayerStory(
                                                        //     volume:
                                                        //         true,
                                                        //     video: allFiles[
                                                        //         pageIndex],
                                                        //     setDuration:
                                                        //         (dur) {
                                                        //       if (mounted) {
                                                        //         setState(
                                                        //             () {
                                                        //           duration =
                                                        //               dur;
                                                        //         });
                                                        //       }
                                                        //       print(
                                                        //           duration);
                                                        //     },
                                                        //   ),
                                                        ),
                                              )
                                            : Container(
                                                child:
                                                    //  true
                                                    widget.type == "image"
                                                        //  widget.assetsList[pageIndex]
                                                        //             .asset.type
                                                        //             .toString() ==
                                                        //         "AssetType.image"
                                                        ? Container(
                                                            child: Image.file(
                                                              allFiles[
                                                                  pageIndex],
                                                              height: 90.0.h,
                                                              width: 100.0.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 90.0.h,
                                                            width: 100.0.w,
                                                            child: widget.flip!
                                                                ? Transform(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    transform: Matrix4
                                                                        .rotationY(
                                                                            math.pi),
                                                                    child:
                                                                        FittedVideoPlayerStory(
                                                                      setDuration:
                                                                          (dur) {
                                                                        if (mounted) {
                                                                          setState(
                                                                              () {
                                                                            duration =
                                                                                dur;
                                                                          });
                                                                        }
                                                                        print(
                                                                            duration);
                                                                      },
                                                                      video: allFiles[
                                                                          pageIndex],
                                                                    ),
                                                                  )
                                                                : FittedVideoPlayerStory(
                                                                    video: allFiles[
                                                                        pageIndex],
                                                                    setDuration:
                                                                        (dur) {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          duration =
                                                                              dur;
                                                                        });
                                                                      }
                                                                      print(
                                                                          duration);
                                                                    },
                                                                  ),
                                                          ),
                                              ),
                                  ),
///////////TOP IS THE VIEW F IMAGE OR VIDEOS

                                  if (!showTextField)
                                    Stack(
                                      children: tagsList[pageIndex]
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
                                                    print(
                                                        "tapped on text edit ${_controller.text}");
                                                    setState(() {
                                                      showColors = false;
                                                      showFonts = true;
                                                      showTextField = true;
                                                      _controller.text =
                                                          e.name!;
                                                      roboto = e.font!;
                                                      selectedColor = e.color!;
                                                      currentEditingTag =
                                                          tagsList[pageIndex]
                                                              .indexOf(e);
                                                      print(
                                                          "error of text=${_controller.text}");
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
                                                      RenderRepaintBoundary? box = e
                                                              .key!.currentContext!
                                                              .findRenderObject()
                                                          as RenderRepaintBoundary;

                                                      // final RenderBox box = e
                                                      //     .key.currentContext
                                                      //     .findRenderObject();
                                                      setState(() {
                                                        e.w = box.size.width;
                                                        e.h = box.size.height;
                                                      });
                                                    });
                                                  },
                                                  onScaleStart: (details) {
                                                    setState(() {
                                                      _baseScaleFactor =
                                                          e.scale!;
                                                      e.h = 100.0.h;
                                                      e.w = 100.0.w;
                                                    });
                                                  },
                                                  onScaleUpdate: (details) {
                                                    setState(() {
                                                      e.scale =
                                                          _baseScaleFactor *
                                                              details.scale;
                                                    });
                                                  },
                                                  onMoveStart: (details) {
                                                    setState(() {
                                                      offset = Offset(
                                                          e.posx!, e.posy!);
                                                    });
                                                  },
                                                  onMoveUpdate: (details) {
                                                    double xdiff = 0;
                                                    double ydiff = 0;
                                                    offset = Offset(
                                                        offset.dx +
                                                            details.delta.dx,
                                                        offset.dy +
                                                            details.delta.dy);
                                                    // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                    xdiff = (offset.dx) < 0
                                                        ? (-offset.dx)
                                                        : (offset.dx);
                                                    ydiff = deletePosition.dy -
                                                        (offset.dy + 5.0.h);
                                                    print(ydiff);

                                                    print(deletePosition.dy
                                                            .toString() +
                                                        " delete pos");
                                                    if (((xdiff > 0 &&
                                                                xdiff < 60) ||
                                                            (xdiff < 0 &&
                                                                xdiff >= -1)) &&
                                                        ((ydiff > 0 &&
                                                                ydiff < 100) ||
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
                                                        offset.dx +
                                                            details.delta.dx,
                                                        offset.dy +
                                                            details.delta.dy);
                                                    // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                    xdiff = (offset.dx) < 0
                                                        ? (-offset.dx)
                                                        : (offset.dx);
                                                    ydiff = deletePosition.dy -
                                                        (offset.dy + 5.0.h);
                                                    print(ydiff);
                                                    if (((xdiff > 0 &&
                                                                xdiff < 60) ||
                                                            (xdiff < 0 &&
                                                                xdiff >= -1)) &&
                                                        ((ydiff > 0 &&
                                                                ydiff < 100) ||
                                                            (ydiff < 0 &&
                                                                ydiff >= -1))) {
                                                      int i =
                                                          tagsList[pageIndex]
                                                              .indexOf(e);
                                                      setState(() {
                                                        tagsList[pageIndex]
                                                            .removeAt(i);
                                                        _controller.clear();
                                                        deleteIconColor = false;
                                                        isTagSelected = false;
                                                      });
                                                      bool? hasVibration =
                                                          await Vibration
                                                              .hasVibrator();
                                                      if (hasVibration!) {
                                                        Vibration.vibrate();
                                                      }
                                                    } else {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (timeStamp) {
                                                        RenderRepaintBoundary? box = e
                                                                .key!
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderRepaintBoundary;
                                                        // final RenderBox box = e
                                                        //     .key.currentContext
                                                        //     .findRenderObject();
                                                        setState(() {
                                                          isTagSelected = false;
                                                          e.w = box.size.width;
                                                          e.h = box.size.height;
                                                        });
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 6.0.w,
                                                              vertical: 5.0.h),
                                                      child: Container(
                                                        height: e.h,
                                                        width: e.w,
                                                        color:
                                                            Colors.transparent,
                                                        child: Center(
                                                          child: Text(
                                                            e.name!,
                                                            style: e.font!.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: e.color,
                                                                fontSize: 25),
                                                            textAlign: TextAlign
                                                                .center,
                                                            textScaleFactor:
                                                                e.scale,
                                                            key: e.key,
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

                                  //-------------------------------------------------------------
                                  Stack(
                                    children: stickerList[pageIndex]
                                        .map(
                                          (e) => Positioned.fill(
                                            left: e.posx! - 125,
                                            top: e.posy! - 125,
                                            right: -125,
                                            bottom: -125,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: XGestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onLongPress: (val) {
                                                  print("gesture stickerss");
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
                                                    print(
                                                        "baseScale=${_baseScaleFactor}");
                                                    /*e.h = 100.0.h;
                                                          e.w = 100.0.w;*/
                                                  });
                                                },
                                                onScaleUpdate: (details) {
                                                  print(
                                                      "gesture sticker scale ${_baseScaleFactor} * ${details.scale}=${_baseScaleFactor * details.scale}");
                                                  setState(() {
                                                    if (_baseScaleFactor *
                                                            details.scale >
                                                        2.0)
                                                      e.scale = 2.0;
                                                    else
                                                      e.scale =
                                                          _baseScaleFactor *
                                                              details.scale;
                                                  });
                                                },
                                                onMoveStart: (details) {
                                                  print("gesture sticker move");
                                                  setState(() {
                                                    offset = Offset(
                                                        e.posx!, e.posy!);
                                                  });
                                                },
                                                onMoveUpdate: (details) {
                                                  double xdiff = 0;
                                                  double ydiff = 0;
                                                  offset = Offset(
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                  /*ydiff = deletePosition.dy - offset.dy < 0
                                                            ? offset.dy - deletePosition.dy
                                                            : deletePosition.dy - offset.dy;
*/
                                                  xdiff = (offset.dx) < 0
                                                      ? (-offset.dx)
                                                      : (offset.dx);
                                                  ydiff = deletePosition.dy -
                                                      (offset.dy + 6.0.h);
                                                  // print(e.posy.toInt().toString() + " dy,  " + deletePosition.dy.toInt().toString() + "~~" + (e.posy.toInt() + 200).toString());
                                                  if (((xdiff > 0 &&
                                                              xdiff < 60) ||
                                                          (xdiff < 0 &&
                                                              xdiff >= -1)) &&
                                                      ((ydiff > 0 &&
                                                              ydiff < 100) ||
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
                                                    // e.h = 100.0.h;
                                                    //e.w = 100.0.w;
                                                    offset = Offset(
                                                        offset.dx +
                                                            details.delta.dx,
                                                        offset.dy +
                                                            details.delta.dy);
                                                    e.posy = offset.dy;
                                                    e.posx = offset.dx;
                                                  });
                                                },
                                                onMoveEnd: (details) async {
                                                  double xdiff = 0;
                                                  double ydiff = 0;
                                                  offset = Offset(
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                  /*ydiff = deletePosition.dy - offset.dy < 0
                                                            ? offset.dy - deletePosition.dy
                                                            : deletePosition.dy - offset.dy;*/
                                                  xdiff = (offset.dx) < 0
                                                      ? (-offset.dx)
                                                      : (offset.dx);
                                                  ydiff = deletePosition.dy -
                                                      (offset.dy + 4.0.h);
                                                  // print(ydiff);

                                                  if (((xdiff > 0 &&
                                                              xdiff < 60) ||
                                                          (xdiff < 0 &&
                                                              xdiff >= -1)) &&
                                                      ((ydiff > 0 &&
                                                              ydiff < 100) ||
                                                          (ydiff < 0 &&
                                                              ydiff >= -1))) {
                                                    int i =
                                                        stickerList[pageIndex]
                                                            .indexOf(e);
                                                    setState(() {
                                                      stickerList[pageIndex]
                                                          .removeAt(i);
                                                      _controller.clear();
                                                      deleteIconColor = false;
                                                      isTagSelected = false;
                                                    });
                                                    bool? hasVibration =
                                                        await Vibration
                                                            .hasVibrator();
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
                                                    transform:
                                                        new Matrix4.diagonal3(
                                                            new v.Vector3(
                                                                e.scale!,
                                                                e.scale!,
                                                                e.scale!)),
                                                    alignment:
                                                        FractionalOffset.center,
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0.w,
                                                                vertical:
                                                                    4.0.h),
                                                        child: Transform(
                                                          transform: new Matrix4
                                                                  .diagonal3(
                                                              new v.Vector3(
                                                                  e.scale!,
                                                                  e.scale!,
                                                                  e.scale!)),
                                                          alignment:
                                                              FractionalOffset
                                                                  .center,
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

//------------------------------------------------------------

                                  Stack(
                                    children: [
                                      if (timeViewData[currentIndex]?.name !=
                                              "" &&
                                          isTimeViewAdd &&
                                          timeViewData[currentIndex]?.posx !=
                                              null)
                                        Positioned.fill(
                                          left: timeViewData[currentIndex].posx,
                                          top:
                                              timeViewData[currentIndex].posy! -
                                                  0,
                                          right: 0,
                                          bottom: 0,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: XGestureDetector(
                                              onTap: (_) {
                                                print("clicked on time event");
                                                print("clicked on story data");
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              onLongPress: (val) {
                                                setState(() {
                                                  timeViewData[currentIndex].h =
                                                      100.0.h;
                                                  timeViewData[currentIndex].w =
                                                      100.0.w;
                                                });
                                              },
                                              onScaleStart: (details) {
                                                setState(() {
                                                  _baseScaleFactor =
                                                      timeViewData[
                                                              currentIndex]!
                                                          .scale!;
                                                  // timeViewData[currentIndex].h =
                                                  //     100.0.h;
                                                  // timeViewData[currentIndex].w =
                                                  //     100.0.w;
                                                });
                                              },
                                              onScaleEnd: () {
                                                setState(() {
                                                  timeViewData[currentIndex]
                                                          .lastRotation =
                                                      timeViewData[currentIndex]
                                                          .rotation;
                                                });
                                              },
                                              onScaleUpdate: (details) {
                                                print("scaling time here");
                                                setState(() {
                                                  timeViewData[currentIndex]
                                                          .rotation =
                                                      timeViewData[currentIndex]
                                                              .lastRotation! -
                                                          details.rotationAngle;
                                                  if (_baseScaleFactor *
                                                          details.scale >
                                                      2.0)
                                                    timeViewData[currentIndex]
                                                        .scale = 2.0;
                                                  else
                                                    timeViewData[currentIndex]
                                                            .scale =
                                                        _baseScaleFactor *
                                                            details.scale;
                                                });
                                              },
                                              onMoveStart: (details) {
                                                print("scaling moving");
                                                setState(() {
                                                  offset = Offset(
                                                      timeViewData[currentIndex]
                                                          .posx!,
                                                      timeViewData[currentIndex]
                                                          .posy!);
                                                });
                                              },
                                              onMoveUpdate: (details) {
                                                ///////////////
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);

                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                /*ydiff = deletePosition.dy - offset.dy < 0
                                                            ? offset.dy - deletePosition.dy
                                                            : deletePosition.dy - offset.dy;
*/
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);
                                                print(
                                                    "delete pos reach =${xdiff},${ydiff}");
                                                // print(e.posy.toInt().toString() + " dy,  " + deletePosition.dy.toInt().toString() + "~~" + (e.posy.toInt() + 200).toString());
                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  setState(() {
                                                    deleteIconColor = true;
                                                    print(
                                                        "delete icon color=${deleteIconColor}");
                                                    // timeViewData[currentIndex]
                                                    //     .name = '';
                                                    // offset = Offset.zero;
                                                  });

                                                  // Future.delayed(
                                                  //     Duration(
                                                  //         milliseconds: 100),
                                                  //     () {
                                                  //   setState(() {
                                                  //     deleteIconColor = false;
                                                  //   });
                                                  // });
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
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  timeViewData[currentIndex]
                                                      .posy = offset.dy;
                                                  timeViewData[currentIndex]
                                                      .posx = offset.dx;
                                                });
                                              },
                                              onMoveEnd: (details) async {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                /*ydiff = deletePosition.dy - offset.dy < 0
                                                            ? offset.dy - deletePosition.dy
                                                            : deletePosition.dy - offset.dy;*/
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 4.0.h);
                                                // print(ydiff);

                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  int i = timeViewData.indexOf(
                                                      timeViewData[
                                                          currentIndex]);
                                                  setState(() {
                                                    // timeViewData.removeAt(i);
                                                    // _controller.clear();
                                                    // timeViewData[currentIndex] =
                                                    //     null;
                                                    timeViewData[currentIndex]
                                                        .name = "";
                                                    isTimeViewAdd = false;
                                                    deleteIconColor = false;
                                                    isTagSelected = false;
                                                  });
                                                  bool? hasVibration =
                                                      await Vibration
                                                          .hasVibrator();
                                                  if (hasVibration!) {
                                                    Vibration.vibrate();
                                                  }
                                                } else {
                                                  setState(() {
                                                    isTagSelected = false;
                                                  });
                                                }
                                              },
                                              child: Transform(
                                                  transform: new Matrix4
                                                      .diagonal3(new v
                                                          .Vector3(
                                                      timeViewData[currentIndex]
                                                          .scale!,
                                                      timeViewData[currentIndex]
                                                          .scale!,
                                                      timeViewData[currentIndex]
                                                          .scale!))
                                                    ..rotateZ(timeViewData[
                                                            currentIndex]
                                                        .rotation!),
                                                  alignment:
                                                      FractionalOffset.center,
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    // height: timeViewData[
                                                    //         currentIndex]
                                                    //     .h,
                                                    // width: timeViewData[
                                                    //         currentIndex]
                                                    //     .w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6.0.w,
                                                            vertical: 5.0.h),
                                                    child: Transform(
                                                      transform: new Matrix4
                                                          .diagonal3(new v
                                                              .Vector3(
                                                          timeViewData[
                                                                  currentIndex]
                                                              .scale!,
                                                          timeViewData[
                                                                  currentIndex]
                                                              .scale!,
                                                          timeViewData[
                                                                  currentIndex]
                                                              .scale!))
                                                        ..rotateZ(timeViewData[
                                                                currentIndex]
                                                            .rotation!),
                                                      alignment:
                                                          FractionalOffset
                                                              .center,
                                                      child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    6.0.w,
                                                                vertical:
                                                                    5.0.h),
                                                        child: StoryTimeWidget(
                                                          dateData: DateTime
                                                              .parse(timeViewData[
                                                                      currentIndex]
                                                                  .name!),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      if (hashtagViewData.length != 0 &&
                                          hashtagViewData[currentIndex]?.name !=
                                              "" &&
                                          ishastagViewAdd)
                                        Positioned.fill(
                                          left: hashtagViewData[currentIndex]!
                                                  .posx! -
                                              0,
                                          top: hashtagViewData[currentIndex]!
                                                  .posy! -
                                              125,
                                          right: -125,
                                          bottom: -125,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: XGestureDetector(
                                              onLongPress: (val) {
                                                setState(() {
                                                  // showTextField = !showTextField;
                                                  hashtagViewData[currentIndex]!
                                                      .h = 100.0.h;
                                                  hashtagViewData[currentIndex]!
                                                      .w = 100.0.w;
                                                });
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              onTap: (val) {
                                                print("tapped on hashtag");
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
                                                  RenderRepaintBoundary? box =
                                                      hashtagViewData[
                                                                  currentIndex]!
                                                              .stickerKey!
                                                              .currentContext!
                                                              .findRenderObject()
                                                          as RenderRepaintBoundary;

                                                  // final RenderBox box =
                                                  //     hashtagViewData[
                                                  //             currentIndex]
                                                  //         .stickerKey
                                                  //         .currentContext
                                                  //         .findRenderObject();
                                                  setState(() {
                                                    hashtagViewData[
                                                                currentIndex]!
                                                            .lastRotation =
                                                        hashtagViewData[
                                                                currentIndex]!
                                                            .rotation;
                                                    hashtagViewData[
                                                            currentIndex]!
                                                        .w = box.size.width;
                                                    hashtagViewData[
                                                            currentIndex]!
                                                        .h = box.size.height;
                                                  });
                                                });
                                              },
                                              onScaleStart: (details) {
                                                setState(() {
                                                  _baseScaleFactor =
                                                      hashtagViewData[
                                                              currentIndex]!
                                                          .scale!;
                                                  hashtagViewData[currentIndex]!
                                                      .h = 100.0.h;
                                                  hashtagViewData[currentIndex]!
                                                      .w = 100.0.w;
                                                });
                                              },
                                              onScaleUpdate: (details) {
                                                setState(() {
                                                  hashtagViewData[currentIndex]!
                                                          .rotation =
                                                      hashtagViewData[
                                                                  currentIndex]!
                                                              .lastRotation! -
                                                          details.rotationAngle;
                                                  hashtagViewData[currentIndex]!
                                                          .scale =
                                                      _baseScaleFactor *
                                                          details.scale;
                                                });
                                              },
                                              onMoveStart: (details) {
                                                setState(() {
                                                  offset = Offset(
                                                      hashtagViewData[
                                                              currentIndex]!
                                                          .posx!,
                                                      hashtagViewData[
                                                              currentIndex]!
                                                          .posy!);
                                                });
                                              },
                                              onMoveUpdate: (details) {
                                                print(
                                                    "move update ${offset.dy + details.delta.dy} delpos=${deletePosition.dy}");
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                xdiff = deletePosition.dx -
                                                            offset.dx <
                                                        0
                                                    ? offset.dx -
                                                        deletePosition.dx
                                                    : deletePosition.dx -
                                                        offset.dx;
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);
                                                print(ydiff);

                                                print(deletePosition.dy
                                                        .toString() +
                                                    " delete pos");
                                                if ((ydiff > 0 &&
                                                        ydiff < 100) ||
                                                    (ydiff < 0 &&
                                                        ydiff >= -1)) {
                                                  print(
                                                      "hash color change true aa");
                                                  setState(() {
                                                    deleteIconColor = true;
                                                    // hashtagViewData.clear();
                                                    print(
                                                        "here hash ${hashtagViewData[currentIndex]!.name}");
                                                    hashtagViewData[
                                                            currentIndex]!
                                                        .name = '';
                                                    offset = Offset.zero;
                                                    // offset.dy = 0.0;

                                                    ishastagViewAdd = false;

                                                    Future.delayed(
                                                      Duration(
                                                          milliseconds: 100),
                                                      () {
                                                        deleteIconColor = false;
                                                      },
                                                    );
                                                  });
                                                } else {
                                                  print(
                                                      "hash color change false");
                                                  setState(() {
                                                    deleteIconColor = false;
                                                  });
                                                }
                                                // double xdiff = 0;
                                                // double ydiff = 0;
                                                // offset = Offset(
                                                //     offset.dx +
                                                //         details.delta.dx,
                                                //     offset.dy +
                                                //         details.delta.dy);
                                                // // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                // xdiff = (offset.dx) < 0
                                                //     ? (-offset.dx)
                                                //     : (offset.dx);
                                                // ydiff = deletePosition.dy -
                                                //     (offset.dy + 5.0.h);
                                                // print(ydiff);

                                                // print(deletePosition.dy
                                                //         .toString() +
                                                //     " delete pos" +
                                                //     "${ydiff} hashtag pos");
                                                // if (((xdiff > 0 &&
                                                //             xdiff < 60) ||
                                                //         (xdiff < 0 &&
                                                //             xdiff >= -1)) &&
                                                //     ((ydiff > 0 &&
                                                //             ydiff < 100) ||
                                                //         (ydiff < 0 &&
                                                //             ydiff >= -1))) {
                                                //   setState(() {
                                                //     deleteIconColor = true;
                                                //   });
                                                // } else {
                                                //   setState(() {
                                                //     deleteIconColor = false;
                                                //   });
                                                // }
                                                setState(() {
                                                  isTagSelected = true;
                                                  calculatePosition();
                                                  hashtagViewData[currentIndex]!
                                                      .h = 100.0.h;
                                                  hashtagViewData[currentIndex]!
                                                      .w = 100.0.w;
                                                  offset = Offset(
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  hashtagViewData[currentIndex]!
                                                      .posy = offset.dy;
                                                  hashtagViewData[currentIndex]!
                                                      .posx = offset.dx;
                                                });
                                                // print(details.position.toString());
                                                // print(100.0.h);
                                                // print(deletePosition.toString());
                                              },
                                              onMoveEnd: (details) async {
                                                print("hash move end");
                                                // double xdiff = 0;
                                                // double ydiff = 0;
                                                // offset = Offset(
                                                //     offset.dx +
                                                //         details.delta.dx,
                                                //     offset.dy +
                                                //         details.delta.dy);
                                                // // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                // xdiff = (offset.dx) < 0
                                                //     ? (-offset.dx)
                                                //     : (offset.dx);
                                                // ydiff = deletePosition.dy -
                                                //     (offset.dy + 5.0.h);
                                                // print(ydiff);
                                                // if (((xdiff > 0 &&
                                                //             xdiff < 60) ||
                                                //         (xdiff < 0 &&
                                                //             xdiff >= -1)) &&
                                                //     ((ydiff > 0 &&
                                                //             ydiff < 100) ||
                                                //         (ydiff < 0 &&
                                                //             ydiff >= -1))) {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                xdiff = deletePosition.dx -
                                                            offset.dx <
                                                        0
                                                    ? offset.dx -
                                                        deletePosition.dx
                                                    : deletePosition.dx -
                                                        offset.dx;
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);
                                                print(ydiff);
                                                if ((ydiff > 0 &&
                                                        ydiff < 100) ||
                                                    (ydiff < 0 &&
                                                        ydiff >= -1)) {
                                                  setState(() {
                                                    //  tagsList[pageIndex].removeAt(i);
                                                    //  _controller.clear();
                                                    ishastagViewAdd = false;
                                                    hashtagViewData[
                                                                currentIndex]!
                                                            .name ==
                                                        "";
                                                    hashtagViewData[
                                                        currentIndex] = null;
                                                    deleteIconColor = false;
                                                    isTagSelected = false;
                                                  });

                                                  bool? hasVibration =
                                                      await Vibration
                                                          .hasVibrator();
                                                  if (hasVibration!) {
                                                    Vibration.vibrate();
                                                  }
                                                } else {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    RenderRepaintBoundary? box =
                                                        hashtagViewData[
                                                                    currentIndex]!
                                                                .stickerKey!
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderRepaintBoundary;

                                                    // final RenderBox box =
                                                    //     hashtagViewData[
                                                    //             currentIndex]
                                                    //         .stickerKey
                                                    //         .currentContext
                                                    //         .findRenderObject();
                                                    setState(() {
                                                      isTagSelected = false;
                                                      hashtagViewData[
                                                              currentIndex]!
                                                          .w = box.size.width;
                                                      hashtagViewData[
                                                              currentIndex]!
                                                          .h = box.size.height;
                                                    });
                                                  });
                                                }
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData[currentIndex].rotation),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0.w,
                                                      vertical: 5.0.h),
                                                  child: Container(
                                                    height: hashtagViewData[
                                                            currentIndex]!
                                                        .h,
                                                    width: hashtagViewData[
                                                            currentIndex]!
                                                        .w,
                                                    color: Colors.transparent,
                                                    child: Center(
                                                      child: Container(
                                                        key: hashtagViewData[
                                                                currentIndex]!
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
                                                        child: Text(
                                                          hashtagViewData[
                                                                  currentIndex]!
                                                              .name!
                                                              .toUpperCase(),
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
                                                                  Colors.pink
                                                                ],
                                                                begin: Alignment
                                                                    .bottomLeft,
                                                                end: Alignment
                                                                    .topRight,
                                                              ).createShader(Rect
                                                                      .largest),
                                                          ),
                                                          textScaleFactor:
                                                              hashtagViewData[
                                                                      currentIndex]!
                                                                  .scale,
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
                                      if (islocationViewAdd &&
                                          locationViewData[currentIndex].name !=
                                              '')
                                        Positioned.fill(
                                          left: locationViewData[currentIndex]!
                                                  .posx! -
                                              125,
                                          top: locationViewData[currentIndex]
                                                  .posy! -
                                              125,
                                          right: -125,
                                          bottom: -125,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: XGestureDetector(
                                              onLongPress: (val) {
                                                setState(() {
                                                  // showTextField = !showTextField;
                                                  locationViewData[currentIndex]
                                                      .h = 100.0.h;
                                                  locationViewData[currentIndex]
                                                      .w = 100.0.w;
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
                                                  RenderRepaintBoundary? box =
                                                      locationViewData[
                                                                  currentIndex]
                                                              .stickerKey!
                                                              .currentContext!
                                                              .findRenderObject()
                                                          as RenderRepaintBoundary;
                                                  // final RenderBox box =
                                                  //     locationViewData[
                                                  //             currentIndex]
                                                  //         .stickerKey
                                                  //         .currentContext
                                                  //         .findRenderObject();
                                                  setState(() {
                                                    locationViewData[
                                                                currentIndex]
                                                            .lastRotation =
                                                        locationViewData[
                                                                currentIndex]
                                                            .rotation;
                                                    locationViewData[
                                                            currentIndex]
                                                        .w = box.size.width;
                                                    locationViewData[
                                                            currentIndex]
                                                        .h = box.size.height;
                                                  });
                                                });
                                              },
                                              onScaleStart: (details) {
                                                setState(() {
                                                  _baseScaleFactor =
                                                      locationViewData[
                                                              currentIndex]!
                                                          .scale!;
                                                  locationViewData[currentIndex]
                                                      .h = 100.0.h;
                                                  locationViewData[currentIndex]
                                                      .w = 100.0.w;
                                                });
                                              },
                                              onScaleUpdate: (details) {
                                                setState(() {
                                                  locationViewData[currentIndex]
                                                          .rotation =
                                                      locationViewData[
                                                                  currentIndex]
                                                              .lastRotation! -
                                                          details.rotationAngle;
                                                  locationViewData[currentIndex]
                                                          .scale =
                                                      _baseScaleFactor *
                                                          details.scale;
                                                });
                                              },
                                              onMoveStart: (details) {
                                                setState(() {
                                                  offset = Offset(
                                                      locationViewData[
                                                              currentIndex]!
                                                          .posx!,
                                                      locationViewData[
                                                              currentIndex]!
                                                          .posy!);
                                                });
                                              },
                                              onMoveUpdate: (details) {
                                                double xdiff = 0;
                                                double ydiff = 0;

                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);
                                                print(ydiff);

                                                print(deletePosition.dy
                                                        .toString() +
                                                    " delete pos");
                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  print(
                                                      "hash color change true");
                                                  setState(() {
                                                    deleteIconColor = true;
                                                  });
                                                } else {
                                                  print(
                                                      "hash color change false");
                                                  setState(() {
                                                    deleteIconColor = false;
                                                  });
                                                }
                                                setState(() {
                                                  isTagSelected = true;
                                                  calculatePosition();
                                                  locationViewData[currentIndex]
                                                      .h = 100.0.h;
                                                  locationViewData[currentIndex]
                                                      .w = 100.0.w;
                                                  offset = Offset(
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  locationViewData[currentIndex]
                                                      .posy = offset.dy;
                                                  locationViewData[currentIndex]
                                                      .posx = offset.dx;
                                                });
                                                // print(details.position.toString());
                                                // print(100.0.h);
                                                // print(deletePosition.toString());
                                              },
                                              onMoveEnd: (details) async {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);
                                                print(ydiff);
                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  // int i = tagsList[pageIndex].indexOf(locationViewData[currentIndex]);
                                                  setState(() {
                                                    // tagsList[pageIndex].removeAt(i);
                                                    // _controller.clear();
                                                    deleteIconColor = false;
                                                    isTagSelected = false;
                                                  });
                                                  bool? hasVibration =
                                                      await Vibration
                                                          .hasVibrator();
                                                  if (hasVibration!) {
                                                    Vibration.vibrate();
                                                  }
                                                } else {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    RenderRepaintBoundary? box =
                                                        locationViewData[
                                                                    currentIndex]
                                                                .stickerKey!
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderRepaintBoundary;
                                                    // final RenderBox box =
                                                    //     locationViewData[
                                                    //             currentIndex]
                                                    //         .stickerKey
                                                    //         .currentContext
                                                    //         .findRenderObject();
                                                    setState(() {
                                                      isTagSelected = false;
                                                      locationViewData[
                                                              currentIndex]
                                                          .w = box.size.width;
                                                      locationViewData[
                                                              currentIndex]
                                                          .h = box.size.height;
                                                    });
                                                  });
                                                }
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(locationViewData[currentIndex].rotation),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0.w,
                                                      vertical: 5.0.h),
                                                  child: Container(
                                                    height: locationViewData[
                                                            currentIndex]
                                                        .h,
                                                    width: locationViewData[
                                                            currentIndex]
                                                        .w,
                                                    color: Colors.transparent,
                                                    child: Center(
                                                      child: Container(
                                                        key: locationViewData[
                                                                currentIndex]
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
                                                        child: ShaderMask(
                                                          shaderCallback:
                                                              (Rect bounds) {
                                                            return LinearGradient(
                                                              colors: <Color>[
                                                                Colors.purple,
                                                                Colors
                                                                    .pinkAccent
                                                              ],
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                            ).createShader(
                                                                Rect.fromLTWH(
                                                                    0.0,
                                                                    0.0,
                                                                    120.0,
                                                                    40.0));
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                              Text(
                                                                locationViewData[
                                                                        currentIndex]
                                                                    .name!
                                                                    .toUpperCase(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                        .rajdhani()
                                                                    .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                textScaleFactor:
                                                                    locationViewData[
                                                                            currentIndex]
                                                                        .scale,
                                                              ),
                                                            ],
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
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
                                      if (musicViewData.length != 0 &&
                                          musicViewData.length !=
                                              currentIndex &&
                                          musicViewData[currentIndex]?.name !=
                                              "" &&
                                          ismusicViewAdd)
                                        Positioned.fill(
                                          left: musicViewData[currentIndex]
                                                  .posx! -
                                              125,
                                          top: musicViewData[currentIndex]
                                                  .posy! -
                                              125,
                                          right: -125,
                                          bottom: -125,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: XGestureDetector(
                                              onLongPress: (val) {
                                                setState(() {
                                                  // showTextField = !showTextField;
                                                  musicViewData[currentIndex]
                                                      .h = 100.0.h;
                                                  musicViewData[currentIndex]
                                                      .w = 100.0.w;
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
                                                  musicViewData[currentIndex]
                                                          .lastRotation =
                                                      musicViewData[
                                                              currentIndex]
                                                          .rotation;
                                                });
                                              },
                                              onScaleStart: (details) {
                                                setState(() {
                                                  _baseScaleFactor =
                                                      musicViewData[
                                                              currentIndex]!
                                                          .scale!;
                                                  print(
                                                      "-------------___$_baseScaleFactor------------------------------------------------------------------------");
                                                });
                                              },
                                              onScaleUpdate: (details) {
                                                setState(() {
                                                  musicViewData[currentIndex]
                                                      .rotation = musicViewData[
                                                              currentIndex]
                                                          .lastRotation! -
                                                      details.rotationAngle;
                                                  musicViewData[currentIndex]
                                                          .scale =
                                                      _baseScaleFactor *
                                                          details.scale;
                                                });
                                              },
                                              onMoveStart: (details) {
                                                setState(() {
                                                  offset = Offset(
                                                      musicViewData[
                                                              currentIndex]
                                                          .posx!,
                                                      musicViewData[
                                                              currentIndex]!
                                                          .posy!);
                                                });
                                              },
                                              onMoveUpdate: (details) {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                                                // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
                                                print(ydiff);

                                                print(deletePosition.dy
                                                        .toString() +
                                                    " delete pos");
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);

                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
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
                                                  musicViewData[currentIndex]
                                                      .h = 100.0.h;
                                                  musicViewData[currentIndex]
                                                      .w = 100.0.w;
                                                  offset = Offset(
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  musicViewData[currentIndex]
                                                      .posy = offset.dy;
                                                  musicViewData[currentIndex]
                                                      .posx = offset.dx;
                                                });
                                                // print(details.position.toString());
                                                // print(100.0.h);
                                                // print(deletePosition.toString());
                                              },
                                              onMoveEnd: (details) async {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);
                                                print(ydiff);
                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  // int i = tagsList[pageIndex].indexOf(musicViewData[currentIndex]);
                                                  setState(() {
                                                    isquestionsViewAdd = false;

                                                    // tagsList[pageIndex].removeAt(i);
                                                    // _controller.clear();
                                                    musicViewData[currentIndex]
                                                        ?.name = "";

                                                    thisplayer.stop();
                                                    // musicViewData[
                                                    //     currentIndex] = null;
                                                    deleteIconColor = false;
                                                    isTagSelected = false;
                                                  });
                                                  bool? hasVibration =
                                                      await Vibration
                                                          .hasVibrator();
                                                  if (hasVibration!) {
                                                    Vibration.vibrate();
                                                  }
                                                } else {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    RenderRepaintBoundary? box =
                                                        musicViewData[
                                                                    currentIndex]
                                                                .stickerKey!
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderRepaintBoundary;

                                                    // final RenderBox box =
                                                    //     musicViewData[
                                                    //             currentIndex]
                                                    //         .stickerKey
                                                    //         .currentContext
                                                    //         .findRenderObject();
                                                    setState(() {
                                                      isTagSelected = false;
                                                      musicViewData[
                                                              currentIndex]
                                                          .w = box.size.width;
                                                      musicViewData[
                                                              currentIndex]
                                                          .h = box.size.height;
                                                    });
                                                  });
                                                }
                                                setState(() {
                                                  offset = Offset.zero;
                                                });
                                              },
                                              child: Transform.scale(
                                                scale:
                                                    musicViewData[currentIndex]
                                                        .scale,
                                                child: Container(
                                                  color: Colors.transparent,
                                                  // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(musicViewData[currentIndex].rotation),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6.0.w,
                                                            vertical: 5.0.h),
                                                    child: Container(
                                                      height: musicViewData[
                                                              currentIndex]
                                                          .h,
                                                      width: musicViewData[
                                                              currentIndex]
                                                          .w,
                                                      color: Colors.transparent,
                                                      child: Center(
                                                        child: musicViewData[
                                                                            currentIndex]
                                                                        .musicdata!
                                                                        .style !=
                                                                    null &&
                                                                musicViewData[
                                                                            currentIndex]
                                                                        .musicdata!
                                                                        .style !=
                                                                    "liststyle"
                                                            ? Container(
                                                                // height: 20.0.h,
                                                                // width: 40.0.w,

                                                                key: musicViewData[
                                                                        currentIndex]
                                                                    .stickerKey,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            4.0
                                                                                .h,
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
                                                                          .circular(
                                                                              8),
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
                                                                    squaremusicCoverTest(musicViewData[
                                                                            currentIndex]
                                                                        .musicdata!
                                                                        .songImageUrl!)
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
                                                                key: musicViewData[
                                                                        currentIndex]
                                                                    .stickerKey,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(7),

                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .2),
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                      blurRadius:
                                                                          3,
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
                                                                              BorderRadius.circular(20)),
                                                                      // contentPadding:
                                                                      //     EdgeInsets
                                                                      //         .all(
                                                                      //             18.0),
                                                                      tileColor:
                                                                          Colors
                                                                              .white,
                                                                      trailing:
                                                                          FittedBox(
                                                                        child: SpinKitPianoWave(
                                                                            color:
                                                                                Colors.deepPurple,
                                                                            size: 3.0.h),
                                                                      ),
                                                                      leading: musicCover(musicViewData[
                                                                              currentIndex]
                                                                          .musicdata!
                                                                          .songImageUrl!),
                                                                      title: Text(
                                                                          '${musicViewData[currentIndex].musicdata!.songTitle!}',
                                                                          style:
                                                                              TextStyle(fontSize: 20)),
                                                                      subtitle:
                                                                          Text(
                                                                              '${musicViewData[currentIndex].musicdata!.songArtist!}'),
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
                                      if (questionsViewData[currentIndex]
                                                  ?.name !=
                                              "" &&
                                          isquestionsViewAdd)
                                        Positioned.fill(
                                          left: questionsViewData[currentIndex]!
                                                  .posx! -
                                              125,
                                          top: questionsViewData[currentIndex]!
                                                  .posy! -
                                              125,
                                          right: -125,
                                          bottom: -125,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: XGestureDetector(
                                              onLongPress: (val) {
                                                setState(() {
                                                  // showTextField = !showTextField;
                                                  questionsViewData[
                                                          currentIndex]!
                                                      .h = 100.0.h;
                                                  questionsViewData[
                                                          currentIndex]!
                                                      .w = 100.0.w;
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
                                                  questionsViewData[
                                                              currentIndex]!
                                                          .lastRotation =
                                                      questionsViewData[
                                                              currentIndex]!
                                                          .rotation;
                                                });
                                              },
                                              onScaleStart: (details) {
                                                setState(() {
                                                  _baseScaleFactor =
                                                      questionsViewData[
                                                              currentIndex]!
                                                          .scale!;
                                                  print(
                                                      "-------------___$_baseScaleFactor------------------------------------------------------------------------");
                                                });
                                              },
                                              onScaleUpdate: (details) {
                                                setState(() {
                                                  questionsViewData[
                                                              currentIndex]!
                                                          .rotation =
                                                      questionsViewData[
                                                                  currentIndex]!
                                                              .lastRotation! -
                                                          details.rotationAngle;
                                                  questionsViewData[
                                                              currentIndex]!
                                                          .scale =
                                                      _baseScaleFactor *
                                                          details.scale;
                                                });
                                              },
                                              onMoveStart: (details) {
                                                setState(() {
                                                  offset = Offset(
                                                      questionsViewData[
                                                              currentIndex]!
                                                          .posx!,
                                                      questionsViewData[
                                                              currentIndex]!
                                                          .posy!);
                                                });
                                              },
                                              onMoveUpdate: (details) {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                                                // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
                                                print(ydiff);

                                                print(deletePosition.dy
                                                        .toString() +
                                                    " delete pos");
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);

                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  setState(() {
                                                    deleteIconColor = true;
                                                    questionsViewData[
                                                            currentIndex]
                                                        ?.name = "";
                                                    offset = Offset.zero;
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 1000),
                                                        () {
                                                      deleteIconColor = false;
                                                    });
                                                  });
                                                } else {
                                                  setState(() {
                                                    deleteIconColor = false;
                                                  });
                                                }
                                                setState(() {
                                                  isTagSelected = true;
                                                  calculatePosition();
                                                  questionsViewData[
                                                          currentIndex]!
                                                      .h = 100.0.h;
                                                  questionsViewData[
                                                          currentIndex]!
                                                      .w = 100.0.w;
                                                  offset = Offset(
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  questionsViewData[
                                                          currentIndex]!
                                                      .posy = offset.dy;
                                                  questionsViewData[
                                                          currentIndex]!
                                                      .posx = offset.dx;
                                                });
                                                // print(details.position.toString());
                                                // print(100.0.h);
                                                // print(deletePosition.toString());
                                              },
                                              onMoveEnd: (details) async {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 5.0.h);
                                                print(ydiff);
                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  // int i = tagsList[pageIndex].indexOf(questionsViewData[currentIndex]);
                                                  setState(() {
                                                    isquestionsViewAdd = false;
                                                    // tagsList[pageIndex].removeAt(i);
                                                    // _controller.clear();
                                                    questionsViewData[
                                                        currentIndex] = null;
                                                    deleteIconColor = false;
                                                    isTagSelected = false;
                                                  });
                                                  bool? hasVibration =
                                                      await Vibration
                                                          .hasVibrator();
                                                  if (hasVibration!) {
                                                    Vibration.vibrate();
                                                  }
                                                } else {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    RenderRepaintBoundary? box =
                                                        questionsViewData[
                                                                    currentIndex]!
                                                                .stickerKey!
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderRepaintBoundary;

                                                    // final RenderBox box =
                                                    //     questionsViewData[
                                                    //             currentIndex]!
                                                    //         .stickerKey
                                                    //         .currentContext
                                                    //         .findRenderObject();
                                                    setState(() {
                                                      isTagSelected = false;
                                                      questionsViewData[
                                                              currentIndex]!
                                                          .w = box.size.width;
                                                      questionsViewData[
                                                              currentIndex]!
                                                          .h = box.size.height;
                                                    });
                                                  });
                                                }
                                                setState(() {
                                                  offset = Offset.zero;
                                                });
                                              },
                                              child: Transform.scale(
                                                scale: questionsViewData[
                                                        currentIndex]!
                                                    .scale,
                                                child: Container(
                                                  color: Colors.transparent,
                                                  // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(questionsViewData[currentIndex].rotation),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6.0.w,
                                                            vertical: 5.0.h),
                                                    child: Container(
                                                      height: questionsViewData[
                                                              currentIndex]!
                                                          .h,
                                                      width: questionsViewData[
                                                              currentIndex]!
                                                          .w,
                                                      color: Colors.transparent,
                                                      child: Center(
                                                        child: Container(
                                                          key: questionsViewData[
                                                                  currentIndex]!
                                                              .stickerKey,
                                                          padding:
                                                              EdgeInsets.all(7),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .2),
                                                                offset: Offset(
                                                                    0, 2),
                                                                blurRadius: 3,
                                                              ),
                                                            ],
                                                          ),
                                                          child:

                                                              //CHILD START

                                                              Stack(
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .70,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
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
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              15),
                                                                      child:
                                                                          Text(
                                                                        questionsViewData[currentIndex]!
                                                                            .name!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                        textScaleFactor:
                                                                            questionsViewData[currentIndex]!.scale!,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        borderRadius:
                                                                            BorderRadius.circular(7),
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "Viewers respond here",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          textScaleFactor:
                                                                              questionsViewData[currentIndex]!.scale,
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
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 20,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                      CurrentUser()
                                                                          .currentUser
                                                                          .image!,
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                            //CHILD END
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
                                      if (mentionUserList[currentIndex]
                                          .isNotEmpty)
                                        ...mentionUserList[pageIndex]
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
                                                        RenderRepaintBoundary? box = e
                                                                .key!
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderRepaintBoundary;

                                                        // final RenderBox box = e
                                                        //     .key.currentContext
                                                        //     .findRenderObject();
                                                        setState(() {
                                                          // e.lastRotation = e.rotation;
                                                          e.w = box.size.width;
                                                          e.h = box.size.height;
                                                        });
                                                      });
                                                    },
                                                    onScaleStart: (details) {
                                                      setState(() {
                                                        _baseScaleFactor =
                                                            e.scale!;
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                      });
                                                    },
                                                    onScaleUpdate: (details) {
                                                      setState(() {
                                                        // e.rotation = e.lastRotation - details.rotationAngle;
                                                        e.scale =
                                                            _baseScaleFactor *
                                                                details.scale;
                                                      });
                                                    },
                                                    onMoveStart: (details) {
                                                      setState(() {
                                                        offset = Offset(
                                                            e.posx!, e.posy!);
                                                      });
                                                    },
                                                    onMoveUpdate: (details) {
                                                      double xdiff = 0;
                                                      double ydiff = 0;
                                                      offset = Offset(
                                                          offset.dx +
                                                              details.delta.dx,
                                                          offset.dy +
                                                              details.delta.dy);
                                                      // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                      xdiff = (offset.dx) < 0
                                                          ? (-offset.dx)
                                                          : (offset.dx);
                                                      ydiff = deletePosition
                                                              .dy -
                                                          (offset.dy + 5.0.h);
                                                      print(ydiff);

                                                      print(deletePosition.dy
                                                              .toString() +
                                                          " delete pos");
                                                      if (((xdiff > 0 &&
                                                                  xdiff < 60) ||
                                                              (xdiff < 0 &&
                                                                  xdiff >=
                                                                      -1)) &&
                                                          ((ydiff > 0 &&
                                                                  ydiff <
                                                                      100) ||
                                                              (ydiff < 0 &&
                                                                  ydiff >=
                                                                      -1))) {
                                                        setState(() {
                                                          deleteIconColor =
                                                              true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          deleteIconColor =
                                                              false;
                                                        });
                                                      }
                                                      setState(() {
                                                        isTagSelected = true;
                                                        calculatePosition();
                                                        e.h = 100.0.h;
                                                        e.w = 100.0.w;
                                                        offset = Offset(
                                                            offset.dx +
                                                                details
                                                                    .delta.dx,
                                                            offset.dy +
                                                                details
                                                                    .delta.dy);
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
                                                          offset.dx +
                                                              details.delta.dx,
                                                          offset.dy +
                                                              details.delta.dy);
                                                      // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                      xdiff = (offset.dx) < 0
                                                          ? (-offset.dx)
                                                          : (offset.dx);
                                                      ydiff = deletePosition
                                                              .dy -
                                                          (offset.dy + 5.0.h);
                                                      print(ydiff);
                                                      if (((xdiff > 0 &&
                                                                  xdiff < 60) ||
                                                              (xdiff < 0 &&
                                                                  xdiff >=
                                                                      -1)) &&
                                                          ((ydiff > 0 &&
                                                                  ydiff <
                                                                      100) ||
                                                              (ydiff < 0 &&
                                                                  ydiff >=
                                                                      -1))) {
                                                        int i = mentionUserList[
                                                                pageIndex]
                                                            .indexOf(e);
                                                        setState(() {
                                                          mentionUserList[
                                                                  pageIndex]
                                                              .removeAt(i);
                                                          mentionUserIdList[
                                                                  pageIndex]
                                                              .removeAt(i);
                                                          print(
                                                              mentionUserList);
                                                          print(
                                                              mentionUserIdList);
                                                          // _controller.clear();
                                                          deleteIconColor =
                                                              false;
                                                          isTagSelected = false;
                                                        });

                                                        bool? hasVibration =
                                                            await Vibration
                                                                .hasVibrator();

                                                        if (hasVibration!) {
                                                          Vibration.vibrate();
                                                        }
                                                      } else {
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (timeStamp) {
                                                          RenderRepaintBoundary? box = e
                                                                  .key!
                                                                  .currentContext!
                                                                  .findRenderObject()
                                                              as RenderRepaintBoundary;
                                                          // final RenderBox box = e
                                                          //     .key
                                                          //     .currentContext
                                                          //     .findRenderObject();
                                                          setState(() {
                                                            isTagSelected =
                                                                false;
                                                            e.w =
                                                                box.size.width;
                                                            e.h =
                                                                box.size.height;
                                                          });
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData[currentIndex].rotation),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    6.0.w,
                                                                vertical:
                                                                    5.0.h),
                                                        child: Container(
                                                          height: e.h,
                                                          width: e.w,
                                                          color: Colors
                                                              .transparent,
                                                          child: Center(
                                                            child: Container(
                                                              key: e.key,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .2),
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Text(
                                                                e.name!
                                                                    .toUpperCase(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                        .rajdhani()
                                                                    .copyWith(
                                                                  // color: Colors.pink,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,

                                                                  foreground:
                                                                      Paint()
                                                                        ..shader =
                                                                            LinearGradient(
                                                                          colors: <
                                                                              Color>[
                                                                            Colors.orange,
                                                                            Colors.amber
                                                                          ],
                                                                          begin:
                                                                              Alignment.bottomLeft,
                                                                          end: Alignment
                                                                              .topRight,
                                                                        ).createShader(Rect.largest),
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
                                            .toList(),
                                      if (questionsReplyTextData != null)
                                        Positioned.fill(
                                          left: questionsReplyTextData.posx! -
                                              125,
                                          top: questionsReplyTextData.posy! -
                                              125,
                                          right: -125,
                                          bottom: -125,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: XGestureDetector(
                                              onLongPress: (val) {
                                                setState(() {
                                                  // showTextField = !showTextField;
                                                  questionsReplyTextData.h =
                                                      100.0.h;
                                                  questionsReplyTextData.w =
                                                      100.0.w;
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
                                                  RenderRepaintBoundary? box =
                                                      questionsReplyTextData
                                                              .stickerKey!
                                                              .currentContext!
                                                              .findRenderObject()
                                                          as RenderRepaintBoundary;

                                                  // final RenderBox box =
                                                  //     questionsReplyTextData
                                                  //         .stickerKey
                                                  //         .currentContext
                                                  //         .findRenderObject();
                                                  setState(() {
                                                    questionsReplyTextData
                                                            .lastRotation =
                                                        questionsReplyTextData
                                                            .rotation;
                                                    questionsReplyTextData.w =
                                                        box.size.width;
                                                    questionsReplyTextData.h =
                                                        box.size.height;
                                                  });
                                                });
                                              },
                                              onScaleStart: (details) {
                                                setState(() {
                                                  _baseScaleFactor =
                                                      questionsReplyTextData!
                                                          .scale!;
                                                  questionsReplyTextData.h =
                                                      100.0.h;
                                                  questionsReplyTextData.w =
                                                      100.0.w;
                                                });
                                              },
                                              onScaleUpdate: (details) {
                                                setState(() {
                                                  questionsReplyTextData
                                                          .rotation =
                                                      questionsReplyTextData
                                                              .lastRotation! -
                                                          details.rotationAngle;
                                                  questionsReplyTextData.scale =
                                                      _baseScaleFactor *
                                                          details.scale;
                                                });
                                              },
                                              onMoveStart: (details) {
                                                setState(() {
                                                  offset = Offset(
                                                      questionsReplyTextData
                                                          .posx!,
                                                      questionsReplyTextData
                                                          .posy!);
                                                });
                                              },
                                              onMoveUpdate: (details) {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
                                                // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
                                                print(ydiff);

                                                print(deletePosition.dy
                                                        .toString() +
                                                    " delete pos");
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 20.0.h);

                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
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
                                                  // calculatePosition();
                                                  questionsReplyTextData.h =
                                                      100.0.h;
                                                  questionsReplyTextData.w =
                                                      100.0.w;
                                                  offset = Offset(
                                                      offset.dx +
                                                          details.delta.dx,
                                                      offset.dy +
                                                          details.delta.dy);
                                                  questionsReplyTextData.posy =
                                                      offset.dy;
                                                  questionsReplyTextData.posx =
                                                      offset.dx;
                                                });
                                                // print(details.position.toString());
                                                // print(100.0.h);
                                                // print(deletePosition.toString());
                                              },
                                              onMoveEnd: (details) async {
                                                double xdiff = 0;
                                                double ydiff = 0;
                                                offset = Offset(
                                                    offset.dx +
                                                        details.delta.dx,
                                                    offset.dy +
                                                        details.delta.dy);
                                                // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                xdiff = (offset.dx) < 0
                                                    ? (-offset.dx)
                                                    : (offset.dx);
                                                ydiff = deletePosition.dy -
                                                    (offset.dy + 20.0.h);
                                                print(ydiff);
                                                if (((xdiff > 0 &&
                                                            xdiff < 60) ||
                                                        (xdiff < 0 &&
                                                            xdiff >= -1)) &&
                                                    ((ydiff > 0 &&
                                                            ydiff < 100) ||
                                                        (ydiff < 0 &&
                                                            ydiff >= -1))) {
                                                  // int i = tagsList[pageIndex].indexOf(questionsReplyViewData);
                                                  setState(() {
                                                    isquestionsViewAdd = false;
                                                    // tagsList[pageIndex].removeAt(i);
                                                    // _controller.clear();
                                                    // questionsReplyViewData = null;
                                                    deleteIconColor = false;
                                                    isTagSelected = false;
                                                  });

                                                  bool? hasVibration =
                                                      await Vibration
                                                          .hasVibrator();

                                                  if (hasVibration!) {
                                                    Vibration.vibrate();
                                                  }
                                                } else {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    RenderRepaintBoundary? box =
                                                        questionsReplyTextData
                                                                .stickerKey!
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderRepaintBoundary;
                                                    // final RenderBox box =
                                                    //     questionsReplyTextData
                                                    //         .stickerKey
                                                    //         .currentContext
                                                    //         .findRenderObject();
                                                    setState(() {
                                                      isTagSelected = false;
                                                      questionsReplyTextData.w =
                                                          box.size.width;
                                                      questionsReplyTextData.h =
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
                                                // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(questionsReplyViewData.rotation),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0.w,
                                                      vertical: 5.0.h),
                                                  child: Container(
                                                    height:
                                                        questionsReplyTextData
                                                            .h,
                                                    width:
                                                        questionsReplyTextData
                                                            .w,
                                                    color: Colors.transparent,
                                                    child: Center(
                                                      child: Container(
                                                        key:
                                                            questionsReplyTextData
                                                                .stickerKey,
                                                        // padding: EdgeInsets.all(7),
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
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          // padding: EdgeInsets.all(20),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .70,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        15),
                                                                child: Text(
                                                                  questionsReplyTextData
                                                                      .name!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade200,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                width: double
                                                                    .infinity,
                                                                child: Center(
                                                                  child: Text(
                                                                    questionsReplyTextData
                                                                        .extraName!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
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
                                    ],
                                  ),

                                  showTextField
                                      ? Positioned.fill(
                                          top: 30.0.h,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              autofocus: true,
                                              cursorColor: Colors.white,
                                              cursorHeight: 5.0.h,
                                              onTap: () {
                                                onTap(pageIndex);
                                              },
                                              onChanged: (val) {
                                                print(
                                                    "editing text=${val} $currentEditingTag");
                                                if (currentEditingTag >= 0) {
                                                  setState(() {
                                                    tagsList[pageIndex]
                                                            [currentEditingTag]
                                                        .name = val;
                                                    tagsList[pageIndex]
                                                            [currentEditingTag]
                                                        .w = 100.0.w;
                                                    tagsList[pageIndex]
                                                            [currentEditingTag]
                                                        .h = 100.0.h;
                                                  });
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    print(currentEditingTag);
                                                    RenderRepaintBoundary? box = tagsList[
                                                                    pageIndex][
                                                                currentEditingTag]
                                                            .key!
                                                            .currentContext!
                                                            .findRenderObject()
                                                        as RenderRepaintBoundary;
                                                    // final RenderBox box =
                                                    //     tagsList[pageIndex][
                                                    //             currentEditingTag]
                                                    //         .key
                                                    //         .currentContext
                                                    //         .findRenderObject();
                                                    setState(() {
                                                      tagsList[pageIndex][
                                                              currentEditingTag]
                                                          .w = box.size.width;
                                                      tagsList[pageIndex][
                                                              currentEditingTag]
                                                          .h = box.size.height;
                                                    });
                                                  });
                                                }

                                                List<String> users =
                                                    val.split(" ");

                                                if (users[users.length - 1]
                                                    .startsWith("#")) {
                                                  print("################");
                                                  getHashtags(
                                                      users[users.length - 1]
                                                          .replaceAll("#", ""));
                                                  setState(() {
                                                    showHashtags = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    tags.searchTags = [];
                                                    showHashtags = false;
                                                  });
                                                  print("endddddddddddd");
                                                }
                                                print("agaiaaannn");
                                                if (users[users.length - 1]
                                                    .startsWith("@")) {
                                                  print("@@@@@@@@@@@@@2");
                                                  getUserTags(
                                                      users[users.length - 1]
                                                          .replaceAll("@", ""));
                                                  setState(() {
                                                    showUsersList = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    tagList.userTags = [];
                                                    showUsersList = false;
                                                  });
                                                }
                                                print("checkkkkkkkkkkkk");
                                              },
                                              maxLines: null,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              controller: _controller,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: roboto.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: selectedColor,
                                                  fontSize: 25),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText: "",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10.0.sp),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  tagList != null &&
                                          tagList.userTags.length > 0 &&
                                          _controller.text.isNotEmpty
                                      ? Positioned.fill(
                                          bottom: CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight ==
                                                  0.0
                                              ? 35.0.h
                                              : (CurrentUser()
                                                          .currentUser
                                                          .keyBoardHeight! +
                                                      2.0.h) -
                                                  7.0.h,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                    children: tagList.userTags
                                                        .map((s) {
                                                  return UserRow(
                                                    user: s,
                                                    onTap: () {
                                                      mentionedUsersList
                                                          .add(s.memberId!);
                                                      print(mentionedUsersList);
                                                      String? str;
                                                      _controller.text
                                                          .split(" ")
                                                          .forEach((element) {
                                                        if (element
                                                            .startsWith("@")) {
                                                          str = element;
                                                        }
                                                      });
                                                      String data =
                                                          _controller.text;
                                                      data = _controller.text
                                                          .substring(
                                                              0,
                                                              data.length -
                                                                  str!.length +
                                                                  1);
                                                      data += s.shortcode!;
                                                      data += " ";
                                                      setState(() {
                                                        _controller.text = data;
                                                        tagList.userTags = [];
                                                        showUsersList = false;
                                                      });
                                                      _controller.selection =
                                                          TextSelection.fromPosition(
                                                              TextPosition(
                                                                  offset: _controller
                                                                      .text
                                                                      .length));
                                                    },
                                                  );
                                                }).toList()),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  tags != null &&
                                          tags.searchTags.length > 0 &&
                                          _controller.text.isNotEmpty
                                      ? Positioned.fill(
                                          bottom: (CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight! +
                                                  2.0.h) -
                                              7.0.h,
                                          child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: tags.searchTags
                                                        .map((e) =>
                                                            StoryHashtagsCard(
                                                              onTap: () {
                                                                String? str;
                                                                _controller.text
                                                                    .split(" ")
                                                                    .forEach(
                                                                        (element) {
                                                                  if (element
                                                                      .startsWith(
                                                                          "#")) {
                                                                    str =
                                                                        element;
                                                                  }
                                                                });
                                                                String data =
                                                                    _controller
                                                                        .text;
                                                                data = _controller
                                                                    .text
                                                                    .substring(
                                                                        0,
                                                                        data.length -
                                                                            str!.length +
                                                                            1);
                                                                data += e.name!;
                                                                data += " ";
                                                                setState(() {
                                                                  _controller
                                                                          .text =
                                                                      data;
                                                                  tags.searchTags =
                                                                      [];
                                                                  showHashtags =
                                                                      false;
                                                                });
                                                                _controller
                                                                        .selection =
                                                                    TextSelection.fromPosition(TextPosition(
                                                                        offset: _controller
                                                                            .text
                                                                            .length));
                                                              },
                                                              hashtag: e,
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              )),
                                        )
                                      : Container(),
                                  showColors &&
                                          !showUsersList &&
                                          !showHashtags &&
                                          keyboardVisible
                                      ? Positioned.fill(
                                          bottom: CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight ==
                                                  0.0
                                              ? 35.0.h
                                              : CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight! +
                                                  5.0.h
                                          //  (
                                          //   CurrentUser()
                                          //             .currentUser
                                          //             .keyBoardHeight +
                                          //         10.0.h

                                          //         ) -
                                          //     7.0.h
                                          ,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 4.5.h,
                                              color: Colors.transparent,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: colors.length + 1,
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (index == 0) {
                                                      return Container(
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border:
                                                              new Border.all(
                                                            color: Colors.white,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              selectedColor,
                                                          child: Icon(
                                                            Icons.brush,
                                                            color:
                                                                selectedColor ==
                                                                        Colors
                                                                            .white
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                            size: 2.0.h,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return StoryColorCard(
                                                        color:
                                                            colors[index - 1],
                                                        onTap: () {
                                                          if (currentEditingTag <
                                                              0) {
                                                            setState(() {
                                                              selectedColor =
                                                                  colors[index -
                                                                      1];
                                                            });
                                                          } else {
                                                            setState(() {
                                                              selectedColor =
                                                                  colors[index -
                                                                      1];
                                                              tagsList[pageIndex]
                                                                          [
                                                                          currentEditingTag]
                                                                      .color =
                                                                  colors[index -
                                                                      1];
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
                                  showFonts &&
                                          !showUsersList &&
                                          !showHashtags &&
                                          keyboardVisible
                                      ? Positioned.fill(
                                          bottom: (CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight ==
                                                  0.0
                                              ? 35.0.h
                                              : CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight! +
                                                  5.0.h)
                                          //     -
                                          // 7.0.h
                                          ,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 4.5.h,
                                              color: Colors.transparent,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: fontsList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return StoryFontCard(
                                                      index: index,
                                                      font: fontsList[index],
                                                      selectedFontIndex:
                                                          selectedFontIndex,
                                                      onTap: () {
                                                        if (currentEditingTag <
                                                            0) {
                                                          setState(() {
                                                            roboto = fontsList[
                                                                index];
                                                            selectedFontIndex =
                                                                index;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            roboto = fontsList[
                                                                index];
                                                            selectedFontIndex =
                                                                index;
                                                            tagsList[pageIndex][
                                                                        currentEditingTag]
                                                                    .font =
                                                                fontsList[
                                                                    index];
                                                          });
                                                        }
                                                      },
                                                    );
                                                  }),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              );
                            }),
                      ),
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        _showStickersPage();
                      },
                      child: Container(
                        color: Colors.black,
                        height: 7.0.h,
                      ),
                    ),
                  ],
                ),
                allFiles.length > 1
                    ? DeleteFiles(
                        delete: () {
                          setState(() {
                            allFiles.removeAt(currentIndex);
                            assetsList.removeAt(currentIndex);
                          });
                        },
                      )
                    : Container(),
                Positioned.fill(
                  bottom: 7.0.h,
                  child: Align(
                    alignment: allFiles.length > 1
                        ? Alignment.bottomCenter
                        : Alignment.bottomRight,
                    child: Container(
                      color: allFiles.length > 1
                          ? Colors.black.withOpacity(0.7)
                          : Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Row(
                          mainAxisSize: allFiles.length > 1
                              ? MainAxisSize.max
                              : MainAxisSize.min,
                          mainAxisAlignment: allFiles.length > 1
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            allFiles.length > 1
                                ? Container(
                                    height: 8.0.h,
                                    width: 65.0.w,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: allFiles.length,
                                        itemBuilder: (context, index) {
                                          return AllFilesRow(
                                            navigate: () async {
                                              // print(
                                              //     "reached here= ${currentIndex} len= ${musicViewData[currentIndex].musicdata.songTitle}");
                                              if (thisplayer.playing)
                                                thisplayer.stop();
                                              else {}
                                              try {
                                                print("music here aha");
                                                thisplayer!.setUrl(
                                                    musicViewData[index]
                                                        .musicdata!
                                                        .songUrl!);
                                                thisplayer.play();
                                                thisplayer
                                                    .setLoopMode(LoopMode.all);
                                              } catch (e) {}
                                              print("here index=$index");
                                              pageController.jumpToPage(index);
                                              // pageController.animateToPage(
                                              //     index,
                                              //     duration:
                                              //         Duration(milliseconds: 2),
                                              //     curve: Curves.easeIn);
                                              setState(() {
                                                currentIndex = index;

                                                print(
                                                    "currentIndex  => $currentIndex");
                                              });
                                            },
                                            index: index,
                                            currentIndex: currentIndex,
                                            assetsList:
                                                widget.assetsList![index],
                                          );
                                        }),
                                  )
                                : Container(
                                    color: Colors.red,
                                    height: 0.0.h,
                                    width: 0.0.w,
                                  ),
                            SizedBox(
                              width: 5.0.w,
                            ),
                            InkWell(
                              onTap: () {
                                String res = "";
                                publishStory();
                                //uploadStory(tags.join("~~~"));
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
                                            AppLocalizations.of(
                                              "Send to",
                                            ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                !showTextField
                    ? Positioned.fill(
                        right: 5.0.w,
                        top: 1.5.h,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    onTap: () {
                                      /*if(links.length > 0) {
                                        if (links[currentIndex].isNotEmpty) {
                                          links.removeAt(currentIndex);
                                        }
                                      }*/

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddLinkToStory(
                                                    addLink: (link) {
                                                      setState(() {
                                                        links.add(
                                                            (currentIndex + 1)
                                                                    .toString() +
                                                                "^^" +
                                                                link);
                                                      });
                                                      print(links.join("~~~"));
                                                    },
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.link,
                                      color: Colors.white,
                                      size: 3.5.h,
                                    )),
                                SizedBox(
                                  width: 4.0.w,
                                ),
                                InkWell(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                        msg: AppLocalizations.of(
                                          "Saved to gallery",
                                        ),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.7),
                                        textColor: Colors.white,
                                        fontSize: 15.0,
                                      );

                                      if (allFiles[currentIndex]
                                              .path
                                              .endsWith(".jpg") ||
                                          allFiles[currentIndex]
                                              .path
                                              .endsWith(".png") ||
                                          allFiles[currentIndex]
                                              .path
                                              .endsWith(".JPG") ||
                                          allFiles[currentIndex]
                                              .path
                                              .endsWith(".PNG")) {
                                        _capturePng();
                                      } else {
                                        GallerySaver.saveVideo(
                                            allFiles[currentIndex].path,
                                            albumName: "Bebuzee");
                                      }
                                    },
                                    child: Icon(
                                      Icons.download_sharp,
                                      color: Colors.white,
                                      size: 4.0.h,
                                    )),
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
                                SizedBox(
                                  width: 4.0.w,
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        showTextField = true;
                                        showFonts = true;
                                        showColors = false;
                                      });
                                    },
                                    child: Text(
                                      AppLocalizations.of("Aa"),
                                      style: TextStyle(
                                          fontSize: 2.5.h,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    )),
                              ],
                            )),
                      )
                    : Positioned.fill(
                        top: 1.5.h,
                        child: keyboardVisible
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            showFonts = !showFonts;
                                            showColors = !showColors;
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
                                                    "assets/images/gradient.png"))),
                                    SizedBox(
                                      width: 4.0.w,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          print("emoticon page");
                                          _showStickersPage();
                                        },
                                        child: Icon(
                                          Icons.emoji_emotions_outlined,
                                          color: Colors.white,
                                          size: 4.0.h,
                                        )),
                                  ],
                                ))
                            : Container(),
                      ),
                isTagSelected
                    ? Positioned.fill(
                        bottom: 17.0.h,
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
                            )))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HashTagSelectView extends StatefulWidget {
  final Function onDone;
  final String oldHashtag;
  const HashTagSelectView(
      {Key? key, required this.onDone, required this.oldHashtag})
      : super(key: key);

  @override
  _HashTagSelectViewState createState() => _HashTagSelectViewState();
}

class _HashTagSelectViewState extends State<HashTagSelectView> {
  TagPlaces tags = new TagPlaces([]);
  bool hasData = false;
  bool showHashtags = false;

  Future<void> getHashtags(text) async {
    // var url = Uri.parse(
    // "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_hashtags_tags_data&user_id=${CurrentUser().currentUser.memberID}&keyword=$text");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/search_hastag_list.php",
        {"user_id": CurrentUser().currentUser.memberID, "keyword": text});

    if (response!.success == 1) {
      TagPlaces tagData = TagPlaces.fromJson(response!.data['data']);
      print(CurrentUser().currentUser.keyBoardHeight);
      if (mounted) {
        setState(() {
          tags = tagData;
          hasData = true;
        });
      }

      if (response!.data == null ||
          response!.data['data'] == null ||
          response!.data['data'] == []) {
        setState(() {
          hasData = false;
        });
      }
    }
  }

  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text:
            "${widget.oldHashtag == null || widget.oldHashtag == '' ? '#' : widget.oldHashtag}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 48),
                  child: IntrinsicWidth(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (val) {
                        List<String> users = val.split(" ");

                        if (users[users.length - 1].startsWith("#")) {
                          print("################");
                          getHashtags(
                              users[users.length - 1].replaceAll("#", ""));
                          setState(() {
                            showHashtags = true;
                          });
                        }
                      },
                      style: GoogleFonts.rajdhani().copyWith(
                        // color: Colors.pink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[Colors.orange, Colors.pink],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ).createShader(Rect.largest),
                      ),
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                widget.onDone(context, _controller.text);
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
          Positioned.fill(
            bottom: (CurrentUser().currentUser.keyBoardHeight! + 2.0.h),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: tags.searchTags
                          .map((e) => StoryHashtagsCard(
                                onTap: () {
                                  String? str;
                                  _controller.text
                                      .split(" ")
                                      .forEach((element) {
                                    if (element.startsWith("#")) {
                                      str = element;
                                    }
                                  });
                                  String data = _controller.text;
                                  data = _controller.text.substring(
                                      1, data.length - str!.length + 1);
                                  data += e.name!;
                                  data += " ";
                                  setState(() {
                                    _controller.text = data.toUpperCase();
                                    tags.searchTags = [];
                                    showHashtags = false;
                                  });
                                  _controller.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _controller.text.length));
                                },
                                hashtag: e,
                              ))
                          .toList(),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class MentionSelectView extends StatefulWidget {
  final Function onDone;
  const MentionSelectView({Key? key, required this.onDone}) : super(key: key);

  @override
  _MentionSelectViewState createState() => _MentionSelectViewState();
}

class _MentionSelectViewState extends State<MentionSelectView> {
  UserTags tagList = new UserTags([]);
  late String mentionedUserID;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: "${'@'}");
    super.initState();
  }

  Future<void> getUserTags(String searchedTag) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/user/userSearchFollowers", {
      "user_id": CurrentUser().currentUser.memberID,
      "searchword": searchedTag
    });

    // print(response!.body);
    if (response!.success == 1) {
      UserTags tagsData = UserTags.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          tagList = tagsData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 48),
                  child: IntrinsicWidth(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (val) {
                        List<String> users = val.split(" ");

                        if (users[users.length - 1].startsWith("@")) {
                          print("@@@@@@@@@@@@@2");
                          getUserTags(
                              users[users.length - 1].replaceAll("@", ""));
                          setState(() {
                            // showUsersList = true;
                          });
                        } else {
                          setState(() {
                            tagList.userTags = [];
                            // showUsersList = false;
                          });
                        }
                      },
                      style: GoogleFonts.rajdhani().copyWith(
                        // color: Colors.pink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,

                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[Colors.orange, Colors.amberAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(Rect.largest),
                      ),
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                widget.onDone(context, _controller.text, mentionedUserID);
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
          Positioned.fill(
            bottom: (CurrentUser().currentUser.keyBoardHeight! + 2.0.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: tagList.userTags.map((s) {
                    return UserRow(
                      user: s,
                      onTap: () {
                        mentionedUserID = s.memberId!;
                        print(mentionedUserID);
                        String? str;
                        _controller.text.split(" ").forEach((element) {
                          if (element.startsWith("@")) {
                            str = element;
                          }
                        });
                        String? data = _controller.text;
                        data = _controller.text
                            .substring(0, data.length - str!.length + 1);
                        data += s.shortcode!;
                        data += " ";
                        setState(() {
                          _controller.text = data!;
                          tagList.userTags = [];
                          // showUsersList = false;
                        });
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length));
                      },
                    );
                  }).toList()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LocationInputView extends StatefulWidget {
  final Function? onDone;
  final String? oldLocation;

  const LocationInputView(
      {Key? key, @required this.onDone, @required this.oldLocation})
      : super(key: key);

  @override
  _LocationInputViewState createState() => _LocationInputViewState();
}

class _LocationInputViewState extends State<LocationInputView> {
  var _controller = TextEditingController();
  var uuid = new Uuid();
  late String _sessionToken;
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACESAPIKEY = "AIzaSyBP5GiOKxigNkvU6tyUbhX3fZgavwPHbik";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken';
    print("locaction url =${request}");
    var response = await http.get(Uri.parse(request));
    print("response of location ${response!.body}");
    if (response!.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response!.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Location"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Seek your location here",
                    focusColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: Icon(Icons.map),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      widget.onDone!(context, _placeList[index]["description"]);
                    },
                    leading: Icon(Icons.location_on),
                    title: Text(
                      _placeList[index]["description"],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionsInputView extends StatefulWidget {
  final Function? onDone;
  final String? oldQuestionsText;

  const QuestionsInputView(
      {Key? key, @required this.onDone, @required this.oldQuestionsText})
      : super(key: key);

  @override
  _QuestionsInputViewState createState() => _QuestionsInputViewState();
}

class _QuestionsInputViewState extends State<QuestionsInputView> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.oldQuestionsText ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  widget.onDone!(
                    context,
                    _controller.text,
                  );
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
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * .70,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 3,
                          minLines: 1,
                          onChanged: (val) {},
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ask me a question",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Viewers respond here",
                              style: TextStyle(
                                color: Colors.grey,
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
                        backgroundImage: NetworkImage(
                          CurrentUser().currentUser.image!,
                        ),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MusicView extends StatefulWidget {
  final Function onDone;
  final String oldQuestionsText;
  final String? songId;
  final String? songImageUrl;
  final String? songTitle;
  final String? songArtist;
  final String? songUrl;
  const MusicView({
    Key? key,
    required this.onDone,
    required this.oldQuestionsText,
    this.songId,
    this.songImageUrl,
    this.songArtist,
    this.songTitle,
    this.songUrl,
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
      var value = _animcontroller?.value ?? 0;
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
      // ClipRRect(
      //   borderRadius: BorderRadius.all(Radius.circular(15)),
      //   child:

      CircularPercentIndicator(
          radius: 15.0.w,
          // percent: _sliderValue,
          progressColor: Color(0xffA56169),
          center: AnimatedBuilder(
            animation: _animcontroller,
            builder: (_, child) {
              return Transform.rotate(
                angle: getAngle(),
                child: child,
              );
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
                //  Image.asset(
                //   AudioManager.instance.info?.coverUrl ??
                //       "assets/images/disc.png",
                //   width: 120.0,
                //   height: 120.0,
                //   fit: BoxFit.cover,
                // )

                ),
          )
          // Card(
          //   color: Colors.black,
          //   shape: RoundedRectangleBorder(),
          //   child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
          // ),
          );
      // );
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
                    widget.onDone(
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
                                  "forward currentsecond=${player.duration!.inSeconds!} and forward ${currentDuration}");
                              // player.durationFuture.then((value) =>value,)
                              setState(() {
                                currentDuration = Duration(
                                    seconds: player.position.inSeconds + 1);
                              });
                              if (currentDuration.inSeconds >
                                  player.duration!.inSeconds!) {
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

class MusicInputView extends StatefulWidget {
  final Function onDone;
  final String? oldQuestionsText;
  final String? song_id;
  final song_image_url;

  MusicInputView(
      {Key? key,
      required this.onDone,
      this.oldQuestionsText,
      this.song_id,
      this.song_image_url})
      : super(key: key);

  @override
  _MusicInputViewState createState() => _MusicInputViewState();
}

class _MusicInputViewState extends State<MusicInputView> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.oldQuestionsText ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AudioSource.uri
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  widget.onDone!(
                    context,
                    _controller.text,
                  );
                },
                child: Text(
                  "Music Done",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * .70,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 3,
                          minLines: 1,
                          onChanged: (val) {},
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ask me a question",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Viewers respond here",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Positioned(
                  //   left: 0,
                  //   right: 0,
                  //   top: -20,
                  //   child: Center(
                  //     child: CircleAvatar(
                  //       radius: 20,
                  //       backgroundImage: NetworkImage(
                  //         CurrentUser().currentUser.image,
                  //       ),
                  //       backgroundColor: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  Stack(
                    alignment: Alignment.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
