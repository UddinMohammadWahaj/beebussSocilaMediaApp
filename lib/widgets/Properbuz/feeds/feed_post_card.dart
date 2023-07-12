// import 'package:bizbultest/models/Properbuz/properbuz_feeds_model.dart';
// import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
// import 'package:bizbultest/view/Properbuz/detailed_feed_view.dart';
// import 'package:bizbultest/widgets/Properbuz/feeds/user_header_card.dart';
// import 'package:flutter/cupertino.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/feed_link_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/Properbuz/properbuz_feed_controller.dart';
import 'engagement_card.dart';
import 'feed_actions_row.dart';
import 'feed_description_card.dart';
import 'feed_media_card.dart';
import 'like_status_card.dart';
import 'user_header_card.dart';

class ProperbuzFeedPostCard extends GetView<ProperbuzFeedController> {
  final int index;
  final int val;
  final int? maxLines;
  final bool? showMenu;
  final bool? navigate;
  final Function? setNavbar;
  final Function? changeColor;
  final Function? isChannelOpen;

  const ProperbuzFeedPostCard(
      {Key? key,
      required this.index,
      required this.val,
      this.maxLines,
      this.showMenu,
      this.navigate,
      this.setNavbar,
      this.changeColor,
      this.isChannelOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ProperbuzFeedsModel feeds;
    Get.put(ProperbuzFeedController());
    var postId = controller.getFeedsList(val)[index].postId;
    var postType = controller.getFeedsList(val)[index].postType;

    // var feed = controller.feeds[index];
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserHeaderCard(
            index: index,
            val: val,
            showMenu: showMenu,
          ),
          FeedDescriptionCard(
            index: index,
            val: val,
            maxLines: maxLines!,
          ),
          FeedMediaCard(index: index, val: val),
          // FeedLinkCard(index: index, val : val ),
          EngagementCard(index: index, val: val),
          LikeStatusCard(
            index: index,
            val: val,
            postID: postId,
            postType: postType,
            isChannelOpen: () {},
          ),
          FeedActionsRow(
            index: index,
            val: val,
            navigate: navigate!,
          )
        ],
      ),
    );
  }
}
