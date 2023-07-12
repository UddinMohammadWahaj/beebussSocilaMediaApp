import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Properbuz/add_property_list_model.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';

import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/property/common_appbar_title.dart';
import 'package:bizbultest/widgets/Properbuz/utils/popularenum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import '/widgets/Properbuz/utils/popularenum.dart';

class SearchByMapFilterPropertyBottomSheet
    extends GetView<SearchByMapController> {
  String from = "";
  SearchByMapFilterPropertyBottomSheet({Key? key, this.from = ''})
      : super(key: key);

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ));
  }

  Future customBarBottomSheetPriceList(
      double h, String title, dataList, Price type) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of("Select") +
                    " " +
                    AppLocalizations.of(title)),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          if (type == Price.max) {
                            controller.currentMaxPriceIndex.value = index;
                            controller.currentMaxPrice.value =
                                dataList[index].toString();
                          } else {
                            controller.currentMinPriceIndex.value = index;
                            controller.currentMinPrice.value =
                                dataList[index].toString();
                          }

                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index].toString()),
                          style: TextStyle(
                              color: ((type == Price.max)
                                      ? index ==
                                          controller.currentMaxPriceIndex.value
                                      : index ==
                                          controller.currentMinPriceIndex.value)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor: ((type == Price.max)
                                ? index == controller.currentMaxPriceIndex.value
                                : index ==
                                    controller.currentMinPriceIndex.value)
                            ? hotPropertiesThemeColor
                            : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Future customBarBottomSheetBedroomList(
      double h, String title, dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of("Select") +
                    " " +
                    AppLocalizations.of(title)),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          controller.currentBedroomIndex.value = index;
                          controller.currentBedroom.value = dataList[index];
                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index]),
                          style: TextStyle(
                              color: (index ==
                                      controller.currentBedroomIndex.value)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor:
                            (index == controller.currentBedroomIndex.value)
                                ? hotPropertiesThemeColor
                                : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Future customBarBottomSheetBathroomList(
      double h, String title, dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of("Select") +
                    " " +
                    AppLocalizations.of(title)),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          controller.currentBathroomIndex.value = index;
                          controller.currentBathroom.value = dataList[index];
                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index]),
                          style: TextStyle(
                              color: (index ==
                                      controller.currentBathroomIndex.value)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor:
                            (index == controller.currentBathroomIndex.value)
                                ? hotPropertiesThemeColor
                                : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Future customBarBottomSheetPropertyList(
      double h, String title, List<AddPropertyListModel> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of("Select") +
                    " " +
                    AppLocalizations.of(title)),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          controller.currrentPropertyCode.value =
                              dataList[index].propertytypeID!;
                          controller.currentPropertyTypeIndex.value = index;
                          controller.currentPropertyType.value =
                              dataList[index].propertytype!;
                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index].propertytype!),
                          style: TextStyle(
                              color: (index ==
                                      controller.currentPropertyTypeIndex.value)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor:
                            (index == controller.currentPropertyTypeIndex.value)
                                ? hotPropertiesThemeColor
                                : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Widget _appBarTitle(context) {
    return CommonAppBarTitle(
      title: AppLocalizations.of(
        "Filters",
      ),
      buttonTitle: AppLocalizations.of(
        "RESET",
      ),
      onTap: () {
        controller.reset();
        controller.maptype == MapSearchType.searchByName
            ? controller.getSearchByName(controller.currentLocation.latitude,
                controller.currentLocation.longitude,
                page: controller.page.value)
            : from == 'metro'
                ? controller.fetchMetroPropertyList()
                : controller.searchFilter(from: from);
        Navigator.pop(context);
      },
    );
  }

  Widget _customListTile(
      String title, IconData icon, VoidCallback onTap, BorderStyle style) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2, style: style),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        onTap: onTap,
        leading: Icon(
          icon,
          size: 25,
          color: Colors.grey.shade800,
        ),
        title: Container(
            child: Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700),
        )),
        trailing: Text(
          AppLocalizations.of(
            "Any",
          ),
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _customListTileBathroom(
      String title, IconData icon, VoidCallback onTap, BorderStyle style) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2, style: style),
        ),
      ),
      child: Obx(
        () => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          onTap: onTap,
          leading: (controller.iscurrentBathroomLoad.value)
              ? _loader()
              : Icon(
                  icon,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
          title: Container(
              child: Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700),
          )),
          trailing: Obx(
            () => Text(
              AppLocalizations.of(
                (controller.currentBathroom.value.isEmpty)
                    ? "Any"
                    : controller.currentBathroom.value,
              ),
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customListTilePrice(String title, IconData icon, VoidCallback onTap,
      BorderStyle style, Price type) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2, style: style),
        ),
      ),
      child: Obx(
        () => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          onTap: onTap,
          leading: (type == Price.max && controller.iscurrentMaxPriceLoad.value)
              ? _loader()
              : Icon(
                  icon,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
          title: Container(
              child: Text(
            AppLocalizations.of(title),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700),
          )),
          trailing: Text(
            AppLocalizations.of(
              ((type == Price.max && controller.currentMaxPrice.value.isEmpty) ^
                      (type == Price.min && controller.currentMinPrice.isEmpty))
                  ? "Any"
                  : (type == Price.max)
                      ? controller.currentMaxPrice.value
                      : controller.currentMinPrice.value,
            ),
            style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget _customListTileBedroom(
      String title, IconData icon, VoidCallback onTap, BorderStyle style) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2, style: style),
        ),
      ),
      child: Obx(
        () => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          onTap: onTap,
          leading: (controller.iscurrentBedroomLoad.value)
              ? _loader()
              : Icon(
                  icon,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
          title: Container(
              child: Text(
            AppLocalizations.of(title),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700),
          )),
          trailing: Obx(
            () => Text(
              AppLocalizations.of(
                (controller.currentBedroom.value.isEmpty)
                    ? "Any"
                    : controller.currentBedroom.value,
              ),
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loader() {
    return CircularProgressIndicator(
      color: hotPropertiesThemeColor,
    );
  }

  Widget _customListTilePropType(
      String title, IconData icon, VoidCallback onTap, BorderStyle style) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2, style: style),
        ),
      ),
      child: Obx(
        () => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          onTap: onTap,
          leading: (controller.iscurrentPropertyLoad.value)
              ? _loader()
              : Icon(
                  icon,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
          title: Container(
              child: Text(
            AppLocalizations.of(title),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700),
          )),
          trailing: Obx(
            () => Text(
              AppLocalizations.of(
                (controller.currentPropertyType.value.isEmpty)
                    ? "Any"
                    : controller.currentPropertyType.value,
              ),
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(String name, BuildContext context, var index) {
    return GestureDetector(
      child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            name,
            style: Theme.of(context).textTheme.button!.merge(TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: index == controller.selectedTab.value
                    ? Colors.black
                    : Colors.white)),
          )),
    );
  }

  Widget _switcher(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: 100.0.w,
      child: Obx(
        () => CupertinoSlidingSegmentedControl(
            groupValue: controller.selectedTab.value,
            backgroundColor: hotPropertiesThemeColor,
            children: <int, Widget>{
              0: _tab(
                  AppLocalizations.of(
                    "For Sale",
                  ),
                  context,
                  0),
              1: _tab(
                  AppLocalizations.of(
                    "To Rent",
                  ),
                  context,
                  1),
            },
            onValueChanged: (int? index) {
              controller.switchTabs(index!);
            }),
      ),
    );
  }

  Widget _searchButton(context) {
    return GestureDetector(
      // onTap: () => Get.back(),

      onTap: () async {
        print("datalistprice  33 =${from} ");
        controller.currentSearchType.value =
            controller.selectedTab.value == 1 ? "RENT" : "SALE";
        var data = controller.searchFilter(
          maxprice: controller.currentMaxPrice.value ?? "",
          searchtype: controller.selectedTab.value == 1 ? "Rent" : "Sale",
          from: from,
        );
        print("datalistprice  33 -----  =${controller.propertylist.length} ");
        print("datalistprice 22 33 -----  = $data");

        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: new BoxDecoration(
          color: hotPropertiesThemeColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        width: 100.0.w - 30,
        child: Center(
          child: Text(
            AppLocalizations.of('Search'),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: hotPropertiesThemeColor,
        elevation: 0,
        brightness: Brightness.dark,
        title: _appBarTitle(context),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 100.0.h - (56 + 60 + statusBarHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _switcher(context),
                  // _customListTile(
                  //     AppLocalizations.of(
                  //       "Type",
                  //     ),
                  //     CustomIcons.apartment,
                  //     () {},
                  //     BorderStyle.solid),
                  // _customListTile(
                  //     AppLocalizations.of(
                  //       "Location",
                  //     ),
                  //     CustomIcons.propert_location,
                  //     () {},
                  //     BorderStyle.solid),
                  _customListTilePrice(
                      AppLocalizations.of("Maximum") +
                          " " +
                          AppLocalizations.of("Price"),
                      CustomIcons.money, () {
                    controller.fetchPriceListSale(() {
                      customBarBottomSheetPriceList(
                          Get.size.height / 2,
                          AppLocalizations.of('your Preferred Price'),
                          controller.pricelistsale,
                          Price.max);
                    }, Price.max);
                  }, BorderStyle.solid, Price.max),
                  _customListTilePrice(
                      AppLocalizations.of("Minimum") +
                          " " +
                          AppLocalizations.of("Price"),
                      CustomIcons.money, () {
                    controller.fetchPriceListSale(() {
                      customBarBottomSheetPriceList(
                          Get.size.height / 2,
                          AppLocalizations.of('your Preferred Price'),
                          controller.pricelistsale,
                          Price.min);
                    }, Price.max);
                  }, BorderStyle.solid, Price.min),
                  _customListTileBedroom(
                      AppLocalizations.of(
                        "Rooms",
                      ),
                      CustomIcons.double_bed, () {
                    controller.fetchBedroomList(() {
                      customBarBottomSheetBedroomList(
                          Get.size.height / 2,
                          AppLocalizations.of('Rooms'),
                          controller.bedroomlist.value);
                    });
                  }, BorderStyle.solid),
                  _customListTileBathroom(
                      AppLocalizations.of(
                        "Bathrooms",
                      ),
                      CustomIcons.bath_1, () {
                    controller.fetchBathroomList(() {
                      customBarBottomSheetBathroomList(
                          Get.size.height / 2,
                          AppLocalizations.of('Bathrooms'),
                          controller.bathroomlist.value);
                    });
                  }, BorderStyle.solid),
                  _customListTilePropType(
                      AppLocalizations.of(
                        "Property Type",
                      ),
                      CustomIcons.property_type, () async {
                    print("property clicked");
                    controller.fetchPropertyList(() {
                      customBarBottomSheetPropertyList(
                          Get.size.height / 2,
                          AppLocalizations.of('Property Type'),
                          controller.propertytypelist);
                    });
                  }, BorderStyle.none),
                ],
              ),
            ),
          ),
          _searchButton(context),
        ],
      )),
    );
  }
}
