import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class DisableAccountConfirmationPage extends StatefulWidget {
  final Function? setNavbar;

  const DisableAccountConfirmationPage({Key? key, this.setNavbar})
      : super(key: key);

  @override
  _DisableAccountConfirmationPageState createState() =>
      _DisableAccountConfirmationPageState();
}

class _DisableAccountConfirmationPageState
    extends State<DisableAccountConfirmationPage> {
  TextEditingController _controller = TextEditingController();

  String res = "";
  bool matched = false;

  Future<String> checkPassword(String pass) async {
    var url =
        "https://www.bebuzee.com/api/member_password_check.php?action=edit_profile_check_password&password=$pass&user_id=${CurrentUser().currentUser.memberID}";

    var response = await ApiProvider().fireApi(url);

    if (mounted && response.data != null) {
      print('password check api call ${response.data}');
      setState(() {
        res = response.data['response'];
        if (res == "success") {
          setState(() {
            matched = true;
          });
        } else {
          setState(() {
            matched = false;
          });
        }
      });
    }

    return "success";
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("memberID");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(
                Icons.keyboard_backspace_outlined,
                color: Colors.black,
                size: 3.5.h,
              ),
              SizedBox(
                width: 4.0.w,
              ),
              Text(
                AppLocalizations.of(
                  "Disable Account",
                ),
                style: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                    "Confirm Your Password",
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
                ),
                SizedBox(
                  width: 1.5.h,
                ),
                Container(
                  child: TextFormField(
                    onChanged: (val) {
                      if (val != "") {
                        checkPassword(val);
                      } else {
                        checkPassword("2");
                      }
                    },
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      hintText: AppLocalizations.of(
                        "Enter Password",
                      ),

                      contentPadding: EdgeInsets.only(top: 15),
                      hintStyle:
                          TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: matched ? Colors.green : Colors.grey,
                        size: 25,
                      ),

                      // 48 -> icon width
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (matched) {
                        logout();
                        widget.setNavbar!(true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      from: "disable",
                                    )));
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(
                            "Account disabled successfully",
                          ),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          textColor: Colors.white,
                          fontSize: 15.0,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(
                            "Incorrect Password",
                          ),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          textColor: Colors.white,
                          fontSize: 15.0,
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                          decoration: new BoxDecoration(
                            color: matched
                                ? primaryBlueColor
                                : primaryBlueColor.withOpacity(0.3),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              AppLocalizations.of(
                                "Disable",
                              ),
                              style: TextStyle(
                                  fontSize: 12.0.sp, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
