import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';

import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/widgets/Properbuz/menu/user_properties/saved_property_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../utilities/colors.dart';
import '../../../../widgets/Properbuz/utils/header_footer.dart';

class SavedPropertiesTab extends GetView<PropertiesController> {
  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Obx(
          () => controller.saveLoding.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                  color: hotPropertiesThemeColor,
                ))
              : controller.savedProperties.length == 0
                  ? Center(child: Text("No Saved property yet..!!"))
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: customHeader(),
                      footer: customFooter(),
                      controller: controller.refreshController,
                      onRefresh: () => controller.refreshSaveProperties(),
                      onLoading: () => controller.loadMoreSavedProperties(),
                      child: ListView.builder(
                        itemCount: controller.savedProperties.length, 
                        itemBuilder: (context, index) {
                          return SavedPropertyCard(
                            index: index,
                          );
                        },
                      ),
                    ),
        ));
  }
}
