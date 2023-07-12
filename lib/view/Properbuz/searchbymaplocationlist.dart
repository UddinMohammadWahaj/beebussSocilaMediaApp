import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/searchbymapitem.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_card.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_filter.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_sort_widget.dart';
import 'package:bizbultest/widgets/Properbuz/property/searchbymapfeatures/searchbymapfilter.dart';
import 'package:bizbultest/widgets/Properbuz/property/searchbymapfeatures/searchbymapsort.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class SearchByMapLocationList extends GetView<SearchByMapController> {
  String from = "";
  SearchByMapLocationList({this.from = ''});

  Widget _appBarTitle(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              ),
              color: Colors.white,
              onPressed: () {
                controller.reset();
                Navigator.pop(context);
              },
            ),
            Obx(
              () => Container(
                  width: 100.0.w - 80,
                  decoration: new BoxDecoration(
                    color: hotPropertiesThemeLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    shape: BoxShape.rectangle,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(
                          controller.currentMapSearchType.value ==
                                  MapSearchType.searchByName
                              ? controller.searchTextLoc.text
                              : AppLocalizations.of("Area drawn on map"),
                        ),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        AppLocalizations.of(
                                '${controller.propertylist.length ?? 0} ') +
                            AppLocalizations.of('Home'),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

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
                  )),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    color: hotPropertiesThemeColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
    );
  }

  Widget _settingsRow() {
    return Container(
      height: 57,
      color: Colors.white,
      child: Row(
        children: [
          _settingsCard(
              AppLocalizations.of(
                "FILTERS",
              ),
              CustomIcons.filter, () {
            Get.bottomSheet(
                SearchByMapFilterPropertyBottomSheet(
                  from: from,
                ),
                enableDrag: false,
                isScrollControlled: true,
                ignoreSafeArea: false,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))));
          }),
          _settingsCard(
              AppLocalizations.of(
                "SORT BY",
              ),
              CustomIcons.sort, () {
            Get.bottomSheet(
              SearchByMapSortPropertyBottomSheet(
                from: from,
              ),
              isScrollControlled: true,
              enableDrag: false,
              ignoreSafeArea: false,
              backgroundColor: Colors.white,
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SearchByMapController());
    return WillPopScope(
      onWillPop: () async {
        controller.reset();
        Navigator.pop(context);

        // Get.delete<SearchByMapController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  toolbarHeight: 70,
                  titleSpacing: 5,
                  pinned: true,
                  floating: true,
                  elevation: 0,
                  brightness: Brightness.dark,
                  backgroundColor: hotPropertiesThemeColor,
                  title: _appBarTitle(context),
                  bottom: PreferredSize(
                      preferredSize: Size.fromHeight(57),
                      child: _settingsRow()),
                  automaticallyImplyLeading: false,
                )
              ];
            },
            body: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Obx(
                () => controller.metroLoading.isTrue
                    ? Center(
                        child: CircularProgressIndicator(
                            color: hotPropertiesThemeColor),
                      )
                    : Container(
                        child: controller.propertylist.length == 0
                            ? Container(
                                color: Colors.white,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of('No properties Found!!'),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                )))
                            : SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                header: customHeader(),
                                footer: customFooter(),
                                controller: controller.refreshController,
                                onRefresh: () => controller.refreshData(),
                                onLoading: () => controller.loadMoreData1(from),
                                // {
                                //   print('onloading prop');
                                //   if (controller.currentMapSearchType.value ==
                                //       MapSearchType.searchByDraw) {
                                //     controller.fetchPropertyDetailsDraw();
                                //   } else if (controller
                                //           .currentMapSearchType.value ==
                                //       MapSearchType.searchByName) {
                                //     print("search by map name on loading ");
                                //     controller.getSearchByName(
                                //         controller.currentLocation.latitude,
                                //         controller.currentLocation.longitude,
                                //         page: controller.page.value + 1);
                                //   } else {
                                //     print(
                                //         "metro current page=${controller.page.value}");
                                //     controller.fetchPropertyDetails(
                                //         page: controller.page.value + 1);
                                //   }
                                // },
                                child: ListView.builder(
                                    itemCount: controller.propertylist.length,
                                    itemBuilder: (context, index) {
                                      return SearchByMapItem(index);
                                      // return PopularRealEstateItem(index);
                                    })),
                      ),
              ),
            )

            //  Obx(
            //   () => Container(
            //     child: (controller.lstofpopularrealestatemodel.length == 0)
            //         ? Center(
            //             child: CircularProgressIndicator(
            //               color: settingsColor,
            //             ),
            //           )
            //         : ListView.separated(
            //             separatorBuilder: (context, index) => Divider(
            //                   height: 5,
            //                   color: settingsColor,
            //                 ),
            //             itemCount: controller.lstofpopularrealestatemodel.length,
            //             itemBuilder: (context, index) {
            //               return PopularRealEstateItem(index);
            //             }),
            //   ),
            ),
      ),
    );
  }
}
