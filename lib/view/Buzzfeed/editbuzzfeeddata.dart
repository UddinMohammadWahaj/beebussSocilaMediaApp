// import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedEditcontroller.dart';
// import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
// import 'package:bizbultest/services/current_user.dart';
// import 'package:bizbultest/utilities/loading_indicator.dart';
// import 'package:bizbultest/view/Buzzfeed/buzzfeedplayer.dart';
// import 'package:bizbultest/view/Buzzfeed/buzzfeedpoll.dart';
// import 'package:bizbultest/widgets/Chat/group_chat_card.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_parsed_text/flutter_parsed_text.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_parsed_text/flutter_parsed_text.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:polls/polls.dart';
// import 'package:sizer/sizer.dart';
// import 'package:skeleton_text/skeleton_text.dart';
// import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;

// import 'BuzzerfeedEditvideoplayer.dart';
// import 'buzzfeedexpandedimage.dart';
// import 'buzzfeednetworkvideoplayer.dart';
// import 'buzzfeedpostupload.dart';

// // class MainApp extends StatefulWidget {
// //   @override
// //   _MainAppState createState() => _MainAppState();
// // }

// // class _MainAppState extends State<MainApp> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final parse = <MatchText>[
// //       MatchText(
// //           type: ParsedType.EMAIL,
// //           style: TextStyle(
// //             color: Colors.red,
// //             fontSize: 24,
// //           ),
// //           onTap: (url) {
// //             launch("mailto:" + url);
// //           }),
// //       MatchText(
// //           type: ParsedType.URL,
// //           style: TextStyle(
// //             color: Colors.blue,
// //             fontSize: 24,
// //           ),
// //           onTap: (url) async {
// //             var a = await canLaunch(url);

// //             if (a) {
// //               launch(url);
// //             }
// //           }),
// //       MatchText(
// //           type: ParsedType.PHONE,
// //           style: TextStyle(
// //             color: Colors.red,
// //             fontSize: 24,
// //           ),
// //           onTap: (url) {
// //             launch("tel:" + url);
// //           }),
// //       MatchText(
// //         type: ParsedType.CUSTOM,
// //         pattern:
// //             r"^(?:http|https):\/\/[\w\-_]+(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
// //         style: TextStyle(color: Colors.lime),
// //         onTap: (url) => print(url),
// //       ),
// //       MatchText(
// //           type: ParsedType.CUSTOM,
// //           pattern:
// //               "(---( )?(`)?spoiler(`)?( )?---)\n\n(.*?)\n( )?(---( )?(`)?spoiler(`)?( )?---)",
// //           style: TextStyle(
// //             color: Colors.purple,
// //             fontSize: 50,
// //           ),
// //           onTap: (url) {
// //             launch("tel:" + url);
// //           }),
// //       MatchText(
// //         pattern: r"\[(@[^:]+):([^\]]+)\]",
// //         style: TextStyle(
// //           color: Colors.green,
// //           fontSize: 24,
// //         ),
// //         renderText: ({pattern, str}) {
// //           RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
// //           Match match = customRegExp.firstMatch(str);

// //           print('test test: ${match[1]}');
// //           // return Container(
// //           //   padding: EdgeInsets.all(5.0),
// //           //   color: Colors.amber,
// //           //   child: Text(match[1]!),
// //           // );
// //           //
// //           return {'display': match[1]};
// //         },
// //         onTap: (url) {
// //           showDialog(
// //             context: context,
// //             builder: (BuildContext context) {
// //               Map<String, String> map = Map<String, String>();
// //               RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
// //               Match match = customRegExp.firstMatch(url);
// //               // return object of type Dialog
// //               return AlertDialog(
// //                 title: new Text("Mentions clicked"),
// //                 content: new Text("${match.group(1)} clicked."),
// //                 actions: <Widget>[
// //                   // usually buttons at the bottom of the dialog
// //                   new FlatButton(
// //                     child: new Text("Close"),
// //                     onPressed: () {},
// //                   ),
// //                 ],
// //               );
// //             },
// //           );
// //         },
// //         // onLongTap: (url) {
// //         //   print('long press');
// //         // },
// //       ),
// //       MatchText(
// //         pattern: r"\B#+([\w]+)\b",
// //         style: TextStyle(
// //           color: Colors.pink,
// //           fontSize: 24,
// //         ),
// //         onTap: (url) async {
// //           showDialog(
// //             context: context,
// //             builder: (BuildContext context) {
// //               // return object of type Dialog
// //               return AlertDialog(
// //                 title: new Text("Hashtag clicked"),
// //                 content: new Text("$url clicked."),
// //                 actions: <Widget>[
// //                   // usually buttons at the bottom of the dialog
// //                   new FlatButton(
// //                     child: new Text("Close"),
// //                     onPressed: () {},
// //                   ),
// //                 ],
// //               );
// //             },
// //           );
// //         },
// //         // onLongTap: (url) {
// //         //   print('long press');
// //         // },
// //       ),
// //       MatchText(
// //           pattern: r"lon",
// //           style: TextStyle(
// //             color: Colors.pink,
// //             fontSize: 24,
// //           ),
// //           onTap: (url) async {})
// //     ];
// //     return Scaffold(
// //       appBar: AppBar(),
// //       body: Column(
// //         children: <Widget>[
// //           SizedBox(
// //             height: 40.0,
// //           ),
// //           // Padding(
// //           //   padding: const EdgeInsets.all(8.0),
// //           //   child: ParsedText(
// //           //     alignment: TextAlign.start,
// //           //     text:
// //           //         "[@michael:51515151] Hello  --- spoiler ---\n\n spoiler content \n--- spoiler ---\n  https://172.0.0.1 london this is https://apps.apple.com/id/app/facebook/id284882215  an example of the ParsedText, links like http://www.google.com or http://www.facebook.com are clickable and phone number 444-555-6666 can call too. But you can also do more with this package, for example Bob will change style and David too.\nAlso a US number example +1-(800)-831-1117. foo@gmail.com And the magic number is 42! #flutter #flutterdev",
// //           //     parse: [],
// //           //     style: TextStyle(
// //           //       fontSize: 24,
// //           //       color: Colors.black,
// //           //     ),
// //           //   ),
// //           // ),
// //           FormattedText("hello @FAYEED hello")
// //         ],
// //       ),
// //     );
// //   }
// // }

// class FormattedText extends StatelessWidget {
//   final String text;
//   final TextStyle style;
//   final TextAlign textAlign;
//   final TextDirection textDirection;
//   final TextOverflow overflow;
//   final int maxLines;

//   final parse = <MatchText>[
//     MatchText(
//       pattern: r"@([a-z][a-z0-9_]{4,31})",
//       renderWidget: ({pattern, text}) => Text(
//         text,
//         textDirection: TextDirection.ltr,
//         style: TextStyle(
//           color: Colors.blue,
//           fontFamily: 'HelveticaNeue',
//           fontSize: 3.0.h,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       onTap: (String username) {
//         print('Text=${username.substring(1)}');
//       },
//     ),
//     MatchText(
//       pattern: r"#([a-z][a-z0-9_]{4,31})",
//       renderWidget: ({pattern, text}) => Text(
//         text,
//         textDirection: TextDirection.ltr,
//         style: TextStyle(
//           color: Colors.blue,
//           fontFamily: 'HelveticaNeue',
//           fontSize: 3.0.h,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       onTap: (String username) {
//         print('Text=${username.substring(1)}');
//       },
//     ),
//   ];

//   FormattedText(
//     this.text, {
//     Key key,
//     this.style,
//     this.textAlign,
//     this.textDirection,
//     this.overflow,
//     this.maxLines,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final defaultTextStyle = DefaultTextStyle.of(context);

//     return ParsedText(
//       text: text,
//       onTap: () {
//         print("tapped text");
//       },
//       style: TextStyle(
//               // fontFamily: 'HelveticaNeue',
//               fontSize: 3.0.h,
//               fontWeight: FontWeight.w300,
//               color: Colors.black) ??
//           TextStyle(
//               fontFamily: 'HelveticaNeue',
//               fontSize: 3.0.h,
//               fontWeight: FontWeight.w300,
//               color: Colors.black),
//       alignment: TextAlign.start,
//       textDirection: textDirection ?? Directionality.of(context),
//       overflow: TextOverflow.clip,
//       maxLines: maxLines ?? defaultTextStyle.maxLines,
//       parse: parse,
//       regexOptions: RegexOptions(caseSensitive: false),
//     );
//   }
// }

// class BuzzerfeedEdit extends StatefulWidget {
//   var description;
//   String avatar;
//   String username;
//   String name;
//   String timeAgo;

//   String comments;
//   String retweets;
//   String favorites;
//   bool likeStatus;
//   BuzzerfeedMainController buzzerfeedMainController;
//   int userindex;
//   String posttype;

//   BuzzerfeedEdit(
//       {Key key,
//       this.description,
//       this.buzzerfeedMainController,
//       this.avatar,
//       this.comments,
//       this.favorites,
//       this.likeStatus,
//       this.name,
//       this.posttype,
//       this.retweets,
//       this.timeAgo,
//       this.userindex,
//       this.username})
//       : super(key: key);

//   @override
//   State<BuzzerfeedEdit> createState() => _BuzzerfeedEditState();
// }

// class _BuzzerfeedEditState extends State<BuzzerfeedEdit> {
//   var postusername = "${CurrentUser().currentUser.fullName}";
//   BuzzerfeedEditController controller;

//   @override
//   void initState() {
//     controller = Get.put(BuzzerfeedEditController(
//         buzzerfeedId: widget.buzzerfeedMainController
//             .listbuzzerfeeddata[widget.userindex].buzzerfeedId));
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget expandedHeader() {
//       return ListTile(
//         leading: CircleAvatar(
//             maxRadius: 8.0.w,
//             backgroundImage: CachedNetworkImageProvider(
//               (widget.buzzerfeedMainController
//                           .listbuzzerfeeddata[widget.userindex].memberId ==
//                       CurrentUser().currentUser.memberID)
//                   ? CurrentUser().currentUser.image
//                   : widget.buzzerfeedMainController
//                       .listbuzzerfeeddata[widget.userindex].userPicture,
//             )),
//         title: Text('${widget.username}'),
//         subtitle: Text('@${widget.name}'),
//       );
//     }

//     Widget commentgifCard(index) {
//       return Container(
//         width: 75.0.w,
//         height: 25.0.h,
//         child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: CachedNetworkImage(
//               placeholder: (context, url) => SkeletonAnimation(
//                 child: Container(
//                   width: 75.0.w,
//                   height: 25.0.h,
//                   color: Colors.grey[300],
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               imageUrl: controller.commentList[index].images[0],
//               fit: BoxFit.cover,
//             )),
//       );
//     }

//     Widget gifCard() {
//       return InkWell(
//         onTap: () {
//           Navigator.of(Get.context).push(MaterialPageRoute(
//             builder: (context) => BuzzfeedExpandedImage(
//               listofimages: widget.buzzerfeedMainController
//                   .listbuzzerfeeddata[widget.userindex].images,
//               index: 0,
//             ),
//           ));
//         },
//         child: Container(
//           width: 95.0.w,
//           height: 45.0.h,
//           // margin: EdgeInsets.only(left: 2.0.w),
//           child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: CachedNetworkImage(
//                 placeholder: (context, url) => SkeletonAnimation(
//                   child: Container(
//                     width: 85.0.w,
//                     height: 35.0.h,
//                     color: Colors.grey[300],
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 imageUrl: widget.buzzerfeedMainController
//                     .listbuzzerfeeddata[widget.userindex].images[0],
//                 fit: BoxFit.cover,
//               )),
//         ),
//       );
//     }

//     Widget dateBar() {
//       return Container(
//         margin: EdgeInsets.symmetric(horizontal: 2.0.w),
//         child: Row(
//           children: [
//             Text(
//               '${widget.timeAgo}',
//               style: TextStyle(
//                   fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w900),
//             ),
//             // SizedBox(
//             //   width: 2.0.w,
//             // ),
//             // Text(
//             //   '20 Apr 22',
//             //   style: TextStyle(
//             //       fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w900),
//             // ),
//             // SizedBox(
//             //   width: 2.0.w,
//             // ),
//             FormattedText(' @${widget.name}')
//           ],
//         ),
//       );
//     }

//     Widget buzzdetails() {
//       return Container(
//         height: 5.0.h,
//         margin: EdgeInsets.symmetric(horizontal: 2.0.w),
//         width: Get.width,
//         child: Row(
//           children: [
//             TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   '${widget.buzzerfeedMainController.listbuzzerfeeddata[widget.userindex].totalReBuzzerfeed} Retweets',
//                   style: TextStyle(
//                       fontFamily: 'HelveticaNeue',
//                       color: Colors.black,
//                       fontSize: 2.0.h,
//                       fontWeight: FontWeight.bold),
//                 )),
//             SizedBox(
//               width: 2.0.w,
//             ),
//             TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   '${widget.buzzerfeedMainController.listbuzzerfeeddata[widget.userindex].quotes.length} Quote Tweets',
//                   style: TextStyle(
//                       fontFamily: 'HelveticaNeue',
//                       color: Colors.black,
//                       fontSize: 2.0.h,
//                       fontWeight: FontWeight.bold),
//                 )),
//             TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   '${widget.buzzerfeedMainController.listbuzzerfeeddata[widget.userindex].totalLikes} Likes',
//                   style: TextStyle(
//                       fontFamily: 'HelveticaNeue',
//                       color: Colors.black,
//                       fontSize: 2.0.h,
//                       fontWeight: FontWeight.bold),
//                 ))
//           ],
//         ),
//       );
//     }

//     Widget videoCard() {
//       print(
//           "current video=${widget.buzzerfeedMainController.listbuzzerfeeddata[widget.userindex].video}");

//       return InkWell(
//         onTap: () {},
//         child: ClipRRect(
//             borderRadius: BorderRadius.circular(2.0.w),
//             child:
//                 //  DiscoverVideoPlayer(
//                 //   url:
//                 //       buzzerfeedMainController.listbuzzerfeeddata[this.userindex].video,
//                 // )
//                 BuzzfeedNetworkVideoPlayer(
//               url: widget.buzzerfeedMainController
//                   .listbuzzerfeeddata[widget.userindex].video,
//             )),
//       );
//     }

//     Widget commentimageCard(index) {
//       return InkWell(
//         onTap: () {
//           Navigator.of(Get.context).push(MaterialPageRoute(
//             builder: (context) => BuzzfeedExpandedImage(
//               listofimages: controller.commentList[index].images,
//               index: 0,
//             ),
//           ));
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(2.0.w),
//           child: Container(
//             height: 25.0.h,
//             width: controller.commentList[index].images.length == 1
//                 ? 85.0.w
//                 : 35.0.w,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(2.0.w),
//               child: CachedNetworkImage(
//                 fit: BoxFit.cover,
//                 imageUrl: '${controller.commentList[index].images[index]}',
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     Widget imageCardlist(imageindex) {
//       return InkWell(
//         onTap: () {
//           Navigator.of(Get.context).push(MaterialPageRoute(
//             builder: (context) => BuzzfeedExpandedImage(
//               listofimages: widget.buzzerfeedMainController
//                   .listbuzzerfeeddata[widget.userindex].images,
//               index: imageindex,
//             ),
//           ));
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(2.0.w),
//           child: Container(
//             height: widget.buzzerfeedMainController
//                         .listbuzzerfeeddata[widget.userindex].images.length ==
//                     1
//                 ? 50.0.h
//                 : 25.0.h,
//             width: widget.buzzerfeedMainController
//                         .listbuzzerfeeddata[widget.userindex].images.length ==
//                     1
//                 ? 82.0.w
//                 : 35.0.w,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(2.0.w),
//               child: CachedNetworkImage(
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => SkeletonAnimation(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(2.0.w),
//                     child: Container(
//                       width: widget
//                                   .buzzerfeedMainController
//                                   .listbuzzerfeeddata[widget.userindex]
//                                   .images
//                                   .length ==
//                               1
//                           ? 75.0.w
//                           : 35.0.w,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ),
//                 imageUrl: widget.buzzerfeedMainController
//                     .listbuzzerfeeddata[widget.userindex].images[imageindex],
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     Widget imageCard(index) {
//       return InkWell(
//         onTap: () {
//           Navigator.of(Get.context).push(MaterialPageRoute(
//             builder: (context) => BuzzfeedExpandedImage(
//               listofimages: widget.buzzerfeedMainController
//                   .listbuzzerfeeddata[widget.userindex].images,
//               index: index,
//             ),
//           ));
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(2.0.w),
//           child: Container(
//             // height: 35.0.h,
//             width: widget.buzzerfeedMainController
//                         .listbuzzerfeeddata[widget.userindex].images.length ==
//                     1
//                 ? 85.0.w
//                 : 35.0.w,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(2.0.w),
//               child: CachedNetworkImage(
//                 fit: (widget
//                             .buzzerfeedMainController
//                             .listbuzzerfeeddata[widget.userindex]
//                             .images
//                             .length ==
//                         1)
//                     ? BoxFit.contain
//                     : BoxFit.cover,
//                 imageUrl:
//                     '${widget.buzzerfeedMainController.listbuzzerfeeddata[widget.userindex].images[index]}',
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     Widget listofcommentimagecard(index) {
//       // return Container();
//       return Container(
//           width: 85.0.w,
//           height: widget.buzzerfeedMainController
//                       .listbuzzerfeeddata[widget.userindex].images.length ==
//                   1
//               ? 55.0.h
//               : 25.0.h,
//           child: ListView.separated(
//             separatorBuilder: (context, index) => SizedBox(
//               width: 1.0.w,
//             ),
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: controller.commentList[index].images.length,
//             itemBuilder: (context, index) => commentimageCard(index),
//           ));
//     }

//     Widget listofimagecardcomment(index) {
//       // return Container();
//       return Container(
//           width: 85.0.w,
//           height: controller.commentList[index].images.length == 1
//               ? 55.0.h
//               : 25.0.h,
//           child: ListView.separated(
//             separatorBuilder: (context, index) => SizedBox(
//               width: 1.0.w,
//             ),
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: controller.commentList[index].images.length,
//             itemBuilder: (context, index) => commentimageCard(index),
//           ));
//     }

//     Widget listofimagecard() {
//       // return Container();
//       return Container(
//           width: 85.0.w,
//           height: widget.buzzerfeedMainController
//                       .listbuzzerfeeddata[widget.userindex].images.length ==
//                   1
//               ? 55.0.h
//               : 25.0.h,
//           child: ListView.separated(
//             separatorBuilder: (context, index) => SizedBox(
//               width: 1.0.w,
//             ),
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: widget.buzzerfeedMainController
//                 .listbuzzerfeeddata[widget.userindex].images.length,
//             itemBuilder: (context, index) => imageCard(index),
//           ));
//     }

//     // Widget listofimagecard() {
//     //   // return Container();
//     //   return
//     //       // margin: EdgeInsets.symmetric(horizontal: 2.0.w),

//     //       Container(
//     //     color: Colors.pink,
//     //     child: PageView.builder(
//     //       // separatorBuilder: (context, index) => SizedBox(
//     //       //   width: 1.0.w,
//     //       // ),
//     //       // shrinkWrap: true,
//     //       scrollDirection: Axis.horizontal,
//     //       itemCount: widget.buzzerfeedMainController
//     //           .listbuzzerfeeddata[widget.userindex].images.length,
//     //       itemBuilder: (context, index) => imageCardlist(index),
//     //     ),
//     //   );
//     // }

//     Widget expandedBody() {
//       return InkWell(
//         onTap: () {
//           if (widget.posttype == "videos") {
//             print("clicked on video");
//             Navigator.of(context).push(MaterialWithModalsPageRoute(
//                 builder: (context) => BuzzfeedNetworkVideoPlayerExpanded(
//                       url: widget.buzzerfeedMainController
//                           .listbuzzerfeeddata[widget.userindex].video,
//                     )));
//           }
//         },
//         child: Container(
//             alignment: Alignment.topLeft,
//             margin: EdgeInsets.only(left: 2.0.w),
//             child: FormattedText('${widget.description}')),
//       );
//     }

//     Widget tweetIconButton(IconData icon, String text,
//         {onPressed: null, color: Colors.black45}) {
//       return InkWell(
//         onTap: onPressed ?? () {},
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 2.0.h,
//               color: color,
//             ),
//             Container(
//               margin: const EdgeInsets.all(6.0),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     void retweetCard() {
//       showBarModalBottomSheet(
//         context: context,
//         builder: (context) => SafeArea(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(3.0.w),
//             child: Container(
//               color: Colors.white,
//               height: Get.height / 2,
//               width: Get.width,
//               child: Row(
//                 children: [
//                   Text(
//                     'How Rebuzz Work?',
//                     style: TextStyle(color: Colors.black, fontSize: 4.0.h),
//                   ),
//                   ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage:
//                           NetworkImage('${CurrentUser().currentUser.image}'),
//                     ),
//                     title: Text(''),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     void rebuzz() {
//       showCupertinoModalBottomSheet(
//         context: context,
//         builder: (context) => ClipRRect(
//           borderRadius: BorderRadius.circular(2.0.h),
//           child: Container(
//             height: Get.height / 3,
//             width: Get.height,
//             margin: EdgeInsets.symmetric(horizontal: 2.0.w),
//             child: Container(
//               color: Colors.white,
//               child: Material(
//                 child: Column(
//                   children: [
//                     ListTile(
//                         title: Text(
//                       'How Rebuzz works ?',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 3.0.h,
//                           fontWeight: FontWeight.bold),
//                     )),
//                     ListTile(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       leading: Icon(
//                         FontAwesomeIcons.retweet,
//                         size: 3.0.h,
//                       ),
//                       title: Text(
//                         'Rebuzz',
//                         style: TextStyle(
//                             fontFamily: 'HelveticaNeue',
//                             fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('Share this buzz with your followers'),
//                     ),
//                     ListTile(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       leading: Icon(
//                         FontAwesomeIcons.pen,
//                         size: 3.0.h,
//                       ),
//                       title: Text(
//                         'Quote Rebuzz',
//                         style: TextStyle(
//                             fontFamily: 'HelveticaNeue',
//                             fontWeight: FontWeight.bold),
//                       ),
//                       isThreeLine: true,
//                       subtitle: Text(
//                           'Add a comment,photo or GIF before you share this Buzz'),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     Widget tweetButtons() {
//       return Container(
//         width: Get.width,
//         margin: EdgeInsets.only(top: 10.0, right: 2.0.w, left: 2.0.w),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               tweetIconButton(FontAwesomeIcons.comment, ''),
//               tweetIconButton(FontAwesomeIcons.retweet, '', onPressed: () {
//                 rebuzz();
//               }),
//               tweetIconButton(FontAwesomeIcons.heart, ''),
//               tweetIconButton(FontAwesomeIcons.share, ''),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget line() {
//       return Divider(
//         height: 0.1.h,
//         thickness: 0.1.h,
//       );
//     }

//     Widget customTextField(
//         {width: 0.0, height: 0.0, choice: 0, txtcontroller: null}) {
//       return Container(
//           width: width,
//           child: Column(
//             children: [
//               TextFormField(
//                 onChanged: (val) {},
//                 maxLines: null,
//                 controller: txtcontroller == null
//                     ? TextEditingController()
//                     : txtcontroller,
//                 textInputAction: TextInputAction.newline,
//                 keyboardType: TextInputType.multiline,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                     borderSide: BorderSide(color: Colors.grey, width: 1),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   hintText: "Choice $choice",
//                   //  AppLocalizations.of(
//                   //   "Description",
//                   // ),
//                   hintStyle: TextStyle(color: Colors.black, fontSize: 10.0.sp),
//                 ),
//               ),
//               SizedBox(
//                 height: 2.0.h,
//               ),
//             ],
//           ));
//     }

//     Widget buzzreplyCard(index) {
//       return Container(
//         child: Column(
//           children: [
//             ListTile(
//                 contentPadding: EdgeInsets.all(8),
//                 leading: CircleAvatar(
//                   backgroundImage: CachedNetworkImageProvider(
//                       '${controller.commentList[index].userPicture}'),
//                 ),
//                 title: Text(
//                     '${controller.commentList[index].memberName} . ${controller.commentList[index].timeStamp}'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Replying to @${widget.name}'),
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       child: Text(
//                         '${controller.commentList[index].comment}',
//                         style: TextStyle(color: Colors.black),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       width: 100.0.w,
//                     ),
//                     controller.commentList[index].type == "images"
//                         ? listofimagecardcomment(index)
//                         : controller.commentList[index].type == "gif"
//                             ? commentgifCard(index)
//                             : Container()
//                   ],
//                 )),
//           ],
//         ),
//       );
//     }

//     Widget pollBody() {
//       var polldata = widget.buzzerfeedMainController
//           .listbuzzerfeeddata[widget.userindex].pollAnswer;

//       var polllist = [];
//       polldata.forEach((element) {
//         polllist.add(Polls.options(
//           title: element.answer,
//           value: 0,
//         ));
//       });

//       print("polllist =${polllist}");
//       return PollView(
//         polllist: polllist,
//       );
//     }

//     Widget commentList() {
//       return ListView.separated(
//         physics: NeverScrollableScrollPhysics(),
//         separatorBuilder: (context, index) => line(),
//         itemCount: controller.commentList.length,
//         itemBuilder: (context, index) => buzzreplyCard(index),
//         shrinkWrap: true,
//       );
//     }

//     Widget tweetReply() {
//       return Container(
//           color: Colors.white,
//           height: 12.0.h,
//           width: Get.width,
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 6.0.h,
//                 child: TextFormField(
//                   maxLines: null,
//                   controller: controller.reply,
//                   textInputAction: TextInputAction.newline,
//                   keyboardType: TextInputType.multiline,
//                   style: TextStyle(color: Colors.black),
//                   cursorColor: Colors.black,
//                   decoration: InputDecoration(
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         Navigator.of(Get.context).push(MaterialPageRoute(
//                           builder: (context) => BuzzfeedUploadPost(
//                             purpose: "comment_upload",
//                             from: 'expanded',
//                             BuzzerfeedEditController: controller,
//                             buzzfeedmaincontroller:
//                                 widget.buzzerfeedMainController,
//                             buzzerfeedId: controller.buzzerfeedId,
//                           ),
//                         ));
//                       },
//                       icon: Icon(
//                         Icons.open_in_full_outlined,
//                         color: Colors.black,
//                       ),
//                     ),

//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black),
//                     ),
//                     border: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),

//                     // enabledBorder: OutlineInputBorder(
//                     //   // borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                     //   borderSide: BorderSide(color: Colors.grey, width: 1),
//                     // ),
//                     // focusedBorder: OutlineInputBorder(
//                     //   // borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     //   borderSide: BorderSide(color: Colors.black),
//                     // ),
//                     hintText: "Buzz your reply",
//                     //  AppLocalizations.of(
//                     //   "Description",
//                     // ),
//                     hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0.sp),
//                   ),
//                 ),
//               ),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//                 IconButton(
//                     onPressed: () {
//                       Navigator.of(Get.context).push(MaterialPageRoute(
//                         builder: (context) => BuzzfeedUploadPost(
//                           purpose: "comment_upload",
//                           from: 'expanded',
//                           BuzzerfeedEditController: controller,
//                           buzzfeedmaincontroller:
//                               widget.buzzerfeedMainController,
//                           buzzerfeedId: controller.buzzerfeedId,
//                         ),
//                       ));
//                     },
//                     icon: Icon(
//                       Icons.photo_outlined,
//                     )),
//                 IconButton(
//                     onPressed: () {}, icon: Icon(Icons.photo_album_outlined)),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(Get.context).push(MaterialPageRoute(
//                       builder: (context) => BuzzfeedUploadPost(
//                         purpose: "comment_upload",
//                         from: 'expanded',
//                         BuzzerfeedEditController: controller,
//                         buzzfeedmaincontroller: widget.buzzerfeedMainController,
//                         buzzerfeedId: controller.buzzerfeedId,
//                       ),
//                     ));
//                   },
//                   icon: Icon(Icons.poll_outlined),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(Get.context).push(MaterialPageRoute(
//                       builder: (context) => BuzzfeedUploadPost(
//                         BuzzerfeedEditController: controller,
//                         purpose: "comment_upload",
//                         from: 'expanded',
//                         buzzfeedmaincontroller: widget.buzzerfeedMainController,
//                         buzzerfeedId: controller.buzzerfeedId,
//                       ),
//                     ));
//                   },
//                   icon: Icon(Icons.location_on_outlined),
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.black),
//                           shape: MaterialStateProperty.all(
//                               RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(3.0.w)))),
//                       onPressed: () {
//                         controller.postComment(controller.buzzerfeedId);
//                         controller.reply.text = '';
//                       },
//                       child: Text(
//                         'Reply',
//                         style: TextStyle(color: Colors.white),
//                       )),
//                 )
//               ])
//             ],
//           ));
//     }

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Tweet',
//         ),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             onPressed: () {
//               Get.delete<BuzzerfeedEditController>();
//               Navigator.of(context).pop();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             )),
//       ),
//       body: WillPopScope(
//         onWillPop: () async {
//           Get.delete<BuzzerfeedEditController>();
//           return true;
//         },
//         child: SingleChildScrollView(
//           child: Stack(children: [
//             Container(
//               margin: EdgeInsets.only(bottom: kToolbarHeight),
//               color: Colors.white,
//               width: Get.width,
//               child: Column(
//                 children: [
//                   expandedHeader(),
//                   expandedBody(),
//                   SizedBox(
//                     height: 3.0.h,
//                   ),
//                   widget.posttype == "images"
//                       ? ClipRRect(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(2.0.w)),
//                           child: Container(
//                             width: 100.0.w,
//                             margin: EdgeInsets.symmetric(horizontal: 2.0.w),
//                             color: Colors.white,
//                             child: Container(
//                               child: (widget
//                                           .buzzerfeedMainController
//                                           .listbuzzerfeeddata[widget.userindex]
//                                           .images
//                                           .length ==
//                                       1)
//                                   ? imageCard(0)
//                                   : listofimagecard(),
//                               // child: PageView.builder(
//                               //   // separatorBuilder: (context, index) => SizedBox(
//                               //   //   width: 1.0.w,
//                               //   // ),
//                               //   // shrinkWrap: true,
//                               //   scrollDirection: Axis.horizontal,
//                               //   itemCount: widget
//                               //       .buzzerfeedMainController
//                               //       .listbuzzerfeeddata[widget.userindex]
//                               //       .images
//                               //       .length,
//                               //   itemBuilder: (context, index) => imageCard(index),
//                               // ),
//                             ),
//                           ),
//                         )
//                       : widget.posttype == "poll"
//                           ? pollBody()
//                           : widget.posttype == "gif"
//                               ? gifCard()
//                               : videoCard(),
//                   line(),
//                   dateBar(),
//                   line(),
//                   buzzdetails(),
//                   line(),
//                   tweetButtons(),
//                   line(),
//                   Obx(() => controller.commentList != null &&
//                           controller.commentList.length != 0
//                       ? Container(
//                           child: commentList(),
//                           margin: EdgeInsets.only(bottom: 15.0.h),
//                         )
//                       : Container(
//                           child: Center(
//                             child: Text(
//                               'No comments found!!',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                         ))

//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                   // buzzreplyCard(),
//                 ],
//               ),
//             ),
//           ]),
//         ),
//       ),
//       bottomSheet: BottomAppBar(
//         child: SingleChildScrollView(child: tweetReply()),
//       ),
//     );
//   }
// }
