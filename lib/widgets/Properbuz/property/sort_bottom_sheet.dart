import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

class SortPropertyBottomSheet extends GetView<PropertiesController> {
  const SortPropertyBottomSheet({Key? key}) : super(key: key);

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
              ),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 16,
                  color: hotPropertiesThemeColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortItem(String name, int index) {
    return ListTile(
      tileColor: controller.selectedIndex.value == index
          ? hotPropertiesThemeColor
          : Colors.white,
      // contentPadding: EdgeInsets.symmetric(horizontal: 15),
      onTap: () {
        // controller.sortHotProperties(
        //     name.replaceAll(" ", "_").toLowerCase().toString());

        print("name=$name");
        controller.selectedSort.value =
            name.replaceAll(" ", "_").toLowerCase().toString();

        controller.selectedIndex.value = index;
      },
      title: Text(
        AppLocalizations.of(name),
        style: TextStyle(
            fontSize: 16,
            color: controller.selectedIndex.value == index
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _settingsCard(AppLocalizations.of("Cancel"), Icons.cancel_outlined,
                () {
              controller.selectedSort.value = "latest";
              controller.selectedIndex.value = -1;
              Get.back();
              controller.sortHotProperties(controller.selectedSort.value);
            }),
            _settingsCard(AppLocalizations.of("Done"), Icons.done_rounded,
                () async {
              controller.sortHotProperties(controller.selectedSort.value);
            }),
          ],
        ),
        Divider(
          thickness: 2,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.898,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.sortList.length,
              itemBuilder: (context, index) {
                return Obx(() =>
                    _sortItem(controller.sortList[index].toString(), index));
              }),
        ),
      ],
    );
  }
}
