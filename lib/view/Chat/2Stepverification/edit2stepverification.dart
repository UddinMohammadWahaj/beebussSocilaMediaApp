import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/app.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/2Stepverification/email.dart';
import 'package:bizbultest/view/Chat/2Stepverification/two_step_verification.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Edit2StepVerification extends StatefulWidget {
  const Edit2StepVerification({Key? key}) : super(key: key);

  @override
  _Edit2StepVerificationState createState() => _Edit2StepVerificationState();
}

class _Edit2StepVerificationState extends State<Edit2StepVerification> {
  bool isloading = false;
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
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, bottom: 16),
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.0),
                                  color: fabBgColor.withOpacity(0.4),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 70,
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    shape: BoxShape.rectangle,
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              Center(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: fabBgColor,
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: fabBgColor,
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: fabBgColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 90,
                          top: 83,
                          child: Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60.0),
                              color: fabBgColor,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: Icon(Icons.done, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Two-step verification is enabled, You will need to enter your PIN when registering your phone number with Bebuzee again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      _showMyDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14, left: 14),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel,
                            color: secondaryColor,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Disable",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 14, left: 14, top: 24),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountTwoStepPINScreen(
                              isComeFromChangePIN: true,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.pin,
                            color: secondaryColor,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Change PIN",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 14, left: 14, top: 24),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountTwoStepEmailScreen(
                              isComeFromChangeEmail: true,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: secondaryColor,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Change email address",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Disable two-step verification?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
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
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    disable2Factor();
                    // Navigator.pushReplacementNamed(context, Routes.ENABLETWOSTEP);
                  },
                  child: Container(
                    height: 40,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        "DISABLE",
                        style: TextStyle(color: secondaryColor, fontSize: 14),
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

  TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();
  disable2Factor() async {
    try {
      setState(() {
        isloading = true;
      });

      String uid = CurrentUser().currentUser.memberID!;

      await Future.delayed(Duration(seconds: 2));

      objTwoFactorEnableModel = await ApiProvider().disableTwoFactor(uid);

      if (objTwoFactorEnableModel != null) {
        Fluttertoast.showToast(msg: objTwoFactorEnableModel.message!);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
      Navigator.pop(context);
    }
  }
}
