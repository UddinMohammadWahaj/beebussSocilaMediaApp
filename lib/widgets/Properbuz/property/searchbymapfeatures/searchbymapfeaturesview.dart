import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/popular_real_estate_market_map_view.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_floor_plan_feature.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_virtual_tour_feature.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_photo_item_feature.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/floorplan_item.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/map_feature_item.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/photos_item.dart';
import 'package:bizbultest/widgets/Properbuz/property/features/virtual_tour_feature.dart';
import 'package:bizbultest/widgets/Properbuz/property/searchbymapfeatures/searchbymapfloorplanitemfeature.dart';
import 'package:bizbultest/widgets/Properbuz/property/searchbymapfeatures/searchbymapmapfeatureitem.dart';
import 'package:bizbultest/widgets/Properbuz/property/searchbymapfeatures/searchbymapphotoitemfeature.dart';
import 'package:bizbultest/widgets/Properbuz/property/searchbymapfeatures/searchbymapvirtualtourfeature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../Language/appLocalization.dart';

class SearchByMapPropertyFeaturesView extends GetView<SearchByMapController> {
  final String? title;
  final int? val;
  final int? feature;
  final int? index;

  const SearchByMapPropertyFeaturesView(
      {Key? key, this.title, this.val, this.feature, this.index})
      : super(key: key);

  Widget _featureItem() {
    switch (feature) {
      case 2:
        return SearchByMapFloorPlanItemFeature(
          index: index!,
        );
        break;
      case 3:
        return SearchByMapVirtualTourFeature(
          index: index!,
          val: val!,
        );
        break;
      case 4:
        return controller.propertylist[index!]!.video != "" &&
                controller.propertylist[index!]!.video != null
            ? WebView(
                initialUrl: controller.propertylist[index!]!.video ?? "",
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
                child: Text(AppLocalizations.of("Video Not Available..!!")),
              );
        break;
      case 5:
        return SearchByMapMapFeatureItem(
          index: index!,
          val: val!,
        );
        break;
      default:
        return SearchByMapPhotosItemFeature(
          index: index!,
          val: val!,
        );
        break;
    }
  }

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
