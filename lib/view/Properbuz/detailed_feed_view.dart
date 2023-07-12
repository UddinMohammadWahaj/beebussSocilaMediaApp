import 'dart:ui';

import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/widgets/Properbuz/comments/comments_list_item.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/detailed_feeds/comment_textfield.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/detailed_feeds/likes_row_card.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/feed_post_card.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/menu_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';

class DetailedFeedView extends GetView<ProperbuzFeedController> {
  int? feedIndex;
  final int? val;
  final postId;
  final String? from;

  DetailedFeedView({Key? key, this.feedIndex, this.val, this.postId, this.from})
      : super(key: key);

  RxInt index = 0.obs;

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    // if (from == "singlePost") {
    //   for (int i = 0; i < controller.getFeedsList(1).length; i++) {
    //     if (controller.feeds[i].postId == postId) {
    //       print("------ $postId");
    //       index.value = i;
    //     } else
    //       controller.loadMoreData();
    //     if (controller.feeds[i].postId == postId) {
    //       print("------ $postId");
    //       index.value = i;

    //       print("------1122 $postId");
    //     }
    //   }
    //   print("---index --- $index");
    // }
    // feedIndex = index.value;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<CommentsController>();
        controller.commentController.clear();
        controller.comment.value = "";
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.delete<CommentsController>();
              controller.commentController.clear();
              controller.comment.value = "";
            },
          ),
          actions: [
            IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.more_vert_outlined,
                size: 28,
                color: Colors.black,
              ),
              onPressed: () {
                Get.bottomSheet(
                  MenuBottomSheet(
                    buildContext: context,
                    goBack: true,
                    index: feedIndex!,
                    val: val!,
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                );
              },
            ),
          ],
          title: Text(
            from == "singlePost"
                ? AppLocalizations.of('Feed Post')
                : AppLocalizations.of("Comments"),
            style: TextStyle(
                fontSize: 15.0.sp,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: 100.0.h -
                  (56 + MediaQueryData.fromWindow(window).padding.top),
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: [
                      ProperbuzFeedPostCard(
                        navigate: false,
                        maxLines: 20000,
                        showMenu: false,
                        index: feedIndex!,
                        val: val!,
                      ),
                      LikesRowCard(),
                      CommentsListItem(
                        // postID:
                        //     controller.getFeedsList(val!)[feedIndex!].postId,
                        feedIndex: feedIndex!,
                        val: val!,
                      )
                    ],
                  ),
                ),
              ),
            ),
            CommentTextField(
              val: val!,
              feedIndex: feedIndex!,
            )
          ],
        ),
      ),
    );
  }
}
