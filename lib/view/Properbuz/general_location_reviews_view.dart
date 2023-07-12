import 'package:bizbultest/services/Properbuz/location_reviews_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/reviews/review_card_home.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/review_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../utilities/custom_icons.dart';

class GeneralLocationReviewsView extends GetView<LocationReviewsController> {
  const GeneralLocationReviewsView({Key? key}) : super(key: key);

  Widget noDataView() {
    return Center(
      child: Container(
          // height: 100,
          // width: double.infinity,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CustomIcons.review,
            size: 70,
            color: Colors.black,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            AppLocalizations.of("No Reviews Available Yet..!"),
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      )),
    );
  }

  Widget _noReviewsCard() {
    return Center(
      child: Container(
        child: Text(
          AppLocalizations.of("No reviews found"),
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LocationReviewsController);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<LocationReviewsController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            // toolbarHeight: 170,
            leading: IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.keyboard_backspace,
                size: 28,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                Get.delete<LocationReviewsController>();
              },
            ),
            backgroundColor: hotPropertiesThemeColor,
            elevation: 0,
            title: Text(
              AppLocalizations.of(
                  "${controller.selectedCity.value}, ${controller.selectedCountry.value}"),
              style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
            ),
          ),
        ),
        body: Obx(
          () => Container(
            child: controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                    color: hotPropertiesThemeColor,
                  ))
                : Container(
                    child: controller.locationReviewsList.length < 1
                        ? noDataView()
                        : ListView.builder(
                            itemCount: controller.locationReviewsList.length,
                            itemBuilder: (context, index) {
                              print(
                                  "length  of review =${controller.locationReviewsList.length} and index=${index}");
                              return LocationReviewItem(
                                index: index,
                                value: 1,
                              );
                            }),
                  ),
          ),
        ),
      ),
    );
  }
}
