import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/widgets/Properbuz/menu/user_properties/alert_property_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../utilities/colors.dart';
import '../../../../widgets/Properbuz/utils/header_footer.dart';

class AlertPropertiesTab extends GetView<PropertiesController> {

  
  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Obx(
          () => controller.alertLoding.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                  color: hotPropertiesThemeColor,
                ))
              : controller.alertProperties.length == 0
                  ? Center(child: Text("No Alert Property yet..!!"))
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: customHeader(),
                      footer: customFooter(),
                      controller: controller.refreshController1,
                      onRefresh: () => controller.refreshAlertProperties(),
                      onLoading: () => controller.loadMoreAlertProperties(),
                      child: ListView.builder(
                        itemCount: controller.alertProperties.length,
                        itemBuilder: (context, index) {
                          return AlertPropertyCard(
                            index: index,
                          );
                        },
                      ),
                    ),
        ));
  }
}
