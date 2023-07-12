import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/services/User/otp_verification_controller.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../country_name.dart';

class PasswordResetController extends GetxController {
  TextEditingController emailController = TextEditingController();

  var country = "".obs;

  Future<void> getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    country.value = locationX["country"];
  }

  Future<void> resetPassword() async {
    OTPVerificationController controller = Get.put(OTPVerificationController());
    Get.dialog(ProcessingDialog(
      title: "Sending OTP",
      heading: "",
    ));
    var url = Uri.parse(
        "https://www.bebuzee.com/api/auth/forgotPassword?action=forgot_password_data&email=${emailController.text}");
    var response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      controller.receivedOTP.value = jsonDecode(response.body)['code'];
      controller.email.value = emailController.text;  
      Get.back();
      controller.start.value = 30;
      controller.startTimer();
    } else {
      Get.back();
    }
  }

  @override
  void onInit() {
    getCountry();
    super.onInit();
  }
}
