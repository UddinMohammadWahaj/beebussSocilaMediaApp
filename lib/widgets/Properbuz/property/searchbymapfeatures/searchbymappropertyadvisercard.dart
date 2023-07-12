import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../utilities/colors.dart';

class SearchByMapPropertyAdviserCard extends GetView<SearchByMapController> {
  final int index;
  final int? val;
  const SearchByMapPropertyAdviserCard({
    Key? key,
    required this.index,
    this.val,
  }) : super(key: key);

  Widget _contactButton(
      IconData icon, String value, VoidCallback onTap, double padding) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.0.w - padding,
        height: 55,
        color: Colors.red.shade800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                )),
            Text(
              value,
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageIconCard() {
    return Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: Colors.grey.shade800,
            width: 0.5,
          ),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 15),
        child: Icon(
          CustomIcons.businessman,
          size: 50,
        ));
  }

  Widget _divider() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Divider(
        thickness: 0.5,
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget _customInfoCard(String title, String subtitle) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _contactAdvertiserRow() {
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0) {
          controller.isContactVisible.value = true;
          print("visible");
        } else {
          controller.isContactVisible.value = false;
          print("not visible");
        }
      },
      key: ObjectKey(controller.visibilityKey),
      child: Container(
        margin: EdgeInsets.only(bottom: 15, top: 30),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _contactButton(
                Icons.call,
                AppLocalizations.of(
                  "CALL",
                ),
                () => controller.callAgent(
                    "tel:${controller.propertylist[index]!.memberContactNo}"),
                15),
            _contactButton(
                Icons.email,
                AppLocalizations.of(
                  "CONTACT",
                ),
                () => controller
                    .emailAgent(controller.propertylist[index]!.memberEmail!),
                15),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
        // color: settingsColor,
        width: 100.0.w - 30,
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(
                "Advertiser",
              ),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                  fontSize: 18),
            ),
            Obx(() => controller.propertylist[index]!.agentId !=
                    CurrentUser().currentUser.memberID
                ? followView()
                : Container()),
          ],
        ));
  }

  Widget followView() {
    return FittedBox(
      alignment: Alignment.center,
      child: TextButton.icon(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: hotPropertiesThemeColor))),
            // foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor:
                controller.propertylist[index]!.followStatus!.value == 1 ||
                        controller.propertylist[index]!.followStatus!.value == 4
                    ? MaterialStateProperty.all(hotPropertiesThemeColor)
                    : MaterialStateProperty.all(Colors.white)),
        onPressed: () {
          controller.followTheAgent(
              controller.propertylist[index]!.agentId!, index);
        },
        icon: (controller.propertylist[index]!.followStatus!.value == 1 ||
                controller.propertylist[index]!.followStatus!.value == 4)
            ? Icon(
                Icons.person,
                color: Colors.white,
              )
            : Icon(Icons.person_add_alt, color: hotPropertiesThemeColor),
        label: (controller.propertylist[index]!.followStatus!.value == 1)
            ? Text(
                AppLocalizations.of("Following"),
                style: TextStyle(color: Colors.white),
              )
            : (controller.propertylist[index]!.followStatus!.value == 2)
                ? Text(
                    AppLocalizations.of("Requested"),
                    style: TextStyle(color: hotPropertiesThemeColor),
                  )
                : (controller.propertylist[index]!.followStatus!.value == 4)
                    ? Text(
                        AppLocalizations.of("Followed"),
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        AppLocalizations.of("Follow"),
                        style: TextStyle(color: hotPropertiesThemeColor),
                      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          top: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          _header(),
          _imageIconCard(),
          _customInfoCard(
            AppLocalizations.of(
              "Agent",
            ),
            AppLocalizations.of(
                controller.propertylist[index]!.memberFirstname!.isEmpty
                    ? AppLocalizations.of("Agent Name")
                    : AppLocalizations.of(
                        controller.propertylist[index]!.memberFirstname!)),
          ),
          _divider(),
          _customInfoCard(
            AppLocalizations.of("Agent") +
                " " +
                AppLocalizations.of("Location"),
            AppLocalizations.of("Not found"),
          ),
          _contactAdvertiserRow()
        ],
      ),
    );
  }
}
