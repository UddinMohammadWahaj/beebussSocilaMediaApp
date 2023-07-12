import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewContact extends StatefulWidget {
  final ChatMessagesModel? message;

  const ViewContact({Key? key, this.message}) : super(key: key);
  @override
  _ViewContactState createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            AppLocalizations.of(
              'View contact',
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            widget.message!.contactName!,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await ContactsService.addContact(new Contact(
                                givenName: widget.message!.contactName,
                                phones: [
                                  Item(
                                      label: widget.message!.contactType,
                                      value: widget.message!.contactNumber)
                                ],
                              )).then((value) {
                                customToastWhite(
                                    AppLocalizations.of(
                                      "Contact Saved Successfully",
                                    ),
                                    14.0,
                                    ToastGravity.BOTTOM);
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(darkColor)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                AppLocalizations.of("Add"),
                                style: whiteBold.copyWith(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      )
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
                  },
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.message,
                      color: darkColor,
                    ),
                  ),
                  title: Text(
                    widget.message!.contactNumber!,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    widget.message!.contactType!,
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(
                              Icons.call,
                              color: darkColor,
                            ),
                            onPressed: () {},
                          );
                        },
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(
                              Icons.videocam_sharp,
                              color: darkColor,
                            ),
                            onPressed: () {},
                          );
                        },
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
