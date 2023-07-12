import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/expanded_blog_page.dart';
import 'package:bizbultest/view/feed_likes_page.dart';
import 'package:bizbultest/view/insights_page.dart';
import 'package:bizbultest/view/promote_post_page.dart';
import 'package:bizbultest/widgets/Bookmark/save_to_board_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../feeds_video_player.dart';

class FeedBodyFooter extends StatefulWidget {
  final NewsFeedModel? feed;
  final VoidCallback? expandedFeed;
  final VoidCallback? like;
  final VoidCallback? share;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  FeedBodyFooter(
      {Key? key,
      this.feed,
      this.expandedFeed,
      this.like,
      this.share,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  _FeedBodyFooterState createState() => _FeedBodyFooterState();
}

class _FeedBodyFooterState extends State<FeedBodyFooter> {
  Widget _iconButton(VoidCallback onTap, IconData icon, Color color) {
    return IconButton(
        padding: EdgeInsets.all(0),
        constraints: BoxConstraints(),
        splashColor: Colors.transparent,
        onPressed: onTap,
        splashRadius: 25,
        icon: Icon(
          icon,
          color: color,
          size: 25,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _iconButton(
                        widget.like!,
                        !widget.feed!.isLiked!
                            ? CustomIcons.heart
                            : CustomIcons.like,
                        !widget.feed!.isLiked! ? Colors.black : Colors.red),
                    SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: widget.expandedFeed ?? () {},
                      child: Image.asset(
                        "assets/images/comment.png",
                        height: 25,
                      ),
                    ),
                    SizedBox(
                      width: 19,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: widget.share ?? () {},
                      child: Image.asset(
                        "assets/images/share.png",
                        height: 25,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  splashRadius: 20,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    CustomIcons.bookmark_thin,
                  ),
                  onPressed: () {
                    print(widget.feed!.postImgData);
                    Get.bottomSheet(
                        SaveToBoardSheet(
                          postID: widget.feed!.postId,
                          image: widget.feed!.thumbnailUrl!
                              .replaceAll(".mp4", ".jpg"),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))));
                  },
                  padding: EdgeInsets.symmetric(horizontal: 0),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FeedLikesPage(
                          setNavBar: widget.setNavBar!,
                          isChannelOpen: widget.isChannelOpen!,
                          changeColor: widget.changeColor!,
                          postID: widget.feed!.postId,
                          postType: widget.feed!.postType,
                        )),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  child: Text(
                    widget.feed!.postType == "Video" ||
                            widget.feed!.postType == "svideo"
                        ? widget.feed!.postNumViews + ' views'
                        : widget.feed!.postTotalLikes,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromotePostFooter extends StatelessWidget {
  final NewsFeedModel? feed;

  PromotePostFooter({Key? key, this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          feed!.postPromotedSlider! > 0
              ? Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feed!.postTotalReach! +
                            " " +
                            AppLocalizations.of(
                              "People Reached",
                            ),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        feed!.postTotalEngagement! +
                            " " +
                            AppLocalizations.of(
                              "Engagements",
                            ),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => InsightsPage(
                      //                     postType: feed.postType,
                      //                     postID: feed.postId,
                      //                     memberID:
                      //                         CurrentUser().currentUser.image,
                      //                   )));
                      //     },
                      //     child: Container(
                      //         color: Colors.transparent,
                      //         child: Text(
                      //           AppLocalizations.of(
                      //             "View Insights",
                      //           ),
                      //           style: TextStyle(color: primaryBlueColor),
                      //         )))
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InsightsPage(
                                  postType: feed!.postType,
                                  postID: feed!.postId,
                                  memberID: CurrentUser().currentUser.image,
                                )));
                  },
                  child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(1.5.h),
                        child: Text(
                          AppLocalizations.of(
                            "View Insights",
                          ),
                          style: TextStyle(color: primaryBlueColor),
                        ),
                      ))),
          Padding(
            padding: EdgeInsets.only(right: 1.0.h),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryBlueColor),
                  // disabledColor: primaryBlueColor,
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PromotePost(
                              memberName: CurrentUser().currentUser.fullName,
                              memberImage: CurrentUser().currentUser.image,
                              feed: feed!,
                              logo: CurrentUser().currentUser.logo,
                              country: CurrentUser().currentUser.country,
                              memberID: CurrentUser().currentUser.memberID,
                            )));
              },
              child: Text(
                AppLocalizations.of(
                  "Promote",
                ),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BlogFooter extends StatelessWidget {
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  final NewsFeedModel? feed;

  BlogFooter(
      {Key? key,
      this.feed,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                  image: CachedNetworkImageProvider(feed!.postImgData!),
                  fit: BoxFit.cover)),
          InkWell(
            onTap: () {
              print(feed!.postImgData);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpandedBlogPage(
                            setNavBar: setNavBar!,
                            isChannelOpen: isChannelOpen!,
                            changeColor: changeColor!,
                            blogID: feed!.blogId,
                          )));
            },
            splashColor: Colors.grey.withOpacity(0.3),
            child: Padding(
              padding: EdgeInsets.all(1.0.h),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      feed!.postBlogCategory!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                            AppLocalizations.of(
                              "Read More",
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Icon(Icons.arrow_forward_ios_sharp)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
          )
        ],
      ),
    );
  }
}

class FeedBodyVideo extends StatelessWidget {
  final NewsFeedModel? feed;
  final VoidCallback? doubleTap;
  final VoidCallback? tagTap;
  final List<Sticker>? stickerList;
  final List<Position>? positionList;
  final int? feedindex;
  final List? demoList;
  final url;

  FeedBodyVideo({
    Key? key,
    this.feed,
    this.doubleTap,
    this.tagTap,
    this.stickerList,
    this.positionList,
    this.feedindex,
    this.demoList,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: doubleTap ?? () {},
      child: Container(
        alignment: Alignment.center,
        // width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // AspectRatio(
            //   aspectRatio: feed.postVideoWidth / feed.postVideoHeight,
            Align(
              alignment: Alignment.center,
              child: Container(
                // color: Colors.pink,
                child: FeedsVideoPlayer(
                  stickerList: stickerList!,
                  positionList: positionList!,
                  image: feed!.thumbnailUrl,
                  url: url,
                  // feed.video,
                  // .split("~~")[feedindex],
                  aspect: feed!.postVideoWidth / feed!.postVideoHeight,
                ),
              ),
            ),
            feed!.videoTag == 1 && feed!.videoTaggedDetails != null
                ? Positioned.fill(
                    bottom: 1.5.w,
                    left: 1.5.w,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: InkWell(
                          onTap: tagTap ?? () {},
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: 3.0.h, top: 3.0.h),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      width: 0.1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/images/tag.png",
                                      height: 1.8.h,
                                    ),
                                  )),
                            ),
                          ),
                        )),
                  )
                : Container(),
            feed!.whiteHeartLogo == true
                ? Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/white_heart.png",
                          height: 100,
                        )),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
