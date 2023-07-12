import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/permission/permissions.dart';
import 'package:bizbultest/playground/PlayVideoCallScreen.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/attachments_card.dart';
import 'package:bizbultest/utilities/Chat/chat_galley_thumbnails.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/delete_message_popup.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Chat/location_sharing.dart';
import 'package:bizbultest/view/Chat/select_contacts_to_send.dart';
import 'package:bizbultest/view/Chat/view_contact.dart';
import 'package:bizbultest/view/Chat/view_single_file.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:bizbultest/widgets/Chat/appbar_icon.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:bizbultest/widgets/Chat/link_preview.dart';
import 'package:bizbultest/widgets/Chat/message_card_direct.dart';
import 'package:bizbultest/widgets/Chat/reply_card.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

import '../../main.dart';
import 'audio_library.dart';
import 'expanded_file_single.dart';
import 'expanded_files_multiple.dart';
import 'forward_message_direct.dart';
import 'message_info_page.dart';

enum ChatDetailMenuOptions {
  delete,
}

enum ChatDetailMoreMenuOptions {
  report,
  block,
  clearChat,
  exportChat,
  addShortcut,
}

class DetailedDirectScreen extends StatefulWidget {
  final String? memberID;
  final String? image;
  final String? name;
  final String? token;
  final bool? onlineStatus;
  final String? from;
  final Function? setNavbar;

  const DetailedDirectScreen(
      {Key? key,
      this.memberID,
      this.image,
      this.name,
      this.token,
      this.onlineStatus,
      this.from,
      this.setNavbar})
      : super(key: key);

  @override
  _DetailedDirectScreenState createState() => _DetailedDirectScreenState();
}

class _DetailedDirectScreenState extends State<DetailedDirectScreen> {
  check() async {
    var call_per = await Permission.phone.status;
    var mic_per = await Permission.microphone.status;

    if (!call_per.isGranted) {
      await Permission.phone.request();
    }

    if (!mic_per.isGranted) {
      await Permission.microphone.request();
    }
  }

  _onSelectMoreMenuOption(ChatDetailMoreMenuOptions option) {}

  AutoScrollController controller = AutoScrollController();

  List<String> messageID = [];
  bool isMultiSelect = false;
  List<GalleryThumbnails> multiSelectList = [];
  late String fileLocation;
  late String fileName;
  late int h;
  late int w;
  late var fileSize;
  String dir = "";
  int selectedIndex = 0;
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  List<bool> isyou = [];

  Future saveImage() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/MyImages';
    setState(() {
      dir = myImagePath;
    });
    final myImgDir = await new Directory(myImagePath).create();
    // thumbToImage();
  }

  bool showLinkPreview = false;
  bool isReply = false;
  String domain = "";
  String description = "";
  String title = "";
  String image = "";

  int replyIndex = 0;

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

  double height = 12;
  List<File> thumbs = [];
  List<File> allFiles = [];
  List<File> documents = [];
  List<File> audioFiles = [];
  List<String> audioPaths = [];

  _onSelectMenuOption(ChatDetailMenuOptions option) {
    switch (option) {
      case ChatDetailMenuOptions.delete:
        showDialog(
            context: context,
            builder: (BuildContext processingContext) {
              DirectApiCalls.removeUser(widget.memberID!).then((value) {
                // refresh.updateRefresh(true);
                Navigator.pop(processingContext);
                Navigator.pop(context);
              });
              return ProcessingDialog(
                title: AppLocalizations.of(
                  "Please wait a moment",
                ),
                heading: "",
              );
            });
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
                      AppLocalizations.of(
                            "Tap photo to select",
                          ) +
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
                                          File? file = await multiSelectList[i]
                                              .asset!
                                              .file;
                                          if (multiSelectList[i]
                                                  .asset!
                                                  .type
                                                  .toString() ==
                                              "AssetType.video") {
                                            await file!.copy(
                                                "/storage/emulated/0/Bebuzee/Bebuzee Videos/${p.basename(file.path)}");
                                            await thumbs[i].copy(
                                                "/storage/emulated/0/Bebuzee/.thumbnails/${p.basename(thumbs[i].path)}");
                                          } else {
                                            print(file!.path);
                                            await file.copy(
                                                "/storage/emulated/0/Bebuzee/Bebuzee Images/${p.basename(file.path)}");
                                          }
                                        }

                                        DirectApiCalls.uploadFiles(allData,
                                                files, widget.memberID!)
                                            .then((value) {
                                          DirectApiCalls.sendFcmRequest1(
                                              "Notification",
                                              "",
                                              type,
                                              widget.memberID!,
                                              widget.token!);
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
                                          _detailedRefresh.updateRefresh(true);
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

  HomepageRefreshState homeRefresh = new HomepageRefreshState();

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
                                        _messages.messages[0].isSending = true;
                                      });

                                      if (type == "video") {
                                        await video.copy(
                                            "/storage/emulated/0/Bebuzee/Bebuzee Videos/${p.basename(video.path)}");
                                        await file.copy(
                                            "/storage/emulated/0/Bebuzee/.thumbnails/${p.basename(file.path)}");
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

                                      DirectApiCalls.uploadFiles(
                                              data, allFiles, widget.memberID!)
                                          .then((value) {
                                        DirectApiCalls.sendFcmRequest1(
                                            "Notification",
                                            "",
                                            type,
                                            widget.memberID!,
                                            widget.token!);
                                        setState(() {
                                          _messages.messages.forEach((element) {
                                            setState(() {
                                              element.isVideoUploading = false;
                                              element.isSending = false;
                                            });
                                          });
                                        });
                                        refresh.updateRefresh(true);
                                        _detailedRefresh.updateRefresh(true);
                                      });
                                    },
                                    groupId: widget.memberID,
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
      searchText: AppLocalizations.of(
        "Search GIPHY",
      ),

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
      DirectApiCalls.sendGif(widget.memberID!,
          gif.images!.original!.webp.toString(), widget.token!, widget.name!);
    }
  }

  void _openCamera() {
    setState(() {
      attachmentsOpened = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatCameraScreen(
                  memberId: 's',
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
                      _messages.messages[0].isSending = true;
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
                    DirectApiCalls.uploadFiles(data, allFiles, widget.memberID!)
                        .then((value) {
                      DirectApiCalls.sendFcmRequest1("Notification", "", type,
                          widget.memberID!, widget.token!);
                      setState(() {
                        _messages.messages.forEach((element) {
                          setState(() {
                            element.isVideoUploading = false;
                            element.isSending = false;
                          });
                        });
                      });
                      refresh.updateRefresh(true);
                      _detailedRefresh.updateRefresh(true);
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
    DirectApiCalls().sendTextMessage(widget.memberID!, _message, widget.token!);

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

  void _replyMessage(String type, String imageURL, String originalMessage,
      String replyID, String filename, String videoTime, String name) async {
    if (_message == null || _message.isEmpty) return;

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
    DirectApiCalls().sendReplyMessage(widget.memberID!, _message, widget.token!,
        widget.name!, type, imageURL, originalMessage, replyID);
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
    DirectApiCalls()
        .sendLink(widget.memberID!, widget.token!, title, description, url[4],
            image, domain, widget.name!)
        .then((value) {
      setState(() {
        domain = "";
        description = "";
        title = "";
        image = "";
      });
    });
  }

  void _onLoading() async {
    ChatMessages? messagesData = await DirectApiCalls.onLoading(
        _messages, context, _refreshController, widget.memberID!);
    if (messagesData != null) {
      setState(() {
        _messages.messages.addAll(messagesData.messages);
      });
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890eiamdakk33r33433kkfwmkppvj58298ghha';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<String> _reloadChats() async {
    _chatMessages =
        DirectApiCalls.getAllChats(widget.memberID!, "").then((value) {
      setState(() {
        _messages.messages = value.messages.reversed.toList();
      });
      _loopTest();
      _getMediaFiles();
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
        DirectApiCalls.getAllChats(widget.memberID!, "").then((value) {
      setState(() {
        _messages.messages = value.messages.reversed.toList();
      });
      _loopTest();
      _selectAutomatically();
      _getMediaFiles();
      refresh.updateRefresh(true);
      _detailedRefresh.updateRefresh(true);

      return value;
    });
    return "success";
  }

  @override
  void initState() {
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
                description = value[1];
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
    saveImage();
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

  DirectRefresh refresh = DirectRefresh();
  DetailedDirectRefresh _detailedRefresh = DetailedDirectRefresh();
  List<GalleryThumbnails> assets = [];
  bool areAssetsLoaded = false;

  void _startRecording() async {
    bool result = await Record().hasPermission();

    print(result.toString() + " has permission");
    String filename = "${widget.name}_${generateRandomString(12)}.m4a";
    await Directory('/storage/emulated/0/Bebuzee/Bebuzee Voice/')
        .create(recursive: true);
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
      });
      _startTimer();
      print("Success");
      setState(() {
        voiceFile = filename;
      });
    });
  }

  Future<void> _sendVoiceRecording() async {
    String voicePath = "/storage/emulated/0/Bebuzee/Bebuzee Voice/$voiceFile";
    Record().stop().then((value) {
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
        _messages.messages[0].isSending = true;
      });

      DirectApiCalls()
          .uploadVoiceRecording(
              voicePath, widget.memberID!, voicePath, voiceDuration)
          .then((val) {
        DirectApiCalls.sendFcmRequest1(
            "Notification", "", "voice", widget.memberID!, widget.token!);

        setState(() {
          _messages.messages.forEach((element) {
            setState(() {
              element.isSending = false;
            });
          });
        });
        DirectApiCalls.getAllChats(widget.memberID!, "");
        refresh.updateRefresh(true);
        _detailedRefresh.updateRefresh(true);
      });
    });
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.all);
    final recentAlbum = albums.first;
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
          img.Image? src = img.decodeImage(pageImage.bytes);
          print(pageImage.bytes);
          thumb = new File(
              "/storage/emulated/0/Bebuzee/.thumbnails/${generateRandomString(10)}.jpg")
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
                  isPicked: 1,
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
          _messages.messages[0].isSending = true;
        });
      }

      DirectApiCalls.uploadFiles(
              allData.join("\$\$\$"), files, widget.memberID!)
          .then((value) {
        DirectApiCalls.sendFcmRequest1(
            "Notification", "", "file", widget.memberID!, widget.token!);
        setState(() {
          _messages.messages.forEach((element) {
            setState(() {
              element.isSending = false;
            });
          });
        });
        refresh.updateRefresh(true);
        // _detailedRefresh.updateRefresh(true);
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _onTapMessage(int i) async {
    String path = "";
    if (_messages.messages[i].you == 1) {
      path = _messages.messages[i].path!;
    } else {
      path = _messages.messages[i].receiverDevicePath!;
    }
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
          if (_messages.messages[i].isStar == 0) {}
        } else {
          print("removeee");
          messageID.removeWhere(
              (element) => element == _messages.messages[i].messageId);
          selectedMessages.removeWhere((element) =>
              element.messageId == _messages.messages[i].messageId);
          if (_messages.messages[i].isStar == 0) {}
        }
      });
    } else if (_messages.messages[i].receiverDownload == 1 &&
        _messages.messages[i].you == 0 &&
        _messages.messages[i].messageType != "contact" &&
        _messages.messages[i].messageType != "location" &&
        _messages.messages[i].messageType != "link") {
      print("exeeeeeeeee");

      if (_messages.messages[i].messageType == "image") {
        String path =
            "/storage/emulated/0/Bebuzee/Bebuzee Images/${_messages.messages[i].fileNameUploaded}";
        setState(() {
          _messages.messages[i].isDownloading = true;
        });
        await Dio().download(
            _messages.messages[i].imageData.replaceAll("resized/", ""), path,
            onReceiveProgress: (int sent, int total) {
          final progress = (sent / total) * 100;
          print('image download progress: $progress');
        });
        print(path);
        await ImageGallerySaver.saveFile(path).then((value) => {
              print("image saved"),
              if (mounted)
                {
                  setState(() {
                    _messages.messages[i].receiverDevicePath = path;
                    _messages..messages[i].receiverDownload = 0;
                  }),
                  DirectApiCalls()
                      .downloadFile(_messages.messages[i].messageId!, path,
                          path, widget.memberID!)
                      .then((value) {
                    setState(() {
                      _getMediaFiles();
                      _messages.messages[i].isDownloading = false;
                    });
                  })
                }
            });
      } else if (_messages.messages[i].messageType == "video") {
        String path =
            "/storage/emulated/0/Bebuzee/Bebuzee Videos/${_messages.messages[i].fileNameUploaded}";
        String thumb =
            "/storage/emulated/0/Bebuzee/.thumbnails/${_messages.messages[i].fileNameUploaded?.replaceAll(".mp4", ".jpg")}";
        setState(() {
          _messages.messages[i].isDownloading = true;
          _messages.messages[i].isVideoUploading = true;
        });
        await Dio().download(
            _messages.messages[i].url!.replaceAll(".mp4", ".jpg"), thumb);
        await Dio().download(
          _messages.messages[i].video!,
          path,
          onReceiveProgress: (int sent, int total) {
            final progress = (sent / total) * 100;
            print('video download progress: $progress');
          },
        );
        await ImageGallerySaver.saveFile(path);
        await ImageGallerySaver.saveFile(thumb);
        setState(() {
          _messages.messages[i].receiverThumbnail = thumb;
          _messages.messages[i].receiverDevicePath = path;
          _messages..messages[i].receiverDownload = 0;
        });
        DirectApiCalls()
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
        String savePath = "/storage/emulated/0/Bebuzee/Bebuzee Documents/" +
            "${_messages.messages[i].fileNameUploaded}";
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
        await ImageGallerySaver.saveFile(savePath).then((value) => {
              if (mounted)
                {
                  setState(() {
                    _messages.messages[i].receiverDownload = 0;
                    _messages.messages[i].receiverDevicePath = savePath;
                  }),
                }
            });
        DirectApiCalls()
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
        String savePath = "/storage/emulated/0/Bebuzee/Bebuzee Audio/" +
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
        await ImageGallerySaver.saveFile(savePath).then((value) => {
              if (mounted)
                {
                  setState(() {
                    _messages.messages[i].receiverDownload = 0;
                    _messages.messages[i].receiverDevicePath = savePath;
                  }),
                }
            });
        DirectApiCalls()
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
        String savePath = "/storage/emulated/0/Bebuzee/Bebuzee Voice/" +
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
        await ImageGallerySaver.saveFile(savePath).then((value) => {
              if (mounted)
                {
                  setState(() {
                    _messages.messages[i].receiverDownload = 0;
                    _messages.messages[i].receiverDevicePath = savePath;
                  }),
                }
            });
        DirectApiCalls()
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
      if (!File(path).existsSync()) {
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
      if (!File(path).existsSync()) {
        print("no media");
        simpleDialog(
            context,
            "Sorry this media file doesn't exist on your internal storage.",
            "OK");
      } else {
        OpenFile.open(_messages.messages[i].path);
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

  ChatMessages _mediaMessages = new ChatMessages([]);

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

    print(_mediaMessages.messages.length.toString() + " media length");
  }

  Future<void> getLocalChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("chats" + widget.memberID!);
    if (chatData != null) {
      _chatMessages =
          DirectApiCalls.getAllChatsLocal(widget.memberID!).then((value) {
        setState(() {
          _messages.messages = value!.messages.reversed.toList();
        });
        _selectAutomatically();
        _loopTest();
        _getMediaFiles();
        return value!;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: _detailedRefresh.currentSelect,
        stream: _detailedRefresh.observableCart,
        builder: (context, dynamic snapshot) {
          if (snapshot.data) {
            print("refresh direct list");
            _reloadChats();
            _detailedRefresh.updateRefresh(false);
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              brightness: Brightness.light,
              elevation: 0.5,
              backgroundColor: Colors.grey.shade100,
              //flexibleSpace: gradientContainer(null),
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
                            color: directAppBarIconColor,
                          ),
                          CircleAvatar(
                            radius: 15.0,
                            backgroundImage: NetworkImage(widget.image!),
                          ),
                        ],
                      ),
                    )
                  : AppBarIcon(
                      iconData: Icons.arrow_back,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
              title: messageID.length == 0
                  ? Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        highlightColor: highlightColor,
                        splashColor: secondaryColor,
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 100.0.w - 235,
                              height: 56,
                              child: StreamBuilder<Object>(
                                  initialData: _status.currentSelect,
                                  stream: _status.observableCart,
                                  builder: (context, snapshot) {
                                    String status = "Online";
                                    if (snapshot.data == true) {
                                      status = "Online";
                                    } else {
                                      status = "";
                                    }

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name!,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        snapshot.data.toString() != ""
                                            ? Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Text(
                                                    status,
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 13,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: Text(
                        messageID.length.toString(),
                        style: TextStyle(
                            color: directAppBarIconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
              actions: messageID.length != 0
                  ? [
                      messageID.length == 1
                          ? AppBarIcon(
                              size: 20,
                              iconData: CustomIcons.backward,
                              onPressed: () {
                                setState(() {
                                  replyIndex = _messages.messages.indexWhere(
                                      (element) => element.isSelected == true);
                                  isReply = true;
                                });
                              })
                          : Container(),
                      messageID.length == 1 && selectedMessages[0].you == 1
                          ? AppBarIcon(
                              iconData: Icons.info_outline,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MessageInfoPage(
                                              message: selectedMessages[0],
                                            )));
                              })
                          : Container(),
                      messageID.length > 0
                          ? AppBarIcon(
                              iconData: Icons.delete,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog

                                    return DeleteMessagePopup(
                                      isyou: isyou,
                                      title: messageID.length == 1
                                          ? AppLocalizations.of(
                                              "Delete message?",
                                            )
                                          : "Delete ${messageID.length.toString()} messages?",
                                      deleteForMe: () {
                                        DirectApiCalls().deleteMessages(
                                            messageID.join(","),
                                            widget.memberID!);
                                        Navigator.pop(context);
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
                                      },
                                      deleteForAll: () {
                                        Navigator.pop(context);
                                        print(messageID.join("~~~"));
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
                                        DirectApiCalls()
                                            .deleteMessagesEveryone(
                                                messageID.join(","),
                                                widget.memberID!,
                                                widget.token!)
                                            .then((value) {
                                          setState(() {
                                            messageID = [];
                                            messageID.length = 0;
                                            selectedMessages = [];
                                          });
                                        });
                                      },
                                    );
                                  },
                                );
                              })
                          : Container(),
                      messageID.length > 0
                          ? AppBarIcon(iconData: Icons.copy, onPressed: () {})
                          : Container(),
                      messageID.length > 0
                          ? AppBarIcon(
                              iconData: CustomIcons.forward_new,
                              size: 20,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForwardMessageDirectPage(
                                              messageIDs: messageID,
                                            )));
                              })
                          : Container(),
                    ]
                  : [
                      AppBarIcon(
                          iconData: Icons.videocam,
                          onPressed: () async {
                            await getPermission();

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => PlayVideoCallScreen(
                            //         name: widget.name ?? "",
                            //         oppositeMemberId:
                            //         widget.memberID ?? "",
                            //         userImage: widget.image ?? "",
                            //         callType: CallType.audio,
                            //         usertok: widget.token,
                            //       )
                            //
                            //     //  JoinChannelAudio(
                            //     //   img: widget.image,
                            //     //   isFromHome: false,
                            //     //   callFromButton: true,
                            //     //   token: widget.token,
                            //     //   name: widget.name,
                            //     //   oppositeMemberId: widget.memberID,
                            //     // ),
                            //
                            //   ),
                            // );
                            // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Video Call Button tapped')));
                          }),
                      AppBarIcon(
                          iconData: Icons.call,
                          onPressed: () async {
                            print("boubia Calltype=audio");

                            if (await Permission.phone.request().isGranted) {
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
                            }

                            // await sendPushMessage(isVideo: false);

                            // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Call Button tapped')));
                          }),
                      PopupMenuButton<ChatDetailMenuOptions>(
                        icon:
                            Icon(Icons.more_vert, color: directAppBarIconColor),
                        color: Colors.white,
                        tooltip: AppLocalizations.of("More options"),
                        onSelected: _onSelectMenuOption,
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<ChatDetailMenuOptions>(
                              child: Text(AppLocalizations.of("Clear chat")),
                              value: ChatDetailMenuOptions.delete,
                            ),
                          ];
                        },
                      )
                    ],
            ),
            body: WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                DirectApiCalls.fcmOnlineStatus("Online");
                if (widget.from == "profile") {
                  widget.setNavbar!(false);
                }
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
                                    controller: controller,
                                    itemCount: _messages.messages.length,
                                    reverse: true,
                                    itemBuilder: (context, int index) {
                                      return SwipeTo(
                                        iconColor: Colors.transparent,
                                        onRightSwipe: () {
                                          if (_messages.messages[index].you ==
                                                  1 ||
                                              _messages.messages[index].you ==
                                                  0) {
                                            setState(() {
                                              replyIndex = index;
                                              isReply = true;
                                            });
                                          }
                                        },
                                        child: MessageItemDirect(
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
                                            }),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
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
                                          children: <Widget>[
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
                                            Container(
                                              decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                                shape: BoxShape.rectangle,
                                                color: Colors.grey.shade200,
                                              ),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 23,
                                                    backgroundColor: darkColor,
                                                    child: IconButton(
                                                      splashRadius: 10,
                                                      color: Colors.white,
                                                      icon: Icon(
                                                          Icons.camera_alt),
                                                      onPressed: () {
                                                        _openCamera();
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
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
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        hintText:
                                                            AppLocalizations.of(
                                                          'Message',
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color:
                                                              textFieldHintColor,
                                                          fontSize: 16.0,
                                                        ),
                                                        counterText: '',
                                                      ),
                                                      onSubmitted:
                                                          (String text) {
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
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: null,
                                                    ),
                                                  ),
                                                  textFieldController
                                                          .text.isNotEmpty
                                                      ? Container(
                                                          child: TextButton(
                                                            onPressed: () {
                                                              if (showLinkPreview) {
                                                                _sendLink();
                                                              } else if (isReply) {
                                                                print(
                                                                    "isReplyyyyyy");

                                                                String you = "";
                                                                if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .you ==
                                                                    1) {
                                                                  you = "You";
                                                                } else {
                                                                  you = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .username!;
                                                                }

                                                                String message =
                                                                    "";
                                                                if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "location") {
                                                                  message = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .locationTitle!;
                                                                } else if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "contact") {
                                                                  message =
                                                                      "Contact: ${_messages.messages[replyIndex].contactName}";
                                                                } else if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "audio") {
                                                                  message =
                                                                      "Audio (${_messages.messages[replyIndex].audioDuration})";
                                                                } else if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "voice") {
                                                                  message =
                                                                      "Voice message (${_messages.messages[replyIndex].audioDuration})";
                                                                } else {
                                                                  message = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .message!;
                                                                }

                                                                String
                                                                    imageUrl =
                                                                    "";
                                                                if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "image") {
                                                                  imageUrl = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .imageData
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "/resized",
                                                                          "");
                                                                } else if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "video") {
                                                                  imageUrl = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .videoImage!
                                                                      .replaceAll(
                                                                          ".mp4",
                                                                          ".jpg");
                                                                } else if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "location") {
                                                                  imageUrl = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .url!
                                                                      .replaceAll(
                                                                          "/resized",
                                                                          "");
                                                                } else if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "link") {
                                                                  imageUrl = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .message!
                                                                      .split(
                                                                          "~~~")[2];
                                                                } else {
                                                                  imageUrl = "";
                                                                }

                                                                String
                                                                    videoTime =
                                                                    "";
                                                                if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "video") {
                                                                  videoTime = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .videoPlaytime!;
                                                                }
                                                                String
                                                                    fileName =
                                                                    "";
                                                                if (_messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType ==
                                                                    "file") {
                                                                  fileName = _messages
                                                                      .messages[
                                                                          replyIndex]
                                                                      .fileNameUploaded!;
                                                                }
                                                                _replyMessage(
                                                                    _messages
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageType!,
                                                                    imageUrl,
                                                                    message,
                                                                    _messages!
                                                                        .messages[
                                                                            replyIndex]
                                                                        .messageId!,
                                                                    fileName,
                                                                    videoTime,
                                                                    you);
                                                              } else {
                                                                _sendMessage();
                                                              }
                                                            },
                                                            child: Text(
                                                              AppLocalizations
                                                                  .of(
                                                                "Send",
                                                              ),
                                                              style: TextStyle(
                                                                  color:
                                                                      darkColor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        )
                                                      : Row(
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                bool result =
                                                                    await Record()
                                                                        .hasPermission();
                                                                if (result) {
                                                                  _startRecording();
                                                                  setState(() {
                                                                    height = 30;
                                                                  });
                                                                } else {
                                                                  customToastWhite(
                                                                      AppLocalizations
                                                                          .of(
                                                                        "Please enable microphone permission from settings",
                                                                      ),
                                                                      14.0,
                                                                      ToastGravity
                                                                          .BOTTOM);
                                                                }
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .settings_voice,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              splashRadius: 10,
                                                              color: Colors
                                                                  .black87,
                                                              icon: Icon(Icons
                                                                  .attach_file),
                                                              onPressed: () {
                                                                setState(() {
                                                                  attachmentsOpened =
                                                                      !attachmentsOpened;
                                                                });
                                                              },
                                                            ),
                                                            IconButton(
                                                              splashRadius: 10,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0.0),
                                                              disabledColor:
                                                                  Colors
                                                                      .black87,
                                                              color: Colors
                                                                  .black87,
                                                              icon: Icon(Icons
                                                                  .insert_emoticon),
                                                              onPressed:
                                                                  () async {
                                                                await SystemChannels
                                                                    .textInput
                                                                    .invokeMethod(
                                                                        'TextInput.hide');
                                                                await Future.delayed(
                                                                    Duration(
                                                                        milliseconds:
                                                                            100));
                                                                _gif();
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(
                                          decoration: new BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            shape: BoxShape.rectangle,
                                            color: Colors.grey.shade200,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 23,
                                                    backgroundColor: darkColor,
                                                    child: IconButton(
                                                        splashRadius: 10,
                                                        color: Colors.white,
                                                        icon:
                                                            Icon(Icons.delete),
                                                        onPressed: () async {
                                                          Record()
                                                              .stop()
                                                              .then((value) {
                                                            setState(() {
                                                              voiceDuration =
                                                                  _setDuration();
                                                              isRecording =
                                                                  false;
                                                            });
                                                            _endTimer();
                                                          });
                                                        }),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
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
                                              TextButton(
                                                onPressed: () async {
                                                  bool result = await Record()
                                                      .hasPermission();
                                                  if (result) {
                                                    _sendVoiceRecording();
                                                  }
                                                },
                                                child: Text(
                                                  AppLocalizations.of(
                                                    "Send",
                                                  ),
                                                  style: TextStyle(
                                                      color: darkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
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

                                            DirectApiCalls()
                                                .sendLocation(
                                                    widget.memberID!,
                                                    latitude.toString(),
                                                    longitude.toString(),
                                                    title,
                                                    subtitle,
                                                    path,
                                                    widget.token!)
                                                .then((val) {
                                              DirectApiCalls.sendFcmRequest1(
                                                  "Notification",
                                                  "Location",
                                                  "location",
                                                  widget.memberID!,
                                                  widget.token!);

                                              refresh.updateRefresh(true);
                                              _detailedRefresh
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

                                              DirectApiCalls().sendContacts(
                                                  widget.memberID!,
                                                  contactData.join("\$\$\$"),
                                                  widget.token!);
                                            },
                                          )));
                            } else {
                              customToastWhite(
                                  AppLocalizations.of(
                                    "Please enable contact permission from settings",
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
                                                _messages.messages[0]
                                                    .isSending = true;
                                              });
                                            }

                                            DirectApiCalls()
                                                .uploadAudioFiles(
                                                    audioFiles,
                                                    widget.memberID!,
                                                    savedPaths.join("\$\$\$"),
                                                    durations.join("\$\$\$"))
                                                .then((val) {
                                              DirectApiCalls.sendFcmRequest1(
                                                  "Notification",
                                                  "",
                                                  "audio",
                                                  widget.memberID!,
                                                  widget.token!);
                                              setState(() {
                                                _messages.messages
                                                    .forEach((element) {
                                                  setState(() {
                                                    element.isSending = false;
                                                  });
                                                });
                                              });
                                              DirectApiCalls.getAllChats(
                                                  widget.memberID!, "");
                                              refresh.updateRefresh(true);
                                              _detailedRefresh
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
          );
        });
  }

  getPermission() async {
    bool locationResult = await Permissions().getCameraPermission();
    if (locationResult) {
      // await sendPushMessage(isVideo: true);
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

  late PermissionStatus _permissionGranted;
  // final Permission  pemission1;
  dynamic permissionhandle;

// Future<void> _checkPermissions()  async {
//   Permission.microphone;
//   //final PermissionStatus permissionGrantedResult = await Permission.microphone;
//  permissionhandle=await Permission.microphone;

//   setState(() {
//     _permissionGranted = permissionGrantedResult;
//   });
// }

  void newdata() {
    if (permissionhandle.isGranted) {}
  }

// Future<void> _requestPermission()  async {
//   if(_permissionGranted != PermissionStatus.granted){
//     final PermissionStatus permissionRequestedResult  = await call.requestPermission();
//   }

//   setState(() {
//     _permissionGranted = permissionRequestedResult;
//   });
// }
}
