// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../services/Properbuz/properbuz_feed_controller.dart';
// import 'package:bizbultest/Language/appLocalization.dart';
// import 'package:bizbultest/services/Properbuz/comments_controller.dart';
// import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
// import 'package:bizbultest/services/current_user.dart';
// import 'package:bizbultest/utilities/colors.dart';
// import 'package:bizbultest/view/Properbuz/detailed_feed_view.dart';
// import 'package:bizbultest/view/Properbuz/properbuz_web_view.dart';
// import 'package:bizbultest/view/Properbuz/tags_feeds_view.dart';
// import 'package:bizbultest/view/profile_page_main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:path/path.dart';
// import 'package:readmore/readmore.dart';
// import 'package:rich_text_view/rich_text_view.dart';
// import 'package:sizer/sizer.dart';

// class FeedLinkCard extends GetView<ProperbuzFeedController> {
//   final int index;
//   final int val;
//   final int maxLines;
//   bool keep = false;
//   var urll = "";

//   FeedLinkCard({Key key, this.index, this.val, this.maxLines})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Get.put(ProperbuzFeedController());
//     // controller.checkLink(urll: url);

//     return GestureDetector(
//       onTap: () {
//         // controller.checkLink(
//         //     urll: controller.getFeedsList(val)[index].description.value);
//         CommentsController commentsController = Get.put(CommentsController());
//         commentsController.getUsers(controller.getFeedsList(val)[index].postId);
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => DetailedFeedView(
//                       feedIndex: 0,
//                       val: val,
//                     )));
//       },
//       // getURLMetadata(buzzerfeedMainController
//       //     .listbuzzerfeeddata[this.userindex].description);
//       // print(
//       //     "-------####-- ${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkDesc}");

//       // (
//       // buzzerfeedMainController
//       //           .listbuzzerfeeddata[this.userindex].linkImages.length ==
//       //       0)
//       //   ? Container(
//       //       height: 0.0,
//       //       width: 0.0,
//       //     )
//       // :
//       // child: Center(
//       //   child: Padding(
//       //     padding: const EdgeInsets.all(8.0),
//       child: Container(
//         height: 250,
//         width: 250,
//         // color: Colors.amber,
//         child: ListView.separated(
//             physics: NeverScrollableScrollPhysics(),
//             separatorBuilder: (context, indexs) => Container(
//                   height: 0.1.h,
//                 ),
//             shrinkWrap: true,
//             itemCount: controller.getFeedsList(val)[index].urlLink.url.length,
//             itemBuilder: (context, indexx) => InkWell(
//                   onTap: () {
//                     // print("-------- ${}");
//                     launch(
//                         '${controller.getFeedsList(val)[index].urlLink.url[indexx]}');
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Card(
//                         elevation: 2.0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(2.0.h))),
//                         child: ClipRRect(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(2.0.h)),
//                           child: Container(
//                               height: 200,
//                               width: 80.0.w,
//                               color: Colors.pink,
//                               child: Column(
//                                 children: [
//                                   controller
//                                               .getFeedsList(val)[index]
//                                               .urlLink
//                                               .image
//                                               .length ==
//                                           0
//                                       ? Text("0o----o0")
//                                       :
//                                       // Card(
//                                       //   elevation: 1.0,
//                                       //   child: Container(
//                                       //     width: 80.0.w,
//                                       //     height: 20.0.h,
//                                       //     child: Image.asset(
//                                       //       'assets/images/buzzfeed.png',
//                                       //       fit: BoxFit.contain,
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                       // :
//                                       CachedNetworkImage(
//                                           imageUrl: controller
//                                               .getFeedsList(val)[index]
//                                               .urlLink
//                                               .image[indexx],
//                                           fit: BoxFit.contain,
//                                         ),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     margin: EdgeInsets.only(left: 1.5.w),
//                                     child: Text(
//                                       '${controller.getFeedsList(val)[index].urlLink.url[indexx]}',
//                                       // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkDesc[index]}',
//                                       maxLines: 3,
//                                       softWrap: true,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                         ),
//                         // leading: CachedNetworkImage(
//                         //   imageUrl: buzzerfeedMainController
//                         //       .listbuzzerfeeddata[this.userindex]
//                         //       .linkImages[index],
//                         //   fit: BoxFit.contain,
//                         // ),
//                       ),
//                     ),
//                   ),
//                 )),
//       ),
//       // ),
//       // ),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   Get.put(ProperbuzFeedController());
//   //   // controller.checkLink(urll: url);

//   //   return GestureDetector(
//   //     onTap: () {
//   //       // controller.checkLink(
//   //       //     urll: controller.getFeedsList(val)[index].description.value);
//   //       CommentsController commentsController = Get.put(CommentsController());
//   //       commentsController.getUsers(controller.getFeedsList(val)[index].postId);
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //               builder: (context) => DetailedFeedView(
//   //                     feedIndex: 0,
//   //                     val: val,
//   //                   )));
//   //     },
//   //     child: Container(
//   //         // width: 100.0.w,/
//   //         // height: 250,
//   //         color: Colors.pink,
//   //         padding: EdgeInsets.symmetric(horizontal: 10),
//   //         child: linkCard()),
//   //   );
//   // }
// }
