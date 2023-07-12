import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'confirm_email.dart';

class AccountTwoStepEmailScreen extends StatefulWidget {
  final bool isComeFromChangeEmail;
  const AccountTwoStepEmailScreen(
      {Key? key, this.isComeFromChangeEmail = false})
      : super(key: key);

  @override
  _AccountTwoStepEmailScreenState createState() =>
      _AccountTwoStepEmailScreenState();
}

class _AccountTwoStepEmailScreenState extends State<AccountTwoStepEmailScreen> {
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
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Add an email address to your account which will be used to reset your PIN if you forget in and",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'safeguard your accpunt. ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                height: 1.1,
                              ),
                            ),
                            widget.isComeFromChangeEmail
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      _showMyDialog();
                                    },
                                    child: Text(
                                      'Skip',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 16.0,
                                        height: 1.1,
                                      ),
                                    ),
                                  )
                          ],
                        )
                      ],
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
                  widget.isComeFromChangeEmail
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
              // ignore: deprecated_member_use
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
                        builder: (context) => AccountTwoStepConfirmEmail(
                          confEmail: emailCtrl.text,
                          isComeFromChangeEmail: widget.isComeFromChangeEmail,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  TextEditingController emailCtrl = new TextEditingController();

  bool checkValidation() {
    if (emailCtrl.text == null || emailCtrl.text == "") {
      Fluttertoast.showToast(msg: "Please enter Email");
      return false;
    }
    return true;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "if you don't add an email address and you forget your PIN, you won't be able to re-register your phone number with Bebuzee.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        "Cancle",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () async {
                    await enable2F();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool isloading = false;

  TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();
  enable2F() async {
    try {
      setState(() {
        isloading = true;
      });

      String? pin = await MySharedPreferences()!.getPin2f()!;
      String? email = await MySharedPreferences()!.getEmail2f()!;
      String uid = CurrentUser().currentUser.memberID!;

      await Future.delayed(Duration(seconds: 2));

      objTwoFactorEnableModel =
          await ApiProvider().enableTwoFactor(uid, pin!, email!);

      if (objTwoFactorEnableModel != null) {
        Fluttertoast.showToast(msg: objTwoFactorEnableModel.message!);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  // _showAlertDialog(BuildContext context) {
  //   Widget okButton = TextButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       Navigator.pop(context);

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => AccountTwoStepDone(
  //             isComfromEmailScreen: true,
  //           ),
  //         ),
  //       );

  //       // Set Two Step verification
  //     },
  //   );
  //   Widget cancelButton = TextButton(
  //     child: Text("CANCEL"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );

  //   AlertDialog alert = AlertDialog(
  //     content: Text("if you dont't add an email address and you forget your PIN, you won't be able to re-register your phone number with Bebuzee."),
  //     actions: [
  //       cancelButton,
  //       okButton,
  //     ],
  //   );

  //   show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
