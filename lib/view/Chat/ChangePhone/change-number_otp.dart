import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/help_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeNumberOTP extends StatefulWidget {
  final String? fromPhone;
  final String? toPhone;
  final String? countryCode;
  final String? onlyToPhoneNumber;
  const ChangeNumberOTP(
      {Key? key,
      this.fromPhone,
      this.toPhone,
      this.countryCode,
      this.onlyToPhoneNumber})
      : super(key: key);

  @override
  _ChangeNumberOTPState createState() => _ChangeNumberOTPState();
}

class _ChangeNumberOTPState extends State<ChangeNumberOTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Verify ${widget.toPhone}',
            style: TextStyle(color: secondaryColor)),
        centerTitle: true,
        actionsIconTheme: IconThemeData(color: Colors.black54),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpSettingsScreen(),
                  ),
                );
              }
              if (value == 2) {}
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 30,
                value: 1,
                child: Row(
                  children: <Widget>[
                    Text(
                      'Help',
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text('Waiting to automatically detect an SMS sent to'),
                  RichText(
                    text: TextSpan(
                      text: '${widget.toPhone}, ',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Wrong number?',
                          style: TextStyle(color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: pinCtrl,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
                      autofocus: true,
                      cursorHeight: 25,
                      style: TextStyle(fontSize: 23),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '  * * *   * * *',
                        hintStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text("Enter 6-digit code")),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.message),
                        title: Text('Resend SMS'),
                      ),
                      Divider(height: 0),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text('Call me'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor)),
              child: Text(
                'DONE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (checkValidation()) {
                  String uid = CurrentUser().currentUser.memberID!;
                  TwoFactorEnableModel objTwoFactorEnableModel =
                      await ApiProvider().updatePhone(
                          widget.countryCode!, uid, widget.toPhone!);

                  if (objTwoFactorEnableModel != null &&
                      objTwoFactorEnableModel.success != null) {
                    Fluttertoast.showToast(msg: "Phone Number Updated");
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool checkValidation() {
    if (pinCtrl.text == "" || pinCtrl.text == null) {
      Fluttertoast.showToast(msg: "Please enter Pin");
      return false;
    } else if (pinCtrl.text.length < 6) {
      Fluttertoast.showToast(msg: "Please enter 6 digit Pin");
      return false;
    }
    return true;
  }

  TextEditingController pinCtrl = new TextEditingController();
}
