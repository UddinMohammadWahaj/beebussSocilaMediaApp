// import 'dart:math';

// import 'package:bizbultest/Language/appLocalization.dart';
// import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
// import 'package:bizbultest/utilities/colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';

// class SearchedPropertyCard extends GetView<UserPropertiesController> {
//   final int index;

//   const SearchedPropertyCard({Key key, this.index}) : super(key: key);

//   Widget _imageCard() {
//     var r = Random();
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(3),
//       child: Image(
//         image: CachedNetworkImageProvider(controller.images[r.nextInt(controller.images.length)]),
//         fit: BoxFit.cover,
//         height: 70,
//         width: 70,
//       ),
//     );
//   }

//   Widget _customTile(BuildContext context, int index) {
//     return Container(
//       decoration: new BoxDecoration(
//         shape: BoxShape.rectangle,
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade300, width: 1),
//         ),
//       ),
//       padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             child: Row(
//               children: [
//                 _imageCard(),
//                 Container(
//                   padding: EdgeInsets.only(left: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(bottom: 4),
//                         width: 100.0.w - 150,
//                         child: Text(
//                           AppLocalizations.of(
//                             "Trilocale Via Poma 61, Milano",
//                           ),
//                           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Container(
//                         width: 100.0.w - 150,
//                         child: Text(
//                           AppLocalizations.of(
//                             "Milan, Via Carlo Poma",
//                           ),
//                           style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//                         ),
//                       ),
//                       Text(
//                         AppLocalizations.of(
//                               "Price:",
//                             ) +
//                             " € 555,000",
//                         style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             splashRadius: 20,
//             icon: Icon(
//               CupertinoIcons.delete,
//               size: 22,
//               color: settingsColor,
//             ),
//             color: Colors.black,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(UserPropertiesController());
//     return _customTile(context, index);
//   }
// }
