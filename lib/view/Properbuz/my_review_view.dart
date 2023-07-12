import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/location_reviews_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/add_items/write_review_view.dart';
import 'package:bizbultest/view/Properbuz/general_location_reviews_view.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../api/api.dart';
import '../../services/Properbuz/user_properties_controller.dart';
import '../../services/current_user.dart';
import '../../widgets/Properbuz/menu/user_properties/location_review_card.dart';

class MyLocationReviews extends GetView<UserPropertiesController> {
  const MyLocationReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<UserPropertiesController>();
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
                  Get.delete<UserPropertiesController>();
                },
              ),
              backgroundColor: hotPropertiesThemeColor,
              elevation: 0,
              title: Text(
                AppLocalizations.of("My") +
                    " " +
                    AppLocalizations.of("Reviews"),
                style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
              ),
            ),
          ),
          body: Obx(() => controller.revLoding.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                  color: hotPropertiesThemeColor,
                ))
              : ListView.builder(
                  itemCount: controller.loactionReviewList.length,
                  itemBuilder: (context, index) {
                    return LocationReviewCard(
                      images:
                          controller.loactionReviewList[index]['images'] ?? [],
                      approvalstatus: controller.loactionReviewList[index]
                          ['status'],
                      country: controller.loactionReviewList[index]['country'],
                      location: controller.loactionReviewList[index]
                          ['location'],
                      title: controller.loactionReviewList[index]
                          ['review_title'],
                      review: controller.loactionReviewList[index]['review'],
                      rating: int.parse(
                        controller.loactionReviewList[index]['rating'],
                      ),
                      index: index,
                    );
                  }))),
    );
  }
}
