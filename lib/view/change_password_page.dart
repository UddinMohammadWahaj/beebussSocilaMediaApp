import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../api/ApiRepo.dart' as ApiRepo;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool passMatch = false;
//TODO:: inSheet 332
  Future<void> getPassword(String password) async {

    var response =
        await ApiRepo.postWithToken("api/member_password_check.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "password": password,
    });

    if (response!.success == 1) {
      if (this.mounted) {
        var pass = false;
        pass = response!.data['data']['is_match'];
        // ignore: unnecessary_statements

        setState(() {
          if (pass) {
            passMatch = true;
          }
        });

        print(passMatch);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_backspace_outlined,
                  size: 3.5.h,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 4.0.w,
                ),
                Text(
                  AppLocalizations.of(
                    "Change password",
                  ),
                  style: blackBold.copyWith(fontSize: 15.0.sp),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                child: Row(
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 4.0.h,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(CurrentUser().currentUser.image!),
                      ),
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Text(
                      CurrentUser().currentUser.shortcode!,
                      style: TextStyle(fontSize: 16.0.sp),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 3.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.0.h,
                      ),
                      child: Text(
                        AppLocalizations.of(
                          "Old Password",
                        ),
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      onChanged: (val) {
                        getPassword(val);
                      },
                      onTap: () {},
                      maxLines: 1,
                      controller: _oldPasswordController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: AppLocalizations.of(
                          "Enter old password",
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.0.h,
                      ),
                      child: Text(
                        AppLocalizations.of(
                          "New Password",
                        ),
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      onTap: () {},
                      maxLines: 1,
                      controller: _newPasswordController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: AppLocalizations.of(
                          "Enter new password",
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.0.h,
                      ),
                      child: Text(
                        AppLocalizations.of(
                          "Confirm Password",
                        ),
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      onTap: () {},
                      maxLines: 1,
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: AppLocalizations.of(
                          "Confirm new password",
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(primaryBlueColor)),
                onPressed: () {
                  if (passMatch == false) {
                    ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                        .showSnackBar(showSnackBar(
                      AppLocalizations.of('Old password incorrect'),
                    ));
                  } else if (_newPasswordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                        .showSnackBar(showSnackBar(
                      AppLocalizations.of('Passwords do not match'),
                    ));
                  } else {
                    ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                        .showSnackBar(showSnackBar(
                      AppLocalizations.of('Password updated successfully'),
                    ));
                  }
                },
                child: Text(
                  AppLocalizations.of(
                    "Change password",
                  ),
                  style: whiteBold.copyWith(fontSize: 10.0.sp),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
