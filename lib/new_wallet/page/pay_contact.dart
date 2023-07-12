
// import 'package:bizbultest/new_wallet/page/single_user_send_list.dart';
// import 'package:flutter/material.dart';

// import '../connection/user_connection.dart';
// import '../model/PayUserModel.dart';
// import '../utils/constant.dart';

// class PayContactScreen extends StatefulWidget {
//   const PayContactScreen({Key key}) : super(key: key);

//   @override
//   State<PayContactScreen> createState() =>
//       _PayContactScreenState();
// }

// class _PayContactScreenState extends State<PayContactScreen> {
//   TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//             children: [
//         Padding(
//         padding: EdgeInsets.only(left: 20,right: 20,top: 50),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 15),
//           decoration: BoxDecoration(
//             border: Border.all(color: Color(0xffA6635B)),
//             borderRadius: BorderRadius.all(Radius.circular(
//                 30.0) //                 <--- border radius here
//             ),
//           ),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.pop(context);
//                 },
//                 child: ImageIcon(
//                   AssetImage("assets/back_arrow.png"),
//                   color: Color(0xFF000000),
//                   size: 20,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     enabledBorder: new OutlineInputBorder(
//                       borderRadius: new BorderRadius.circular(25.0),
//                       borderSide: BorderSide(color: Color(0x00000000)),
//                     ),
//                     focusedBorder: new OutlineInputBorder(
//                       borderRadius: new BorderRadius.circular(250.0),
//                       borderSide: BorderSide(color: Color(0x00000000)),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     hintText: 'Search transaction history',
//                   ),
//                   controller: searchController,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(height: 20,),
//       Expanded(
//         child: FutureBuilder<PayUserModel>(
//           future: UserConnection().payByContact("2"),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return snapshot.data.user.length != 0 ? ListView.builder(
//                   itemCount: snapshot.data.user?.length,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) =>
//                                   SingleUserSendListScreen(
//                                       otherUserId: snapshot.data.user[index]
//                                           .id.toString(),
//                                       userName: snapshot.data.user[index]
//                                           .name.toString(),
//                                       userProfile: snapshot.data.user[index]
//                                           .profileImage.toString())),);
//                         },
//                         child: Card(
//                           elevation: 1,
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 10.0,
//                                 bottom: 12.0,
//                                 left: 15.0,
//                                 right: 15.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 CircleAvatar(
//                                   backgroundColor: Colors.brown.shade800,
//                                   backgroundImage: NetworkImage(
//                                     '${Constant.PROFILE_URL}${snapshot.data
//                                         .user[index].profileImage}',),
//                                 ),
//                                 SizedBox(
//                                   width: 25,
//                                 ),
//                                 Flexible(child: Container(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment
//                                         .start,
//                                     children: [
//                                       Text(
//                                         '${snapshot.data.user[index]
//                                             .name}',
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w800,
//                                             fontSize: 17),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         '${snapshot.data.user[index]
//                                             .mobile}',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.normal,
//                                             fontSize: 13),
//                                       ),
//                                     ],
//                                   ),
//                                 ))
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   })
//                   : SizedBox(
//                   height: MediaQuery
//                       .of(context)
//                       .size
//                       .height / 1.5,
//                   child: Center(
//                       child: Text("No user found",
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold))));
//             } else {
//               return SizedBox(
//                   height: MediaQuery
//                       .of(context)
//                       .size
//                       .height / 1.3,
//                   child: Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(Color(
//                             0xffF18910)),
//                       )));
//             }
//           },
//         ),)
//         ],
//       ),
//     ),);
//   }
// }
