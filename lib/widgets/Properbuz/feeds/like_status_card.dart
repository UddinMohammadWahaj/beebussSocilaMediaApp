import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/newsfeed_likes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizbultest/models/Properbuz/properbuz_feeds_model.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

class LikeStatusCard extends GetView<ProperbuzFeedController> {
  final int? index;
  final int? val;
  final String? postID;
  final String? postType;
  final ProperbuzFeedsModel? feeds;
  final Function? setNavBar;
  final Function? isChannelOpen;
  final Function? changeColor;

  const LikeStatusCard(
      {Key? key,
      this.index,
      this.val,
      this.postID,
      this.postType,
      this.feeds,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Row(
      children: [
        Obx(
          () => Container(
            width: 50.0.w,
            color: Colors.transparent,
            child: controller.getFeedsList(val!)[index!].totalLike!.value == 0
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Obx(() => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsFeedLikesPage(
                                              setNavBar: setNavBar!,
                                              isChannelOpen: isChannelOpen!,
                                              changeColor: changeColor!,
                                              postID: postID!,
                                              postType: postType!,
                                            )));
                              },
                              child: Text(
                                AppLocalizations.of(controller
                                        .getFeedsList(val!)[index!]
                                        .totalLike!
                                        .value
                                        .toString() +
                                    " " +
                                    controller.likesString(index!, val!)),
                                style: TextStyle(
                                  color: hotPropertiesThemeColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
          ),
        ),
        Obx(
          () => Container(
            width: 50.0.w,
            color: Colors.transparent,
            child:
                controller.getFeedsList(val!)[index!].totalComment!.value == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(() => Text(
                                  controller
                                          .getFeedsList(val!)[index!]
                                          .totalComment!
                                          .value
                                          .toString() +
                                      " " +
                                      controller.commentString(index!, val!),
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )),
                          ],
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}
