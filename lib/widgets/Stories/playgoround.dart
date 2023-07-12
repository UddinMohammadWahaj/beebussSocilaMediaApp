// if (musicViewData[currentIndex]
//                                                   ?.name !=
//                                               "" &&
//                                           isquestionsViewAdd)
//                                         Positioned.fill(
//                                           left: musicViewData[currentIndex]
//                                                   .posx -
//                                               125,
//                                           top: musicViewData[currentIndex]
//                                                   .posy -
//                                               125,
//                                           right: -125,
//                                           bottom: -125,
//                                           child: Align(
//                                             alignment: Alignment.center,
//                                             child: XGestureDetector(
//                                               onLongPress: (val) {
//                                                 setState(() {
//                                                   // showTextField = !showTextField;
//                                                   musicViewData[
//                                                           currentIndex]
//                                                       .h = 100.0.h;
//                                                   musicViewData[
//                                                           currentIndex]
//                                                       .w = 100.0.w;
//                                                 });
//                                               },
//                                               onTap: (val) {
//                                                 setState(() {
//                                                   // showColors = false;
//                                                   // showFonts = true;
//                                                   // showTextField = true;
//                                                   // _controller.text = e.name;
//                                                   // roboto = e.font;
//                                                   // selectedColor = e.color;
//                                                   // currentEditingTag = tagsList[pageIndex].indexOf(e);
//                                                 });
//                                                 /*  setState(() {
//                                                         // showTextField = !showTextField;
//                                                         e.h = 100.0.h;
//                                                         e.w = 100.0.w;
//                                                       });*/
//                                               },
//                                               onScaleEnd: () {
//                                                 setState(() {
//                                                   musicViewData[
//                                                               currentIndex]
//                                                           .lastRotation =
//                                                       musicViewData[
//                                                               currentIndex]
//                                                           .rotation;
//                                                 });
//                                               },
//                                               onScaleStart: (details) {
//                                                 setState(() {
//                                                   _baseScaleFactor =
//                                                       musicViewData[
//                                                               currentIndex]
//                                                           .scale;
//                                                   print(
//                                                       "-------------___$_baseScaleFactor------------------------------------------------------------------------");
//                                                 });
//                                               },
//                                               onScaleUpdate: (details) {
//                                                 setState(() {
//                                                   musicViewData[
//                                                               currentIndex]
//                                                           .rotation =
//                                                       musicViewData[
//                                                                   currentIndex]
//                                                               .lastRotation -
//                                                           details.rotationAngle;
//                                                   musicViewData[
//                                                               currentIndex]
//                                                           .scale =
//                                                       _baseScaleFactor *
//                                                           details.scale;
//                                                 });
//                                               },
//                                               onMoveStart: (details) {
//                                                 setState(() {
//                                                   offset = Offset(
//                                                       musicViewData[
//                                                               currentIndex]
//                                                           .posx,
//                                                       musicViewData[
//                                                               currentIndex]
//                                                           .posy);
//                                                 });
//                                               },
//                                               onMoveUpdate: (details) {
//                                                 double xdiff = 0;
//                                                 double ydiff = 0;
//                                                 offset = Offset(
//                                                     offset.dx +
//                                                         details.delta.dx,
//                                                     offset.dy +
//                                                         details.delta.dy);
//                                                 // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
//                                                 // xdiff = (offset.dx) < 0 ? (-offset.dx) : (offset.dx);
//                                                 // ydiff = deletePosition.dy - (offset.dy + 5.0.h);
//                                                 print(ydiff);

//                                                 print(deletePosition.dy
//                                                         .toString() +
//                                                     " delete pos");
//                                                 xdiff = (offset.dx) < 0
//                                                     ? (-offset.dx)
//                                                     : (offset.dx);
//                                                 ydiff = deletePosition.dy -
//                                                     (offset.dy + 5.0.h);

//                                                 if (((xdiff > 0 &&
//                                                             xdiff < 60) ||
//                                                         (xdiff < 0 &&
//                                                             xdiff >= -1)) &&
//                                                     ((ydiff > 0 &&
//                                                             ydiff < 100) ||
//                                                         (ydiff < 0 &&
//                                                             ydiff >= -1))) {
//                                                   setState(() {
//                                                     deleteIconColor = true;
//                                                     musicViewData[
//                                                             currentIndex]
//                                                         ?.name = "";
//                                                     offset = Offset.zero;
//                                                     Future.delayed(
//                                                         Duration(
//                                                             milliseconds: 1000),
//                                                         () {
//                                                       deleteIconColor = false;
//                                                     });
//                                                   });
//                                                 } else {
//                                                   setState(() {
//                                                     deleteIconColor = false;
//                                                   });
//                                                 }
//                                                 setState(() {
//                                                   isTagSelected = true;
//                                                   calculatePosition();
//                                                   musicViewData[
//                                                           currentIndex]
//                                                       .h = 100.0.h;
//                                                   musicViewData[
//                                                           currentIndex]
//                                                       .w = 100.0.w;
//                                                   offset = Offset(
//                                                       offset.dx +
//                                                           details.delta.dx,
//                                                       offset.dy +
//                                                           details.delta.dy);
//                                                   musicViewData[
//                                                           currentIndex]
//                                                       .posy = offset.dy;
//                                                   musicViewData[
//                                                           currentIndex]
//                                                       .posx = offset.dx;
//                                                 });
//                                                 // print(details.position.toString());
//                                                 // print(100.0.h);
//                                                 // print(deletePosition.toString());
//                                               },
//                                               onMoveEnd: (details) async {
//                                                 double xdiff = 0;
//                                                 double ydiff = 0;
//                                                 offset = Offset(
//                                                     offset.dx +
//                                                         details.delta.dx,
//                                                     offset.dy +
//                                                         details.delta.dy);
//                                                 // xdiff = deletePosition.dx - offset.dx < 0 ? offset.dx - deletePosition.dx : deletePosition.dx - offset.dx;
//                                                 xdiff = (offset.dx) < 0
//                                                     ? (-offset.dx)
//                                                     : (offset.dx);
//                                                 ydiff = deletePosition.dy -
//                                                     (offset.dy + 5.0.h);
//                                                 print(ydiff);
//                                                 if (((xdiff > 0 &&
//                                                             xdiff < 60) ||
//                                                         (xdiff < 0 &&
//                                                             xdiff >= -1)) &&
//                                                     ((ydiff > 0 &&
//                                                             ydiff < 100) ||
//                                                         (ydiff < 0 &&
//                                                             ydiff >= -1))) {
//                                                   // int i = tagsList[pageIndex].indexOf(musicViewData[currentIndex]);
//                                                   setState(() {
//                                                     isquestionsViewAdd = false;
//                                                     // tagsList[pageIndex].removeAt(i);
//                                                     // _controller.clear();
//                                                     musicViewData[
//                                                         currentIndex] = null;
//                                                     deleteIconColor = false;
//                                                     isTagSelected = false;
//                                                   });
//                                                   if (await Vibration
//                                                       .hasVibrator()) {
//                                                     Vibration.vibrate();
//                                                   }
//                                                 } else {
//                                                   WidgetsBinding.instance
//                                                       .addPostFrameCallback(
//                                                           (timeStamp) {
//                                                     final RenderBox box =
//                                                         musicViewData[
//                                                                 currentIndex]
//                                                             .stickerKey
//                                                             .currentContext
//                                                             .findRenderObject();
//                                                     setState(() {
//                                                       isTagSelected = false;
//                                                       musicViewData[
//                                                               currentIndex]
//                                                           .w = box.size.width;
//                                                       musicViewData[
//                                                               currentIndex]
//                                                           .h = box.size.height;
//                                                     });
//                                                   });
//                                                 }
//                                                 setState(() {
//                                                   offset = Offset.zero;
//                                                 });
//                                               },
//                                               child: Transform.scale(
//                                                 scale: musicViewData[
//                                                         currentIndex]
//                                                     .scale,
//                                                 child: Container(
//                                                   color: Colors.transparent,
//                                                   // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(musicViewData[currentIndex].rotation),
//                                                   child: Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 6.0.w,
//                                                             vertical: 5.0.h),
//                                                     child: Container(
//                                                       height: musicViewData[
//                                                               currentIndex]
//                                                           .h,
//                                                       width: musicViewData[
//                                                               currentIndex]
//                                                           .w,
//                                                       color: Colors.transparent,
//                                                       child: Center(
//                                                         child: Container(
//                                                           key: musicViewData[
//                                                                   currentIndex]
//                                                               .stickerKey,
//                                                           padding:
//                                                               EdgeInsets.all(7),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: Colors.white,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         8),
//                                                             boxShadow: [
//                                                               BoxShadow(
//                                                                 color: Colors
//                                                                     .black
//                                                                     .withOpacity(
//                                                                         .2),
//                                                                 offset: Offset(
//                                                                     0, 2),
//                                                                 blurRadius: 3,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           child:
                                                          
//                                                          //CHILD START 
                                                          
//                                                            Stack(
//                                                             clipBehavior:
//                                                                 Clip.none,
//                                                             children: [
//                                                               Container(
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10),
//                                                                 ),
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .all(
//                                                                             20),
//                                                                 width: MediaQuery.of(
//                                                                             context)
//                                                                         .size
//                                                                         .width *
//                                                                     .70,
//                                                                 child: Column(
//                                                                   mainAxisSize:
//                                                                       MainAxisSize
//                                                                           .min,
//                                                                   children: [
//                                                                     // TextField(
//                                                                     //   controller: _controller,
//                                                                     //   enabled: false,
//                                                                     //   textAlign: TextAlign.center,
//                                                                     //   textCapitalization: TextCapitalization.sentences,
//                                                                     //   maxLines: 3,
//                                                                     //   minLines: 1,
//                                                                     //   onChanged: (val) {},
//                                                                     //   style: TextStyle(
//                                                                     //     fontSize: 20,
//                                                                     //   ),
//                                                                     //   decoration: InputDecoration(
//                                                                     //     border: InputBorder.none,
//                                                                     //     hintText: "Ask me a question",
//                                                                     //     hintStyle: TextStyle(
//                                                                     //       color: Colors.grey,
//                                                                     //     ),
//                                                                     //   ),
//                                                                     // ),
//                                                                     Padding(
//                                                                       padding: const EdgeInsets
//                                                                               .symmetric(
//                                                                           vertical:
//                                                                               15),
//                                                                       child:
//                                                                           Text(
//                                                                         musicViewData[currentIndex]
//                                                                             .name,
//                                                                         style: TextStyle(
//                                                                             fontSize:
//                                                                                 20),
//                                                                         textScaleFactor:
//                                                                             musicViewData[currentIndex].scale,
//                                                                       ),
//                                                                     ),
//                                                                     Container(
//                                                                       decoration:
//                                                                           BoxDecoration(
//                                                                         color: Colors
//                                                                             .grey
//                                                                             .shade200,
//                                                                         borderRadius:
//                                                                             BorderRadius.circular(7),
//                                                                       ),
//                                                                       padding:
//                                                                           EdgeInsets.all(
//                                                                               10),
//                                                                       width: double
//                                                                           .infinity,
//                                                                       child:
//                                                                           Center(
//                                                                         child:
//                                                                             Text(
//                                                                           "Viewers respond here",
//                                                                           style:
//                                                                               TextStyle(
//                                                                             color:
//                                                                                 Colors.grey,
//                                                                           ),
//                                                                           textScaleFactor:
//                                                                               musicViewData[currentIndex].scale,
//                                                                         ),
//                                                                       ),
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Positioned(
//                                                                 left: 0,
//                                                                 right: 0,
//                                                                 top: -20,
//                                                                 child: Center(
//                                                                   child:
//                                                                       CircleAvatar(
//                                                                     radius: 20,
//                                                                     backgroundImage:
//                                                                         NetworkImage(
//                                                                       CurrentUser()
//                                                                           .currentUser
//                                                                           .image,
//                                                                     ),
//                                                                     backgroundColor:
//                                                                         Colors
//                                                                             .grey,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                             //CHILD END
//                                                           ),
//                                                           // height: 30,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),