import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_overview_model.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/utilities/colors.dart';

import 'package:flutter_html/flutter_html.dart';

import 'package:hexcolor/hexcolor.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_infotab.dart';
import 'package:bizbultest/models/Properbuz/hot_properties_model.dart';

import '../ManagePropertiesFeatures/hot_property_nearby.dart';

class PropertyContentCard extends GetView<PropertiesController> {
  int index;
  int val;

  PropertyContentCard({Key? key, required this.index, required this.val})
      : super(key: key);

  Widget _tabCard(String value, var index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          AppLocalizations.of(value),
          style: TextStyle(
              fontSize: 9.0.sp,
              color: controller.propertyContentIndex.value == index
                  ? Colors.white
                  : hotPropertiesThemeColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ));
  }

  Widget _customCheckBox(String value) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        color: Colors.transparent,
        width: 50.0.w - 20,
        child: Row(
          children: [
            Icon(
              Icons.done_all,
              color: hotPropertiesThemeColor,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                AppLocalizations.of(value),
                style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkBoxListBuilder(List<String> list) {
    return Column(
      children:
          list.map((e) => _customCheckBox(AppLocalizations.of(e))).toList(),
    );
  }

  Widget _customCheckBoxListBuilder(List<String> list1, List<String> list2) {
    return Container(
      decoration: new BoxDecoration(
        color: HexColor("#f5f7f6"),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _checkBoxListBuilder(list1),
          _checkBoxListBuilder(list2),
        ],
      ),
    );
  }

  Widget _displayCard() {
    print('new index =${controller.propertyContentIndex.value}');
    switch (controller.propertyContentIndex.value) {
      case 0:
        return Container(
          child: Html(
              // defaultTextStyle: TextStyle(
              //     fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 2),
              data: AppLocalizations.of(
                  "${controller.properties(val)[index].propertyDescription} \n ${controller.propertydetailslist.length > 0 ? controller.propertydetailslist[0].furnished : "" == "Yes" ? "This property is Furnished" : "This property is not furnished"}")),

          // child: Text(
          //     '${controller.lstofpopularrealestatemodel[index].propertyDescription}\n ${controller.propertydetailslist[0].furnished == "Yes" ? "This property is Furnished" : "This property is not furnished"}'),
        );

      case 1:
        print("this case ${controller.propertyContentIndex.value}");
        return Container(
          child: Text(
              // "${controller.properties(val)[index].}"),
              // '${controller.propertydetailslist[0].propertyNeighbourhood ?? "No Neighbourhood to show--"}'),
              AppLocalizations.of(
                  '${controller.propertydetailslist.length > 0 ? controller.propertydetailslist[0].propertyNeighbourhood : "No Neighbourhood to show" ?? "No Neighbourhood to show"}')),
        );
        break;
      case 2:
        // Navigator.of(Get.context).push(
        //     MaterialPageRoute(builder: (context) => PopularNearBy(index)));

        //Commented here
        print("this case ${controller.propertyContentIndex.value}");
        if (controller.properties(val)[index].latitude == null &&
            controller.properties(val)[index].longitude == null)
          return Container(
            child: Center(
                child: Text(
              AppLocalizations.of('No data found for this property!!'),
              style: TextStyle(color: Colors.black),
            )),
          );

        return GestureDetector(
          onTap: () {
            print("tapped on map");
          },
          child: Obx(
            () => Container(
                height: Get.size.height / 2,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    WebView(
                      gestureNavigationEnabled: true,
                      initialUrl: controller.propertyfetchNearby(
                              controller.properties(val)[index].latitude!,
                              controller.properties(val)[index].longitude!,
                              "school") ??
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
                    Positioned(
                        child: IconButton(
                      onPressed: () {
                        Navigator.of(Get.context!).push(MaterialPageRoute(
                            builder: (context) => PropertyNearBy(
                                index: index, type: 1, value: val)));
                      },
                      icon: Icon(
                        Icons.fullscreen,
                        color: Colors.black,
                        size: 25,
                      ),
                    ))
                  ],
                )),
          ),
        );
        // return Container();
//  Container(
//           margin: EdgeInsets.all(10),
//           height: 500,
//           child:
//         );

        break;
      case 3:
        print("this case ${controller.propertyContentIndex.value}");
        return Container(
          color: Colors.white,
          child: _customCheckBoxListBuilder(
              controller.features1, controller.features2),
        );

        break;
      case 4:
        print("this case ${controller.propertyContentIndex.value}");
        if (controller.properties(val)[index].latitude == null &&
            controller.properties(val)[index].longitude == null)
          return Container(
            child: Center(
                child: Text(
              AppLocalizations.of('No data found for this property!!'),
              style: TextStyle(color: Colors.black),
            )),
          );

        return Obx(
          () => GestureDetector(
            onTap: () {
              print("tapped on map");
            },
            child: Container(
                height: Get.size.height / 2,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    WebView(
                      gestureNavigationEnabled: true,
                      initialUrl: controller.propertyfetchStreetView(
                              controller.properties(val)[index].latitude!,
                              controller.properties(val)[index].longitude!) ??
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
                    Positioned(
                        child: IconButton(
                      onPressed: () {
                        Navigator.of(Get.context!).push(MaterialPageRoute(
                            builder: (context) => PropertyNearBy(
                                  index: index,
                                  type: 2,
                                  value: val,
                                )));
                      },
                      icon: Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 20,
                      ),
                    ))
                  ],
                )),
          ),
        );
        break;
      default:
        print("this case ${controller.propertyContentIndex.value}");
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Obx(
      () => Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: MaterialSegmentedControl(
              horizontalPadding: EdgeInsets.symmetric(horizontal: 15),
              children: {
                0: _tabCard(
                    AppLocalizations.of(
                      "Overviews",
                    ),
                    0),
                1: _tabCard(
                    AppLocalizations.of(
                      "Neighbourhood",
                    ),
                    1),
                2: _tabCard(
                    AppLocalizations.of(
                      "Nearby",
                    ),
                    2),
                3: _tabCard(
                    AppLocalizations.of(
                      "Features",
                    ),
                    3),
                4: _tabCard(
                    AppLocalizations.of(
                      "Street View",
                    ),
                    4),
              },
              selectionIndex: controller.propertyContentIndex.value,
              borderColor: hotPropertiesThemeColor,
              selectedColor: hotPropertiesThemeColor,
              unselectedColor: Colors.white,
              borderRadius: 1,
              onSegmentChosen: (int index) {
                controller.changePropertyContentIndex(index);
              },
            ),
          ),
          Obx(() => _displayCard())
        ],
      ),
    );
  }
}
