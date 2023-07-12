import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/Properbuz/tags_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FilterBottomSheet extends GetView<ProperbuzFeedController> {
  const FilterBottomSheet({Key? key}) : super(key: key);

  Widget _customListTile(String title, VoidCallback onTap, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
        color: Colors.grey.shade800,
      ),
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _customListTile(
              AppLocalizations.of(
                "Latest",
              ), () {
            Get.back();
            controller.selectedSort.value = "latest";
            controller.getTagFeeds(controller.selectedTag.value);
          }, CustomIcons.new__1_),
          _customListTile(
              AppLocalizations.of(
                "Followers",
              ), () {
            Get.back();
            controller.selectedSort.value = "followers";
            controller.getTagFeeds(controller.selectedTag.value);
          }, CustomIcons.followers),
        ],
      ),
    );
  }
}
