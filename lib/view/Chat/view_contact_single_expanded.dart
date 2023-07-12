import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/group_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Chat/starred_messages_screen.dart';
import 'package:bizbultest/view/Chat/view_single_file.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'all_media_page_chat.dart';
import 'detailed_group_chat_screen.dart';

class ViewContactSingle extends StatefulWidget {
  final String? name;
  final String? image;
  final String? memberID;
  final String? token;
  final int? blocked;
  final List<ChatMessagesModel>? messages;

  const ViewContactSingle(
      {Key? key,
      this.name,
      this.image,
      this.memberID,
      this.blocked,
      this.messages,
      this.token})
      : super(key: key);

  @override
  _ViewContactSingleState createState() => _ViewContactSingleState();
}

class _ViewContactSingleState extends State<ViewContactSingle> {
  ScrollController _controller = ScrollController();
  int blocked = 0;

  @override
  void initState() {
    blocked = widget.blocked!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(MediaQuery.of(context).size.height * 0.35);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: darkColor,
        body: SafeArea(
          child: Container(
            color: Colors.grey.shade300,
            child: CustomScrollView(
              controller: _controller,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  forceElevated: false,
                  elevation: 6,
                  backgroundColor: darkColor,
                  floating: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.40,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    title: Text(
                      widget.name!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    background: Container(
                      color: darkColor,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: Image.network(
                        widget.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  MediaAndLinks(
                    name: widget.name!,
                    messages: widget.messages!,
                    memberID: widget.memberID!,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  NotificationsAndMedia(
                    memberID: widget.memberID!,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  AboutAndNumber(
                    memberID: widget.memberID!,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  CommonGroups(
                    memberID: widget.memberID,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        if (blocked == 0) {
                          showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (BuildContext blockContext) {
                                return BlockPopup(
                                    action: 0,
                                    onTapOk: () {
                                      Navigator.pop(blockContext);
                                      showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext processingContext) {
                                            ChatApiCalls()
                                                .blockUser(widget.memberID!)
                                                .then((value) {
                                              if (mounted) {
                                                setState(() {
                                                  blocked = 1;
                                                });
                                              }
                                              Navigator.of(processingContext,
                                                      rootNavigator: true)
                                                  .pop();
                                            });
                                            return ProcessingDialog(
                                              title: AppLocalizations.of(
                                                "Please wait a moment",
                                              ),
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
                              builder: (BuildContext unblockContext) {
                                ChatApiCalls()
                                    .unblockUser(widget.memberID!)
                                    .then((value) {
                                  setState(() {
                                    blocked = 0;
                                  });
                                  Navigator.of(unblockContext,
                                          rootNavigator: true)
                                      .pop();
                                });
                                return ProcessingDialog(
                                  title: AppLocalizations.of(
                                    "Please wait a moment",
                                  ),
                                  heading: "",
                                );
                              });
                        }
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      dense: false,
                      leading: Icon(
                        CustomIcons.prohibition,
                        color: blocked == 0 ? Colors.red.shade800 : Colors.grey,
                      ),
                      title: Text(
                        blocked == 0
                            ? AppLocalizations.of("Block")
                            : AppLocalizations.of("Unblock"),
                        style: TextStyle(
                            fontSize: 16,
                            color: blocked == 0
                                ? Colors.red.shade800
                                : Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        bool isExit = true;

                        showDialog(
                            context: context,
                            builder: (BuildContext reportContext) {
                              return ReportPopup(
                                action: AppLocalizations.of(
                                  "Exit group and delete this group's messages",
                                ),
                                exit: (bool exit) {
                                  isExit = exit;
                                },
                                onTapOk: () {
                                  if (isExit) {
                                    Navigator.of(reportContext,
                                            rootNavigator: true)
                                        .pop();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext exitContext) {
                                        ChatApiCalls()
                                            .removeUser(widget.memberID!)
                                            .then((value) {
                                          Navigator.of(exitContext,
                                                  rootNavigator: true)
                                              .pop();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          customToastWhite(
                                              "Report sent and ${widget.name}'s chat has been deleted",
                                              14.0,
                                              ToastGravity.CENTER);
                                          GroupApiCalls.reportMember(
                                              widget.memberID!);
                                        });

                                        return ProcessingDialog(
                                          title: AppLocalizations.of(
                                            "Please wait a moment",
                                          ),
                                          heading: AppLocalizations.of(
                                            "Reporting..",
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.of(reportContext,
                                            rootNavigator: true)
                                        .pop();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    customToastWhite(
                                        AppLocalizations.of(
                                          "Report sent",
                                        ),
                                        14.0,
                                        ToastGravity.CENTER);
                                    GroupApiCalls.reportMember(
                                        widget.memberID!);
                                  }
                                },
                                title: AppLocalizations.of(
                                  "Report this group to Bebuzee?",
                                ),
                                subtitle: AppLocalizations.of(
                                  "Most recent messages in this group will be forwarded to Bebuzee",
                                ),
                              );
                            });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      dense: false,
                      leading: RotatedBox(
                          quarterTurns: 2,
                          child: Icon(
                            CustomIcons.videolike2,
                            color: Colors.red.shade800,
                          )),
                      title: Text(
                        AppLocalizations.of("Report contact"),
                        style:
                            TextStyle(fontSize: 16, color: Colors.red.shade800),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 20,
                  ),
                ]))
              ],
            ),
          ),
        ),
      );
}

class MediaAndLinks extends StatelessWidget {
  final List<ChatMessagesModel>? messages;
  final String? memberID;
  final String? token;
  final String? name;

  const MediaAndLinks(
      {Key? key, this.messages, this.memberID, this.token, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllMediaPageChat(
                      title: name!,
                      uniqueID: memberID!,
                      token: token!,
                      from: "chat",
                    )));
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(
                          "Media, links and docs",
                        ),
                        style: TextStyle(
                            color: darkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        messages?.length?.toString() ?? "0",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 70,
                  child: ListView.builder(
                      itemCount: (messages?.length ?? 0) + 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == (messages?.length ?? 0)) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllMediaPageChat(
                                            title: name!,
                                            uniqueID: memberID!,
                                            token: token!,
                                            from: "chat",
                                          )));
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 70,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 26,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewSingleChatFile(
                                                token: token,
                                                memberID: memberID,
                                                messages: messages,
                                                selectedIndex: index,
                                              )));
                                },
                                child: Container(
                                    width: 70,
                                    child: ChatMediaCard(
                                      path: messages![index].you == 0
                                          ? messages![index].receiverThumbnail!
                                          : messages![index].thumbPath!,
                                      image: messages![index].messageType ==
                                              "video"
                                          ? messages![index]
                                              .videoImage!
                                              .replaceAll(".mp4", ".jpg")
                                          : messages![index]
                                              .imageData
                                              .toString()
                                              .replaceAll("/resized", ""),
                                    ))),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsAndMedia extends StatefulWidget {
  final String? memberID;

  const NotificationsAndMedia({Key? key, this.memberID}) : super(key: key);

  @override
  _NotificationsAndMediaState createState() => _NotificationsAndMediaState();
}

class _NotificationsAndMediaState extends State<NotificationsAndMedia> {
  ChatMessages _messages = new ChatMessages([]);
  Future<ChatMessages>? _starredMessages;

  void _getStarredMessages() {
    _starredMessages =
        ChatApiCalls.getStarredMessagesSingleUser(widget.memberID!)
            .then((value) {
      setState(() {
        _messages.messages = value.messages;
      });
      return value;
    });
  }

  @override
  void initState() {
    _getStarredMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              print("notiii");
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            dense: false,
            title: Text(
              AppLocalizations.of("Mute notifications"),
              style: TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            dense: false,
            title: Text(
              AppLocalizations.of(
                "Custom notifications",
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            dense: false,
            title: Text(
              AppLocalizations.of(
                "Media Visibility",
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StarredMessagesScreen(messages: _messages.messages)));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            dense: false,
            title: Text(
              AppLocalizations.of(
                "Starred Messages",
              ),
              style: TextStyle(fontSize: 16),
            ),
            trailing: _messages.messages.length > 0
                ? Text(
                    _messages.messages.length.toString(),
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
          ),
        ],
      ),
    );
  }
}

class AboutAndNumber extends StatefulWidget {
  final String? memberID;

  const AboutAndNumber({Key? key, this.memberID}) : super(key: key);

  @override
  _AboutAndNumberState createState() => _AboutAndNumberState();
}

class _AboutAndNumberState extends State<AboutAndNumber> {
  late Future _infoFuture;

  _getSelectedStatus() {
    _infoFuture =
        DirectApiCalls.getStatusAndNumber(widget.memberID!).then((value) {
      return value;
    });
  }

  @override
  void initState() {
    _getSelectedStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FutureBuilder(
            future: _infoFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          AppLocalizations.of(
                            "About and phone number",
                          ),
                          style: TextStyle(
                              color: darkColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        dense: false,
                        title: Text(
                          snapshot.data.toString().split(",")[0],
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          snapshot.data.toString().split(",")[1],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        dense: false,
                        trailing: Container(
                          width: 145,
                          child: Row(
                            children: [
                              Builder(
                                builder: (BuildContext context) {
                                  return IconButton(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    icon: Icon(
                                      Icons.message,
                                      color: darkColor,
                                    ),
                                    onPressed: () {},
                                  );
                                },
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  return IconButton(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    icon: Icon(
                                      Icons.call,
                                      color: darkColor,
                                    ),
                                    onPressed: () {},
                                  );
                                },
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  return IconButton(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    icon: Icon(
                                      Icons.videocam_sharp,
                                      color: darkColor,
                                    ),
                                    onPressed: () {},
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        title: Text(
                          snapshot.data.toString().split(",")[2],
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(
                            "Mobile",
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}

class CommonGroups extends StatefulWidget {
  final String? memberID;

  const CommonGroups({Key? key, this.memberID}) : super(key: key);

  @override
  _CommonGroupsState createState() => _CommonGroupsState();
}

class _CommonGroupsState extends State<CommonGroups> {
  late Future _future;
  DirectUsers _commonGroups = new DirectUsers([]);
  UpdateTypingStatusGroup _typingStatus = UpdateTypingStatusGroup();

  void _getCommonGroups() {
    _future = GroupApiCalls.getCommonGroupsList(widget.memberID!).then((value) {
      setState(() {
        _commonGroups = value!;
      });

      return value;
    });
  }

  @override
  void initState() {
    _getCommonGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(
                              "Groups in common",
                            ),
                            style: TextStyle(
                                color: darkColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${_commonGroups.users.length.toString()}",
                            style: TextStyle(
                                color: darkColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _commonGroups.users.length,
                        itemBuilder: (context, index) {
                          var group = _commonGroups.users[index];
                          return ListTile(
                            onTap: () {
                              _typingStatus.updateRefresh(
                                  CurrentUser().currentUser.memberID! +
                                      "-" +
                                      "");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailedGroupChatScreen(
                                            topic: group.topic!,
                                            token: group.token!,
                                            name: group.name!,
                                            image: group.image!,
                                            groupID: group.fromuserid!,
                                            members: group.groupMembers!,
                                          )));
                            },
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            leading: CircleAvatar(
                              radius: 24.0,
                              backgroundColor: darkColor,
                              backgroundImage:
                                  CachedNetworkImageProvider(group.image!),
                            ),
                            title: Text(
                              group.name!,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              group.groupMembers!.replaceAll(",", ", ") +
                                  ", You",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black45),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                    Container(
                      color: Colors.grey.shade300,
                      height: 15,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

class ChatMediaCard extends StatelessWidget {
  final String? path;
  final String? image;

  const ChatMediaCard({Key? key, this.path, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (File(path!).existsSync()) {
      return Image.file(
        File(path!),
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        image!,
        fit: BoxFit.cover,
      );
    }
  }
}
