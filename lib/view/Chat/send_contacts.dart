import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsCustom {
  Contact? contact;
  bool? selected = true;

  ContactsCustom(contact, selected) {
    this.contact = contact;
    this.selected = selected;
  }
}

class SendContacts extends StatefulWidget {
  final List<Contact>? selectedContacts;
  final Function? sendContacts;

  const SendContacts({Key? key, this.selectedContacts, this.sendContacts})
      : super(key: key);

  @override
  _SendContactsState createState() => _SendContactsState();
}

class _SendContactsState extends State<SendContacts> {
  List<ContactsCustom> finalContacts = [];
  List<Contact> contacts = <Contact>[];

  void setContacts() {
    widget.selectedContacts!.forEach((element) {
      finalContacts.add(ContactsCustom(element, true));
    });
  }

  void _unselectContact(int index) {
    setState(() {
      finalContacts[index].selected = !finalContacts[index].selected!;
    });
  }

  @override
  void initState() {
    setContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: new FloatingActionButton(
        backgroundColor: darkColor,
        child: Icon(
          Icons.send,
          size: 20,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            contacts = [];
          });
          finalContacts.forEach((element) {
            if (element.selected!) {
              setState(() {
                contacts.add(element.contact!);
              });
            }
          });
          print(contacts.length);
          Navigator.pop(context);
          Navigator.pop(context);
          widget.sendContacts!(contacts);
        },
      ),
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            AppLocalizations.of(
              'Send Contacts',
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: ListView.builder(
            itemCount: finalContacts.length,
            itemBuilder: (context, index) {
              var contact = finalContacts[index].contact;
              return Card(
                elevation: 3,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                    decoration: new BoxDecoration(
                                      color: darkColor.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.person,
                                        size: 30,
                                      ),
                                    )),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  contact!.displayName!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.3,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          onTap: () {
                            print("hey");
                            _unselectContact(index);
                          },
                          leading: Icon(
                            Icons.call,
                            color: darkColor,
                          ),
                          title: Text(
                            contact.phones!.length == 0
                                ? ""
                                : contact.phones!.first.value!,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            contact.phones!.first.label!.toUpperCase(),
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Checkbox(
                              checkColor: Colors.white,
                              focusColor: Colors.white,
                              activeColor: darkColor,
                              value: finalContacts[index].selected,
                              onChanged: (val) {
                                _unselectContact(index);
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
