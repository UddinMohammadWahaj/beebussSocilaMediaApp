import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/blocked_users_chat_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/profile_api.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/Chat/text_helpers.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Chat/select_users_to_block.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedUsersScreen extends StatefulWidget {
  final List<BlockedUsersModel>? users;

  const BlockedUsersScreen({Key? key, this.users}) : super(key: key);

  @override
  _BlockedUsersScreenState createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  List<BlockedUsersModel> _blockedUsers = [];

  Widget _userCard(BlockedUsersModel user) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      title: TextHelpers().simpleTextCard(user.name!, FontWeight.normal, 16,
          Colors.black, 1, TextOverflow.ellipsis),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: darkColor,
        backgroundImage: CachedNetworkImageProvider(user.image!),
      ),
      onTap: () {
        _showUnblockDialog(user);
      },
    );
  }

  Widget _header() {
    return Container(
      color: Colors.grey.shade200,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        AppLocalizations.of('Contacts'),
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
      ),
    );
  }

  void _showUnblockDialog(BlockedUsersModel user) {
    showDialog(
      context: context,
      builder: (BuildContext unblockContext) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(unblockContext);
            _showProcessingDialog(user);
          },
          child: Dialog(
              child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                AppLocalizations.of('Unblock') + " ${user.name}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )),
        );
      },
    );
  }

  void _showProcessingDialog(BlockedUsersModel user) {
    showDialog(
        context: context,
        builder: (BuildContext processingContext) {
          ChatApiCalls().unblockUser(user.memberId!).then((value) {
            Navigator.pop(processingContext);
            customToastWhite(AppLocalizations.of('Unblocked') + " ${user.name}",
                16.0, ToastGravity.BOTTOM);
            setState(() {
              _blockedUsers.remove(user);
            });
          });
          return ProcessingDialog(
            title: AppLocalizations.of(
              "Please wait a moment",
            ),
            heading: "",
          );
        });
  }

  late int _blockedUsersCount;

  void _getBlockedUsers() {
    ProfileApiCallsChat.getBlockedUsers().then((value) async {
      setState(() {
        _blockedUsers = value!.users;
        _blockedUsersCount = _blockedUsers.length;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("blocked_count", _blockedUsersCount);
      return value;
    });
  }

  void _showBlockDialog(String memberID, String name) {
    showDialog(
        context: context,
        builder: (BuildContext processingContext) {
          ChatApiCalls().blockUser(memberID).then((value) {
            Navigator.pop(processingContext);
            customToastWhite("Blocked $name", 16.0, ToastGravity.CENTER);
            _getBlockedUsers();
          });
          return ProcessingDialog(
            title: AppLocalizations.of(
              "Please wait a moment",
            ),
            heading: "",
          );
        });
  }

  @override
  void initState() {
    _blockedUsers = widget.users!;
    _getBlockedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          AppLocalizations.of("Blocked contacts"),
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectUsersToBlock(
                              block: (String memberID, String name) {
                                _showBlockDialog(memberID, name);
                              },
                            )));
              })
        ],
      ),
      body: ListView.builder(
          itemCount: _blockedUsers.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _header();
            } else {
              return _userCard(_blockedUsers[index - 1]);
            }
          }),
    );
  }
}
