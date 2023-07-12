import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/boost_feed_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EngagementCard extends GetView<ProperbuzFeedController> {
  final int? index;
  final int? val;
  const EngagementCard({Key? key, this.index, this.val}) : super(key: key);

  Widget _customEngagementCard(String value, String number) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 14,
              color: settingsColor,
              fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  Widget _boostButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BoostFeedPost(
                    postID: controller.getFeedsList(val!)[index!].postId!,
                  ))),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: new BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 1.2,
            ),
          ),
          child: Text(
            AppLocalizations.of(
              "Boost Post",
            ),
            style: TextStyle(color: hotPropertiesThemeColor),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    if (controller.getFeedsList(val!)[index!].boostStatus!) {
      return Container(
        margin: EdgeInsets.only(top: 15, bottom: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _customEngagementCard(
                AppLocalizations.of(
                  "People Reached",
                ),
                controller
                    .getFeedsList(val!)[index!]
                    .boostData!
                    .peopleReached
                    .toString()),
            _customEngagementCard(
                AppLocalizations.of(
                  "Engagements",
                ),
                controller
                    .getFeedsList(val!)[index!]
                    .boostData!
                    .engagements
                    .toString()),
            _boostButton(context)
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
