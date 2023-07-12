import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PropertyAdviserCard extends GetView<PropertiesController> {
  final int index;
  final int val;
  const PropertyAdviserCard({
    Key? key,
    required this.index,
    required this.val,
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
              AppLocalizations.of(value),
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
            AppLocalizations.of(title),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            AppLocalizations.of(subtitle),
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
                    "tel:${controller.properties(val)[index].memberContactNo}"),
                15),
            _contactButton(
                Icons.email,
                AppLocalizations.of(
                  "CONTACT",
                ),
                () => controller
                    .emailAgent(controller.properties(val)[index].memberEmail!),
                15),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
        width: 100.0.w - 30,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          AppLocalizations.of(
            "Advertiser",
          ),
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
              fontSize: 18),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
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
            AppLocalizations.of("Estate") + " " + AppLocalizations.of("Agent"),

            AppLocalizations.of(
                controller.properties(val)[index].memberName!.isEmpty
                    ? "Estate Agent Name"
                    : controller.properties(val)[index].memberName!),

            // controller.properties(val)[index].memberName.isEmpty
            //     ? AppLocalizations.of("Estate Agent Name")
            //     : AppLocalizations.of(
            //         controller.properties(val)[index].memberName),

          ),
          _divider(),
          _customInfoCard(
            AppLocalizations.of("Estate") +
                " " +
                AppLocalizations.of("Agent") +
                " " +
                AppLocalizations.of("Location"),
            AppLocalizations.of(
              controller.properties(val)[index].memberLocation!.isEmpty
                  ? AppLocalizations.of("Not") +
                      " " +
                      AppLocalizations.of("Found")
                  : controller.properties(val)[index].memberLocation!,
            ),
          ),
          _contactAdvertiserRow()
        ],
      ),
    );
  }
}
