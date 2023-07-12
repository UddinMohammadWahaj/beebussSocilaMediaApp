import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/android_intent_helpers.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../edit_profile_page.dart';
import 'contacts_help_screen.dart';
import 'detailed_chat_screen.dart';
import 'direct_chat_screen.dart';
import 'new_group_select_users_page.dart';

enum NewChatOptions {
  inviteAFriend,
  contacts,
  refresh,
  help,
}

class NewChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectContact();
  }
}

class SelectContact extends StatefulWidget {
  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  late Future<Iterable<Contact>> _contacts;
  var numContacts;
  int number = 0;
  late Future<DirectUsers> _chatContactsUserFuture;
  DirectUsers _chatUserContacts = new DirectUsers([]);
  DirectUsers _mainChatUserContacts = new DirectUsers([]);
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  ContactsRefresh _refresh = ContactsRefresh();
  TextEditingController _searchBarController = TextEditingController();
  bool isSearchOpen = false;
  bool isRefreshing = false;

  Future<Iterable<Contact>> _getContacts() async {
    var contacts = await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );
    print("contact is here $contacts");
    contacts = contacts.where((f) => f.phones!.length > 0).toList();
    // Map<String, dynamic> jsonMap = new Map();
    List contactsLst = [];
    contacts.forEach((element) {
      Map<String, dynamic> singleContact = new Map();
      singleContact['name'] = element.givenName;
      singleContact['phones'] = [];
      element.phones!.forEach((element) {
        singleContact['phones'].add(element.value);
      });
      contactsLst.add(singleContact);
    });

    // print(jsonEncode(jsonMap));
    // print(jsonMap["contacts"].length);
    DirectApiCalls.syncContacts(contactsLst).then((value) {
      _getUserContactsLocal();
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    });

    return contacts;
  }

  void _searchUsers(String name) async {
    setState(() {
      _chatUserContacts.users = _mainChatUserContacts.users
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(name.toLowerCase()))
          .toList();
    });
  }

  Widget searchBar() {
    return TextField(
      style: TextStyle(color: Colors.white, fontSize: 18),
      cursorColor: Colors.white,
      onChanged: (val) {
        _searchUsers(val);
      },
      controller: _searchBarController,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: whiteNormal.copyWith(fontSize: 18)),
    );
  }

  Future<int> _getNumContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );
    return contacts.where((f) => f.phones!.length > 0).length;
  }

  void onTapProfileContactItem(BuildContext context, Contact contact) {
    Dialog profileDialog = DialogHelpers.getProfileDialog(
      context: context,
      id: 1,
      imageUrl: null,
      name: contact.displayName,
    );
    showDialog(
        context: context, builder: (BuildContext context) => profileDialog);
  }

  void _getUserContactsLocal() {
    _chatContactsUserFuture =
        ChatApiCalls.getChatContactsListLocal().then((value) {
      if (mounted) {
        setState(() {
          _chatUserContacts.users = value.users;
          _mainChatUserContacts.users = value.users;
          // number = value.users.length;
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
          _mainChatUserContacts.users = value.users;
          number = value.users.length;
        });
      }
      return value!;
    });
  }

  Future<void> _showPopupMenuPhoto(double height) async {
    int? selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0.w, height, 0, 400),
      items: [
        PopupMenuItem(
          value: 0,
          child: Text(
            AppLocalizations.of('Invite friends'),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            AppLocalizations.of('Contacts'),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            AppLocalizations.of('Refresh'),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            AppLocalizations.of('Help'),
          ),
        ),
      ],
      elevation: 8.0,
    );
    if (selected == 0) {
      AndroidIntentHelpers.inviteFriend(context);
    } else if (selected == 1) {
      AndroidIntentHelpers.openContactApp(context);
    } else if (selected == 2) {
      setState(() {
        isRefreshing = true;
      });
      _getContacts();
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ContactsHelpScreen()));
    }
  }

  @override
  void initState() {
    _getUserContactsLocal();
    _contacts = _getContacts();
    _getNumContacts().then((num) {
      setState(() {
        numContacts = num;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
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
                        'Select contact',
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: number == 0
                        ? null
                        : Text(
                            '$number contacts',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                  )
                ],
              ),
        actions: !isSearchOpen
            ? [
                isRefreshing
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                            height: 5,
                            width: 35,
                            child: Center(
                                child: customCircularIndicator(
                                    0.4, Colors.white))),
                      )
                    : Container(),
                IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearchOpen = true;
                      });
                    }),
                IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      _showPopupMenuPhoto(statusBarHeight);
                    })
              ]
            : [Container()],
      ),
      body: WillPopScope(
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
        child: StreamBuilder<Object>(
            initialData: _refresh.currentSelect,
            stream: _refresh.observableCart,
            builder: (context, dynamic snapshot) {
              if (snapshot.data) {
                print("refresh contactsss");
                _getUserContacts();
                _refresh.updateRefresh(false);
              }
              return Container(
                  child: FutureBuilder(
                future: _chatContactsUserFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: ListView.builder(
                          itemCount: isSearchOpen
                              ? _chatUserContacts.users.length
                              : _chatUserContacts.users.length + 4,
                          itemBuilder: (context, index) {
                            if (index == 0 && !isSearchOpen) {
                              return ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: fabBgColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.group,
                                    size: 32.0,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(AppLocalizations.of("New group"),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewGroupSelectUsers(
                                                from: true,
                                              )));
                                },
                              );
                            } else if (index == 1 && !isSearchOpen) {
                              return ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: fabBgColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.person_add,
                                    size: 24.0,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                    AppLocalizations.of(
                                      'New contact',
                                    ),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                onTap: () {
                                  AndroidIntentHelpers.createContact(context);
                                },
                              );
                            } else if (index ==
                                    (_chatUserContacts.users.length + 2) &&
                                !isSearchOpen) {
                              return ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.share),
                                ),
                                title:
                                    Text(AppLocalizations.of('Invite friends'),
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                onTap: () {
                                  AndroidIntentHelpers.inviteFriend(context);
                                },
                              );
                            } else if (index ==
                                    _chatUserContacts.users.length + 3 &&
                                !isSearchOpen) {
                              return ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.help),
                                ),
                                title: Text(
                                    AppLocalizations.of(
                                      'Contacts help',
                                    ),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContactsHelpScreen()));
                                },
                              );
                            } else {
                              int ind;
                              if (isSearchOpen) {
                                ind = index;
                              } else {
                                ind = index - 2;
                              }
                              return DirectChatUserCard(
                                smallSize: 1,
                                from: "forward",
                                onTap: () {
                                  setState(() {
                                    CurrentUser()
                                            .currentUser
                                            .currentOpenMemberID =
                                        _chatUserContacts.users[ind].fromuserid;
                                  });
                                  _status.updateRefresh(_chatUserContacts
                                      .users[ind].onlineStatus);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailedChatScreen(
                                                  token: _chatUserContacts
                                                      .users[ind].token!,
                                                  name: _chatUserContacts
                                                      .users[ind].name!,
                                                  image: _chatUserContacts
                                                      .users[ind].image!,
                                                  memberID: _chatUserContacts
                                                      .users[ind].fromuserid!,
                                                  user: _chatUserContacts
                                                      .users[ind])));
                                },
                                user: _chatUserContacts.users[ind],
                              );
                            }
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
                                  fontWeight: FontWeight.w500, fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(darkColor)),
                              child: Text(
                                AppLocalizations.of(
                                  "Update",
                                ),
                                style: whiteBold.copyWith(fontSize: 15),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile()));
                              }),
                        ],
                      ),
                    );
                  }
                },
              ));
            }),
      ),
    );
  }
}
