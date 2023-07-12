import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detailed_broadcast_screen.dart';
import 'detailed_chat_screen.dart';
import 'detailed_group_chat_screen.dart';
import 'direct_chat_screen.dart';

class ArchivedChats extends StatefulWidget {
  final List<DirectMessageUserListModel>? users;

  const ArchivedChats({Key? key, this.users}) : super(key: key);

  @override
  _ArchivedChatsState createState() => _ArchivedChatsState();
}

class _ArchivedChatsState extends State<ArchivedChats> {
  List<String> chatMemberIDs = [];
  List<DirectMessageUserListModel> _archivedUsers = [];
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  UpdateTypingStatusGroup _typingStatus = UpdateTypingStatusGroup();

  void _clearSelectedChat() {
    setState(() {
      chatMemberIDs = [];
    });
    _archivedUsers.forEach((element) {
      if (element.isSelected!) {
        setState(() {
          element.isSelected = false;
        });
      }
    });
  }

  void _onTapChat(int i) {
    if (chatMemberIDs.length > 0) {
      setState(() {
        _archivedUsers[i].isSelected = !_archivedUsers[i].isSelected!;
        if (_archivedUsers[i].isSelected!) {
          print("addd");
          chatMemberIDs.add(_archivedUsers[i].fromuserid!);
        } else {
          print("removeee");
          chatMemberIDs.removeWhere(
              (element) => element == _archivedUsers[i].fromuserid);
        }
      });
    }
  }

  void _onLongTapChat(int i) {
    if (chatMemberIDs.length == 0) {
      setState(() {
        _archivedUsers[i].isSelected = true;
        chatMemberIDs.add(_archivedUsers[i].fromuserid!);
      });
    }
  }

  @override
  void initState() {
    _archivedUsers = widget.users!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: chatMemberIDs.length > 0
            ? [
                IconButton(
                    icon: Icon(Icons.unarchive_rounded),
                    onPressed: () {
                      String members = "";
                      members = chatMemberIDs.join(",");
                      setState(() {
                        _archivedUsers.removeWhere(
                            (element) => element.isSelected == true);
                      });
                      ChatApiCalls().removeFromArchive(members);
                      _clearSelectedChat();
                    }),
                IconButton(
                  icon: const Icon(
                    Icons.delete_sharp,
                  ),
                  onPressed: () {
                    String members = "";
                    members = chatMemberIDs.join(",");
                    setState(() {
                      _archivedUsers
                          .removeWhere((element) => element.isSelected == true);
                    });
                    _clearSelectedChat();
                    ChatApiCalls().removeUser(members);
                  },
                ),
              ]
            : [],
        flexibleSpace: gradientContainer(null),
        title: Text(
          chatMemberIDs.length > 0
              ? chatMemberIDs.length.toString()
              : "Archived chats",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
          itemCount: _archivedUsers.length,
          itemBuilder: (context, index) {
            return DirectChatUserCard(
              from: "ar",
              onLongTap: () {
                _onLongTapChat(index);
              },
              onTap: () {
                if (chatMemberIDs.length > 0) {
                  _onTapChat(index);
                } else if (_archivedUsers[index].chatType == "group") {
                  _typingStatus.updateRefresh(
                      CurrentUser().currentUser.memberID! + "-" + "");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedGroupChatScreen(
                                topic: _archivedUsers[index].topic!,
                                token: _archivedUsers[index].token!,
                                name: _archivedUsers[index].name!,
                                image: _archivedUsers[index].image!,
                                groupID: _archivedUsers[index].fromuserid!,
                                members: _archivedUsers[index].groupMembers!,
                                groupStatus: _archivedUsers[index].groupStatus!,
                              )));
                } else if (_archivedUsers[index].chatType == "broadcast") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedBroadcastChatScreen(
                                topic: _archivedUsers[index].topic!,
                                token: _archivedUsers[index].token!,
                                name: _archivedUsers[index].name!,
                                image: _archivedUsers[index].image!,
                                broadcastID: _archivedUsers[index].fromuserid!,
                                members: _archivedUsers[index].groupMembers!,
                              )));
                } else {
                  setState(() {
                    CurrentUser().currentUser.currentOpenMemberID =
                        _archivedUsers[index].fromuserid;
                  });
                  _status.updateRefresh(_archivedUsers[index].onlineStatus);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedChatScreen(
                                token: _archivedUsers[index].token!,
                                blocked: _archivedUsers[index].blocked!,
                                name: _archivedUsers[index].name!,
                                image: _archivedUsers[index].image!,
                                memberID: _archivedUsers[index].fromuserid!,
                              )));
                }
              },
              user: _archivedUsers[index],
            );
          }),
    );
  }
}
