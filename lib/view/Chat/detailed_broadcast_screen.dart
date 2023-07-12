import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/services/Chat/broadcast_api.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/group_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/attachments_card.dart';
import 'package:bizbultest/utilities/Chat/chat_galley_thumbnails.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/delete_message_popup.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Chat/all_media_page_chat.dart';
import 'package:bizbultest/view/Chat/location_sharing.dart';
import 'package:bizbultest/view/Chat/select_contacts_to_send.dart';
import 'package:bizbultest/view/Chat/view_broadcast_info_expanded.dart';
import 'package:bizbultest/view/Chat/view_contact.dart';
import 'package:bizbultest/view/Chat/view_single_file.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:bizbultest/widgets/Chat/group_chat_card.dart';
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
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multipart_request/multipart_request.dart' as mp;
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

import 'audio_library.dart';
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

class DetailedBroadcastChatScreen extends StatefulWidget {
  final String? broadcastID;
  final String? image;
  final String? name;
  final String? token;
  final bool? onlineStatus;
  final String? topic;
  final String? members;

  const DetailedBroadcastChatScreen(
      {Key? key,
      this.broadcastID,
      this.image,
      this.name,
      this.token,
      this.onlineStatus,
      this.topic,
      this.members})
      : super(key: key);

  @override
  _DetailedBroadcastChatScreenState createState() =>
      _DetailedBroadcastChatScreenState();
}

class _DetailedBroadcastChatScreenState
    extends State<DetailedBroadcastChatScreen> with WidgetsBindingObserver {
  _onSelectMoreMenuOption(ChatDetailMoreMenuOptions option) {}
  AutoScrollController controller = AutoScrollController();
  ChatMessages _mediaMessages = new ChatMessages([]);
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
  UpdateTypingStatusGroup _typingStatus = UpdateTypingStatusGroup();
  HomepageRefreshState homeRefresh = new HomepageRefreshState();

  Future saveImage() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/MyImages';
    setState(() {
      dir = myImagePath;
    });
    final myImgDir = await new Directory(myImagePath).create();
    // thumbToImage();
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

  DetailedChatRefresh _detailedChatRefresh = DetailedChatRefresh();

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

  void _viewInfo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewBroadcastInfoExpanded(
                  messages: _mediaMessages.messages,
                  topic: widget.topic,
                  groupID: widget.broadcastID,
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

  _onSelectMenuOption(ChatDetailMenuOptions option) {
    switch (option) {
      case ChatDetailMenuOptions.viewContact:
        _viewInfo();
        break;
      case ChatDetailMenuOptions.media:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllMediaPageChat(
                      title: widget.name!.split(", ").length.toString() +
                          " recipients",
                      uniqueID: widget.broadcastID,
                      topic: widget.topic,
                      from: "group",
                    )));
        break;
      case ChatDetailMenuOptions.search:
        break;
      case ChatDetailMenuOptions.muteNotifications:
        break;
      case ChatDetailMenuOptions.wallpaper:
        break;
      case ChatDetailMenuOptions.more:
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
                      AppLocalizations.of("Tap photo to select") +
                          " " +
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
                                        print(type + " typeeeeeeeeeeee");

                                        for (int i = 0;
                                            i < multiSelectList.length;
                                            i++) {
                                          setState(() {
                                            _messages.messages.insert(
                                                0,
                                                new ChatMessagesModel(
                                                    message: messages[i],
                                                    messageType: multiSelectList[
                                                                    i]
                                                                .asset!
                                                                .type
                                                                .toString() ==
                                                            "AssetType.video"
                                                        ? AppLocalizations.of(
                                                            "video")
                                                        : AppLocalizations.of(
                                                            "image"),
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
                                          print("saveeee");
                                          File? file = await multiSelectList[i]
                                              .asset!
                                              .file;
                                          if (multiSelectList[i]
                                                  .asset!
                                                  .type
                                                  .toString() ==
                                              "AssetType.video") {
                                            await GallerySaver.saveVideo(
                                                    file!.path,
                                                    albumName:
                                                        "Bebuzee/Bebuzee Videos")
                                                .then((value) async {
                                              await GallerySaver.saveImage(
                                                  thumbs[i].path,
                                                  albumName:
                                                      "Bebuzee/.thumbnails");
                                            });
                                          } else {
                                            await GallerySaver.saveImage(
                                                file!.path,
                                                albumName:
                                                    "Bebuzee/Bebuzee Images");
                                          }
                                        }
                                        BroadcastApiCalls.uploadMultipleFiles(
                                                allData,
                                                "",
                                                files,
                                                CurrentUser()
                                                    .currentUser
                                                    .memberID!,
                                                widget.broadcastID!)
                                            .then((request) {
                                          mp.Response response = request.send();
                                          response.onError = () {
                                            print("Error");
                                          };
                                          response.onComplete = (response) {
                                            BroadcastApiCalls.sendFcmRequest(
                                                "Notification",
                                                "",
                                                type,
                                                widget.broadcastID!,
                                                widget.topic!);
                                            print(response +
                                                " resssssppponnseee");

                                            _messages.messages
                                                .forEach((element) {
                                              setState(() {
                                                element.isVideoUploading =
                                                    false;
                                                element.isSending = false;
                                              });
                                            });

                                            ChatApiCalls.getAllChats(
                                                widget.broadcastID!, "");
                                            refresh.updateRefresh(true);
                                            _detailedChatRefresh
                                                .updateRefresh(true);
                                          };
                                          response.progress
                                              .listen((int progress) {
                                            print(
                                                "progress from response object " +
                                                    progress.toString());
                                          });
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExpandedFileChatSingle(
                                    sendFile: (String message, File file,
                                        String type, thumb, File video) async {
                                      print(message + "is message");
                                      List<File> allFiles = [];
                                      allFiles
                                          .add(type == "image" ? file : video);

                                      setState(() {
                                        _messages.messages.insert(
                                            0,
                                            new ChatMessagesModel(
                                                message: message,
                                                messageType: type,
                                                dateData:
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.now()),
                                                you: 1,
                                                checkStatus: 1,
                                                time: DateFormat('hh:mm a')
                                                    .format(DateTime.now()),
                                                file: file,
                                                path: type == "image"
                                                    ? file.path
                                                    : video.path,
                                                thumbPath: file.path));
                                        _messages.messages[0].isVideoUploading =
                                            true;
                                      });

                                      if (type == "video") {
                                        await GallerySaver.saveVideo(video.path,
                                                albumName:
                                                    "Bebuzee/Bebuzee Videos")
                                            .then((value) async {
                                          await GallerySaver.saveImage(
                                              file.path,
                                              albumName: "Bebuzee/.thumbnails");
                                        });
                                      }

                                      String folder = type == "video"
                                          ? "Bebuzee Videos"
                                          : "Bebuzee Images";
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
                                      BroadcastApiCalls.uploadMultipleFiles(
                                              data,
                                              "",
                                              allFiles,
                                              CurrentUser()
                                                  .currentUser
                                                  .memberID!,
                                              widget.broadcastID!)
                                          .then((request) {
                                        mp.Response response = request.send();
                                        response.onError = () {
                                          print("Error");
                                        };
                                        response.onComplete = (response) {
                                          BroadcastApiCalls.sendFcmRequest(
                                              "Notification",
                                              "",
                                              type,
                                              widget.broadcastID!,
                                              widget.topic!);
                                          print(
                                              response + " resssssppponnseee");
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
                                          ChatApiCalls.getAllChats(
                                              widget.broadcastID!, "");
                                          refresh.updateRefresh(true);
                                          _detailedChatRefresh
                                              .updateRefresh(true);
                                        };
                                        response.progress
                                            .listen((int progress) {
                                          print(
                                              "progress from response object " +
                                                  progress.toString());
                                        });
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
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatCameraScreen(
                  memberId: '',
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
                      await GallerySaver.saveVideo(video.path,
                              albumName: "Bebuzee/Bebuzee Videos")
                          .then((value) async {
                        await GallerySaver.saveImage(file.path,
                            albumName: "Bebuzee/.thumbnails");
                      });
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
                    BroadcastApiCalls.uploadMultipleFiles(
                            data,
                            "",
                            allFiles,
                            CurrentUser().currentUser.memberID!,
                            widget.broadcastID!)
                        .then((request) {
                      mp.Response response = request.send();
                      response.onError = () {
                        print("Error");
                      };
                      response.onComplete = (response) {
                        print(response + " resssssppponnseee");
                        BroadcastApiCalls.sendFcmRequest("Notification", "",
                            type, widget.broadcastID!, widget.topic!);
                        setState(() {
                          _messages.messages.forEach((element) {
                            setState(() {
                              element.isVideoUploading = false;
                              element.isSending = false;
                            });
                          });
                        });
                        ChatApiCalls.getAllChats(widget.broadcastID!, "");
                        refresh.updateRefresh(true);
                        _detailedChatRefresh.updateRefresh(true);
                      };
                      response.progress.listen((int progress) {
                        print("progress from response object " +
                            progress.toString());
                      });
                    });
                  },
                  name: widget.name!,
                  image: widget.image,
                )));
  }

  late Future<ChatMessages> _chatMessages;
  ChatMessages _messages = new ChatMessages([]);
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

  void _sendMessage() {
    if (_message == null || _message.isEmpty) return;
    BroadcastApiCalls()
        .sendTextMessage(widget.broadcastID!, _message, widget.topic!);

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
      print(_message);
      textFieldController.text = '';
    });
  }

  void _onLoading() async {
    ChatMessages? messagesData = await ChatApiCalls.onLoading(
        _messages, context, _refreshController, widget.broadcastID!);
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
        ChatApiCalls.getAllChats(widget.broadcastID!, "").then((value) {
      setState(() {
        _messages.messages = value.messages.reversed.toList();
      });
      _getMediaFiles();
      _loopTest();
      _selectAutomatically();

      return value;
    });

    return "success";
  }

  void _getVoicePermission() async {
    bool result = await Record().hasPermission();
  }

  void _loopTest() {
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
        ChatApiCalls.getAllChats(widget.broadcastID!, "").then((value) {
      setState(() {
        _messages.messages = value.messages.reversed.toList();
      });
      _getMediaFiles();
      _loopTest();
      _selectAutomatically();
      refresh.updateRefresh(true);
      return value;
    });
    return "success";
  }

  @override
  void initState() {
    getLocalChats();
    print(widget.broadcastID);
    _getChats();
    // _fcmListener();
    _askPermission();

    textFieldController = new TextEditingController()
      ..addListener(() {
        setState(() {
          _message = textFieldController.text;
        });
      });
    _fetchAssets();
    saveImage();
    // _loopTest();

    WidgetsBinding.instance.addObserver(this);
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    GroupApiCalls.fcmTypingStatus(
        widget.name!, "false", widget.topic!, widget.broadcastID!);
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
      path: '/storage/emulated/0/Bebuzee/Bebuzee Voice/$filename', // required
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
    String voicePath = "/storage/emulated/0/Bebuzee/Bebuzee Voice/$voiceFile";
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
      BroadcastApiCalls()
          .uploadVoiceRecording(
              voicePath, widget.broadcastID!, voicePath, voiceDuration)
          .then((request) {
        mp.Response response = request.send();
        response.onError = () {
          print("Error");
        };
        response.onComplete = (response) {
          BroadcastApiCalls.sendFcmRequest(
              "Notification", "", "voice", widget.broadcastID!, widget.token!);
          print(response + " resssssppponnseee");
          setState(() {
            _messages.messages.forEach((element) {
              setState(() {
                element.isSending = false;
              });
            });
          });
          ChatApiCalls.getAllChats(widget.broadcastID!, "");
          refresh.updateRefresh(true);
          _detailedChatRefresh.updateRefresh(true);
        };
        response.progress.listen((int progress) {
          print("progress from response object " + progress.toString());
        });
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
      late File thumb;
      for (int i = 0; i < documents.length; i++) {
        savedFile = await documents[i].copy(
            "/storage/emulated/0/Bebuzee/Bebuzee Documents/${p.basename(documents[i].path)}");
        if (p.extension(documents[i].path).replaceAll(".", "") == "pdf") {
          document = await PdfDocument.openFile(savedFile.path);
          final page = await document.getPage(1);
          final pageImage = await page.render(
            width: page.width,
            height: page.height,
            // format: PdfPageFormat.JPEG,
          );
          // var image = await pageImage.createImageDetached();
          img.Image src = img.decodeImage(pageImage.bytes)!;
          print(pageImage.bytes);
          thumb = new File(
              "/storage/emulated/0/Bebuzee/.thumbnails/${generateRandomString(10)}.jpg")
            ..writeAsBytesSync(img.encodeJpg(src, quality: 100));
          // Page
        }

        String thumbPath =
            p.extension(documents[i].path).replaceAll(".", "") == "pdf"
                ? thumb.path
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

      BroadcastApiCalls.uploadMultipleFiles(allData.join("\$\$\$"), "", files,
              CurrentUser().currentUser.memberID!, widget.broadcastID!)
          .then((request) {
        mp.Response response = request.send();
        response.onError = () {
          print("Error");
        };
        response.onComplete = (response) {
          BroadcastApiCalls.sendFcmRequest(
              "Notification", "", "file", widget.broadcastID!, widget.topic!);
          print(response + " resssssppponnseee");
          setState(() {
            _messages.messages.forEach((element) {
              setState(() {
                element.isSending = false;
              });
            });
          });

          refresh.updateRefresh(true);
          _detailedChatRefresh.updateRefresh(true);
        };
        response.progress.listen((int progress) {
          print("progress from response object " + progress.toString());
        });
      });
    } else {
      // User canceled the picker
    }
  }

  int countUnStared = 0;

  Future<void> _onTapMessage(int i) async {
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
        _messages.messages[i].messageType != "location") {
      print("exeeeeeeeee");

      if (_messages.messages[i].messageType == "image") {
        String path =
            "/storage/emulated/0/Bebuzee/Bebuzee Images/${(_messages.messages[i].imageData).toString().split("/")[6]}";
        setState(() {
          _messages.messages[i].isDownloading = true;
        });

        GallerySaver.saveImage(
                _messages.messages[i].imageData.replaceAll("resized/", ""),
                albumName: "Bebuzee/Bebuzee Images")
            .then((value) {
          print("success");
          print(
              "/storage/emulated/0/Bebuzee/Bebuzee Images/${(_messages.messages[i].imageData).toString().split("/")[6]}");
          if (mounted) {
            setState(() {
              _messages.messages[i].receiverDevicePath = path;
              _messages..messages[i].receiverDownload = 0;
              _messages.messages[i].isDownloading = false;
            });
          }
        });
        ChatApiCalls().downloadFile(
            _messages.messages[i].messageId!, path, path, widget.broadcastID!);
      } else if (_messages.messages[i].messageType == "video") {
        String path =
            "/storage/emulated/0/Bebuzee/Bebuzee Videos/${(_messages.messages[i].video).toString().split("/")[5]}";
        String thumb =
            "/storage/emulated/0/Bebuzee/.thumbnails/${_messages.messages[i].url?.replaceAll(".mp4", ".jpg").toString().split("/")[5]}";
        print("thumb");
        setState(() {
          _messages.messages[i].isDownloading = true;
        });

        GallerySaver.saveVideo(_messages.messages[i].video!,
                albumName: "Bebuzee/Bebuzee Videos")
            .then((value) {
          print("success");
          print(path + " path");
          GallerySaver.saveImage(
                  _messages.messages[i].url!.replaceAll(".mp4", ".jpg"),
                  albumName: "Bebuzee/.thumbnails")
              .then((value) {
            setState(() {
              _messages.messages[i].receiverThumbnail = thumb;
              _messages.messages[i].receiverDevicePath = path;
              _messages..messages[i].receiverDownload = 0;
              _messages.messages[i].isDownloading = false;
            });
          });
        });
        ChatApiCalls().downloadFile(
            _messages.messages[i].messageId!, path, thumb, widget.broadcastID!);
      } else if (_messages.messages[i].messageType == "file") {
        print("new fileeee");
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        String savePath = "/storage/emulated/0/Bebuzee/Bebuzee Documents/" +
            "${_messages.messages[i].fileNameUploaded}";
        await Dio().download(_messages.messages[i].url!, savePath);
        print(savePath);
        await ImageGallerySaver.saveFile(savePath).then((value) => {
              if (mounted)
                {
                  setState(() {
                    _messages.messages[i].isDownloading = false;
                    _messages.messages[i].receiverDownload = 0;
                    _messages.messages[i].path = savePath;
                  }),
                }
            });
        ChatApiCalls().downloadFile(_messages.messages[i].messageId!, savePath,
            savePath, widget.broadcastID!);
      } else if (_messages.messages[i].messageType == "audio") {
        print("audio message");
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        String savePath = "/storage/emulated/0/Bebuzee/Bebuzee Audio/" +
            "${_messages.messages[i].fileNameUploaded}";
        await Dio().download(_messages.messages[i].url!, savePath);
        print(savePath);
        await ImageGallerySaver.saveFile(savePath).then((value) => {
              if (mounted)
                {
                  setState(() {
                    _messages.messages[i].isDownloading = false;
                    _messages.messages[i].receiverDownload = 0;
                    _messages.messages[i].receiverDevicePath = savePath;
                  }),
                }
            });
        ChatApiCalls().downloadFile(_messages.messages[i].messageId!, savePath,
            savePath, widget.broadcastID!);
      } else if (_messages.messages[i].messageType == "voice") {
        print("voice message");
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        String savePath = "/storage/emulated/0/Bebuzee/Bebuzee Voice/" +
            "${_messages.messages[i].fileNameUploaded}";
        await Dio().download(_messages.messages[i].url!, savePath);
        print(savePath);
        await ImageGallerySaver.saveFile(savePath).then((value) => {
              if (mounted)
                {
                  setState(() {
                    _messages.messages[i].isDownloading = false;
                    _messages.messages[i].receiverDownload = 0;
                    _messages.messages[i].receiverDevicePath = savePath;
                  }),
                }
            });
        ChatApiCalls().downloadFile(_messages.messages[i].messageId!, savePath,
            savePath, widget.broadcastID!);
      }
    } else if (_messages.messages[i].messageType != "file" &&
        _messages.messages[i].messageType != "audio" &&
        _messages.messages[i].messageType != "voice" &&
        _messages.messages[i].messageType != "text" &&
        _messages.messages[i].messageType != "contact" &&
        _messages.messages[i].messageType != "location") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewSingleChatFile(
                  // type: _messages.messages[i].messageType,
                  // who: _messages.messages[i].you == 0 ? widget.name : "You",
                  //  path: _messages.messages[i].you == 0  ?  _messages.messages[i].receiverDevicePath : _messages.messages[i].path,
                  )));
      print("tapped");
    } else if (_messages.messages[i].messageType == "file" &&
        messageID.length == 0 &&
        _messages.messages[i].isDownloading == false) {
      print("fileeeeee");
      print(_messages.messages[i].path);
      OpenFile.open(_messages.messages[i].path);
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
    }
  }

  void _onLongTapMessage(int i) {
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

  Future<void> getLocalChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("main_chats" + widget.broadcastID!);
    if (chatData != null) {
      _chatMessages =
          ChatApiCalls.getAllChatsLocal(widget.broadcastID!).then((value) {
        setState(() {
          _messages.messages = value!.messages.reversed.toList();
        });
        _getMediaFiles();
        _selectAutomatically();
        _loopTest();
        return value!;
      });

      print(_messages.messages.length);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: _detailedChatRefresh.currentSelect,
        stream: _detailedChatRefresh.observableCart,
        builder: (context, dynamic snapshot) {
          if (snapshot.data) {
            print("refresh group chat");
            _reloadChats();
            _detailedChatRefresh.updateRefresh(false);
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
                  ? Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        highlightColor: highlightColor,
                        splashColor: secondaryColor,
                        onTap: () {
                          _viewInfo();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 100.0.w - 195,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name!.split(", ").length.toString() +
                                        " " +
                                        AppLocalizations.of("recipients"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    widget.name!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                messageID.length > 0
                    ? Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(
                              CustomIcons.backward,
                              size: 20,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(AppLocalizations.of(
                                          'Call Button tapped'))));
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
                                    isyou: [],
                                    title: messageID.length == 1
                                        ? AppLocalizations.of("Delete message?")
                                        : "Delete ${messageID.length.toString()} messages?",
                                    deleteForMe: () {
                                      String messages = messageID.join(",");
                                      ChatApiCalls().deleteMessages(
                                          messages, widget.broadcastID!);
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
                                          widget.broadcastID!,
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
                                      content: Text(AppLocalizations.of(
                                          'Call Button tapped'))));
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
                    ? PopupMenuButton<ChatDetailMenuOptions>(
                        tooltip: AppLocalizations.of("More options"),
                        onSelected: _onSelectMenuOption,
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text(
                                AppLocalizations.of(
                                  "Broadcast list info",
                                ),
                              ),
                              value: ChatDetailMenuOptions.viewContact,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text(
                                AppLocalizations.of(
                                  "Broadcast list media",
                                ),
                              ),
                              value: ChatDetailMenuOptions.media,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text(
                                AppLocalizations.of('Search'),
                              ),
                              value: ChatDetailMenuOptions.search,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text(AppLocalizations.of("Wallpaper")),
                              value: ChatDetailMenuOptions.wallpaper,
                            ),
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: Text(
                                  AppLocalizations.of('More'),
                                ),
                                trailing: Icon(Icons.arrow_right),
                              ),
                              value: ChatDetailMenuOptions.more,
                            ),
                          ];
                        },
                      )
                    : Container(),
              ],
            ),
            body: WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);

                return true;
              },
              child: Stack(
                children: [
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
                                        return GroupChatCard(
                                            controller: controller,
                                            index: index,
                                            image: widget.image,
                                            message: _messages.messages[index],
                                            onLongPress: () {
                                              if (_messages
                                                      .messages[index].you !=
                                                  2) {
                                                _onLongTapMessage(index);
                                              }
                                            },
                                            onTap: () {
                                              if (_messages
                                                      .messages[index].you !=
                                                  2) {
                                                _onTapMessage(index);
                                              }
                                            });
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
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(30.0)),
                                  color: Colors.white,
                                ),
                                child: !isRecording
                                    ? Row(
                                        children: <Widget>[
                                          IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            disabledColor: iconColor,
                                            color: iconColor,
                                            icon: Icon(Icons.insert_emoticon),
                                            onPressed: () async {
                                              await SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');
                                              await Future.delayed(
                                                  Duration(milliseconds: 100));
                                              toggleEmojiKeyboard();
                                            },
                                          ),
                                          Flexible(
                                            child: TextField(
                                              controller: textFieldController,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              textInputAction: _textInputAction,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.all(0.0),
                                                hintText: AppLocalizations.of(
                                                  'Type a message',
                                                ),
                                                hintStyle: TextStyle(
                                                  color: textFieldHintColor,
                                                  fontSize: 16.0,
                                                ),
                                                counterText: '',
                                              ),
                                              onSubmitted: (String text) {
                                                if (_textInputAction ==
                                                    TextInputAction.send) {
                                                  _sendMessage();
                                                }
                                              },
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              maxLength: 100,
                                            ),
                                          ),
                                          IconButton(
                                            color: iconColor,
                                            icon: Icon(Icons.attach_file),
                                            onPressed: () {
                                              setState(() {
                                                attachmentsOpened =
                                                    !attachmentsOpened;
                                              });
                                            },
                                          ),
                                          _message.isEmpty || _message == null
                                              ? IconButton(
                                                  color: iconColor,
                                                  icon: Icon(Icons.camera_alt),
                                                  onPressed: () {
                                                    _openCamera();
                                                  },
                                                )
                                              : Container(),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
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
                                            bool result =
                                                await Record().hasPermission();
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
                                          },
                                          onLongPressEnd: (val) async {
                                            bool result =
                                                await Record().hasPermission();
                                            if (result) {
                                              _sendVoiceRecording();
                                            }
                                          },
                                          child: AnimatedContainer(
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
                                          onTap: () {
                                            _sendMessage();
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
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
                                            BroadcastApiCalls()
                                                .sendLocation(
                                                    widget.broadcastID!,
                                                    latitude.toString(),
                                                    longitude.toString(),
                                                    title,
                                                    subtitle,
                                                    path)
                                                .then((request) {
                                              mp.Response response =
                                                  request.send();
                                              response.onError = () {
                                                print("Error");
                                              };
                                              response.onComplete = (response) {
                                                BroadcastApiCalls
                                                    .sendFcmRequest(
                                                        "Notification",
                                                        "Location",
                                                        "location",
                                                        widget.broadcastID!,
                                                        widget.topic!);
                                                print(response +
                                                    " resssssppponnseee locationnnn");
                                                refresh.updateRefresh(true);
                                                _detailedChatRefresh
                                                    .updateRefresh(true);
                                              };
                                              response.progress
                                                  .listen((int progress) {
                                                print(
                                                    "progress from response object " +
                                                        progress.toString());
                                              });
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
                                                String data = element
                                                        .displayName! +
                                                    "^^^" +
                                                    element
                                                        .phones!.first.value! +
                                                    "^^^" +
                                                    element.phones!.first.label!
                                                        .toUpperCase();
                                                contactData.add(data);
                                                setState(() {
                                                  _messages.messages.insert(
                                                      0,
                                                      new ChatMessagesModel(
                                                        messageType: "contact",
                                                        contactName:
                                                            element.displayName,
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
                                                            .format(
                                                                DateTime.now()),
                                                        you: 1,
                                                        checkStatus: 1,
                                                        time: DateFormat(
                                                                'hh:mm a')
                                                            .format(
                                                                DateTime.now()),
                                                      ));
                                                });
                                              });

                                              BroadcastApiCalls().sendContacts(
                                                  widget.broadcastID!,
                                                  contactData.join("\$\$\$"),
                                                  widget.topic!);
                                            },
                                          )));
                            } else {
                              customToastWhite(
                                  AppLocalizations.of(
                                    "Please enable microphone permission from settings",
                                  ),
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
                                        topRight: const Radius.circular(20.0))),
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
                                              savedFile = await audioFiles[i].copy(
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
                                                      path: audioFiles[i].path,
                                                      fileNameUploaded:
                                                          p.basename(
                                                              audioFiles[i]
                                                                  .path),
                                                    ));
                                              });
                                            }
                                            print(durations.join("\$\$\$"));
                                            print("durationsssssss");
                                            BroadcastApiCalls()
                                                .uploadAudioFiles(
                                                    audioFiles,
                                                    widget.broadcastID!,
                                                    savedPaths.join("\$\$\$"),
                                                    durations.join("\$\$\$"))
                                                .then((request) {
                                              mp.Response response =
                                                  request.send();
                                              response.onError = () {
                                                print("Error");
                                              };
                                              response.onComplete = (response) {
                                                BroadcastApiCalls
                                                    .sendFcmRequest(
                                                        "Notification",
                                                        "",
                                                        "audio",
                                                        widget.broadcastID!,
                                                        widget.token!);
                                                print(response +
                                                    " resssssppponnseee");
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
                                              };
                                              response.progress
                                                  .listen((int progress) {
                                                print(
                                                    "progress from response object " +
                                                        progress.toString());
                                              });
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
          );
        });
  }
}
