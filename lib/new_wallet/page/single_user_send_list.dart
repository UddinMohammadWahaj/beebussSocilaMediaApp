
// import 'package:bizbultest/new_wallet/page/request_pay.dart';
// import 'package:bizbultest/new_wallet/page/send_user.dart';
// import 'package:bizbultest/new_wallet/page/transaction_detail.dart';
// import 'package:flutter/material.dart';
// import '../connection/user_connection.dart';
// import '../model/user_list_transaction_model.dart';
// import '../utils/constant.dart';

// class SingleUserSendListScreen extends StatefulWidget {
//   String userName;
//   String userProfile;
//   String otherUserId;

//   SingleUserSendListScreen( {this.userName = "", this.userProfile = "", this.otherUserId = ""});

//   @override
//   State<SingleUserSendListScreen> createState() =>
//       _SingleUserSendListScreenState();
// }

// class _SingleUserSendListScreenState extends State<SingleUserSendListScreen> {
//   String currency = "\$";
//   String userId = "1796768";

//   _getRequests() async {
//     setState(() {
//       print('SingleUserSendListScreen Refresh');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color(0xFF010101),
//         appBar: AppBar(
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           backgroundColor: Color(0xFF010101),
//           flexibleSpace: SafeArea(
//             child: Container(
//               padding: EdgeInsets.only(right: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.pop(context);
//                     },
//                     child: ImageIcon(
//                       AssetImage("assets/back_arrow.png"),
//                       color: Color(0xffFFFFFF),
//                       size: 20,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: 10.0, bottom: 12.0, left: 15.0, right: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ClipRRect(
//                             borderRadius: BorderRadius.circular(50.0),
//                             child: widget.userProfile.toString() == ""
//                                 ? Image.asset(
//                                     'assets/user_placeholder.png',
//                                     width: 35.0,
//                                     height: 35.0,
//                                     fit: BoxFit.fill,
//                                   )
//                                 : Image.network(
//                                     '${Constant.PROFILE_URL}${widget.userProfile}',
//                                     height: 35,
//                                     width: 35,
//                                     fit: BoxFit.fill,
//                                   )),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           '${widget.userName}',
//                           style: TextStyle(
//                             color: Color(0xffFFFFFF),
//                               fontWeight: FontWeight.w800, fontSize: 17),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   height: 0.5,
//                   color: Color(0xffFFFFFF),
//                 ),
//                 Expanded(
//                   child: FutureBuilder<UserListTrasactionModel>(
//                       future: UserConnection().getUserToUserTransaction(userId,widget.otherUserId),
//                       builder: (context, snapshot) {
//                         if(snapshot.hasData){
//                           return snapshot.data?.transactions?.length != 0 ?
//                           ListView.builder(
//                             itemCount: snapshot.data?.transactions?.length,
//                             shrinkWrap: true,
//                             reverse: true,
//                             padding: EdgeInsets.only(top: 10, bottom: 70),
//                             itemBuilder: (context, index) {
//                                return
//                                GestureDetector(
//                                  onTap: (){
//                                    snapshot.data?.transactions[index].transactionType.toString() == "payment_request"
//                                        && snapshot.data?.transactions[index].userId.toString() != userId ?
//                                    Navigator.of(context).push(MaterialPageRoute(
//                                        builder: (context) => SendUser(
//                                          amount: snapshot.data?.transactions[index].amount.toString() ?? "",
//                                            otherUserId: widget.otherUserId,
//                                            userName: widget.userName,
//                                            userProfile: widget.userProfile)),):
//                                    snapshot.data?.transactions[index].transactionType.toString() == "debit" ||
//                                        snapshot.data?.transactions[index].transactionType.toString() == "credit"?
//                                    Navigator.of(context).push(MaterialPageRoute(
//                                        builder: (context) => TransactionDetailScreen(
//                                            transactionId: snapshot.data?.transactions[index].id.toString() ?? "",
//                                        )),): null;

//                                  },
//                                  child: Container(
//                                  width: double.infinity,
//                                   padding: EdgeInsets.only(
//                                       left: 14, right: 14, top: 10, bottom: 10),
//                                   child: Align(
//                                     alignment: (
//                                         snapshot.data?.transactions[index].transactionType.toString() == "debit"
//                                         ? Alignment.topRight:snapshot
//                                         .data?.transactions[index].transactionType.toString() == "credit"
//                                         ? Alignment.topLeft
//                                         : snapshot.data?.transactions[index].transactionType.toString() == "payment_request"
//                                         && snapshot.data?.transactions[index].userId.toString() == userId ?
//                                          Alignment.topRight
//                                         : Alignment.topLeft),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         color: Color(0xFF1c1c1c),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 16, horizontal: 30),
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             snapshot.data?.transactions[index].transactionType.toString() == "debit"
//                                                 ? 'Pay to ${widget.userName}'
//                                                 : snapshot.data?.transactions[index].transactionType.toString() == "credit"? "Pay to you"
//                                                 : 'Payment Request',
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 18),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Text(
//                                             '${currency}${snapshot.data?.transactions[index].amount.toString()}',
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.normal,
//                                                 fontSize: 25),
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               ImageIcon(
//                                                 AssetImage("assets/check.png"),
//                                                 color: Color(0xFF358F0B),
//                                                 size: 10,
//                                               ),
//                                               SizedBox(
//                                                 width: 5,
//                                               ),
//                                               Text(
//                                                 '${snapshot.data?.transactions[index].createdAt.toString().substring(0,snapshot.data?.transactions[index].createdAt.toString().indexOf("T")).trim()}',
//                                                 style: TextStyle(
//                                                     color: Colors.green,
//                                                     fontWeight: FontWeight.normal,
//                                                     fontSize: 13),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),);
//                             },
//                           ):SizedBox(
//                               height: MediaQuery.of(context).size.height / 1.5,
//                               child: Center(
//                                   child: Text("No transacation history",
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold))));
//                         }else {
//                           return SizedBox(
//                               height: MediaQuery
//                                   .of(context)
//                                   .size
//                                   .height / 2,
//                               child: Center(
//                                   child: CircularProgressIndicator(
//                                     valueColor:
//                                     AlwaysStoppedAnimation(
//                                         Color(0xffF18910)),
//                                   )));
//                         }

//                       }),
//                 )
//               ],
//             ),
//             Positioned(
//               child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     color:  Color(0xFF010101),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               right: 0, top: 15, left: 10, bottom: 15),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.of(context)
//                                   .push(
//                                     MaterialPageRoute(
//                                         builder: (_) =>
//                                             SendUser(userName: widget.userName,
//                                                 userProfile:widget.userProfile,
//                                                 otherUserId: widget.otherUserId)),
//                                   )
//                                   .then((val) => _getRequests());
//                             },
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                   color: Color(0xff3f63B5),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20))),
//                               child: const Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 40.0,
//                                     right: 40.0,
//                                     top: 10.0,
//                                     bottom: 10.0),
//                                 child: Text(
//                                   'Pay',
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               right: 0, top: 15, left: 10, bottom: 15),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.of(context)
//                                   .push(
//                                     MaterialPageRoute(
//                                         builder: (_) =>
//                                             RequestPayScreen(userName: widget.userName,userProfile:widget.userProfile ,otherUserId: widget.otherUserId)),
//                                   )
//                                   .then((val) => _getRequests());
//                             },
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                   color: Color(0xff3f63B5),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20))),
//                               child: const Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 25.0,
//                                     right: 25.0,
//                                     top: 10.0,
//                                     bottom: 10.0),
//                                 child: Text(
//                                   'Request',
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   )),
//             ),
//           ],
//         ));
//   }
// }
