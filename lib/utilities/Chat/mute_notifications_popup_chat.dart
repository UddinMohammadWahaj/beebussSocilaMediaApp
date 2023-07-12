import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MuteNotificationPopupChat extends StatefulWidget {
  final String memberID;

  const MuteNotificationPopupChat({Key? key, required this.memberID})
      : super(key: key);

  @override
  _MuteNotificationPopupChatState createState() =>
      _MuteNotificationPopupChatState();
}

class _MuteNotificationPopupChatState extends State<MuteNotificationPopupChat> {
  int selectedIndex = 2;
  String selectedDuration = "Infinity";

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

  Widget _tile(String title, VoidCallback onTap, int selected) {
    return ListTile(
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black87, fontSize: 18, fontWeight: FontWeight.normal),
      ),
      leading: selected == selectedIndex ? _selected() : _unselected(),
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                AppLocalizations.of(
                  "Mute notifications for...",
                ),
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
            _tile(
                AppLocalizations.of(
                  "8 hours",
                ), () {
              setState(() {
                selectedIndex = 0;
                selectedDuration = "8";
              });
            }, 0),
            _tile(
                AppLocalizations.of(
                  "1 week",
                ), () {
              setState(() {
                selectedIndex = 1;
                selectedDuration = "168";
              });
            }, 1),
            _tile(
                AppLocalizations.of(
                  "Always",
                ), () {
              setState(() {
                selectedIndex = 2;
                selectedDuration = "Infinity";
              });
            }, 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      AppLocalizations.of(
                        "Cancel",
                      ),
                      style: TextStyle(fontSize: 16, color: darkColor),
                    )),
                TextButton(
                    onPressed: () {
                      ChatApiCalls()
                          .muteUser(widget.memberID, selectedDuration);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      AppLocalizations.of(
                        "OK",
                      ),
                      style: TextStyle(fontSize: 16, color: darkColor),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
