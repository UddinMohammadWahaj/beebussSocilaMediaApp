import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/popularrealestatemarketview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

class LocationCategories extends GetView<ProperbuzController> {
  LocationCategories({Key? key}) : super(key: key);

  Widget _locationsListBuilder() {
    print("oye here ${controller.lstPopularRealEstateMarketSaved.length}");
    if (controller.lstPopularRealEstateMarketSaved.length > 0) {
      print("list print ${controller.lstPopularRealEstateMarketSaved.length}");
      print(
          "list first name= ${controller.lstPopularRealEstateMarketSaved[0].name}");
    }
    if (controller.lstPopularRealEstateMarketSaved.length > 0)
      print(
          "oye here ${controller.lstPopularRealEstateMarketSaved[0].country} ${controller.lstPopularRealEstateMarketSaved[0].name}");

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.lstPopularRealEstateMarketSaved
            .map((e) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      print("clicked ${e.name}");
                      Navigator.of(Get.context!).push(MaterialPageRoute(
                        builder: (context) =>
                            GeneralPopularRealEstateMarketView(
                                e.country!, e.name!),
                      ));
                    },
                    child: Text(
                      "•  " + AppLocalizations.of(e.name!),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  bool loader = false;
  Widget _categoryCard(int index) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.0.w - 30,
            decoration: new BoxDecoration(
              color: HexColor("#f5f7f6"),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle,
            ),
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              visualDensity: VisualDensity(horizontal: -4),
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                print(
                    "----- 4411 ${controller.lstPopularRealEstateMarketSaved}");
                controller.popularRealLoader.value = true;
                controller.lstPopularRealEstateMarketSaved.isEmpty
                    ? await controller.fetchData()
                    : null;
                controller.popularRealLoader.value = false;
                print("----- 44 ${controller.lstPopularRealEstateMarketSaved}");

                controller.locationExpandedStatus[index].value =
                    !controller.locationExpandedStatus[index].value;
              },
              title: Text(
                controller.locationCategoryList[index]["value"],
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Obx(
                () => controller.popularRealLoader.isTrue
                    ? CircularProgressIndicator(
                        color: hotPropertiesThemeColor,
                      )
                    : Icon(
                        controller.locationExpandedStatus[index].value
                            ? Icons.arrow_drop_up_sharp
                            : Icons.arrow_drop_down_sharp,
                        size: 20,
                        color: properbuzBlueColor,
                      ),
              ),
            ),
          ),
          controller.locationExpandedStatus[index].value
              ? _locationsListBuilder()
              : Container()
        ],
      ),
    );
  }

  Widget _categoryList(BuildContext context) {
    return Obx(
      () => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.locationCategoryList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _categoryCard(index);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzController());
    return _categoryList(context);
  }
}
