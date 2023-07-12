// import 'package:flutter/material.dart';

// import '../connection/user_connection.dart';
// import '../model/recent_ransaction_model.dart';
// class RecentActivity extends StatefulWidget {
//   const RecentActivity({Key key}) : super(key: key);

//   @override
//   State<RecentActivity> createState() => _RecentActivityState();
// }

// class _RecentActivityState extends State<RecentActivity> {
//   String currency = "\$";
//   String userId = "1796768";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text('Recent Activity',style: TextStyle(color: Colors.black),),
//       ),
//       body: Container(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 20.0,left: 25.0,right: 25.0,bottom: 5.0),
//             child:  FutureBuilder<RecentTransactionModel>(
//                 future: UserConnection().otherWalletTransaction(userId),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     if(snapshot.data?.transactions?.length != 0) {
//                       return ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: snapshot.data?.transactions?.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       /* Container(
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
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.only(left: 0.0),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children:  [
//                                             Text(
//                                               "${snapshot.data?.transactions[index].description}",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight
//                                                       .w500),
//                                             ),
//                                             Text(
//                                               "${snapshot.data?.transactions[index].createdAt?.substring(0,10).toString()}",
//                                               style: TextStyle(
//                                                   fontSize: 13,
//                                                   color: Colors.black,
//                                                   fontWeight:
//                                                   FontWeight.normal),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(),
//                                       ),
//                                       Text(
//                                         '$currency${snapshot.data?.transactions[index].amount.toString()}',
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   )
//                                 ],
//                               ),
//                             );
//                           });
//                     }else {
//                       return SizedBox(
//                           height: MediaQuery
//                               .of(context)
//                               .size
//                               .height / 1,
//                           child: Center(
//                               child: Text("No Recent History",
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold))));
//                     }
//                   } else {
//                      return SizedBox(
//                         height: MediaQuery
//                             .of(context)
//                             .size
//                             .height / 1,
//                         child: Center(
//                             child: CircularProgressIndicator(
//                               valueColor:
//                               AlwaysStoppedAnimation(
//                                   Color(0xffF18910)),
//                             )));
//                   }
//                 })
//         ),
//       ),
//     );
//   }
// }
