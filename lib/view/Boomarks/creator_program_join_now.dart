import 'dart:convert';
import 'dart:ffi';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:bizbultest/widgets/drop_down_button.dart';
import 'package:bizbultest/widgets/text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class CreatorsJoinNow extends StatefulWidget {
  const CreatorsJoinNow({Key? key}) : super(key: key);

  @override
  _CreatorsJoinNowState createState() => _CreatorsJoinNowState();
}

class _CreatorsJoinNowState extends State<CreatorsJoinNow> {
  var countryNameID = "0";

  var countryDataList = [
    {"value": "0", "name": "Select Country"},
    {"value": "1", "name": "Algeria"},
    {"value": "2", "name": "Australia"},
    {"value": "3", "name": "Cameroon"},
    {"value": "4", "name": "Canada"},
    {"value": "5", "name": "Egypt"},
    {"value": "6", "name": "Ethiopia"},
    {"value": "7", "name": "Ghana"},
    {"value": "8", "name": "India"},
    {"value": "9", "name": "Ireland"},
    {"value": "10", "name": "Italy"},
    {"value": "11", "name": "Kenya"},
    {"value": "12", "name": "Liberia"},
    {"value": "13", "name": "Morocco"},
    {"value": "14", "name": "New Zealand"},
    {"value": "15", "name": "Nigeria"},
    {"value": "16", "name": "Philippines"},
    {"value": "17", "name": "Rwanda"},
    {"value": "18", "name": "South Africa"},
    {"value": "19", "name": "Sudan"},
    {"value": "20", "name": "Tanzania"},
    {"value": "21", "name": "Uganda"},
    {"value": "22", "name": "United Kingdom"},
    {"value": "23", "name": "United States"},
    {"value": "24", "name": "Zambia"},
    {"value": "25", "name": "Zimbabwe"}
  ];

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email =
      TextEditingController(text: CurrentUser().currentUser.email);

  Future<String?> sendJoin() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_apply_creators_program.php");

    if (firstName.text.trim().isEmpty ||
        lastName.text.trim().isEmpty ||
        email.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "fill all fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      return null;
    }
    var sendData = {
      "user_id": CurrentUser().currentUser.memberID,
      "first_name": firstName.text,
      "last_name": lastName.text,
      "email": email.text,
      "country": countryNameID,
    };
    final response = await http.post(url, body: sendData);
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body != "") {
      print(response.body);
      print("text message");
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      _navigateToHome();
      return "Success";
    } else {
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return null;
    }
  }

  var statusCode = 0;

  Future<String?> checkCreatorsProgram() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_check_creators_program.php");

    var sendData = {
      "user_id": CurrentUser().currentUser.memberID,
    };
    try {
      final response = await http.post(url, body: sendData);
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body != "") {
        print(response.body);
        print("text message");
        var responseData = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: responseData["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 15.0,
        );
        setState(() {
          statusCode = responseData['success'];
        });
        // _navigateToHome();
        return "Success";
      } else {
        Fluttertoast.showToast(
          msg: jsonDecode(response.body)["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 15.0,
        );
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Some thing wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
  }

  @override
  void initState() {
    checkCreatorsProgram();
    super.initState();
  }

  void _navigateToHome() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => HomePage(
    //               hasMemberLoaded: true,
    //               currentMemberImage: CurrentUser().currentUser.image,
    //               memberID: CurrentUser().currentUser.memberID,
    //               country: CurrentUser().currentUser.country,
    //               logo: CurrentUser().currentUser.logo,
    //             )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlueColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(
                  "Become a Buzer: a content creator on Bebuzee",
                ),
                style: blackBold.copyWith(
                  fontSize: 16.0.sp,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: firstName,
                  focusNode: FocusNode(),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration.collapsed(
                    hintText: 'First name',
                    hintStyle: greyNormal,
                  ),
                  cursorColor: primaryBlackColor,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: lastName,
                  focusNode: FocusNode(),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Surname',
                    hintStyle: greyNormal,
                  ),
                  cursorColor: primaryBlackColor,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: email,
                  focusNode: FocusNode(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Email address',
                    hintStyle: greyNormal,
                  ),
                  cursorColor: primaryBlackColor,
                ),
              ),
              Container(
                width: double.infinity,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: DropdownButton<String>(
                    value: countryNameID,
                    icon: Icon(Icons.arrow_drop_down),
                    hint: Text("Country"),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(height: 0),
                    onChanged: (dynamic val) {
                      setState(() {
                        countryNameID = val;
                      });
                    },
                    items: countryDataList
                        .map<DropdownMenuItem<String>>((Map value) {
                      return DropdownMenuItem<String>(
                        value: value['value'],
                        child: Text(value['name']),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: blackLight.copyWith(
                    fontSize: 12.0.sp,
                    color: Colors.blueGrey,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(
                        "By clicking on the button below, you agree to Bebuzee",
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(
                        "Terms",
                      ),
                      style: blackLight.copyWith(
                        fontSize: 12.0.sp,
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Terms");
                        },
                    ),
                    TextSpan(
                      text: AppLocalizations.of(
                            ", which governs your use of Bebuzee, and that you have read our",
                          ) +
                          " ",
                    ),
                    TextSpan(
                      text: AppLocalizations.of(
                        "Privacy Policy",
                      ),
                      style: blackLight.copyWith(
                        fontSize: 12.0.sp,
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Privacy Policy");
                        },
                    ),
                    TextSpan(
                      text: AppLocalizations.of(
                        "including our" + " ",
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(
                        "Cookie policy",
                      ),
                      style: blackLight.copyWith(
                        fontSize: 12.0.sp,
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Cookie policy");
                        },
                    ),
                    TextSpan(
                      text: " and ",
                    ),
                    TextSpan(
                      text: AppLocalizations.of(
                        "Community Guidelines",
                      ),
                      style: blackLight.copyWith(
                        fontSize: 12.0.sp,
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Community Guidelines");
                        },
                    ),
                    TextSpan(
                      text: ".",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (statusCode == 0) sendJoin();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  child: Text(
                    "${getTextFromStatusCode(statusCode)}", //"Your application is being reviewed",
                    style: whiteNormal.copyWith(
                      fontSize: 12.0.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getTextFromStatusCode(int code) {
    switch (code) {
      case 1:
        return "Your application has already been approved";
      case 2:
        return "Your application is being reviewed";
      case 3:
        return "Your application is rejected";
      default:
        return "Apply Now";
    }
  }
}
