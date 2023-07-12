import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DeleteMessagePopup extends StatelessWidget {
  final VoidCallback deleteForMe;
  final String title;
  final List<bool> isyou;
  final VoidCallback deleteForAll;

  DeleteMessagePopup(
      {Key? key,
      required this.isyou,
      required this.deleteForMe,
      required this.title,
      required this.deleteForAll})
      : super(key: key);

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
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: deleteForMe ?? () {},
              trailing: Text(
                AppLocalizations.of(
                  "DELETE FOR ME",
                ),
                style: TextStyle(
                    color: darkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              trailing: Text(
                AppLocalizations.of(
                  "CANCEL",
                ),
                style: TextStyle(
                    color: darkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (!isyou.contains(false))
              ListTile(
                onTap: deleteForAll ?? () {},
                trailing: Text(
                  AppLocalizations.of(
                    "DELETE FOR EVERYONE",
                  ),
                  style: TextStyle(
                      color: darkColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
