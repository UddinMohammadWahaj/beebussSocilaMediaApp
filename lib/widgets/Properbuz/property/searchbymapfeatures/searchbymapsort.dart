import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../Language/appLocalization.dart';

enum SortType {
  featured,
  latest,
  maxprice,
  minprice,
  maxarea,
  minarea,
  minrooms,
  maxrooms,
}

class SearchByMapSortPropertyBottomSheet
    extends GetView<SearchByMapController> {
  String from = '';
  SearchByMapSortPropertyBottomSheet({Key? key, this.from = ''})
      : super(key: key);

  Widget _settingsCard(String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: 50.0.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                icon,
                size: 25,
                color: hotPropertiesThemeColor,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 16,
                  color: hotPropertiesThemeColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortItem(String name, int index) {
    return ListTile(
      tileColor: controller.selectedIndex.value == index
          ? hotPropertiesThemeColor
          : Colors.white,
      // contentPadding: EdgeInsets.symmetric(horizontal: 15),
      onTap: () {
        print("name=${name}");
        controller.selectedIndex.value = index;
        // Get.back();
        switch (name) {
          case "Latest":
            controller.currentColType.value = "latest";
            controller.currentOrder.value = "";
            break;
          case "Featured":
            controller.currentColType.value = "featured";
            controller.currentOrder.value = "";
            break;
          case "Max price":
            controller.currentColType.value = "price";
            controller.currentOrder.value = "desc";
            print("MAx price");

            break;
          case "Min price":
            controller.currentColType.value = "price";
            controller.currentOrder.value = "asc";
            print("Min price");
            break;
          case "Min Area":
            controller.currentColType.value = "sqft";
            controller.currentOrder.value = "asc";
            break;
          case "Max Area":
            controller.currentColType.value = "sqft";
            controller.currentOrder.value = "desc";
            break;

          default:
            print("nothing");
            break;
        }
      },
      title: Text(
        AppLocalizations.of(name),
        style: TextStyle(
            fontSize: 16,
            color: controller.selectedIndex.value == index
                ? Colors.white
                : settingsColor,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _settingsCard(AppLocalizations.of("Cancel"), Icons.cancel_outlined,
                () {
              controller.currentColType.value = "latest";
              controller.currentOrder.value = "";
              controller.selectedIndex.value = -1;
              Get.back();
              controller.searchFilter(
                  coltype: controller.currentColType.value,
                  order: controller.currentOrder.value,
                  from: from);
            }),
            _settingsCard(AppLocalizations.of("Done"), Icons.done_rounded,
                () async {
              Get.back();
              controller.searchFilter(
                  coltype: controller.currentColType.value,
                  order: controller.currentOrder.value,
                  from: from);
            }),
          ],
        ),
        Divider(
          thickness: 2,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.898,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.sortList.length,
              itemBuilder: (context, index) {
                return Obx(() =>
                    _sortItem(controller.sortList[index].toString(), index));
              }),
        ),
      ],
    );
  }
}
