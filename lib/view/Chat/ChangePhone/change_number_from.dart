import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';

import 'change-number_otp.dart';

enum SingingCharacter { AllContacts, ChatWith, Custom }

class ChangeNumberFrom extends StatefulWidget {
  final String? fromPhone;
  final String? countryCode;
  final String? toPhone;
  final String? onlyToPhoneNumber;
  const ChangeNumberFrom(
      {Key? key,
      this.fromPhone,
      this.toPhone,
      this.countryCode,
      this.onlyToPhoneNumber})
      : super(key: key);

  @override
  _ChangeNumberFromState createState() => _ChangeNumberFromState();
}

class _ChangeNumberFromState extends State<ChangeNumberFrom> {
  bool _notifyContacts = true;
  bool _notifyswitch = true;
  SingingCharacter _character = SingingCharacter.AllContacts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text('Change number'),
      ),
      body: Column(
        children: [
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('You are about to change your number from'),
                      Text('${widget.fromPhone} to ${widget.toPhone}'),
                    ],
                  ),
                ),
                Divider(height: 0),
                SwitchListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  title: Text('Notify contacts'),
                  activeColor: secondaryColor,
                  onChanged: (bool value) {
                    setState(() {
                      _notifyContacts = value;
                      _notifyswitch = value;
                    });
                  },
                  value: _notifyswitch,
                ),
                _notifyswitch
                    ? Column(
                        children: [
                          Divider(height: 0),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                                'Only your groups will be notified about your new number'),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          RadioListTile<SingingCharacter>(
                            title: const Text('All Contacts'),
                            value: SingingCharacter.AllContacts,
                            groupValue: _character,
                            activeColor: secondaryColor,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value!;
                              });
                            },
                          ),
                          RadioListTile<SingingCharacter>(
                            title: const Text('Contacts I have chats with'),
                            value: SingingCharacter.ChatWith,
                            groupValue: _character,
                            activeColor: secondaryColor,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value!;
                              });
                            },
                          ),
                          RadioListTile<SingingCharacter>(
                            title: const Text('Custom...'),
                            value: SingingCharacter.Custom,
                            groupValue: _character,
                            activeColor: secondaryColor,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value!;
                              });
                            },
                          ),
                          Divider(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                            child: RichText(
                              text: TextSpan(
                                text: 'Your groups and ',
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'All contacts ',
                                    style: TextStyle(
                                      color: secondaryColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'will be notified about your new number.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            // ignore: deprecated_member_use
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor)),
              child: Text(
                'DONE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNumberOTP(
                      fromPhone: widget.fromPhone!,
                      toPhone: widget.toPhone!,
                      countryCode: widget.countryCode!,
                      onlyToPhoneNumber: widget.onlyToPhoneNumber!,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
