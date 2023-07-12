import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:bizbultest/utilities/Chat/chat_video_player.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

import 'controllers/chat_home_controller.dart';

class MultipleChatClass {
  String? message;
  String? replyID = "";
  String? messageReply = "";
  String? imageReply = "";
  String? fileNameReply = "";
  String? type;
  String? path;
  String? thumbPath;
  File? save;

  MultipleChatClass(message, type, path, thumbPath, save) {
    this.message = message;
    this.type = type;
    this.path = path;
    this.thumbPath = thumbPath;
    this.save = save;
  }
}

class ExpandedFilesChatMultiple extends StatefulWidget {
  final String? image;
  final String? name;
  final GalleryThumbnails? asset;
  final List<GalleryThumbnails>? assets;
  final double? height;
  final double? width;
  final Function? sendFile;

  const ExpandedFilesChatMultiple(
      {Key? key,
      this.image,
      this.name,
      this.asset,
      this.height,
      this.width,
      this.sendFile,
      this.assets})
      : super(key: key);

  @override
  _ExpandedFilesChatMultipleState createState() =>
      _ExpandedFilesChatMultipleState();
}

class _ExpandedFilesChatMultipleState extends State<ExpandedFilesChatMultiple> {
  List<TextEditingController> _controller = [];
  late File assetFile;
  String _message = "";
  TextInputAction _textInputAction = TextInputAction.newline;
  bool keyboardVisible = false;
  late double h;
  var key = GlobalKey();
  Size size = Size(0, 0);
  late double w;
  List<List<MultipleChatClass>> chatsList = [];
  String dir = "";
  int selectedIndex = 0;
  List<String> messages = [];
  List<File> allFiles = [];
  List<File> thumbs = [];
  String empty = "";
  ChatHomeController chatHomeController = Get.put(ChatHomeController());

  List<String> allData = [];

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future saveImage() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/MyImages';
    setState(() {
      dir = myImagePath;
    });
    final myImgDir = await new Directory(myImagePath).create();
    // thumbToImage();
  }

  void _compressFile(File file) async {
    print(file.path);

    if (file.path.toString().contains("_compressed")) {
      print("contains");
      setState(() {
        allFiles.add(file);
      });
    } else {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(file.path);
      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 60, percentage: 70);
      setState(() {
        allFiles.add(compressedFile);
      });
    }
  }

  Future<bool> setFiles() async {
    for (int i = 0; i < widget.assets!.length; i++) {
      _controller.add(new TextEditingController());
      File? file = await widget.assets![i].asset!.file!;
      if (widget.assets![i].asset!.type.toString() != "AssetType.video") {
        setState(() {
          allFiles.add(file!);
        });
      } else {
        print("video");
        setState(() {
          allFiles.add(file!);
        });
      }
    }
    return true;
  }

  bool areAssetsLoaded = false;
  late File save;

  PageController _pageController = PageController();

  Future<void> thumbToImage() async {
    var thumb = await widget.asset!.asset!
        .thumbnailDataWithSize(ThumbnailSize(1000, 1000), quality: 100);
    img.Image data = img.decodeImage(thumb!)!;
    setState(() {
      save = new File(
          "$dir/${basename(assetFile.path)?.replaceAll(".mp4", ".jpg")}")
        ..writeAsBytesSync(img.encodeJpg(data, quality: 100));
    });
  }

  @override
  void initState() {
    setFiles().then((value) {
      setState(() {
        areAssetsLoaded = true;
      });
      return value;
    });

    saveImage();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          keyboardVisible = visible;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      body: areAssetsLoaded
          ? Stack(
              children: [
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (ind) {
                              setState(() {
                                selectedIndex = ind;
                              });
                            },
                            itemCount: widget.assets!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  child: widget.assets![index].asset!.type
                                              .toString() ==
                                          "AssetType.video"
                                      ? Container(
                                          width: 100.0.w,
                                          child: ChatExpandedVideoPlayer(
                                            file: allFiles[index],
                                          ),
                                        )
                                      : Container(
                                          width: 100.0.w,
                                          child: Image.file(
                                            allFiles[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ));
                            }),
                      )),
                ),
                Positioned.fill(
                  bottom: keyboardVisible ? 0 : 75,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              shape: BoxShape.rectangle,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: 100.0.w - 70,
                            child: TextField(
                              controller: _controller[selectedIndex],
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: _textInputAction,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(0.0),
                                hintText: 'Add a caption...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 18.0,
                                ),
                                counterText: '',
                              ),
                              onSubmitted: (String text) {
                                if (_textInputAction == TextInputAction.send) {}
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: FloatingActionButton(
                              elevation: 2.0,
                              backgroundColor: secondaryColor,
                              foregroundColor: Colors.white,
                              child: Center(
                                  child: gradientContainerForButton(Icon(
                                Icons.send,
                                size: 20,
                              ))),
                              onPressed: () async {
                                String type = "";
                                for (int i = 0;
                                    i < widget.assets!.length;
                                    i++) {
                                  setState(() {
                                    messages.add(_controller[i].text);
                                  });
                                  var file = allFiles[i];
                                  String finalPath = "";
                                  if (widget.assets![i].asset!.type
                                          .toString() ==
                                      "AssetType.video") {
                                    finalPath =
                                        "${chatHomeController.videoPath.value}/${p.basename(file.path)}";
                                  } else {
                                    finalPath =
                                        "${chatHomeController.imagePath.value}/${p.basename(file.path)}";
                                    print("saved image");
                                  }
                                  String folder = widget.assets![i].asset!.type
                                              .toString() ==
                                          "AssetType.video"
                                      ? "Bebuzee Videos"
                                      : "Bebuzee Images";
                                  type = widget.assets![i].asset!.type
                                              .toString() ==
                                          "AssetType.video"
                                      ? "video"
                                      : "image";

                                  String data = _controller[i].text +
                                      "^^^" +
                                      empty +
                                      "^^^" +
                                      empty +
                                      "^^^" +
                                      empty +
                                      "^^^" +
                                      empty +
                                      "^^^" +
                                      empty +
                                      "^^^" +
                                      type +
                                      "^^^" +
                                      finalPath +
                                      "^^^" +
                                      "${chatHomeController.thumbsPath.value}/${basename(file.path)!.replaceAll(".mp4", ".jpg")}";

                                  print(data);
                                  setState(() {
                                    allData.add(data);
                                  });
                                  if (widget.assets![i].asset!.type
                                          .toString() ==
                                      "AssetType.video") {
                                    var thumb = await widget
                                        .assets![i].asset!.thumbnailData!;
                                    img.Image data = img.decodeImage(thumb!)!;
                                    File f = await File(
                                            "${chatHomeController.thumbsPath.value}/${basename(allFiles[i].path)?.replaceAll(".mp4", ".jpg").replaceAll(".3gp", ".jpg")}")
                                        .create(recursive: true)
                                      ..writeAsBytesSync(
                                          img.encodeJpg(data, quality: 100));
                                    setState(() {
                                      thumbs.add(f);
                                    });
                                  } else {
                                    setState(() {
                                      thumbs.add(file);
                                    });
                                  }
                                }
                                widget.sendFile!(thumbs, allFiles,
                                    allData.join("\$\$\$"), messages, type);
                                //ChatApiCalls.sendFcmRequest("Notification", "", type, widget.memberID, widget.token);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                !keyboardVisible
                    ? Positioned.fill(
                        bottom: 55,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.name!,
                                  style: whiteBold.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                !keyboardVisible
                    ? Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.assets!.length,
                                itemBuilder: (context, index) {
                                  return ThumbnailsCard(
                                    asset: widget.assets![index],
                                    grid: false,
                                    index: index,
                                    selectedIndex: selectedIndex,
                                    onTap: () {
                                      _pageController.animateToPage(index,
                                          duration:
                                              new Duration(milliseconds: 50),
                                          curve: Curves.easeInOut);
                                    },
                                  );
                                }),
                          ),
                        ),
                      )
                    : Container(),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                            color: Colors.white,
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                CachedNetworkImageProvider(widget.image!),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              child: Center(child: customCircularIndicator(3, darkColor)),
            ),
    );
  }
}

class ThumbnailsCard extends StatefulWidget {
  final String? extension;
  final Function? setNavbar;
  final VoidCallback? onTap;
  final bool? isMultiOpen;
  final bool? grid;
  final int? index;
  final int? selectedIndex;

  const ThumbnailsCard({
    Key? key,
    required this.asset,
    this.setNavbar,
    this.extension,
    this.onTap,
    this.isMultiOpen,
    this.grid,
    this.index,
    this.selectedIndex,
  }) : super(key: key);

  final GalleryThumbnails asset;

  @override
  _ThumbnailsCardState createState() => _ThumbnailsCardState();
}

class _ThumbnailsCardState extends State<ThumbnailsCard> {
  late Future future;

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
          return Padding(
            padding: EdgeInsets.only(right: 0),
            child: Container(
                height: 50,
                width: 50,
                color: Colors.black,
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey)))),
          );
        // If there's data, display it as an image
        return InkWell(
          onTap: widget.onTap ?? () {},
          child: Padding(
            padding: EdgeInsets.only(right: 0),
            child: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(
                  color: Colors.white,
                  width: widget.selectedIndex == widget.index ? 2.5 : 0,
                ),
              ),
              height: 50,
              width: 50,
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
