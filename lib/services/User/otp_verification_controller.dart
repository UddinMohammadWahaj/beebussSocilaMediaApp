import 'dart:async';

import 'package:bizbultest/services/User/password_reset_controller.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OTPVerificationController extends GetxController {
  var receivedOTP = "".obs;
  var enteredOTP = "".obs;
  var start = 30.obs;
  var email = "".obs;
  Timer? timer;
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    confirmPassword.dispose();
    newPassword.dispose();
    super.onClose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start.value != 0) {
        start.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendOTP() {
    PasswordResetController controller = Get.put(PasswordResetController());
    controller.resetPassword();
  }

  String? errorText() {
    if (newPassword.text.isEmpty) {
      return "Please enter the new password";
    } else if (confirmPassword.text.isEmpty) {
      return "Please confirm the password";
    } else if (newPassword.text != confirmPassword.text) {
      return "Passwords do not match";
    } else if (newPassword.text.length < 8) {
      return "Password should contain minimum 8 characters";
    } else {
      return null;
    }
  }

  Future<void> updatePassword(BuildContext context) async {
    Get.dialog(ProcessingDialog(
      title: "Updating",
      heading: "",
    ));
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=update_password&email=${email.value}&code=${receivedOTP.value}&password=${newPassword.text}");
    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar(
          'Password reset successfully',
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
      Get.delete<OTPVerificationController>();
      Get.delete<PasswordResetController>();
    } else {
      Get.back();
    }
  }
}
