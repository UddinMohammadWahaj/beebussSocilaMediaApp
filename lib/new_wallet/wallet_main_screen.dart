
// import 'package:bizbultest/new_wallet/page/add_money.dart';
// import 'package:bizbultest/new_wallet/page/cardlist.dart';
// import 'package:bizbultest/new_wallet/page/more.dart';
// import 'package:bizbultest/new_wallet/page/recent_activity.dart';
// import 'package:bizbultest/new_wallet/page/send_user.dart';
// import 'package:bizbultest/new_wallet/page/sendlist.dart';
// import 'package:bizbultest/new_wallet/page/single_user_send_list.dart';
// import 'package:bizbultest/new_wallet/page/wallet_to_wallet.dart';
// import 'package:bizbultest/new_wallet/utils/constant.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'connection/user_connection.dart';
// import 'connection/wallet_connection.dart';
// import 'model/add_balance_history_model.dart';
// import 'model/recent_ransaction_model.dart';
// import 'model/user_recent_model.dart';

// class WalletMainScreen extends StatefulWidget {
//   const WalletMainScreen({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   State<WalletMainScreen> createState() => _WalletMainScreenState();
// }

// class _WalletMainScreenState extends State<WalletMainScreen> {
//   String currency = "\$";
//   bool isMore = false;
//   bool isFirst = true;

//   String userId = "1796768";
//   String customerId = "cus_MofXpz82rCSrKh";
//   String walletBalance = "0";
//   String cardId = "";
//   List<Record> userRecentList = [];

//   _getRequests() async {
//     setState(() {
//       print('Home Page Refresh');
//       isBalanceAPI();
//     });
//   }

//   @override
//   void initState() {
//     isBalanceAPI();
//     super.initState();
//   }




//   isBalanceAPI() {
//     WalleteConnection().walletBalance(userId, customerId).then((value) => {
//           if (value != null)
//             {
//               setState(() {
//                 walletBalance = value.balance.toString() == "null"
//                     ? "0"
//                     : value.balance.toString();
//                 cardId = value.defaultCardId.toString();
//               }),
//             }
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: ScrollPhysics(),
//         child: Padding(
//           padding:
//               const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Hello User',
//                 style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.black,
//                     fontWeight: FontWeight.normal),
//               ),
//               const Text(
//                 'Welcome Back!',
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(
//                 height: 20.0,
//               ),
//               Container(
//                 decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.topRight,
//                         colors: <Color>[
//                           const Color(0xff2B25CC),
//                           const Color(0xffA6635B),
//                           const Color(0xff91596F),
//                           const Color(0xffB46A4D),
//                           const Color(0xffF18910),
//                           const Color(0xffA6635B),
//                         ]),
//                     borderRadius: BorderRadius.all(Radius.circular(8))),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 25.0, right: 25.0, top: 20, bottom: 20),
//                   child: IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Current Balance',
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               '${currency} ${walletBalance}',
//                               style: TextStyle(
//                                   fontSize: 25,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               FloatingActionButton(
//                                 onPressed: () {
//                                   Navigator.of(context)
//                                       .push(MaterialPageRoute(
//                                           builder: (context) => AddMoney(
//                                               walletBalance: walletBalance,
//                                               cardId: cardId)))
//                                       .then((value) => {
//                                             if (value) {_getRequests()}
//                                           });
//                                 },
//                                 backgroundColor: Colors.black45,
//                                 child: const Icon(Icons.add),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 25.0,
//               ),
//               IntrinsicHeight(
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (_, __, ___) => SendList(),
//                             transitionDuration: Duration(milliseconds: 1000),
//                             transitionsBuilder: (_, a, __, c) =>
//                                 FadeTransition(opacity: a, child: c),
//                           ),
//                         ).then((value) => {
//                           _getRequests()
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Color(0xff91596F),
//                             borderRadius: BorderRadius.all(Radius.circular(8))),
//                         child: Center(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(top: 20.0, bottom: 18.0),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: const BoxDecoration(
//                                       color: Color(0x36f4eeee),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(20))),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: ImageIcon(
//                                         AssetImage("assets/send.png"),
//                                         color: Color(0xFFFFFFFF)),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 17,
//                                 ),
//                                 const Text(
//                                   'Send',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     )),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Expanded(
//                         child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (_, __, ___) => CardList(),
//                             transitionDuration: Duration(milliseconds: 650),
//                             transitionsBuilder: (_, a, __, c) =>
//                                 FadeTransition(opacity: a, child: c),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Color(0xffF18910),
//                             borderRadius: BorderRadius.all(Radius.circular(8))),
//                         child: Center(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(top: 20.0, bottom: 18.0),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: const BoxDecoration(
//                                       color: Color(0x36f4eeee),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(20))),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: ImageIcon(
//                                         AssetImage("assets/card.png"),
//                                         color: Color(0xFFFFFFFF)),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 17,
//                                 ),
//                                 const Text(
//                                   'Card',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     )),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Expanded(
//                         child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (_, __, ___) => MoreScreen(),
//                             transitionDuration: Duration(milliseconds: 650),
//                             transitionsBuilder: (_, a, __, c) =>
//                                 FadeTransition(opacity: a, child: c),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Color(0xffA6635B),
//                             borderRadius: BorderRadius.all(Radius.circular(8))),
//                         child: Center(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(top: 20.0, bottom: 18.0),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: const BoxDecoration(
//                                       color: Color(0x36f4eeee),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(20))),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: ImageIcon(
//                                         AssetImage("assets/dot_menu.png"),
//                                         color: Color(0xFFFFFFFF)),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 17,
//                                 ),
//                                 const Text(
//                                   'More',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ))
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 25.0,
//               ),
//               /*** User to user Recent transaction data */
//               FutureBuilder<UserRecentModel>(
//                   future: UserConnection().getRecentUserHome(userId),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       if (snapshot.data.transactions.length != 0) {
//                         return GridView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 4, childAspectRatio: 1),
//                           itemCount: snapshot.data.transactions.length,
//                           itemBuilder: (context, index) {
//                             if (snapshot.data.transactions.isNotEmpty) {
//                               if (isFirst) {
//                                 return Padding(
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: index == 7 && !isMore
//                                         ? Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   /*setState(() {
//                                         isMore = true;
//                                         isFirst = false;
//                                       });*/
//                                                   Navigator.push(
//                                                     context,
//                                                     PageRouteBuilder(
//                                                       pageBuilder: (_, __,
//                                                               ___) =>
//                                                           WalleToWalletScreen(),
//                                                       transitionDuration:
//                                                           Duration(
//                                                               milliseconds:
//                                                                   650),
//                                                       transitionsBuilder:
//                                                           (_, a, __, c) =>
//                                                               FadeTransition(
//                                                                   opacity: a,
//                                                                   child: c),
//                                                     ),
//                                                   ) .then((value) => {
//                                                     _getRequests()
//                                                   });
//                                                 },
//                                                 child: CircleAvatar(
//                                                   backgroundColor:
//                                                       Colors.black54,
//                                                   child: ImageIcon(
//                                                       AssetImage(
//                                                           "assets/dot_menu.png"),
//                                                       color: Color(0xFFFFFFFF)),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Text(
//                                                 'More',
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.normal),
//                                               ),
//                                             ],
//                                           )
//                                         : index > 7
//                                             ? Container()
//                                             : Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       Navigator.of(context).push(
//                                                           MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   SingleUserSendListScreen(otherUserId:snapshot.data.transactions[index].id.toString(),
//                                                                       userProfile:snapshot.data.transactions[index].profileImage.toString(),
//                                                               userName:snapshot.data.transactions[index].name.toString())))
//                                                           .then((value) => {
//                                                         _getRequests()
//                                                       });
//                                                     },
//                                                     child: CircleAvatar(
//                                                       backgroundColor:
//                                                           Colors.transparent,
//                                                       backgroundImage:
//                                                           NetworkImage(
//                                                         '${Constant.PROFILE_URL}${snapshot.data.transactions[index].profileImage}',
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                   Padding(padding: EdgeInsets.only(left: 10),child:   Text(
//                                                     '${snapshot.data.transactions[index].name}',
//                                                     overflow: TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.normal),
//                                                   ),)
//                                                 ],
//                                               ));
//                               } else if (!isFirst) {
//                                 return Padding(
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.of(context).push(
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         SendUser()));
//                                           },
//                                           child: CircleAvatar(
//                                             backgroundColor: Colors.transparent,
//                                             backgroundImage: NetworkImage(
//                                               '${Constant.PROFILE_URL}${snapshot.data.transactions[index].profileImage}',
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Padding(padding: EdgeInsets.only(left: 10),child:   Text(
//                                           '${snapshot.data.transactions[index].name}',
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.normal),
//                                         ),)

//                                       ],
//                                     ));
//                               } else
//                                 return Container();
//                             } else {
//                               return Container();
//                             }
//                           },
//                         );
//                       } else {
//                         return Container();
//                       }
//                     } else {
//                       return Container();
//                     }
//                   }),
//               const SizedBox(
//                 height: 15.0,
//               ),
//               Row(
//                 children: [
//                   const Text(
//                     'Recent activity',
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Container(),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder: (_, __, ___) => RecentActivity(),
//                           transitionDuration: Duration(milliseconds: 650),
//                           transitionsBuilder: (_, a, __, c) =>
//                               FadeTransition(opacity: a, child: c),
//                         ),
//                       ) .then((value) => {
//                         _getRequests()
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 8.0,
//                       ),
//                       child: const Text(
//                         'See all',
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20.0,
//               ),
//               /*** User to bebuzee Recent transaction data */
//               FutureBuilder<RecentTransactionModel>(
//                   future: UserConnection().getRecentTransactionHome("1796768"),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       if(snapshot.data.transactions.length != 0) {
//                         return ListView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: snapshot.data.transactions.length,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                        /* Container(
//                                           height: 40,
//                                           width: 40,
//                                           decoration: const BoxDecoration(
//                                               color: Color(0x91f4eeee),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(20))),
//                                           child: CircleAvatar(
//                                             backgroundColor: Colors.transparent,
//                                             backgroundImage: NetworkImage(
//                                                 'https://www.bnl.gov/today/body_pics/2017/06/stephanhruszkewycz-hr.jpg'),
//                                           ),
//                                         ),*/
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.only(left: 0.0),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children:  [
//                                               Text(
//                                                 snapshot.data.transactions[index].description,
//                                                 style: TextStyle(
//                                                     fontSize: 16,
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight
//                                                         .w500),
//                                               ),
//                                               Text(
//                                                 snapshot.data.transactions[index].createdAt.substring(0,10),
//                                                 style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                     FontWeight.normal),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Container(),
//                                         ),
//                                         Text(
//                                           '${currency}${snapshot.data.transactions[index].amount.toString()}',
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     )
//                                   ],
//                                 ),
//                               );
//                             });
//                       }else {
//                         return SizedBox(
//                             height: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height / 3,
//                             child: Center(
//                                 child: Text("No Recent History",
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold))));
//                       }
//                     } else {
//                       return Container();
//                     }
//                   })
//             ],
//           ),
//         ),
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
