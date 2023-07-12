// import 'package:bizbultest/Language/appLocalization.dart';
// import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
// import 'package:bizbultest/utilities/colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';

// import '../../models/Properbuz/properbuz_feeds_model.dart';

// class SingleMessageScreen extends StatelessWidget {
//   final List<ProperbuzFeedsModel> feed;

//   const SingleMessageScreen({Key key,this.feed}) : super(key: key);

//   Widget _selectedIcon(RxBool selected) {
//     if (selected.value) {
//       return Icon(
//         CupertinoIcons.check_mark_circled_solid,
//         size: 28,
//         color: Colors.green,
//       );
//     } else {
//       return Icon(
//         CupertinoIcons.circle,
//         size: 28,
//         color: Colors.grey.shade600,
//       );
//     }
//   }

//   Widget _searchField() {
//     return Container(
//       decoration: new BoxDecoration(
//         shape: BoxShape.rectangle,
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade500, width: 0.7),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 60,
//             alignment: Alignment.center,
//             child: Text(
//               AppLocalizations.of("To") + ":",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           ),
//           Container(
//             height: 50,
//             width: 100.0.w - 60,
//             child: TextFormField(
//               onChanged: (name) => controller.searchUsers(name),
//               maxLines: 1,
//               cursorColor: Colors.grey.shade600,
//               controller: controller.userSearchController,
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.sentences,
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500),
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 suffixIconConstraints: BoxConstraints(),
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 hintText: AppLocalizations.of(
//                   "Type a name",
//                 ),
//                 hintStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 16,
//                     fontWeight: FontWeight.normal),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _messageField(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 80,
//         decoration: new BoxDecoration(
//           shape: BoxShape.rectangle,
//           color: Colors.white,
//           border: Border(
//             top: BorderSide(color: Colors.grey.shade400, width: 0.7),
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               constraints: BoxConstraints(minHeight: 50),
//               decoration: new BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(8)),
//                 shape: BoxShape.rectangle,
//                 color: Colors.grey.shade200,
//               ),
//               width: 100.0.w - 70,
//               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: TextFormField(
//                 maxLines: null,
//                 cursorColor: Colors.grey.shade600,
//                 controller: controller.directMessageController,
//                 keyboardType: TextInputType.text,
//                 textCapitalization: TextCapitalization.sentences,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   suffixIconConstraints: BoxConstraints(),
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   hintText: AppLocalizations.of(
//                     "Type a message",
//                   ),
//                   hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () => controller.sendPostToDirect(
//                   controller.getFeedsList(val)[index].postId, context),
//               child: Container(
//                   color: Colors.transparent,
//                   width: 50,
//                   alignment: Alignment.center,
//                   child: Icon(
//                     Icons.send,
//                     color: hotPropertiesThemeColor,
//                   )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _userCard(int index, BuildContext context) {
//     return ListTile(
//       onTap: () => controller.selectUnSelectUser(index),
//       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//       leading: CircleAvatar(
//         radius: 22,
//         backgroundImage:
//             CachedNetworkImageProvider(controller.directUsersList[index].image),
//       ),
//       title: Text(
//         controller.directUsersList[index].name,
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//       subtitle: Text(
//         controller.directUsersList[index].shortcode,
//         style: TextStyle(fontSize: 15),
//       ),
//       trailing:
//           Obx(() => _selectedIcon(controller.directUsersList[index].selected)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(ProperbuzFeedController());
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context);
//         controller.unSelectAllUsers();
//         return true;
//       },
//       child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.white,
//             brightness: Brightness.light,
//             leading: IconButton(
//               splashRadius: 20,
//               icon: Icon(
//                 Icons.close,
//                 size: 28,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 controller.unSelectAllUsers();
//               },
//             ),
//             title: Text(
//               AppLocalizations.of("New Message"),
//               style: TextStyle(
//                   fontSize: 13.0.sp,
//                   color: Colors.black,
//                   fontWeight: FontWeight.normal),
//             ),
//             bottom: PreferredSize(
//                 preferredSize: Size.fromHeight(50), child: _searchField()),
//           ),
//           body: Container(
//             child: Stack(
//               children: [
//                 Obx(
//                   () => ListView.builder(
//                       padding: EdgeInsets.only(
//                           bottom: controller.isOneUserSelected.value ? 80 : 0),
//                       itemCount: controller.directUsersList.length,
//                       itemBuilder: (context, index) {
//                         return _userCard(index, context);
//                       }),
//                 ),
//                 Obx(() => Container(
//                     child: controller.isOneUserSelected.value
//                         ? Container()
//                         : _messageField(context)))
//               ],
//             ),
//           )),
//     );
//   }
// }
