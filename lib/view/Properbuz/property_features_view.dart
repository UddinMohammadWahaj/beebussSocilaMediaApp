import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/floorplan_item.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/map_feature_item.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/photos_item.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/virtual_tour_feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Language/appLocalization.dart';

class PropertyFeaturesView extends GetView<PropertiesController> {
  final String? title;
  final int? val;
  final int? feature;
  final int? index;

  const PropertyFeaturesView(
      {Key? key, this.title, this.val, this.feature, this.index})
      : super(key: key);

  Widget _featureItem() {
    switch (feature) {
      case 2:
        return FloorPlanItemFeature(
          index: index!,
          val: val!,
        );
        break;
      case 3:
        return VirtualTourFeature(
          index: index!,
          val: val!,
        );
        break;
      case 4:
        return controller.properties(val!)[index!].video != "" &&
                controller.properties(val!)[index!].video != null
            ? WebView(
                initialUrl: controller.properties(val!)[index!].video,
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
              )
            : Center(
                child: Text("Video Not Available..!!"),
              );
        break;
      case 5:
        return MapFeatureItem(
          index: index!,
          val: val!,
        );
        break;
      default:
        return PhotosItemFeature(
          index: index!,
          val: val!,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
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
              Navigator.pop(context);
            },
          ),
          backgroundColor: hotPropertiesThemeColor,
          elevation: 0,
          title: Text(
            AppLocalizations.of(title!),
            style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
          ),
        ),
        body: _featureItem());
  }
}
