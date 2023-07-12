import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/new_message_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FeedActionsRow extends GetView<ProperbuzFeedController> {
  final int index;
  final int val;
  final bool? navigate;

  const FeedActionsRow(
      {Key? key, required this.index, required this.val, this.navigate})
      : super(key: key);

  Widget _actionButton(IconData icon, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100.0.w / 4,
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Icon(
              icon,
              color: Colors.grey.shade700,
              size: 17,
            )),
            SizedBox(
              height: 2,
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget _likeButton() {
    return Obx(
      () => InkWell(
        onTap: () => controller.likeUnlike(index, val),
        child: Container(
          width: 100.0.w / 4,
          padding: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Icon(
                controller.getFeedsList(val)[index].liked!.value
                    ? Icons.thumb_up
                    : Icons.thumb_up_alt_outlined,
                color: controller.getFeedsList(val)[index].liked!.value
                    ? hotPropertiesThemeColor
                    : Colors.grey.shade700,
                size: 17,
              )),
              SizedBox(
                height: 2,
              ),
              Text(
                AppLocalizations.of("Like"),
                style: TextStyle(
                    fontSize: 13,
                    color: controller.getFeedsList(val)[index].liked!.value
                        ? hotPropertiesThemeColor
                        : Colors.grey.shade700,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      width: 100.0.w - 20,
      height: 0.8,
      color: Colors.grey.shade400,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Container(
      child: Column(
        children: [
          _divider(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _likeButton(),
                _actionButton(
                    CupertinoIcons.chat_bubble_text_fill,
                    AppLocalizations.of(
                      "Comment",
                    ),
                    () => controller.navigateToComment(
                        navigate!, index, val, context)),
                _actionButton(
                    CupertinoIcons.arrow_turn_up_right,
                    AppLocalizations.of(
                      "Share",
                    ),
                    () => controller.sharePost(index, val)),
                _actionButton(
                    CustomIcons.plane_thick,
                    AppLocalizations.of(
                      "Direct",
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewMessageScreen(
                                  index: index,
                                  val: val,
                                )))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
