import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/widgets/Properbuz/comments/comments_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Language/appLocalization.dart';

class CommentsListItem extends GetView<CommentsController> {
  final int feedIndex;
  final int val;
  const CommentsListItem(
      {Key? key, required this.feedIndex, required this.val,/* this.postID*/}): super(key: key);
        // padding: EdgeInsets.symmetric(vertical: 30),
        // child: Text(
        //   AppLocalizations.of("No comments"),
        //   style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        //   textAlign: TextAlign.center,
        // ),
    //   ),
    // );
  @override
  Widget build(BuildContext context) {
    Get.put(CommentsController());
    return Container(
      child: Obx(
            () => Container(
          child: controller.areCommentsLoading.value
              ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                strokeWidth: 3,
              ))
              : Container(
            child: controller.commentsList.isEmpty
                ? /*_noCommentsCard()*/Container()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: Text(
                      "Comments",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.normal),
                    )),
                Obx(
                      () => ListView.builder(
                      controller: controller.scrollController,
                      padding: EdgeInsets.only(bottom: 50),
                      //physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.commentsList.length,
                      itemBuilder: (context, index) {
                        return CommentsCard(
                          postID: /*postID*/"postid",
                          feedIndex: feedIndex,
                          index: index,
                          val: val,
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  }



