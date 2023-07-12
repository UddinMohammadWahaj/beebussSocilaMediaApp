import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/properbuz_web_view.dart';
import 'package:bizbultest/view/Properbuz/tags_feeds_view.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/widgets/Properbuz/comments/sub_comments_menu_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:sizer/sizer.dart';

class SubCommentsCard extends GetView<CommentsController> {
  final int? subCommentIndex;
  final int? index;
  final int? val;
  final int? feedIndex;
  final String? postID;

  const SubCommentsCard(
      {Key? key,
      this.index,
      this.val,
      this.feedIndex,
      this.postID,
      this.subCommentIndex})
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
        text: controller
            .commentsList[index!].subComments![subCommentIndex!].comment!.value,
        maxLines: 4,
        align: TextAlign.end,
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

  Widget _imageCard(BuildContext context) {
    return InkWell(
      onTap: () {
        OtherUser().otherUser.memberID = controller
            .commentsList[index!].subComments![subCommentIndex!].memberId
            .toString()
            .replaceAll("@", "");
        OtherUser().otherUser.shortcode = controller
            .commentsList[index!].subComments![subCommentIndex!].shortcode
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
                      otherMemberID: controller.commentsList[index!]
                          .subComments![subCommentIndex!].memberId
                          .toString()
                          .replaceAll("@", ""),
                    )));
      },
      child: Container(
        height: 45,
        width: 45,
        padding: EdgeInsets.only(right: 10),
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(controller
              .commentsList[index!].subComments![subCommentIndex!].image!),
          backgroundColor: settingsColor,
          foregroundColor: settingsColor,
        ),
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
              InkWell(
                onTap: () {
                  OtherUser().otherUser.memberID = controller
                      .commentsList[index!]
                      .subComments![subCommentIndex!]
                      .memberId
                      .toString()
                      .replaceAll("@", "");
                  OtherUser().otherUser.shortcode = controller
                      .commentsList[index!]
                      .subComments![subCommentIndex!]
                      .shortcode
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
                                otherMemberID: controller.commentsList[index!]
                                    .subComments![subCommentIndex!].memberId
                                    .toString()
                                    .replaceAll("@", ""),
                              )));
                },
                child: Text(
                  controller.commentsList[index!].subComments![subCommentIndex!]
                      .name!,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                controller.commentsList[index!].subComments![subCommentIndex!]
                    .designation!,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600),
              ),
              Text(
                controller
                    .commentsList[index!].subComments![subCommentIndex!].time!,
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
              Get.bottomSheet(
                  SubCommentsMenuSheet(
                    subCommentIndex: subCommentIndex!,
                    feedIndex: feedIndex!,
                    val: val!,
                    index: index!,
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
          width: 100.0.w - (20 + 45 + 55),
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
        child: controller.commentsList[index!].subComments![subCommentIndex!]
                    .likes!.value ==
                0
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
                      "${controller.commentsList[index!].subComments![subCommentIndex!].likes!.value.toString()} ${controller.likesStringSubComment(index!, subCommentIndex!)}",
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
            () => controller.likeSubComment(index!, subCommentIndex!, postID!),
            controller.getLikeColorSubComment(index!, subCommentIndex!))),
        _likesInfoCard(),
        Container(
          width: 1,
          color: Colors.grey.shade800,
          height: 12,
        ),
        _customLikeButton(
            "Reply",
            () => controller.onTapSubCommentReply(
                context,
                postID!,
                controller.commentsList[index!].commentID!,
                index!,
                controller.commentsList[index!].shortcode!),
            Colors.grey.shade800)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CommentsController());
    return Container(
      padding: EdgeInsets.only(right: 0, left: 55),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_imageCard(context), _commentContainer(context)],
        ),
      ),
    );
  }
}
