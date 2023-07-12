import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/userDetailModel.dart';

// import 'package:audioplayers/audio_cache.dart' as ac;
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Chat/forward_message_chat.dart';
import 'package:bizbultest/widgets/Chat/link_preview.dart';
import 'package:bizbultest/widgets/Chat/reply_message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';

enum FontSize {
  Small,
  Medium,
  Large,
}

class MessageItem extends StatefulWidget {
  final ChatMessagesModel? message;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? image;
  final int? index;
  final AutoScrollController? controller;
  final String? dir;
  final DirectMessageUserListModel? user;
  ChatMessages? users;

  MessageItem({
    this.onTap,
    this.onLongPress,
    this.message,
    this.image,
    this.user,
    this.index,
    this.controller,
    this.dir,
  });

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem>
    with SingleTickerProviderStateMixin {
  ap.AudioPlayer player = ap.AudioPlayer();

  late AnimationController _animationController;

  Widget _storyCard(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            text,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
        Container(
            height: 220,
            width: 180,
            child: Image(
              image: CachedNetworkImageProvider(
                widget.message!.url!
                    .replaceAll(
                      ".mp4",
                      ".jpg",
                    )
                    .replaceAll("/compressed", ""),
              ),
              fit: BoxFit.cover,
              height: 220,
              width: 180,
            )),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 170,
            child: Text(
              widget.message!.message!,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _gifCard() {
    return Container(
      child: Image(
        image: CachedNetworkImageProvider(widget.message!.imageData),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _replyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ReplyMessageCard(
          message: widget.message!,
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: _textCard(""),
        ),
      ],
    );
  }

  Widget _linkCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinkPreview(
          showClose: 0,
          title: widget.message!.message!.split("~~~")[0],
          domain: widget.message!.message!.split("~~~")[3],
          description: widget.message!.message!.split("~~~")[1],
          image: widget.message!.message!.split("~~~")[2],
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            widget.message!.message!.split("~~~")[4],
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        )
      ],
    );
  }

  Widget _textCard(String match) {
    if (widget.message!.message == "❤️" || widget.message!.message == "❤") {
      return FadeTransition(
        opacity: _animationController,
        child: Text(
          widget.message!.message!,
          style: TextStyle(fontSize: 70, fontStyle: FontStyle.normal),
          textAlign: TextAlign.start,
        ),
      );
    } else {
      return Text(
        widget.message!.message!,
        style: TextStyle(
            color: widget.message!.message == match
                ? Colors.black54
                : Colors.black,
            fontSize: enumFontSize == FontSize.Small
                ? 14
                : enumFontSize == FontSize.Medium
                    ? 16
                    : 20,
            fontStyle: widget.message!.message == match
                ? FontStyle.italic
                : FontStyle.normal),
        textAlign: TextAlign.start,
      );
    }
  }

  Widget _networkImageCard(String image, double h, double w) {
    return Container(
      height: h,
      width: w,
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: Image.network(
          image,
          colorBlendMode: BlendMode.softLight,
          fit: BoxFit.cover,
          height: h,
          width: w,
        ),
      ),
    );
  }

  Widget _localImageCard(String path, double h, double w) {
    return Container(
      height: h,
      width: w,
      child: Image.file(
        File(path),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _imageCard(String path, String image) {
    if (File(path).existsSync()) {
      return _localImageCard(path, 300, 300);
    } else {
      return _networkImageCard(image, 300, 300);
    }
  }

  Widget _videoCard(String thumbPath, String videoPath, String image) {
    if (!File(thumbPath).existsSync() &&
        !File(videoPath).existsSync() &&
        widget.message!.isVideoUploading == false) {
      return _networkImageCard(image, 300, 300);
    } else if (!File(thumbPath).existsSync() &&
        widget.message!.isVideoUploading == false) {
      print("22222222222222222");
      print(thumbPath);
      return Image.network(
        image,
        fit: BoxFit.cover,
        height: 300,
        width: 300,
      );
    } else if (!File(videoPath).existsSync() &&
        widget.message!.isVideoUploading == false) {
      print("33333333333333");
      return _networkImageCard(image, 300, 300);
    } else {
      return _localImageCard(thumbPath, 300, 300);
    }
  }

  Widget _downloadIndicatorMedia() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.center,
            child: Container(
                decoration: new BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Icon(
                    Icons.download_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ))));
  }

  Widget _downloadIndicatorFile() {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          Icons.download_rounded,
          color: Colors.grey,
          size: 23,
        ),
      ),
    );
  }

  Widget _blurredImageCard(String image) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Container(
        child: Image.network(image,
            fit: BoxFit.cover, colorBlendMode: BlendMode.softLight),
      ),
    );
  }

  Widget _playArrow() {
    return Container(
        decoration: new BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Icon(
            Icons.play_arrow,
            size: 30,
            color: Colors.white,
          ),
        ));
  }

  Widget _contactCardBottom() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.message!.you == 1
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        height: 0.3,
                        color: Colors.grey,
                        width: 250,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(
                        "Message",
                      ),
                      style: TextStyle(
                          color: darkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        height: 0.3,
                        color: Colors.grey,
                        width: 250,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            AppLocalizations.of(
                              "Message",
                            ),
                            style: TextStyle(
                                color: darkColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 22,
                          color: Colors.grey,
                          width: 0.3,
                        ),
                        GestureDetector(
                          onTap: () async {
                            print("save contact");
                            await ContactsService.addContact(new Contact(
                              givenName: widget.message!.contactName,
                              phones: [
                                Item(
                                    label: widget.message!.contactType,
                                    value: widget.message!.contactNumber)
                              ],
                            )).then((value) {
                              customToastWhite(
                                  AppLocalizations.of(
                                    "Contact Saved Successfully",
                                  ),
                                  14.0,
                                  ToastGravity.BOTTOM);
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                AppLocalizations.of(
                                  "Add Contact",
                                ),
                                style: TextStyle(
                                    color: darkColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _contactCard() {
    return Container(
      width: 250,
      child: Row(
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.account_circle,
                  size: 50.0,
                ),
                color: darkColor,
                onPressed: () {}),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: 180,
            child: Text(
              widget.message!.contactName!,
              style: TextStyle(
                  color: darkColor, fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Container(
        child: Text(
          action,
          style: TextStyle(
            color: Colors.white,
            fontSize: enumFontSize == FontSize.Small
                ? 14
                : enumFontSize == FontSize.Medium
                    ? 16
                    : 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _locationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          width: 280,
          child: Image.network(
            widget.message!.url!,
            fit: BoxFit.cover,
          ),
        ),
        widget.message!.locationTitle != ""
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message!.locationTitle!,
                        style: TextStyle(
                            fontSize: 16,
                            color: darkColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.message!.locationSubtitle!,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Widget _fileSymbol() {
    return Stack(
      children: [
        Icon(
          Icons.insert_drive_file_rounded,
          color: Colors.red.shade600,
          size: 32,
        ),
        Positioned.fill(
          bottom: 4,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.message!.fileTypeExtension!.toUpperCase(),
                style: whiteBold.copyWith(fontSize: 9),
              )),
        )
      ],
    );
  }

  Widget _forwardArrowYou() {
    if ((widget.message!.messageType == "video" ||
            widget.message!.messageType == "image" ||
            widget.message!.messageType == "file") &&
        !File(widget.message!.path!).existsSync()) {
      return Container();
    } else {
      return Container(
        decoration: new BoxDecoration(
            shape: BoxShape.circle, color: Colors.grey.withOpacity(0.5)),
        child: IconButton(
          onPressed: () {
            List<String> id = [];
            id.add(widget.message!.messageId!);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForwardMessageChatPage(
                          messageIDs: id,
                        )));
          },
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(5),
          icon: Icon(
            CustomIcons.forward_new,
            color: Colors.white,
            size: 18,
          ),
        ),
      );
    }
  }

  Widget _forwardArrowOther() {
    if ((widget.message!.messageType == "video" ||
            widget.message!.messageType == "image" ||
            widget.message!.messageType == "file" &&
                widget.message!.receiverDownload == 0) &&
        !File(widget.message!.receiverDevicePath!).existsSync()) {
      return Container();
    } else {
      return Container(
          decoration: new BoxDecoration(
              shape: BoxShape.circle, color: Colors.grey.withOpacity(0.5)),
          child: IconButton(
              onPressed: () {
                List<String> id = [];
                id.add(widget.message!.messageId!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForwardMessageChatPage(
                              messageIDs: id,
                            )));
              },
              constraints: BoxConstraints(),
              padding: EdgeInsets.all(5),
              icon: Icon(
                CustomIcons.forward_new,
                color: Colors.white,
                size: 18,
              )));
    }
  }

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    getUserData();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  UserDetailModel objUserDetailModel = new UserDetailModel();
  FontSize enumFontSize = FontSize.Small;

  getUserData() async {
    String uid = CurrentUser().currentUser.memberID!;
    objUserDetailModel = await ApiProvider().getUserDetail(uid);
    if (objUserDetailModel != null &&
        objUserDetailModel.memberId != null &&
        objUserDetailModel.memberId != "") {
      print("Get User Data");
      if (objUserDetailModel.fontsize!.toLowerCase() == "small") {
        enumFontSize = FontSize.Small;
      } else if (objUserDetailModel.fontsize!.toLowerCase() == "medium") {
        enumFontSize = FontSize.Medium;
      } else {
        enumFontSize = FontSize.Large;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        color: widget.message!.isSelected!
            ? darkColor.withOpacity(0.2)
            : Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: widget.message!.you == 1
              ? MainAxisAlignment.end
              : widget.message!.you == 2 || widget.message!.you == 4
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
          children: [
            widget.message!.you == 1 &&
                    widget.message!.messageType != "text" &&
                    widget.message!.messageType != "reply"
                ? _forwardArrowYou()
                : Container(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: widget.message!.you == 1
                  ? MainAxisAlignment.end
                  : widget.message!.you == 2 || widget.message!.you == 4
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: widget.message!.messageType == "gif_url"
                              ? null
                              : [
                                  new BoxShadow(
                                      color: Colors.grey,
                                      offset: new Offset(1.0, 1.0),
                                      blurRadius: 1.0)
                                ],
                          color: widget.message!.you == 1 &&
                                  widget.message!.messageType != "gif_url"
                              ? messageBubbleColor
                              : (widget.message!.you == 2 ||
                                          widget.message!.you == 4) &&
                                      widget.message!.messageType != "gif_url"
                                  ? darkColor.withOpacity(0.6)
                                  : widget.message!.messageType == "gif_url"
                                      ? Colors.transparent
                                      : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      constraints: BoxConstraints(
                        minWidth: 80.0,
                        maxWidth: widget.message!.messageType == "link" ||
                                widget.message!.messageType == "reply"
                            ? 80.0.w
                            : 280.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            widget.message!.you == 2 || widget.message!.you == 4
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.end,
                        children: <Widget>[
                          widget.message!.you == 0
                              ? Container(
                                  constraints: BoxConstraints(
                                    minWidth: 80.0,
                                  ),
                                  child: widget.message!.messageType == "image"
                                      ? ClipRRect(
                                          child: Stack(
                                            children: [
                                              Container(
                                                  height: 300,
                                                  width: 300,
                                                  child: widget.message!
                                                              .receiverDownload ==
                                                          0
                                                      ? _imageCard(
                                                          widget.message!
                                                              .receiverDevicePath!,
                                                          widget.message!
                                                              .imageData
                                                              .toString()
                                                              .replaceAll(
                                                                  "/resized",
                                                                  ""))
                                                      : _blurredImageCard(widget
                                                          .message!.imageData
                                                          .toString()
                                                          .replaceAll(
                                                              "/resized", ""))),
                                              widget.message!.receiverDownload ==
                                                          1 &&
                                                      widget.message!
                                                              .isDownloading ==
                                                          false
                                                  ? _downloadIndicatorMedia()
                                                  : Container(),
                                              widget.message!.isDownloading!
                                                  ? Positioned.fill(
                                                      child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: downloadIndicator(
                                                              widget.message!
                                                                  .downloadProgress!)))
                                                  : Container()
                                            ],
                                          ),
                                        )
                                      : widget.message!.messageType == "video"
                                          ? Container(
                                              height: 300,
                                              width: 300,
                                              child: ClipRRect(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 300,
                                                      width: 300,
                                                      child: widget.message!
                                                                  .receiverDownload ==
                                                              0
                                                          ? _videoCard(
                                                              widget.message!
                                                                  .receiverThumbnail!,
                                                              widget.message!
                                                                  .receiverDevicePath!,
                                                              widget.message!
                                                                  .videoImage!
                                                                  .replaceAll(
                                                                      ".mp4",
                                                                      ".jpg"))
                                                          : Container(
                                                              child: _blurredImageCard(widget
                                                                  .message!.url!
                                                                  .replaceAll(
                                                                      ".mp4",
                                                                      ".jpg"))),
                                                    ),
                                                    widget.message!.receiverDownload ==
                                                                1 &&
                                                            widget.message!
                                                                    .isDownloading ==
                                                                false
                                                        ? _downloadIndicatorMedia()
                                                        : Container(),
                                                    widget.message!
                                                                .receiverDownload ==
                                                            0
                                                        ? Positioned.fill(
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: !widget
                                                                        .message!
                                                                        .isVideoUploading!
                                                                    ? _playArrow()
                                                                    : customCircularIndicator(
                                                                        3,
                                                                        Colors
                                                                            .white)),
                                                          )
                                                        : Container(),
                                                    widget.message!
                                                            .isDownloading!
                                                        ? Positioned.fill(
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: downloadIndicator(
                                                                    widget
                                                                        .message!
                                                                        .downloadProgress!)),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              ),
                                            )
                                          : widget.message!.messageType ==
                                                  "file"
                                              ? Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      widget.message!
                                                                  .fileTypeExtension ==
                                                              "pdf"
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                              child: Container(
                                                                height: 100,
                                                                width: 280,
                                                                child: Image
                                                                    .network(
                                                                  widget
                                                                      .message!
                                                                      .pdfImage!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ))
                                                          : Container(),
                                                      Container(
                                                        color: darkColor
                                                            .withOpacity(0.1),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      5),
                                                          child: Row(
                                                            children: [
                                                              _fileSymbol(),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                width: widget
                                                                            .message!
                                                                            .receiverDownload ==
                                                                        1
                                                                    ? 175
                                                                    : 200,
                                                                child: Text(
                                                                  widget
                                                                      .message!
                                                                      .fileNameUploaded!
                                                                      .split(
                                                                          "/")
                                                                      .last,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              widget.message!
                                                                          .receiverDownload ==
                                                                      1
                                                                  ? SizedBox(
                                                                      child: widget
                                                                              .message!
                                                                              .isDownloading!
                                                                          ? Container(
                                                                              child: downloadIndicator(widget.message!.downloadProgress!))
                                                                          : _downloadIndicatorFile(),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : widget.message!.messageType ==
                                                      "audio"
                                                  ? AudioCardReceiver(
                                                      duration: widget.message!
                                                          .audioDuration,
                                                      receiverDownload: widget
                                                          .message!
                                                          .receiverDownload,
                                                      receiverPath: widget
                                                          .message!
                                                          .receiverDevicePath,
                                                      url: widget.message!.url,
                                                      sentNow: widget
                                                          .message!.sentNow,
                                                      path:
                                                          widget.message!.path!,
                                                      message: widget.message!,
                                                      isDownloading: widget
                                                          .message!
                                                          .isDownloading,
                                                    )
                                                  : widget.message!
                                                              .messageType ==
                                                          "voice"
                                                      ? VoiceCardReceiver(
                                                          downloadProgress: widget
                                                              .message!
                                                              .downloadProgress,
                                                          path: widget.message!
                                                              .receiverDevicePath!,
                                                          image: widget.image!,
                                                          isSending: widget
                                                              .message!
                                                              .isSending!,
                                                          duration: widget
                                                              .message!
                                                              .audioDuration!,
                                                          isDownloading: widget
                                                              .message!
                                                              .isDownloading!,
                                                          receiverDownload: widget
                                                              .message!
                                                              .receiverDownload!,
                                                        )
                                                      : widget.message!
                                                                  .messageType ==
                                                              "contact"
                                                          ? _contactCard()
                                                          : widget.message!
                                                                      .messageType ==
                                                                  "location"
                                                              ? _locationCard()
                                                              : widget.message!
                                                                          .messageType ==
                                                                      "story"
                                                                  ? _storyCard(
                                                                      "Replied to your story")
                                                                  : widget.message!
                                                                              .messageType ==
                                                                          "link"
                                                                      ? _linkCard()
                                                                      : widget.message!.messageType ==
                                                                              "reply"
                                                                          ? _replyCard()
                                                                          : widget.message!.messageType == "gif_url"
                                                                              ? _gifCard()
                                                                              : _textCard("This message was deleted"))
                              : widget.message!.you == 2
                                  ? _actionCard(widget.message!.message!.toUpperCase())
                                  : widget.message!.you == 4
                                      ? _actionCard(widget.message!.message!)
                                      : Container(
                                          constraints: BoxConstraints(
                                            minWidth: 80.0,
                                          ),
                                          child: widget.message!.messageType == "image"
                                              ? ClipRRect(
                                                  child: Container(
                                                    height: 300,
                                                    width: 300,
                                                    child: Stack(
                                                      children: [
                                                        _imageCard(
                                                            widget.message!
                                                                .fileNameUploaded!,
                                                            widget.message!
                                                                .imageData
                                                                .toString()
                                                                .replaceAll(
                                                                    "/resized",
                                                                    "")),
                                                        widget.message!
                                                                .isSending!
                                                            ? Positioned.fill(
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: customCircularIndicator(
                                                                        3,
                                                                        Colors
                                                                            .white)),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : widget.message!.messageType == "video"
                                                  ? ClipRRect(
                                                      child: Container(
                                                        height: 300,
                                                        width: 300,
                                                        child: Stack(
                                                          children: [
                                                            _videoCard(
                                                                widget.message!
                                                                    .thumbPath!,
                                                                widget.message!
                                                                    .path!,
                                                                widget.message!
                                                                            .videoImage !=
                                                                        null
                                                                    ? widget
                                                                        .message!
                                                                        .videoImage!
                                                                        .replaceAll(
                                                                            ".mp4",
                                                                            ".jpg")
                                                                    : ""),
                                                            Positioned.fill(
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: !widget
                                                                          .message!
                                                                          .isVideoUploading!
                                                                      ? _playArrow()
                                                                      : customCircularIndicator(
                                                                          3,
                                                                          Colors
                                                                              .white)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : widget.message!.messageType == "file"
                                                      ? Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                child: widget
                                                                            .message!
                                                                            .fileTypeExtension ==
                                                                        "pdf"
                                                                    ? Container(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            280,
                                                                        child:
                                                                            PdfCardLocal(
                                                                          message:
                                                                              widget.message!,
                                                                          sentNow: widget
                                                                              .message!
                                                                              .sentNow!,
                                                                          path: widget
                                                                              .message!
                                                                              .thumbPath!,
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ),
                                                              Container(
                                                                color: darkColor
                                                                    .withOpacity(
                                                                        0.1),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          5),
                                                                  child: Row(
                                                                    children: [
                                                                      _fileSymbol(),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width: widget.message!.isSending ==
                                                                                true
                                                                            ? 175
                                                                            : 200,
                                                                        child:
                                                                            Text(
                                                                          widget
                                                                              .message!
                                                                              .fileNameUploaded!
                                                                              .split("/")
                                                                              .last,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w400),
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                      widget.message!
                                                                              .isSending!
                                                                          ? customCircularIndicator(
                                                                              0,
                                                                              Colors.grey.shade600)
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : widget.message!.messageType == "audio"
                                                          ? AudioCardSender(
                                                              duration: widget
                                                                  .message!
                                                                  .audioDuration!,
                                                              sentNow: widget
                                                                  .message!
                                                                  .sentNow!,
                                                              path: widget
                                                                  .message!
                                                                  .path!,
                                                              message: widget
                                                                  .message!,
                                                            )
                                                          : widget.message!.messageType == "voice"
                                                              ? VoiceCardSender(
                                                                  path: widget
                                                                      .message!
                                                                      .path!,
                                                                  isSending: widget
                                                                      .message!
                                                                      .isSending!,
                                                                  duration: widget
                                                                      .message!
                                                                      .audioDuration!,
                                                                )
                                                              : widget.message!.messageType == "contact"
                                                                  ? _contactCard()
                                                                  : widget.message!.messageType == "location"
                                                                      ? Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              height: 150,
                                                                              width: 280,
                                                                              child: Image.file(
                                                                                File(widget.message!.path!),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                            widget.message!.locationTitle != ""
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                                                                    child: Container(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            widget.message!.locationTitle!,
                                                                                            style: TextStyle(fontSize: 16, color: darkColor, fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                          Text(
                                                                                            widget.message!.locationSubtitle!,
                                                                                            style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.normal),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Container()
                                                                          ],
                                                                        )
                                                                      : widget.message!.messageType == "story"
                                                                          ? _storyCard("You replied to their story")
                                                                          : widget.message!.messageType == "link"
                                                                              ? _linkCard()
                                                                              : widget.message!.messageType == "reply"
                                                                                  ? _replyCard()
                                                                                  : widget.message!.messageType == "gif_url"
                                                                                      ? _gifCard()
                                                                                      : _textCard("You deleted this message")),
                          SizedBox(
                            height: widget.message!.you == 2 ||
                                    widget.message!.you == 4
                                ? 0
                                : 5,
                          ),
                          (widget.message!.messageType == "image" ||
                                      widget.message!.messageType == "video") &&
                                  widget.message!.message != ""
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 260.0,
                                      ),
                                      width: 260,
                                      child: Text(
                                        widget.message!.message!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize:
                                (widget.message!.messageType == "video" &&
                                            widget.message!.you == 0) ||
                                        (widget.message!.messageType == "file")
                                    ? MainAxisSize.max
                                    : MainAxisSize.min,
                            children: <Widget>[
                              widget.message!.messageType == "video" &&
                                      widget.message!.you == 0
                                  ? Row(
                                      children: [
                                        Container(
                                            child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.videocam_sharp,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              widget.message!.you == 0
                                                  ? widget
                                                      .message!.videoPlaytime!
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                              ),
                                            )
                                          ],
                                        )),
                                      ],
                                    )
                                  : widget.message!.messageType == "file"
                                      ? Row(
                                          children: [
                                            widget.message!.fileTypeExtension ==
                                                    "pdf"
                                                ? Container(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      widget.message!
                                                                  .pageCount ==
                                                              1
                                                          ? widget.message!
                                                                  .pageCount
                                                                  .toString() +
                                                              " " +
                                                              AppLocalizations
                                                                  .of(
                                                                "page",
                                                              )
                                                          : widget.message!
                                                                  .pageCount
                                                                  .toString() +
                                                              " " +
                                                              AppLocalizations
                                                                  .of(
                                                                "pages",
                                                              ),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            widget.message!.fileTypeExtension ==
                                                    "pdf"
                                                ? Container(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      " • ",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            Container(
                                              color: Colors.transparent,
                                              child: Text(
                                                widget
                                                    .message!.fileTypeExtension!
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : widget.message!.messageType == "audio"
                                          ? Row(
                                              children: [
                                                Container(
                                                  width: 180,
                                                  child: Text(
                                                    widget.message!
                                                        .fileNameUploaded!
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            )
                                          : widget.message!.messageType ==
                                                  "voice"
                                              ? Row(
                                                  children: [
                                                    Container(
                                                      width: 180,
                                                      child: Text(
                                                        widget.message!
                                                            .audioDuration!,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Container(),
                                                  ],
                                                ),
                              widget.message!.you != 2 &&
                                      widget.message!.you != 4
                                  ? Row(
                                      children: [
                                        Container(
                                          decoration: new BoxDecoration(
                                            color:
                                                widget.message!.messageType ==
                                                        "gif_url"
                                                    ? messageBubbleColor
                                                    : Colors.transparent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            shape: BoxShape.rectangle,
                                          ),
                                          width: widget.message!.isStar == 1
                                              ? 90.0
                                              : widget.message!.messageType ==
                                                      "gif_url"
                                                  ? 90
                                                  : widget.message!.isStar ==
                                                              1 &&
                                                          widget.message!
                                                                  .messageType ==
                                                              "gif_url"
                                                      ? 100
                                                      : 80.0,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                widget.message!.messageType ==
                                                        "gif_url"
                                                    ? 5.0
                                                    : 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                widget.message!.isStar == 1
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 4.0),
                                                        child: Icon(
                                                          Icons.star,
                                                          color: Colors.grey
                                                              .withOpacity(0.6),
                                                          size: 14,
                                                        ),
                                                      )
                                                    : Container(),
                                                Container(
                                                  child: Text(
                                                    widget.message!.time!
                                                        .toLowerCase(),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4.0,
                                                ),
                                                widget.message!.you == 1
                                                    ? _getIcon(widget.message!
                                                                    .readStatus ==
                                                                "0" ||
                                                            widget.message!
                                                                    .readStatus ==
                                                                null
                                                        ? Colors.grey
                                                        : primaryBlueColor)
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(),
                                      ],
                                    ),
                            ],
                          ),
                          widget.message!.messageType == "contact"
                              ? _contactCardBottom()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(),
                                  ],
                                )
                        ],
                      )),
                ),
              ],
            ),
            widget.message!.you != 4 &&
                    widget.message!.you != 3 &&
                    widget.message!.you == 0 &&
                    widget.message!.messageType != "text" &&
                    widget.message!.messageType != "reply"
                ? _forwardArrowOther()
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _getIcon(Color color1) {
    return Icon(CustomIcons.double_tick_indicator, size: 17, color: color1);
  }
}

class PdfCardLocal extends StatefulWidget {
  final ChatMessagesModel? message;
  final String path;
  final int sentNow;

  const PdfCardLocal(
      {Key? key, this.message, required this.path, required this.sentNow})
      : super(key: key);

  @override
  _PdfCardLocalState createState() => _PdfCardLocalState();
}

class _PdfCardLocalState extends State<PdfCardLocal> {
  Future<Future<PdfPageImage?>> getDoc() async {
    print(widget.sentNow.toString() + "sent status");
    print(widget.path + " doc received");
    final document = await PdfDocument.openFile(widget.path);
    final page = await document.getPage(1);
    final pageImage = page.render(
      // rendered image width resolution, required
      width: page.width * 2,
      // rendered image height resolution, required
      height: page.height * 2,

      // Rendered image compression format, also can be PNG, WEBP*
      // Optional, default: PdfPageFormat.PNG
      // Web not supported

      // format: PdfPageFormat.PNG,

      // Image background fill color for JPEG
      // Optional, default '#ffffff'
      // Web not supported
      backgroundColor: '#ffffff',

      // Crop rect in image for render
      // Optional, default null
      // Web not supported
      cropRect:
          Rect.fromCenter(center: Offset(140, 140), width: 280, height: 100),
    );

    await page.close();

    return pageImage;
  }

  late Future future;

  @override
  void initState() {
    // future = getDoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        widget.message!.pdfImage ?? "",
        fit: BoxFit.cover,
      ),
    );
  }
}

class AudioCardSender extends StatefulWidget {
  final String path;
  final ChatMessagesModel message;
  final int sentNow;
  final String duration;

  const AudioCardSender(
      {Key? key,
      required this.path,
      required this.message,
      required this.sentNow,
      required this.duration})
      : super(key: key);

  @override
  _AudioCardSenderState createState() => _AudioCardSenderState();
}

class _AudioCardSenderState extends State<AudioCardSender> {
  bool isPlaying = false;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _completeSubscription;
  Duration _duration = new Duration();
  late ap.AudioPlayer player;
  Duration _position = new Duration();

  void _init() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _positionSubscription = player.onAudioPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _completeSubscription = player.onPlayerCompletion.listen((event) {
      setState(() {
        _position = new Duration(seconds: 0);
        isPlaying = false;
      });
    });
  }

  Future<void> play() async {
    print(widget.path + " play path");
    await player.play(widget.path);
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pause() async {
    await player.pause();
    await player.release();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void initState() {
    player = ap.AudioPlayer();
    _init();

    super.initState();
  }

  @override
  void dispose() {
    print("disposeee");
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _completeSubscription.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                  color: darkColor),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    !isPlaying
                        ? Icon(
                            Icons.headset,
                            color: Colors.white,
                            size: 25,
                          )
                        : Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 25,
                          ),
                    !isPlaying
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Container(
                              child: Text(widget.duration,
                                  style: whiteBold.copyWith(fontSize: 11)),
                            ),
                          )
                        : Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                  _position.inMinutes.toString() +
                                      ":" +
                                      (_position.inSeconds % 60).toString(),
                                  style: whiteBold.copyWith(fontSize: 11)),
                            ),
                          ),
                  ],
                ),
              )),
          widget.message!.isSending!
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    !isPlaying ? Icons.play_arrow : Icons.pause,
                    size: 40,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    !isPlaying ? play() : pause();
                  },
                ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: 140,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  trackHeight: 3,
                  thumbColor: darkColor,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: darkColor,
                  overlayColor: Colors.transparent,
                ),
                child: Slider(
                  value: _position.inMilliseconds.toDouble() ?? 0.0,
                  min: 0.0,
                  max: _duration.inMilliseconds.toDouble() ?? 0.0,
                  onChanged: (double value) async {
                    await player.seek(Duration(milliseconds: value.toInt()));
                    _position = Duration(milliseconds: value.toInt());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioCardReceiver extends StatefulWidget {
  final String path;
  final ChatMessagesModel? message;
  final int? sentNow;
  final bool? isDownloading;
  final int? receiverDownload;
  final String? url;
  final String? receiverPath;
  final String? duration;

  const AudioCardReceiver(
      {Key? key,
      required this.path,
      this.message,
      this.sentNow,
      this.isDownloading,
      this.receiverDownload,
      this.url,
      this.receiverPath,
      this.duration})
      : super(key: key);

  @override
  _AudioCardReceiverState createState() => _AudioCardReceiverState();
}

class _AudioCardReceiverState extends State<AudioCardReceiver> {
  bool isPlaying = false;
  String durationText = "";
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _completeSubscription;
  Duration _duration = new Duration();
  ap.AudioPlayer player = ap.AudioPlayer();
  AudioCache audioCache = new AudioCache();
  late Future _durationFuture;
  String stringDuration = "";
  Duration _position = new Duration();

  void _init() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _positionSubscription = player.onAudioPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _completeSubscription = player.onPlayerCompletion.listen((event) {
      setState(() {
        _position = new Duration(seconds: 0);
        isPlaying = false;
      });
    });
  }

  Future<void> play() async {
    print(widget.path + " play path");
    await player.play(widget.path);

    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pause() async {
    await player.pause();
    await player.release();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  void dispose() {
    print("disposeee");
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          widget.isDownloading!
              ? Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      child:
                          downloadIndicator(widget.message!.downloadProgress!)),
                )
              : widget.receiverDownload == 1
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.download_rounded,
                            color: Colors.grey,
                            size: 23,
                          ),
                        ),
                      ),
                    )
                  : IconButton(
                      padding: EdgeInsets.only(left: 1, right: 8),
                      icon: Icon(
                        !isPlaying ? Icons.play_arrow : Icons.pause,
                        size: 40,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        !isPlaying ? play() : pause();
                      },
                    ),
          SizedBox(
            width: widget.receiverDownload == 1 ? 8 : 8,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: 140,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  trackHeight: 3,
                  thumbColor: darkColor,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: darkColor,
                  overlayColor: Colors.transparent,
                ),
                child: Slider(
                  value: _position.inMilliseconds.toDouble() ?? 0.0,
                  min: 0.0,
                  max: _duration.inMilliseconds.toDouble() ?? 0.0,
                  onChanged: (double value) async {
                    await player.seek(Duration(milliseconds: value.toInt()));
                    _position = Duration(milliseconds: value.toInt());
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            width: widget.receiverDownload == 1 ? 8 : 10,
          ),
          Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                  color: darkColor),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    !isPlaying
                        ? Icon(
                            Icons.headset,
                            color: Colors.white,
                            size: 25,
                          )
                        : Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 25,
                          ),
                    !isPlaying
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Container(
                              child: Text(widget.duration!,
                                  style: whiteBold.copyWith(fontSize: 11)),
                            ),
                          )
                        : Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                  _position.inMinutes.toString() +
                                      ":" +
                                      (_position.inSeconds % 60).toString(),
                                  style: whiteBold.copyWith(fontSize: 11)),
                            ),
                          ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class VoiceCardSender extends StatefulWidget {
  final String duration;
  final String path;
  final bool isSending;

  const VoiceCardSender(
      {Key? key,
      required this.path,
      required this.duration,
      required this.isSending})
      : super(key: key);

  @override
  _VoiceCardSenderState createState() => _VoiceCardSenderState();
}

class _VoiceCardSenderState extends State<VoiceCardSender> {
  bool isPlaying = false;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _completeSubscription;
  Duration _duration = new Duration();
  late ap.AudioPlayer player;
  Duration _position = new Duration();

  void _init() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _positionSubscription = player.onAudioPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _completeSubscription = player.onPlayerCompletion.listen((event) {
      setState(() {
        _position = new Duration(seconds: 0);
        isPlaying = false;
      });
    });
  }

  Future<void> play() async {
    print(widget.path + " play path");
    await player.play(widget.path);
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pause() async {
    await player.pause();
    await player.release();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void initState() {
    player = ap.AudioPlayer();
    _init();

    super.initState();
  }

  @override
  void dispose() {
    print("disposeee");
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _completeSubscription.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(CurrentUser().currentUser.image!),
            ),
          ),
          widget.isSending
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    !isPlaying ? Icons.play_arrow : Icons.pause,
                    size: 40,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    !isPlaying ? play() : pause();
                  },
                ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: 140,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  trackHeight: 3,
                  thumbColor: darkColor,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: darkColor,
                  overlayColor: Colors.transparent,
                ),
                child: Slider(
                  value: _position.inMilliseconds.toDouble() ?? 0.0,
                  min: 0.0,
                  max: _duration.inMilliseconds.toDouble() ?? 0.0,
                  onChanged: (double value) async {
                    await player.seek(Duration(milliseconds: value.toInt()));
                    _position = Duration(milliseconds: value.toInt());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoiceCardReceiver extends StatefulWidget {
  final String duration;
  final String path;
  final bool isSending;
  final bool isDownloading;
  final int receiverDownload;
  final String image;
  final double? downloadProgress;

  const VoiceCardReceiver(
      {Key? key,
      required this.duration,
      required this.path,
      required this.isSending,
      required this.isDownloading,
      required this.receiverDownload,
      required this.image,
      this.downloadProgress})
      : super(key: key);

  @override
  _VoiceCardReceiverState createState() => _VoiceCardReceiverState();
}

class _VoiceCardReceiverState extends State<VoiceCardReceiver> {
  bool isPlaying = false;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _completeSubscription;
  Duration _duration = new Duration();
  late ap.AudioPlayer player;
  Duration _position = new Duration();

  void _init() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _positionSubscription = player.onAudioPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _completeSubscription = player.onPlayerCompletion.listen((event) {
      setState(() {
        _position = new Duration(seconds: 0);
        isPlaying = false;
      });
    });
  }

  Future<void> play() async {
    print(widget.path + " play path");
    await player.play(widget.path);
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pause() async {
    await player.pause();
    await player.release();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void initState() {
    player = ap.AudioPlayer();
    _init();

    super.initState();
  }

  @override
  void dispose() {
    print("disposeee");
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _completeSubscription.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          widget.isDownloading
              ? Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      child: downloadIndicator(widget.downloadProgress!)),
                )
              : widget.receiverDownload == 1
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.download_rounded,
                            color: Colors.grey,
                            size: 23,
                          ),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        !isPlaying ? Icons.play_arrow : Icons.pause,
                        size: 40,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        !isPlaying ? play() : pause();
                      },
                    ),
          SizedBox(
            width: 8,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: 135,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  trackHeight: 3,
                  thumbColor: darkColor,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: darkColor,
                  overlayColor: Colors.transparent,
                ),
                child: Slider(
                  value: _position.inMilliseconds.toDouble() ?? 0.0,
                  min: 0.0,
                  max: _duration.inMilliseconds.toDouble() ?? 0.0,
                  onChanged: (double value) async {
                    await player.seek(Duration(milliseconds: value.toInt()));
                    _position = Duration(milliseconds: value.toInt());
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(widget.image),
            ),
          ),
        ],
      ),
    );
  }
}
