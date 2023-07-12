// import 'package:bizbultest/api/api.dart';
// import 'package:bizbultest/models/getContactsModel.dart';
// import 'package:bizbultest/models/user.dart';
// import 'package:bizbultest/services/Chat/chat_api.dart';
// import 'package:bizbultest/services/current_user.dart';
// import 'package:bizbultest/utilities/Chat/colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class AddPersonACall extends StatefulWidget {
//   const AddPersonACall({Key key}) : super(key: key);

//   @override
//   _AddPersonACallState createState() => _AddPersonACallState();
// }

// class _AddPersonACallState extends State<AddPersonACall> {
//   List<GetContactModel> lstGetContactModel = [];

//   bool isSearch = false;

//   @override
//   void initState() {
//     getContactDetails();
//     super.initState();
//   }

//   getContactDetails() async {
//     try {
//       User user = CurrentUser().currentUser;
//       // lstGetContactModel = await ApiProvider().getContactDetail(user.memberID);
//     } catch (e) {
//       print(e);
//     } finally {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: gradientContainer(null),
//         elevation: 0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Add Participant',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   lstGetContactModel != null ? lstGetContactModel.length.toString() + " contacts" : "0" + " contacts",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//             Icon(Icons.search),
//           ],
//         ),
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.only(right: 14, left: 14, top: 14),
//         itemCount: lstGetContactModel.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               InkWell(
//                 onTap: () async {
//                   await sendPushMessage(lstGetContactModel[index]);
//                   Navigator.pop(context, lstGetContactModel[index]);
//                 },
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 22,
//                       backgroundColor: darkColor,
//                       backgroundImage: CachedNetworkImageProvider(
//                         lstGetContactModel[index].image,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 12,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           lstGetContactModel[index].name,
//                           style: TextStyle(
//                             fontSize: 20,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Text(
//                           lstGetContactModel[index].userStatus,
//                           style: TextStyle(
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Future sendPushMessage(GetContactModel objGetContactModel) async {
//     String aa = "";
//     aa = CurrentUser().currentUser.memberID + "+audio";
//     await ChatApiCalls.sendFcmRequest(objGetContactModel.name, aa, "call", "otherMemberID", objGetContactModel.token, 0, 0, isVideo: false);
//   }
// }
