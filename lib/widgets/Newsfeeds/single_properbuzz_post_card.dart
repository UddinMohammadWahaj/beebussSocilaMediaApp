// import 'package:bizbultest/models/Properbuz/properbuz_feeds_model.dart';
// import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
// import 'package:bizbultest/view/Properbuz/detailed_feed_view.dart';
// import 'package:bizbultest/widgets/Properbuz/feeds/user_header_card.dart';
// import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:readmore/readmore.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/Properbuz/properbuz_feed_controller.dart';
import '../../Language/appLocalization.dart';
import '../../models/Properbuz/properbuz_feeds_model.dart';
import '../../models/feeds_hashtag_model.dart';
import '../../services/Properbuz/api/properbuz_feeds_api.dart';
import '../../services/Properbuz/comments_controller.dart';
import '../../services/current_user.dart';
import '../../utilities/colors.dart';
import '../../utilities/custom_icons.dart';
import '../../utilities/deep_links.dart';
import '../../view/Properbuz/detailed_video_view.dart';
import '../../view/Properbuz/new_message_screen.dart';
import '../../view/Properbuz/properbuz_web_view.dart';
import '../../view/Properbuz/tags_feeds_view.dart';
import '../../view/newsfeed_likes_page.dart';
import '../../view/profile_page_main.dart';
// import 'engagement_card.dart';
// import 'feed_actions_row.dart';
// import 'feed_description_card.dart';
// import 'feed_media_card.dart';
// import 'like_status_card.dart';
// import 'user_header_card.dart';

class SingleProperbuzFeedPostCard extends StatelessWidget {
  final List<ProperbuzFeedsModel>? feed;
  final int? maxLines;
  // final bool showMenu;
  // final bool navigate;
  // final Function setNavbar;
  // final Function changeColor;
  // final Function isChannelOpen;

  SingleProperbuzFeedPostCard({
    Key? key,
    this.feed,
    this.maxLines,
    // this.showMenu,
    // this.navigate,
    // this.setNavbar,
    // this.changeColor,
    // this.isChannelOpen
  }) : super(key: key);

  RxInt selectIndex = 0.obs;

  Widget _userImageCard() {
    return CircleAvatar(
      radius: 22,
      foregroundColor: featuredColor,
      backgroundColor: featuredColor,
      backgroundImage: CachedNetworkImageProvider(feed![0].memberProfile!),
    );
  }

  Widget _userNameCard() {
    return Text(
      feed![0].memberName!,
      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
    );
  }

  Widget _userDescriptionCard() {
    return Text(
      "",
      // AppLocalizations.of(feed[0].description.value),
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _timeStampCard() {
    return Text(
      feed![0].createdAt!,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _moreCard() {
    return IconButton(
      splashRadius: 20,
      constraints: BoxConstraints(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      onPressed: () {
        // Get.bottomSheet(
        //   MenuBottomSheet(
        //     goBack: false,
        //     index: index,
        //     val: val,
        //   ),
        //   isScrollControlled: true,
        //   backgroundColor: Colors.white,
        // );
      },
      icon: Icon(Icons.more_vert_outlined),
      color: Colors.black,
    );
  }

  Widget ussercard(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                OtherUser().otherUser.memberID =
                    feed![0].memberId.toString().replaceAll("@", "");
                OtherUser().otherUser.shortcode =
                    feed![0].shortcode.toString().replaceAll("@", "");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePageMain(
                              from: "tags",
                              setNavBar: () {},
                              isChannelOpen: () {},
                              changeColor: () {},
                              otherMemberID: feed![0]
                                  .memberId
                                  .toString()
                                  .replaceAll("@", ""),
                            )));
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    _userImageCard(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _userNameCard(),
                          // _userDescriptionCard(),
                          _timeStampCard()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // showMenu ? _moreCard() : Container()
          ],
        ));
  }
// -----------------------------------FeedDescriptionCard---------------------------

  void openEmail(String email) async {
    final url = Uri.encodeFull('mailto:$email?subject=&body=');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _textDescription(BuildContext context) {
    return Container(
      child: Obx(() => RichTextView(
            selectable: false,
            linkStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: settingsColor,
                fontSize: 14.5),
            boldStyle: TextStyle(
                fontWeight: FontWeight.normal, color: Colors.grey.shade600),
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade900,
                fontSize: 14.5),
            text: feed![0].description!.value ?? "",
            maxLines: maxLines,
            align: TextAlign.center,
            onEmailClicked: (email) => openEmail(email),
            onHashTagClicked: (tag) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TagsFeedsView(tag: tag, keep: false))),
            onMentionClicked: (value) {
              OtherUser().otherUser.memberID =
                  value.toString().replaceAll("@", "");
              OtherUser().otherUser.shortcode =
                  value.toString().replaceAll("@", "");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePageMain(
                            from: "tags",
                            setNavBar: () {},
                            isChannelOpen: () {},
                            changeColor: () {},
                            otherMemberID: value.toString().replaceAll("@", ""),
                          )));
            },
            onUrlClicked: (url) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProperbuzWebView(url: url))),
          )),
    );
  }

  Widget _readMore() {
    return Obx(
      () => ReadMoreText(
        feed![0].description!.value,
        trimLines: maxLines!,
        colorClickableText: Colors.grey.shade500,
        trimMode: TrimMode.Line,
        trimCollapsedText: AppLocalizations.of(
          'see more',
        ),
        trimExpandedText: AppLocalizations.of(
          'see less',
        ),
        style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade900,
            fontSize: 14.5),
        moreStyle: TextStyle(
            fontWeight: FontWeight.normal, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _description(BuildContext context) {
    if (feed![0].description!.value.isNotEmpty ||
        feed![0].description!.value == null) {
      return Container(child: _textDescription(context));
    } else {
      return Container();
    }
  }

  Widget FeedDescriptionCard(BuildContext context) {
    // Get.put(ProperbuzFeedController());
    return GestureDetector(
      onTap: () {
        // CommentsController commentsController = Get.put(CommentsController());
        // commentsController.getUsers(controller.getFeedsList(val)[index].postId);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => DetailedFeedView(
        //           feedIndex: index,
        //           val: val,
        //         )));
      },
      child: Container(
          width: 100.0.w,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _description(context)),
    );
  }
// -----------------------------------FeedMediaCard---------------------------

  Widget _customURLInfoCard(String domain) {
    return Container(
      color: Colors.grey.shade100,
      child: ListTile(
        contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10),
        title: Text(
          AppLocalizations.of(
            feed![0].video!.urlCaption!,
          ),
          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          domain,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _singleImageCard(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DetailedImageView(index: index, val: val),
      //   ),
      // ),
      child: Container(
        color: Colors.transparent,
        child: Image(
          image: CachedNetworkImageProvider(feed![0].images![0]),
          fit: BoxFit.cover,
          width: 100.0.w,
          height: 40.0.h,
        ),
      ),
    );
  }

  Widget _customImageCard(String image, double width) {
    return Container(
      constraints: BoxConstraints(maxHeight: 60.0.h, minHeight: 40.0.h),
      width: width,
      child: Image(
        image: CachedNetworkImageProvider(image),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _multipleImagesCard(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DetailedImageView(index: index, val: val),
      //   ),
      // ),
      child: Container(
          width: 100.0.w,
          color: Colors.transparent,
          constraints: BoxConstraints(maxHeight: 60.0.h, minHeight: 40.0.h),
          child: Column(
            children: [
              Container(
                  height: 55.h,
                  child:
                      // Obx(
                      //   () =>
                      PageView.builder(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int value) {
                      selectIndex.value = value;
                      // // ctr.update();
                    },
                    itemCount: feed![0].images!.length,
                    itemBuilder: (context, index1) {
                      return _customImageCard(
                        feed![0].images![index1],
                        100.0.w - 1.0,
                      );
                    },
                    // ),
                  )),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  feed![0].images!.length,
                  (index2) {
                    return Obx(() => index2 == selectIndex.value
                        ? _indicator(true)
                        : _indicator(false));
                  },
                ),
              )
            ],
          )
          // Row(
          //   children: [
          //     _customImageCard(
          //         controller.getFeedsList(val)[index].images[0], 50.0.w - 1.0),
          //     SizedBox(
          //       width: 2,
          //     ),
          //     _customImageCard(
          //         controller.getFeedsList(val)[index].images[1], 50.0.w - 1.0),
          //   ],
          // ),
          ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < feed![0].images!.length; i++) {
      list.add(i == selectIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.black.withOpacity(.5) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  Widget _videoCard(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => DetailedVideoView(index: index, val: val))),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            _customImageCard(feed![0].video!.videoThumb!, 100.0.w),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void openYouTube() async {
    String url = feed![0].video!.videoUrl!;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _youtubeCard() {
    return GestureDetector(
      onTap: () => openYouTube(),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Stack(
              children: [
                _customImageCard(feed![0].video!.videoThumb!, 100.0.w),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.red.shade800,
                        shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _customURLInfoCard("youtube.com")
          ],
        ),
      ),
    );
  }

  Widget _bebuzeeVideoCard() {
    return Column(
      children: [
        Stack(
          children: [
            _customImageCard(feed![0].video!.videoThumb!, 100.0.w),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        _customURLInfoCard("bebuzee.com")
      ],
    );
  }

  Widget _urlCard(BuildContext context) {
    return GestureDetector(
        // onTap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             ProperbuzWebView(url: feed[0].urlLink.url))),
        // child: Container(
        //   color: Colors.transparent,
        //   child: Column(
        //     children: [
        //       Container(
        //         height: 250,
        //         width: 100.0.w,
        //         child: Image(
        //           image: CachedNetworkImageProvider(feed[0].urlLink.image),
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //       Container(
        //         color: Colors.grey.shade100,
        //         child: ListTile(
        //           contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10),
        //           title: Text(
        //             AppLocalizations.of(
        //               feed[0].urlLink.title,
        //             ),
        //             style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
        //           ),
        //           subtitle: Text(
        //             feed[0].urlLink.domain,
        //             style: TextStyle(
        //                 fontSize: 13,
        //                 fontWeight: FontWeight.normal,
        //                 color: Colors.grey.shade600),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        );
  }

  Widget _mediaCard(BuildContext context) {
    switch (feed![0].postType) {
      case "image":
        return _singleImageCard(context);
        break;
      case "video":
        return _videoCard(context);
        break;
      case "multiple":
        return _multipleImagesCard(context);
        break;
      case "youtube":
        return _youtubeCard();
        break;
      case "bebuzee":
        return _bebuzeeVideoCard();
        break;
      case "full_url":
        return _urlCard(context);
        break;
      default:
        return Container();
        break;
    }
  }

  Widget FeedMediaCard(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: feed![0].description!.value.isNotEmpty ? 8 : 0),
      child: _mediaCard(context),
    );
  }

// -----------------------------------EngagementCard---------------------------

  Widget _customEngagementCard(String value, String number) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 14,
              color: settingsColor,
              fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  Widget _boostButton(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => BoostFeedPost(
      //               postID: controller.getFeedsList(val)[index].postId,
      //             ))),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: new BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 1.2,
            ),
          ),
          child: Text(
            AppLocalizations.of(
              "Boost Post",
            ),
            style: TextStyle(color: hotPropertiesThemeColor),
          )),
    );
  }

  Widget EngagementCard(BuildContext context) {
    // if (feed[0].boostStatus) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _customEngagementCard(
              AppLocalizations.of(
                "People Reached",
              ),
              feed![0].boostData!.peopleReached.toString()),
          _customEngagementCard(
              AppLocalizations.of(
                "Engagements",
              ),
              feed![0].boostData!.engagements.toString()),
          _boostButton(context)
        ],
      ),
    );
    // } else {
    // return Container();
    // }
  }

// -----------------------------------LikeStatusCard---------------------------

  String likesString() {
    switch (feed![0].totalLike!.value) {
      case 1:
        return AppLocalizations.of("Like");
        break;

      default:
        return AppLocalizations.of("Likes");
        break;
    }
  }

  String commentString() {
    switch (feed![0].totalComment!.value) {
      case 1:
        return AppLocalizations.of("Comment");
        break;

      default:
        return AppLocalizations.of("Comments");
        break;
    }
  }

  Widget LikeStatusCard(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Row(
      children: [
        Obx(
          () => Container(
            width: 50.0.w,
            color: Colors.transparent,
            child: feed![0].totalLike!.value == 0
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
                                              setNavBar: () {},
                                              isChannelOpen: () {},
                                              changeColor: () {},
                                              postID: feed![0].postId,
                                              postType: feed![0].postType,
                                            )));
                              },
                              child: Text(
                                AppLocalizations.of(
                                    feed![0].totalLike!.value.toString() +
                                        " " +
                                        likesString()),
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
            child: feed![0].totalComment!.value == 0
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() => Text(
                              feed![0].totalComment!.value.toString() +
                                  " " +
                                  commentString(),
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

// -----------------------------------FeedActionsRow---------------------------

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

  void likeUnlike() {
    feed![0].liked!.value = !feed![0].liked!.value;
    ProperbuzFeedsAPI.likeUnlike(feed![0].postId!).then((value) {
      feed![0].totalLike!.value = value;
    });
  }

  Widget _likeButton() {
    return Obx(
      () => InkWell(
        onTap: () => likeUnlike(),
        child: Container(
          width: 100.0.w / 4,
          padding: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Icon(
                feed![0].liked!.value
                    ? Icons.thumb_up
                    : Icons.thumb_up_alt_outlined,
                color: feed![0].liked!.value
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
                    color: feed![0].liked!.value
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

  void navigateToComment(bool navigate, BuildContext context) async {
    if (navigate) {
      CommentsController commentsController = Get.put(CommentsController());
      commentsController.getUsers(feed![0].postId!);
      commentsController.getComments(feed![0].postId!);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => SingleProperbuzFeedPostCard()));
    } else {
      await SystemChannels.textInput.invokeMethod('TextInput.show');
      FocusScope.of(context).nextFocus();
    }
  }

  void sharePost() async {
    ProperbuzFeedsModel feed1 = ProperbuzFeedsModel();
    feed1 = feed![0];
    Uri uri = await DeepLinks.createPropberbuzPostDeepLink(
        feed1.memberId!,
        "properbuz_feed",
        feed1.memberProfile!,
        feed1.description!.value,
        feed1.shortcode!,
        feed1.postId!);
    Share.share(
      '${uri.toString()}',
    );
  }

  @override
  Widget FeedActionsRow(BuildContext context) {
    // Get.put(ProperbuzFeedController());
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
                    () => navigateToComment(true, context)),
                _actionButton(
                    CupertinoIcons.arrow_turn_up_right,
                    AppLocalizations.of(
                      "Share",
                    ),
                    () => sharePost()),
                _actionButton(
                    CustomIcons.plane_thick,
                    AppLocalizations.of(
                      "Direct",
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewMessageScreen(
                                  postId: feed![0].postId,
                                )))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ussercard(context),
          FeedDescriptionCard(context),
          FeedMediaCard(context),
          EngagementCard(context),
          LikeStatusCard(context),
          FeedActionsRow(context)
        ],
      ),
    );
  }
}
