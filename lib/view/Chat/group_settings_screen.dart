import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/group_api.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group_admins_page.dart';

class GroupSettingsPage extends StatefulWidget {
  final String? groupID;
  final String? topic;
  final List<DirectMessageUserListModel>? users;

  const GroupSettingsPage({Key? key, this.groupID, this.topic, this.users})
      : super(key: key);

  @override
  _GroupSettingsPageState createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  Future<void> _setPreferenceEditInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("edit_group_info_${widget.groupID}", editGroupInfoIndex);
    GroupApiCalls().updateEditGroupInfo(
        editGroupInfoIndex, widget.groupID!, widget.topic!);
  }

  Future<void> _setPreferenceSendMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("send_messages_${widget.groupID}", sendMessagesIndex);
    GroupApiCalls().updateSendMessageInfo(
        sendMessagesIndex, widget.groupID!, widget.topic!);
  }

  Future<void> _getPreferenceEditInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? pref = prefs.getInt("edit_group_info_${widget.groupID!}");
    if (pref != null) {
      setState(() {
        editGroupInfoIndex = pref;
      });
    }
  }

  Future<void> _getPreferenceSendMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? pref = prefs.getInt("send_messages_${widget.groupID}");
    if (pref != null) {
      setState(() {
        sendMessagesIndex = pref;
      });
    }
  }

  String editInfoTitle = "Edit group info";
  String editInfoContent =
      "Choose who can change this group's subject, icon and description.";

  String sendMessagesTitle = "Send messages";
  String sendMessagesContent = "Choose who can send messages to this group";

  int editGroupInfoIndex = 1;
  int sendMessagesIndex = 1;

  Widget _actionButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 16, color: darkColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _listTile(String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ListTile(
        onTap: onTap,
        dense: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        tileColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: subtitle == "none"
            ? null
            : Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
      ),
    );
  }

  Widget _unselected() {
    return Container(
      height: 20,
      width: 20,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.grey,
          width: 2,
        ),
      ),
    );
  }

  Widget _selected() {
    return Container(
      height: 20,
      width: 20,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: darkColor,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 7,
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 5,
          foregroundColor: darkColor,
          backgroundColor: darkColor,
        ),
      ),
    );
  }

  Widget _dialogTile(
      String title, VoidCallback onTap, int selected, int mainIndex) {
    return SizedBox(
      height: 40,
      child: Center(
        child: ListTile(
          dense: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          onTap: onTap,
          title: Text(
            title,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
          leading: selected == mainIndex ? _selected() : _unselected(),
        ),
      ),
    );
  }

  Widget _dialog(String heading, String text, int val, int matchIndex) {
    return Dialog(
      child: StatefulBuilder(
          builder: (BuildContext dialogContext, StateSetter state) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Text(
                  heading,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87),
                ),
              ),
              _dialogTile(
                  AppLocalizations.of(
                    "All participants",
                  ), () {
                if (val == 1) {
                  state(() {
                    editGroupInfoIndex = 1;
                  });
                } else {
                  state(() {
                    sendMessagesIndex = 1;
                  });
                }
              }, 1, val == 1 ? editGroupInfoIndex : sendMessagesIndex),
              _dialogTile(
                  AppLocalizations.of(
                    "Only admins",
                  ), () {
                if (val == 1) {
                  state(() {
                    editGroupInfoIndex = 0;
                  });
                } else {
                  state(() {
                    sendMessagesIndex = 0;
                  });
                }
              }, 0, val == 1 ? editGroupInfoIndex : sendMessagesIndex),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _actionButton(
                      AppLocalizations.of(
                        "CANCEL",
                      ), () {
                    if (val == 1) {
                      _getPreferenceEditInfo();
                    } else {
                      _getPreferenceSendMessages();
                    }
                    Navigator.pop(dialogContext);
                  }),
                  _actionButton(
                      AppLocalizations.of(
                        "OK",
                      ), () {
                    Navigator.pop(dialogContext);
                    if (val == 1) {
                      _setPreferenceEditInfo();
                      _getPreferenceEditInfo();
                    } else {
                      _setPreferenceSendMessages();
                      _getPreferenceSendMessages();
                    }
                  }),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  void _showDialog(String title, String text, int val, int matchIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _dialog(title, text, val, matchIndex);
      },
    );
  }

  @override
  void initState() {
    _getPreferenceEditInfo();
    _getPreferenceSendMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            "Group settings",
          ),
          style: whiteBold.copyWith(fontSize: 20),
        ),
        flexibleSpace: gradientContainer(null),
        backgroundColor: Colors.white,
        brightness: Brightness.dark,
      ),
      body: Column(
        children: [
          _listTile(editInfoTitle,
              editGroupInfoIndex == 1 ? "All participants" : "Only admins", () {
            _showDialog(editInfoTitle, editInfoContent, 1, editGroupInfoIndex);
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Text(
              editInfoContent,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
          _listTile(
              sendMessagesTitle,
              sendMessagesIndex == 1
                  ? AppLocalizations.of("All participants")
                  : AppLocalizations.of(
                      "Only admins",
                    ), () {
            _showDialog(
                sendMessagesTitle, sendMessagesContent, 2, sendMessagesIndex);
          }),
          _listTile(
            AppLocalizations.of(
              "Edit group admins",
            ),
            AppLocalizations.of(
              "none",
            ),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupAdminsPage(
                    users: widget.users!,
                    addOrRemoveAdmin: (List<DirectMessageUserListModel> users) {
                      showDialog(
                        context: context,
                        builder: (BuildContext processingContext) {
                          users.forEach((element) {
                            if (element.admin == 1) {
                              GroupApiCalls().makeGroupAdmin(
                                  element.fromuserid!,
                                  widget.groupID!,
                                  widget.topic!);
                            } else {
                              GroupApiCalls().removeGroupAdmin(
                                  element.fromuserid!,
                                  widget.groupID!,
                                  widget.topic!);
                            }
                          });
                          Timer(Duration(seconds: 2), () {
                            Navigator.pop(processingContext);
                          });

                          return ProcessingDialog(
                            title: AppLocalizations.of(
                              "Please wait a moment",
                            ),
                            heading: AppLocalizations.of(
                              "Updating group admins",
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
