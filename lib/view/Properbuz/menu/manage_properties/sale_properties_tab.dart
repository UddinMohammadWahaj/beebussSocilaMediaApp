import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/menu/manage_properties/manage_properties_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Language/appLocalization.dart';
import '../../../../utilities/colors.dart';

class SalePropertiesTab extends GetView<UserPropertiesController> {
  const SalePropertiesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());

    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child:
            //FOR TESTING PURPOSE
            // ListView.builder(
            //     // controller.manageProperties.length
            //     itemCount: 20,
            //     itemBuilder: (context, index) {
            //       return ManagePropertiesCard(
            //         listingType: "Sale",
            //         index: 0,
            //       );
            //     }),
//FOR REAL USE
            Obx(
          () => controller.managepropertyLoding.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                  color: hotPropertiesThemeColor,
                ))
              : controller.saleProperties.length != 0
                  ? ListView.builder(
                      // controller.manageProperties.length
                      itemCount: controller.saleProperties.length,
                      itemBuilder: (context, index) {
                        return ManagePropertiesCard(
                          listingType: "Sale",
                          index: index,
                        );
                      })
                  : Center(
                      child: Text(AppLocalizations.of('No data to show')),
                    ),
        ),
      ),
    );
  }
}
