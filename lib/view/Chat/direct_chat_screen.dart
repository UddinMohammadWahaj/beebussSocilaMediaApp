import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:bizbultest/models/Chat/direct_user_model.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DirectSearchedUserCard extends StatelessWidget {
  final DirectUserModel? user;
  final VoidCallback? onTap;

  const DirectSearchedUserCard({Key? key, this.user, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.0,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(user!.image!),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  width: 60.0.w,
                  child: Text(
                    user!.name!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class DirectChatUserCard extends StatefulWidget {
  final DirectMessageUserListModel? user;
  final VoidCallback? onTap;
  final String? from;
  final VoidCallback? onLongTap;
  final int? smallSize;

  const DirectChatUserCard(
      {Key? key,
      this.user,
      this.onTap,
      this.from,
      this.onLongTap,
      this.smallSize})
      : super(key: key);

  @override
  _DirectChatUserCardState createState() => _DirectChatUserCardState();
}

class _DirectChatUserCardState extends State<DirectChatUserCard> {
  Widget _icon(double rightPadding, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: Icon(
        icon,
        color: color,
        size: 17,
      ),
    );
  }

  Widget _muteIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 6),
      child: Container(
          child: Icon(
        CustomIcons.mute,
        color: Colors.grey,
        size: 12,
      )),
    );
  }

  Widget _emptyContainer() {
    return Container(
      height: 0,
      width: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.user!.isSelected!
          ? Colors.grey.withOpacity(0.3)
          : Colors.transparent,
      child: ListTile(
        leading: Stack(
          children: [
            widget.user!.chatType == "broadcast"
                ? CircleAvatar(
                    radius: 28.0,
                    backgroundColor: darkColor.withOpacity(0.4),
                    child: Icon(
                      CustomIcons.broadcast,
                      color: Colors.white,
                      size: 22,
                    ),
                  )
                : CircleAvatar(
                    radius: widget.smallSize == 1 ? 22 : 28.0,
                    backgroundColor: darkColor,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.user!.image!,
                    ),
                  ),
            widget.user!.isSelected!
                ? Positioned(
                    top: 37,
                    left: 37,
                    child: Container(
                        decoration: new BoxDecoration(
                          color: darkColor,
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: _icon(0, Icons.check, Colors.white)),
                  )
                : _emptyContainer()
          ],
        ),
        onTap: widget.onTap ?? () {},
        onLongPress: widget.onLongTap ?? () {},
        title: Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
            widget.user!.name! == null
                ? AppLocalizations.of("Name")
                : widget.user!.name!,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: widget.from == "forward"
            ? Container(
                child: Text(
                  widget.user!.userStatus!,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54),
                ),
              )
            : Row(
                // direction: Axis.horizontal,
                children: [
                  widget.user!.inOut == "message-out" &&
                          widget.user!.typeMessage != "deleted" &&
                          widget.user!.typeMessage != "removed" &&
                          widget.user!.typeMessage != "added" &&
                          widget.user!.typeMessage != "unblocked" &&
                          widget.user!.typeMessage != "blocked" &&
                          widget.user!.typeMessage != "exit" &&
                          widget.user!.typeMessage != "group_name" &&
                          widget.user!.typeMessage != "group_desc" &&
                          widget.user!.typeMessage != "group_msg_setting" &&
                          widget.user!.typeMessage != "group_msg_edit"
                      ? _icon(
                          5,
                          CustomIcons.double_tick_indicator,
                          widget.user!.readStatus == "0"
                              ? Colors.black54
                              : primaryBlueColor)
                      : widget.user!.typeMessage == "deleted"
                          ? Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                CustomIcons.prohibition,
                                size: 14,
                                color: Colors.black54,
                              ),
                            )
                          : _emptyContainer(),
                  widget.user!.typeMessage == "image"
                      ? _icon(3, Icons.photo, Colors.grey)
                      : widget.user!.typeMessage == "video"
                          ? _icon(3, Icons.videocam_sharp, Colors.grey)
                          : widget.user!.typeMessage == "file"
                              ? _icon(3, Icons.insert_drive_file, Colors.grey)
                              : widget.user!.typeMessage == "audio"
                                  ? _icon(3, Icons.headset, Colors.grey)
                                  : widget.user!.typeMessage == "voice"
                                      ? _icon(3, Icons.mic, Colors.grey)
                                      : widget.user!.typeMessage == "contact"
                                          ? _icon(3, Icons.person, Colors.grey)
                                          : widget.user!.typeMessage ==
                                                  "location"
                                              ? _icon(3, Icons.location_on,
                                                  Colors.grey)
                                              : widget.user!.typeMessage ==
                                                      "gif_url"
                                                  ? _icon(
                                                      3, Icons.gif, Colors.grey)
                                                  : widget.user!.typeMessage ==
                                                          "board"
                                                      ? _icon(3, Icons.bookmark,
                                                          Colors.grey)
                                                      : Container(
                                                          height: 0,
                                                          width: 0,
                                                        ),
                  Container(
                    child: Expanded(
                      child: Text(
                        widget.user!.typeMessage! == "image"
                            ? AppLocalizations.of(
                                "Image",
                              )
                            : widget.user!.typeMessage! == "video"
                                ? AppLocalizations.of("Video")
                                : widget.user!.typeMessage! == "file"
                                    ? widget.user!.fileName!
                                    : widget.user!.typeMessage == "audio"
                                        ? AppLocalizations.of("Audio")
                                        : widget.user!.typeMessage! == "voice"
                                            ? AppLocalizations.of("Voice")
                                            : widget.user!.typeMessage! ==
                                                    "contact"
                                                ? widget.user!.messageData!
                                                    .split("^^^")[0]
                                                : widget.user!.typeMessage! ==
                                                        "location"
                                                    ? AppLocalizations.of(
                                                        "Location")
                                                    : widget.user!
                                                                .typeMessage ==
                                                            "gif_url"
                                                        ? AppLocalizations.of(
                                                            "GIF")
                                                        : widget.user!
                                                                    .typeMessage ==
                                                                "board"
                                                            ? AppLocalizations
                                                                .of("Board")
                                                            : widget.user!
                                                                .messageData!,
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.normal,
                            color: Colors.black54,
                            fontStyle: widget.user!.typeMessage == "deleted"
                                ? FontStyle.italic
                                : FontStyle.normal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
        trailing: widget.from == "forward"
            ? _emptyContainer()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user!.time! == null ? "" : widget.user!.time!,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.user!.inOut == "message-in" &&
                                widget.user!.readStatus == "0"
                            ? darkColor
                            : Colors.black54),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        widget.user!.mute == 1
                            ? _muteIcon()
                            : _emptyContainer(),
                        widget.from == "ar"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 3.0, right: 4, left: 4),
                                child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      shape: BoxShape.rectangle,
                                      border: new Border.all(
                                        color: Colors.grey,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        AppLocalizations.of('Archived'),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )),
                              )
                            : _emptyContainer(),
                        widget.user!.inOut == "message-in" &&
                                widget.user!.readStatus == "0"
                            ? Container(
                                decoration: new BoxDecoration(
                                  color: darkColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    widget.user!.totalUnread.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ))
                            : _emptyContainer(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class MinimalUserCard extends StatelessWidget {
  final DirectMessageUserListModel? user;
  final VoidCallback? onTap;
  final String? from;
  final VoidCallback? onLongTap;
  final int? admin;

  const MinimalUserCard(
      {Key? key, this.user, this.onTap, this.from, this.onLongTap, this.admin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          user!.isSelected! ? Colors.grey.withOpacity(0.3) : Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: darkColor,
          backgroundImage: CachedNetworkImageProvider(user!.image!),
        ),
        onTap: onTap ?? () {},
        onLongPress: onLongTap ?? () {},
        title: Text(
          user!.name!,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Container(
          child: Text(
            user!.userStatus!,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black54),
          ),
        ),
        trailing: user!.admin == 1
            ? Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: darkColor,
                    width: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    AppLocalizations.of(
                      "Group Admin",
                    ),
                    style: TextStyle(color: darkColor, fontSize: 11),
                  ),
                ))
            : Container(
                height: 0,
                width: 0,
              ),
      ),
    );
  }
}
