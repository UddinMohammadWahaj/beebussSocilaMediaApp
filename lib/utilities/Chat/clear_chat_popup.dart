import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialogue_helpers.dart';

class ClearChatPopup extends StatefulWidget {
  final String memberID;

  const ClearChatPopup({Key? key, required this.memberID}) : super(key: key);

  @override
  _ClearChatPopupState createState() => _ClearChatPopupState();
}

class _ClearChatPopupState extends State<ClearChatPopup> {
  int selectedIndex = 0;
  bool deleteMedia = true;
  bool deleteStarred = false;

  Widget _unselected() {
    return Container(
      height: 20,
      width: 20,
      child: Icon(
        Icons.check_box_outline_blank,
        color: Colors.grey,
      ),
    );
  }

  Widget _selected() {
    return Container(
      height: 20,
      width: 20,
      child: Icon(Icons.check_box, color: darkColor),
    );
  }

  Widget _tile(String title, VoidCallback onTap, bool selected) {
    return ListTile(
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(color: Colors.black54, fontSize: 15),
      ),
      leading: selected == true ? _selected() : _unselected(),
    );
  }

  void _clearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProcessingDialog(
          title: AppLocalizations.of(
            "Clearing chat",
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: Container(
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                AppLocalizations.of(
                  "Clear messages in chat?",
                ),
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                AppLocalizations.of(
                  "Are you sure you want to clear messages in this chat?",
                ),
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
            _tile(
                AppLocalizations.of(
                  "Delete media in this chat",
                ), () {
              setState(() {
                deleteMedia = !deleteMedia;
              });
            }, deleteMedia),
            _tile(
                AppLocalizations.of(
                  "Delete starred messages",
                ), () {
              setState(() {
                deleteStarred = !deleteStarred;
              });
            }, deleteStarred),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(
                        "CANCEL",
                      ),
                      style: TextStyle(fontSize: 14, color: darkColor),
                    )),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      //_clearDialog();
                      int starred;
                      if (deleteStarred) {
                        starred = 1;
                      } else {
                        starred = 0;
                      }
                      await ChatApiCalls()
                          .clearChat(widget.memberID, starred, context);
                    },
                    child: Text(
                      AppLocalizations.of(
                        "CLEAR MESSAGES",
                      ),
                      style: TextStyle(fontSize: 14, color: darkColor),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
