import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentBottomSheet extends GetView<ProperbuzFeedController> {
  const ContentBottomSheet({Key? key}) : super(key: key);

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
                "All",
              ), () {
            Get.back();
            controller.selectedSort.value = "";
            controller.getTagFeeds(controller.selectedTag.value);
          }, CustomIcons.all),
          _customListTile(
              AppLocalizations.of(
                "Content",
              ), () {
            Get.back();
            controller.selectedSort.value = "content";
            controller.getTagFeeds(controller.selectedTag.value);
          }, CustomIcons.content),
        ],
      ),
    );
  }
}
