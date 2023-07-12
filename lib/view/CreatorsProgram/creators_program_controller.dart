import 'package:bizbultest/services/creators_program.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/CreatorsProgram/terms_and_condition_webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CreatorsProgramController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: CurrentUser().currentUser.email);
  var textColor = HexColor("#727a85");
  var textBgColor = HexColor("#f5f7f6");
  var statusCode = 5.obs;
  var isLoading = false.obs;
  var isUrlLoading = false.obs;
  var selectedCountry = "Select Country".obs;
  var selectedCountryValue = "0".obs;
  var countryDataList = [
    {"value": "1", "name": "Algeria", "selected": false},
    {"value": "2", "name": "Australia", "selected": false},
    {"value": "3", "name": "Cameroon", "selected": false},
    {"value": "4", "name": "Canada", "selected": false},
    {"value": "5", "name": "Egypt", "selected": false},
    {"value": "6", "name": "Ethiopia", "selected": false},
    {"value": "7", "name": "Ghana", "selected": false},
    {"value": "8", "name": "India", "selected": false},
    {"value": "9", "name": "Ireland", "selected": false},
    {"value": "10", "name": "Italy", "selected": false},
    {"value": "11", "name": "Kenya", "selected": false},
    {"value": "12", "name": "Liberia", "selected": false},
    {"value": "13", "name": "Morocco", "selected": false},
    {"value": "14", "name": "New Zealand", "selected": false},
    {"value": "15", "name": "Nigeria", "selected": false},
    {"value": "16", "name": "Philippines", "selected": false},
    {"value": "17", "name": "Rwanda", "selected": false},
    {"value": "18", "name": "South Africa", "selected": false},
    {"value": "19", "name": "Sudan", "selected": false},
    {"value": "20", "name": "Tanzania", "selected": false},
    {"value": "21", "name": "Uganda", "selected": false},
    {"value": "22", "name": "United Kingdom", "selected": false},
    {"value": "23", "name": "United States", "selected": false},
    {"value": "24", "name": "Zambia", "selected": false},
    {"value": "25", "name": "Zimbabwe", "selected": false}
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    print("ready");
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getApplicationStatus() async {
    try {
      isLoading(true);
      int status = await CreatorsProgramApi.getApplicationStatus();
      statusCode.value = status;
    } finally {
      isLoading(false);
    }
  }

  void applyToProgram() async {
    try {
      isLoading(true);
      int status = await CreatorsProgramApi.applyToProgram(
          firstNameController.text,
          surnameController.text,
          emailController.text,
          selectedCountryValue.value);
      statusCode.value = status;
    } finally {
      isLoading(false);
      showToast("Your application has been submitted");
    }
  }

  String applicationStatusMessage(int code) {
    switch (code) {
      case 1:
        return "Your application has already been approved";
      case 2:
        return "Your application is under review";
      case 3:
        return "Your application has been rejected";
      default:
        return "Apply Now";
    }
  }

  VoidCallback onPressedApply(int code) {
    print(code);
    switch (code) {
      case 1:
        return () => showToast("Your application has already been approved");
      case 2:
        return () => showToast("Your application is under review");
      case 3:
        return () => showToast("Your application has been rejected");
      default:
        return () => apply();
    }
  }

  getProgressDialog() {
    return new Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
        ),
        child: new Center(
            child: const CupertinoActivityIndicator(
          radius: 20,
        )));
  }

  void clearCountryList() {
    countryDataList.forEach((element) {
      if (element["selected"] != null) {
        element["selected"] = false;
      }
    });
  }

  void selectCountry(int index) {
    clearCountryList();
    selectedCountry.value = countryDataList[index]["name"].toString();
    selectedCountryValue.value = countryDataList[index]["value"].toString();
    countryDataList[index]["selected"] = true;
    Get.back();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey.shade600,
      textColor: Colors.white,
      fontSize: 15,
    );
  }

  bool validateFields() {
    if (selectedCountryValue.value == "0" ||
        firstNameController.text.isEmpty ||
        surnameController.text.isEmpty ||
        emailController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void apply() {
    if (validateFields()) {
      applyToProgram();
    } else {
      showToast("Please fill all the fields");
    }
  }

  void goToTerms(BuildContext context, String title, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TermsAndConditionsWebView(
                  title: title,
                  url: url,
                )));
  }
}
