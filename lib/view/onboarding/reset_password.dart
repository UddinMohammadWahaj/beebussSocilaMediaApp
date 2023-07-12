import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/User/password_reset_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/login_page.dart';
import 'package:bizbultest/view/onboarding/signup_page1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'otp_page.dart';

class PasswordReset extends StatefulWidget {
  final String? logo;
  final String? country;

  PasswordReset({Key? key, this.logo, this.country}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

var res;

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PasswordResetController controller = Get.put(PasswordResetController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<PasswordResetController>();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
              Get.delete<PasswordResetController>();
            },
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black87, width: 4)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.black87,
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      AppLocalizations.of(
                        "Trouble Logging In?",
                      ),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: Center(
                      child: Text(
                        AppLocalizations.of(
                          "Enter your email and we'll send you a 4-digit OTP to get back into your account.",
                        ),
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        shape: BoxShape.rectangle,
                        border: new Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            'Email',
                          ),
                          hintStyle: TextStyle(color: Colors.grey),
                          alignLabelWithHint: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controller.emailController.text.isEmpty) {
                            ScaffoldMessenger.of(
                                    _scaffoldKey.currentState!.context)
                                .showSnackBar(
                              showSnackBar(
                                AppLocalizations.of('Please enter Email'),
                              ),
                            );
                          } else {
                            controller.resetPassword().then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            });
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            backgroundColor:
                                MaterialStateProperty.all(primaryBlueColor)),
                        child: Text(
                          AppLocalizations.of(
                            "Send Login Link",
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(
                        'or',
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignUpPage1();
                        }));
                      },
                      child: Container(
                        width: _currentScreenSize.width - 20,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(
                              'Create New Account',
                            ),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
