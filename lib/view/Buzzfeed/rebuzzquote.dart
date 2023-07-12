// class ReTweet extends StatelessWidget {
//   final String avatar;
//   final String username;
//   final String name;
//   final String timeAgo;
//   final String text;
//   final String comments;
//   final String retweets;
//   final String favorites;
//   bool likeStatus;
//   BuzzerfeedMainController buzzerfeedMainController;
//   int userindex;
//   String posttype;
//   BuzzfeedNetworkVideoPlayer videoPlayer;
//   FlickManager flickManager;

//   ReTweet(
//       {Key key,
//       @required this.avatar,
//       @required this.username,
//       @required this.name,
//       @required this.timeAgo,
//       @required this.text,
//       @required this.comments,
//       @required this.retweets,
//       @required this.favorites,
//       this.posttype,
//       this.likeStatus,
//       this.flickManager,
//       this.buzzerfeedMainController,
//       this.videoPlayer,
//       this.userindex})
//       : super(key: key);

//   get featuredColor => null;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: InkWell(
//         onTap: () {
//           // Navigator.of(Get.context).push(MaterialPageRoute(
//           //     builder: (context) => BuzzerfeedExpanded(
//           //         description: text,
//           //         avatar: this.avatar,
//           //         comments: this.comments,
//           //         favorites: this.favorites,
//           //         buzzerfeedMainController: this.buzzerfeedMainController,
//           //         likeStatus: this.likeStatus,
//           //         name: this.name,
//           //         posttype: this.posttype,
//           //         retweets: this.retweets,
//           //         timeAgo: this.timeAgo,
//           //         userindex: this.userindex,
//           //         username: this.username)));
//         },
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             tweetAvatar(),
//             tweetBody(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget tweetAvatar() {
//     return Container(
//       margin: const EdgeInsets.all(10.0),
//       child: CircleAvatar(
//         backgroundColor: Colors.black,
//         backgroundImage: NetworkImage(this.quotes[0].userPicture),
//       ),
//     );
//   }

//   Widget linkCard() {
//     return (this.quotes[0].linkImages.length ==
//             0)
//         ? Container(
//             height: 0.0,
//             width: 0.0,
//           )
//         : Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 // color: Colors.amber,
//                 child: ListView.separated(
//                     physics: NeverScrollableScrollPhysics(),
//                     separatorBuilder: (context, index) => Container(
//                           height: 0.1.h,
//                         ),
//                     shrinkWrap: true,
//                     itemCount: buzzerfeedMainController
//                         .listbuzzerfeeddata[this.userindex].linkDesc.length,
//                     itemBuilder: (context, index) => InkWell(
//                           onTap: () {
//                             launch(
//                                 '${this.quotes[0].linkLink[index]}');
//                           },
//                           child: ClipRRect(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(2.0.h)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Card(
//                                 elevation: 2.0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(2.0.h))),
//                                 child: ClipRRect(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(2.0.h)),
//                                   child: Container(
//                                       width: 80.0.w,
//                                       child: Column(
//                                         children: [
//                                           buzzerfeedMainController
//                                                       .listbuzzerfeeddata[
//                                                           this.userindex]
//                                                       .linkImages[0] ==
//                                                   ""
//                                               ? Card(
//                                                   elevation: 1.0,
//                                                   child: Container(
//                                                     width: 80.0.w,
//                                                     height: 20.0.h,
//                                                     child: Image.asset(
//                                                       'assets/images/buzzfeed.png',
//                                                       fit: BoxFit.contain,
//                                                     ),
//                                                   ),
//                                                 )
//                                               : CachedNetworkImage(
//                                                   imageUrl:
//                                                       buzzerfeedMainController
//                                                           .listbuzzerfeeddata[
//                                                               this.userindex]
//                                                           .linkImages[index],
//                                                   fit: BoxFit.contain,
//                                                 ),
//                                           Container(
//                                             alignment: Alignment.center,
//                                             margin:
//                                                 EdgeInsets.only(left: 1.5.w),
//                                             child: Text(
//                                               '${this.quotes[0].linkDesc[index]}',
//                                               maxLines: 3,
//                                               softWrap: true,
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                         ],
//                                       )),
//                                 ),
//                                 // leading: CachedNetworkImage(
//                                 //   imageUrl: buzzerfeedMainController
//                                 //       .listbuzzerfeeddata[this.userindex]
//                                 //       .linkImages[index],
//                                 //   fit: BoxFit.contain,
//                                 // ),
//                               ),
//                             ),
//                           ),
//                         )),
//               ),
//             ),
//           );
//   }

//   Widget tweetBody() {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           tweetHeader(),

//           InkWell(
//             onTap: () {
//               print("tapa tap");
//               // Navigator.of(Get.context).push(MaterialPageRoute(
//               //     builder: (context) => BuzzerfeedExpanded(
//               //         description: text,
//               //         avatar: this.avatar,
//               //         comments: this.comments,
//               //         favorites: this.favorites,
//               //         buzzerfeedMainController: this.buzzerfeedMainController,
//               //         likeStatus: this.likeStatus,
//               //         name: this.name,
//               //         posttype: this.posttype,
//               //         retweets: this.retweets,
//               //         timeAgo: this.timeAgo,
//               //         userindex: this.userindex,
//               //         username: this.username)));
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 (!this.text.isEmpty)
//                     ? tweetText()
//                     : Container(
//                         width: 0,
//                         height: 0,
//                       ),
//                 (!this.text.isEmpty)
//                     ? SizedBox(
//                         height: 2.0.h,
//                       )
//                     : Container(
//                         width: 0,
//                         height: 0,
//                       ),
//                 buzzBody(),
//                 linkCard(),
        
//               ],
//             ),
//           ),

     
//         ],
//       ),
//     );
//   }

//   Widget tweetHeader() {
//     return Row(
//       children: [
//         Container(
//             margin: const EdgeInsets.only(right: 5.0),
//             child: Row(
//               children: [
//                 Text(
//                   this.username,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 0.8.w,
//                 ),
//                 this
//                             .quptes
//                             .listbuzzerfeeddata[this.userindex]
//                             .varified !=
//                         ""
//                     ? Container(
//                         // height: 0.2.h,
//                         // width: 0.2.w,
//                         child: Icon(
//                         Icons.verified_rounded,
//                         size: 1.5.h,
//                         color: Colors.blue[800],
//                       ))
//                     //   CachedNetworkImage(
//                     //       fit: BoxFit.cover,
//                     //       imageUrl: this
//                     //           .buzzerfeedMainController
//                     //           .listbuzzerfeeddata[this.userindex]
//                     //           .varified),
//                     // )
//                     : Container(
//                         height: 0,
//                         width: 0,
//                       )
//               ],
//             )),
//         Text(
//           '@${name} · $timeAgo',
//           style: TextStyle(
//             color: Colors.grey,
//           ),
//         ),
//         Spacer(),
//         IconButton(
//           icon: Icon(
//             FontAwesomeIcons.angleDown,
//             size: 14.0,
//             color: Colors.grey,
//           ),
//           onPressed: () {

//           },
//         ),
//       ],
//     );
//   }

//   Widget tweetText() {
//     return FormattedText(
//       text,
//       overflow: TextOverflow.clip,
//     );
//   }

// //POLL-START
//   Widget pollBody() {
//     var polldata = this
//         .buzzerfeedMainController
//         .listbuzzerfeeddata[this.userindex]
//         .pollAnswer;

//     var polllist = [];
//     polldata.forEach((element) {
//       polllist.add(Polls.options(
//         title: element.answer,
//         value: 0,
//       ));
//     });

//     print("polllist =${polllist}");
//     return PollView(
//       polllist: polllist,
//     );
//   }

// //POLL-END
//   Widget videoCard() {
//     print(
//         "current video=${this.quotes[0].video}");
//     return ClipRRect(
//         borderRadius: BorderRadius.circular(2.0.w),
//         child:
//             //  DiscoverVideoPlayer(
//             //   url:
//             //       this.quotes[0].video,
//             // )-

//             InkWell(
//           onTap: () {
//             print("clicked on video");
//             Navigator.of(Get.context).push(MaterialWithModalsPageRoute(
//                 builder: (context) => BuzzfeedNetworkVideoPlayerExpanded(
//                       url: this
//                           .buzzerfeedMainController
//                           .listbuzzerfeeddata[this.userindex]
//                           .video,
//                     )));
//           },
//           child: BuzzerFeedPlay(
//             image: buzzerfeedMainController
//                 .listbuzzerfeeddata[this.userindex].thumb,
//             url: buzzerfeedMainController
//                 .listbuzzerfeeddata[this.userindex].video,
//             // flickManager:

//             //  FlickManager(
//             //     videoPlayerController: VideoPlayerController.network(
//             //         buzzerfeedMainController
//             //             .listbuzzerfeeddata[this.userindex].video)

//             //             ),
//           ),
//         )
//         //     BuzzfeedNetworkVideoPlayer(
//         //   url:
//         //       this.quotes[0].video,
//         // )

//         );
//   }

// //Imgae
//   Widget imageCard(imageindex) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(Get.context).push(MaterialPageRoute(
//           builder: (context) => BuzzfeedExpandedImage(
//             listofimages: this
//                 .buzzerfeedMainController
//                 .listbuzzerfeeddata[this.userindex]
//                 .images,
//             index: imageindex,
//           ),
//         ));
//       },
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(2.0.w),
//         child: Container(
//           height: this
//                       .buzzerfeedMainController
//                       .listbuzzerfeeddata[this.userindex]
//                       .images
//                       .length ==
//                   1
//               ? 50.0.h
//               : 25.0.h,
//           width: this
//                       .buzzerfeedMainController
//                       .listbuzzerfeeddata[this.userindex]
//                       .images
//                       .length ==
//                   1
//               ? 82.0.w
//               : 35.0.w,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(2.0.w),
//             child: CachedNetworkImage(
//               fit: BoxFit.cover,
//               placeholder: (context, url) => SkeletonAnimation(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(2.0.w),
//                   child: Container(
//                     width: this
//                                 .buzzerfeedMainController
//                                 .listbuzzerfeeddata[this.userindex]
//                                 .images
//                                 .length ==
//                             1
//                         ? 75.0.w
//                         : 35.0.w,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ),
//               imageUrl: this
//                   .buzzerfeedMainController
//                   .listbuzzerfeeddata[this.userindex]
//                   .images[imageindex],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget gifCard() {
//     return InkWell(
//       onTap: () {
//         Navigator.of(Get.context).push(MaterialPageRoute(
//           builder: (context) => BuzzfeedExpandedImage(
//             listofimages: this
//                 .buzzerfeedMainController
//                 .listbuzzerfeeddata[this.userindex]
//                 .images,
//             index: 0,
//           ),
//         ));
//       },
//       child: Container(
//         width: 83.0.w,
//         height: this
//                     .buzzerfeedMainController
//                     .listbuzzerfeeddata[this.userindex]
//                     .images
//                     .length ==
//                 1
//             ? 45.0.h
//             : 25.0.h,
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
//               imageUrl: this
//                   .buzzerfeedMainController
//                   .listbuzzerfeeddata[this.userindex]
//                   .images[0],
//               fit: BoxFit.cover,
//             )),
//       ),
//     );
//   }

//   Widget listofimagecard() {
//     // return Container();
//     return Container(
//         width: 85.0.w,
//         height: this
//                     .buzzerfeedMainController
//                     .listbuzzerfeeddata[this.userindex]
//                     .images
//                     .length ==
//                 1
//             ? 55.0.h
//             : 25.0.h,
//         child: ListView.separated(
//           separatorBuilder: (context, index) => SizedBox(
//             width: 1.0.w,
//           ),
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: this
//               .buzzerfeedMainController
//               .listbuzzerfeeddata[this.userindex]
//               .images
//               .length,
//           itemBuilder: (context, index) => imageCard(index),
//         ));
//   }

// //Image end
//   Widget buzzBody() {
//     print("buzzbody ${this.posttype}");
//     return Container(
//       child: this.posttype == "text"
//           ? Container()
//           : this.posttype == "images"
//               ? listofimagecard()
//               : this.posttype == "poll"
//                   ? pollBody()
//                   : this.posttype == "videos"
//                       ?
//                       // Container()
//                       videoCard()
//                       : gifCard(),
//     );
//   }

//   Widget customListTile(
//       title, context, VoidCallback callback, IconData iconData) {
//     return Expanded(
//       child: ListTile(
//         onTap: callback,
//         leading: Icon(
//           iconData,
//           color: Colors.grey,
//           size: 2.0.h,
//         ),
//         title: Text(
//           '$title',
//           style: TextStyle(fontSize: 2.0.h),
//         ),
//       ),
//     );
//   }

//   void details() {
//     showBarModalBottomSheet(
//         context: Get.context,
//         builder: (context) => ClipRRect(
//             child: Container(
//               width: 100.w,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 3.0.h,
//                   ),
//                   customListTile('Block', context, () {}, Icons.block),
//                   customListTile('Report', context, () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => BuzzerFeedReport(),
//                     ));
//                   }, Icons.block),
//                 ],
//               ),
//               height: 20.0.h,
//             ),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
//   }




//   Widget tweetIconButton(IconData icon, String text, VoidCallback callback,
//       {Color color: Colors.black45}) {
//     return Row(
//       children: [
//         InkWell(
//           onTap: callback,
//           child: Icon(
//             icon,
//             size: 20.0,
//             color: color,
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.all(6.0),
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.black45,
//               fontSize: 14.0,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

