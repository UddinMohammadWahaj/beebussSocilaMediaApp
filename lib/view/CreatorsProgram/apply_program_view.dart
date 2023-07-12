import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import 'creators_program_controller.dart';

class ApplyProgramView extends StatefulWidget {
  const ApplyProgramView({Key? key}) : super(key: key);

  @override
  State<ApplyProgramView> createState() => _ApplyProgramViewState();
}

class _ApplyProgramViewState extends State<ApplyProgramView> {
  CreatorsProgramController controller = Get.put(CreatorsProgramController());

  Widget _header() {
    return Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Text(
          AppLocalizations.of(
            "Become a Buzer: a content creator on Bebuzee",
          ),
          style: blackBold.copyWith(fontSize: 25, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ));
  }

  Widget _customTextField(
      TextEditingController textEditingController, String labelText) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                labelText,
                style: TextStyle(fontSize: 15, color: controller.textColor),
              )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            decoration: new BoxDecoration(
              color: controller.textBgColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle,
            ),
            child: TextFormField(
              cursorColor: controller.textColor,
              autofocus: false,
              controller: textEditingController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                // 48 -> icon width
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countryTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(
                "Country",
              ),
              style: TextStyle(fontSize: 15, color: controller.textColor),
            )),
        GestureDetector(
          onTap: () {
            Get.bottomSheet(_countryListBuilder(),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))));
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              decoration: new BoxDecoration(
                color: controller.textBgColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                shape: BoxShape.rectangle,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Container(
                      child: Text(
                        controller.selectedCountry.value,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: controller.textColor,
                  )
                ],
              )),
        ),
      ],
    );
  }

  Widget _actionButton() {
    return Obx(
      () => controller.isLoading.value
          ? controller.getProgressDialog()
          : GestureDetector(
              onTap: controller.onPressedApply(controller.statusCode.value),
              child: Container(
                width: 100.0.w,
                decoration: new BoxDecoration(
                  color: HexColor("#344853"),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Text(
                  controller
                      .applicationStatusMessage(controller.statusCode.value),
                  style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }

  Widget _countryCard(int index) {
    return Obx(
      () => ListTile(
        onTap: () {
          controller.selectCountry(index);
        },
        title: Text(
          controller.countryDataList[index]["name"].toString(),
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        trailing: controller.countryDataList[index]["selected"] != null
            ? Icon(
                Icons.check,
                color: Colors.black,
              )
            : null,
      ),
    );
  }

  Widget _countryListBuilder() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 6,
            width: 12.0.w,
            margin: EdgeInsets.symmetric(vertical: 15),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle,
              color: Colors.grey.shade300,
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.countryDataList.length,
              itemBuilder: (context, index) {
                return _countryCard(index);
              }),
        ],
      ),
    );
  }

  Widget _termsAndConditionsCard() {
    return Obx(
      () => controller.isLoading.value
          ? Container()
          : RichText(
              text: TextSpan(
                style: blackLight.copyWith(
                  fontSize: 10.0.sp,
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
                      fontSize: 10.0.sp,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.goToTerms(
                            context,
                            "Bebuzee Terms & Conditions",
                            "https://www.bebuzee.com/terms");
                      },
                  ),
                  TextSpan(
                    text: AppLocalizations.of(
                      ", which governs your use of Bebuzee, and that you have read our" +
                          " ",
                    ),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(
                      "Privacy Policy",
                    ),
                    style: blackLight.copyWith(
                      fontSize: 10.0.sp,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.goToTerms(context, "Bebuzee Privacy Policy",
                            "https://www.bebuzee.com/privacy-policy");
                      },
                  ),
                  TextSpan(
                    text: AppLocalizations.of(
                      ", including our" + " ",
                    ),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(
                      "Cookie policy",
                    ),
                    style: blackLight.copyWith(
                      fontSize: 10.0.sp,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.goToTerms(context, "Bebuzee Cookie Policy",
                            "https://www.bebuzee.com/cookie-policy");
                      },
                  ),
                  TextSpan(
                    text: " " +
                        AppLocalizations.of(
                          "and",
                        ) +
                        " ",
                  ),
                  TextSpan(
                    text: AppLocalizations.of(
                      "Community Guidelines",
                    ),
                    style: blackLight.copyWith(
                      fontSize: 10.0.sp,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.goToTerms(
                            context,
                            "Bebuzee's Community Guidelines",
                            "https://www.bebuzee.com/community-guidelines.html");
                      },
                  ),
                  TextSpan(
                    text: ".",
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void initState() {
    controller.getApplicationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              size: 25,
              color: Colors.black,
            ),
            splashRadius: 20,
            constraints: BoxConstraints(),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: 100.0.h - (statusBarHeight + 60),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _header(),
              _customTextField(
                controller.firstNameController,
                AppLocalizations.of("First Name"),
              ),
              _customTextField(
                controller.surnameController,
                AppLocalizations.of("Surname"),
              ),
              _customTextField(
                controller.emailController,
                AppLocalizations.of("Email Address"),
              ),
              _countryTile(),
              Spacer(),
              _termsAndConditionsCard(),
              _actionButton(),
            ],
          ),
        ),
      ),
    );
  }
}
