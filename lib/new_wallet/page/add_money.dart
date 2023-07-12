// import 'package:bizbultest/new_wallet/page/stripe_webview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../connection/wallet_connection.dart';
// import '../model/add_balance_history_model.dart';
// import 'package:intl/intl.dart';

// import 'add_new_card.dart';

// class AddMoney extends StatefulWidget {
//   String cardId;
//   String walletBalance;

//   AddMoney({this.walletBalance = "00", this.cardId = ""});

//   @override
//   State<AddMoney> createState() => _AddMoneyState();
// }

// class _AddMoneyState extends State<AddMoney> {
//   String currency = "\$";
//   String price = "";
//   String userId = "1796768";
//   String customerId = "cus_MofXpz82rCSrKh";

//   bool walletLoding = false;
//   int showAlert = 0;

//   @override
//   void initState() {
//     /* WalleteConnection().walletBalance(userId, customerId).then((value) => {
//       if(value != null){
//         setState((){
//           walletBalance = value.balance.toString();
//           cardId = value.defaultCardId.toString();
//         }),

//       }
//     });*/
//     super.initState();
//   }

//   _willPopCallback() {
//     Navigator.of(context).pop(true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _willPopCallback(),
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 15, top: 50, right: 15),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () async {
//                             Navigator.of(context).pop(true);
//                           },
//                           child: ImageIcon(
//                             AssetImage("assets/back_arrow.png"),
//                             color: Color(0xFF000000),
//                             size: 20,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 15,
//                         ),
//                         Text(
//                           'Add Money to Bebuzee Wallet',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Color(0xFF000000),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(),
//                           flex: 1,
//                         ),
//                         Container(
//                           width: 25,
//                           height: 25,
//                           child: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               backgroundImage: NetworkImage(
//                                 'https://www.bnl.gov/today/body_pics/2017/06/stephanhruszkewycz-hr.jpg',
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 15.0, vertical: 15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 30),
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: Color(0xff2B25CC),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(8)),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black,
//                                   blurRadius: 5.0,
//                                   spreadRadius: 0.0,
//                                   offset: Offset(2.0,
//                                       2.0), // shadow direction: bottom right
//                                 )
//                               ],
//                             ),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 30.0),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     'Wallet Balance',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.normal,
//                                         fontSize: 16,
//                                         color: Colors.white70),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text('${currency}',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 18,
//                                               color: Colors.white)),
//                                       Text(widget.walletBalance,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 30,
//                                               color: Colors.white)),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 50,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 30.0),
//                                     child: widget.cardId != "null" &&
//                                             widget.cardId.isNotEmpty
//                                         ? Row(
//                                             children: [
//                                               Expanded(
//                                                   flex: 1,
//                                                   child: TextButton(
//                                                     style: ButtonStyle(
//                                                         shape: MaterialStateProperty.all(
//                                                             RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             20.0))),
//                                                         elevation:
//                                                             MaterialStateProperty
//                                                                 .all(2.0),
//                                                         backgroundColor:
//                                                             MaterialStateProperty
//                                                                 .all(Color(
//                                                                     0xffffffff))),
//                                                     onPressed: () {
//                                                       openDialog();
//                                                     },
//                                                     child: Text(
//                                                       "Add Wallet",
//                                                       style: TextStyle(
//                                                           color: Color(
//                                                               0xff2B25CC)),
//                                                     ),
//                                                   )),
//                                               SizedBox(width: 20),
//                                               Expanded(
//                                                   flex: 1,
//                                                   child: TextButton(
//                                                     style: ButtonStyle(
//                                                         shape: MaterialStateProperty.all(
//                                                             RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             20.0))),
//                                                         elevation:
//                                                             MaterialStateProperty
//                                                                 .all(2.0),
//                                                         backgroundColor:
//                                                             MaterialStateProperty
//                                                                 .all(Color(
//                                                                     0xffffffff))),
//                                                     onPressed: () {
//                                                       openWithdrowDialog();
//                                                     },
//                                                     child: Text(
//                                                       "Withdraw",
//                                                       style: TextStyle(
//                                                           color: Color(
//                                                               0xff2B25CC)),
//                                                     ),
//                                                   )),
//                                             ],
//                                           )
//                                         : Expanded(
//                                             flex: 1,
//                                             child: TextButton(
//                                               style: ButtonStyle(
//                                                   shape: MaterialStateProperty
//                                                       .all(RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       20.0))),
//                                                   elevation:
//                                                       MaterialStateProperty.all(
//                                                           2.0),
//                                                   backgroundColor:
//                                                       MaterialStateProperty.all(
//                                                           Color(0xffffffff))),
//                                               onPressed: () {
//                                                 // Navigator.of(context)
//                                                 //     .push(
//                                                 //   MaterialPageRoute(builder: (_) => AddNewCard()),
//                                                 // )
//                                                 //     .then((val) => getCardDetail());
//                                               },
//                                               child: Text(
//                                                 "Add Card",
//                                                 style: TextStyle(
//                                                     color: Color(0xff2B25CC)),
//                                               ),
//                                             )),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Center(
//                             child: Text('History',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600))),
//                         FutureBuilder<AddBalanceHistory>(
//                             future:
//                                 WalleteConnection().walletHistory(customerId),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 if (snapshot.data?.record != null &&
//                                     snapshot.data.record.data.isNotEmpty) {
//                                   return ListView.builder(
//                                       physics: NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemCount:
//                                           snapshot.data.record.data.length,
//                                       itemBuilder: (context, index) {
//                                         return Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 20.0),
//                                           child: Container(
//                                             child: Column(
//                                               children: [
//                                                 snapshot.data.record.data[index]
//                                                             .status ==
//                                                         "succeeded"
//                                                     ? Column(
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Container(
//                                                                 height: 40,
//                                                                 width: 40,
//                                                                 decoration: const BoxDecoration(
//                                                                     color: Color(
//                                                                         0x91f4eeee),
//                                                                     borderRadius:
//                                                                         BorderRadius.all(
//                                                                             Radius.circular(20))),
//                                                                 child:
//                                                                     CircleAvatar(
//                                                                   backgroundColor:
//                                                                       Colors
//                                                                           .transparent,
//                                                                   backgroundImage:
//                                                                       NetworkImage(
//                                                                           'https://www.bnl.gov/today/body_pics/2017/06/stephanhruszkewycz-hr.jpg'),
//                                                                 ),
//                                                               ),
//                                                               Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .only(
//                                                                         left:
//                                                                             20.0),
//                                                                 child: Column(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .start,
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                       'Transaction succeeded',
//                                                                       style: TextStyle(
//                                                                           fontSize:
//                                                                               16,
//                                                                           color: Colors
//                                                                               .green,
//                                                                           fontWeight:
//                                                                               FontWeight.w500),
//                                                                     ),
//                                                                     Row(
//                                                                       children: [
//                                                                         Text(
//                                                                           '+ ',
//                                                                           style: TextStyle(
//                                                                               fontSize: 18,
//                                                                               color: Colors.green,
//                                                                               fontWeight: FontWeight.bold),
//                                                                         ),
//                                                                         Text(
//                                                                           '${currency}${snapshot.data.record.data[index].amount}',
//                                                                           style: TextStyle(
//                                                                               fontSize: 18,
//                                                                               color: Colors.black,
//                                                                               fontWeight: FontWeight.bold),
//                                                                         ),
//                                                                       ],
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 flex: 1,
//                                                                 child:
//                                                                     Container(),
//                                                               ),
//                                                               Text(
//                                                                 '${DateFormat('dd,MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.record.data[index].created * 1000))}',
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         13,
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w400),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: 8,
//                                                           )
//                                                         ],
//                                                       )
//                                                     : snapshot
//                                                                 .data
//                                                                 .record
//                                                                 .data[index]
//                                                                 .status ==
//                                                             "payment_failed"
//                                                         ? Column(
//                                                             children: [
//                                                               Row(
//                                                                 children: [
//                                                                   Container(
//                                                                     height: 40,
//                                                                     width: 40,
//                                                                     decoration: const BoxDecoration(
//                                                                         color: Color(
//                                                                             0x91f4eeee),
//                                                                         borderRadius:
//                                                                             BorderRadius.all(Radius.circular(20))),
//                                                                     child:
//                                                                         CircleAvatar(
//                                                                       backgroundColor:
//                                                                           Colors
//                                                                               .transparent,
//                                                                       backgroundImage:
//                                                                           NetworkImage(
//                                                                               'https://www.bnl.gov/today/body_pics/2017/06/stephanhruszkewycz-hr.jpg'),
//                                                                     ),
//                                                                   ),
//                                                                   Padding(
//                                                                     padding: const EdgeInsets
//                                                                             .only(
//                                                                         left:
//                                                                             20.0),
//                                                                     child:
//                                                                         Column(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .start,
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Text(
//                                                                           'Transaction Failed',
//                                                                           style: TextStyle(
//                                                                               fontSize: 16,
//                                                                               color: Colors.red,
//                                                                               fontWeight: FontWeight.w500),
//                                                                         ),
//                                                                         Row(
//                                                                           children: [
//                                                                             Text(
//                                                                               '${currency}${snapshot.data.record.data[index].amount}',
//                                                                               style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
//                                                                             ),
//                                                                           ],
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                   Expanded(
//                                                                     flex: 1,
//                                                                     child:
//                                                                         Container(),
//                                                                   ),
//                                                                   Text(
//                                                                     '${DateFormat('dd,MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.record.data[index].created * 1000))}',
//                                                                     style: TextStyle(
//                                                                         fontSize:
//                                                                             13,
//                                                                         color: Colors
//                                                                             .black,
//                                                                         fontWeight:
//                                                                             FontWeight.w400),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 8,
//                                                               )
//                                                             ],
//                                                           )
//                                                         : snapshot
//                                                                     .data
//                                                                     .record
//                                                                     .data[index]
//                                                                     .status ==
//                                                                 "processing"
//                                                             ? Column(
//                                                                 children: [
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         height:
//                                                                             40,
//                                                                         width:
//                                                                             40,
//                                                                         decoration: const BoxDecoration(
//                                                                             color:
//                                                                                 Color(0x91f4eeee),
//                                                                             borderRadius: BorderRadius.all(Radius.circular(20))),
//                                                                         child:
//                                                                             CircleAvatar(
//                                                                           backgroundColor:
//                                                                               Colors.transparent,
//                                                                           backgroundImage:
//                                                                               NetworkImage('https://www.bnl.gov/today/body_pics/2017/06/stephanhruszkewycz-hr.jpg'),
//                                                                         ),
//                                                                       ),
//                                                                       Padding(
//                                                                         padding:
//                                                                             const EdgeInsets.only(left: 20.0),
//                                                                         child:
//                                                                             Column(
//                                                                           mainAxisAlignment:
//                                                                               MainAxisAlignment.start,
//                                                                           crossAxisAlignment:
//                                                                               CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             Text(
//                                                                               'Processing',
//                                                                               style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
//                                                                             ),
//                                                                             Text(
//                                                                               '${currency}${snapshot.data.record.data[index].amount}',
//                                                                               style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Expanded(
//                                                                         flex: 1,
//                                                                         child:
//                                                                             Container(),
//                                                                       ),
//                                                                       Text(
//                                                                         '${DateFormat('dd,MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.record.data[index].created * 1000))}',
//                                                                         style: TextStyle(
//                                                                             fontSize:
//                                                                                 13,
//                                                                             color:
//                                                                                 Colors.black,
//                                                                             fontWeight: FontWeight.w400),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   SizedBox(
//                                                                     height: 8,
//                                                                   )
//                                                                 ],
//                                                               )
//                                                             : Container(),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       });
//                                 } else {
//                                   return SizedBox(
//                                       height:
//                                           MediaQuery.of(context).size.height /
//                                               3,
//                                       child: Center(
//                                           child: Text("No wallet History",
//                                               style: TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight:
//                                                       FontWeight.bold))));
//                                 }
//                               } else {
//                                 return SizedBox(
//                                     height:
//                                         MediaQuery.of(context).size.height / 2,
//                                     child: Center(
//                                         child: CircularProgressIndicator(
//                                       valueColor: AlwaysStoppedAnimation(
//                                           Color(0xffF18910)),
//                                     )));
//                               }
//                             })
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               walletLoding
//                   ? SizedBox(
//                       height: MediaQuery.of(context).size.height / 1.6,
//                       child: Center(
//                           child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(Color(0xffF18910)),
//                       )))
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   showSuccess(String msg) {
//     Widget continueButton = TextButton(
//       child: const Text(
//         "Ok",
//         style: TextStyle(
//             color: Color(0xff2B25CC),
//             fontSize: 15,
//             fontWeight: FontWeight.bold),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Bebuzee Wallet",
//         style: TextStyle(fontSize: 17, color: Color(0xff91596F)),
//         textAlign: TextAlign.center,
//       ),
//       content: Text(
//         msg,
//         style: TextStyle(fontSize: 15),
//         textAlign: TextAlign.center,
//       ),
//       actions: [
//         continueButton,
//       ],
//       actionsAlignment: MainAxisAlignment.center,
//     );

//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   void openDialog() {
//     TextEditingController priceController = TextEditingController();
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Dialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//             elevation: 10,
//             child: Container(
//               height: 200,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text('Enter Amount',
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             fontSize: 20,
//                             color: Colors.black54)),
//                     TextField(
//                       controller: priceController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       decoration: InputDecoration(
//                         labelText: 'Enter Price',
//                         prefixText: '${currency}',
//                       ),
//                       onChanged: (int) {
//                         price = '${currency}$int';
//                       },
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextButton(
//                       style: ButtonStyle(
//                           shape: MaterialStateProperty.all(
//                               RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0))),
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xff2B25CC))),
//                       onPressed: () {
//                         if (priceController.text.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               backgroundColor: Colors.black,
//                               elevation: 4.0,
//                               content: const Text(
//                                 'Please enter price.',
//                                 textAlign: TextAlign.center,
//                               ),
//                               duration: const Duration(milliseconds: 2000),
//                               width: 280.0,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical:
//                                       10.0 // Inner padding for SnackBar content.
//                                   ),
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                           );
//                         } else {
//                           setState(() {
//                             Navigator.pop(context);
//                             walletLoding = true;
//                           });
//                           int walletBalance;
//                           int newBalance;
//                           WalleteConnection()
//                               .addMoney(userId, customerId, widget.cardId,
//                                   priceController.text.toString())
//                               .then((value) => {
//                                     setState(() {
//                                       walletLoding = false;
//                                     }),
//                                     if (value != null)
//                                       {
//                                         if (value.authenticationUrl
//                                             .toString()
//                                             .isEmpty)
//                                           {
//                                             walletBalance = int.tryParse(
//                                                 widget.walletBalance),
//                                             newBalance = int.tryParse(
//                                                 priceController.text),
//                                             widget.walletBalance =
//                                                 (walletBalance + newBalance)
//                                                     .toString(),
//                                           }
//                                         else
//                                           {
//                                             /** Web Authentication */
//                                             Navigator.of(context)
//                                                 .push(
//                                                   MaterialPageRoute(
//                                                       builder: (_) =>
//                                                           StripeWebview(
//                                                             url: value
//                                                                 .authenticationUrl
//                                                                 .toString(),
//                                                           )),
//                                                 )
//                                                 .then((val) => {
//                                                       walletBalance =
//                                                           int.tryParse(widget
//                                                               .walletBalance),
//                                                       newBalance = int.tryParse(
//                                                           priceController.text),
//                                                       _getRequests(
//                                                           walletBalance,
//                                                           newBalance,
//                                                           value.paymentId
//                                                               .toString())
//                                                     }),
//                                           }
//                                       }
//                                     else
//                                       {
//                                         /* setState((){
//                             showAlert = 2;
//                           })*/
//                                       }
//                                   });
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   void openWithdrowDialog() {
//     TextEditingController priceController = TextEditingController();
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Dialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//             elevation: 10,
//             child: Container(
//               height: 200,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text('Enter Amount',
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             fontSize: 20,
//                             color: Colors.black54)),
//                     TextField(
//                       controller: priceController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       decoration: InputDecoration(
//                         labelText: 'Enter Price',
//                         prefixText: '${currency}',
//                       ),
//                       onChanged: (int) {
//                         price = '${currency}$int';
//                       },
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextButton(
//                       style: ButtonStyle(
//                           shape: MaterialStateProperty.all(
//                               RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0))),
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xff2B25CC))),
//                       onPressed: () {
//                         if (priceController.text.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               backgroundColor: Colors.black,
//                               elevation: 4.0,
//                               content: const Text(
//                                 'Please enter price.',
//                                 textAlign: TextAlign.center,
//                               ),
//                               duration: const Duration(milliseconds: 2000),
//                               width: 280.0,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical:
//                                       10.0 // Inner padding for SnackBar content.
//                                   ),
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                           );
//                         } else if (int.parse(priceController.text.toString()) >
//                             int.parse(widget.walletBalance)) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               backgroundColor: Colors.black,
//                               elevation: 4.0,
//                               content: const Text(
//                                 'Your have entered incorrect amount',
//                                 textAlign: TextAlign.center,
//                               ),
//                               duration: const Duration(milliseconds: 2000),
//                               width: 280.0,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical:
//                                       10.0 // Inner padding for SnackBar content.
//                                   ),
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                           );
//                         } else {
//                           setState(() {
//                             Navigator.pop(context);
//                             walletLoding = true;
//                           });
//                           int walletBalance;
//                           int newBalance;
//                           WalleteConnection()
//                               .withdrowMoneyRequest(
//                                   userId, priceController.text.toString())
//                               .then((value) => {
//                                     setState(() {
//                                       walletLoding = false;
//                                     }),
//                                     if (value != null)
//                                       {
//                                         if (value.status == 1)
//                                           {
//                                             setState(() {
//                                               walletBalance = int.tryParse(
//                                                   widget.walletBalance);
//                                               newBalance = int.tryParse(
//                                                   priceController.text);
//                                               widget.walletBalance =
//                                                   (walletBalance - newBalance)
//                                                       .toString();
//                                             }),
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                 backgroundColor: Colors.black,
//                                                 elevation: 4.0,
//                                                 content: Text(
//                                                   value.msg,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 duration: const Duration(
//                                                     milliseconds: 2000),
//                                                 width: 280.0,
//                                                 padding: const EdgeInsets
//                                                         .symmetric(
//                                                     vertical:
//                                                         10.0 // Inner padding for SnackBar content.
//                                                     ),
//                                                 behavior:
//                                                     SnackBarBehavior.floating,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10.0),
//                                                 ),
//                                               ),
//                                             ),
//                                           }
//                                         else
//                                           {}
//                                       }
//                                   });
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   _getRequests(int walletBalance, int newBalance, String paymentId) async {
//     setState(() {
//       WalleteConnection().addMoneyWithAuth(userId, paymentId).then((value) => {
//             if (value)
//               {
//                 widget.walletBalance = (walletBalance + newBalance).toString(),
//               }
//           });
//     });
//   }

//   getCardDetail() {
//     WalleteConnection().walletBalance(userId, customerId).then((value) => {
//           if (value != null)
//             {
//               setState(() {
//                 widget.cardId = value.defaultCardId.toString();
//               }),
//             }
//         });
//   }
// }
