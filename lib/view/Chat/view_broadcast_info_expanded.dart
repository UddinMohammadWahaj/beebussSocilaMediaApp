import 'dart:async';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/services/Chat/broadcast_api.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Chat/view_singe_group_file.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/group_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Chat/view_contact_single_expanded.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'detailed_chat_screen.dart';
import 'detailed_group_chat_screen.dart';
import 'direct_chat_screen.dart';
import 'new_group_select_users_page.dart';

class ViewBroadcastInfoExpanded extends StatefulWidget {
  final String? name;
  final String? image;
  final String? groupID;
  final String? groupMembers;
  final String? topic;
  final int? groupStatus;
  final List<ChatMessagesModel>? messages;

  const ViewBroadcastInfoExpanded(
      {Key? key,
      this.name,
      this.image,
      this.groupID,
      this.groupMembers,
      this.topic,
      this.groupStatus,
      this.messages})
      : super(key: key);

  @override
  _ViewBroadcastInfoExpandedState createState() =>
      _ViewBroadcastInfoExpandedState();
}

class _ViewBroadcastInfoExpandedState extends State<ViewBroadcastInfoExpanded> {
  ScrollController _controller = ScrollController();
  bool isSearchOpen = false;
  bool isCurrentMemberAdmin = false;
  int groupStatus = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(MediaQuery.of(context).size.height * 0.20);
      }
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                  brightness: Brightness.dark,
                  automaticallyImplyLeading: false,
                  forceElevated: false,
                  elevation: 3,
                  backgroundColor: darkColor,
                  floating: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.40,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name!.split(", ").length.toString() +
                              " recipients",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Created on 25/10/2020",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    background: Container(
                        color: darkColor.withOpacity(0.1),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                        child: Icon(CustomIcons.broadcast,
                            color: Colors.white.withOpacity(0.3),
                            size: MediaQuery.of(context).size.height * 0.10)),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  widget.messages!.length > 0
                      ? MediaAndLinks(
                          topic: widget.topic,
                          groupID: widget.groupID,
                          messages: widget.messages,
                        )
                      : Container(),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  BroadcastRecipeints(
                    groupStatus: groupStatus,
                    openSearch: () {
                      setState(() {
                        isSearchOpen = true;
                      });
                    },
                    name: widget.name,
                    sKey: _scaffoldKey,
                    groupID: widget.groupID,
                    topic: widget.topic,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext mainContext) {
                              return Container();
                            });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      dense: false,
                      leading: Icon(
                        CustomIcons.prohibition,
                        color: Colors.red.shade800,
                      ),
                      title: Text(
                        AppLocalizations.of(
                          "Delete broadcast list",
                        ),
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
  final String? groupID;
  final String? topic;

  const MediaAndLinks({Key? key, this.messages, this.groupID, this.topic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      messages!.length.toString(),
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
                    itemCount: messages!.length + 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (index == messages!.length) {
                        return GestureDetector(
                          onTap: () {},
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
                                      builder: (context) => ViewSingleGroupFile(
                                            topic: topic,
                                            memberID: groupID,
                                            messages: messages,
                                            selectedIndex: index,
                                          )));
                            },
                            child: Container(
                                width: 70,
                                child: Image.file(
                                  File(messages![index].you! == 0
                                      ? messages![index].receiverDevicePath!
                                      : messages![index].path!),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        );
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BroadcastRecipeints extends StatefulWidget {
  final String? groupID;
  final GlobalKey<ScaffoldState>? sKey;
  final String? name;
  final Function? openSearch;
  final String? topic;
  final int? groupStatus;

  const BroadcastRecipeints(
      {Key? key,
      this.groupID,
      this.sKey,
      this.name,
      this.openSearch,
      this.topic,
      this.groupStatus})
      : super(key: key);

  @override
  _BroadcastRecipeintsState createState() => _BroadcastRecipeintsState();
}

class _BroadcastRecipeintsState extends State<BroadcastRecipeints> {
  late Future _future;
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  DirectUsers _broadcastUsers = new DirectUsers([]);
  bool isCurrentMemberAdmin = false;
  int groupStatus = 0;

  void _getUsers() {
    _future = BroadcastApiCalls.getSelectedBroadcastUserList(widget.groupID!)
        .then((value) {
      if (mounted) {
        setState(() {
          _broadcastUsers.users = value.users;
        });
      }
      return value;
    });
  }

  Future<void> _showPopupMenu(
      DirectMessageUserListModel user, int index) async {
    int selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(350, 400, 25, 400),
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          value: 0,
          child: Text(AppLocalizations.of(
                'Message',
              ) +
              " ${user.name}"),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(AppLocalizations.of(
                'View',
              ) +
              " ${user.name}"),
        ),
        isCurrentMemberAdmin && groupStatus == 0
            ? PopupMenuItem(
                value: 2,
                child: Text(user.admin == 0
                    ? AppLocalizations.of(
                        "Make group admin",
                      )
                    : AppLocalizations.of("Dismiss as admin")),
              )
            : PopupMenuItem(child: Container()),
        isCurrentMemberAdmin && groupStatus == 0
            ? PopupMenuItem(
                value: 3,
                child: Text(AppLocalizations.of(
                      "Remove",
                    ) +
                    " ${user.name}"),
              )
            : PopupMenuItem(
                value: 3,
                child: Container(),
              ),
      ],
      elevation: 8.0,
    );
    if (selected == 0) {
      print(user.name);
      setState(() {
        CurrentUser().currentUser.currentOpenMemberID = user.fromuserid;
      });
      _status.updateRefresh(user.onlineStatus);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedChatScreen(
                    token: user.token!,
                    name: user.name!,
                    image: user.image!,
                    memberID: user.fromuserid!,
                  )));
    } else if (selected == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewContactSingle(
                    memberID: user.fromuserid,
                    name: user.name,
                    image: user.image,
                  )));
    } else if (selected == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(user.fromuserid);
        print(widget.groupID);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (user.admin == 0) {
              GroupApiCalls()
                  .makeGroupAdmin(
                      user.fromuserid!, widget.groupID!, widget.topic!)
                  .then((value) {
                _getUsers();
                Timer(Duration(milliseconds: 100),
                    () => Navigator.of(context, rootNavigator: true).pop());
              });
              return ProcessingDialog(
                title: AppLocalizations.of(
                  "Please wait a moment",
                ),
                heading: AppLocalizations.of(
                  "Adding...",
                ),
              );
            } else {
              GroupApiCalls()
                  .removeGroupAdmin(
                      user.fromuserid!, widget.groupID!, widget.topic!)
                  .then((value) {
                _getUsers();
                Timer(Duration(milliseconds: 100),
                    () => Navigator.of(context, rootNavigator: true).pop());
              });
              return ProcessingDialog(
                title: AppLocalizations.of(
                  "Please wait a moment",
                ),
                heading: AppLocalizations.of(
                  "Removing...",
                ),
              );
            }
          },
        );
      });
    } else if (selected == 3) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicCancelOkPopup(
              title: 'Remove ${user.name} from "${widget.name}" group?',
              onTapOk: () {
                Navigator.of(context, rootNavigator: true).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      GroupApiCalls()
                          .removeMembersFromGroup(
                              user.fromuserid!, widget.groupID!, widget.topic!)
                          .then((value) {
                        _getUsers();
                        Timer(
                            Duration(milliseconds: 100),
                            () => Navigator.of(context, rootNavigator: true)
                                .pop());
                      });
                      return ProcessingDialog(
                        title: AppLocalizations.of(
                          "Please wait a moment",
                        ),
                        heading: AppLocalizations.of(
                          "Removing...",
                        ),
                      );
                    });
              },
            );
          });
    }
  }

  GroupMembersRefresh _refresh = GroupMembersRefresh();

  @override
  void initState() {
    print(widget.groupStatus);
    groupStatus = widget.groupStatus!;
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: _refresh.currentSelect,
        stream: _refresh.observableCart,
        builder: (context, dynamic snapshot) {
          if (snapshot.data) {
            _getUsers();

            //_exitGroup();
            print("refresh group users");
            _refresh.updateRefresh(false);
          }
          return FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Container(
                              child: Text(
                                "${_broadcastUsers.users.length.toString()} recipients",
                                style: TextStyle(
                                    color: darkColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: isCurrentMemberAdmin
                                ? _broadcastUsers.users.length + 2
                                : _broadcastUsers.users.length,
                            itemBuilder: (context, index) {
                              if (index == 0 && isCurrentMemberAdmin) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewGroupSelectUsers(
                                                  add: 1,
                                                  groupID: widget.groupID!,
                                                  addMember:
                                                      (String memberIDs) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          GroupApiCalls()
                                                              .addMembersToGroup(
                                                                  memberIDs,
                                                                  widget
                                                                      .groupID!,
                                                                  widget.topic!)
                                                              .then((value) {
                                                            Timer(
                                                                Duration(
                                                                    milliseconds:
                                                                        100),
                                                                () => Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop());
                                                            _getUsers();
                                                          });
                                                          return ProcessingDialog(
                                                            title:
                                                                AppLocalizations
                                                                    .of(
                                                              "Please wait a moment",
                                                            ),
                                                            heading:
                                                                AppLocalizations
                                                                    .of(
                                                              "Adding...",
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                                  },
                                                )));
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  title: Text(
                                    AppLocalizations.of(
                                      "Add participants",
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  leading: Container(
                                    decoration: new BoxDecoration(
                                      color: darkColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.person_add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (index == 1 && isCurrentMemberAdmin) {
                                return ListTile(
                                  onTap: () async {
                                    /* try {
                                    await ContactsService.openExistingContact(new Contact(
                                      givenName: "Gill",
                                      phones: [Item(label: "Mobile", value: "+91 90449 10458")],
                                    ));
                                  } on FormOperationException catch (e) {
                                    switch (e.errorCode) {
                                      case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                                      case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                                      case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                                        print(e.toString());
                                        break;
                                    }
                                  }*/
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  title: Text(
                                    AppLocalizations.of(
                                      "Invite via link",
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  leading: Container(
                                    decoration: new BoxDecoration(
                                      color: darkColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.link,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                var user;
                                if (isCurrentMemberAdmin) {
                                  user = _broadcastUsers.users[index - 2];
                                } else {
                                  user = _broadcastUsers.users[index];
                                }
                                return MinimalUserCard(
                                  onLongTap: () {
                                    if (user.fromuserid !=
                                        CurrentUser().currentUser.memberID) {
                                      int selectedIndex;
                                      if (isCurrentMemberAdmin) {
                                        selectedIndex = index - 2;
                                      } else {
                                        selectedIndex = index;
                                      }
                                      _showPopupMenu(user, selectedIndex);
                                    } else {
                                      print("you are selected");
                                    }
                                  },
                                  admin: 1,
                                  from: "forward",
                                  onTap: () {
                                    print(user.name);
                                    setState(() {
                                      CurrentUser()
                                              .currentUser
                                              .currentOpenMemberID =
                                          user.fromuserid;
                                    });
                                    _status.updateRefresh(user.onlineStatus);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailedChatScreen(
                                                  token: user.token,
                                                  name: user.name,
                                                  image: user.image,
                                                  memberID: user.fromuserid,
                                                )));
                                  },
                                  user: user,
                                );
                              }
                            }),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              });
        });
  }
}
