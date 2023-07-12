import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/tags_feeds_view.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/tags_country_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrendingTags extends GetView<ProperbuzFeedController> {
  const TrendingTags({Key? key}) : super(key: key);

  Widget _title() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(TagsCountryBottomSheet(),
            backgroundColor: Colors.white);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(
                    "Trending Tags in",
                  ) +
                  " ${CurrentUser().currentUser.country} • ",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              AppLocalizations.of(
                "Change",
              ),
              style: TextStyle(
                fontSize: 13,
                color: hotPropertiesThemeColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagCard(int index, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TagsFeedsView(
                  tag: AppLocalizations.of("${controller.tags[index]}")))),
      child: Container(
          margin: EdgeInsets.only(
              left: index == 0 ? 10 : 5,
              right: index == controller.tags.length - 1 ? 10 : 0),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 1,
            ),
          ),
          child: Container(
            child: Text(
              AppLocalizations.of("${controller.tags[index]}"),
              style: TextStyle(
                  color: hotPropertiesThemeColor, fontWeight: FontWeight.w500),
            ),
          )),
    );
  }

  Widget _tagsBuilder(BuildContext context) {
    return Container(
      height: 35,
      child: Obx(
        () => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.tags.length,
            itemBuilder: (context, index) {
              return _tagCard(index, context);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_title(), _tagsBuilder(context)],
      ),
    );
  }
}
