// import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
// import 'package:bizbultest/utilities/colors.dart';
// import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ReviewCard extends GetView {
//   List<ReviewData> reviewDataList = [];
//   int index;
//   ReviewCard(
//     List<ReviewData> value,
//     int index, {
//     Key key,
//   }) : super(key: key);

//   Widget _nameCard(index) {
//     return Text(
//       reviewDataList[index].memberName,
//       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//     );
//   }

//   Widget _reviewDescriptionCard(index) {
//     return Container(
//       padding: EdgeInsets.only(top: 10),
//       child: Text(
//         reviewDataList[index].review,
//         style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.normal,
//             color: Colors.grey.shade700),
//       ),
//     );
//   }

//   Widget _ratingsIconCard(
//     IconData icon,
//     rate,
//   ) {
//     return Container(
//       padding: EdgeInsets.only(right: 15),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: settingsColor,
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Text(
//             rate,
//             style: TextStyle(color: settingsColor),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _ratingsIconRow(index) {
//     return Container(
//       padding: EdgeInsets.only(top: 10),
//       child: Row(
//         children: [
//           _ratingsIconCard(
//               Icons.access_time_outlined, reviewDataList[index].timeRate),
//           _ratingsIconCard(
//               Icons.cleaning_services, reviewDataList[index].serviceRate),
//           _ratingsIconCard(Icons.emoji_emotions_outlined,
//               reviewDataList[index].satisfactionRate),
//           _ratingsIconCard(Icons.handyman, reviewDataList[index].workRate),
//         ],
//       ),
//     );
//   }

//   Widget _customerCard(index) {
//     return Container(
//         padding: EdgeInsets.only(top: 10),
//         child: Text(
//           "– Customer in Ferla (1) 04 January 2019",
//           style: TextStyle(color: Colors.grey.shade600),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(TradesmenResultsController());
//     return Container(
//       padding: EdgeInsets.only(left: 10, bottom: 15, right: 10, top: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _nameCard(index),
//           _reviewDescriptionCard(index),
//           _ratingsIconRow(index),
//           _customerCard(index)
//         ],
//       ),
//     );
//   }
// }
