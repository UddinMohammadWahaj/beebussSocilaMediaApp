import 'dart:ui';

import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../Language/appLocalization.dart';

class InsightsView extends GetView<UserPropertiesController> {
  final String? id;
  InsightsView({Key? key, this.id}) : super(key: key);

  Widget _infoCard(String info) {
    return Text(
      info,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
    );
  }

  Widget _customInsightCard(String count, String value, String info) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: Colors.white,
      height: 50.0.h -
          0.75 -
          ((56 + MediaQueryData.fromWindow(window).padding.top) / 2),
      width: 50.0.w - 0.25,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoCard(""),
            Column(
              children: [
                Text(
                  count,
                  style: TextStyle(
                      fontSize: 15.0.sp,
                      fontWeight: FontWeight.w500,
                      color: hotPropertiesThemeColor),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info,
                  size: 18,
                  color: hotPropertiesThemeColor,
                ),
                SizedBox(width: 5),
                Container(width: 50.0.w - (55), child: _infoCard(info)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.dark,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of("Insights"),
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: controller.getInsights(this.id),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData) {
            print("-------- $id -- ${this.id}");
            return Center(
                child: CircularProgressIndicator(
              color: hotPropertiesThemeColor,
            ));
          } else if (snapshot.data == null)
            return Center(
                child: Text(AppLocalizations.of('No insights found')));
          return Container(
            decoration: new BoxDecoration(
              color: hotPropertiesThemeColor,
              shape: BoxShape.rectangle,
              border: Border(
                top: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _customInsightCard(
                        "${snapshot.data!['no_of_saved']}",
                        AppLocalizations.of("Saved"),
                        AppLocalizations.of(
                            "Number of times the property has been saved")),
                    _customInsightCard(
                        "${snapshot.data!['no_of_imp']}",
                        AppLocalizations.of("Impressions"),
                        AppLocalizations.of(
                            "How many times the property has been seen")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _customInsightCard(
                        "${snapshot.data!['no_of_click']}",
                        AppLocalizations.of("Clicks"),
                        AppLocalizations.of(
                            "How many times the property has been clicked on")),
                    _customInsightCard(
                        "${snapshot.data!['no_of_enquiry']}",
                        AppLocalizations.of("Enquiries"),
                        AppLocalizations.of(
                            "How many enquiries has been sent to the agent or landlord who advertised the property")),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
