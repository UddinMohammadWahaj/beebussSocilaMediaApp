
// import 'package:bizbultest/new_wallet/page/single_user_send_list.dart';
// import 'package:flutter/material.dart';

// import '../connection/user_connection.dart';
// import '../model/all_transaction_history_model.dart';
// import '../utils/constant.dart';


// class TransacationScreen extends StatefulWidget {
//   const TransacationScreen({Key key}) : super(key: key);

//   @override
//   State<TransacationScreen> createState() => _TransacationScreenState();
// }

// class _TransacationScreenState extends State<TransacationScreen> {
//   TextEditingController searchController = TextEditingController();
//   bool isSearch = false;
//   bool isOnTap = false;
//   String filterType = "";
//   String userId = "1796768";
//   String currency = "\$";

//   onSearchTextChanged(String text) async {
//     print("onSearchTextChanged Key $text");
//     if (text.isEmpty) {
//       setState(() {
//         searchController.clear();
//         isSearch = false;
//       });
//     } else {
//       setState(() {
//         isOnTap = false;
//         isSearch = true;
//       });
//     }
//   }

//   onTextChanged(String text) async {
//     if (text.isEmpty) {
//       setState(() {
//         print("OnTextEmplty Key $text");
//         searchController.clear();
//         isSearch = false;
//         isOnTap = false;
//       });
//     }else {
//       setState(() {
//         filterType  = "";
//       });
//     }
//   }

//   openTap() async {
//     setState(() {
//       isOnTap = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 50,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Color(0xffA6635B)),
//                 borderRadius: BorderRadius.all(Radius.circular(
//                         30.0) //                 <--- border radius here
//                     ),
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.pop(context);
//                     },
//                     child: ImageIcon(
//                       AssetImage("assets/back_arrow.png"),
//                       color: Color(0xFF000000),
//                       size: 20,
//                     ),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         enabledBorder: new OutlineInputBorder(
//                           borderRadius: new BorderRadius.circular(25.0),
//                           borderSide: BorderSide(color: Color(0x00000000)),
//                         ),
//                         focusedBorder: new OutlineInputBorder(
//                           borderRadius: new BorderRadius.circular(250.0),
//                           borderSide: BorderSide(color: Color(0x00000000)),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         hintText: 'Search transaction history',
//                       ),
//                       onChanged: onTextChanged,
//                       controller: searchController,
//                       onTap: openTap,
//                       onSubmitted: onSearchTextChanged,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           isOnTap
//               ? Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
//             child: Container(
//               decoration: const BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.all(Radius.circular(8))),
//               height: 200,
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 40, vertical: 0),
//                     child: GestureDetector(
//                       onTap: () {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         setState(() {
//                           isOnTap = false;
//                           filterType = "this_month";
//                         });
//                       },
//                       child: Container(
//                         child: Text('This month',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                                 color: Color(0xFFFFFFFF), fontSize: 17)),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: Container(
//                       height: 1,
//                       color: Color(0xc2f4eeee),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 40, vertical: 0),
//                     child: GestureDetector(
//                       onTap: () {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         setState(() {
//                           isOnTap = false;
//                           filterType = "last_month";
//                         });
//                       },
//                       child: Container(
//                         child: Text('Last month',
//                             style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFFFFFFFF), fontSize: 17)),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: Container(
//                       height: 1,
//                       color: Color(0xc2f4eeee),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 40, vertical: 0),
//                     child: GestureDetector(
//                       onTap: () {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         setState(() {
//                           isOnTap = false;
//                           filterType = "this_week";
//                         });
//                       },
//                       child: Container(
//                         child: Text('This week',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFFFFFFF), fontSize: 17)),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: Container(
//                       height: 1,
//                       color: Color(0xc2f4eeee),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 40, vertical: 0),
//                     child: GestureDetector(
//                       onTap: () {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         setState(() {
//                           isOnTap = false;
//                           filterType = "fail";
//                         });
//                       },
//                       child: Container(
//                         child: Text('Failed',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFFFFFFF), fontSize: 17)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//               : Container(),
//           /* SizedBox(
//                 height: 20,
//               ),*/
//           Expanded(
//             child: FutureBuilder<AllTransactionHistoryModel>(
//               future: UserConnection().getFilterTransaction(userId,filterType,searchController.text.toString()),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   filterType  = "";
//                   return snapshot.data.transactions.isNotEmpty ?
//                   ListView.builder(
//                       itemCount: snapshot.data.transactions.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 8),
//                           child: GestureDetector(
//                             onTap: () {
//                               snapshot.data.transactions[index].transaction == "bebuzee_video_campaign" ||
//                                   snapshot.data.transactions[index].transaction == "bebuzee_banner_campaign" ||
//                                   snapshot.data.transactions[index].transaction == "bebuzee_sponsor_campaign" ||
//                                   snapshot.data.transactions[index].transaction == "wallet_recharge"
//                               ?Container() :
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) =>
//                                       SingleUserSendListScreen(otherUserId: snapshot.data
//                                           .transactions[index].id.toString(),userName: snapshot.data
//                                           .transactions[index].name.toString(),
//                                       userProfile: snapshot.data
//                                           .transactions[index].profileImage.toString(),)));
//                             },
//                             child: Card(
//                               elevation: 5,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 10.0,
//                                     bottom: 12.0,
//                                     left: 15.0,
//                                     right: 15.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.brown.shade800,
//                                       backgroundImage: NetworkImage(
//                                         '${Constant.PROFILE_URL}${snapshot.data
//                                             .transactions[index].profileImage}',),
//                                     ),
//                                     SizedBox(
//                                       width: 25,
//                                     ),
//                                     Flexible(child: Container(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Text(
//                                             snapshot.data.transactions[index].transaction == "bebuzee_video_campaign" ?
//                                                 'Video Campaign':
//                                             snapshot.data.transactions[index].transaction == "bebuzee_banner_campaign" ?
//                                                 "Banner Campaign" :
//                                             snapshot.data.transactions[index].transaction == "bebuzee_sponsor_campaign" ?
//                                                 "Sponsor Campaign" :
//                                             snapshot.data.transactions[index].transaction == "wallet_recharge" ?
//                                             "Wallet Recharge" :
//                                             '${snapshot.data.transactions[index].name}',
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w800,
//                                                 fontSize: 17),
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                             snapshot.data.transactions[index].transaction == "bebuzee_video_campaign" ?
//                                             '$currency ${snapshot.data.transactions[index]
//                                                 .amount}':
//                                             snapshot.data.transactions[index].transaction == "bebuzee_banner_campaign" ?
//                                             "$currency ${snapshot.data.transactions[index]
//                                                 .amount}" :
//                                             snapshot.data.transactions[index].transaction == "bebuzee_sponsor_campaign" ?
//                                             "$currency ${snapshot.data.transactions[index]
//                                                 .amount}" :
//                                             snapshot.data.transactions[index].transaction == "wallet_recharge" ?
//                                             "$currency ${snapshot.data.transactions[index]
//                                                 .amount}" :
//                                             '${snapshot.data.transactions[index]
//                                                 .mobile}',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                                 fontSize: 15),
//                                           ),
//                                         ],
//                                       ),
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       })
//                       : SizedBox(
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height / 1.5,
//                       child: Center(
//                           child: Text("No transaction history",
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold))));
//                 } else {
//                   return SizedBox(
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height / 1.3,
//                       child: Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(
//                                 Color(0xffF18910)),
//                           )));
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
