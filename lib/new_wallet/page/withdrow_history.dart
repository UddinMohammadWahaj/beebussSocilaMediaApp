// import 'package:flutter/material.dart';

// import '../connection/user_connection.dart';
// import '../model/withdrow_history_model.dart';
// class WithdrowHistoryScreen extends StatefulWidget {
//   const WithdrowHistoryScreen({Key key}) : super(key: key);

//   @override
//   State<WithdrowHistoryScreen> createState() => _WithdrowHistoryScreenState();
// }

// class _WithdrowHistoryScreenState extends State<WithdrowHistoryScreen> {
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
//         title: Text('Withdraw History',style: TextStyle(color: Colors.black),),
//       ),
//       body: Container(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 20.0,left: 25.0,right: 25.0,bottom: 5.0),
//             child:  FutureBuilder<WithdrowHistoryModel>(
//                 future: UserConnection().getWithdrowHistory(userId),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     if(snapshot.data?.walletWithdrawList?.length != 0) {
//                       return ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: snapshot.data?.walletWithdrawList?.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
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
//                                               "${snapshot.data?.walletWithdrawList[index].status}",
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.blue,
//                                                   fontWeight: FontWeight
//                                                       .w500),
//                                             ),
//                                             Text(
//                                               "${snapshot.data?.walletWithdrawList[index].createdAt?.substring(0,10).toString()}",
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
//                                         '$currency${snapshot.data?.walletWithdrawList[index].amount.toString()}',
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
//                               child: Text("No Withdrow History",
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
