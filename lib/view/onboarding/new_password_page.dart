import 'dart:ui';

import 'package:bizbultest/services/User/otp_verification_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NewPasswordPage extends GetView<OTPVerificationController> {
  const NewPasswordPage({Key? key}) : super(key: key);

  Widget _customTextField(String hintText, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          alignLabelWithHint: true,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 50,
      width: 100.0.w - 20,
      child: ElevatedButton(
        onPressed: () {
          controller.errorText() != null
              ? ScaffoldMessenger.of(context).showSnackBar(
                  showSnackBar(
                    controller.errorText()!,
                  ),
                )
              : controller.updatePassword(context);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            backgroundColor: MaterialStateProperty.all(primaryBlueColor)),
        child: Text(
          "Update",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(OTPVerificationController());
    return Scaffold(
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
            //Get.delete<OTPVerificationController>();
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text("Set Password",
            style: TextStyle(fontSize: 14.0.sp, color: Colors.black)),
        elevation: 0,
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          height:
              100.0.h - (56 + MediaQueryData.fromWindow(window).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _customTextField("Enter new password", controller.newPassword),
              _customTextField("Confirm password", controller.confirmPassword),
              _submitButton(context)
            ],
          ),
        ),
      ),
    );
  }
}
