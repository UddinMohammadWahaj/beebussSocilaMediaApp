import 'dart:io';
import 'dart:math';

import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/chat_video_player.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart' as ap;

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'controllers/chat_home_controller.dart';

class ExpandedFileChatSingle extends StatefulWidget {
  final String? token;
  final String? groupId;
  final String? image;
  final String? memberId;
  final String? name;
  final GalleryThumbnails? asset;
  final double? height;
  final double? width;
  final Function? sendFile;
  final File? file;
  final String? from;
  final String? type;

  const ExpandedFileChatSingle(
      {Key? key,
      this.groupId,
      this.token,
      this.memberId,
      this.image,
      this.name,
      this.asset,
      this.height,
      this.sendFile,
      this.width,
      this.file,
      this.from,
      this.type})
      : super(key: key);

  @override
  _ExpandedFileChatSingleState createState() => _ExpandedFileChatSingleState();
}

class _ExpandedFileChatSingleState extends State<ExpandedFileChatSingle> {
  late TextEditingController textFieldController;
  ChatHomeController chatHomeController = Get.put(ChatHomeController());
  late File assetFile;
  String _message = "";
  TextInputAction _textInputAction = TextInputAction.newline;
  bool keyboardVisible = false;
  late double h;
  var key = GlobalKey();
  Size size = Size(0, 0);
  late double w;
  ChatMessages _messages = new ChatMessages([]);
  ChatsRefresh refresh = ChatsRefresh();
  DetailedChatRefresh _detailedChatRefresh = DetailedChatRefresh();
  ap.AudioPlayer player = ap.AudioPlayer();

  void _playPop() {
    if (dir != null && dir != "") {
      player.play("$dir/pop.mpeg", isLocal: true);
    }
  }

  String dir = "";
  String type = "";

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

  void setFile() async {
    if (widget.from != "camera") {
      File? file = await widget.asset!.asset!.file!;
      setState(() {
        assetFile = file!;
      });
      if (widget.asset!.asset!.type.toString() != "AssetType.video") {
        setState(() {
          assetFile = file!;
        });
      }
    } else {
      setState(() {
        assetFile = widget.file!;
      });
    }
    thumbToImage();
  }

  void _compressFile(File file) async {
    print("compresss");
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(file.path);
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 80,
        targetWidth: 1080,
        targetHeight: (properties.height! * 1080 / properties.width!).round());

    setState(() {
      assetFile = compressedFile;
    });
  }

  void _compressVideo(File file) async {
    print("video compression");
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    setState(() {
      assetFile = mediaInfo as File;
    });
  }

  void setType() {
    if (widget.from != "camera") {
      setState(() {
        type = widget.asset!.asset!.type.toString();
      });
    } else {
      setState(() {
        type = widget.type!;
      });
    }
  }

  bool isGeneratingThumbnail = false;

  late File save;

  Future<void> thumbToImage() async {
    if (widget.from != "camera" && type == "AssetType.video") {
      File? file = await widget.asset!.asset!.file;
      setState(() {
        isGeneratingThumbnail = true;
      });
      print("break");
      var thumb = await widget.asset!.asset!.thumbnailData;
      img.Image? data = img.decodeImage(thumb!);
      setState(() {
        save = new File(
            "${chatHomeController.thumbsPath.value}/${basename(file!.path)?.replaceAll(".mp4", ".jpg")}")
          ..writeAsBytesSync(img.encodeJpg(data!, quality: 100));
      });
      setState(() {
        isGeneratingThumbnail = false;
      });
    }
    print("finished");
  }

  sendFile(String message, File file, type, thumb, File video) async {
    List<File> allFiles = [];
    allFiles.add(type == "image" ? file : video);
    print(message + "is message");

    setState(() {
      _messages.messages.insert(
          0,
          new ChatMessagesModel(
              message: message,
              messageType: type,
              dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              you: 1,
              checkStatus: 1,
              time: DateFormat('hh:mm a').format(DateTime.now()),
              file: file,
              path: type == "image" ? file.path : video.path,
              thumbPath: file.path));
      _messages.messages[0].isVideoUploading = true;
    });

    if (type == "video") {
      await video.copy(
          "/storage/emulated/0/Bebuzee/Bebuzee Videos/${p.basename(video.path)}");
      await file.copy(
          "/storage/emulated/0/Bebuzee/.thumbnails/${p.basename(file.path)}");
    }

    String folder = type == "video" ? "Bebuzee Videos" : "Bebuzee Images";
    String data = message +
        "^^^" +
        "" +
        "^^^" +
        "" +
        "^^^" +
        "" +
        "^^^" +
        "" +
        "^^^" +
        "" +
        "^^^" +
        type +
        "^^^" +
        "/storage/emulated/0/Bebuzee/$folder/${p.basename(type == "image" ? file.path : video.path)}" +
        "^^^" +
        "/storage/emulated/0/Bebuzee/.thumbnails/${p.basename(file.path)?.replaceAll(".mp4", ".jpg")}";
    print(data);
    String mess = "";
    if (type == "image") {
      mess = "📷 Image";
    } else {
      mess = "🎥 Video";
    }
    ChatApiCalls.uploadFiles("$data" + "^^^" + "${video.path}", widget.token!,
            widget.name!, allFiles, widget.memberId ?? widget.groupId!)
        .then((value) {
      ChatApiCalls.sendFcmRequest(
          widget.name!,
          mess,
          type,
          CurrentUser().currentUser.memberID!,
          DirectMessageUserListModel().token!,
          DirectMessageUserListModel().blocked!,
          DirectMessageUserListModel().mute!);
      _playPop();
      setState(() {
        _messages.messages.forEach((element) {
          setState(() {
            element.isVideoUploading = false;
            element.isSending = false;
          });
        });
      });
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
    });
  }

  @override
  void initState() {
    setType();
    setFile();
    saveImage();
    textFieldController = new TextEditingController()
      ..addListener(() {
        setState(() {
          _message = textFieldController.text;
        });
      });
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
      body: assetFile != null && !isGeneratingThumbnail
          ? Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: type == "AssetType.video"
                            ? Container(
                                width: 100.0.w,
                                child: ChatExpandedVideoPlayer(
                                  file: assetFile,
                                ),
                              )
                            : Container(
                                width: 100.0.w,
                                child: Image.file(
                                  assetFile,
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                ),
                Positioned.fill(
                  bottom: 35,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                            width: 100.0.w - 80,
                            child: TextField(
                              controller: textFieldController,
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
                                if (type == "AssetType.video" &&
                                    widget.from == "camera") {
                                  final unit8list =
                                      await VideoThumbnail.thumbnailData(
                                    video: assetFile.path,
                                    imageFormat: ImageFormat.JPEG,
                                    // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                                    quality: 100,
                                  );
                                  img.Image? src = img.decodeImage(unit8list!);
                                  setState(() {
                                    save = new File(
                                        "${chatHomeController.imagePath.value}/${basename(assetFile.path)?.replaceAll(".mp4", ".jpg")}")
                                      ..writeAsBytesSync(
                                          img.encodeJpg(src!, quality: 100));
                                  });
                                  sendFile(
                                      textFieldController.text,
                                      type == "AssetType.video"
                                          ? save
                                          : assetFile,
                                      type == "AssetType.video"
                                          ? "video"
                                          : "image",
                                      basename(assetFile.path)
                                          ?.replaceAll(".mp4", ".jpg"),
                                      assetFile);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else if (widget.from != "camera" &&
                                    type == "AssetType.video") {
                                  sendFile(
                                      textFieldController.text,
                                      type == "AssetType.video"
                                          ? save
                                          : assetFile,
                                      type == "AssetType.video"
                                          ? "video"
                                          : "image",
                                      basename(assetFile.path)
                                          ?.replaceAll(".mp4", ".jpg"),
                                      assetFile);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  sendFile(
                                      textFieldController.text,
                                      type == "AssetType.video"
                                          ? save
                                          : assetFile,
                                      type == "AssetType.video"
                                          ? "video"
                                          : "image",
                                      basename(assetFile.path)
                                          ?.replaceAll(".mp4", ".jpg"),
                                      assetFile);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
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
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
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
                                  widget.name ?? "",
                                  style: whiteBold.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
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
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              )),
            ),
    );
  }
}
