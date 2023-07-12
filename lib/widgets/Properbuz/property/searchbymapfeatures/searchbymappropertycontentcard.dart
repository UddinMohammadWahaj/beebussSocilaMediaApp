import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_nearby.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'searchbymap_nearby_market.dart';

class SearchByMapPropertyContentCard extends GetView<SearchByMapController> {
  int index;
  SearchByMapPropertyContentCard({Key? key, required this.index})
      : super(key: key);

  Widget _tabCard(String value, var index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          value,
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

  _displayCard() {
    switch (controller.propertyContentIndex.value) {
      case 0:
        return Container(
          child: Html(
              // defaultTextStyle: TextStyle(
              //     fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 2),
              data: AppLocalizations.of(
                  '${controller.propertylist[index]!.propertyDescription}\n ${controller.propertydetailslist[0].furnished == "Yes" ? "This property is Furnished" : "This property is not furnished"}')),

          // child: Text(
          //     '${controller.lstofpopularrealestatemodel[index].propertyDescription}\n ${controller.propertydetailslist[0].furnished == "Yes" ? "This property is Furnished" : "This property is not furnished"}'),
        );

      case 1:
        return Container(
          child: Text(AppLocalizations.of(
              '${controller.propertydetailslist[0].propertyNeighbourhood ?? "No Neighbourhood to show"}')),
        );
        break;
      case 2:
        // Navigator.of(Get.context).push(
        //     MaterialPageRoute(builder: (context) => PopularNearBy(index)));
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
                      initialUrl: controller.fetchNearby(
                              controller.propertylist[index]!.lat!,
                              controller.propertylist[index]!.long!,
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
                            builder: (context) => SearchMapNearBy(index, 1)));
                      },
                      icon: Icon(
                        Icons.fullscreen,
                        color: Colors.black,
                        size: 20,
                      ),
                    ))
                  ],
                )),
          ),
        );
//  Container(
//           margin: EdgeInsets.all(10),
//           height: 500,
//           child:
//         );

        break;
      case 3:
        return Container(
          color: Colors.white,
          child: _customCheckBoxListBuilder(
              controller.features1, controller.features2),
        );

        break;
      case 4:
        print("case 4");
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
                    initialUrl: controller.fetchStreetView(
                            controller.propertylist[index]!.lat!,
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
                  Positioned(
                      child: IconButton(
                    onPressed: () {
                      Navigator.of(Get.context!).push(MaterialPageRoute(
                          builder: (context) => SearchMapNearBy(index, 2)));
                    },
                    icon: Icon(
                      Icons.fullscreen,
                      color: Colors.black,
                      size: 20,
                    ),
                  ))
                ],
              )),
        );
        break;
      default:
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
                selectionIndex: controller.propertyContentIndex.value,
                borderColor: hotPropertiesThemeColor,
                selectedColor: hotPropertiesThemeColor,
                unselectedColor: Colors.white,
                borderRadius: 5.0,
                onSegmentChosen: (int ind) async {
                  controller.changePropertyContentIndex(ind);

                  // controller.fetchDetails(controller.lstofpopularrealestatemodel
                  //     .value[this.index].propertyId);
                  print("index changed");
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

            _displayCard()
          ],
        ));
  }
}
