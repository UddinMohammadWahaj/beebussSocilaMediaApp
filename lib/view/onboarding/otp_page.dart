import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/User/otp_verification_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import 'new_password_page.dart';

class OTPPage extends GetView<OTPVerificationController> {
  const OTPPage({Key? key}) : super(key: key);

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 50),
      child: Column(
        children: [
          Text(
            "Verify Your Email Address",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Enter your OTP here",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _otpField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: PinCodeTextField(
        mainAxisAlignment: MainAxisAlignment.center,
        scrollPadding: EdgeInsets.symmetric(horizontal: 10),
        onCompleted: (val) {
          controller.enteredOTP.value = val;
        },
        keyboardType: TextInputType.number,
        cursorColor: Colors.black,
        pinTheme: PinTheme(
            fieldOuterPadding: EdgeInsets.symmetric(horizontal: 10),
            borderWidth: 2,
            selectedFillColor: Colors.grey.withOpacity(0.2),
            activeColor: primaryBlueColor,
            shape: PinCodeFieldShape.box,
            fieldHeight: 50,
            fieldWidth: 50,
            activeFillColor: Colors.transparent,
            inactiveFillColor: Colors.transparent,
            disabledColor: Colors.black,
            inactiveColor: Colors.grey,
            selectedColor: Colors.black),
        appContext: context,
        length: 4,
        onChanged: (String value) {},
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
          if (controller.enteredOTP.value == controller.receivedOTP.value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewPasswordPage()));
            print("correct otp");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              showSnackBar(
                'Incorrect OTP',
              ),
            );
          }
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            backgroundColor: MaterialStateProperty.all(primaryBlueColor)),
        child: Text(
          AppLocalizations.of(
            "Submit",
          ),
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _otpResendButton() {
    return Obx(
      () => TextButton(
        onPressed: () {
          if (controller.start.value == 0) {
            controller.resendOTP();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Didn't receive OTP?",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "  RESEND",
                        style: TextStyle(
                            fontSize: 14,
                            color: controller.start.value != 0
                                ? Colors.grey.shade500
                                : primaryBlueColor),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                controller.start.value < 10
                    ? "00:0" + controller.start.value.toString()
                    : "00:" + controller.start.value.toString(),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(OTPVerificationController());
    return WillPopScope(
      onWillPop: () async {
        Get.delete<OTPVerificationController>();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
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
              Get.delete<OTPVerificationController>();
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.dark,
          title: Text("OTP Verification",
              style: TextStyle(fontSize: 14.0.sp, color: Colors.black)),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              height: 100.0.h -
                  (56 + MediaQueryData.fromWindow(window).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _header(),
                      _otpField(context),
                    ],
                  ),
                  Column(
                    children: [_otpResendButton(), _submitButton(context)],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
