import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../api/ApiRepo.dart' as ApiRepo;

class ContactOptionsProfile extends StatefulWidget {
  final String? email;
  final String? number;
  final Function? refresh;

  ContactOptionsProfile({Key? key, this.email, this.number, this.refresh})
      : super(key: key);

  @override
  _ContactOptionsProfileState createState() => _ContactOptionsProfileState();
}

class _ContactOptionsProfileState extends State<ContactOptionsProfile> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//TODO:: inSheet 331
  Future<void> updateContact() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=update_public_contact_and_email&user_id=${CurrentUser().currentUser.memberID}&email=${_emailController.text}&contact=${_numberController.text}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_update_contact_and_email.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "email": _emailController.text,
      "contact": _numberController.text
    });

    if (response!.success == 1) {
      print(response!.data);
    }
  }

  @override
  void initState() {
    _numberController.text = widget.number!;
    _emailController.text = widget.email!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_backspace_outlined,
                        size: 3.5.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.0.w),
                      child: Text(
                        AppLocalizations.of("Contact Options"),
                        style: blackBold.copyWith(fontSize: 15.0.sp),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        updateContact();
                        ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                            .showSnackBar(showSnackBar(
                          AppLocalizations.of(
                            AppLocalizations.of(
                                'Contact Details Updated Successfully'),
                          ),
                        ));
                        Timer(Duration(seconds: 2), () {
                          Navigator.pop(context);
                          widget.refresh!();
                        });
                      },
                      child: Icon(
                        Icons.check,
                        size: 3.5.h,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 3.0.h),
              child: Text(
                AppLocalizations.of(
                  "Public Information",
                ),
                style: blackBold.copyWith(fontSize: 10.5.sp),
              ),
            ),
            PublicInformationInput(
              prefix: Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
              controller: _emailController,
            ),
            PublicInformationInput(
              prefix: Icon(
                Icons.phone_android,
                color: Colors.black,
              ),
              controller: _numberController,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 4.0.w),
              child: Text(
                AppLocalizations.of(
                  "People will be able to email or call your business directly from a button on your profile",
                ),
                style: greyNormal.copyWith(fontSize: 9.0.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PublicInformationInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Icon? prefix;

  const PublicInformationInput(
      {Key? key, this.controller, this.hintText, this.prefix})
      : super(key: key);

  @override
  _PublicInformationInputState createState() => _PublicInformationInputState();
}

class _PublicInformationInputState extends State<PublicInformationInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.0.h,
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.black.withOpacity(0.8)),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: widget.hintText,
          contentPadding: EdgeInsets.only(top: 15),
          hintStyle: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
          prefixIcon: widget.prefix,

          // 48 -> icon width
        ),
      ),
    );
  }
}
