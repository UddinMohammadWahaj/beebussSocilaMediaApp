
// import 'package:flutter/material.dart';
// import '../connection/user_connection.dart';
// import '../model/user_recent_model.dart';
// import '../utils/constant.dart';

// class WalleToWalletScreen extends StatefulWidget {
//   const WalleToWalletScreen({Key key}) : super(key: key);

//   @override
//   State<WalleToWalletScreen> createState() => _WalleToWalletScreenState();

// }



// class _WalleToWalletScreenState extends State<WalleToWalletScreen> {

//   @override
//   void initState() {
//     super.initState();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 50,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               SizedBox(
//                 width: 15,
//               ),
//               GestureDetector(
//                   onTap: () async {
//                     Navigator.pop(context, false);
//                   },
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: ImageIcon(
//                       AssetImage("assets/back_arrow.png"),
//                       color:  Colors.black,
//                       size: 20,
//                     ),
//                   )
//               ),
//               SizedBox(
//                 width: 15,
//               ),
//               Text(
//                 'Recent Transaction',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: FutureBuilder<UserRecentModel>(
//               future:  UserConnection().getUserListWalletTransaction("1796768"),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return snapshot.data.transactions?.length != 0 ? ListView.builder(
//                       itemCount: snapshot.data.transactions?.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 0),
//                           child: GestureDetector(
//                             onTap: () {
//                            /*   Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) =>
//                                       SingleUserSendListScreen(transactionUser: snapshot.data!
//                                           .record![index])));*/
//                             },
//                             child: Card(
//                               elevation: 1,
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
//                                             '${snapshot.data.transactions[index]
//                                                 .name}',
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w800,
//                                                 fontSize: 17),
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           /*Text(
//                                             '${snapshot.data!.transactions?[index]
//                                                 .mobile}',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                                 fontSize: 13),
//                                           ),*/
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
//                           child: Text("No Recent history",
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
//       )
//       ,
//     );
//   }
// }
