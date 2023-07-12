import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/Properbuz/tags_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SearchBottomSheet extends GetView<ProperbuzFeedController> {
  const SearchBottomSheet({Key? key}) : super(key: key);

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

  Widget _customTextField(
      TextEditingController controller, String hintText, VoidCallback onTap) {
    return Container(
      height: 50,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.transparent,
                child: Text(
                  "Apply",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: hotPropertiesThemeColor),
                  textAlign: TextAlign.center,
                )),
          ),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
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
                "Posts having keyword",
              ),
              () {},
              CupertinoIcons.text_bubble_fill),
          _customTextField(controller.keywordController, "Enter keyword", () {
            Get.back();
            controller.selectedSort.value = "";
            controller.getTagFeeds(controller.selectedTag.value);
            controller.keywordController.clear();
          }),
          _customListTile(
              AppLocalizations.of(
                "Posts having images only",
              ), () {
            Get.back();
            controller.selectedSort.value = "images";
            controller.getTagFeeds(controller.selectedTag.value);
          }, CupertinoIcons.photo),
          _customListTile(
              AppLocalizations.of(
                "Posts having video only",
              ), () {
            Get.back();
            controller.selectedSort.value = "videos";
            controller.getTagFeeds(controller.selectedTag.value);
          }, CupertinoIcons.play_rectangle_fill),
          // _customListTile(
          //     AppLocalizations.of(
          //       "Posts mentioning someone",
          //     ),
          //     () {},
          //     CupertinoIcons.tag_solid),
        ],
      ),
    );
  }
}
