import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/delete_message_popup.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Chat/starred_message_card.dart';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forward_message_chat.dart';
import 'message_info_page.dart';

enum StarredMessageOptions {
  unstarAll,
}

class StarredMessagesScreen extends StatefulWidget {
  final List<ChatMessagesModel>? messages;

  const StarredMessagesScreen({Key? key, this.messages}) : super(key: key);

  @override
  _StarredMessagesScreenState createState() => _StarredMessagesScreenState();
}

class _StarredMessagesScreenState extends State<StarredMessagesScreen> {
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

  Future<void> _clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("starred");
  }

  ChatMessages _messages = new ChatMessages([]);
  ChatMessages _filteredMessages = new ChatMessages([]);
  late Future<ChatMessages> _starredMessages;
  List<String> messageID = [];
  List<ChatMessagesModel> selectedMessages = [];

  TextEditingController _searchBarController = TextEditingController();
  StarredMessagesRefresh _refresh = StarredMessagesRefresh();
  bool isSearchOpen = false;

  Widget searchBar() {
    return TextField(
      style: TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.white,
      onChanged: (val) {
        if (val != "") {
          _searchContacts(val);
        } else {
          setState(() {
            _filteredMessages.messages = [];
          });
        }
      },
      controller: _searchBarController,
      autofocus: true,
      decoration: InputDecoration(hintText: AppLocalizations.of('Search'), border: InputBorder.none, hintStyle: whiteNormal.copyWith(fontSize: 16)),
    );
  }

  Future<String> _getStarredMessagesLocal() async {
    _starredMessages = ChatApiCalls.getStarredMessagesLocal().then((value) {
      setState(() {
        _messages.messages = value.messages;
      });
      _getStarredMessages();

      return value;
    });

    return "success";
  }

  Future<String> _getStarredMessages() async {
    _starredMessages = ChatApiCalls.getStarredMessages("").then((value) {
      setState(() {
        _messages.messages = value.messages;
      });
      return value;
    });
    return "success";
  }

  void _searchContacts(String name) async {
    setState(() {
      _filteredMessages.messages =
          _messages.messages.where((element) => element.message.toString().toLowerCase().contains(name.toLowerCase())).toList();
    });
    print(_filteredMessages.messages.length);
  }

  void _onTap(int i) {
    if (messageID.length > 0) {
      setState(() {
        _messages.messages[i].isSelected = !_messages.messages[i].isSelected!;
        if (_messages.messages[i].isSelected!) {
          print("addd");
          messageID.add(_messages.messages[i].messageId!);
          selectedMessages.add(_messages.messages[i]);
        } else {
          print("removeee");
          messageID.removeWhere((element) => element == _messages.messages[i].messageId);
          selectedMessages.removeWhere((element) => element.messageId == _messages.messages[i].messageId);
        }
      });
    }
  }

  void _onLongTapMessage(int i) {
    if (messageID.length == 0) {
      setState(() {
        _messages.messages[i].isSelected = !_messages.messages[i].isSelected!;
        messageID.add(_messages.messages[i].messageId!);
        selectedMessages.add(_messages.messages[i]);
      });
    }
  }

  void _onTapFilter(int i) {
    if (messageID.length > 0) {
      setState(() {
        _filteredMessages.messages[i].isSelected = !_filteredMessages.messages[i].isSelected!;
        if (_filteredMessages.messages[i].isSelected!) {
          print("addd");
          messageID.add(_filteredMessages.messages[i].messageId!);
          selectedMessages.add(_filteredMessages.messages[i]);
        } else {
          print("removeee");
          messageID.removeWhere((element) => element == _filteredMessages.messages[i].messageId);
          selectedMessages.removeWhere((element) => element.messageId == _filteredMessages.messages[i].messageId);
        }
      });
    }
  }

  void _onLongTapMessageFilter(int i) {
    if (messageID.length == 0) {
      setState(() {
        _filteredMessages.messages[i].isSelected = !_filteredMessages.messages[i].isSelected!;
        messageID.add(_filteredMessages.messages[i].messageId!);
        selectedMessages.add(_filteredMessages.messages[i]);
      });
    }
  }

  Future<List<ChatMessagesModel>> _getSingleStarred() async {
    return widget.messages!;
  }

  void _singleStarred() {
    _starredMessages = _getSingleStarred().then((value) {
      setState(() {
        print("has starred single");
        setState(() {
          _messages.messages = widget.messages!;
        });
        print(_messages.messages[0].you);
      });
      return _messages;
    });
  }

  @override
  void initState() {
    if (widget.messages == null) {
      print("not nullll");
      _getStarredMessagesLocal();
    } else {
      _singleStarred();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatDetailScaffoldBgColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        flexibleSpace: gradientContainer(null),
        title: isSearchOpen && messageID.length == 0
            ? searchBar()
            : messageID.length > 0
                ? Text(messageID.length.toString())
                : Text(
                    AppLocalizations.of('Starred messages'),
                  ),
        actions: _messages.messages.length <= 0 && isSearchOpen
            ? []
            : messageID.length > 0
                ? [
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(CustomIcons.unstarred),
                          onPressed: () {
                            String allIds = "";
                            allIds = messageID.join(",");

                            ChatApiCalls().unstarMessage(allIds).then((value) {
                              _refresh.updateRefresh(true);
                            });
                            setState(() {
                              messageID = [];
                              selectedMessages = [];
                              _messages.messages.removeWhere((element) => element.isSelected == true);
                            });
                            if (_filteredMessages.messages.length > 0) {
                              _filteredMessages.messages.removeWhere((element) => element.isSelected == true);
                            }
                          },
                        );
                      },
                    ),
                    selectedMessages.length == 1
                        ? Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                icon: Icon(Icons.info_outline),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MessageInfoPage(
                                                message: selectedMessages[0],
                                              )));
                                },
                              );
                            },
                          )
                        : Container(),
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog

                                return DeleteMessagePopup(
                                  title: messageID.length == 1
                                      ? AppLocalizations.of("Delete message?")
                                      : "Delete ${messageID.length.toString()} messages?",
                                  deleteForMe: () {
                                    String messages = messageID.join(",");
                                    ChatApiCalls().deleteMessages(messages, "").then((value) {
                                      _refresh.updateRefresh(true);
                                    });
                                    setState(() {
                                      _messages.messages.removeWhere((element) => element.isSelected == true);
                                    });
                                    setState(() {
                                      messageID = [];
                                      messageID.length = 0;
                                      selectedMessages = [];
                                    });
                                    Navigator.pop(context);
                                  },
                                  deleteForAll: () {
                                    String messages = messageID.join(",");
                                    ChatApiCalls().deleteMessagesEveryone(messages, "", "").then((value) {
                                      _refresh.updateRefresh(true);
                                    });

                                    _messages.messages.forEach((element) {
                                      if (element.isSelected!) {
                                        print("selected");
                                        setState(() {
                                          element.message = "You deleted this message";
                                          element.isSelected = false;
                                          element.messageType = "text";
                                        });
                                      }
                                    });
                                    setState(() {
                                      messageID = [];
                                      messageID.length = 0;
                                      selectedMessages = [];
                                    });

                                    Navigator.pop(context);
                                  }, isyou: [],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Call Button tapped')));
                          },
                        );
                      },
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(
                            CustomIcons.forward_new,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForwardMessageChatPage(
                                          messageIDs: messageID,
                                        )));
                          },
                        );
                      },
                    ),
                  ]
                : <Widget>[
                    IconButton(
                      tooltip: AppLocalizations.of('Search'),
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      onPressed: () {
                        // _clear();

                        setState(() {
                          isSearchOpen = true;
                        });
                      },
                    ),
                    PopupMenuButton<StarredMessageOptions>(
                      tooltip: AppLocalizations.of("More options"),
                      onSelected: _selectOption,
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<StarredMessageOptions>(
                            child: Text(
                              AppLocalizations.of('Unstar all'),
                            ),
                            value: StarredMessageOptions.unstarAll,
                          ),
                        ];
                      },
                    )
                  ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isSearchOpen) {
            setState(() {
              isSearchOpen = false;
              _filteredMessages.messages = [];
            });
            _searchBarController.clear();
            return false;
          } else if (messageID.length > 0) {
            setState(() {
              messageID = [];
              selectedMessages = [];
            });
            return false;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: StreamBuilder<Object>(
            initialData: _refresh.currentSelect,
            stream: _refresh.observableCart,
            builder: (context, dynamic snapshot) {
              if (snapshot.data) {
                print("refresh starred");
                _getStarredMessages();
                _refresh.updateRefresh(false);
              }
              return FutureBuilder(
                  future: _starredMessages,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: _searchBarController.text.length > 0
                            ? ListView.builder(
                                itemCount: _filteredMessages.messages.length,
                                itemBuilder: (context, index) {
                                  return StarredMessageCard(
                                      index: index,
                                      message: _filteredMessages.messages[index],
                                      onLongPress: () {
                                        if (_filteredMessages.messages[index].you != 2) {
                                          _onLongTapMessageFilter(index);
                                        }
                                      },
                                      onTap: () {
                                        if (_filteredMessages.messages[index].you != 2) {
                                          _onTapFilter(index);
                                        }
                                      }, controller: AutoScrollController(),
                                      image: '',
                                      
                                      );
                                })
                            : ListView.builder(
                                itemCount: _messages.messages.length,
                                itemBuilder: (context, index) {
                                  return StarredMessageCard(
                                      index: index,controller: AutoScrollController(),
                                      image: '',
                                      
                                      message: _messages.messages[index],
                                      onLongPress: () {
                                        if (_messages.messages[index].you != 2) {
                                          _onLongTapMessage(index);
                                        }
                                      },
                                      onTap: () {
                                        if (_messages.messages[index].you != 2) {
                                          _onTap(index);
                                        }
                                      });
                                }),
                      );
                    } else {
                      return Container();
                    }
                  });
            }),
      ),
    );
  }

  _buildEmptyPage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                const Color(0xff2B25CC),
                const Color(0xffA6635B),
                const Color(0xff91596F),
                const Color(0xffB46A4D),
                const Color(0xffF18910),
                const Color(0xffA6635B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(75.0),
            // color: Color(0xff1dbea5),
          ),
          child: Icon(
            Icons.star,
            color: Colors.white,
            size: 75.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 80.0, left: 80.0, top: 32.0),
          child: Text(
            AppLocalizations.of(
              'Tap and hold on any message in any chat to star it, so you can easily find it later.',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.2,
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
        )
      ],
    );
  }

  _selectOption(StarredMessageOptions option) {
    switch (option) {
      case StarredMessageOptions.unstarAll:
        break;
    }
  }
}
