import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/ManagePropertiesFeatures/manage_property_nearby.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_nearby.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ManagePropertyContentCard extends GetView<UserPropertiesController> {
  int index;
  int val;
  int padding;
  ManagePropertyContentCard(
      {Key? key, required this.index, required this.val, required this.padding})
      : super(key: key);

  Widget _tabCard(String value, var index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          value,
          style: TextStyle(
              fontSize: 9.0.sp,
              color: controller.managepropertyContentIndex.value == index
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
                value,
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
      children: list.map((e) => _customCheckBox(e)).toList(),
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
    print('new index =${controller.managepropertyContentIndex.value}');
    switch (controller.managepropertyContentIndex.value) {
      case 0:
        return Container(
          child: Html(
              // defaultTextStyle: TextStyle(
              //     fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 2),
              data:
                  '${controller.value(val)[index].propertydescription}\n ${controller.managepropertydetailslist[0].furnished == "Yes" ? "This property is Furnished" : "This property is not furnished"}'),

          // child: Text(
          //     '${controller.lstofpopularrealestatemodel[index].propertyDescription}\n ${controller.propertydetailslist[0].furnished == "Yes" ? "This property is Furnished" : "This property is not furnished"}'),
        );

      case 1:
        print("this case ${controller.managepropertyContentIndex.value}");
        return Container(
          child: Text(
              '${controller.managepropertydetailslist[0].propertyNeighbourhood ?? AppLocalizations.of("No Neighbourhood to show")}'),
        );
        break;
      case 2:
        // Navigator.of(Get.context).push(
        //     MaterialPageRoute(builder: (context) => PopularNearBy(index)));

        //Commented here
        print("this case ${controller.managepropertyContentIndex.value}");
        if (controller.value(val)[index].lat!.isEmpty &&
            controller.value(val)[index].long!.isEmpty)
          return Container(
            child: Center(
                child: Text(
              AppLocalizations.of('No data found for this property!!'),
              style: TextStyle(color: hotPropertiesThemeColor),
            )),
          );

        return GestureDetector(
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
                    initialUrl: controller.managepropertyfetchNearby(
                            controller.value(val)[index].lat!,
                            controller.value(val)[index].long!,
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
                          builder: (context) => ManagePropertyNearBy(
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
        );
        // return Container();
//  Container(
//           margin: EdgeInsets.all(10),
//           height: 500,
//           child:
//         );

        break;
      case 3:
        print("this case ${controller.managepropertyContentIndex.value}");
        return Container(
          color: Colors.white,
          child: _customCheckBoxListBuilder(controller.managepropertyfeatures1,
              controller.managepropertyfeatures2),
        );

        break;
      case 4:
        print("this case ${controller.managepropertyContentIndex.value}");
        if (controller.value(val)[index].lat!.isEmpty &&
            controller.value(val)[index].long!.isEmpty)
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
          child: Container(
              height: Get.size.height / 2,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  WebView(
                    gestureNavigationEnabled: true,
                    initialUrl: controller.managepropertyfetchStreetView(
                            controller.value(val)[index].lat!,
                            controller.value(val)[index].long!) ??
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
                          builder: (context) => ManagePropertyNearBy(
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
        );
        break;
      default:
        print("this case ${controller.managepropertyContentIndex.value}");
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
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
                selectionIndex: controller.managepropertyContentIndex.value,
                borderColor: hotPropertiesThemeColor,
                selectedColor: hotPropertiesThemeColor,
                unselectedColor: Colors.white,
                borderRadius: 5.0,
                onSegmentChosen: (int ind) async {
                  controller.changePropertyContentIndex(ind);

                  controller.fetchDetails(
                      controller.value(val)[this.index].propertyid);
                  print("index changed $ind");
                },
              ),
            ),

            // (controller.propertydetailslist.length != 0)
            //     ? FutureBuilder(
            //         future: controller.fetchDetails(controller
            //             .lstofpopularrealestatemodel[index].propertyId),
            //         builder: (context, snapshot) {
            //           if (snapshot != null)
            //             return _displayCard();
            //           else
            //             return Container();
            //         },
            //       )
            //     : Container()

            Obx(() => _displayCard()),
            SizedBox(
              height: 100,
            )
          ],
        ));
  }
}
