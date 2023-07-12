import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/basic/join_channel_audio.dart';
import 'package:bizbultest/basic/join_channel_video.dart';
import 'package:bizbultest/basic/newVcScreen.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/MyContactModel.dart';
import 'package:bizbultest/permission/permissions.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/android_intent_helpers.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Chat/contacts_help_screen.dart';
import 'package:bizbultest/view/Chat/detailed_chat_screen.dart';
import 'package:bizbultest/view/Chat/direct_chat_screen.dart';
import 'package:bizbultest/view/Chat/new_group_select_users_page.dart';
import 'package:bizbultest/view/edit_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  _SelectContactScreenState createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  Future<Iterable<Contact>>? _contacts;
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

  MyContactModel objMyContactModel = new MyContactModel();

  Future<Iterable<Contact>> _getContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );
    contacts = contacts.where((f) => f.phones!.length > 0);
    Map<String, dynamic> jsonMap = new Map();
    jsonMap["contacts"] = [];
    contacts.forEach((element) {
      Map<String, dynamic> singleContact = new Map();
      singleContact['name'] = element.givenName;
      singleContact['phones'] = [];
      element.phones!.forEach((element) {
        singleContact['phones'].add(element.value);
      });
      jsonMap['contacts'].add(singleContact);
    });

    print(jsonEncode(jsonMap));
    print(jsonMap["contacts"].length);
    DirectApiCalls.syncContacts(contacts.toList()).then((value) {
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
          hintText: AppLocalizations.of(
            'Search...',
          ),
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
          child: Text(AppLocalizations.of('Refresh')),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactsHelpScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    myContact();
    super.initState();
  }

  List<ContactList> lstContactList = [];

  myContact() async {
    try {
      objMyContactModel =
          await ApiProvider().myContacts(CurrentUser().currentUser.memberID!);

      if (objMyContactModel != null && objMyContactModel.contactList != null) {
        objMyContactModel.contactList!.forEach((element) {
          if (element.memberId != CurrentUser().currentUser.memberID) {
            lstContactList.add(element);
          }
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {});
    }
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
        title: Column(
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
              child: Text(
                lstContactList.length.toString(),
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
                              0.4,
                              Colors.white,
                            ),
                          ),
                        ),
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
                  },
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    _showPopupMenuPhoto(statusBarHeight);
                  },
                )
              ]
            : [
                Container(),
              ],
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
        child: ListView.builder(
          padding: EdgeInsets.only(
              top: 14,
              right: 14,
              left: 14,
              bottom: MediaQuery.of(context).padding.bottom + 50),
          itemCount: lstContactList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    lstContactList[index].memberImage != null &&
                            lstContactList[index].memberImage != ""
                        ? Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 23.0,
                                backgroundImage: NetworkImage(
                                  lstContactList[index].memberImage!,
                                ),
                                backgroundColor: Colors.grey[300],
                              ),
                            ],
                          )
                        : CircleAvatar(
                            radius: 23.0,
                            backgroundColor: Colors.grey[350],
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lstContactList[index].memberName!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          AppLocalizations.of(
                            "Avilable",
                          ),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        getPermission(
                          lstContactList[index].memberName,
                          lstContactList[index].firebaseToken,
                          lstContactList[index].memberId,
                          lstContactList[index].memberImage,
                        );
                      },
                      child: Icon(Icons.videocam),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () async {
                        await sendPushMessage(
                            lstContactList[index].memberName,
                            lstContactList[index].firebaseToken,
                            lstContactList[index].memberId,
                            isVideo: false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JoinChannelAudio(
                              img: lstContactList[index].memberImage,
                              isFromHome: false,
                              callFromButton: true,
                              token: lstContactList[index].firebaseToken,
                              name: lstContactList[index].memberName,
                              oppositeMemberId: lstContactList[index].memberId,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.call),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  getPermission(name, token, memberid, image) async {
    bool locationResult = await Permissions().getCameraPermission();
    if (locationResult) {
      await sendPushMessage(name, token, memberid, isVideo: true);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            oppositeMemberId: memberid,
            isFromHome: false,
            callFromButton: true,
            name: name,
            token: token,
            userImage: image,
          ),
        ),
      );
    } else {
      getPermission(name, token, memberid, image);
    }
  }

  Future sendPushMessage(name, token, memberid, {bool isVideo = false}) async {
    String aa = "";
    if (isVideo) {
      aa = memberid + "+video";
    } else {
      aa = memberid + "+audio";
    }
    await ChatApiCalls.sendFcmRequest(
        name, aa, "call", "otherMemberID", token, 0, 0,
        isVideo: isVideo);
  }
}
