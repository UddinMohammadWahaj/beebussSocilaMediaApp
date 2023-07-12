import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/properbuz_web_view.dart';
import 'package:bizbultest/view/Properbuz/tags_feeds_view.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/widgets/Properbuz/comments/comments_menu_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/comments/sub_comments_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:sizer/sizer.dart';

class CommentsCard extends GetView<CommentsController> {
  final int index;
  final int val;
  final int? feedIndex;
  final String? postID;

  const CommentsCard(
      {Key? key,
      required this.index,
      required this.val,
      this.feedIndex,
      this.postID})
      : super(key: key);

  Widget _commentDescription(BuildContext context) {
    return Obx(
      () => RichTextView(
        selectable: false,
        linkStyle: TextStyle(
            fontWeight: FontWeight.w500, color: settingsColor, fontSize: 14.5),
        boldStyle: TextStyle(
            fontWeight: FontWeight.normal, color: Colors.grey.shade600),
        style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade900,
            fontSize: 14.5),
        text: controller.commentsList[index].comment!.value,
        maxLines: 4,
        align: TextAlign.center,
        onEmailClicked: (email) => controller.openEmail(email),
        onHashTagClicked: (tag) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => TagsFeedsView(tag: tag))),
        onMentionClicked: (value) {
          OtherUser().otherUser.memberID = value.toString().replaceAll("@", "");
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
      ),
    );
  }

  Widget _imageCard() {
    return Container(
      height: 45,
      width: 45,
      padding: EdgeInsets.only(right: 10),
      child: CircleAvatar(
        backgroundImage:
            CachedNetworkImageProvider(controller.commentsList[index].image!),
        backgroundColor: settingsColor,
        foregroundColor: settingsColor,
      ),
    );
  }

  Widget _userInfoCard(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: GestureDetector(
                onTap: () {
                  OtherUser().otherUser.memberID = controller
                      .commentsList[index].memberId
                      .toString()
                      .replaceAll("@", "");
                  OtherUser().otherUser.shortcode = controller
                      .commentsList[index].shortcode
                      .toString()
                      .replaceAll("@", "");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePageMain(
                                from: "tags",
                                setNavBar: () {},
                                isChannelOpen: () {},
                                changeColor: () {},
                                otherMemberID: controller
                                    .commentsList[index].memberId
                                    .toString()
                                    .replaceAll("@", ""),
                              )));
                },
                child: Text(
                  controller.commentsList[index].name!,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              )),
              Text(
                controller.commentsList[index].designation!,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600),
              ),
              Text(
                controller.commentsList[index].time!,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600),
              ),
            ],
          ),
          IconButton(
            constraints: BoxConstraints(),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            splashRadius: 20,
            icon: Icon(
              Icons.more_vert_outlined,
              size: 20,
              color: Colors.grey.shade800,
            ),
            onPressed: () {
              print(controller.commentsList[index].commentID);
              Get.bottomSheet(
                  CommentsMenuSheet(
                    feedIndex: feedIndex!,
                    val: val,
                    index: index,
                  ),
                  backgroundColor: Colors.white);
            },
          ),
        ],
      ),
    );
  }

  Widget _commentContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            shape: BoxShape.rectangle,
          ),
          width: 100.0.w - (20 + 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userInfoCard(context),
              SizedBox(
                height: 10,
              ),
              _commentDescription(context)
            ],
          ),
        ),
        _actionRow(context)
      ],
    );
  }

  Widget _customLikeButton(String title, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 13, color: color, fontWeight: FontWeight.w500),
          )),
    );
  }

  Widget _likesInfoCard() {
    return Obx(
      () => SizedBox(
        child: controller.commentsList[index].likes!.value == 0
            ? Container()
            : Container(
                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        "•",
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ),
                    Text(
                      "${controller.commentsList[index].likes!.value.toString()} ${controller.likesStringComment(index)}",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _repliesInfoCard() {
    return Obx(
      () => SizedBox(
        child: controller.commentsList[index].replies!.value == 0
            ? Container()
            : Container(
                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        "•",
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ),
                    Text(
                      "${controller.commentsList[index].replies!.value.toString()} ${controller.replyStringComment(index)}",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _actionRow(BuildContext context) {
    return Row(
      children: [
        Obx(() => _customLikeButton(
            "Like",
            () => controller.likeComment(index, postID!),
            controller.getLikeColorComment(index))),
        _likesInfoCard(),
        Container(
          width: 1,
          color: Colors.grey.shade800,
          height: 12,
        ),
        _customLikeButton(
            "Reply",
            () => controller.onTapCommentReply(context, postID!,
                controller.commentsList[index].commentID!, index),
            Colors.grey.shade800),
        _repliesInfoCard()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CommentsController());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            // onTap: () {
            //   OtherUser().otherUser.memberID = controller
            //       .commentsList[index].memberId
            //       .toString()
            //       .replaceAll("@", "");
            //   OtherUser().otherUser.shortcode = controller
            //       .commentsList[index].shortcode
            //       .toString()
            //       .replaceAll("@", "");
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ProfilePageMain(
            //                 from: "tags",
            //                 setNavBar: () {},
            //                 isChannelOpen: () {},
            //                 changeColor: () {},
            //                 otherMemberID: controller
            //                     .commentsList[index].memberId
            //                     .toString()
            //                     .replaceAll("@", ""),
            //               )));
            // },
            child: Container(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        OtherUser().otherUser.memberID = controller
                            .commentsList[index].memberId
                            .toString()
                            .replaceAll("@", "");
                        OtherUser().otherUser.shortcode = controller
                            .commentsList[index].shortcode
                            .toString()
                            .replaceAll("@", "");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePageMain(
                                      from: "tags",
                                      setNavBar: () {},
                                      isChannelOpen: () {},
                                      changeColor: () {},
                                      otherMemberID: controller
                                          .commentsList[index].memberId
                                          .toString()
                                          .replaceAll("@", ""),
                                    )));
                      },
                      child: _imageCard(),
                    ),
                  ),
                  _commentContainer(context)
                ],
              ),
            ),
          ),
          Obx(
            () => Container(
                child: controller.commentsList[index].hasSubComments!.value
                    ? Container(
                        child: Obx(
                          () => ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller
                                  .commentsList[index].subComments!.length,
                              itemBuilder: (context, ind) {
                                return SubCommentsCard(
                                  feedIndex: feedIndex!,
                                  index: index,
                                  subCommentIndex: ind,
                                  postID: postID!,
                                  val: val,
                                );
                              }),
                        ),
                      )
                    : Container()),
          ),
        ],
      ),
    );
  }
}
