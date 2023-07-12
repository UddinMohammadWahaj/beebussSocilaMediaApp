import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utilities/colors.dart';

class CommonAppBarTitle extends GetView<PropertiesController> {
  final String? title;
  final String? buttonTitle;
  final VoidCallback? onTap;
  const CommonAppBarTitle({Key? key, this.title, this.buttonTitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Container(
      color: Colors.white,
      height: 56,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 0),
          splashRadius: 20,
          icon: Icon(
            Icons.close,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Container(
            child: Text(
          title!,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
        )),
        trailing: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            color: Colors.transparent,
            child: Text(
              buttonTitle!,
              style: TextStyle(
                  color: hotPropertiesThemeColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
