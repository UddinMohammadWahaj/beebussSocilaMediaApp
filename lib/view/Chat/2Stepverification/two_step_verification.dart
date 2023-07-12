import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'confirm_pin.dart';

class AccountTwoStepPINScreen extends StatefulWidget {
  final bool isComeFromChangePIN;

  const AccountTwoStepPINScreen({Key? key, this.isComeFromChangePIN = false})
      : super(key: key);
  @override
  _AccountTwoStepPINScreenState createState() =>
      _AccountTwoStepPINScreenState();
}

class _AccountTwoStepPINScreenState extends State<AccountTwoStepPINScreen> {
  TextEditingController pinCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          'Two-step verification',
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                  child: Text(
                    "Enter a 6-digit PIN which you'll be asked for when you register your phone number with Bebuzee:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.1,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    controller: pinCtrl,
                    textAlignVertical: TextAlignVertical.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    textAlign: TextAlign.center,
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
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: fabBgColor,
                ),
                CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.black26,
                ),
                widget.isComeFromChangePIN
                    ? SizedBox()
                    : CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.black26,
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(fabBgColor)),
              child: Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (checkValidation()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountTwoStepConfirmPIN(
                        pin: pinCtrl.text,
                        isComeFromChangePIN: widget.isComeFromChangePIN,
                      ),
                    ),
                  );
                }
              },
            ),
          )
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
}
