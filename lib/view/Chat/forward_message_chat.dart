import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'detailed_direct_screen.dart';
import 'direct_chat_screen.dart';

class ForwardMessageChatPage extends StatefulWidget {
  final List<String>? messageIDs;
  final String? from;

  const ForwardMessageChatPage({Key? key, this.messageIDs, this.from})
      : super(key: key);

  @override
  _ForwardMessageChatPageState createState() => _ForwardMessageChatPageState();
}

class _ForwardMessageChatPageState extends State<ForwardMessageChatPage> {
  late Future<DirectUsers> _chatUsers;
  DirectUsers _users = new DirectUsers([]);
  List<String> memberIDs = [];
  List<String> memberNames = [];

  void _getLocalList() {
    _chatUsers = ChatApiCalls.getChatsListLocal().then((value) {
      setState(() {
        _users = value;
      });
      _getUserList();
      return value;
    });
  }

  void _getUserList() {
    setState(() {
      _chatUsers = ChatApiCalls.getChatsList("").then((value) {
        setState(() {
          _users = value;
        });

        return value;
      });
    });
  }

  @override
  void initState() {
    print(widget.messageIDs!.join(","));
    // _getLocalList();
    _getUserList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: memberIDs.length > 0
          ? new FloatingActionButton(
              backgroundColor: darkColor,
              child: Icon(
                Icons.send,
                size: 22,
                color: Colors.white,
              ),
              onPressed: () {
                print(memberIDs.join(","));
                ChatApiCalls().forwardMessages(
                  widget.messageIDs!.join(","),
                  memberIDs.join(","),
                );
                Navigator.pop(context);
                Navigator.pop(context);
                if (widget.from == "expanded") {
                  Navigator.pop(context);
                }
              },
            )
          : null,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            "Forward to",
          ),
          style: TextStyle(fontSize: 20),
        ),
        flexibleSpace: gradientContainer(null),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            child: FutureBuilder(
                future: _chatUsers,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: _users.users.length,
                        itemBuilder: (context, index) {
                          return DirectChatUserCard(
                            from: "forward",
                            onTap: () {
                              if (_users.users[index].isSelected == false) {
                                if (memberIDs.length == 5) {
                                  customToastBlack(
                                      "You can only share with up to 5 chats ",
                                      14.0,
                                      ToastGravity.BOTTOM);
                                } else {
                                  setState(() {
                                    _users.users[index].isSelected = true;
                                    memberIDs
                                        .add(_users.users[index].fromuserid!);
                                    memberNames.add(_users.users[index].name!);
                                  });
                                }
                              } else {
                                setState(() {
                                  _users.users[index].isSelected = false;
                                  memberIDs.removeWhere((element) =>
                                      element ==
                                      _users.users[index].fromuserid);
                                  memberNames.removeWhere((element) =>
                                      element == _users.users[index].name);
                                });
                              }
                            },
                            user: _users.users[index],
                          );
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
          memberNames.length > 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: darkColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 17,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              width: 90.0.w,
                              child: Text(
                                memberNames.join(", "),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
