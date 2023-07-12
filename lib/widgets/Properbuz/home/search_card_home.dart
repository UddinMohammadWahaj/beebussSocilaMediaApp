import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/find_tradsemen_view.dart';
import 'package:bizbultest/view/Properbuz/home/price_range_view.dart';
import 'package:bizbultest/view/Properbuz/location_reviews_view.dart';
import 'package:bizbultest/widgets/Properbuz/home/property_card_home.dart';
import 'package:bizbultest/widgets/Properbuz/home/search/bedrooms_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/home/search/location_search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SearchCardHome extends GetView<ProperbuzController> {
  StateSetter setstate;
  SearchCardHome(this.setstate, {Key? key}) : super(key: key);

  Widget _locationBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tapped here");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LocationSearchPage()));
      },
      child: Container(
          alignment: Alignment.centerLeft,
          height: 50,
          width: 100.0.w,
          padding: EdgeInsets.only(
            left: 10,
          ),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 1,
            ),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.transparent,
                  width: 100.0.w - 115,
                  child: Text(
                    controller.message.isEmpty
                        ? AppLocalizations.of("Type") +
                            " " +
                            AppLocalizations.of("Location") +
                            " " +
                            AppLocalizations.of("of") +
                            " " +
                            AppLocalizations.of(
                                "${CurrentUser().currentUser.country}")
                        : AppLocalizations.of(controller.message.value),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                controller.message.value.isEmpty
                    ? Container()
                    : GestureDetector(
                        onTap: () => controller.clearSearchParameters(),
                        child: Container(
                            width: 70,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            height: 50,
                            color: hotPropertiesThemeColor,
                            child: Text(
                              AppLocalizations.of("Remove"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                      )
              ],
            ),
          )),
    );
  }

  Widget _filterCard(String value, VoidCallback onTap, double width) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 9),
          decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 1,
            ),
          ),
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width - 50,
                child: Text(
                  AppLocalizations.of(value),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 23.5,
                color: Colors.black,
              )
            ],
          )),
    );
  }

  Widget _searchButton(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.onTapSearch(context),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: new BoxDecoration(
          color: hotPropertiesThemeColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        width: 100.0.w,
        child: Text(
          AppLocalizations.of('Search'),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _customButton(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: 100.0.w - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style:
                    TextStyle(color: Colors.grey.shade800, fontSize: 11.0.sp),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey.shade800,
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => (ProperbuzController()), fenix: true);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                _locationBox(context),
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Obx(() => _filterCard(
                //             controller.minPrice.value.isEmpty &&
                //                     controller.maxPrice.value.isEmpty
                //                 ? AppLocalizations.of("Price")
                //                 : "${controller.minPrice.value} to ${controller.maxPrice.value}",
                //             () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => PriceRangeView()));
                //         }, 60.0.w)),
                //     Obx(
                //       () => _filterCard(
                //           controller.selectedBedroom.value.isEmpty
                //               ? AppLocalizations.of("Bedrooms")
                //               : controller.selectedBedroom.value, () {
                //         Get.bottomSheet(
                //           BedroomsSheet(),
                //           ignoreSafeArea: false,
                //           backgroundColor: Colors.white,
                //         );
                //       }, 30.0.w),
                //     ),
                //   ],
                // ),
                Obx(() => _filterCard(
                        controller.minPrice.value.isEmpty &&
                                controller.maxPrice.value.isEmpty
                            ? AppLocalizations.of("Price")
                            : "${controller.minPrice.value} to ${controller.maxPrice.value}",
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PriceRangeView()));
                    }, 90.0.w)),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => _filterCard(
                      controller.selectedBedroom.value.isEmpty
                          ? AppLocalizations.of("Bedrooms")
                          : controller.selectedBedroom.value, () {
                    Get.bottomSheet(
                      BedroomsSheet(),
                      ignoreSafeArea: false,
                      backgroundColor: Colors.white,
                    );
                  }, 90.0.w),
                ),
                _searchButton(context),
              ],
            ),
          ),
          PropertyCardHome(),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 15),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       _customButton(
          //           AppLocalizations.of(
          //             "Location Reviews",
          //           ), () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => SearchLocationReviews()));
          //       }),
          //       // _customButton(AppLocalizations.of("Find Tradesmen"), () {
          //       //   Navigator.push(
          //       //       context,
          //       //       MaterialPageRoute(
          //       //           builder: (context) => FindTradsmenView()));
          //       // }),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
