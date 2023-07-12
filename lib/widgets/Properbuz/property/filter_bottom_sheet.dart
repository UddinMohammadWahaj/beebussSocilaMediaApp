import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/property/common_appbar_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utilities/colors.dart';
import 'filter_location_search_page.dart';

class FilterPropertyBottomSheet extends GetView<PropertiesController> {
  final int index;
  final int val;
  const FilterPropertyBottomSheet({
    Key? key,
    required this.index,
    required this.val,
  }) : super(key: key);

  Widget _appBarTitle() {
    return CommonAppBarTitle(
        title: AppLocalizations.of(
          "Filters",
        ),
        buttonTitle: AppLocalizations.of(
          "RESET",
        ),
        onTap: () {
          Get.back();

          if (val == 1) {
            controller.refreshData();
          } else {
            controller.propertSearchRefreshData();
          }
        });
  }

  Widget _customListTile(
    String title,
    IconData icon,
    BuildContext context,
    BorderStyle style,
    RxString any,
    int type,
  ) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2, style: style),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        onTap: () => controller.openDetailedFilterSheet(type, context),
        leading: Icon(
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
              any.value.isEmpty ? "Any" : any.value,
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

  Widget _tab(String name, BuildContext context, var index) {
    return GestureDetector(
      child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(

            name,
            style: Theme.of(context).textTheme.button!.merge(TextStyle(

            // AppLocalizations.of(name),
            // style: Theme.of(context).textTheme.button.merge(TextStyle(
            //
            //     fontSize: 11.0.sp,
            //     fontWeight: FontWeight.w500,
            //     color: index == controller.selectedTab.value
            //         ? Colors.black
            //         : Colors.white)
    ),
          )),
      ));
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
              2: _tab(
                  AppLocalizations.of(
                    "New Homes",
                  ),
                  context,
                  2),
            },
            onValueChanged: (int? index) {
              controller.switchTabs(index!);
            }),
      ),
    );
  }

  Widget _searchButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
        if (val == 1) {
          controller.getHotProperties();
        } else {
          controller.searchFilter();
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: new BoxDecoration(
          color: hotPropertiesThemeColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        width: 100.0.w - 20,
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
    Get.put(PropertiesController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: hotPropertiesThemeColor,
        elevation: 0,
        brightness: Brightness.dark,
        title: _appBarTitle(),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100.0.h - (56 + 70 + statusBarHeight),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _switcher(context),
                    _customListTile(
                        AppLocalizations.of(
                          "Country",
                        ),
                        Icons.public,
                        context,
                        BorderStyle.solid,
                        controller.selectedCountry,
                        1),
                    _customListTile(
                        AppLocalizations.of(
                          "Location",
                        ),
                        CustomIcons.propert_location,
                        context,
                        BorderStyle.solid,
                        controller.selectedLocation,
                        2),
                    _customListTile(
                        AppLocalizations.of("Minimum") +
                            " " +
                            AppLocalizations.of("Price"),
                        CustomIcons.money,
                        context,
                        BorderStyle.solid,
                        controller.minPrice,
                        3),
                    _customListTile(
                        AppLocalizations.of("Maximum") +
                            " " +
                            AppLocalizations.of("Price"),
                        CustomIcons.money,
                        context,
                        BorderStyle.solid,
                        controller.maxPrice,
                        4),
                    _customListTile(
                        AppLocalizations.of(
                          "Rooms",
                        ),
                        CustomIcons.double_bed,
                        context,
                        BorderStyle.solid,
                        controller.rooms,
                        5),
                    _customListTile(
                        AppLocalizations.of(
                          "Property Type",
                        ),
                        CustomIcons.property_type,
                        context,
                        BorderStyle.none,
                        controller.propertyType,
                        6),
                  ],
                ),
              ),
            ),
            _searchButton()
          ],
        ),
      )),
    );
  }
}
