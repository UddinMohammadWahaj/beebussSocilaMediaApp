import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/report/report_item_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

class MenuBottomSheet extends GetView<ProperbuzFeedController> {
  final int index;
  final int val;
  final bool goBack;
  final BuildContext? buildContext;

  const MenuBottomSheet(
      {Key? key,
      required this.index,
      required this.val,
      required this.goBack,
      this.buildContext})
      : super(key: key);

  Widget _divider() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 15),
      height: 5,
      width: 50,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
          color: Colors.grey.shade700),
    );
  }

  Widget _customListTile(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              child: Icon(
                icon,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            subtitle.isEmpty
                ? Text(
                    AppLocalizations.of(title),
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.normal),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(title),
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        AppLocalizations.of(subtitle),
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 9.0.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ],
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
          _divider(),
          Obx(() => _customListTile(
              controller
                  .saveString(controller.getFeedsList(val)[index].saved!.value)
                  .split(" ")[0],
              "${controller.saveString(controller.getFeedsList(val)[index].saved!.value)}",
              controller
                  .saveIcon(controller.getFeedsList(val)[index].saved!.value),
              () => controller.saveUnsavePost(index, val))),
          _customListTile(
              AppLocalizations.of("Share") + " " + AppLocalizations.of("via"),
              AppLocalizations.of("Share") +
                  " " +
                  AppLocalizations.of("this") +
                  " " +
                  AppLocalizations.of("post") +
                  " " +
                  AppLocalizations.of("via"),
              Icons.share_sharp, () {
            controller.sharePost(index, val);
          }),
          CurrentUser().currentUser.memberID !=
                  controller.getFeedsList(val)[index].memberId
              ? _customListTile(
                  AppLocalizations.of("Unfollow") +
                      " ${controller.getFeedsList(val)[index].memberName}",
                  AppLocalizations.of(
                          "Stay connected but stop seeing posts from") +
                      " ${controller.getFeedsList(val)[index].memberName!.split(" ")[0]} in feed",
                  Icons.cancel,
                  () => controller.unfollowPopup(
                      index, val, goBack, buildContext!))
              : Container(),
          CurrentUser().currentUser.memberID !=
                  controller.getFeedsList(val)[index].memberId
              ? Container()
              : _customListTile(
                  AppLocalizations.of("Edit") +
                      " " +
                      AppLocalizations.of("post"),
                  "",
                  Icons.edit,
                  () => controller.onTapEdit(index, val, context)),
          CurrentUser().currentUser.memberID !=
                  controller.getFeedsList(val)[index].memberId
              ? Container()
              : _customListTile(
                  AppLocalizations.of("Delete") +
                      " " +
                      AppLocalizations.of("post"),
                  "",
                  CupertinoIcons.delete_solid,
                  () => controller.deletePopup(
                      index, val, goBack, buildContext!)),
          // _customListTile("I don't want to see this", "Let us know why you don't want to see this post", CupertinoIcons.eye_slash_fill, () {}),
          CurrentUser().currentUser.memberID !=
                  controller.getFeedsList(val)[index].memberId
              ? _customListTile(
                  AppLocalizations.of("Report") +
                      " " +
                      AppLocalizations.of("this") +
                      " " +
                      AppLocalizations.of("post"),
                  AppLocalizations.of(
                      "This post is offensive or the account is hacked"),
                  Icons.report_rounded, () {
                  Get.back();
                  Get.bottomSheet(
                      ReportItemSheet(
                        type: "post",
                        uniqueID: controller.getFeedsList(val)[index].postId,
                      ),
                      backgroundColor: Colors.white);
                })
              : Container(),
        ],
      ),
    );
  }
}
