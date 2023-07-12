import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CommentTextField extends GetView<ProperbuzFeedController> {
  final int feedIndex;
  final int val;

  const CommentTextField({Key? key, required this.feedIndex, required this.val})
      : super(key: key);

  Widget _userImageCard() {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: CircleAvatar(
        backgroundImage:

            CachedNetworkImageProvider(CurrentUser().currentUser.image!),


        radius: 18,
      ),
    );
  }

  Widget _postButton(BuildContext context) {
    return Obx(
      () => Container(
          child: !controller.isCommenting.value
              ? GestureDetector(
                  onTap: () => controller.postComment(context, val, feedIndex),
                  child: Container(
                      //constraints: BoxConstraints(minHeight: 50),
                      width: 70,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Obx(() => Text(
                            controller.isCommentEdit.value

                                ? "Update"
                                : controller.isReply.value
                                    ? "Reply"
                                    : "Post",

                                // ? AppLocalizations.of("Update")
                                // : controller.isReply.value
                                //     ? AppLocalizations.of("Reply")
                                //     : AppLocalizations.of("Send"),

                            style: TextStyle(
                                color: controller.comment.value.isEmpty
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade800,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ))),
                )
              : Container(
                  child: SizedBox(
                      height: 18,
                      width: 18,
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 3,
                      ))),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 3),
            ),
          ),
          child: Row(
            children: [
              Container(
                  width: 100.0.w - 80,
                  padding: EdgeInsets.only(left: 10),
                  constraints: BoxConstraints(minHeight: 50),
                  color: Colors.white,
                  child: DetectableTextField(
                    cursorColor: Colors.grey.shade500,
                    onChanged: (value) {
                      controller.comment.value = value;
                      if (value == "" && controller.isCommentEdit.value) {
                        controller.isCommentEdit.value = false;
                      }
                      if (value == "" && controller.isReply.value) {
                        controller.isReply.value = false;
                      }
                    },
                    controller: controller.commentController,
                    maxLines: null,
                    focusNode: controller.focusNode,
                    decoration: InputDecoration(
                      prefixIcon: _userImageCard(),
                      border: InputBorder.none,
                      suffixIconConstraints: BoxConstraints(),
                      prefixIconConstraints: BoxConstraints(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,

                      hintText: AppLocalizations.of(
                        "Leave your thoughts here...",
                      ),
                      hintStyle:
                          TextStyle(color: Colors.grey.shade700, fontSize: 15),
                    ),
                    detectionRegExp: detectionRegExp()!,

                    //   hintText:
                    //       AppLocalizations.of("Leave your thoughts here") +
                    //           "...",
                    //   hintStyle:
                    //       TextStyle(color: Colors.grey.shade700, fontSize: 15),
                    // ),
                    // detectionRegExp: detectionRegExp(),

                    decoratedStyle: TextStyle(
                        fontSize: 15,
                        color: appBarColor,
                        fontWeight: FontWeight.w500),
                    basicStyle:
                        TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  )),
              _postButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
