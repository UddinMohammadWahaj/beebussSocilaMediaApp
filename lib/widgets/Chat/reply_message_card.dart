import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/text_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class ReplyMessageCard extends StatefulWidget {
  final ChatMessagesModel message;

  const ReplyMessageCard({Key? key, required this.message}) : super(key: key);

  @override
  _ReplyMessageCardState createState() => _ReplyMessageCardState();
}

class _ReplyMessageCardState extends State<ReplyMessageCard> {
  Widget _icon(IconData icon, double size) {
    return Icon(
      icon,
      color: Colors.grey,
      size: size,
    );
  }

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

  Widget _commonText() {
    return TextHelpers().simpleTextCard(
        widget.message.replyParameters![0].name!,
        FontWeight.w500,
        14,
        darkColor,
        1,
        TextOverflow.ellipsis);
  }

  Widget _commonDecoration(Widget widget) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
            constraints: BoxConstraints(minWidth: 75),
            decoration: new BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                border: Border(left: BorderSide(color: darkColor, width: 4))),
            child: Padding(padding: const EdgeInsets.all(5), child: widget)),
      ),
    );
  }

  Widget _textReply() {
    return _commonDecoration(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commonText(),
          _sizedBox(3, 0),
          TextHelpers().simpleTextCard(
              widget.message.replyParameters![0].message!,
              FontWeight.normal,
              14,
              Colors.grey.shade600,
              3,
              TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _mediaReply() {
    String text = "";
    if (widget.message.replyParameters![0].type == "image") {
      text = "Image";
    } else {
      text = "Video";
    }

    return _commonDecoration(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _commonText(),
              _sizedBox(3, 0),
              Row(
                children: [
                  _icon(
                      widget.message.replyParameters![0].type == "image"
                          ? Icons.photo
                          : Icons.videocam_sharp,
                      12),
                  _sizedBox(0, 3),
                  TextHelpers().simpleTextCard(text, FontWeight.normal, 14,
                      Colors.grey.shade600, 3, TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
          _sizedBox(0, 10),
          _imageCard(widget.message.replyParameters![0].thumb!, 50, 50)
        ],
      ),
    );
  }

  Widget _fileReply() {
    return _commonDecoration(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commonText(),
          _sizedBox(3, 0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _icon(Icons.insert_drive_file, 12),
              _sizedBox(0, 3),
              TextHelpers().simpleTextCard(
                  widget.message.replyParameters![0].fileName!,
                  FontWeight.normal,
                  14,
                  Colors.grey.shade600,
                  3,
                  TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationReply() {
    return _commonDecoration(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _commonText(),
              _sizedBox(3, 0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _icon(Icons.location_on, 12),
                  _sizedBox(0, 3),
                  Container(
                    constraints: BoxConstraints(maxWidth: 175),
                    child: TextHelpers().simpleTextCard(
                        widget.message.replyParameters![0].message == ""
                            ? "Location"
                            : widget.message.replyParameters![0].message!,
                        FontWeight.normal,
                        14,
                        Colors.grey.shade600,
                        1,
                        TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
          _sizedBox(0, 10),
          _imageCard(widget.message.replyParameters![0].thumb!, 50, 50)
        ],
      ),
    );
  }

  Widget _contactReply() {
    return _commonDecoration(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _commonText(),
              _sizedBox(3, 0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _icon(Icons.location_on, 12),
                  _sizedBox(0, 3),
                  Container(
                    constraints: BoxConstraints(maxWidth: 175),
                    child: TextHelpers().simpleTextCard(
                        widget.message.replyParameters![0].message!,
                        FontWeight.normal,
                        14,
                        Colors.grey.shade600,
                        1,
                        TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
          _sizedBox(0, 10),
          Container(
              color: Colors.grey.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: darkColor.withOpacity(0.3),
                size: 48,
              )),
        ],
      ),
    );
  }

  Widget _audioReply() {
    return _commonDecoration(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commonText(),
          _sizedBox(3, 0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _icon(
                  widget.message.replyParameters![0].type == "audio"
                      ? Icons.headset
                      : Icons.mic,
                  12),
              _sizedBox(0, 3),
              TextHelpers().simpleTextCard(
                  widget.message.replyParameters![0].message!,
                  FontWeight.normal,
                  14,
                  Colors.grey.shade600,
                  3,
                  TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linkReply() {
    return _commonDecoration(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _commonText(),
              _sizedBox(3, 0),
              Container(
                constraints: BoxConstraints(
                    maxWidth: widget.message.replyParameters![0].message!
                                .split("~~~")[2] !=
                            ""
                        ? 249
                        : 80.0.w),
                child: TextHelpers().simpleTextCard(
                    widget.message.replyParameters![0].message!.split("~~~")[4],
                    FontWeight.normal,
                    14,
                    Colors.grey.shade600,
                    2,
                    TextOverflow.ellipsis),
              ),
            ],
          ),
          _sizedBox(0, 10),
          widget.message.replyParameters![0].message!.split("~~~")[2] != ""
              ? _imageCard(widget.message.replyParameters![0].thumb!, 50, 50)
              : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.message.replyParameters![0].type == "text"
          ? _textReply()
          : widget.message.replyParameters![0].type == "image" ||
                  widget.message.replyParameters![0].type == "video"
              ? _mediaReply()
              : widget.message.replyParameters![0].type == "file"
                  ? _fileReply()
                  : widget.message.replyParameters![0].type == "location"
                      ? _locationReply()
                      : widget.message.replyParameters![0].type == "contact"
                          ? _contactReply()
                          : widget.message.replyParameters![0].type ==
                                      "audio" ||
                                  widget.message.replyParameters![0].type ==
                                      "voice"
                              ? _audioReply()
                              : widget.message.replyParameters![0].type ==
                                      "link"
                                  ? _linkReply()
                                  : Container(),
    );
  }
}
