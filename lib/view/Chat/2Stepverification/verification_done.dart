import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AccountTwoStepDone extends StatefulWidget {
  final bool isComfromEmailScreen;
  const AccountTwoStepDone({
    Key? key,
    this.isComfromEmailScreen = false,
  }) : super(key: key);

  @override
  _AccountTwoStepDoneState createState() => _AccountTwoStepDoneState();
}

class _AccountTwoStepDoneState extends State<AccountTwoStepDone> {
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
        child: Column(
          children: <Widget>[
            Flexible(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0, bottom: 28.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'Two-step verification is enabled',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.1,
                        ),
                      ),
                    )
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
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: fabBgColor,
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
                  'ENABLE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (widget.isComfromEmailScreen) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    // Set 2f Enable

                    await enable2F();

                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();
  enable2F() async {
    try {
      setState(() {
        isloading = true;
      });

      String? pin = await MySharedPreferences().getPin2f();
      String? email = await MySharedPreferences().getEmail2f();
      String? uid = CurrentUser().currentUser.memberID;

      await Future.delayed(Duration(seconds: 2));

      objTwoFactorEnableModel =
          await ApiProvider().enableTwoFactor(uid!, pin!, email!);

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
}
