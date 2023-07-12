import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/widgets/Properbuz/menu/manage_properties/manage_properties_card.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../../utilities/colors.dart';

class RentalPropertiesTab extends GetView<UserPropertiesController> {
  RentalPropertiesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var refreshController = RefreshController(initialRefresh: false);
    Get.put(UserPropertiesController());
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Obx(
          () => controller.managepropertyLoding.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                  color: hotPropertiesThemeColor,
                ))
              : controller.rentalProperties.length != 0
                  ?
                  // SmartRefresher(
                  //     enablePullDown: true,
                  //     enablePullUp: true,
                  //     header: customHeader(),
                  //     footer: customFooter(),
                  //     controller: controller.refreshController,
                  //     onRefresh: () => controller.refreshSaveProperties(),
                  //     onLoading: () => controller.loadMoreSavedProperties(),
                  //     child: ListView.builder(
                  //       itemCount: controller.savedProperties.length,
                  //       itemBuilder: (context, index) {
                  //         return SavedPropertyCard(
                  //           index: index,
                  //         );
                  //       },
                  //     ),
                  //   ),
                  SmartRefresher(
                      controller: refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      onLoading: () async {
                        print("onloading calld");
                        controller.loadManageProperties(
                            'rental', refreshController.loadComplete);
                      },
                      onRefresh: () {
                        print('onrefresh called');
                      },
                      header: customHeader(),
                      footer: customFooter(),
                      child: ListView.builder(
                          itemCount: controller.rentalProperties.length,
                          itemBuilder: (context, index) {
                            return ManagePropertiesCard(
                              listingType: "Rental",
                              index: index,
                            );
                          }),
                    )
                  : Center(
                      child: Text('No Data to show'),
                    ),
        ),
      ),
    );
  }
}
