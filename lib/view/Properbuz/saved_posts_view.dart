import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/feed_post_card.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';

class SavedPostsView extends GetView<ProperbuzFeedController> {
  const SavedPostsView({Key? key}) : super(key: key);

  Widget _separator() {
    return Container(
      width: 100.0.w,
      height: 10,
      color: HexColor("#e9e6df"),
    );
  }

  Widget _noPostCard() {
    return Center(
      child: Container(
        child: Text(
          "No saved posts",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    controller.getSavedFeeds();
    return Scaffold(
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
          },
        ),
        title: Text(
          AppLocalizations.of("Saved") + " " + AppLocalizations.of("posts"),
          style: TextStyle(
              fontSize: 15.0.sp,
              color: Colors.black,
              fontWeight: FontWeight.normal),
        ),
      ),
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Obx(
          () => controller.isLoading.value
              ? Container()
              : Container(
                  child: controller.savedPosts.length == 0
                      ? _noPostCard()
                      : SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: customHeader(),
                          footer: customFooter(),
                          controller: controller.refreshControllerSaved,
                          onRefresh: () => controller.refreshDataSaved(),
                          onLoading: () => controller.loadMoreDataSaved(),
                          child: ListView.builder(
                              // separatorBuilder: (context, index) =>
                              //     _separator(),
                              itemCount: controller.savedPosts.length,
                              itemBuilder: (context, index) {
                                return ProperbuzFeedPostCard(
                                  navigate: true,
                                  showMenu: true,
                                  maxLines: 3,
                                  index: index,
                                  val: 3,
                                );
                              }),
                        ),
                ),
        ),
      ),
    );
  }
}
