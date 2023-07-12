import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/detailed_feed_view.dart';
import 'package:bizbultest/view/Properbuz/properbuz_web_view.dart';
import 'package:bizbultest/view/Properbuz/tags_feeds_view.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:readmore/readmore.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedDescriptionCard extends GetView<ProperbuzFeedController> {
  final int index;
  final int val;
  final int? maxLines;
  bool keep = false;
  var urll = "";

  FeedDescriptionCard(
      {Key? key, required this.index, required this.val, this.maxLines})
      : super(key: key);

  Widget _textDescription(BuildContext context) {
    // print(
    // "------------UrlImag ${controller.getFeedsList(val)[index].urlLink.image}");
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
          text: controller.getFeedsList(val)[index].description!.value ?? "",
          maxLines: maxLines,
          align: TextAlign.center,
          onEmailClicked: (email) => controller.openEmail(email),
          onHashTagClicked: (tag) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TagsFeedsView(tag: tag, keep: false))),
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
          onUrlClicked: (url) {
            // print("-------------------${url}");
            // urll = urll;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProperbuzWebView(url: url)));
          })),
    );
  }

  Widget _readMore() {
    return Obx(
      () => ReadMoreText(
        controller.getFeedsList(val)[index].description!.value,
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

  // Widget linkCard() {
  //   return Container(
  //     height: 250,
  //     width: 250,
  //     color: Colors.amber,
  //     child: ListView.separated(
  //         // physics: NeverScrollableScrollPhysics(),
  //         separatorBuilder: (context, indexs) => Container(
  //               height: 0.1.h,
  //             ),
  //         shrinkWrap: true,
  //         itemCount: controller.getFeedsList(val)[index].urlLink.title.length,
  //         //  controller.getFeedsList(val)[index].urlLink.domain.length,
  //         itemBuilder: (context, indexx) => InkWell(
  //               onTap: () {
  //                 // print("-------- ${}");
  //                 // launch(
  //                 //     '${controller.getFeedsList(val)[index].urlLink.title}');
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => ProperbuzWebView(
  //                             url: controller
  //                                 .getFeedsList(val)[index]
  //                                 .description
  //                                 .value)));
  //               },
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(10.0),
  //                   child: Card(
  //                     elevation: 2.0,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius:
  //                             BorderRadius.all(Radius.circular(2.0.h))),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
  //                       child: Container(
  //                           height: 200,
  //                           width: 80.0.w,
  //                           color: Colors.pink,
  //                           child: Column(
  //                             children: [
  //                               // controller
  //                               //             .getFeedsList(val)[index]
  //                               //             .urlLink
  //                               //             .image
  //                               //             .length ==
  //                               //         0
  //                               //     ? Text("0o----o0")
  //                               //     :
  //                               // Card(
  //                               //   elevation: 1.0,
  //                               //   child: Container(
  //                               //     width: 80.0.w,
  //                               //     height: 20.0.h,
  //                               //     child: Image.asset(
  //                               //       'assets/images/buzzfeed.png',
  //                               //       fit: BoxFit.contain,
  //                               //     ),
  //                               //   ),
  //                               // ),
  //                               // :
  //                               CachedNetworkImage(
  //                                 imageUrl:
  //                                     "https://securemetrics.apple.com/b/ss/applestoreww/1/H.8--NS/0?pageName=No-Script:AOS%3A+home%2Fshop_iphone%2Ffamily%2Fiphone_14_pro%2Fselect",
  //                                 fit: BoxFit.contain,
  //                               ),
  //                               Container(
  //                                 alignment: Alignment.center,
  //                                 margin: EdgeInsets.only(left: 1.5.w),
  //                                 child: Text(
  //                                   "000" +
  //                                       '${controller.getFeedsList(val)[index].urlLink.title.toString()}',
  //                                   // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkDesc[index]}',
  //                                   maxLines: 3,
  //                                   softWrap: true,
  //                                   style:
  //                                       TextStyle(fontWeight: FontWeight.w400),
  //                                 ),
  //                               ),
  //                             ],
  //                           )),
  //                     ),
  //                     // leading: CachedNetworkImage(
  //                     //   imageUrl: buzzerfeedMainController
  //                     //       .listbuzzerfeeddata[this.userindex]
  //                     //       .linkImages[index],
  //                     //   fit: BoxFit.contain,
  //                     // ),
  //                   ),
  //                 ),
  //               ),
  //             )),
  //   );
  //   // ),
  //   // ),
  //   // );
  // }

  Widget _description(BuildContext context) {
    if (controller.getFeedsList(val)[index].description!.value.isNotEmpty ||
        controller.getFeedsList(val)[index].description!.value == null) {
      return Container(child: _textDescription(context));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    // controller.checkLink(urll: url);

    return GestureDetector(
      onTap: () {
        // controller.checkLink(
        //     urll: controller.getFeedsList(val)[index].description.value);
        CommentsController commentsController = Get.put(CommentsController());
        commentsController
            .getUsers(controller.getFeedsList(val)[index].postId!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedFeedView(
                      feedIndex: 0,
                      val: val,
                    )));
      },
      child: Container(
        width: 100.0.w,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: _description(context),
      ),
    );
  }
}
