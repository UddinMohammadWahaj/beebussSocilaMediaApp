import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/2Stepverification/verification_done.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountTwoStepConfirmEmail extends StatefulWidget {
  final String? confEmail;
  final bool? isComeFromChangeEmail;
  const AccountTwoStepConfirmEmail(
      {Key? key, this.confEmail, this.isComeFromChangeEmail = false})
      : super(key: key);

  @override
  _AccountTwoStepConfirmEmailState createState() =>
      _AccountTwoStepConfirmEmailState();
}

class _AccountTwoStepConfirmEmailState
    extends State<AccountTwoStepConfirmEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          'Two-step verification',
        ),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            Flexible(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                      child: Text(
                        "Confirm your email address:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: emailCtrl,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        cursorHeight: 23,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ],
                ),
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
                    backgroundColor: fabBgColor,
                  ),
                  widget.isComeFromChangeEmail!
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
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (checkValidation()) {
                    if (widget.isComeFromChangeEmail!) {
                      if (widget.confEmail == emailCtrl.text) {
                        MySharedPreferences().set2fEmail(widget.confEmail!);
                        updatePin();
                      } else {
                        Fluttertoast.showToast(
                            msg: "PINs don't match, Try again.");
                      }
                    } else {
                      if (widget.confEmail == emailCtrl.text) {
                        MySharedPreferences().set2fEmail(widget.confEmail!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountTwoStepDone(),
                          ),
                        );
                      } else {}
                      Fluttertoast.showToast(
                          msg: "Emails don't match, Try again.");
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isloading = false;

  updatePin() async {
    try {
      setState(() {
        isloading = true;
      });
      TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();
      String uid = CurrentUser().currentUser.memberID!;
      objTwoFactorEnableModel =
          await ApiProvider().updateEmail(emailCtrl.text, uid);
      if (objTwoFactorEnableModel != null) {
        Fluttertoast.showToast(msg: "Email Address set");
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  TextEditingController emailCtrl = new TextEditingController();

  bool checkValidation() {
    if (emailCtrl.text == null || emailCtrl.text == "") {
      Fluttertoast.showToast(msg: "Please enter Email");
      return false;
    }
    return true;
  }
}
