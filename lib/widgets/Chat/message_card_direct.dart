import 'dart:io';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Bookmarks/boards_model.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Boards/board_controller.dart';
import 'package:bizbultest/view/Boards/board_posts_view.dart';
import 'package:bizbultest/view/Chat/forward_message_chat.dart';
import 'package:bizbultest/view/Chat/forward_message_direct.dart';
import 'package:bizbultest/widgets/Chat/link_preview.dart';
import 'package:bizbultest/widgets/Chat/reply_message_card.dart';
import 'package:bizbultest/widgets/Newsfeeds/single_feed_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';

import 'message_card.dart';

class MessageItemDirect extends StatefulWidget {
  final ChatMessagesModel? message;
  final VoidCallback? onTap;
  final VoidCallback ?onLongPress;
  final String? image;
  final int? index;
  final AutoScrollController? controller;
  final String? dir;

  MessageItemDirect({
    this.onTap,
    this.onLongPress,
    this.message,
    this.image,
    this.index,
    this.controller,
    this.dir,
  });

  @override
  _MessageItemDirectState createState() => _MessageItemDirectState();
}

class _MessageItemDirectState extends State<MessageItemDirect> with SingleTickerProviderStateMixin {
  ap.AudioPlayer player = ap.AudioPlayer();

 late  AnimationController _animationController;

  Widget _timeCard(Color color) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        Container(
          child: Text(
            widget.message!.time!.toLowerCase(),
            style: TextStyle(
              color: color,
              fontSize: 12.0,
            ),
          ),
        ),
        SizedBox(
          width: 4.0,
        ),
        widget.message!.you == 1 ? _getIcon(color) : Container()
      ],
    );
  }

  Widget _mediaMessageDivider(double left, double right) {
    if (widget.message!.message != "") {
      return Padding(
        padding: EdgeInsets.only(left: left, right: right),
        child: Container(
          width: 2,
          color: Colors.grey.shade300,
          height: 180,
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  Widget _storyCard(String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            text,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.message!.you == 0 ? _mediaMessageDivider(0, 12) : Container(),
            Container(
                height: 200,
                width: 130,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
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
                        height: 200,
                        width: 130,
                      ),
                    ),
                    _timeCardMedia()
                  ],
                )),
            widget.message!.you == 1 ? _mediaMessageDivider(12, 0) : Container(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: new BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              shape: BoxShape.rectangle,
            ),
            width: 130,
            child: Text(
              widget.message!.message!,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _boardImageCard(Alignment alignment, double topRight, double topLeft, double bottomLeft, double bottomRight, String image) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
          child: image == ""
              ? Container(
                  height: 125 - 1.25,
                  width: 125 - 1.25,
                )
              : Image(
                  image: CachedNetworkImageProvider(image),
                  fit: BoxFit.cover,
                  height: 125 - 1.25,
                  width: 125 - 1.25,
                  alignment: Alignment.topCenter,
                ),
        ),
      ),
    );
  }

  Widget _boardCard() {
    return GestureDetector(
      onTap: () {
        OtherUser().otherUser.memberID = widget.message!.boardParameters![0].memberId;
        BoardController boardController = Get.put(BoardController());
        boardController.setNameAndDescription(widget.message!.boardParameters![0].name!, "");
        BoardModel board = new BoardModel(posts: widget.message!.boardParameters![0].posts, boardId: widget.message!.boardParameters![0].boardId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BoardPostsView(
                      memberID: widget.message!.boardParameters![0].memberId,
                      board: board,
                    )));
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              decoration: new BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                shape: BoxShape.rectangle,
              ),
              margin: EdgeInsets.only(top: 10),
              height: 250,
              width: 250,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.white,
                      height: 250,
                      width: 2.5,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.white,
                      height: 2.5,
                      width: 250,
                    ),
                  ),
                  _boardImageCard(Alignment.topRight, 5, 0, 0, 0, widget.message!.boardParameters![0].image1!.replaceAll(".mp4", ".jpg")),
                  _boardImageCard(Alignment.topLeft, 0, 5, 0, 0, widget.message!.boardParameters![0].image2!.replaceAll(".mp4", ".jpg")),
                  _boardImageCard(Alignment.bottomLeft, 0, 0, 5, 0, widget.message!.boardParameters![0].image3!.replaceAll(".mp4", ".jpg")),
                  _boardImageCard(Alignment.bottomRight, 0, 0, 0, 5, widget.message!.boardParameters![0].image4!.replaceAll(".mp4", ".jpg")),
                ],
              ),
            ),
            ListTile(
              visualDensity: VisualDensity(horizontal: -2, vertical: -2),
              dense: true,
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(widget.message!.boardParameters![0].userImage!),
              ),
              title: Text(
                widget.message!.boardParameters![0]!.name??"",
                style: TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                widget.message!.boardParameters![0].posts!,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
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
            color: widget.message!.message == match ? Colors.black54 : Colors.black,
            fontSize: 16,
            fontStyle: widget.message!.message == match ? FontStyle.italic : FontStyle.normal),
        textAlign: TextAlign.start,
      );
    }
  }

  Widget _timeCardMedia() {
    return Positioned.fill(
      right: 4,
      bottom: 4,
      child: Align(alignment: Alignment.bottomRight, child: _timeCard(Colors.white)),
    );
  }

  Widget _networkImageCard(String image, double h, double w) {
    return Container(
      height: h,
      width: w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaY: 15, sigmaX: 15),
              child: Image.network(
                image,
                colorBlendMode: BlendMode.softLight,
                fit: BoxFit.cover,
                height: h,
                width: w,
              ),
            ),
            _timeCardMedia()
          ],
        ),
      ),
    );
  }

  Widget _localImageCard(String path, double h, double w) {
    return Container(
      height: h,
      width: w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.file(
              File(path),
              fit: BoxFit.cover,
              height: h,
              width: w,
            ),
            _timeCardMedia()
          ],
        ),
      ),
    );
  }

  Widget _imageCard(String path, String image) {
    if (File(path).existsSync()) {
      return _localImageCard(path, 200, 130);
    } else {
      return _networkImageCard(image, 200, 130);
    }
  }

  Widget _videoCard(String thumbPath, String videoPath, String image) {
    if (!File(thumbPath).existsSync() && !File(videoPath).existsSync() && widget.message!.isVideoUploading == false) {
      return _networkImageCard(image, 200, 130);
    } else if (!File(thumbPath).existsSync() && widget.message!.isVideoUploading == false) {
      print("22222222222222222");
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
              height: 200,
              width: 130,
            ),
            _timeCardMedia()
          ],
        ),
      );
    } else if (!File(videoPath).existsSync() && widget.message!.isVideoUploading == false) {
      print("33333333333333");
      return _networkImageCard(image, 200, 130);
    } else {
      return _localImageCard(thumbPath, 200, 130);
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          child: Image.network(image, fit: BoxFit.cover, colorBlendMode: BlendMode.softLight),
        ),
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
                      style: TextStyle(color: darkColor, fontWeight: FontWeight.w500, fontSize: 16),
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
                            style: TextStyle(color: darkColor, fontWeight: FontWeight.w500, fontSize: 16),
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
                              phones: [Item(label: widget.message!.contactType, value: widget.message!.contactNumber)],
                            )).then((value) {
                              customToastWhite(AppLocalizations.of("Contact Saved Successfully"), 14.0, ToastGravity.BOTTOM);
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                AppLocalizations.of(
                                  "Add Contact",
                                ),
                                style: TextStyle(color: darkColor, fontWeight: FontWeight.w500, fontSize: 16),
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
              style: TextStyle(color: darkColor, fontSize: 16, fontWeight: FontWeight.w500),
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
          action.replaceAll("/", " "),
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
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
    if ((widget.message!.messageType == "video" || widget.message!.messageType == "image" || widget.message!.messageType == "file") &&
        !File(widget.message!.path!).existsSync()) {
      return Container();
    } else {
      return Container(
          decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.5)),
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

  Widget _forwardArrowOther() {
    if ((widget.message!.messageType == "video" ||
            widget.message!.messageType == "image" ||
            widget.message!.messageType == "file" && widget.message!.receiverDownload == 0) &&
        !File(widget.message!.receiverDevicePath!).existsSync()) {
      return Container();
    } else {
      return Container(
          decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.5)),
          child: IconButton(
              onPressed: () {
                List<String> id = [];
                id.add(widget.message!.messageId!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForwardMessageDirectPage(
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

  Widget _feedPostCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          OtherUser().otherUser.memberID = widget.message!.postParameters![0].memberId;
          OtherUser().otherUser.shortcode = widget.message!.postParameters![0].userName;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleFeedPost(
                      memberID: widget.message!.postParameters![0].memberId,
                      postID: widget.message!.postParameters![0].postId,
                      setNavBar: (bool val) {},
                      refresh: () {},
                      changeColor: () {},
                      isChannelOpen: () {},
                    )));
      },
      child: Container(
        height: widget.message!.postParameters![0].description != "" ? 400 : 350,
        width: 275,
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 50,
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity(horizontal: -4),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(widget.message!.postParameters![0].userImage!),
                ),
                title: Text(
                  widget.message!.postParameters![0].shortcode!,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            widget.message!.postParameters![0].blogTitle != ""
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      widget.message!.postParameters![0].blogTitle!,
                      style: TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'Georgie'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                : Container(),
            Image(
              image: CachedNetworkImageProvider(widget.message!.postParameters![0].thumbnailUrl!),
              fit: BoxFit.cover,
              height: 300,
              width: 275,
            ),
            widget.message!.postParameters![0].description != "" && widget.message!.postParameters![0].blogTitle == ""
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    height: 50,
                    child: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.message!.postParameters![0].shortcode !+ "  ",
                            style: blackBold.copyWith(fontSize: 14),
                          ),
                          TextSpan(
                            text: widget.message!.postParameters![0].description,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.message!.you == 1
            ? MainAxisAlignment.end
            : widget.message!.you == 2 || widget.message!.you == 4
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
        crossAxisAlignment: widget.message!.you == 1
            ? CrossAxisAlignment.end
            : widget.message!.you == 2 || widget.message!.you == 4
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
        children: [
          Container(
            color: widget.message!.isSelected! ? darkColor.withOpacity(0.2) : Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.message!.you == 1
                  ? MainAxisAlignment.end
                  : widget.message!.you == 2 || widget.message!.you == 4
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              children: [
                widget.message!.you == 1 && widget.message!.messageType != "text" && widget.message!.messageType != "reply" ? _forwardArrowYou() : Container(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: widget.message!.you == 1
                      ? MainAxisAlignment.end
                      : widget.message!.you == 2 || widget.message!.you == 4
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: widget.message!.you == 1 ||
                                      widget.message!.you == 2 ||
                                      widget.message!.you == 4 ||
                                      widget.message!.messageType == "image" ||
                                      widget.message!.messageType == "video" ||
                                      widget.message!.messageType == "story"
                                  ? null
                                  : new Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                              color: widget.message!.you == 1 &&
                                      widget.message!.messageType != "gif_url" &&
                                      widget.message!.messageType != "image" &&
                                      widget.message!.messageType != "video" &&
                                      widget.message!.messageType != "story"
                                  ? Colors.grey.shade200
                                  : (widget.message!.you == 2 || widget.message!.you == 4) && widget.message!.messageType != "gif_url"
                                      ? Colors.transparent
                                      : widget.message!.messageType == "gif_url" ||
                                              widget.message!.messageType == "image" ||
                                              widget.message!.messageType == "video" ||
                                              widget.message!.messageType == "story"
                                          ? Colors.transparent
                                          : Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          constraints: BoxConstraints(
                            minWidth: 80.0,
                            maxWidth: widget.message!.messageType == "link" || widget.message!.messageType == "reply" ? 80.0.w : 280.0,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: widget.message!.you == 2 || widget.message!.you == 4 ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                            children: <Widget>[
                              widget.message!.you == 0
                                  ? Container(
                                      constraints: BoxConstraints(
                                        minWidth: 80.0,
                                      ),
                                      child: widget.message!.messageType == "image"
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                _mediaMessageDivider(0, 12),
                                                ClipRRect(
                                                  child: Container(
                                                    height: 200,
                                                    width: 130,
                                                    child: Stack(
                                                      children: [
                                                        widget.message!.receiverDownload == 0
                                                            ? _imageCard(widget.message!.receiverDevicePath!,
                                                                widget.message!.imageData.toString().replaceAll("/resized", ""))
                                                            : _blurredImageCard(widget.message!.imageData.toString().replaceAll("/resized", "")),
                                                        widget.message!.receiverDownload == 1 && widget.message!.isDownloading == false
                                                            ? _downloadIndicatorMedia()
                                                            : Container(
                                                                height: 0,
                                                                width: 0,
                                                              ),
                                                        widget.message!.isDownloading!
                                                            ? Positioned.fill(
                                                                child: Align(alignment: Alignment.center, child: customCircularIndicator(3, Colors.white)))
                                                            : Container(
                                                                height: 0,
                                                                width: 0,
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : widget.message!.messageType == "video"
                                              ? Container(
                                                  height: 200,
                                                  width: 130,
                                                  child: ClipRRect(
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 200,
                                                          width: 130,
                                                          child: widget.message!.receiverDownload == 0
                                                              ? _videoCard(widget.message!.receiverThumbnail!, widget.message!.receiverDevicePath!,
                                                                  widget.message!.videoImage!.replaceAll(".mp4", ".jpg"))
                                                              : Container(child: _blurredImageCard(widget.message!.url!.replaceAll(".mp4", ".jpg"))),
                                                        ),
                                                        widget.message!.receiverDownload == 1 && widget.message!.isDownloading == false
                                                            ? _downloadIndicatorMedia()
                                                            : Container(),
                                                        widget.message!.receiverDownload == 0
                                                            ? Positioned.fill(
                                                                child: Align(
                                                                    alignment: Alignment.center,
                                                                    child: !widget.message!.isVideoUploading!
                                                                        ? _playArrow()
                                                                        : customCircularIndicator(3, Colors.white)),
                                                              )
                                                            : Container(),
                                                        widget.message!.isDownloading!
                                                            ? Positioned.fill(
                                                                child: Align(alignment: Alignment.center, child: customCircularIndicator(3, Colors.white)),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : widget.message!.messageType == "file"
                                                  ? Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          widget.message!.fileTypeExtension == "pdf"
                                                              ? Padding(
                                                                  padding: const EdgeInsets.only(bottom: 10),
                                                                  child: Container(
                                                                    height: 100,
                                                                    width: 280,
                                                                    child: Image.network(
                                                                      widget.message!.pdfImage!,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ))
                                                              : Container(),
                                                          Container(
                                                            color: darkColor.withOpacity(0.1),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                              child: Row(
                                                                children: [
                                                                  _fileSymbol(),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    width: widget.message!.receiverDownload == 1 ? 175 : 200,
                                                                    child: Text(
                                                                      widget.message!.fileNameUploaded!,
                                                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  widget.message!.receiverDownload == 1
                                                                      ? SizedBox(
                                                                          child: widget.message!.isDownloading!
                                                                              ? Container(child: customCircularIndicator(1, Colors.grey))
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
                                                  : widget.message!.messageType == "audio"
                                                      ? AudioCardReceiver(
                                                          duration: widget.message!.audioDuration,
                                                          receiverDownload: widget.message!.receiverDownload,
                                                          receiverPath: widget.message!.receiverDevicePath,
                                                          url: widget.message!.url,
                                                          sentNow: widget.message!.sentNow,
                                                          path: widget.message!.path!,
                                                          message: widget.message!,
                                                          isDownloading: widget.message!.isDownloading,
                                                        )
                                                      : widget.message!.messageType == "voice"
                                                          ? VoiceCardReceiver(
                                                              path: widget.message!.receiverDevicePath!,
                                                              image: widget.image!,
                                                              isSending: widget.message!.isSending!,
                                                              duration: widget.message!.audioDuration!,
                                                              isDownloading: widget.message!.isDownloading!,
                                                              receiverDownload: widget.message!.receiverDownload!, 
                                                            )
                                                          : widget.message!.messageType == "contact"
                                                              ? _contactCard()
                                                              : widget.message!.messageType == "location"
                                                                  ? _locationCard()
                                                                  : widget.message!.messageType == "story"
                                                                      ? _storyCard("Replied to your story")
                                                                      : widget.message!.messageType == "link"
                                                                          ? _linkCard()
                                                                          : widget.message!.messageType == "feed_post"
                                                                              ? _feedPostCard()
                                                                              : widget.message!.messageType == "reply"
                                                                                  ? _replyCard()
                                                                                  : widget.message!.messageType == "gif_url"
                                                                                      ? _gifCard()
                                                                                      : widget.message!.messageType == "board"
                                                                                          ? _boardCard()
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
                                                  ? Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        ClipRRect(
                                                          child: Container(
                                                            height: 200,
                                                            width: 130,
                                                            child: Stack(
                                                              children: [
                                                                _imageCard(widget.message!.path!, widget.message!.imageData.toString().replaceAll("/resized", "")),
                                                                widget.message!.isSending!
                                                                    ? Positioned.fill(
                                                                        child:
                                                                            Align(alignment: Alignment.center, child: customCircularIndicator(3, Colors.white)),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        _mediaMessageDivider(12, 0)
                                                      ],
                                                    )
                                                  : widget.message!.messageType == "video"
                                                      ? ClipRRect(
                                                          child: Container(
                                                            height: 200,
                                                            width: 130,
                                                            child: Stack(
                                                              children: [
                                                                _videoCard(
                                                                    widget.message!.thumbPath!,
                                                                    widget.message!.path!,
                                                                    widget.message!.videoImage != null
                                                                        ? widget.message!.videoImage!.replaceAll(".mp4", ".jpg")
                                                                        : ""),
                                                                Positioned.fill(
                                                                  child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: !widget.message!.isVideoUploading!
                                                                          ? _playArrow()
                                                                          : customCircularIndicator(3, Colors.white)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : widget.message!.messageType == "file"
                                                          ? Container(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(bottom: 10),
                                                                    child: widget.message!.fileTypeExtension == "pdf"
                                                                        ? Container(
                                                                            height: 100,
                                                                            width: 280,
                                                                            child: PdfCardLocal(
                                                                              sentNow: widget.message!.sentNow!,
                                                                              path: widget.message!.thumbPath!,
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                  ),
                                                                  Container(
                                                                    color: darkColor.withOpacity(0.1),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                                      child: Row(
                                                                        children: [
                                                                          _fileSymbol(),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Container(
                                                                            width: widget.message!.isSending == true ? 175 : 200,
                                                                            child: Text(
                                                                              widget.message!.fileNameUploaded!,
                                                                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          widget.message!.isSending! ? customCircularIndicator(1, Colors.grey) : Container()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : widget.message!.messageType == "audio"
                                                              ? AudioCardSender(
                                                                  duration: widget.message!.audioDuration!,
                                                                  sentNow: widget.message!.sentNow!,
                                                                  path: widget.message!.path!,
                                                                  message: widget.message!,
                                                                )
                                                              : widget.message!.messageType == "voice"
                                                                  ? VoiceCardSender(
                                                                      path: widget.message!.path!,
                                                                      isSending: widget.message!.isSending!,
                                                                      duration: widget.message!.audioDuration!,
                                                                    )
                                                                  : widget.message!.messageType == "contact"
                                                                      ? _contactCard()
                                                                      : widget.message!.messageType == "location"
                                                                          ? Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  height: 150,
                                                                                  width: 280,
                                                                                  child: Image.file(
                                                                                    new File(widget.message!.path!),
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
                                                                            )
                                                                          : widget.message!.messageType == "story"
                                                                              ? _storyCard("You replied to their story")
                                                                              : widget.message!.messageType == "link"
                                                                                  ? _linkCard()
                                                                                  : widget.message!.messageType == "feed_post"
                                                                                      ? _feedPostCard()
                                                                                      : widget.message!.messageType == "reply"
                                                                                          ? _replyCard()
                                                                                          : widget.message!.messageType == "gif_url"
                                                                                              ? _gifCard()
                                                                                              : widget.message!.messageType == "board"
                                                                                                  ? _boardCard()
                                                                                                  : _textCard("You deleted this message")),
                              SizedBox(
                                height: widget.message!.you == 2 || widget.message!.you == 4 ? 0 : 5,
                              ),
                              (widget.message!.messageType == "image" || widget.message!.messageType == "video") && widget.message!.message != ""
                                  ? Container(
                                      constraints: BoxConstraints(maxWidth: 220, minWidth: 80),
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                      decoration: new BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Text(
                                        widget.message!.message!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: (widget.message!.messageType == "video" && widget.message!.you == 0) || (widget.message!.messageType == "file")
                                    ? MainAxisSize.max
                                    : MainAxisSize.min,
                                children: <Widget>[
                                  widget.message!.messageType == "video" && widget.message!.you == 0
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
                                                  widget.message!.you == 0 ? widget.message!.videoPlaytime! : "",
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
                                                widget.message!.fileTypeExtension == "pdf"
                                                    ? Container(
                                                        color: Colors.transparent,
                                                        child: Text(
                                                          widget.message!.pageCount == 1
                                                              ? widget.message!.pageCount.toString() + " page"
                                                              : widget.message!.pageCount.toString() + " pages",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                widget.message!.fileTypeExtension == "pdf"
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
                                                    widget.message!.fileTypeExtension!.toUpperCase(),
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
                                                        widget.message!.fileNameUploaded!.toUpperCase(),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : widget.message!.messageType == "voice"
                                                  ? Row(
                                                      children: [
                                                        Container(
                                                          width: 180,
                                                          child: Text(
                                                            widget.message!.audioDuration!,
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 12.0,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Container(),
                                                      ],
                                                    ),
                                  widget.message!.you != 2 && widget.message!.you != 4
                                      ? Row(
                                          children: [
                                            Container(
                                              decoration: new BoxDecoration(
                                                color: widget.message!.messageType == "gif_url" ? Colors.grey.shade200 : Colors.transparent,
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                shape: BoxShape.rectangle,
                                              ),
                                              width: widget.message!.isStar == 1
                                                  ? 90.0
                                                  : widget.message!.messageType == "gif_url"
                                                      ? 90
                                                      : widget.message!.isStar == 1 && widget.message!.messageType == "gif_url"
                                                          ? 100
                                                          : 80.0,
                                              child: Padding(
                                                padding: EdgeInsets.all(widget.message!.messageType == "gif_url" ? 5.0 : 0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    widget.message!.isStar == 1
                                                        ? Padding(
                                                            padding: const EdgeInsets.only(right: 4.0),
                                                            child: Icon(
                                                              Icons.star,
                                                              color: Colors.grey.withOpacity(0.6),
                                                              size: 14,
                                                            ),
                                                          )
                                                        : Container(),
                                                    widget.message!.messageType != "image" &&
                                                            widget.message!.messageType != "video" &&
                                                            widget.message!.messageType != "story"
                                                        ? _timeCard(Colors.grey.shade600)
                                                        : Container(),
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
          widget.message!.messageType == "feed_post" && widget.message!.postParameters![0].message != ""
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  constraints: BoxConstraints(maxWidth: 240),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: new BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(
                    widget.message!.postParameters![0].message!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }

  Widget _getIcon(Color color) {
    return Icon(
      CustomIcons.double_tick_indicator,
      size: 17,
      color: color,
    );
  }
}
