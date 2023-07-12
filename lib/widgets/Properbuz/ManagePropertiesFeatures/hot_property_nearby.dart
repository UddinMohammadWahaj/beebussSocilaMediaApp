import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';

import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

class PropertyNearBy extends GetView<PropertiesController> {
  int index;
  int type;
  int value;
  PropertyNearBy(
      {required this.index, required this.type, required this.value});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.white,
          onPressed: () {
            print("clicked");
            Navigator.pop(Get.context!);
          },
        ),
        backgroundColor: hotPropertiesThemeColor,
        elevation: 0,
        title: Text(
          (this.type == 1)
              ? AppLocalizations.of("Nearby")
              : AppLocalizations.of("Street View"),
          style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
        ),
      ),
      body: Obx(
        () => WebView(
          gestureNavigationEnabled: true,
          initialUrl: (this.type == 1)
              ? controller.propertyfetchNearby(
                      controller.properties(value)[index].latitude!,
                      controller.properties(value)[index].longitude!,
                      "school") ??
                  ""
              : controller.propertyfetchStreetView(
                      controller.properties(value)[index].latitude!,
                      controller.properties(value)[index].longitude!) ??
                  "",
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (String url) {
            print('-----Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('-----Page finished loading: $url');
          },
          onProgress: (int progress) {
            print("------WebView is loading (progress : $progress%)");
          },
        ),
      ),
    );
  }
}
