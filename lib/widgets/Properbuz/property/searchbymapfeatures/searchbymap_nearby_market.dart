import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../../Language/appLocalization.dart';

class SearchMapNearBy extends GetView<SearchByMapController> {
  int index;
  int type;
  SearchMapNearBy(this.index, this.type);
  @override
  Widget build(BuildContext context) {
    Get.put(SearchByMapController());
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
      body: WebView(
        gestureNavigationEnabled: true,
        initialUrl: (this.type == 1)
            ? controller.fetchNearby(controller.propertylist[index]!.lat!,
                    controller.propertylist[index]!.long!, "school") ??
                ""
            : controller.fetchStreetView(controller.propertylist[index]!.lat!,
                    controller.propertylist[index]!.long!) ??
                "",
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
      ),
    );
  }
}
