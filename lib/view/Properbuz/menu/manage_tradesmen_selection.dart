import 'dart:ui';

import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/custom_icons.dart';
import 'manage_company_tradesmen.dart';
import 'manage_tradesman_view.dart';

class ChoicePageView extends StatefulWidget {
  const ChoicePageView({Key? key}) : super(key: key);

  @override
  State<ChoicePageView> createState() => _ChoicePageViewState();
}

class _ChoicePageViewState extends State<ChoicePageView> {
  AddTradesmenController ctr = Get.put(AddTradesmenController());

  Widget _customAddListTile(
      String title, IconData icon, VoidCallback onTap, BorderStyle style) {
    final double statusBarHeight =
        MediaQueryData.fromWindow(window).padding.top;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100.0.w,
        height: (100.0.h - (56 + 55 + statusBarHeight)) / 5,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: HexColor("#f5f7f6"),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: settingsColor,
              width: 0.5,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: settingsColor,
                size: 50,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: settingsColor,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //  backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: appBarColor,
        brightness: Brightness.dark,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);

            Get.delete<AddTradesmenController>();
          },
        ),
        title: Text(
          AppLocalizations.of("Manage Data"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _customAddListTile(
              AppLocalizations.of("Manage") +
                  " " +
                  AppLocalizations.of("Tradesmen"),
              CustomIcons.customer,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageTradesmanView("0"),
                  )),
              BorderStyle.solid),
          _customAddListTile(
              AppLocalizations.of("Manage") +
                  " " +
                  AppLocalizations.of("Company"),
              CustomIcons.employee,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageCompanyTradesmenView(),
                  )),
              BorderStyle.solid),
        ],
      ),
    );
  }
}
