import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/ApiRepo.dart';
import 'package:bizbultest/models/stickers_model.dart';
import 'package:bizbultest/models/tags_search_model.dart';
import 'package:bizbultest/widgets/Shortbuz/upload_shortbuz.dart';
import 'package:bizbultest/widgets/Stories/add_link.dart';
import 'package:bizbultest/widgets/Stories/story_widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:bizbultest/widgets/FeedPosts/feed_post_gallery.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/utilities/constant.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:vibration/vibration.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class AddTagsShortbuz extends StatefulWidget {
  final File? file;
  final List<AssetCustom>? assetsList;
  final List<File>? filesList;
  final String? path;
  final String? type;
  final bool? flip;
  final Function? clear;
  final bool? from;
  final Function? refreshFromShortbuz;

  const AddTagsShortbuz(
      {Key? key,
      this.file,
      this.type,
      this.flip,
      this.path,
      this.filesList,
      this.clear,
      this.assetsList,
      this.from,
      this.refreshFromShortbuz})
      : super(key: key);

  @override
  _AddTagsShortbuzState createState() => _AddTagsShortbuzState();
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
  GlobalKey key = new GlobalKey();

  TagsClass(posx, posy, name, scale, color, font) {
    this.posx = posx;
    this.posy = posy;
    this.name = name;
    this.scale = scale;
    this.color = color;
    this.font = font;
  }
}

class StickerClass {
  double? posx;
  double? posy;
  String? name;
  double? scale;
  String? id;
  double? h;
  double? w;
  GlobalKey stickerKey = new GlobalKey();

  StickerClass(posx, posy, name, scale, id) {
    this.posx = posx;
    this.posy = posy;
    this.name = name;
    this.scale = scale;
    this.id = id;
  }
}

class _AddTagsShortbuzState extends State<AddTagsShortbuz>
    with SingleTickerProviderStateMixin {
  img.Image? image;
  File? finalFile;
  bool showTextField = false;
  PageController pageController = PageController();
  TextEditingController _controller = TextEditingController();
  double keyBoardHeight = 0;
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
  double w = 100.0.w;
  List<List<TagsClass>> tagsList = [];
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
  TextEditingController _searchController = TextEditingController();

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

  void onTap(int pageIndex) {
    setState(() {
      showTextField = !showTextField;
    });
    if (showTextField) {
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showFonts = true;
          showColors = false;
          selectedColor = Colors.white;
          roboto = GoogleFonts.roboto();
          selectedFontIndex = 5;
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
        print(CurrentUser().currentUser.keyBoardHeight);
      });
    }
    if (!showTextField && _controller.text != "" && currentEditingTag < 0) {
      setState(() {
        showFonts = false;
        showColors = false;
        offset = Offset.zero;
        tagsList[pageIndex].add(new TagsClass(offset.dx, offset.dy,
            _controller.text, 1.0, selectedColor, roboto));
        _controller.text = "";
      });

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        RenderRepaintBoundary? box = tagsList[pageIndex]
                [tagsList[pageIndex].length - 1]
            .key
            .currentContext!
            .findRenderObject() as RenderRepaintBoundary?;

        // final RenderBox box = tagsList[pageIndex]
        //         [tagsList[pageIndex].length - 1]
        //     .key
        //     .currentContext
        //     .findRenderObject();
        setState(() {
          tagsList[pageIndex][tagsList[pageIndex].length - 1].w =
              box!.size.width;
          tagsList[pageIndex][tagsList[pageIndex].length - 1].h =
              box!.size.height;
        });
      });
    } else {
      setState(() {
        currentEditingTag = -1;
      });
    }
  }

  Widget _stickers() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      shape: BoxShape.rectangle,
                    ),
                    width: 45,
                    height: 4,
                  ),
                )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Container(
                    child: TextFormField(
                      onChanged: (val) {
                        print(val);
                        if (val == "") {
                          getStickers("", state);
                        } else {
                          getStickers(val, state);
                        }
                      },
                      maxLines: null,
                      controller: _searchController,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                        isDense: true,

                        hintText: AppLocalizations.of('Search'),
                        //alignLabelWithHint: true,
                        contentPadding: EdgeInsets.only(left: 4.0.w, top: 15),
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 11.0.sp),
                      ),
                    ),
                  ),
                ),
                TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        child: Text(
                          AppLocalizations.of(
                            "Stickers",
                          ),
                          style:
                              TextStyle(color: Colors.white, fontSize: 9.0.sp),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppLocalizations.of(
                            "Emojis",
                          ),
                          style:
                              TextStyle(color: Colors.white, fontSize: 9.0.sp),
                        ),
                      ),
                    ]),
                Container(
                  height: 75.0.h,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      areStickersLoaded
                          ? GridView.builder(
                              shrinkWrap: true,
                              controller: ModalScrollController.of(context),
                              itemCount: stickersList.stickers.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemBuilder: (context, index) {
                                return AspectRatio(
                                  aspectRatio: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      state(() {
                                        _searchController.text = "";
                                      });
                                      setState(() {
                                        offset = Offset.zero;
                                        stickerList[currentIndex].add(
                                            new StickerClass(
                                                offset.dx,
                                                offset.dy,
                                                stickersList
                                                    .stickers[index].name,
                                                1.0,
                                                stickersList
                                                    .stickers[index].id));
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 20,
                                      child: Image.network(
                                        stickersList.stickers[index].name!,
                                        height: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Container(),
                      areEmojisLoaded
                          ? GridView.builder(
                              shrinkWrap: true,
                              controller: ModalScrollController.of(context),
                              itemCount: emojisList.stickers.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemBuilder: (context, index) {
                                return AspectRatio(
                                  aspectRatio: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      state(() {
                                        _searchController.text = "";
                                      });

                                      setState(() {
                                        offset = Offset.zero;
                                        stickerList[currentIndex].add(
                                            new StickerClass(
                                                offset.dx,
                                                offset.dy,
                                                emojisList.stickers[index].name,
                                                1.0,
                                                emojisList.stickers[index].id));
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 20,
                                      child: Image.network(
                                        emojisList.stickers[index].name!,
                                        height: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

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
      RenderRepaintBoundary? box = deleteKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary?;

      // final RenderBox box = deleteKey.currentContext.findRenderObject();
      setState(() {
        deletePosition = box!.localToGlobal(Offset.zero);
      });
    });
  }

  List<List<StickerClass>> stickerList = [];

  void calculateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderRepaintBoundary? box =
          keyText.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      // final RenderBox box = keyText.currentContext.findRenderObject();
      setState(() {
        size = box!.size;
        w = size.width;
        h = size.height;
      });
    });
  }

  Future loadSingleFile() async {
    allFiles.add(widget.file!);
    _generateThumbnail(widget.file!);
    //img.Image drawImage = img.drawString(image, img.arial_48, 250, 250, "Helooooooooooooo");
  }

  late Uint8List unit8list;

  void _generateThumbnail(File file) async {
    unit8list = (await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,

      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 70,
    ))!;
  }

  Future loadMultipleFiles() async {
    for (int i = 0; i < widget.assetsList!.length; i++) {
      var file = await widget.assetsList![i].asset!.file;
      setState(() {
        allFiles.add(file!);
      });
      _generateThumbnail(file!);
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
      //print(peopleData.people[0].name);
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

  Future<void> getUserTags(String searchedTag) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag");

    var response = await http.get(url);

    print(response!.body);
    if (response!.statusCode == 200) {
      UserTags tagsData = UserTags.fromJson(jsonDecode(response!.body));
      if (mounted) {
        setState(() {
          tagList = tagsData;
          areTagsLoaded = true;
        });
      }
    }

    if (response!.body == null || response!.statusCode != 200) {
      setState(() {
        areTagsLoaded = false;
      });
    }
  }

  late Stickers stickersList;
  bool areStickersLoaded = false;
  late Stickers emojisList;
  bool areEmojisLoaded = false;
  late TabController _tabController;

  Future<void> getStickers(String search, StateSetter state) async {
    // https://www.bebuzee.com/api/story_stickers_image.php
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?user_id=${CurrentUser().currentUser.memberID}&action=story_swipe_image&keyword=$search");
    print("===http response check====");
    try {
      var httpResponse = await get(
          "api/story_stickers_image.php?user_id=${CurrentUser().currentUser.memberID}&action=story_swipe_image&keyword=$search");
      print(httpResponse.data);

      if (httpResponse.data != null) {
        //Stickers stickerData = Stickers.fromJson(jsonDecode(response!.body));
        Stickers stickerData = httpResponse.data;
        if (mounted) {
          state(() {
            stickersList = stickerData;
            areStickersLoaded = true;
          });
        }
      }

      // if (response!.body == null || response!.statusCode != 200) {
      //   if (mounted) {
      //     state(() {
      //       areStickersLoaded = false;
      //     });
      //   }
      // }
    } catch (e) {}
  }

  Future<void> getEmojis() async {
    var httpResponse = await get(
        "api/story_stickers_image.php?action=story_stickers_image&user_id=${CurrentUser().currentUser.memberID}");

    print(httpResponse);
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_story_data.php?action=story_stickers_image&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      Stickers emojiData = Stickers.fromJson(jsonDecode(response!.body));
      if (mounted) {
        setState(() {
          emojisList = emojiData;
          areEmojisLoaded = true;
        });
      }
    }

    if (response!.body == null || response!.statusCode != 200) {
      setState(() {
        areEmojisLoaded = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.from == "assets") {
      loadMultipleFiles();
      for (int i = 0; i < widget.assetsList!.length; i++) {
        tagsList.add([]);
        stickerList.add([]);
      }
    } else {
      loadSingleFile();
      tagsList.add([]);
      stickerList.add([]);
    }

    getStickers("", setState);
    getEmojis();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);

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
          widget.clear!();
          return true;
        },
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
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
                            itemCount: allFiles.length,
                            itemBuilder: (context, pageIndex) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      onTap(pageIndex);
                                    },
                                    child: widget.assetsList != null
                                        ? Container(
                                            child: widget.assetsList![pageIndex]
                                                        .asset!.type
                                                        .toString() !=
                                                    "AssetType.video"
                                                ? Container(
                                                    child: Image.file(
                                                      allFiles[pageIndex],
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
                                                            alignment: Alignment
                                                                .center,
                                                            transform: Matrix4
                                                                .rotationY(
                                                                    math.pi),
                                                            child:
                                                                FittedVideoPlayerStory(
                                                              video: allFiles[
                                                                  pageIndex],
                                                            ),
                                                          )
                                                        : FittedVideoPlayerStory(
                                                            video: allFiles[
                                                                pageIndex],
                                                          ),
                                                  ),
                                          )
                                        : Container(
                                            child: widget.type == "image"
                                                ? Container(
                                                    child: Image.file(
                                                      allFiles[pageIndex],
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
                                                            alignment: Alignment
                                                                .center,
                                                            transform: Matrix4
                                                                .rotationY(
                                                                    math.pi),
                                                            child:
                                                                FittedVideoPlayerStory(
                                                              video: allFiles[
                                                                  pageIndex],
                                                            ),
                                                          )
                                                        : FittedVideoPlayerStory(
                                                            video: allFiles[
                                                                pageIndex],
                                                          ),
                                                  ),
                                          ),
                                  ),
                                  Stack(
                                    children: tagsList[pageIndex]
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
                                                    onTap: (val) {
                                                      setState(() {
                                                        showColors = false;
                                                        showFonts = true;
                                                        showTextField = true;
                                                        _controller.text =
                                                            e.name!;
                                                        roboto = e.font!;
                                                        selectedColor =
                                                            e.color!;
                                                        currentEditingTag =
                                                            tagsList[pageIndex]
                                                                .indexOf(e);
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
                                                        RenderRepaintBoundary?
                                                            box =
                                                            e.key.currentContext!
                                                                    .findRenderObject()
                                                                as RenderRepaintBoundary?;

                                                        // final RenderBox box = e
                                                        //     .key.currentContext
                                                        //     .findRenderObject();
                                                        setState(() {
                                                          e.w = box!.size.width;
                                                          e.h =
                                                              box!.size.height;
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
                                                    onMoveUpdate: (details) {
                                                      double xdiff = 0;
                                                      double ydiff = 0;
                                                      offset = Offset(
                                                          offset.dx +
                                                              details.delta.dx,
                                                          offset.dy +
                                                              details.delta.dy);
                                                      //xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                      ydiff =
                                                          deletePosition.dy -
                                                              (offset.dy +
                                                                  5.0.h +
                                                                  125);
                                                      if ((ydiff > 0 &&
                                                              ydiff < 100) ||
                                                          (ydiff < 0 &&
                                                              ydiff >= -1)) {
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
                                                      //xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
                                                      ydiff =
                                                          deletePosition.dy -
                                                              (offset.dy +
                                                                  5.0.h +
                                                                  125);

                                                      if ((ydiff > 0 &&
                                                              ydiff < 100) ||
                                                          (ydiff < 0 &&
                                                              ydiff >= -1)) {
                                                        int i =
                                                            tagsList[pageIndex]
                                                                .indexOf(e);
                                                        setState(() {
                                                          tagsList[pageIndex]
                                                              .removeAt(i);
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
                                                                  .key
                                                                  .currentContext!
                                                                  .findRenderObject()
                                                              as RenderRepaintBoundary?;

                                                          // final RenderBox box = e
                                                          //     .key
                                                          //     .currentContext
                                                          //     .findRenderObject();
                                                          setState(() {
                                                            isTagSelected =
                                                                false;

                                                            e.w =
                                                                box!.size.width;
                                                            e.h = box!
                                                                .size.height;
                                                          });
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
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
                                                            child: Text(
                                                              e!.name!,
                                                              style: e.font!.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      e.color,
                                                                  fontSize: 25),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              textScaleFactor:
                                                                  e.scale,
                                                              key: e.key,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ))
                                        .toList(),
                                  ),
                                  Stack(
                                    children: stickerList[pageIndex]
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
                                                        });
                                                      },
                                                      onTap: (val) {},
                                                      onScaleEnd: () {},
                                                      onScaleStart: (details) {
                                                        setState(() {
                                                          _baseScaleFactor =
                                                              e.scale!;
                                                          /*e.h = 100.0.h;
                                                          e.w = 100.0.w;*/
                                                        });
                                                      },
                                                      onScaleUpdate: (details) {
                                                        setState(() {
                                                          e.scale =
                                                              _baseScaleFactor *
                                                                  details.scale;
                                                        });
                                                      },
                                                      onMoveUpdate: (details) {
                                                        double xdiff = 0;
                                                        double ydiff = 0;
                                                        offset = Offset(
                                                            offset.dx +
                                                                details
                                                                    .delta.dx,
                                                            offset.dy +
                                                                details
                                                                    .delta.dy);
                                                        xdiff = deletePosition
                                                                        .dx -
                                                                    offset.dx <
                                                                0
                                                            ? offset.dx -
                                                                deletePosition
                                                                    .dx
                                                            : deletePosition
                                                                    .dx -
                                                                offset.dx;
                                                        ydiff =
                                                            deletePosition.dy -
                                                                (offset.dy +
                                                                    4.0.h +
                                                                    125);
                                                        print(e.posy!
                                                                .toInt()
                                                                .toString() +
                                                            " dy,  " +
                                                            deletePosition.dy
                                                                .toInt()
                                                                .toString() +
                                                            "~~" +
                                                            (e.posy!.toInt() +
                                                                    200)
                                                                .toString());
                                                        if ((ydiff > 0 &&
                                                                ydiff < 100) ||
                                                            (ydiff < 0 &&
                                                                ydiff >= -1)) {
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
                                                          offset = Offset(
                                                              offset.dx +
                                                                  details
                                                                      .delta.dx,
                                                              offset.dy +
                                                                  details.delta
                                                                      .dy);
                                                          e.posy = offset.dy;
                                                          e.posx = offset.dx;
                                                        });
                                                      },
                                                      onMoveEnd:
                                                          (details) async {
                                                        double xdiff = 0;
                                                        double ydiff = 0;
                                                        offset = Offset(
                                                            offset.dx +
                                                                details
                                                                    .delta.dx,
                                                            offset.dy +
                                                                details
                                                                    .delta.dy);
                                                        xdiff = deletePosition
                                                                        .dx -
                                                                    offset.dx <
                                                                0
                                                            ? offset.dx -
                                                                deletePosition
                                                                    .dx
                                                            : deletePosition
                                                                    .dx -
                                                                offset.dx;
                                                        ydiff =
                                                            deletePosition.dy -
                                                                (offset.dy +
                                                                    4.0.h +
                                                                    125);
                                                        print(ydiff);

                                                        if ((ydiff > 0 &&
                                                                ydiff < 100) ||
                                                            (ydiff < 0 &&
                                                                ydiff >= -1)) {
                                                          int i = stickerList[
                                                                  pageIndex]
                                                              .indexOf(e);
                                                          setState(() {
                                                            stickerList[
                                                                    pageIndex]
                                                                .removeAt(i);
                                                            deleteIconColor =
                                                                false;
                                                            isTagSelected =
                                                                false;
                                                          });
                                                          bool? hasVibration =
                                                              await Vibration
                                                                  .hasVibrator();
                                                          if (hasVibration!) {
                                                            Vibration.vibrate();
                                                          }
                                                        } else {
                                                          setState(() {
                                                            isTagSelected =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        color:
                                                            Colors.transparent,
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
                                                          child: Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.0
                                                                              .w,
                                                                      vertical:
                                                                          4.0.h),
                                                              child: Transform(
                                                                transform: new Matrix4
                                                                    .diagonal3(new v
                                                                        .Vector3(
                                                                    e.scale!,
                                                                    e.scale!,
                                                                    e.scale!)),
                                                                alignment:
                                                                    FractionalOffset
                                                                        .center,
                                                                child: Image
                                                                    .network(
                                                                  e.name!,
                                                                  height: 85,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                            ))
                                        .toList(),
                                  ),
                                  showTextField
                                      ? Positioned.fill(
                                          top: 30.0.h,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              height: 8.0.h,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                autofocus: true,
                                                cursorColor: Colors.white,
                                                cursorHeight: 5.0.h,
                                                onTap: () {
                                                  onTap(pageIndex);
                                                },
                                                onChanged: (val) {
                                                  if (currentEditingTag >= 0) {
                                                    setState(() {
                                                      tagsList[pageIndex][
                                                              currentEditingTag]
                                                          .name = val;
                                                      tagsList[pageIndex][
                                                              currentEditingTag]
                                                          .w = 100.0.w;
                                                      tagsList[pageIndex][
                                                              currentEditingTag]
                                                          .h = 100.0.h;
                                                    });
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (timeStamp) {
                                                      print(currentEditingTag);

                                                      RenderRepaintBoundary? box = tagsList[
                                                                      pageIndex]
                                                                  [
                                                                  currentEditingTag]
                                                              .key
                                                              .currentContext!
                                                              .findRenderObject()
                                                          as RenderRepaintBoundary?;

                                                      // final RenderBox box = tagsList[
                                                      //             pageIndex][
                                                      //         currentEditingTag]
                                                      //     .key
                                                      //     .currentContext
                                                      //     .findRenderObject();
                                                      setState(() {
                                                        tagsList[pageIndex][
                                                                currentEditingTag]
                                                            .w = box!.size.width;
                                                        tagsList[pageIndex][
                                                                currentEditingTag]
                                                            .h = box.size.height;
                                                      });
                                                    });
                                                  }
                                                  //print(val);
                                                  List<String> users =
                                                      val.split(" ");
                                                  if (users[users.length - 1]
                                                      .startsWith("#")) {
                                                    getHashtags(
                                                        users[users.length - 1]
                                                            .replaceAll(
                                                                "#", ""));
                                                    setState(() {
                                                      showHashtags = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      tags.searchTags = [];
                                                      showHashtags = false;
                                                    });
                                                  }
                                                  List<String> words =
                                                      val.split(" ");
                                                  if (words[words.length - 1]
                                                      .startsWith("@")) {
                                                    getUserTags(
                                                        words[words.length - 1]
                                                            .replaceAll(
                                                                "@", ""));
                                                    setState(() {
                                                      showUsersList = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      tagList.userTags = [];
                                                      showUsersList = false;
                                                    });
                                                  }
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
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
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
                                          ),
                                        )
                                      : Container(),
                                  tagList != null &&
                                          tagList.userTags.length > 0 &&
                                          _controller.text.isNotEmpty
                                      ? Positioned.fill(
                                          bottom: (CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight! +
                                                  1.0.h) -
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
                                          bottom: (CurrentUser()
                                                      .currentUser
                                                      .keyBoardHeight! +
                                                  1.0.h) -
                                              7.0.h,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 3.5.h,
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
                                                      .keyBoardHeight! +
                                                  1.0.h) -
                                              7.0.h,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 3.5.h,
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
                                      : Container()
                                ],
                              );
                            }),
                      ),
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        showMaterialModalBottomSheet(
                            backgroundColor: Colors.black38,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight: const Radius.circular(20.0))),
                            //isScrollControlled:true,
                            context: context,
                            builder: (context) {
                              return _stickers();
                            });
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
                          });
                        },
                      )
                    : Container(),
                Positioned.fill(
                  bottom: 7.0.h,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      color: allFiles.length > 1
                          ? Colors.black.withOpacity(0.7)
                          : Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                                            navigate: () {
                                              pageController.animateToPage(
                                                  index,
                                                  duration:
                                                      Duration(milliseconds: 2),
                                                  curve: Curves.easeIn);
                                              setState(() {
                                                currentIndex = index;
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
                                    height: 0,
                                    width: 0,
                                  ),
                            SizedBox(
                              width: 5.0.w,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  List<String> tags = [];
                                  List<String> stickers = [];
                                  for (int i = 0; i < tagsList.length; i++) {
                                    for (int j = 0;
                                        j < tagsList[i].length;
                                        j++) {
                                      tags.add("video_" +
                                          (i + 1).toString() +
                                          "^^" +
                                          tagsList[i][j].posx.toString() +
                                          "^^" +
                                          tagsList[i][j].posy.toString() +
                                          "^^" +
                                          tagsList[i][j]
                                              .name!
                                              .replaceAll("#", "@@@") +
                                          "^^" +
                                          "${tagsList[i][j].color!.red.toString() + "," + tagsList[i][j].color!.green.toString() + "," + tagsList[i][j].color!.blue.toString()}" +
                                          "^^" +
                                          tagsList[i][j]
                                              .font!
                                              .fontFamily
                                              .toString() +
                                          "^^" +
                                          tagsList[i][j].scale.toString() +
                                          "^^" +
                                          tagsList[i][j].h.toString() +
                                          "^^" +
                                          tagsList[i][j].w.toString());
                                    }
                                  }
                                  for (int i = 0; i < stickerList.length; i++) {
                                    for (int j = 0;
                                        j < stickerList[i].length;
                                        j++) {
                                      stickers.add("video_" +
                                          (i + 1).toString() +
                                          "^^" +
                                          stickerList[i][j].posx.toString() +
                                          "^^" +
                                          stickerList[i][j].posy.toString() +
                                          "^^" +
                                          stickerList[i][j]
                                              .name!
                                              .replaceAll("#", "@@@") +
                                          "^^" +
                                          stickerList[i][j].id! +
                                          "^^" +
                                          stickerList[i][j].scale.toString());
                                    }
                                  }

                                  print(stickers.join("~~~"));
                                  print(tags.join("~~~"));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UploadShortbuz(
                                                unit8list: unit8list,
                                                stickers: stickers.join("~~~"),
                                                tags: tags.join("~~~"),
                                                fromShortbuz: widget.from,
                                                refreshFromShortbuz:
                                                    widget.refreshFromShortbuz,
                                                video: widget.file,
                                              )));
                                  //uploadStory(tags.join("~~~"));
                                },
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
                                              "Next",
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
                                      showMaterialModalBottomSheet(
                                          backgroundColor: Colors.black38,
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
                                          builder: (context) {
                                            return _stickers();
                                          });
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
                                      "Aa",
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
                                        child: showFonts
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
                                          showMaterialModalBottomSheet(
                                              backgroundColor: Colors.black38,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                              .circular(20.0))),
                                              //isScrollControlled:true,
                                              context: context,
                                              builder: (context) {
                                                return _stickers();
                                              });
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
                        bottom: 20.0.h,
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
