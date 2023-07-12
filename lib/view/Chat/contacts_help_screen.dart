import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class ContactsHelpScreen extends StatefulWidget {
  @override
  _ContactsHelpScreenState createState() => _ContactsHelpScreenState();
}

class _ContactsHelpScreenState extends State<ContactsHelpScreen> {
  Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
          child: Text(
        text,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
      )),
    );
  }

  Widget _bulletText() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Container(child: Text("•", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        flexibleSpace: gradientContainer(null),
        title: Text(
          AppLocalizations.of(
            "Contacts help",
          ),
          style: whiteBold.copyWith(fontSize: 20),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            _text(
              AppLocalizations.of("If some of your friends don't appear on the contacts list, we recommend the following steps:"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                child: Row(
                  children: [
                    _bulletText(),
                    Container(
                        child: Expanded(
                            child: _text(
                      AppLocalizations.of("Make sure that your friend's phone number is in your address book"),
                    ))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                child: Row(
                  children: [
                    _bulletText(),
                    Container(
                        child: Expanded(
                            child: _text(
                      AppLocalizations.of("Make sure that your friend is using Bebuzee"),
                    ))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
