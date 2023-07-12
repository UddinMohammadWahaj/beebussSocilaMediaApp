import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/feed_post_card.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/trending_tags.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/upload_post_card.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../services/current_user.dart';

class ProperbuzFeedsView extends GetView<ProperbuzFeedController> {
  ProperbuzFeedsView({
    Key? key,
  }) : super(key: key);

  Widget _separator() {
    return Container(
      width: 100.0.w,
      height: 10,
      color: HexColor("#e9e6df"),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Container(
      child: Obx(
        () => SmartRefresher(
          key: Key(CurrentUser().currentUser.memberID! + 'proprefresh'),
          enablePullDown: true,
          enablePullUp: true,
          header: customHeader(),
          footer: customFooter(),
          controller: controller.refreshController,
          onRefresh: () => controller.refreshData(),
          onLoading: () => controller.loadMoreData(),
          child: ListView.separated(
              controller: controller.scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              separatorBuilder: (context, index) => _separator(),
              itemCount: controller.feeds.length + 2,
              itemBuilder: (context, index) {
                if (index == 1) {
                  return TrendingTags();
                } else if (index == 0) {
                  return UploadPostCard(
                    index: index - 2,
                  );
                } else {
                  return ProperbuzFeedPostCard(
                    navigate: true,
                    showMenu: true,
                    maxLines: 4,
                    index: index - 2,
                    val: 1,
                  );
                }
              }),
        ),
      ),
    );
  }
}
