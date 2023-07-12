import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/text_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';

class ReplyCard extends StatefulWidget {
  final ChatMessagesModel message;
  final VoidCallback close;

  const ReplyCard({Key? key, required this.message, required this.close})
      : super(key: key);

  @override
  _ReplyCardState createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  var keyText = GlobalKey();
  Size size = Size(0, 0);
  late double h;
  late double w;

  Widget _sizedBox(double h, double w) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  Widget _imageCard(String url, double h, double w) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      height: h,
      width: w,
    );
  }

  Widget _icon(IconData icon, double size) {
    return Icon(
      icon,
      color: Colors.grey,
      size: size,
    );
  }

  void calculateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final RenderObject? box = keyText.currentContext!.findRenderObject();

      final RenderRepaintBoundary? box =
          keyText.currentContext!.findRenderObject() as RenderRepaintBoundary;
      setState(() {
        h = box!.size.height;
        w = box.size.width;
      });
    });
  }

  Widget _closeButton() {
    return IconButton(
      iconSize: 16,
      icon: _icon(Icons.close, 16),
      onPressed: widget.close,
      constraints: BoxConstraints(),
      padding: EdgeInsets.all(2),
    );
  }

  Widget _typeText() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
            width: double.infinity,
            decoration: new BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                border: Border(left: BorderSide(color: darkColor, width: 4))),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelpers().simpleTextCard(
                          widget.message.you == 1
                              ? AppLocalizations.of("You")
                              : widget.message.username!,
                          FontWeight.w500,
                          14,
                          darkColor,
                          1,
                          TextOverflow.ellipsis),
                      _closeButton()
                    ],
                  ),
                  _sizedBox(3, 0),
                  TextHelpers().simpleTextCard(
                      widget.message.message!,
                      FontWeight.normal,
                      14,
                      Colors.grey.shade600,
                      3,
                      TextOverflow.ellipsis),
                ],
              ),
            )),
      ),
    );
  }

  Widget _typeMedia() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Image.network(
                widget.message.messageType == "image"
                    ? widget.message.imageData
                        .toString()
                        .replaceAll("/resized", "")
                    : widget.message.videoImage!.replaceAll(".mp4", ".jpg"),
                fit: BoxFit.cover,
                height: 45,
                width: 45,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: new BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  border: Border(left: BorderSide(color: darkColor, width: 4))),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextHelpers().simpleTextCard(
                            widget.message.you == 1
                                ? AppLocalizations.of("You")
                                : widget.message.username!,
                            FontWeight.w500,
                            14,
                            darkColor,
                            1,
                            TextOverflow.ellipsis),
                        _closeButton()
                      ],
                    ),
                    _sizedBox(3, 0),
                    Row(
                      children: [
                        _icon(
                            widget.message.messageType == "image"
                                ? Icons.photo
                                : Icons.videocam_sharp,
                            14),
                        _sizedBox(0, 3),
                        TextHelpers().simpleTextCard(
                            widget.message.messageType!
                                .replaceAll("v", "V")
                                .replaceAll("i", "I"),
                            FontWeight.normal,
                            14,
                            Colors.grey.shade600,
                            3,
                            TextOverflow.ellipsis),
                        _sizedBox(0, 3),
                        widget.message.messageType == "video"
                            ? TextHelpers().simpleTextCard(
                                "(${widget.message.videoPlaytime})",
                                FontWeight.normal,
                                14,
                                Colors.grey.shade600,
                                3,
                                TextOverflow.ellipsis)
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeFile() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
            width: double.infinity,
            decoration: new BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                border: Border(left: BorderSide(color: darkColor, width: 4))),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelpers().simpleTextCard(
                          widget.message.you == 1
                              ? AppLocalizations.of("You")
                              : widget.message.username!,
                          FontWeight.w500,
                          14,
                          darkColor,
                          1,
                          TextOverflow.ellipsis),
                      _closeButton()
                    ],
                  ),
                  _sizedBox(3, 0),
                  Row(
                    children: [
                      _icon(Icons.file_copy_rounded, 14),
                      _sizedBox(0, 3),
                      TextHelpers().simpleTextCard(
                          widget.message.fileNameUploaded!.split("/").last,
                          FontWeight.normal,
                          14,
                          Colors.grey.shade600,
                          3,
                          TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _typeLink() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Row(
          children: [
            Container(
              key: keyText,
              decoration: new BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  border: Border(left: BorderSide(color: darkColor, width: 4))),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: widget.message.message!.split("~~~")[2] != ""
                      ? 100.0.w - 150
                      : 100.0.w - 95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextHelpers().simpleTextCard(
                              widget.message.you == 1
                                  ? AppLocalizations.of("You")
                                  : widget.message.username!,
                              FontWeight.w500,
                              14,
                              darkColor,
                              1,
                              TextOverflow.ellipsis),
                          _closeButton()
                        ],
                      ),
                      _sizedBox(3, 0),
                      Row(
                        children: [
                          Expanded(
                              child: TextHelpers().simpleTextCard(
                                  widget.message.message!.split("~~~")[4],
                                  FontWeight.normal,
                                  14,
                                  Colors.grey.shade600,
                                  3,
                                  TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.message.message!.split("~~~")[2] != ""
                ? _imageCard(widget.message.message!.split("~~~")[2], h, 55)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _typeAudioVoice() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              border: Border(left: BorderSide(color: darkColor, width: 4))),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextHelpers().simpleTextCard(
                        widget.message.you == 1
                            ? "You"
                            : widget.message.username!,
                        FontWeight.w500,
                        14,
                        darkColor,
                        1,
                        TextOverflow.ellipsis),
                    _closeButton()
                  ],
                ),
                _sizedBox(3, 0),
                Row(
                  children: [
                    _icon(
                        widget.message.messageType == "audio"
                            ? Icons.headset
                            : Icons.mic,
                        14),
                    _sizedBox(0, 3),
                    TextHelpers().simpleTextCard(
                        widget.message.messageType == "audio"
                            ? AppLocalizations.of("Audio")
                            : AppLocalizations.of("Voice Message"),
                        FontWeight.normal,
                        14,
                        Colors.grey.shade600,
                        3,
                        TextOverflow.ellipsis),
                    _sizedBox(0, 3),
                    TextHelpers().simpleTextCard(
                        "(${widget.message.audioDuration})",
                        FontWeight.normal,
                        14,
                        Colors.grey.shade600,
                        3,
                        TextOverflow.ellipsis)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeContact() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Row(
          children: [
            Container(
              decoration: new BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  border: Border(left: BorderSide(color: darkColor, width: 4))),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: 100.0.w - 145,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 55.0.w,
                            child: TextHelpers().simpleTextCard(
                                widget.message.you == 1
                                    ? AppLocalizations.of("You")
                                    : widget.message.username!,
                                FontWeight.w500,
                                14,
                                darkColor,
                                1,
                                TextOverflow.ellipsis),
                          ),
                          _closeButton()
                        ],
                      ),
                      _sizedBox(3, 0),
                      Row(
                        children: [
                          _icon(Icons.person, 14),
                          _sizedBox(0, 3),
                          Expanded(
                              child: TextHelpers().simpleTextCard(
                                  AppLocalizations.of("Contact") +
                                      ": ${widget.message.contactName}",
                                  FontWeight.normal,
                                  14,
                                  Colors.grey.shade600,
                                  3,
                                  TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                color: Colors.grey.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  color: darkColor.withOpacity(0.2),
                  size: 48,
                ))
          ],
        ),
      ),
    );
  }

  Widget _typeLocation() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              key: keyText,
              decoration: new BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  border: Border(left: BorderSide(color: darkColor, width: 4))),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: 100.0.w - 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 55.0.w,
                            child: TextHelpers().simpleTextCard(
                                widget.message.you == 1
                                    ? AppLocalizations.of("You")
                                    : widget.message.username!,
                                FontWeight.w500,
                                14,
                                darkColor,
                                1,
                                TextOverflow.ellipsis),
                          ),
                          _closeButton()
                        ],
                      ),
                      _sizedBox(3, 0),
                      Row(
                        children: [
                          Expanded(
                              child: TextHelpers().simpleTextCard(
                                  widget.message.locationTitle!,
                                  FontWeight.normal,
                                  14,
                                  Colors.grey.shade600,
                                  1,
                                  TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _imageCard(widget.message.url.toString().replaceAll("/resized", ""),
                48, 55)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.message.messageType == "link") {
      calculateHeight();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        color: Colors.transparent,
        child: widget.message.messageType == "text"
            ? _typeText()
            : widget.message.messageType == "image" ||
                    widget.message.messageType == "video"
                ? _typeMedia()
                : widget.message.messageType == "file"
                    ? _typeFile()
                    : widget.message.messageType == "link"
                        ? _typeLink()
                        : widget.message.messageType == "audio" ||
                                widget.message.messageType == "voice"
                            ? _typeAudioVoice()
                            : widget.message.messageType == "location"
                                ? _typeLocation()
                                : widget.message.messageType == "contact"
                                    ? _typeContact()
                                    : Container(
                                        height: 20,
                                      ),
      ),
    );
  }
}
