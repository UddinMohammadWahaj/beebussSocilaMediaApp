import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_card.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_filter.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_sort_widget.dart';
import 'package:bizbultest/widgets/Properbuz/property/filter_bottom_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/property/sort_bottom_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class GeneralPopularRealEstateMarketView
    extends GetView<PopularRealEstateMarketController> {
  final String country;
  final String city;
  GeneralPopularRealEstateMarketView(this.country, this.city);
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
                Navigator.pop(context);
              },
            ),
            Container(
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
                        "Popular Real Estate Market",
                      ),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      AppLocalizations.of(
                        "${this.city},${this.country}",
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                )),
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
      color: Colors.white,
      child: Row(
        children: [
          _settingsCard(
              AppLocalizations.of(
                "FILTERS",
              ),
              CustomIcons.filter, () {
            Get.bottomSheet(PopularFilterPropertyBottomSheet(),
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
              PopularSortPropertyBottomSheet(),
              enableDrag: false,
              isScrollControlled: true,
              ignoreSafeArea: false,
              backgroundColor: Colors.white,
            );
          }),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    Get.put(PopularRealEstateMarketController(this.country, this.city));
    return WillPopScope(
      onWillPop: () async {
        controller.reset();
        Navigator.pop(context);

        Get.delete<PopularRealEstateMarketController>();
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
                      preferredSize: Size.fromHeight(55),
                      child: _settingsRow()),
                  automaticallyImplyLeading: false,
                )
              ];
            },
            body: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Obx(
                () => controller.fetchListLoader.isTrue
                    ? Center(
                        child: CircularProgressIndicator(
                        color: hotPropertiesThemeColor,
                      ))
                    : Container(
                        child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: customHeader(),
                          footer: customFooter(),
                          controller: controller.refreshController,
                          onRefresh: () => controller.refreshData(),
                          onLoading: () => controller.loadMoreData(),
                          child:
                              controller.lstofpopularrealestatemodel.length > 0
                                  ? ListView.builder(
                                      itemCount: controller
                                          .lstofpopularrealestatemodel.length,
                                      itemBuilder: (context, index) {
                                        return PopularRealEstateItem(index);
                                      })
                                  : Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(
                                              'No properties found!!'),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
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
          // ),
          ),
    );
  }
}
