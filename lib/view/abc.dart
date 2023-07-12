      // Positioned.fill(
      //                                       top: isTapOnQuestion &&
      //                                               keyboardVisible
      //                                           ? 0
      //                                           : musicPosY,
      //                                       left: isTapOnQuestion &&
      //                                               keyboardVisible
      //                                           ? 0
      //                                           : musicPosX,
      //                                       // right: isTapOnQuestion && keyboardVisible ? 0 : null,
      //                                       // bottom: isTapOnQuestion && keyboardVisible ? 0 : null,
      //                                       child: Container(
      //                                         color: Colors.transparent,
      //                                         // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
      //                                         child: Padding(
      //                                           padding: EdgeInsets.symmetric(
      //                                               horizontal: 6.0.w,
      //                                               vertical: 5.0.h),
      //                                           child: Container(
      //                                             color: Colors.transparent,
      //                                             child: Center(
      //                                               child: Container(
      //                                                 padding:
      //                                                     EdgeInsets.all(7),
      //                                                 decoration: BoxDecoration(
      //                                                   color: Colors.white,
      //                                                   borderRadius:
      //                                                       BorderRadius
      //                                                           .circular(8),
      //                                                   boxShadow: [
      //                                                     BoxShadow(
      //                                                       color: Colors.black
      //                                                           .withOpacity(
      //                                                               .2),
      //                                                       offset:
      //                                                           Offset(0, 2),
      //                                                       blurRadius: 3,
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                                 child: Stack(
      //                                                   clipBehavior: Clip.none,
      //                                                   children: [
      //                                                     Container(
      //                                                       decoration:
      //                                                           BoxDecoration(
      //                                                         color:
      //                                                             Colors.white,
      //                                                         borderRadius:
      //                                                             BorderRadius
      //                                                                 .circular(
      //                                                                     10),
      //                                                       ),
      //                                                       padding:
      //                                                           EdgeInsets.all(
      //                                                               20),
      //                                                       width: MediaQuery.of(
      //                                                                   context)
      //                                                               .size
      //                                                               .width *
      //                                                           .70,
      //                                                       child: Column(
      //                                                         mainAxisSize:
      //                                                             MainAxisSize
      //                                                                 .min,
      //                                                         children: [
      //                                                           Padding(
      //                                                             padding: const EdgeInsets
      //                                                                     .symmetric(
      //                                                                 vertical:
      //                                                                     15),
      //                                                             child: Text(
      //                                                               musicTextData,
      //                                                               style:
      //                                                                   TextStyle(
      //                                                                 fontSize:
      //                                                                     20,
      //                                                               ),
      //                                                             ),
      //                                                           ),
      //                                                           Container(
      //                                                             decoration:
      //                                                                 BoxDecoration(
      //                                                               color: Colors
      //                                                                   .grey
      //                                                                   .shade200,
      //                                                               borderRadius:
      //                                                                   BorderRadius
      //                                                                       .circular(7),
      //                                                             ),
      //                                                             padding:
      //                                                                 EdgeInsets
      //                                                                     .all(
      //                                                                         10),
      //                                                             width: double
      //                                                                 .infinity,
      //                                                             child: Row(
      //                                                               children: [
      //                                                                 Expanded(
      //                                                                   child:
      //                                                                       TextFormField(
      //                                                                     onTap:
      //                                                                         () {
      //                                                                       isTapOnQuestion =
      //                                                                           true;
      //                                                                       _pause();
      //                                                                     },
      //                                                                     controller:
      //                                                                         _controller,
      //                                                                     textAlign:
      //                                                                         TextAlign.center,
      //                                                                     textCapitalization:
      //                                                                         TextCapitalization.sentences,
      //                                                                     maxLines:
      //                                                                         3,
      //                                                                     minLines:
      //                                                                         1,
      //                                                                     onChanged:
      //                                                                         (val) {},
      //                                                                     style:
      //                                                                         TextStyle(
      //                                                                       fontSize:
      //                                                                           16,
      //                                                                     ),
      //                                                                     decoration:
      //                                                                         InputDecoration(
      //                                                                       border:
      //                                                                           InputBorder.none,
      //                                                                       hintText:
      //                                                                           "Reply here",
      //                                                                       hintStyle:
      //                                                                           TextStyle(
      //                                                                         color: Colors.grey,
      //                                                                       ),
      //                                                                     ),
      //                                                                   ),
      //                                                                 ),
      //                                                                 IconButton(
      //                                                                   onPressed:
      //                                                                       () async {
      //                                                                     await DirectApiCalls().questionReplyFromStory(
      //                                                                         widget.user.memberId,
      //                                                                         _controller.text,
      //                                                                         allFiles[index].id,
      //                                                                         allFiles[index].storyId.toString());
      //                                                                     FocusScope.of(context)
      //                                                                         .requestFocus(FocusNode());
      //                                                                     isTapOnQuestion =
      //                                                                         false;
      //                                                                     timer
      //                                                                         .start();
      //                                                                     _animationController
      //                                                                         .forward();
      //                                                                     if (controller != null &&
      //                                                                         allFiles[_currentIndex].video == 1) {
      //                                                                       controller.play();
      //                                                                     }

      //                                                                     customToastWhite(
      //                                                                         AppLocalizations.of(
      //                                                                           "Reply Sent",
      //                                                                         ),
      //                                                                         16.0,
      //                                                                         ToastGravity.CENTER);
      //                                                                     _controller
      //                                                                         .clear();
      //                                                                   },
      //                                                                   icon:
      //                                                                       Icon(
      //                                                                     Icons
      //                                                                         .send,
      //                                                                     size:
      //                                                                         25,
      //                                                                     color:
      //                                                                         Colors.white,
      //                                                                   ),
      //                                                                 ),
      //                                                               ],
      //                                                             ),
      //                                                           )
      //                                                         ],
      //                                                       ),
      //                                                     ),
      //                                                     Positioned(
      //                                                       left: 0,
      //                                                       right: 0,
      //                                                       top: -20,
      //                                                       child: Center(
      //                                                         child:
      //                                                             CircleAvatar(
      //                                                           radius: 20,
      //                                                           backgroundImage:
      //                                                               NetworkImage(
      //                                                             CurrentUser()
      //                                                                 .currentUser
      //                                                                 .image,
      //                                                           ),
      //                                                           backgroundColor:
      //                                                               Colors.grey,
      //                                                         ),
      //                                                       ),
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                                 // height: 30,
      //                                               ),
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ),