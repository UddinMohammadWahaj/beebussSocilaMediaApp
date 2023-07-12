import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/archived_chats.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat History'),
        flexibleSpace: gradientContainer(null),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            fabBgColor,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                onTap: () {},
                title: Text('Export chat'),
                leading: Icon(Icons.ios_share),
              ),
              ListTile(
                onTap: () {
                  _archiveAllChatDialog();
                },
                title: Text('Archive all chats'),
                leading: Icon(Icons.archive),
              ),
              ListTile(
                onTap: () {
                  _clearAllChatDialog();
                },
                title: Text('Clear all chats'),
                leading: Icon(Icons.remove_circle_outline),
              ),
              ListTile(
                onTap: () {
                  _deleteAllChatDialog();
                },
                title: Text('Delete all chats'),
                leading: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _archiveAllChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            buttonPadding: EdgeInsets.all(0),
            titleTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            title: Text(
              'Are you sure you want to archive ALL chats?',
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    archiveChat();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  )),
            ],
          );
        });
      },
    );
  }

  TwoFactorEnableModel objTwoFactorEnableArchive = new TwoFactorEnableModel();

  archiveChat() async {
    try {
      setState(() {
        isloading = true;
      });
      String uid = CurrentUser().currentUser.memberID!;
      objTwoFactorEnableArchive = await ApiProvider().archiveAllChat(uid);
      if (objTwoFactorEnableArchive != null &&
          objTwoFactorEnableArchive.success != null) {
        Fluttertoast.showToast(msg: objTwoFactorEnableArchive.message!);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  clearChat() async {
    try {
      setState(() {
        isloading = true;
      });
      String uid = CurrentUser().currentUser.memberID!;
      objTwoFactorEnableArchive = await ApiProvider().clearAllChat(uid);
      if (objTwoFactorEnableArchive != null &&
          objTwoFactorEnableArchive.success != null) {
        Fluttertoast.showToast(msg: objTwoFactorEnableArchive.message!);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  delteChat() async {
    try {
      setState(() {
        isloading = true;
      });
      String uid = CurrentUser().currentUser.memberID!;
      objTwoFactorEnableArchive = await ApiProvider().deleteAllChat(uid);
      if (objTwoFactorEnableArchive != null &&
          objTwoFactorEnableArchive.success != null) {
        Fluttertoast.showToast(msg: objTwoFactorEnableArchive.message!);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void _clearAllChatDialog() {
    Map<String, bool> _mediaAutoList = {
      'Delete media in chats': false,
      'Delete starred messages': false,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            buttonPadding: EdgeInsets.all(0),
            title: Text(
              'Clear message in chats?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Messages in all chats will disappear forever.",
                    style: TextStyle(color: secondaryColor, fontSize: 14),
                  ),
                  Column(
                    children: _mediaAutoList.keys.map((String key) {
                      return SizedBox(
                        height: 40,
                        child: Center(
                          child: CheckboxListTile(
                            activeColor: secondaryColor,
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(key),
                            onChanged: (bool? value) {
                              setState(() {
                                _mediaAutoList[key] = value!;
                              });
                            },
                            value: _mediaAutoList[key],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    clearChat();
                  },
                  child: Text(
                    'CLEAR CHATS',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                    ),
                  )),
            ],
          );
        });
      },
    );
  }

  void _deleteAllChatDialog() {
    Map<String, bool> _mediaAutoList = {
      'Delete media in chats': false,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            buttonPadding: EdgeInsets.all(0),
            title: Text('Delete all chats?'),
            content: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Messages will be renovees form this device only."),
                  Column(
                    children: _mediaAutoList.keys.map((String key) {
                      return SizedBox(
                        height: 40,
                        child: Center(
                          child: CheckboxListTile(
                            activeColor: secondaryColor,
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(key),
                            onChanged: (bool? value) {
                              setState(() {
                                _mediaAutoList[key] = value!;
                              });
                            },
                            value: _mediaAutoList[key],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    delteChat();
                  },
                  child: Text(
                    'DELETE CHATS',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                    ),
                  )),
            ],
          );
        });
      },
    );
  }
}
