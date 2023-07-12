import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/android_intent_helpers.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/Chat/text_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Chat/send_contacts.dart';
import 'package:bizbultest/widgets/Chat/multi_select_contact_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/widgets/Chat/contact_card.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum NewChatOptions {
  inviteAFriend,
  contacts,
  refresh,
  help,
}

class SelectContactsToSend extends StatefulWidget {
  final Function? sendContacts;

  const SelectContactsToSend({Key? key, this.sendContacts}) : super(key: key);

  @override
  _SelectContactsToSendState createState() => _SelectContactsToSendState();
}

class _SelectContactsToSendState extends State<SelectContactsToSend> {
  late Future<Iterable<Contact>> _contacts;

  Future<Iterable<Contact>> _getContacts() async {
    var contacts = await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );

    contacts = contacts.where((Contact e) => e.phones!.isNotEmpty).toList();
    print(" contacts List $contacts");
    return contacts;
  }

  Future<Iterable<Contact>> _searchContacts(String name) async {
    var contacts = await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );
    contacts = contacts
        .where((Contact f) => f.displayName
            .toString()
            .toLowerCase()
            .startsWith(name.toLowerCase()))
        .toList();

    return contacts;
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

  List<Contact> allContacts = <Contact>[];
  List<Contact> selectedContacts = <Contact>[];
  TextEditingController _searchBarController = new TextEditingController();
  String text = "";

  Widget searchBar() {
    return TextField(
      style: TextStyle(color: Colors.white, fontSize: 18),
      cursorColor: Colors.white,
      onChanged: (val) {
        setState(() {
          text = _searchBarController.text;
        });
        if (_searchBarController.text != "") {
          setState(() {
            _contacts = _searchContacts(_searchBarController.text);
          });
        } else {
          setState(() {
            _contacts = _getContacts();
          });
        }
      },
      controller: _searchBarController,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: whiteNormal.copyWith(fontSize: 18)),
    );
  }

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _contacts = _getContacts();
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
          Icons.arrow_forward,
          color: Colors.white,
        ),
        onPressed: () {
          if (selectedContacts.length == 0) {
            customToastWhite(
                AppLocalizations.of(
                  "Please select atleast 1 contact",
                ),
                14.0,
                ToastGravity.BOTTOM);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SendContacts(
                          selectedContacts: selectedContacts,
                          sendContacts: widget.sendContacts,
                        )));
          }
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: !isSearching
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          AppLocalizations.of(
                            'Contacts to send',
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          selectedContacts.length.toString() +
                              " " +
                              AppLocalizations.of(
                                'selected',
                              ),
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                      );
                    },
                  )
                ],
              )
            : searchBar(),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isSearching) {
            setState(() {
              isSearching = false;
              _contacts = _getContacts();
            });
            return false;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: Container(
            child: FutureBuilder<Iterable<Contact>>(
                future: _contacts,
                builder: (context, dynamic snapshot) {
                  // List<dynamic> data = List<dynamic>();

                  if (snapshot.hasData) {
                    allContacts = [];
                    allContacts.addAll(snapshot.data);
                    return ListView.builder(
                      itemCount: allContacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = allContacts[index];

                        return MultiSelectContactCard(
                          selectedContacts: selectedContacts,
                          allContacts: allContacts,
                          contact: contact,
                          onTap: () {
                            if (selectedContacts.contains(contact)) {
                              setState(() {
                                selectedContacts.removeWhere(
                                    (element) => element == contact);
                              });
                            } else {
                              setState(() {
                                selectedContacts.add(contact);
                              });
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                })),
      ),
    );
  }
}
