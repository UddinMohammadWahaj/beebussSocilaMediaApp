import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/Chat/direct_user_model.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/Chat/call_history_screen.dart';
import 'package:bizbultest/view/Chat/detailed_direct_screen.dart';
import 'package:bizbultest/view/Chat/direct_chat_screen.dart';
import 'package:bizbultest/view/Chat/settings_screen.dart';
import 'package:bizbultest/view/Chat/starred_messages_screen.dart';
import 'package:bizbultest/view/SocketChat/mainsocketchatview.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import 'archived_chats.dart';
import 'controllers/chat_home_controller.dart';
import 'detailed_broadcast_screen.dart';
import 'detailed_chat_screen.dart';
import 'detailed_group_chat_screen.dart';
import 'new_broadcast_select_users_page.dart';
import 'new_chat_screen.dart';
import 'new_group_select_users_page.dart';

enum HomeOptions {
  settings,
  // Chats Tab
  newGroup,
  newBroadcast,
  whatsappWeb,
  starredMessages,
  socketChat,
  // Status Tab
  statusPrivacy,
  // Calls Tab
  clearCallLog,
  readMe,
}

class ChatHome extends StatefulWidget {
  final Function? setNavbar;
  final String? from;

  ChatHome({Key? key, this.setNavbar, this.from}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late TabController _tabController;
  TextEditingController _searchBarController = TextEditingController();
  late int _tabIndex;
  bool _isSearching = false;
  List<Widget?> _actionButtons = [];
  List<Widget?> _floatingButtons = [];
  bool _searchBarOpen = false;
  String searchText = "";
  DirectUsers _directUsers = new DirectUsers([]);
  DirectUsers _chatUsers = new DirectUsers([]);
  DirectUsers _archivedUsers = new DirectUsers([]);
  Future<DirectUsersSearch?>? _directUsersSearch;
  Future<DirectUsers>? _directUsersFuture;
  Future<DirectUsers>? _chatUsersFuture;
  DirectRefresh directRefresh = DirectRefresh();
  ChatsRefresh chatRefresh = ChatsRefresh();
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  UpdateTypingStatusGroup _typingStatus = UpdateTypingStatusGroup();
  DetailedDirectRefresh _detailedDirectRefresh = DetailedDirectRefresh();
  DetailedChatRefresh _detailedChatRefresh = DetailedChatRefresh();
  int unread = 0;
  String onlineStatus = "";
  bool areArchivedUsersLoaded = false;
  ChatHomeController chatHomeController = Get.put(ChatHomeController());
  List<String> directMemberIDs = [];
  List<String> chatMemberIDs = [];

  void _getNumber() {
    ChatApiCalls.getCurrentUserNumber().then((value) {
      setState(() {
        CurrentUser().currentUser.contactNumber = value;
      });
      return value;
    });
  }

  void _getUserChatsList() {
    _chatUsersFuture = ChatApiCalls.getChatsList("").then((value) {
      setState(() {
        _chatUsers.users = value.users;
      });
      _chatUsers.users.forEach((element) {
        if ((element.chatType == "group" || element.chatType == "broadcast") &&
            element.topic != "") {
          _subscribeToGroupTopic(element.topic!);
        }
      });
      // print(_chatUsers.users.length.toString() + " chatsss");
      return value;
    });
  }

  void _getUserDirectList() {
    _directUsersFuture = DirectApiCalls.getDirectUserList().then((value) {
      setState(() {
        _directUsers.users = value.users;
      });
      _subscribeToTopic();
      return value;
    });
  }

  void _getUserArchivedList() {
    ChatApiCalls.getArchivedList().then((value) {
      setState(() {
        _archivedUsers.users = value.users;
        areArchivedUsersLoaded = true;
      });
      return value;
    });
  }

  Widget _archivedCard() {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArchivedChats(
                      users: _archivedUsers.users,
                    )));
      },
      title: areArchivedUsersLoaded
          ? Text(
              "${AppLocalizations.of('Archived')} (${_archivedUsers.users.length})",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          : Container(
              height: 0,
              width: 0,
            ),
    );
  }

  void _subscribeToGroupTopic(String topic) {
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  List<List<PopupMenuItem<HomeOptions?>?>?>? _popupMenus = [
    null,
    [
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of("New group"),
        ),
        value: HomeOptions.newGroup,
      ),
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of(
            "New broadcast",
          ),
        ),
        value: HomeOptions.newBroadcast,
      ),
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of(
            "Bebuzee Web",
          ),
        ),
        value: HomeOptions.whatsappWeb,
      ),
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of(
            "Starred Messages",
          ),
        ),
        value: HomeOptions.starredMessages,
      ),
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of("Settings"),
        ),
        value: HomeOptions.settings,
      ),
    ],
    [
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of("Status privacy"),
        ),
        value: HomeOptions.statusPrivacy,
      ),
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of(
            AppLocalizations.of("Settings"),
          ),
        ),
        value: HomeOptions.settings,
      ),
    ],
    [
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of("Clear call log"),
        ),
        value: HomeOptions.clearCallLog,
      ),
      PopupMenuItem<HomeOptions>(
        child: Text(
          AppLocalizations.of("Settings"),
        ),
        value: HomeOptions.settings,
      ),
    ],
  ];

  Widget searchBar() {
    return TextField(
      style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
      cursorColor: Colors.white,
      onChanged: (val) {
        print(searchText);
        setState(() {
          searchText = _searchBarController.text;
          _directUsersSearch =
              DirectApiCalls.getDirectUserSearchList(_searchBarController.text)
                  as Future<DirectUsersSearch>?;
        });
        print(searchText);
        print(_isSearching);
      },
      controller: _searchBarController,
      autofocus: true,
      decoration: InputDecoration(
          hintText: AppLocalizations.of(
            'Search...',
          ),
          border: InputBorder.none,
          hintStyle: whiteNormal.copyWith(fontSize: 12.0.sp)),
    );
  }

  void _tabListener() {
    _tabController.animation!
      ..addListener(() {
        var value = _tabController.animation!.value.round();
        if (value != _tabIndex) {
          setState(() {
            _tabIndex = _tabController.animation!.value.round();
            _isSearching = false;
          });
        }
        if (directMemberIDs.length > 0) {
          print("clearrr direct");
          setState(() {
            _clearSelectedDirect();
          });
        }
        if (chatMemberIDs.length > 0) {
          print("clear chattt");
          setState(() {
            _clearSelectedChat();
          });
        }
        /* if(_tabIndex == 2) {
          refreshUsers();
        }*/
      });
  }

  void _selectOption(HomeOptions? option) {
    switch (option) {
      case HomeOptions.newGroup:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewGroupSelectUsers(
                      from: false,
                    )));
        break;
      case HomeOptions.newBroadcast:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewBroadcastSelectUsers()));
        break;
      case HomeOptions.whatsappWeb:
        // Application.router.navigateTo(
        //   context,
        //   Routes.whatsappWeb,
        //   transition: TransitionType.inFromRight,
        // );
        break;
      case HomeOptions.starredMessages:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StarredMessagesScreen()));

        break;
      case HomeOptions.settings:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SettingsScreenChat()));
        break;
      case HomeOptions.statusPrivacy:
        // Application.router.navigateTo(
        //   context,
        //   //Routes.statusPrivacy,
        //   Routes.futureTodo,
        //   transition: TransitionType.inFromRight,
        // );
        break;
      case HomeOptions.clearCallLog:
        break;
      case HomeOptions.socketChat:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SocketChatHome()));
        break;
      case HomeOptions.readMe:
        // Application.router.navigateTo(
        //   context,
        //   Routes.futureTodo,
        //   transition: TransitionType.inFromRight,
        // );
        break;
    }
  }

  void _subscribeToTopic() {
    FirebaseMessaging.instance.subscribeToTopic("Online").then((value) {
      DirectApiCalls.fcmOnlineStatus("Online");
      DirectApiCalls.updateOnlineStatus("Online");
      ChatApiCalls.updateOnlineStatus("Online");
    });
  }

  void _unsubscribeToTopic() {
    FirebaseMessaging.instance.unsubscribeFromTopic("Online").then((value) {
      DirectApiCalls.fcmOnlineStatus("");
      DirectApiCalls.updateOnlineStatus("");
      ChatApiCalls.updateOnlineStatus("");
    });
  }

  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      CurrentUser().currentUser.token = token;
    });
    DirectApiCalls.setToken(token!);
  }

  void _fcmListener() {
    FirebaseMessaging.instance.getInitialMessage();
    //String token = await firebaseMessaging.getToken();
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      // print(notification.title.toString() + " title");
      // print(message.notification.title.toString() + " message title");
      _detailedChatRefresh
          .updateRefresh(message.notification?.body != null ? true : false);
      _detailedDirectRefresh
          .updateRefresh(message.notification?.body != null ? true : false);
      if (message.data['type'] == "online") {
        //print("onlineeeeee");
        _directUsers.users.forEach((element) {
          if (element.fromuserid == message.data['user_id']) {
            setState(() {
              element.onlineStatus = message.data['status'];
            });
          }
        });
        _chatUsers.users.forEach((element) {
          if (element.fromuserid == message.data['user_id']) {
            setState(() {
              element.onlineStatus = message.data['status'];
            });
          }
        });

        if (CurrentUser().currentUser.currentOpenMemberID ==
            message.data['user_id']) {
          _status.updateRefresh(message.data['status']);
        }
      } else if (message.data['type'] == "group_typing") {
        // print(message.data['status']);
        String memberName = "";

        _chatUsers.users.forEach((element) {
          if (element.fromuserid == message.data['user_id']) {
            memberName = element.name!;
          } else {
            memberName = message.data['user_id'];
          }
        });

        _chatUsers.users.forEach((element) {
          if (element.groupId == message.data['group_id']) {
            if (message.data['status'] == "true") {
              // print("typingggg");
              _typingStatus.updateRefresh(
                  message.data['name'] + "-" + memberName + " is typing..");
            } else {
              // print("not typingggg");
              _typingStatus.updateRefresh(message.data['name'] + "-" + "");
            }
          }
        });

        print(_typingStatus.currentSelect);
      } else if (message.data['category'] == "chat") {
        //  print("chat message");
        _chatUsers.users.forEach((element) {
          if (element.fromuserid == message.data['user_id']) {
            //  print("matcheddddd");
            if (mounted)
              setState(() {
                element.typeMessage = message.data['type'];
                element.inOut = "message-in";
                element.messageData = message.data['body'];
                element.readStatus = "0";
                element.totalUnread = element.totalUnread! + 1;
                element.time = DateFormat('hh:mm a').format(DateTime.now());
              });
          }
          // print(_chatUsers.users[0].messageData);
          // print(message.data['user_id']);
        });
        _detailedChatRefresh
            .updateRefresh(message.collapseKey != "" ? true : false);
        chatRefresh.updateRefresh(true);
      } else if (message.data['category'] == "group") {
        print("groupppp");
        chatRefresh.updateRefresh(true);
        _detailedChatRefresh
            .updateRefresh(message.collapseKey != "" ? true : false);
      } else if (message.data['category'] == "deleteChat") {
        // print("delete chat");
        _detailedChatRefresh
            .updateRefresh(message.collapseKey != "" ? true : false);
        chatRefresh.updateRefresh(true);
      } else if (message.data['category'] == "deleteDirect") {
        // print("delete direct");
        _detailedDirectRefresh.updateRefresh(true);
        directRefresh.updateRefresh(true);
      } else if (message.data['category'] == "actions") {
        // print("actions");
        _detailedChatRefresh
            .updateRefresh(message.collapseKey != "" ? true : false);
        chatRefresh.updateRefresh(true);
      } else {
        _directUsers.users.forEach((element) {
          if (element.fromuserid == message.data['user_id']) {
            setState(() {
              element.typeMessage = message.data['type'];
              element.inOut = "message-in";
              element.messageData = message.data['body'];
              element.readStatus = "0";
              element.totalUnread = element.totalUnread! + 1;
              element.time = DateFormat('hh:mm a').format(DateTime.now());
            });

            //  print(element.totalUnread.toString() + " unread countttt");
          }
        });
        setState(() {
          unread = unread + 1;
        });
        _detailedDirectRefresh.updateRefresh(true);
      }
    });

    // firebaseMessaging.configure(
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("on launchhhhhhhhhhh");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("on resumeeeeeeeee");
    //   },
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("received");

    //     if (message['data']['type'] == "online") {
    //       print("onlineeeeee");
    //       _directUsers.users.forEach((element) {
    //         if (element.fromuserid == message['data']['user_id']) {
    //           setState(() {
    //             element.onlineStatus = message['data']['status'];
    //           });
    //         }
    //       });

    //       _chatUsers.users.forEach((element) {
    //         if (element.fromuserid == message['data']['user_id']) {
    //           setState(() {
    //             element.onlineStatus = message['data']['status'];
    //           });
    //         }
    //       });

    //       if (CurrentUser().currentUser.currentOpenMemberID == message['data']['user_id']) {
    //         _status.updateRefresh(message['data']['status']);
    //       }
    //     } else if (message['data']['type'] == "group_typing") {
    //       print(message['data']['status']);
    //       String memberName = "";

    //       _chatUsers.users.forEach((element) {
    //         if (element.fromuserid == message['data']['user_id']) {
    //           memberName = element.name;
    //         } else {
    //           memberName = message['data']['user_id'];
    //         }
    //       });

    //       _chatUsers.users.forEach((element) {
    //         if (element.groupId == message['data']['group_id']) {
    //           if (message['data']['status'] == "true") {
    //             print("typingggg");
    //             _typingStatus.updateRefresh(message['data']['user_id'] + "-" + memberName + " is typing..");
    //           } else {
    //             print("not typingggg");
    //             _typingStatus.updateRefresh(message['data']['user_id'] + "-" + "");
    //           }
    //         }
    //       });

    //       print(_typingStatus.currentSelect);
    //     } else if (message['data']['category'] == "chat") {
    //       _chatUsers.users.forEach((element) {
    //         if (element.fromuserid == message['data']['user_id']) {
    //           print("matcheddddd");
    //           setState(() {
    //             element.typeMessage = message['data']['type'];
    //             element.inOut = "message-in";
    //             element.messageData = message['data']['body'];
    //             element.readStatus = "0";
    //             element.totalUnread = element.totalUnread + 1;
    //             element.time = DateFormat('hh:mm a').format(DateTime.now());
    //           });
    //         }
    //         print(_chatUsers.users[0].messageData);
    //         print(message['data']['user_id']);
    //       });
    //       _detailedChatRefresh.updateRefresh(true);
    //       chatRefresh.updateRefresh(true);
    //     } else if (message['data']['category'] == "group") {
    //       print("groupppp");
    //       chatRefresh.updateRefresh(true);
    //       _detailedChatRefresh.updateRefresh(true);
    //     } else if (message['data']['category'] == "deleteChat") {
    //       print("delete chat");
    //       _detailedChatRefresh.updateRefresh(true);
    //       chatRefresh.updateRefresh(true);
    //     } else if (message['data']['category'] == "deleteDirect") {
    //       print("delete direct");
    //       _detailedDirectRefresh.updateRefresh(true);
    //       directRefresh.updateRefresh(true);
    //     } else if (message['data']['category'] == "actions") {
    //       print("actions");
    //       _detailedChatRefresh.updateRefresh(true);
    //       chatRefresh.updateRefresh(true);
    //     } else {
    //       _directUsers.users.forEach((element) {
    //         if (element.fromuserid == message['data']['user_id']) {
    //           setState(() {
    //             element.typeMessage = message['data']['type'];
    //             element.inOut = "message-in";
    //             element.messageData = message['data']['body'];
    //             element.readStatus = "0";
    //             element.totalUnread = element.totalUnread + 1;
    //             element.time = DateFormat('hh:mm a').format(DateTime.now());
    //           });

    //           print(element.totalUnread.toString() + " unread countttt");
    //         }
    //       });
    //       setState(() {
    //         unread = unread + 1;
    //       });
    //       _detailedDirectRefresh.updateRefresh(true);
    //     }

    //     //ChatApiCalls.getAllChats(message['data']['other_user_id'],"");
    //   },
    // );
  }

  void refreshDirectUsers() {
    _directUsersFuture = DirectApiCalls.getDirectUserList().then((value) {
      setState(() {
        _directUsers.users = value.users;
      });
      return value;
    });
  }

  void refreshChatUsers() {
    _chatUsersFuture = ChatApiCalls.getChatsList("").then((value) {
      setState(() {
        _chatUsers = value;
        //number = value.users.length;
      });
      _chatUsers.users.forEach((element) {
        if ((element.chatType == "group" || element.chatType == "broadcast") &&
            element.topic != "") {
          _subscribeToGroupTopic(element.topic!);
        }
      });

      return value;
    });
  }

  void refreshUnreadCount() {
    DirectApiCalls.getUnreadMessagesCount().then((value) {
      setState(() {
        unread = value;
      });
      return value;
    });
  }

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

  Widget _buildDirectUserSearchList() {
    return FutureBuilder(
      future: _directUsersSearch,
      builder: (context, dynamic snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: ListView.builder(
                itemCount: snapshot.data.users.length,
                itemBuilder: (context, index) {
                  return DirectSearchedUserCard(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailedDirectScreen(
                                    name: snapshot.data.users[index].name,
                                    image: snapshot.data.users[index].image,
                                    memberID:
                                        snapshot.data.users[index].memberId,
                                  )));
                    },
                    user: snapshot.data.users[index],
                  );
                }),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _clearSelectedDirect() {
    setState(() {
      directMemberIDs = [];
    });
    _directUsers.users.forEach((element) {
      if (element.isSelected!) {
        setState(() {
          element.isSelected = false;
        });
      }
    });
  }

  void _clearSelectedChat() {
    setState(() {
      chatMemberIDs = [];
    });
    _chatUsers.users.forEach((element) {
      if (element.isSelected!) {
        setState(() {
          element.isSelected = false;
        });
      }
    });
  }

  void _onTapDirect(int i) {
    if (directMemberIDs.length > 0) {
      setState(() {
        _directUsers.users[i].isSelected = !_directUsers.users[i].isSelected!;
        if (_directUsers.users[i].isSelected!) {
          print("addd");
          directMemberIDs.add(_directUsers.users[i].fromuserid!);
        } else {
          print("removeee");
          directMemberIDs.removeWhere(
              (element) => element == _directUsers.users[i].fromuserid);
        }
      });
    }
  }

  void _onLongTapDirect(int i) {
    if (directMemberIDs.length == 0) {
      setState(() {
        _directUsers.users[i].isSelected = true;
        directMemberIDs.add(_directUsers.users[i].fromuserid!);
      });
    }
  }

  void _onTapChat(int i) {
    if (chatMemberIDs.length > 0) {
      setState(() {
        _chatUsers.users[i].isSelected = !_chatUsers.users[i].isSelected!;
        if (_chatUsers.users[i].isSelected!) {
          print("addd");
          chatMemberIDs.add(_chatUsers.users[i].fromuserid!);
        } else {
          print("removeee");
          chatMemberIDs.removeWhere(
              (element) => element == _chatUsers.users[i].fromuserid);
        }
      });
    }
  }

  void _onLongTapChat(int i) {
    if (chatMemberIDs.length == 0) {
      setState(() {
        _chatUsers.users[i].isSelected = true;
        chatMemberIDs.add(_chatUsers.users[i].fromuserid!);
      });
    }
  }

  Widget _buildDirectUserList() {
    return FutureBuilder(
      future: _directUsersFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: _directUsers.users.length,
                itemBuilder: (context, index) {
                  return DirectChatUserCard(
                    onLongTap: () {
                      _onLongTapDirect(index);
                    },
                    onTap: () {
                      if (directMemberIDs.length > 0) {
                        _onTapDirect(index);
                      } else {
                        setState(() {
                          CurrentUser().currentUser.currentOpenMemberID =
                              _directUsers.users[index].fromuserid;
                        });
                        _status.updateRefresh(
                            _directUsers.users[index].onlineStatus);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedDirectScreen(
                              token: _directUsers.users[index].token!,
                              name: _directUsers.users[index].name!,
                              image: _directUsers.users[index].image!,
                              memberID: _directUsers.users[index].fromuserid!,
                            ),
                          ),
                        );
                      }
                    },
                    user: _directUsers.users[index],
                  );
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildChatUserList() {
    return StreamBuilder<Object>(
        initialData: chatRefresh.currentSelect,
        stream: chatRefresh.observableCart,
        builder: (context, dynamic snapshot) {
          if (snapshot.data) {
            refreshChatUsers();
            _getUserArchivedList();
            chatRefresh.updateRefresh(false);
          }
          return FutureBuilder(
            future: _chatUsersFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                      itemCount: _chatUsers.users.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _chatUsers.users.length) {
                          if (areArchivedUsersLoaded) {
                            return _archivedCard();
                          } else {
                            return Container();
                          }
                        } else {
                          return DirectChatUserCard(
                            onLongTap: () {
                              _onLongTapChat(index);
                            },
                            onTap: () {
                              if (chatMemberIDs.length > 0) {
                                _onTapChat(index);
                              } else if (_chatUsers.users[index].chatType ==
                                  "group") {
                                _typingStatus.updateRefresh(
                                    CurrentUser().currentUser.memberID! +
                                        "-" +
                                        "");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedGroupChatScreen(
                                              group: _chatUsers.users[index],
                                              groupDescription: _chatUsers
                                                  .users[index]
                                                  .groupDescription!,
                                              topic: _chatUsers
                                                  .users[index].topic!,
                                              token: _chatUsers
                                                  .users[index].token!,
                                              name:
                                                  _chatUsers.users[index].name!,
                                              image: _chatUsers
                                                  .users[index].image!,
                                              groupID: _chatUsers
                                                  .users[index].fromuserid!,
                                              members: _chatUsers
                                                  .users[index].groupMembers!,
                                              groupStatus: _chatUsers
                                                  .users[index].groupStatus!,
                                            )));
                              } else if (_chatUsers.users[index].chatType ==
                                  "broadcast") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedBroadcastChatScreen(
                                              topic: _chatUsers
                                                  .users[index].topic!,
                                              token: _chatUsers
                                                  .users[index].token!,
                                              name:
                                                  _chatUsers.users[index].name!,
                                              image: _chatUsers
                                                  .users[index].image!,
                                              broadcastID: _chatUsers
                                                  .users[index].fromuserid!,
                                              members: _chatUsers
                                                  .users[index].groupMembers!,
                                            )));
                              } else {
                                setState(() {
                                  CurrentUser()
                                          .currentUser
                                          .currentOpenMemberID =
                                      _chatUsers.users[index].fromuserid;
                                });
                                _status.updateRefresh(
                                    _chatUsers.users[index].onlineStatus);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailedChatScreen(
                                        token: _chatUsers.users[index].token!,
                                        blocked:
                                            _chatUsers.users[index].blocked!,
                                        name: _chatUsers.users[index].name!,
                                        image: _chatUsers.users[index].image!,
                                        memberID:
                                            _chatUsers.users[index].fromuserid!,
                                        fromChat: true),
                                  ),
                                );
                              }
                            },
                            user: _chatUsers.users[index],
                          );
                        }
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        });
  }

  Future<String> getTimezone() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    if (mounted) {
      setState(() {
        CurrentUser().currentUser.timeZone = locationX["timezone"];
      });
    }
    return "Success";
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    directRefresh.updateRefresh(true);
    chatRefresh.updateRefresh(true);
    if (state.toString() == "AppLifecycleState.resumed") {
      _subscribeToTopic();
    }
    if (state.toString() == "AppLifecycleState.paused" ||
        state.toString() == "AppLifecycleState.detached") {
      _unsubscribeToTopic();
    }
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        createFolder();
        print("permission granted");
      }
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      print("permission denied");
    }
  }

  void createFolder() async {
    String directory = (await p.getExternalStorageDirectory())!.path;
    new Directory(directory + "/Bebuzee" + "/Bebuzee Images")
        .create(recursive: true)
        .then((value) {
      print(value.path);
      print("pathhh");
    });
    new Directory(directory + "/Bebuzee" + "/Bebuzee Video")
        .createSync(recursive: true);
    new Directory(directory + "/Bebuzee" + "/Bebuzee Documents")
        .createSync(recursive: true);
    new Directory(directory + "/Bebuzee" + "/Bebuzee Audio")
        .createSync(recursive: true);
    new Directory(directory + "/Bebuzee" + "/Bebuzee Voice Notes")
        .createSync(recursive: true);
    new Directory(directory + "/Bebuzee" + "/Bebuzee Thumbnails")
        .createSync(recursive: true);
  }

  Future<String> imagesFolder() async {
    var dir = await p.getApplicationDocumentsDirectory();
    final folderName = "Bebuzee Images";
    print(dir.toString());
    final path = Directory("${dir.path}/$folderName");
    var status = await Permission.storage.status;
    var android11Status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (!android11Status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if ((await path.exists())) {
      print("exists");
      print(path.path.toString());
      return path.path;
    } else {
      path.create().then((value) {
        print("create success");
        print(value.path.toString());
      });
      return path.path;
    }
  }

  Future<String> videosFolder() async {
    final folderName = "Bebuzee Videos";
    final path = Directory("storage/emulated/0/Bebuzee/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  Future<String> createDocumentsFolder() async {
    final folderName = "Bebuzee Documents";
    final path = Directory("storage/emulated/0/Bebuzee/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  Future<String> createAudioFolder() async {
    final folderName = "Bebuzee Audio";
    final path = Directory("storage/emulated/0/Bebuzee/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  Future<String> createVoiceFolder() async {
    final folderName = "Bebuzee Voice";
    final path = Directory("storage/emulated/0/Bebuzee/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  void _getLocalDirectList() {
    _directUsersFuture = DirectApiCalls.getDirectUserListLocal().then((value) {
      setState(() {
        _directUsers.users = value.users;
      });

      return value;
    });
  }

  void _getLocalChatList() {
    _chatUsersFuture = ChatApiCalls.getChatsListLocal().then((value) {
      setState(() {
        _chatUsers.users = value.users;
      });

      return value;
    });
  }

  void _getAllUsers() {
    getTimezone().then((value) {
      print("get timezone");
      _getUserChatsList();
      _getUserDirectList();
      _getUserArchivedList();
      return value;
    });
  }

  UserDetailModel objUserDetailModel = new UserDetailModel();
  bool isOpen2fBox = false;
  bool isshowOTPError = false;

  getCurrentUserDetail() async {
    String uid = CurrentUser().currentUser.memberID!;
    objUserDetailModel = await ApiProvider().getUserDetail(uid);
    if (objUserDetailModel != null &&
        objUserDetailModel.twoStepVerification != null &&
        objUserDetailModel.twoStepVerification!) {
      isOpen2fBox = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    getCurrentUserDetail();
    _getAllUsers();
    _getLocalChatList();
    _getLocalDirectList();
    getToken();
    //imagesFolder();
    // createFolder();
    // videosFolder();
    // createDocumentsFolder();
    // createAudioFolder();
    // createVoiceFolder();
    _fcmListener();
    _directUsersSearch =
        DirectApiCalls.getDirectUserSearchList(_searchBarController.text);
    DirectApiCalls.getUnreadMessagesCount().then((value) {
      setState(() {
        unread = value;
      });
      return value;
    });
    _getNumber();
    _floatingButtons = [
      null,
      new FloatingActionButton(
          child: gradientContainerForButton(Icon(Icons.message)),
          backgroundColor: fabBgColor,
          foregroundColor: Colors.white,
          onPressed: () async {
            final PermissionStatus permissionStatus = await _getPermission();
            if (permissionStatus == PermissionStatus.granted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewChatScreen()));
            } else {
              ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                  .showSnackBar(blackSnackBar(AppLocalizations.of(
                      'Please enable contacts permission from settings')));
            }
          }),
      null,
      new FloatingActionButton(
          child: gradientContainerForButton(Icon(Icons.add_call)),
          backgroundColor: fabBgColor,
          foregroundColor: Colors.white,
          onPressed: () {}),
    ];
    _actionButtons = <Widget?>[
      IconButton(
        tooltip: AppLocalizations.of('Search'),
        icon: const Icon(
          Icons.search_sharp,
        ),
        onPressed: () {
          setState(() {
            _searchBarOpen = true;
            _isSearching = true;
            _searchBarController?.text = "";
          });
        },
      ),
      PopupMenuButton<HomeOptions?>(
        icon: Icon(
          Icons.more_vert_rounded,
        ),
        tooltip: AppLocalizations.of("More options"),
        onSelected: _selectOption!,
        itemBuilder: (BuildContext context) {
          return [
            _tabIndex == 1
                ? PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of("New group"),
                    ),
                    value: HomeOptions.newGroup,
                  )
                : _tabIndex == 2
                    ? PopupMenuItem<HomeOptions>(
                        child: Text(
                          AppLocalizations.of("Status privacy"),
                        ),
                        value: HomeOptions.statusPrivacy,
                      )
                    : _tabIndex == 3
                        ? PopupMenuItem<HomeOptions>(
                            child: Text(
                              AppLocalizations.of("Clear call log"),
                            ),
                            value: HomeOptions.clearCallLog,
                          )
                        : PopupMenuItem<HomeOptions>(
                            child: Text(
                              AppLocalizations.of(""),
                            ),
                            value: HomeOptions.newGroup,
                          ),
            _tabIndex == 1
                ? PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of(
                        "New broadcast",
                      ),
                    ),
                    value: HomeOptions.newBroadcast,
                  )
                : _tabIndex == 2
                    ? PopupMenuItem<HomeOptions>(
                        child: Text(
                          AppLocalizations.of(
                            AppLocalizations.of("Settings"),
                          ),
                        ),
                        value: HomeOptions.settings,
                      )
                    : _tabIndex == 3
                        ? PopupMenuItem<HomeOptions>(
                            child: Text(
                              AppLocalizations.of("Settings"),
                            ),
                            value: HomeOptions.settings,
                          )
                        : PopupMenuItem<HomeOptions>(
                            child: Text(
                              AppLocalizations.of(""),
                            ),
                            value: HomeOptions.newGroup,
                          ),
            _tabIndex == 1
                ? PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of(
                        "Bebuzee Web",
                      ),
                    ),
                    value: HomeOptions.whatsappWeb,
                  )
                : PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of(""),
                    ),
                    value: HomeOptions.newGroup,
                  ),
            _tabIndex == 1
                ? PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of(
                        "Starred Messages",
                      ),
                    ),
                    value: HomeOptions.starredMessages,
                  )
                : PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of(""),
                    ),
                    value: HomeOptions.newGroup,
                  ),
            _tabIndex == 1
                ? PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of("Settings"),
                    ),
                    value: HomeOptions.settings,
                  )
                : PopupMenuItem<HomeOptions>(
                    child: Text(
                      AppLocalizations.of(""),
                    ),
                    value: HomeOptions.newGroup,
                  ),
            // _tabIndex == 1
            //     ? PopupMenuItem<HomeOptions>(
            //         child: Text(
            //           "Socket Chat Test",
            //         ),
            //         value: HomeOptions.socketChat,
            //       )
            //     : null
          ];

          // _popupMenus[_tabIndex];
        },
      ),
    ];
    _tabIndex = 1;
    _tabController = new TabController(
      length: 4,
      initialIndex: _tabIndex,
      vsync: this,
    );
    _tabListener();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      initialData: directRefresh.currentSelect,
      stream: directRefresh.observableCart,
      builder: (context, dynamic snapshot) {
        if (snapshot.data) {
          refreshDirectUsers();
          refreshUnreadCount();
          directRefresh.updateRefresh(false);
        }
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          floatingActionButton: _floatingButtons[_tabIndex],
          body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  brightness: Brightness.dark,
                  toolbarHeight: _tabIndex == 0 ? 0 : 56,
                  // actions: _isSearching!
                  //     ? null
                  //     : directMemberIDs.length > 0 || chatMemberIDs.length > 0
                  //         ? [
                  //             _tabIndex == 1
                  //                 ? IconButton(
                  //                     icon: Icon(Icons.archive),
                  //                     onPressed: () {
                  //                       String members = "";
                  //                       members = chatMemberIDs.join(",");
                  //                       setState(() {
                  //                         _chatUsers.users.removeWhere(
                  //                             (element) =>
                  //                                 element.isSelected == true);
                  //                       });
                  //                       ChatApiCalls().addToArchive(members);
                  //                       ScaffoldMessenger.of(_scaffoldKey
                  //                               .currentState.context)
                  //                           .showSnackBar(customSnackBar(
                  //                               '${chatMemberIDs.length.toString()} chats archived',
                  //                               Colors.white,
                  //                               15,
                  //                               Colors.black87,
                  //                               2));
                  //                       _clearSelectedChat();
                  //                     })
                  //                 : Container(),
                  //             IconButton(
                  //               icon: const Icon(
                  //                 Icons.delete,
                  //               ),
                  //               onPressed: () {
                  //                 if (directMemberIDs.length > 0) {
                  //                   String members = "";
                  //                   members = directMemberIDs.join(",");
                  //                   setState(() {
                  //                     _directUsers.users.removeWhere(
                  //                         (element) =>
                  //                             element.isSelected == true);
                  //                   });
                  //                   _clearSelectedDirect();
                  //                   DirectApiCalls.removeUser(members);
                  //                 } else {
                  //                   String members = "";
                  //                   members = chatMemberIDs.join(",");
                  //                   setState(() {
                  //                     _chatUsers.users.removeWhere((element) =>
                  //                         element.isSelected == true);
                  //                   });
                  //                   _clearSelectedChat();
                  //                   ChatApiCalls().removeUser(members);
                  //                 }
                  //               },
                  //             ),
                  //           ]
                  //         : _actionButtons,
                  title: _isSearching
                      ? searchBar()
                      : directMemberIDs.length > 0
                          ? Text(
                              directMemberIDs.length.toString(),
                              style: whiteBold.copyWith(fontSize: 18),
                            )
                          : chatMemberIDs.length > 0
                              ? Text(
                                  chatMemberIDs.length.toString(),
                                  style: whiteBold.copyWith(fontSize: 18),
                                )
                              : Text(
                                  'Bebuzee',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24),
                                ),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.black,
                  bottom: _isSearching || _tabIndex == 0
                      ? null
                      : TabBar(
                          onTap: (index) {
                            setState(() {
                              _tabIndex = index;
                            });
                          },
                          indicatorColor: Colors.white,
                          controller: _tabController,
                          tabs: <Widget>[
                            Tab(
                              icon: Icon(Icons.camera_alt),
                            ),
                            Tab(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('CHATS'),
                                      style:
                                          whiteBold.copyWith(fontSize: 10.0.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('DIRECT'),
                                      style:
                                          whiteBold.copyWith(fontSize: 10.0.sp),
                                    ),
                                    unread > 0
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                left: 4.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(9.0))),
                                            alignment: Alignment.center,
                                            height: 18.0,
                                            width: 18.0,
                                            child: Text(
                                              unread.toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                AppLocalizations.of('CALLS'),
                                style: whiteBold.copyWith(fontSize: 10.0.sp),
                              ),
                            ),
                          ],
                          labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        ),
                  pinned: true,
                  floating: true,
                  expandedHeight: _tabIndex == 0 ? 0 : 100,
                  flexibleSpace:
                      _tabIndex == 0 ? null : gradientContainer(null),
                ),
              ];
            },
            body: WillPopScope(
              onWillPop: () async {
                if (_tabIndex == 0) {
                  _tabController.animateTo(1);
                  return false;
                } else if (_searchBarOpen) {
                  print("2");
                  setState(() {
                    _searchBarOpen = false;
                    _isSearching = false;
                    _searchBarController?.text = "";
                    _directUsersSearch =
                        DirectApiCalls.getDirectUserSearchList("");
                  });
                  return false;
                } else if ((_tabIndex == 2 || _tabIndex == 3) &&
                    directMemberIDs.length == 0) {
                  print("2");
                  _tabController.animateTo(1);
                  return false;
                } else if (directMemberIDs.length > 0) {
                  print("4");
                  _clearSelectedDirect();
                  return false;
                } else if (chatMemberIDs.length > 0) {
                  print("5");
                  _clearSelectedChat();
                  return false;
                } else {
                  print("6");

                  if (widget.from == "blog") {
                    Navigator.pop(context);
                  }
                  widget.setNavbar!(false);
                  // CurrentUser().currentUser.timer.cancel();
                  return true;
                }
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  ChatCameraScreen(memberId: '', name: ''),
                  Stack(
                    children: [
                      _buildChatUserList(),
                      isOpen2fBox
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              color: Colors.black.withOpacity(0.5),
                            )
                          : SizedBox(),
                      isOpen2fBox
                          ? Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              backgroundColor: Colors.white,
                              elevation: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 14, right: 14, top: 16),
                                      child: Text(
                                        "Enter your two-step verification PIN",
                                        style: blackBold.copyWith(
                                            fontSize: 15.0.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: TextFormField(
                                          controller: pinCtrl,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          textAlign: TextAlign.center,
                                          autofocus: true,
                                          cursorHeight: 25,
                                          style: TextStyle(fontSize: 23),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: '* * *  * * *',
                                            hintStyle: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            if (objUserDetailModel != null &&
                                                objUserDetailModel
                                                        .twoStepVerificationPin !=
                                                    null &&
                                                objUserDetailModel
                                                        .twoStepVerificationPin !=
                                                    "" &&
                                                objUserDetailModel
                                                        .twoStepVerificationPin ==
                                                    val) {
                                              setState(() {
                                                isOpen2fBox = false;
                                                isshowOTPError = false;
                                              });
                                            } else {
                                              setState(() {
                                                isshowOTPError = true;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  isshowOTPError
                                      ? Text(
                                          "Incorrect PIN. Try again",
                                          style: blackBold.copyWith(
                                              fontSize: 14, color: Colors.red),
                                          textAlign: TextAlign.center,
                                        )
                                      : SizedBox(),
                                  isshowOTPError
                                      ? SizedBox(
                                          height: 16,
                                        )
                                      : SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    child: Text(
                                      "You will be asked for it periodically to help you remember it.",
                                      style: blackBold.copyWith(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _showMyDialog(context);
                                    },
                                    child: Text(
                                      "Forgot PIN?",
                                      style: blackBold.copyWith(
                                        fontSize: 16,
                                        color: secondaryColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  _isSearching
                      ? _buildDirectUserSearchList()
                      : _buildDirectUserList(),
                  CallHistoryScreen(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Disable two-step verification?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        "Cancle",
                        style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    String uid = CurrentUser().currentUser.memberID!;

                    var objTwoFactorEnableModel =
                        await ApiProvider().disableTwoFactor(uid);
                    if (objTwoFactorEnableModel != null) {
                      Fluttertoast.showToast(
                          msg: objTwoFactorEnableModel.message!);
                    }

                    setState(() {
                      isOpen2fBox = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        "Disable",
                        style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  TextEditingController pinCtrl = new TextEditingController();
}
