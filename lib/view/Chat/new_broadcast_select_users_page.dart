import 'dart:async';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/group_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../edit_profile_page.dart';
import 'direct_chat_screen.dart';
import 'new_group_finalize.dart';
import 'package:sizer/sizer.dart';

enum NewChatOptions {
  inviteAFriend,
  contacts,
  refresh,
  help,
}

class NewBroadcastSelectUsers extends StatefulWidget {
  @override
  _NewBroadcastSelectUsersState createState() =>
      _NewBroadcastSelectUsersState();
}

class _NewBroadcastSelectUsersState extends State<NewBroadcastSelectUsers> {
  late Future<Iterable<Contact>> _contacts;
  var numContacts;
  int number = 0;
  bool isSearchOpen = false;
  late Future<DirectUsers> _chatContactsUserFuture;
  DirectUsers _chatUserContacts = new DirectUsers([]);
  DirectUsers _chatUserContactsMain = new DirectUsers([]);
  DirectUsers _selectedUsers = new DirectUsers([]);
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  ContactsRefresh _refresh = ContactsRefresh();
  List<String> memberIDs = [];
  List<String> names = [];
  TextEditingController _searchBarController = TextEditingController();

  void _searchUsers(String name) async {
    setState(() {
      _chatUserContacts.users = _chatUserContactsMain.users
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(name.toLowerCase()))
          .toList();
    });
  }

  Widget searchBar() {
    return TextField(
      style: TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.white,
      onChanged: (val) {
        if (val != "") {
          _searchUsers(val);
        } else {
          setState(() {
            _chatUserContacts.users = _chatUserContactsMain.users;
          });
        }
      },
      controller: _searchBarController,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: whiteNormal.copyWith(fontSize: 16)),
    );
  }

  void _getUserContactsLocal() {
    _chatContactsUserFuture =
        ChatApiCalls.getChatContactsListLocal().then((value) {
      if (mounted) {
        setState(() {
          _chatUserContacts.users = value.users;
          _chatUserContactsMain.users = value.users;
          number = value.users.length;
        });
      }
      _getUserContacts();
      return value;
    });
  }

  void _getUserContacts() {
    _chatContactsUserFuture =
        ChatApiCalls.getChatContactsList("").then((value) {
      if (mounted) {
        setState(() {
          _chatUserContacts.users = value!.users;
          _chatUserContactsMain.users = value!.users;
          number = value!.users.length;
          memberIDs = [];
        });
      }
      return value!;
    });
  }

  @override
  void initState() {
    _getUserContactsLocal();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        backgroundColor: darkColor,
        child: Icon(
          Icons.check,
          size: 25,
          color: Colors.white,
        ),
        onPressed: () {
          if (memberIDs.length < 2) {
            customToastWhite(
                AppLocalizations.of(
                  "At least 2 contacts must be selected",
                ),
                14.0,
                ToastGravity.BOTTOM);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(darkColor)),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            AppLocalizations.of(
                              "Creating broadcast list",
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );

            GroupApiCalls()
                .createBroadcast(memberIDs.join(","), names.join(", "))
                .then((value) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
            });
          }
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: isSearchOpen
            ? searchBar()
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      AppLocalizations.of(
                        'New broadcast',
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: memberIDs.length == 0
                        ? Text(
                            AppLocalizations.of(
                              'Add participants',
                            ),
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          )
                        : Text(
                            '${memberIDs.length.toString()} of $number selected',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                  )
                ],
              ),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of('Search'),
            icon: Icon(
              Icons.search,
              size: 28,
            ),
            onPressed: () {
              // _clear();

              setState(() {
                isSearchOpen = true;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<Object>(
          initialData: _refresh.currentSelect,
          stream: _refresh.observableCart,
          builder: (context, dynamic snapshot) {
            if (snapshot.data) {
              print("refresh contactsss");
              _getUserContacts();
              _refresh.updateRefresh(false);
            }
            return WillPopScope(
              onWillPop: () async {
                if (isSearchOpen) {
                  setState(() {
                    isSearchOpen = false;
                  });
                  return false;
                } else {
                  Navigator.pop(context);
                  return true;
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 45,
                      child: Text(
                        AppLocalizations.of(
                              "Only contacts with",
                            ) +
                            " ${CurrentUser().currentUser.contactNumber} in their address book will receive your broadcast messages",
                        style: greyNormal.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 0.6,
                    ),
                    Container(
                        height: 100.0.h - 172,
                        child: FutureBuilder(
                          future: _chatContactsUserFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                child: ListView.builder(
                                    itemCount: _chatUserContacts.users.length,
                                    itemBuilder: (context, index) {
                                      var user = _chatUserContacts.users[index];

                                      return DirectChatUserCard(
                                        from: "forward",
                                        onTap: () {
                                          if (!user.isSelected!) {
                                            setState(() {
                                              user.isSelected = true;
                                              memberIDs.add(user.fromuserid!);
                                              names.add(user.name!);
                                              _selectedUsers.users.add(user);
                                            });
                                          } else {
                                            setState(() {
                                              user.isSelected = false;
                                              memberIDs.removeWhere((element) =>
                                                  element == user.fromuserid);
                                              names.removeWhere((element) =>
                                                  element == user.name);
                                              _selectedUsers.users.removeWhere(
                                                  (element) =>
                                                      element.fromuserid ==
                                                      user.fromuserid);
                                            });
                                          }
                                        },
                                        user: _chatUserContacts.users[index],
                                      );
                                    }),
                              );
                            } else {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 20),
                                      child: Text(
                                        AppLocalizations.of(
                                          "Please update your country code to start using chat",
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    darkColor)),
                                        child: Text(
                                          AppLocalizations.of(
                                            "Update",
                                          ),
                                          style:
                                              whiteBold.copyWith(fontSize: 15),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile()));
                                        }),
                                  ],
                                ),
                              );
                            }
                          },
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
