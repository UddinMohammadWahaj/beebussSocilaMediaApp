import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagsCountryBottomSheet extends GetView<BuzzerfeedMainController> {
  String from;

  TagsCountryBottomSheet({Key? key, this.from = ""}) : super(key: key);

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListTile(
        onTap: () => Get.back(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        title: Text(
          AppLocalizations.of(
            "Trends",
          ),
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.close,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _countryCard(String country, VoidCallback tap) {
    return InkWell(
      onTap: () async {
        Get.back();

        print("country selected=$country");
        controller.country.value = country;
        controller.country.refresh();
        if (this.from == "main") {
          print("from main");
          controller.getTags();
        } else
          controller.fetchTrendingToday();
      },
      child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Text(
            country,
            style: TextStyle(fontSize: 15, color: hotPropertiesThemeColor),
          )),
    );
  }

  Widget _countryBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Obx(() => controller.countries.length == 0
          ? Container()
          : Wrap(
              spacing: 10,
              runSpacing: 10,
              direction: Axis.horizontal,
              children: controller.countries
                  .map((e) => _countryCard(e.toString(), () async {
                        controller.country.value = e.toString();
                        Get.back();
                      }))
                  .toList(),
            )),
    );
  }

  Widget _customButton(
      String value, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: new BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          child: Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: textColor, fontSize: 15),
          )),
    );
  }

  Widget _selectedCountryRow() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            AppLocalizations.of(
              "Your current location:",
            ),
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
          Obx(
            () => _customButton(controller.country.value, Colors.white,
                hotPropertiesThemeColor, () {}),
          ),
          _customButton(
              AppLocalizations.of(
                "Close",
              ),
              hotPropertiesThemeColor,
              Colors.grey.shade200, () {
            Get.back();
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(Buzz());
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_header(), _countryBuilder(), _selectedCountryRow()],
      ),
    );
  }
}
