import 'package:bizbultest/services/Properbuz/upload_xml_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/onboarding/signup_page1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

class UploadXMLView extends GetView<UploadXMLController> {
  const UploadXMLView({Key? key}) : super(key: key);

  Widget _customHeaderCard(String header, double fontSize, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        header,
        style: TextStyle(
            color: color, fontSize: fontSize, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _customTextCard(String header, double fontSize, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        header,
        style: TextStyle(
            color: color, fontSize: fontSize, fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _selectionCard(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
          height: 100,
          width: 100.0.w - 20,
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CustomIcons.xml,
                  color: Colors.grey.shade700,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
              ],
            ),
          )),
    );
  }

  Widget _registerListTile(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Register as an Estate agent to send xml");
        showModalBottomSheet<void>(
          // context and builder are
          // required properties in this widget
          context: context,
          builder: (BuildContext context) {
            // we set up a container inside which
            // we create center column and display text
            return GetBuilder<UploadXMLController>(builder: (con) {
              return Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RadioListTile(
                      activeColor: hotPropertiesThemeColor,
                      value: 1,
                      groupValue: con.val,
                      onChanged: (dynamic value) {
                        con.val = value;
                        con.update();
                      },
                      title: Text(AppLocalizations.of("User")),
                      toggleable: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile(
                      activeColor: hotPropertiesThemeColor,
                      value: 3,
                      groupValue: con.val,
                      onChanged: (dynamic value) {
                        con.val = value;
                        con.update();
                      },
                      title: Text(AppLocalizations.of("Estate") +
                          " " +
                          AppLocalizations.of("Agent")),
                      toggleable: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    InkWell(
                      onTap: () {
                        if (CurrentUser().currentUser.memberType != con.val) {
                          // if (con.val == 3) {
                          logout();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage1()),
                              (_) => false);
                          // }
                        } else {
                          if (con.val == 3) {
                            customToastBlack(
                                AppLocalizations.of(
                                    "You are already a Estate Agent"),
                                14.0,
                                ToastGravity.CENTER);
                          } else {
                            customToastBlack(
                                AppLocalizations.of("You are already a User"),
                                14.0,
                                ToastGravity.CENTER);
                          }
                        }
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            shape: BoxShape.rectangle,
                            color: hotPropertiesThemeColor),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: _customTextCard(
                                AppLocalizations.of("Change"),
                                18,
                                Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
          },
        );
      },
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            color: hotPropertiesThemeColor),
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: _customTextCard(
              AppLocalizations.of("Register as an Estate agent to send xml"),
              15,
              Colors.white),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("memberID");
    await pref.clear();
  }

  Future<void> showSuccess(context) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        AppLocalizations.of("Uploaded XML Successfully"),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      ),
      duration: Duration(seconds: 2),
    ));
    Navigator.of(context).pop();
    Get.delete<UploadXMLController>();
  }

  Future<void> showFail() async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        AppLocalizations.of("Xml Upload Unsuccessfull!!"),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.error,
        color: Colors.red,
      ),
      duration: Duration(seconds: 2),
    ));
  }

  Future<Widget> showLoading(context) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of("Uploading the xml!!")),
              content: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UploadXMLController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: hotPropertiesThemeColor,
        brightness: Brightness.dark,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.white,
          onPressed: () async {
            Navigator.of(context).pop();
            Get.delete<UploadXMLController>();
          },
        ),
        title: Text(
          AppLocalizations.of("Upload XML"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Obx(
        () => Container(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customHeaderCard(
                  AppLocalizations.of(
                      "Uploading your property XML is the fastest way to get your properties listed on Properbuz."),
                  18,
                  Colors.grey.shade800),
              _customHeaderCard(
                  AppLocalizations.of(
                      "Let your properties be seen by millions of home buyers and renters."),
                  15,
                  Colors.grey.shade500),
              (controller.isUploading.isFalse)
                  ? _selectionCard(AppLocalizations.of("Select a XML File"),
                      () async {
                      // await controller.pickXml();
                      print(
                          "------- 22222 ${CurrentUser().currentUser.memberType}");
                      // if (CurrentUser().currentUser.memberType == 3) {
                      await controller.pickAFile(
                          context, showSuccess, showFail);
                      // }
                    })
                  : Center(
                      child: AlertDialog(
                      title: Text(
                          AppLocalizations.of('Xml File is being uploaded!!')),
                      elevation: 10,
                      contentPadding: EdgeInsets.all(10),
                      content: FittedBox(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator())),
                    )),
              _customTextCard(
                  AppLocalizations.of("**We accept all XML formats."),
                  14,
                  hotPropertiesThemeColor),
              Spacer(),
              _registerListTile(context)
            ],
          ),
        ),
      ),
    );
  }
}
