import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ContactsStackRow extends GetView<PropertiesController> {
  final int val;
  final int index;

  const ContactsStackRow({
    Key? key,
    required this.val,
    required this.index,
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

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Positioned.fill(
      bottom: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Obx(
          () => Container(
            child: !controller.isContactVisible.value
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _contactButton(
                          Icons.call,
                          AppLocalizations.of(
                            "CALL",
                          ),
                          () => controller.callAgent(
                              "tel:${controller.properties(val)[index].memberContactNo}"),
                          0),
                      _contactButton(
                          Icons.email,
                          AppLocalizations.of(
                            "CONTACT",
                          ),
                          () => controller.emailAgent(
                              controller.properties(val)[index].memberEmail!),
                          0),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
