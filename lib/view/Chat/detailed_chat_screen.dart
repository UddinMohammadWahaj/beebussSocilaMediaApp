import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/basic/join_channel_audio.dart';
import 'package:bizbultest/basic/join_channel_video.dart';
import 'package:bizbultest/basic/newVcScreen.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/permission/permissions.dart';
import 'package:bizbultest/playground/PlayVideoCallScreen.dart';
import 'package:bizbultest/playground/playvcscreen.dart';
import 'package:bizbultest/playground/src/pages/callpage.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/push/notification_utils.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/attachments_card.dart';
import 'package:bizbultest/utilities/Chat/chat_galley_thumbnails.dart';
import 'package:bizbultest/utilities/Chat/clear_chat_popup.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/delete_message_popup.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/Chat/mute_notifications_popup_chat.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Chat/location_sharing.dart';
import 'package:bizbultest/view/Chat/select_contacts_to_send.dart';
import 'package:bizbultest/view/Chat/view_contact.dart';
import 'package:bizbultest/view/Chat/view_contact_single_expanded.dart';
import 'package:bizbultest/view/Chat/view_single_file.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:bizbultest/widgets/Chat/link_preview.dart';
import 'package:bizbultest/widgets/Chat/message_card.dart';
import 'package:bizbultest/widgets/Chat/reply_card.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_to/swipe_to.dart';

import 'all_media_page_chat.dart';
import 'audio_library.dart';
import 'controllers/chat_home_controller.dart';
import 'expanded_file_single.dart';
import 'expanded_files_multiple.dart';
import 'forward_message_chat.dart';
import 'message_info_page.dart';

enum ChatDetailMenuOptions {
  viewContact,
  media,
  search,
  muteNotifications,
  wallpaper,
  more,
}

enum ChatDetailMoreMenuOptions {
  report,
  block,
  clearChat,
  exportChat,
  addShortcut,
}

class DetailedChatScreen extends StatefulWidget {
  final String? memberID;
  final String? image;
  final String? name;
  final String? token;
  final bool? onlineStatus;
  final int? mute;
  final int? blocked;
  bool? fromChat;
  final DirectMessageUserListModel? user;

  DetailedChatScreen(
      {Key? key,
      this.fromChat,
      this.memberID,
      this.image,
      this.name,
      this.token,
      this.onlineStatus,
      this.mute,
      this.blocked,
      this.user})
      : super(key: key);

  @override
  _DetailedChatScreenState createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  AutoScrollController controller = AutoScrollController();
  ap.AudioPlayer player = ap.AudioPlayer();
  AudioCache audioCache = new AudioCache();
  List<String> messageID = [];
  bool isMultiSelect = false;
  List<GalleryThumbnails> multiSelectList = [];
  late String fileLocation;
  late String fileName;
  late int h;
  late int w;
  var fileSize;
  String dir = "";
  int selectedIndex = 0;
  bool more = false;
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  HomepageRefreshState homeRefresh = new HomepageRefreshState();
  int mute = 0;
  int blocked = 0;
  int replyIndex = 0;
  Size size = Size(0, 0);
  var keyText = GlobalKey();
  double ht = 0;
  late GiphyGif currentGif;
  late String id;
  ChatHomeController chatHomeController = Get.put(ChatHomeController());

  bool keep = true;

  void _playPop() {
    if (dir != null && dir != "") {
      player.play("$dir/pop.mpeg", isLocal: true);
    }
  }

  Future createTempDir() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/temp';
    setState(() {
      dir = myImagePath;
    });
    final myImgDir = await new Directory(myImagePath).create();
    _downloadPopSound(myImagePath);
    // thumbToImage();
  }

  void _downloadPopSound(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? popData = prefs.getString("pop");
    if (popData == null) {
      await Dio()
          .download(
              "http://bebuzee.com/new_files/chat_sound/sound_notification.mpeg",
              path + "/pop.mpeg")
          .then((value) {
        print(value.statusMessage);
        prefs.setString("pop", value.statusMessage.toString());
        print("download success");
      });

      await ImageGallerySaver.saveFile(path).then((path) => {
            print(path),
          });
    } else {
      print("pop exists");
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

  DetailedChatRefresh _detailedChatRefresh = DetailedChatRefresh();

  void _gif() async {
    GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      //Required
      apiKey: "zONCyRNgg6IGXkmoHG7Yy1RxRgvTtPx5",
      //Required.
      lang: GiphyLanguage.english,
      //Optional - Language for query.
      randomID: "abcd",
      // Optional - An ID/proxy for a specific user.
      searchText: "Search GIPHY",
      //Optional - AppBar search hint text.
      tabColor: Colors.teal, // Optional- default accent color.
    );
    if (gif != null && mounted) {
      setState(() {
        attachmentsOpened = false;
        _messages.messages.insert(
            0,
            new ChatMessagesModel(
              imageData: gif.images!.original!.webp,
              playPop: true,
              messageType: "gif_url",
              dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              you: 1,
              checkStatus: 1,
              time: DateFormat('hh:mm a').format(DateTime.now()),
            ));
      });
      await ChatApiCalls.sendGif(
          widget.memberID!,
          gif.images!.original!.webp.toString(),
          widget.token!,
          blocked,
          widget.name!,
          mute);
    }
  }

  late Timer _timer;
  int _recordDuration = 0;
  bool isRecording = false;
  String voiceDuration = "";

  void _startTimer() {
    const tick = const Duration(seconds: 1);

    _timer?.cancel();

    _timer = Timer.periodic(tick, (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  void _endTimer() {
    _timer.cancel();

    setState(() {
      _recordDuration = 0;
    });
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  String _setDuration() {
    String durationText = "";
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);
    durationText = '$minutes:$seconds';
    return durationText;
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes:$seconds',
      style: TextStyle(color: Colors.black, fontSize: 18),
    );
  }

  void _viewContact() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewContactSingle(
                  token: widget.token,
                  messages: _mediaMessages.messages,
                  blocked: blocked,
                  memberID: widget.memberID,
                  name: widget.name,
                  image: widget.image,
                )));
  }

  double height = 12;
  List<File> thumbs = [];
  List<File> allFiles = [];
  List<File> documents = [];
  List<File> audioFiles = [];
  List<String> audioPaths = [];

  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  final popupButtonKey = GlobalKey<State>();
  final GlobalKey _menuKey = new GlobalKey();

  _onSelectMenuOption(ChatDetailMenuOptions option) {
    switch (option) {
      case ChatDetailMenuOptions.viewContact:
        _viewContact();
        break;
      case ChatDetailMenuOptions.media:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllMediaPageChat(
                      title: widget.name,
                      uniqueID: widget.memberID,
                      token: widget.token,
                      from: "chat",
                    )));
        break;
      case ChatDetailMenuOptions.search:
        break;
      case ChatDetailMenuOptions.muteNotifications:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MuteNotificationPopupChat(memberID: widget.memberID!);
            });
        break;
      case ChatDetailMenuOptions.wallpaper:
        break;
      case ChatDetailMenuOptions.more:
        setState(() {
          more = true;
        });

        Timer(Duration(seconds: 1), () {
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        });

        break;
    }
  }

  _onSelectMoreMenuOption(ChatDetailMoreMenuOptions option) {
    switch (option) {
      case ChatDetailMoreMenuOptions.report:
        break;
      case ChatDetailMoreMenuOptions.block:
        if (blocked == 0) {
          showDialog(
              useRootNavigator: false,
              context: context,
              builder: (BuildContext context) {
                return BlockPopup(
                    action: 1,
                    onTapOk: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            ChatApiCalls()
                                .blockUser(widget.memberID!)
                                .then((value) {
                              if (mounted) {
                                setState(() {
                                  blocked = 1;
                                });
                              }
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                            return ProcessingDialog(
                              title: "Please wait a moment",
                              heading: "",
                            );
                          });
                    },
                    title:
                        "Block ${widget.name}? Blocked contacts will no longer be able to call you or send you messages.");
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                ChatApiCalls().unblockUser(widget.memberID!).then((value) {
                  setState(() {
                    blocked = 0;
                  });
                  Navigator.of(context, rootNavigator: true).pop();
                });
                return ProcessingDialog(
                  title: "Please wait a moment",
                  heading: "",
                );
              });
        }
        break;
      case ChatDetailMoreMenuOptions.clearChat:
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) {
              return ClearChatPopup(memberID: widget.memberID!);
            });
        break;
      case ChatDetailMoreMenuOptions.exportChat:
        break;
      case ChatDetailMoreMenuOptions.addShortcut:
        break;
    }
  }

  _buildGalleryAppbar(StateSetter state) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  clearMultiSelectList(state);
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
                      "Tap photo to select " +
                          multiSelectList.length.toString(),
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
                        state(() {
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExpandedFilesChatMultiple(
                                      sendFile: (List<File> thums,
                                          List<File> files,
                                          String allData,
                                          List<String> messages,
                                          String type) async {
                                        print(allData);
                                        setState(() {
                                          allFiles = files;
                                          thumbs = thums;
                                        });
                                        for (int i = 0;
                                            i < multiSelectList.length;
                                            i++) {
                                          setState(() {
                                            _messages.messages.insert(
                                                0,
                                                new ChatMessagesModel(
                                                    playPop: true,
                                                    message: messages[i],
                                                    messageType: multiSelectList[
                                                                    i]
                                                                .asset!
                                                                .type
                                                                .toString() ==
                                                            "AssetType.video"
                                                        ? "video"
                                                        : "image",
                                                    dateData: DateFormat(
                                                            'dd/MM/yyyy')
                                                        .format(DateTime.now()),
                                                    you: 1,
                                                    checkStatus: 1,
                                                    isSending: true,
                                                    isVideoUploading: true,
                                                    time: DateFormat('hh:mm a')
                                                        .format(DateTime.now()),
                                                    file: allFiles[i],
                                                    path: allFiles[i].path,
                                                    thumbPath: thumbs[i].path));
                                          });
                                        }
                                        for (int i = 0;
                                            i < multiSelectList.length;
                                            i++) {
                                          File file = allFiles[i];
                                          if (multiSelectList[i]
                                                  .asset!
                                                  .type
                                                  .toString() ==
                                              "AssetType.video") {
                                            await file.copy(
                                                "${chatHomeController.videoPath.value}/${p.basename(file.path)}");
                                            // await thumbs[i].copy("${chatHomeController.imagePath.value}/${p.basename(thumbs[i].path)}");
                                          } else {
                                            print(file.path);
                                            await file.copy(
                                                "${chatHomeController.imagePath.value}/${p.basename(file.path)}");
                                          }
                                        }
                                        String message = "";
                                        if (multiSelectList[0]
                                                .asset!
                                                .type
                                                .toString() !=
                                            "AssetType.video") {
                                          message = "📷 Image";
                                        } else {
                                          message = "🎥 Video";
                                        }
                                        ChatApiCalls.uploadFiles(
                                                allData,
                                                widget.token!,
                                                widget.name!,
                                                files,
                                                widget.memberID!)
                                            .then((value) {
                                          print("uploading multiple files");
                                          ChatApiCalls.sendFcmRequest(
                                              widget.name!,
                                              message,
                                              type,
                                              widget.memberID!,
                                              widget.token!,
                                              blocked,
                                              mute);
                                          _playPop();
                                          setState(() {
                                            _messages.messages
                                                .forEach((element) {
                                              setState(() {
                                                element.isVideoUploading =
                                                    false;
                                                element.isSending = false;
                                              });
                                            });
                                          });
                                          refresh.updateRefresh(true);
                                          _detailedChatRefresh
                                              .updateRefresh(true);
                                        });
                                      },
                                      name: widget.name,
                                      assets: multiSelectList,
                                      image: widget.image,
                                    )));
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
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return Scaffold(
        appBar: _buildGalleryAppbar(state),
        body: WillPopScope(
          onWillPop: () async {
            if (isMultiSelect) {
              state(() {
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
                  onTap: () async {
                    if (isMultiSelect) {
                      state(() {
                        assets[index].selected = !assets[index].selected;
                      });
                      if (assets[index].selected) {
                        setState(() {
                          multiSelectList.add(assets[index]);
                        });
                      } else {
                        setState(() {
                          multiSelectList.removeWhere(
                              (element) => element == assets[index]);
                        });
                      }
                      print(multiSelectList.length);
                    } else {
                      print("single file");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExpandedFileChatSingle(
                                    token: widget.token,
                                    memberId: widget.memberID,
                                    sendFile: (String message, File file,
                                        String type, thumb, File video) async {
                                      List<File> allFiles = [];
                                      allFiles
                                          .add(type == "image" ? file : video);
                                      print(
                                          file.path.toString() + " file path");
                                      setState(() {
                                        _messages.messages.insert(
                                            0,
                                            new ChatMessagesModel(
                                              path: type == "image"
                                                  ? file.path
                                                  : video.path,
                                              thumbPath: file.path,
                                              isVideoUploading: true,
                                              isSending: true,
                                              message: message,
                                              messageType: type,
                                              dateData: DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now()),
                                              you: 1,
                                              checkStatus: 1,
                                              time: DateFormat('hh:mm a')
                                                  .format(DateTime.now()),
                                              file: file,
                                            ));
                                        _messages.messages[0].isVideoUploading =
                                            true;
                                      });
                                      String finalPath = "";
                                      if (type == "video") {
                                        finalPath =
                                            "${chatHomeController.videoPath.value}/${p.basename(video.path)}";
                                        await video.copy(finalPath);
                                        // await file.copy("${chatHomeController.thumbsPath.value}/${p.basename(file.path)}");
                                      } else {
                                        finalPath =
                                            "${chatHomeController.imagePath.value}/${p.basename(file.path)}";
                                        await file.copy(finalPath);
                                        print("saved image");
                                      }
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
                                          finalPath +
                                          "^^^" +
                                          "${chatHomeController.imagePath.value}/${p.basename(file.path)?.replaceAll(".mp4", ".jpg")}";
                                      ChatApiCalls.uploadFiles(
                                              data,
                                              widget.token!,
                                              widget.name!,
                                              allFiles,
                                              widget.memberID!)
                                          .then((value) {
                                        String message = "";
                                        if (type == "image") {
                                          message = "📷 Image";
                                        } else {
                                          message = "🎥 Video";
                                        }
                                        ChatApiCalls.sendFcmRequest(
                                            widget.name!,
                                            message,
                                            type,
                                            widget.memberID!,
                                            widget.token!,
                                            blocked,
                                            mute);
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
                                        _detailedChatRefresh
                                            .updateRefresh(true);
                                      });
                                    },
                                    name: widget.name,
                                    asset: assets[index],
                                    image: widget.image,
                                    height: (assets[index].asset!.height)
                                        .toDouble(),
                                    width:
                                        (assets[index].asset!.width).toDouble(),
                                  )));
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

  void _openCamera() {
    setState(() {
      attachmentsOpened = false;
      id = widget.memberID!;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatCameraScreen(
                  memberId: id,
                  sendFile: (String message, File file, type, thumb,
                      File video) async {
                    List<File> allFiles = [];
                    allFiles.add(type == "image" ? file : video);
                    print(message + "is message");

                    setState(() {
                      _messages.messages.insert(
                          0,
                          new ChatMessagesModel(
                              message: message,
                              messageType: type,
                              dateData: DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now()),
                              you: 1,
                              checkStatus: 1,
                              time:
                                  DateFormat('hh:mm a').format(DateTime.now()),
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

                    String folder =
                        type == "video" ? "Bebuzee Videos" : "Bebuzee Images";
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
                    ChatApiCalls.uploadFiles(data, widget.token!, widget.name!,
                            allFiles, widget.memberID!)
                        .then((value) {
                      ChatApiCalls.sendFcmRequest(widget.name!, mess, type,
                          widget.memberID!, widget.token!, blocked, mute);
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
                  },
                  name: widget.name!,
                  image: widget.image,
                )));
  }

  late Future<ChatMessages> _chatMessages;
  ChatMessages _messages = new ChatMessages([]);
  ChatMessages _mediaMessages = new ChatMessages([]);
  late TextEditingController textFieldController;
  String _message = "";
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  TextInputAction _textInputAction = TextInputAction.newline;
  bool messagesSelected = false;
  bool attachmentsOpened = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String voiceFile = "";
  bool contactsPermission = false;
  List<ChatMessagesModel> selectedMessages = [];
  List<bool> isyou = [];

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  void _askPermission() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      print("Granted");
      setState(() {
        contactsPermission = true;
      });
    } else {
      await Permission.contacts.request();
      print("not granteddd");
    }
    _getVoicePermission();
  }

  Widget emojiPicker() {
    EmojiPicker emjPicker = EmojiPicker(
      rows: 5,
      columns: 9,
      buttonMode: ButtonMode.MATERIAL,
      numRecommended: 50,
      onEmojiSelected: (emoji, category) {
        if (mounted) {
          print(category.toString());
          setState(() {
            textFieldController.text = textFieldController.text + emoji.emoji;
            textFieldController.selection = TextSelection.fromPosition(
                TextPosition(offset: textFieldController.text.length));
          });
        }
      },
    );
    return emjPicker;
  }

  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  void _sendMessage() async {
    if (_message == null || _message.isEmpty) return;
    String text = _message;
    _playPop();
    setState(() {
      _messages.messages.insert(
          0,
          new ChatMessagesModel(
            message: _message,
            dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            you: 1,
            checkStatus: 1,
            time: DateFormat('hh:mm a').format(DateTime.now()),
          ));
    });
    textFieldController.clear();
    await ChatApiCalls().sendTextMessage(
        widget.memberID!, text, widget.token!, blocked, widget.name!, mute);
  }

  void _replyMessage(String type, String imageURL, String originalMessage,
      String replyID, String filename, String videoTime, String name) async {
    if (_message == null || _message.isEmpty) return;
    _playPop();
    print(filename);
    print("fileeeeeeeeeeee");
    setState(() {
      messageID = [];
      selectedMessages = [];
      _messages.messages[replyIndex].isSelected = false;

      _messages.messages.insert(
          0,
          new ChatMessagesModel(
            messageType: "reply",
            username: "You",
            replyParameters: [
              new ReplyParameter(
                  type: type,
                  message: originalMessage,
                  thumb: imageURL,
                  name: name,
                  fileName: filename,
                  videoPlaytime: videoTime)
            ],
            message: _message,
            dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            you: 1,
            checkStatus: 1,
            time: DateFormat('hh:mm a').format(DateTime.now()),
          ));
      isReply = false;
    });
    ChatApiCalls().sendReplyMessage(widget.memberID!, _message, widget.token!,
        blocked, widget.name!, type, imageURL, originalMessage, replyID, mute);
    textFieldController.clear();
  }

  void _sendLink() {
    print("linkkk");
    List<String> url = [];
    url.add(title);
    url.add(description);
    url.add(image);
    url.add(domain);
    url.add(textFieldController.text);
    setState(() {
      _messages.messages.insert(
          0,
          new ChatMessagesModel(
            messageType: "link",
            message: url.join("~~~"),
            dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            you: 1,
            checkStatus: 1,
            time: DateFormat('hh:mm a').format(DateTime.now()),
          ));
    });
    textFieldController.text = '';
    setState(() {
      showLinkPreview = false;
    });
    ChatApiCalls()
        .sendLink(widget.memberID!, widget.token!, blocked, title, description,
            url[4], image, domain, widget.name!, mute)
        .then((value) {
      setState(() {
        domain = "";
        description = "";
        title = "";
        image = "";
      });
    });
    _playPop();
  }

  void _onLoading() async {
    ChatMessages? messagesData = await ChatApiCalls.onLoading(
        _messages!, context!, _refreshController!, widget.memberID!);
    if (messagesData != null) {
      setState(() {
        _messages.messages.addAll(messagesData.messages);
      });
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890eiamdakk33r33433kkfkppvj58298';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<String> _reloadChats() async {
    _chatMessages =
        ChatApiCalls.getAllChats(widget.memberID!, "").then((value) {
      setState(() {
        _messages.messages = value.messages.reversed.toList();
      });
      _getMediaFiles();
      _getDate();
      _selectAutomatically();

      return value;
    });

    return "success";
  }

  void _getVoicePermission() async {
    bool result = await Record().hasPermission();
  }

  void _getDate() {
    print(_messages.messages.length);

    for (int i = 0; i < _messages.messages.length; i++) {
      if (_messages.messages[i].dateCard != "") {
        setState(() {
          _messages.messages.insert(
              i + 1,
              new ChatMessagesModel(
                message: _messages.messages[i].dateCard,
                isSending: false,
                dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                sentNow: 1,
                checkStatus: 1,
                you: 2,
                time: DateFormat('hh:mm a').format(DateTime.now()),
                messageType: "date_card",
              ));
        });

        i++;
      }
    }
  }

  Future<String> _getChats() async {
    _chatMessages =
        ChatApiCalls.getAllChats(widget.memberID!, "").then((value) {
      setState(() {
        _messages.messages = value.messages.reversed.toList();
      });
      _getMediaFiles();
      _getDate();
      _selectAutomatically();
      refresh.updateRefresh(true);

      return value;
    });
    return "success";
  }

  void _unblock() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UnblockPopup(
            title: "Unblock ${widget.name} to send a message.",
            onTapOk: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    ChatApiCalls().unblockUser(widget.memberID!).then((value) {
                      setState(() {
                        blocked = 0;
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                    return ProcessingDialog(
                      title: "Please wait a moment",
                      heading: "",
                    );
                  });
            },
          );
        });
  }

  bool showLinkPreview = false;
  bool isReply = false;
  String domain = "";
  String description = "";
  String title = "";
  String image = "";

  @override
  void initState() {
    print(widget.mute.toString() + " mute status");
    // calculateHeight();
    mute = widget.mute!;
    blocked = widget.blocked!;
    getUserData();
    getLocalChats();
    print(widget.memberID);
    _getChats();
    // _fcmListener();
    _askPermission();

    textFieldController = new TextEditingController()
      ..addListener(() {
        setState(() {
          _message = textFieldController.text;
        });
        if (textFieldController.text.length == 1) {
          DirectApiCalls.fcmOnlineStatus("Typing...");
        }
        if (textFieldController.text.length == 0) {
          if (mounted) {
            setState(() {
              showLinkPreview = false;
            });
          }
          DirectApiCalls.fcmOnlineStatus("Online");
        }
        if (textFieldController.text.contains("https")) {
          print("contains");

          ChatApiCalls().getLinkPreview(textFieldController.text).then((value) {
            print(textFieldController.text);
            // calculateHeight();
            if (mounted) {
              setState(() {
                showLinkPreview = true;
                title = value![0];
                image = value![2];
                description = value![1];
                domain = value[3];
              });
            }

            print(title);
            print(image);
            print(description);
            print(domain);
          });
        }
      });
    _fetchAssets();
    createTempDir();
    // _loopTest();
    super.initState();

    // ignore: deprecated_member_use
    KeyboardVisibilityController().onChange.listen((bool isKeyboardVisible) {
      if (mounted) {
        setState(() {
          this.isKeyboardVisible = isKeyboardVisible;
        });
      }
      if (isKeyboardVisible && isEmojiVisible) {
        if (mounted) {
          setState(() {
            isEmojiVisible = false;
          });
        }
      }
    });
  }

  UserDetailModel objUserDetailModel = new UserDetailModel();

  String imageName = "";

  getUserData() async {
    String uid = CurrentUser().currentUser.memberID!;
    objUserDetailModel = await ApiProvider().getUserDetail(uid);
    if (objUserDetailModel != null &&
        objUserDetailModel.memberId != null &&
        objUserDetailModel.memberId != "") {
      print("Get User Data");
      if (objUserDetailModel.chatsend == "1") {
        _textInputAction = TextInputAction.send;
      } else {}
    }

    imageName = (await MySharedPreferences().getBGImage())!;

    setState(() {});
  }

  ChatsRefresh refresh = ChatsRefresh();
  List<GalleryThumbnails> assets = [];
  bool areAssetsLoaded = false;

  void _startRecording() async {
    bool result = await Record().hasPermission();

    print(result.toString() + " has permission");
    String filename = "voice_${generateRandomString(8)}.m4a";

// Start recording
    await Record()
        .start(
      path: '${chatHomeController.voicePath.value}/$filename', // required
      encoder: AudioEncoder.aacEld, // by default
      bitRate: 128000, // by default
      // by default
    )
        .then((value) {
      setState(() {
        isRecording = true;
        voiceFile = filename;
      });
      _startTimer();
      print("Success");
    });
  }

  Future<void> _sendVoiceRecording() async {
    String voicePath = "${chatHomeController.voicePath.value}/$voiceFile";
    await Record().stop().then((value) {
      setState(() {
        voiceDuration = _setDuration();
        isRecording = false;
      });
      _endTimer();
      List<String> paths = [];
      paths.add(voicePath);
      setState(() {
        height = 12;
        _messages.messages.insert(
            0,
            new ChatMessagesModel(
              message: "",
              isSending: true,
              dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              you: 1,
              audioDuration: voiceDuration,
              sentNow: 1,
              checkStatus: 1,
              time: DateFormat('hh:mm a').format(DateTime.now()),
              messageType: "voice",
              path: voicePath,
              fileNameUploaded: voiceFile,
            ));
      });
      ChatApiCalls()
          .uploadVoiceRecording(widget.token!, widget.name!, voicePath,
              widget.memberID!, voicePath, voiceDuration)
          .then((val) {
        ChatApiCalls.sendFcmRequest(widget.name!, "🎙 Voice", "voice",
            widget.memberID!, widget.token!, blocked, mute);
        _playPop();
        setState(() {
          _messages.messages.forEach((element) {
            setState(() {
              element.isSending = false;
            });
          });
        });
        refresh.updateRefresh(true);
        _detailedChatRefresh.updateRefresh(true);
      });
    });
  }

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
      if ((element.type.toString() == "AssetType.video" ||
              element.type.toString() == "AssetType.image") &&
          element.videoDuration.inMinutes < 20) {
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

  void pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        documents = files;
      });

      print(documents[0]);
      List<String> allData = [];
      var document;
      File savedFile;
      File? thumb;
      for (int i = 0; i < documents.length; i++) {
        savedFile = await documents[i].copy(
            "${chatHomeController.docPath.value}/${p.basename(documents[i].path)}");
        if (p.extension(documents[i].path).replaceAll(".", "") == "pdf") {
          document = await PdfDocument.openFile(savedFile.path);
          final page = await document.getPage(1);
          final pageImage = await page.render(
            width: page.width,
            height: page.height,
            // format: PdfPageFormat.JPEG,
          );
          // var image = await pageImage.createImageDetached();
          img.Image? src = img.decodeImage(pageImage.bytes);
          print(pageImage.bytes);
          thumb = new File(
              "${chatHomeController.thumbsPath.value}/${generateRandomString(10)}.jpg")
            ..writeAsBytesSync(img.encodeJpg(src!, quality: 100));
          // Page
        }

        String? thumbPath =
            p.extension(documents[i].path).replaceAll(".", "") == "pdf"
                ? thumb!.path
                : "";

        String data = "" +
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
            "file" +
            "^^^" +
            savedFile.path +
            "^^^" +
            thumbPath;

        allData.add(data);

        setState(() {
          _messages.messages.insert(
              0,
              new ChatMessagesModel(
                  message: "",
                  sentNow: 1,
                  dateData: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  you: 1,
                  checkStatus: 1,
                  time: DateFormat('hh:mm a').format(DateTime.now()),
                  messageType: "file",
                  path: savedFile.path,
                  fileNameUploaded: p.basename(documents[i].path),
                  isSending: true,
                  thumbPath: thumbPath,
                  fileTypeExtension:
                      p.extension(documents[i].path).replaceAll(".", ""),
                  pageCount:
                      p.extension(documents[i].path).replaceAll(".", "") ==
                              "pdf"
                          ? document.pagesCount
                          : 0));
        });
      }
      ChatApiCalls.uploadFiles(allData.join("\$\$\$"), widget.token!,
              widget.name!, files, widget.memberID!)
          .then((value) {
        ChatApiCalls.sendFcmRequest(widget.name!, "📄 File", "file",
            widget.memberID!, widget.token!, blocked, mute);
        _playPop();
        setState(() {
          _messages.messages.forEach((element) {
            setState(() {
              element.isSending = false;
            });
          });
        });
        refresh.updateRefresh(true);
        _detailedChatRefresh.updateRefresh(true);
      });
    } else {
      // User canceled the picker
    }
  }

  int countUnStared = 0;

  Future<void> _onTapMessage(int i) async {
    String? path = "";

    path = _messages.messages[i]!.receiverDevicePath == ""
        ? _messages.messages[i]!.fileNameUploaded
        : _messages.messages[i]!.receiverDevicePath!;

    if (_messages.messages[i].you == 1 && !_messages.messages[i].isSelected!) {
      isyou.add(true);
    } else if (!_messages.messages[i].isSelected!) {
      isyou.add(false);
    }

    if (_messages.messages[i].isSelected!) {
      if (_messages.messages[i].you == 1) {
        isyou.remove(true);
      } else {
        isyou.remove(false);
      }
    }

    setState(() {
      selectedIndex = i;
    });
    if (messageID.length > 0) {
      setState(() {
        _messages.messages[i].isSelected = !_messages.messages[i].isSelected!;
        if (_messages.messages[i].isSelected!) {
          print("addd");
          messageID.add(_messages.messages[i].messageId!);
          selectedMessages.add(_messages.messages[i]);
          if (_messages.messages[i].isStar == 0) {
            countUnStared++;
          }
        } else {
          print("removeee");
          messageID.removeWhere(
              (element) => element == _messages.messages[i].messageId);
          selectedMessages.removeWhere((element) =>
              element.messageId == _messages.messages[i].messageId);
          if (_messages.messages[i].isStar == 0) {
            countUnStared--;
          }
        }
      });
    } else if (_messages.messages[i].receiverDownload == 1 &&
        _messages.messages[i].you == 0 &&
        _messages.messages[i].messageType != "contact" &&
        _messages.messages[i].messageType != "location" &&
        _messages.messages[i].messageType != "link") {
      if (_messages.messages[i].messageType == "image") {
        String path =
            "${chatHomeController.imagePath.value}/${(_messages.messages[i].fileNameUploaded)}";
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        var res = await Dio().download(
            _messages.messages[i].imageData.replaceAll("resized/", ""), path,
            onReceiveProgress: (int sent, int total) {
          final progress = (sent / total) * 100;
          print('image download progress: $progress');
          setState(() {
            _messages.messages[i].downloadProgress = (sent / total);
          });
        }).then((value) {
          chatHomeController.refreshGallery(path);
        });

        if (mounted) {
          setState(() {
            _messages.messages[i].receiverDevicePath = path;
            _messages..messages[i].receiverDownload = 0;
          });
        }
        print(path + " new path");
        ChatApiCalls()
            .downloadFile(
                _messages.messages[i].messageId!, path, path, widget.memberID!)
            .then((value) {
          setState(() {
            _getMediaFiles();
            _messages.messages[i].isDownloading = false;
          });
        });
      } else if (_messages.messages[i].messageType == "video") {
        int vidLength =
            (_messages.messages[i].video).toString().split("/").length;
        int thumbLength = _messages.messages[i].url!
            .replaceAll(".mp4", ".jpg")
            .toString()
            .split("/")
            .length;
        String path =
            "${chatHomeController.videoPath.value}/${(_messages.messages[i].fileNameUploaded)}";
        String thumb =
            "${chatHomeController.imagePath.value}/${_messages.messages[i].fileNameUploaded?.replaceAll(".mp4", ".jpg")}";
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        // await Dio().download(_messages.messages[i].videoImage, thumb);
        await Dio().download(
          _messages.messages[i].video!,
          path,
          onReceiveProgress: (int sent, int total) {
            final progress = (sent / total) * 100;
            print('video download progress: $progress');
            setState(() {
              _messages.messages[i].downloadProgress = (sent / total);
            });
          },
        ).then((value) {
          chatHomeController.refreshGallery(path);
        });
        setState(() {
          _messages.messages[i].receiverThumbnail = thumb;
          _messages.messages[i].receiverDevicePath = path;
          _messages..messages[i].receiverDownload = 0;
        });
        ChatApiCalls()
            .downloadFile(
                _messages.messages[i].messageId!, path, thumb, widget.memberID!)
            .then((value) {
          print("api called");
          setState(() {
            _getMediaFiles();
            _messages.messages[i].isDownloading = false;
          });
        });
      } else if (_messages.messages[i].messageType == "file") {
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        String savePath = _messages.messages[i].fileNameUploaded!;
        await Dio().download(
          _messages.messages[i].url!,
          savePath,
          onReceiveProgress: (int sent, int total) {
            final progress = (sent / total) * 100;
            print('file download progress: $progress');
            setState(() {
              _messages.messages[i].downloadProgress = (sent / total);
            });
          },
        );
        print(savePath);
        ChatApiCalls()
            .downloadFile(_messages.messages[i].messageId!, savePath, savePath,
                widget.memberID!)
            .then((value) {
          setState(() {
            _getMediaFiles();
            _messages.messages[i].isDownloading = false;
          });
        });
      } else if (_messages.messages[i].messageType == "audio") {
        print("audio message");
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        String savePath = "${chatHomeController.audioPath.value}/" +
            "${_messages.messages[i].fileNameUploaded}";
        await Dio().download(
          _messages.messages[i].url!,
          savePath,
          onReceiveProgress: (int sent, int total) {
            final progress = (sent / total) * 100;
            print('audio download progress: $progress');
            setState(() {
              _messages.messages[i].downloadProgress = (sent / total);
            });
          },
        );
        print(savePath);
        ChatApiCalls()
            .downloadFile(_messages.messages[i].messageId!, savePath, savePath,
                widget.memberID!)
            .then((value) {
          setState(() {
            _getMediaFiles();
            _messages.messages[i].isDownloading = false;
          });
        });
      } else if (_messages.messages[i].messageType == "voice") {
        print("voice message");
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        String savePath = "${chatHomeController.voicePath.value}/" +
            "${_messages.messages[i].fileNameUploaded}";
        await Dio().download(
          _messages.messages[i].url!,
          savePath,
          onReceiveProgress: (int sent, int total) {
            final progress = (sent / total) * 100;
            print('voice download progress: $progress');
            setState(() {
              _messages.messages[i].downloadProgress = (sent / total);
            });
          },
        );
        print(savePath);

        ChatApiCalls()
            .downloadFile(_messages.messages[i].messageId!, savePath, savePath,
                widget.memberID!)
            .then((value) {
          setState(() {
            _getMediaFiles();
            _messages.messages[i].isDownloading = false;
          });
        });
      }
    } else if (_messages.messages[i].messageType != "file" &&
        _messages.messages[i].messageType != "audio" &&
        _messages.messages[i].messageType != "voice" &&
        _messages.messages[i].messageType != "text" &&
        _messages.messages[i].messageType != "contact" &&
        _messages.messages[i].messageType != "location" &&
        _messages.messages[i].messageType != "link") {
      if (!File(path!).existsSync()) {
        print("no media");
        print(path);
        simpleDialog(
            context,
            "Sorry this media file doesn't exist on your internal storage.",
            "OK");
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewSingleChatFile(
                      token: widget.token,
                      memberID: widget.memberID,
                      messages: _mediaMessages.messages.reversed.toList(),
                      selectedIndex: (_mediaMessages.messages.length - 1) -
                          _mediaMessages.messages.indexWhere((element) =>
                              element.messageId ==
                              _messages.messages[i].messageId),
                    )));
      }
    } else if (_messages.messages[i].messageType == "file" &&
        messageID.length == 0 &&
        _messages.messages[i].isDownloading == false) {
      print("fileeeeee");
      if (!File(path!).existsSync()) {
        print("no media");
        simpleDialog(
            context,
            "Sorry this media file doesn't exist on your internal storage.",
            "OK");
      } else {
        OpenFile.open(_messages.messages[i].receiverDevicePath == ""
            ? path
            : _messages.messages[i].receiverDevicePath);
      }
    } else if (_messages.messages[i].messageType == "contact") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewContact(
                    message: _messages.messages[i],
                  )));
    } else if (_messages.messages[i].messageType == "location") {
      MapsLauncher.launchCoordinates(
          _messages.messages[i].latitude!, _messages.messages[i].longitude!);
    } else if (_messages.messages[i].messageType == "link") {
      ChatApiCalls().openLink(_messages.messages[i].message!.split("~~~")[4]);
    }
  }

  void _onLongTapMessage(int i) {
    isyou.clear();
    if (_messages.messages[i].you == 1) {
      isyou.add(true);
    } else {
      isyou.add(false);
    }
    setState(() {
      selectedIndex = i;
    });
    if (messageID.length == 0) {
      setState(() {
        _messages.messages[i].isSelected = !_messages.messages[i].isSelected!;
        messageID.add(_messages.messages[i].messageId!);
        selectedMessages.add(_messages.messages[i]);
        if (_messages.messages[i].isStar == 0) {
          countUnStared++;
        }
      });
    }
  }

  void _selectAutomatically() {
    _messages.messages.forEach((element) {
      if (messageID.contains(element.messageId)) {
        setState(() {
          element.isSelected = true;
        });
      }
    });
  }

  void _getMediaFiles() {
    setState(() {
      _mediaMessages.messages = [];
    });
    for (int i = 0; i < _messages.messages.length; i++) {
      String path = "";
      if (_messages.messages[i].you == 1) {
        path = _messages.messages[i].path!;
      } else {
        path = _messages.messages[i].receiverDevicePath!;
      }
      if ((_messages.messages[i].messageType == "image" ||
              _messages.messages[i].messageType == "video") &&
          _messages.messages[i].receiverDownload == 0 &&
          File(path).existsSync()) {
        _mediaMessages.messages.add(_messages.messages[i]);
      }
    }
  }

  Future<void> getLocalChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("main_chats" + widget.memberID!);
    if (chatData != null) {
      _chatMessages =
          ChatApiCalls.getAllChatsLocal(widget.memberID!).then((value) {
        setState(() {
          _messages.messages = value!.messages.reversed.toList();
        });
        _getMediaFiles();
        _selectAutomatically();
        _getDate();
        return value!;
      });

      print(_messages.messages.length);
    }
  }

  Future sendPushMessage() async {
    String? aa = "";

    aa = CurrentUser().currentUser.memberID!;

    await ChatApiCalls.sendFcmRequest(CurrentUser().currentUser.fullName!, aa,
        "message", "otherMemberID", widget.token!, 0, 0,
        isVideo: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: _detailedChatRefresh.currentSelect,
        stream: _detailedChatRefresh.observableCart,
        builder: (context, dynamic snapshot) {
          if (snapshot.data /* && !_messages.messages[0].isDownloading */) {
            _reloadChats();
            Future.delayed(Duration(seconds: 2), () {
              _detailedChatRefresh.updateRefresh(false);
            });
          }

          return Scaffold(
            backgroundColor: chatDetailScaffoldBgColor,
            appBar: AppBar(
              brightness: Brightness.dark,
              flexibleSpace: gradientContainer(null),
              leading: messageID.length == 0
                  ? ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.only(left: 2.0)),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          CircleAvatar(
                            radius: 15.0,
                            backgroundImage: NetworkImage(widget.image!),
                          ),
                        ],
                      ),
                    )
                  : null,
              title: messageID.length == 0
                  ? InkWell(
                      highlightColor: highlightColor,
                      splashColor: secondaryColor,
                      onTap: () {
                        _viewContact();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            width: 100.0.w - 235,
                            height: 56,
                            child: StreamBuilder<Object>(
                                initialData: _status.currentSelect,
                                stream: _status.observableCart,
                                builder: (context, snapshot) {
                                  String status = "";
                                  if (snapshot.data == "Online") {
                                    status = "Online";
                                  } else if (snapshot.data == "Typing...") {
                                    status = "Typing...";
                                  } else {
                                    status = "Offline";
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.name == null
                                            ? "Name"
                                            : widget.name!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      widget.blocked == 0 && snapshot.data != ""
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Text(
                        messageID.length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
              actions: <Widget>[
                messageID.length == 1
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(
                              CustomIcons.backward,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                replyIndex = _messages.messages.indexWhere(
                                    (element) => element.isSelected == true);
                                isReply = true;
                              });
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length > 0
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: countUnStared > 0
                                ? Icon(Icons.star)
                                : Icon(CustomIcons.unstarred),
                            onPressed: () {
                              if (countUnStared > 0) {
                                ChatApiCalls().starMessage(messageID.join(","));
                                _messages.messages.forEach((element) {
                                  if (element.isSelected!) {
                                    setState(() {
                                      element.isStar = 1;
                                    });
                                  }
                                });
                              } else {
                                ChatApiCalls()
                                    .unstarMessage(messageID.join(","));
                                _messages.messages.forEach((element) {
                                  if (element.isSelected!) {
                                    setState(() {
                                      element.isStar = 0;
                                    });
                                  }
                                });
                              }
                              setState(() {
                                messageID = [];
                                selectedMessages = [];
                              });
                              _messages.messages.forEach((element) {
                                if (element.isSelected!) {
                                  setState(() {
                                    element.isSelected = false;
                                  });
                                }
                              });
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length == 1 && selectedMessages[0].you == 1
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessageInfoPage(
                                            message: selectedMessages[0],
                                          )));
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length > 0
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog

                                  return DeleteMessagePopup(
                                    isyou: isyou,
                                    title: messageID.length == 1
                                        ? "Delete message?"
                                        : "Delete ${messageID.length.toString()} messages?",
                                    deleteForMe: () {
                                      String messages = messageID.join(",");
                                      ChatApiCalls().deleteMessages(
                                          messages, widget.memberID!);
                                      setState(() {
                                        _messages.messages.removeWhere(
                                            (element) =>
                                                element.isSelected == true);
                                      });
                                      setState(() {
                                        messageID = [];
                                        messageID.length = 0;
                                        selectedMessages = [];
                                      });
                                      Navigator.pop(context);
                                    },
                                    deleteForAll: () {
                                      String messages = messageID.join(",");
                                      ChatApiCalls().deleteMessagesEveryone(
                                          messages,
                                          widget.memberID!,
                                          widget.token!);

                                      _messages.messages.forEach((element) {
                                        if (element.isSelected!) {
                                          print("selected");
                                          setState(() {
                                            element.message =
                                                "You deleted this message";
                                            element.isSelected = false;
                                            element.messageType = "text";
                                          });
                                        }
                                      });
                                      setState(() {
                                        messageID = [];
                                        messageID.length = 0;
                                        selectedMessages = [];
                                      });

                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length > 0
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Call Button tapped')));
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length > 0
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(
                              CustomIcons.forward_new,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForwardMessageChatPage(
                                            messageIDs: messageID,
                                          )));
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length == 0
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(
                              Icons.videocam,
                            ),
                            onPressed: () async {
                              await getPermission();
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length == 0
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {
                              print("boubia Calltype=audio");

                              //await sendPushMessage(isVideo: false);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlayVideoCallScreen(
                                          name: widget.name ?? "",
                                          oppositeMemberId:
                                              widget.memberID ?? "",
                                          userImage: widget.image ?? "",
                                          callType: CallType.audio,
                                          usertok: widget.token,
                                        )

                                    //  JoinChannelAudio(
                                    //   img: widget.image,
                                    //   isFromHome: false,
                                    //   callFromButton: true,
                                    //   token: widget.token,
                                    //   name: widget.name,
                                    //   oppositeMemberId: widget.memberID,
                                    // ),

                                    ),
                              );

                              // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Call Button tapped')));
                            },
                          );
                        },
                      )
                    : Container(),
                messageID.length == 0 && more == false
                    ? PopupMenuButton<ChatDetailMenuOptions>(
                        tooltip: "More options",
                        onSelected: _onSelectMenuOption,
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text("View contact"),
                              value: ChatDetailMenuOptions.viewContact,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text("Media"),
                              value: ChatDetailMenuOptions.media,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text("Search"),
                              value: ChatDetailMenuOptions.search,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text("Mute notifications"),
                              value: ChatDetailMenuOptions.muteNotifications,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text("Wallpaper"),
                              value: ChatDetailMenuOptions.wallpaper,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: Text("More"),
                                trailing: Icon(Icons.arrow_right),
                              ),
                              value: ChatDetailMenuOptions.more,
                            ),
                          ];
                        },
                      )
                    : messageID.length == 0 && more == true
                        ? PopupMenuButton<ChatDetailMoreMenuOptions>(
                            key: _menuKey,
                            onCanceled: () {
                              setState(() {
                                more = false;
                              });
                            },
                            tooltip: "More options",
                            onSelected: _onSelectMoreMenuOption,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<ChatDetailMoreMenuOptions>(
                                  child: Text("Report"),
                                  value: ChatDetailMoreMenuOptions.report,
                                ),
                                PopupMenuItem<ChatDetailMoreMenuOptions>(
                                  child:
                                      Text(blocked == 0 ? "Block" : "Unblock"),
                                  value: ChatDetailMoreMenuOptions.block,
                                ),
                                PopupMenuItem<ChatDetailMoreMenuOptions>(
                                  child: Text("Clear chat"),
                                  value: ChatDetailMoreMenuOptions.clearChat,
                                ),
                                PopupMenuItem<ChatDetailMoreMenuOptions>(
                                  child: Text("Export chat"),
                                  value: ChatDetailMoreMenuOptions.exportChat,
                                ),
                                PopupMenuItem<ChatDetailMoreMenuOptions>(
                                  child: Text("Add shortcut"),
                                  value: ChatDetailMoreMenuOptions.addShortcut,
                                ),
                              ];
                            },
                          )
                        : Container(),
              ],
            ),
            body: WillPopScope(
              onWillPop: () async {
                if (more == true) {
                  print("moreee trueeee");
                  setState(() {
                    more = false;
                  });
                }

                Navigator.pop(context);
                DirectApiCalls.fcmOnlineStatus("Online");
                return true;
              },
              child: Container(
                decoration: imageName != null && imageName != ""
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageName),
                          //  AssetImage(
                          //   imageName,
                          // ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(),
                child: Stack(
                  children: [
                    // imageName != null && imageName != ""
                    //     ? Image.asset(
                    //         imageName,
                    //         fit: BoxFit.fitHeight,
                    //         height: MediaQuery.of(context).size.height,
                    //       )
                    //     : Container(
                    //         color: chatDetailScaffoldBgColor,
                    //       ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 1,
                          child: FutureBuilder(
                              future: _chatMessages,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return SmartRefresher(
                                    enablePullDown: false,
                                    enablePullUp: true,
                                    header: CustomHeader(
                                      builder: (context, mode) {
                                        return Container(
                                          child:
                                              Center(child: loadingAnimation()),
                                        );
                                      },
                                    ),
                                    footer: CustomFooter(
                                      builder: (BuildContext context,
                                          LoadStatus? mode) {
                                        Widget body;
                                        if (mode == LoadStatus.idle) {
                                          body = Text("");
                                        } else if (mode == LoadStatus.loading) {
                                          body = Container();
                                        } else if (mode == LoadStatus.failed) {
                                          body = Container(
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: new Border.all(
                                                    color: Colors.black,
                                                    width: 0.7),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Icon(CustomIcons.reload),
                                              ));
                                        } else if (mode ==
                                            LoadStatus.canLoading) {
                                          body = Text("");
                                        } else {
                                          body = Text("");
                                        }
                                        return Container(
                                          height: 55.0,
                                          child: Center(child: body),
                                        );
                                      },
                                    ),
                                    controller: _refreshController,
                                    onRefresh: () {},
                                    onLoading: () {
                                      _onLoading();
                                    },
                                    child: ListView.builder(
                                        reverse: true,
                                        itemCount: _messages.messages.length,
                                        itemBuilder: (context, index) {
                                          return SwipeTo(
                                            iconColor: Colors.transparent,
                                            onRightSwipe: () {
                                              if (_messages.messages[index]
                                                          .you ==
                                                      1 ||
                                                  _messages.messages[index]
                                                          .you ==
                                                      0) {
                                                setState(() {
                                                  replyIndex = index;
                                                  isReply = true;
                                                });
                                              }
                                            },
                                            child: MessageItem(
                                                user: widget.user,
                                                dir: dir,
                                                controller: controller,
                                                index: index,
                                                image: widget.image,
                                                message:
                                                    _messages.messages[index],
                                                onLongPress: () {
                                                  if (_messages.messages[index]
                                                          .you !=
                                                      2) {
                                                    _onLongTapMessage(index);
                                                  }
                                                },
                                                onTap: () {
                                                  if (_messages.messages[index]
                                                              .you !=
                                                          2 &&
                                                      _messages.messages[index]
                                                              .you !=
                                                          4) {
                                                    _onTapMessage(index);
                                                  }
                                                  if (_messages.messages[index]
                                                              .you ==
                                                          4 &&
                                                      blocked == 1) {
                                                    _unblock();
                                                  }
                                                }),
                                          );
                                        }),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            showLinkPreview || isReply
                                                ? 5
                                                : 30.0),
                                        topRight: Radius.circular(
                                            showLinkPreview || isReply
                                                ? 5
                                                : 30.0),
                                        bottomLeft: Radius.circular(30.0),
                                        bottomRight: Radius.circular(30.0)),
                                    color: Colors.white,
                                  ),
                                  child: !isRecording
                                      ? Wrap(
                                          children: [
                                            showLinkPreview &&
                                                    title != "Page Not Found" &&
                                                    title != null
                                                ? LinkPreview(
                                                    close: () {
                                                      setState(() {
                                                        showLinkPreview = false;
                                                      });
                                                    },
                                                    title: title,
                                                    description:
                                                        description == null
                                                            ? ""
                                                            : description,
                                                    image: image,
                                                    domain: domain,
                                                    showClose: 1,
                                                  )
                                                : Container(),
                                            isReply
                                                ? ReplyCard(
                                                    message: _messages
                                                        .messages[replyIndex],
                                                    close: () {
                                                      setState(() {
                                                        isReply = false;
                                                      });
                                                    })
                                                : Container(),
                                            Row(
                                              children: <Widget>[
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  disabledColor: iconColor,
                                                  color: iconColor,
                                                  icon: Icon(
                                                      Icons.insert_emoticon),
                                                  onPressed: () async {
                                                    await SystemChannels
                                                        .textInput
                                                        .invokeMethod(
                                                            'TextInput.hide');
                                                    await Future.delayed(
                                                        Duration(
                                                            milliseconds: 100));
                                                    toggleEmojiKeyboard();
                                                  },
                                                ),
                                                Flexible(
                                                  child: TextField(
                                                    controller:
                                                        textFieldController,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    textInputAction:
                                                        _textInputAction,
                                                    // textInputAction: isShowSendButton ? TextInputAction.send : _textInputAction,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      hintText:
                                                          AppLocalizations.of(
                                                              'Type a message'),
                                                      hintStyle: TextStyle(
                                                        color:
                                                            textFieldHintColor,
                                                        fontSize: 16.0,
                                                      ),
                                                      counterText: '',
                                                    ),
                                                    onSubmitted: (String text) {
                                                      if (_textInputAction ==
                                                          TextInputAction
                                                              .send) {
                                                        if (showLinkPreview) {
                                                          _sendLink();
                                                        } else {
                                                          _sendMessage();
                                                        }
                                                      }
                                                    },
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                  ),
                                                ),
                                                IconButton(
                                                  color: iconColor,
                                                  icon: Icon(Icons.attach_file),
                                                  onPressed: () {
                                                    if (blocked == 1) {
                                                      _unblock();
                                                    } else {
                                                      setState(() {
                                                        attachmentsOpened =
                                                            !attachmentsOpened;
                                                      });
                                                    }
                                                  },
                                                ),
                                                _message.isEmpty ||
                                                        _message == null
                                                    ? IconButton(
                                                        color: iconColor,
                                                        icon: Icon(
                                                            Icons.camera_alt),
                                                        onPressed: () {
                                                          if (blocked == 1) {
                                                            _unblock();
                                                          } else {
                                                            _openCamera();
                                                          }
                                                        },
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    icon: Icon(
                                                      Icons.mic,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {},
                                                  ),
                                                  _buildTimer(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Container(
                                    child: gradientContainerForButton(_message
                                                .isEmpty ||
                                            _message == null
                                        ? GestureDetector(
                                            onLongPress: () async {
                                              if (blocked == 1) {
                                                _unblock();
                                              } else {
                                                bool result = await Record()
                                                    .hasPermission();
                                                if (result) {
                                                  _startRecording();
                                                  setState(() {
                                                    height = 30;
                                                  });
                                                } else {
                                                  customToastWhite(
                                                      AppLocalizations.of(
                                                        "Please enable microphone permission from settings",
                                                      ),
                                                      12.0,
                                                      ToastGravity.BOTTOM);
                                                }
                                              }
                                            },
                                            onLongPressEnd: (val) async {
                                              if (blocked == 1) {
                                                _unblock();
                                              } else {
                                                bool result = await Record()
                                                    .hasPermission();
                                                if (result) {
                                                  _sendVoiceRecording();
                                                }
                                              }
                                            },
                                            child: AnimatedContainer(
                                              color: Colors.transparent,
                                              curve: Curves.fastOutSlowIn,
                                              duration: new Duration(
                                                  milliseconds: 1000),
                                              child: Padding(
                                                padding: EdgeInsets.all(height),
                                                child: Icon(
                                                  Icons.settings_voice,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () async {
                                              if (blocked == 1) {
                                                _unblock();
                                              } else {
                                                if (showLinkPreview) {
                                                  _sendLink();
                                                } else if (isReply) {
                                                  print("isReplyyyyyy");

                                                  String you = "";
                                                  if (_messages
                                                          .messages[replyIndex]
                                                          .you ==
                                                      1) {
                                                    you = "You";
                                                  } else {
                                                    you = _messages
                                                        .messages[replyIndex]
                                                        .username!;
                                                  }

                                                  String? message = "";
                                                  if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "location") {
                                                    message = _messages
                                                        .messages[replyIndex]
                                                        .locationTitle;
                                                  } else if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "contact") {
                                                    message =
                                                        "Contact: ${_messages.messages[replyIndex].contactName}";
                                                  } else if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "audio") {
                                                    message =
                                                        "Audio (${_messages.messages[replyIndex].audioDuration})";
                                                  } else if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "voice") {
                                                    message =
                                                        "Voice message (${_messages.messages[replyIndex].audioDuration})";
                                                  } else {
                                                    message = _messages
                                                        .messages[replyIndex]
                                                        .message;
                                                  }

                                                  String imageUrl = "";
                                                  if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "image") {
                                                    imageUrl = _messages
                                                        .messages[replyIndex]
                                                        .imageData
                                                        .toString()
                                                        .replaceAll(
                                                            "/resized", "");
                                                  } else if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "video") {
                                                    imageUrl = _messages
                                                        .messages[replyIndex]
                                                        .videoImage!
                                                        .replaceAll(
                                                            ".mp4", ".jpg");
                                                  } else if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "location") {
                                                    imageUrl = _messages
                                                        .messages[replyIndex]
                                                        .url!
                                                        .replaceAll(
                                                            "/resized", "");
                                                  } else if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "link") {
                                                    imageUrl = _messages
                                                        .messages[replyIndex]
                                                        .message!
                                                        .split("~~~")[2];
                                                  } else {
                                                    imageUrl = "";
                                                  }

                                                  String videoTime = "";
                                                  if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "video") {
                                                    videoTime = _messages
                                                        .messages[replyIndex]
                                                        .videoPlaytime!;
                                                  }
                                                  String fileName = "";
                                                  if (_messages
                                                          .messages[replyIndex]
                                                          .messageType ==
                                                      "file") {
                                                    fileName = _messages
                                                        .messages[replyIndex]
                                                        .fileNameUploaded!;
                                                  }
                                                  _replyMessage(
                                                      _messages
                                                          .messages[replyIndex]
                                                          .messageType!,
                                                      imageUrl,
                                                      message!,
                                                      _messages
                                                          .messages[replyIndex]
                                                          .messageId!,
                                                      fileName,
                                                      videoTime,
                                                      you);
                                                } else {
                                                  _sendMessage();
                                                }
                                              }
                                              //_sendMessage();
                                            },
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )),
                                  ))
                            ],
                          ),
                        ),
                        Offstage(
                          child: emojiPicker(),
                          offstage: !isEmojiVisible,
                        ),
                      ],
                    ),
                    attachmentsOpened
                        ? Positioned.fill(
                            child: ChatAttachmentsCard(
                            openGif: () {
                              _gif();
                            },
                            openLocation: () {
                              setState(() {
                                attachmentsOpened = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocationSharing(
                                            sendLocation: (String path,
                                                double latitude,
                                                double longitude,
                                                String title,
                                                String subtitle) {
                                              setState(() {
                                                _messages.messages.insert(
                                                    0,
                                                    new ChatMessagesModel(
                                                        message: "",
                                                        dateData: DateFormat(
                                                                'dd/MM/yyyy')
                                                            .format(
                                                                DateTime.now()),
                                                        you: 1,
                                                        checkStatus: 1,
                                                        time: DateFormat(
                                                                'hh:mm a')
                                                            .format(
                                                                DateTime.now()),
                                                        messageType: "location",
                                                        path: path,
                                                        latitude: latitude,
                                                        longitude: longitude,
                                                        locationTitle: title,
                                                        locationSubtitle:
                                                            subtitle));
                                              });
                                              ChatApiCalls()
                                                  .sendLocation(
                                                      widget.name!,
                                                      widget.memberID!,
                                                      latitude.toString(),
                                                      longitude.toString(),
                                                      title,
                                                      subtitle,
                                                      path,
                                                      widget.token!)
                                                  .then((val) {
                                                ChatApiCalls.sendFcmRequest(
                                                    widget.name!,
                                                    "📍 Location",
                                                    "location",
                                                    widget.memberID!,
                                                    widget.token!,
                                                    blocked,
                                                    mute);
                                                _playPop();

                                                refresh.updateRefresh(true);
                                                _detailedChatRefresh
                                                    .updateRefresh(true);
                                              });
                                            },
                                          )));
                            },
                            openContacts: () {
                              if (contactsPermission) {
                                setState(() {
                                  attachmentsOpened = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectContactsToSend(
                                              sendContacts:
                                                  (List<Contact> contacts) {
                                                List<String> contactData = [];
                                                contacts.forEach((element) {
                                                  String data =
                                                      element.displayName! +
                                                          "^^^" +
                                                          element.phones!.first
                                                              .value! +
                                                          "^^^" +
                                                          element.phones!.first
                                                              .label!
                                                              .toUpperCase();
                                                  contactData.add(data);
                                                  _playPop();
                                                  setState(() {
                                                    _messages.messages.insert(
                                                        0,
                                                        new ChatMessagesModel(
                                                          messageType:
                                                              "contact",
                                                          contactName: element
                                                              .displayName,
                                                          contactNumber: element
                                                              .phones!
                                                              .first
                                                              .value,
                                                          contactType: element
                                                              .phones!
                                                              .first
                                                              .label!
                                                              .toUpperCase(),
                                                          dateData: DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime
                                                                  .now()),
                                                          you: 1,
                                                          checkStatus: 1,
                                                          time: DateFormat(
                                                                  'hh:mm a')
                                                              .format(DateTime
                                                                  .now()),
                                                        ));
                                                  });
                                                });

                                                ChatApiCalls().sendContacts(
                                                    widget.memberID!,
                                                    contactData.join("\$\$\$"),
                                                    widget.token!,
                                                    blocked,
                                                    widget.name!,
                                                    mute);
                                              },
                                            )));
                              } else {
                                customToastWhite(
                                    AppLocalizations.of(
                                        "Please enable contact permission from settings"),
                                    12.0,
                                    ToastGravity.BOTTOM);
                              }
                            },
                            openGallery: () {
                              setState(() {
                                attachmentsOpened = false;
                              });
                              showMaterialModalBottomSheet(
                                  isDismissible: false,
                                  enableDrag: false,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20.0),
                                          topRight:
                                              const Radius.circular(20.0))),
                                  //isScrollControlled:true,
                                  context: context,
                                  builder: (context) {
                                    return _buildGallery();
                                  });
                            },
                            openDocuments: () {
                              setState(() {
                                attachmentsOpened = false;
                              });
                              pickFiles();
                            },
                            openAudio: () {
                              setState(() {
                                attachmentsOpened = false;
                              });
                              //pickAudioFiles();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AudioLibrary(
                                            name: widget.name,
                                            sendAudioMessage: (List<File>
                                                    audioFilePaths,
                                                List<String> durations) async {
                                              File savedFile;
                                              setState(() {
                                                audioFiles = audioFilePaths;
                                              });
                                              List<String> savedPaths = [];
                                              for (int i = 0;
                                                  i < audioFiles.length;
                                                  i++) {
                                                savedFile = await audioFiles[i]
                                                    .copy(
                                                        "/storage/emulated/0/Bebuzee/Bebuzee Audio/${p.basename(audioFiles[i].path)}");
                                                savedPaths.add(savedFile.path);
                                                setState(() {
                                                  _messages.messages.insert(
                                                      0,
                                                      new ChatMessagesModel(
                                                        message: "",
                                                        isSending: true,
                                                        audioDuration:
                                                            durations[i],
                                                        dateData: DateFormat(
                                                                'dd/MM/yyyy')
                                                            .format(
                                                                DateTime.now()),
                                                        you: 1,
                                                        sentNow: 1,
                                                        checkStatus: 1,
                                                        time: DateFormat(
                                                                'hh:mm a')
                                                            .format(
                                                                DateTime.now()),
                                                        messageType: "audio",
                                                        path:
                                                            audioFiles[i].path,
                                                        fileNameUploaded:
                                                            p.basename(
                                                                audioFiles[i]
                                                                    .path),
                                                      ));
                                                });
                                              }
                                              print(durations.join("\$\$\$"));
                                              print("durationsssssss");
                                              ChatApiCalls()
                                                  .uploadAudioFiles(
                                                      widget.token!,
                                                      widget.name!,
                                                      audioFiles,
                                                      widget.memberID!,
                                                      savedPaths.join("\$\$\$"),
                                                      durations.join("\$\$\$"))
                                                  .then((val) {
                                                ChatApiCalls.sendFcmRequest(
                                                    widget.name!,
                                                    "🎧 Audio",
                                                    "audio",
                                                    widget.memberID!,
                                                    widget.token!,
                                                    blocked,
                                                    mute);
                                                _playPop();
                                                setState(() {
                                                  _messages.messages
                                                      .forEach((element) {
                                                    setState(() {
                                                      element.isSending = false;
                                                    });
                                                  });
                                                });

                                                refresh.updateRefresh(true);
                                                _detailedChatRefresh
                                                    .updateRefresh(true);
                                              });
                                            },
                                          )));
                            },
                            openCamera: () {
                              _openCamera();
                            },
                          ))
                        : Container()
                  ],
                ),
              ),
            ),
          );
        });
  }

  getPermission() async {
    bool locationResult = await Permissions().getCameraPermission();
    if (locationResult) {
      //await sendPushMessage(isVideo: true);
      print("BEBUZEE START");
      print(
          "my id=${CurrentUser().currentUser.memberID} and widgetud=${widget.memberID}");

      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => FunnyPage(),
      // ));

      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayVideoCallScreen(
                  name: widget.name ?? "",
                  oppositeMemberId: widget.memberID ?? "",
                  userImage: widget.image ?? "",
                  callType: CallType.video,
                )),

        // ),
      ).then((value) {
        print(value);
      });

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => JoinChannelVideo(
      //       oppositeMemberId: widget.memberID,
      //       isFromHome: false,
      //       callFromButton: true,
      //       name: widget.name,
      //       token: widget.token,
      //       userImage: widget.image,
      //     ),
      //   ),
      // );
    } else {
      getPermission();
    }
  }

  String _token = "";

  // String constructFCMPayload(String token) {
  //   return jsonEncode({
  //     'token': token,
  //     'data': {
  //       'via': 'FlutterFire Cloud Messaging!!!',
  //       'count': "2",
  //     },
  //     'notification': {
  //       'title': 'Hello FlutterFire!',
  //       'body': 'This notification  was created via FCM!',
  //     },
  //   });
  // }

  // Future sendPushMessage({bool isVideo = false}) async {
  //   String aa = "";
  //   if (isVideo) {
  //     aa = CurrentUser().currentUser.memberID + "+video";
  //   } else {
  //     aa = CurrentUser().currentUser.memberID + "+audio";
  //   }
  //   await ChatApiCalls.sendFcmRequest(CurrentUser().currentUser.fullName, aa,
  //       "call", "otherMemberID", widget.token, 0, 0,
  //       isVideo: isVideo);
  // }
}
