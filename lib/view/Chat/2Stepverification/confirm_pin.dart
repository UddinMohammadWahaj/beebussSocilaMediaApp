import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'email.dart';

class AccountTwoStepConfirmPIN extends StatefulWidget {
  final bool? isComeFromChangePIN;
  final String? pin;
  const AccountTwoStepConfirmPIN(
      {Key? key, this.pin, this.isComeFromChangePIN = false})
      : super(key: key);

  @override
  _AccountTwoStepConfirmPINState createState() =>
      _AccountTwoStepConfirmPINState();
}

class _AccountTwoStepConfirmPINState extends State<AccountTwoStepConfirmPIN> {
  TextEditingController pinCtrl = new TextEditingController();

  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          'Two-step verification',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            fabBgColor,
          ),
        ),
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
                        "Confirm your PIN:",
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
            ),
            SizedBox(
              width: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.black26,
                  ),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: fabBgColor,
                  ),
                  widget.isComeFromChangePIN!
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
                    if (widget.isComeFromChangePIN!) {
                      if (widget.pin == pinCtrl.text) {
                        MySharedPreferences().set2fPin(widget.pin!);
                        updatePin();
                      } else {
                        Fluttertoast.showToast(
                            msg: "PINs don't match, Try again.");
                      }
                    } else {
                      if (widget.pin == pinCtrl.text) {
                        MySharedPreferences().set2fPin(widget.pin!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AccountTwoStepEmailScreen()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "PINs don't match, Try again.");
                      }
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

  updatePin() async {
    try {
      setState(() {
        isloading = true;
      });
      TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();
      String uid = CurrentUser().currentUser.memberID!;
      objTwoFactorEnableModel =
          await ApiProvider().updatePIN(pinCtrl.text, uid);
      if (objTwoFactorEnableModel != null) {
        Fluttertoast.showToast(msg: "PIN set");
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
