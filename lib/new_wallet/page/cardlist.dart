// import 'package:flutter/material.dart';
// import '../connection/wallet_connection.dart';
// import '../model/cardlist_model.dart';
// import '../utils/dialogutils.dart';
// import 'add_new_card.dart';

// class CardList extends StatefulWidget {
//   const CardList({Key key}) : super(key: key);

//   @override
//   State<CardList> createState() => _CardListState();
// }

// class _CardListState extends State<CardList> {
//   _getRequests() async {
//     setState(() {
//       print('Page Refresh');
//       getPrimaryDetail();
//     });
//   }

//   String customerId = "cus_MofXpz82rCSrKh";
//   bool isConnect = false;
//   String primaryCard = "";

//   void getPrimaryDetail() {
//     WalleteConnection().getPrimaryCard(customerId).then((value) => {
//           if (value.status == 1)
//             {
//               setState(() {
//                 primaryCard = value.card;
//               }),
//             }
//           else
//             {
//               primaryCard = "",
//             }
//         });
//   }

//   @override
//   void initState() {
//     getPrimaryDetail();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 15, top: 50),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.pop(context);
//                     },
//                     child: const ImageIcon(
//                       AssetImage("assets/back_arrow.png"),
//                       color: Color(0xFF000000),
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   const Text(
//                     'Cards',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Color(0xFF000000),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(),
//                   flex: 1,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20, top: 20),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Navigator.of(context)
//                       //     .push(
//                       //       MaterialPageRoute(builder: (_) => AddNewCard()),
//                       //     )
//                       //     .then((val) => val ? _getRequests() : false);
//                     },
//                     child: Container(
//                       decoration: const BoxDecoration(
//                           color: Color(0xffA6635B),
//                           borderRadius: BorderRadius.all(Radius.circular(20))),
//                       child: const Padding(
//                         padding: EdgeInsets.only(
//                             left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
//                         child: Text(
//                           'Add New Card',
//                           style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Center(
//               child: FutureBuilder<CardListModel>(
//                   future: WalleteConnection().getCardList(customerId),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       if (snapshot.data.cardList.data.isNotEmpty) {
//                         return ListView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: snapshot.data.cardList.data.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 10),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       color: Color(0xFF000000),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(20))),
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 20, vertical: 20),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         primaryCard ==
//                                                 snapshot.data.cardList
//                                                     .data[index].id
//                                             ? Center(
//                                                 child: Text(
//                                                   "Primary Card",
//                                                   style: TextStyle(
//                                                       color: Color(0xc2f4eeee),
//                                                       fontSize: 20,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                 ),
//                                               )
//                                             : Container(),
//                                         Row(
//                                           children: [
//                                             ImageIcon(
//                                               AssetImage("assets/card.png"),
//                                               color: Color(0xc2f4eeee),
//                                               size: 35,
//                                             ),
//                                             SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text(
//                                               "${snapshot.data.cardList.data[index].brand}",
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 22,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             Expanded(
//                                               child: Container(),
//                                               flex: 1,
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 // DialogUtils().showAlertDialog(context,
//                                                 //         okBtnFunction: () => {
//                                                 //               print(index),
//                                                 //               Navigator.pop(
//                                                 //                   context),
//                                                 //               WalleteConnection()
//                                                 //                   .deleteCard(
//                                                 //                       customerId,
//                                                 //                       "${snapshot.data.cardList.data[index].id}")
//                                                 //                   .then(
//                                                 //                       (value) =>
//                                                 //                           {
//                                                 //                             if (value.status ==
//                                                 //                                 1)
//                                                 //                               {
//                                                 //                                 setState(() {
//                                                 //                                   snapshot.data.cardList.data.remove(index);
//                                                 //                                 }),
//                                                 //                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                 //                                   SnackBar(
//                                                 //                                     backgroundColor: Colors.black,
//                                                 //                                     elevation: 4.0,
//                                                 //                                     content: const Text(
//                                                 //                                       'Card Removed Successfully.',
//                                                 //                                       textAlign: TextAlign.center,
//                                                 //                                     ),
//                                                 //                                     duration: const Duration(milliseconds: 2000),
//                                                 //                                     width: 280.0,
//                                                 //                                     padding: const EdgeInsets.symmetric(vertical: 10.0 // Inner padding for SnackBar content.
//                                                 //                                         ),
//                                                 //                                     behavior: SnackBarBehavior.floating,
//                                                 //                                     shape: RoundedRectangleBorder(
//                                                 //                                       borderRadius: BorderRadius.circular(10.0),
//                                                 //                                     ),
//                                                 //                                   ),
//                                                 //                                 ),
//                                                 //                               }
//                                                 //                             else
//                                                 //                               {
//                                                 //                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                 //                                   SnackBar(
//                                                 //                                     backgroundColor: Colors.black,
//                                                 //                                     elevation: 4.0,
//                                                 //                                     content: const Text(
//                                                 //                                       'Please try again.',
//                                                 //                                       textAlign: TextAlign.center,
//                                                 //                                     ),
//                                                 //                                     duration: const Duration(milliseconds: 2000),
//                                                 //                                     width: 280.0,
//                                                 //                                     padding: const EdgeInsets.symmetric(vertical: 10.0 // Inner padding for SnackBar content.
//                                                 //                                         ),
//                                                 //                                     behavior: SnackBarBehavior.floating,
//                                                 //                                     shape: RoundedRectangleBorder(
//                                                 //                                       borderRadius: BorderRadius.circular(10.0),
//                                                 //                                     ),
//                                                 //                                   ),
//                                                 //                                 ),
//                                                 //                               }
//                                                 //                           })
//                                                 //             });
//                                               },
//                                               child: Container(
//                                                 height: 40,
//                                                 width: 40,
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(5.0),
//                                                   child: ImageIcon(
//                                                       AssetImage(
//                                                           "assets/delete.png"),
//                                                       color: Color(0xFFFFFFFF)),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 20,
//                                         ),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "**** **** **** ${snapshot.data.cardList.data[index].last4}",
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             Spacer(),
//                                             primaryCard !=
//                                                     snapshot.data.cardList
//                                                         .data[index].id
//                                                 ? GestureDetector(
//                                                     onTap: () {
//                                                       WalleteConnection()
//                                                           .primaryCard(
//                                                               customerId,
//                                                               snapshot
//                                                                       .data
//                                                                       .cardList
//                                                                       .data[
//                                                                           index]
//                                                                       .id ??
//                                                                   "")
//                                                           .then((value) => {
//                                                                 if (value
//                                                                         .status ==
//                                                                     1)
//                                                                   {
//                                                                     ScaffoldMessenger.of(
//                                                                             context)
//                                                                         .showSnackBar(
//                                                                       SnackBar(
//                                                                         backgroundColor:
//                                                                             Colors.black,
//                                                                         elevation:
//                                                                             4.0,
//                                                                         content:
//                                                                             Text(
//                                                                           "${value.msg.toString()}",
//                                                                           textAlign:
//                                                                               TextAlign.center,
//                                                                         ),
//                                                                         duration:
//                                                                             const Duration(milliseconds: 2000),
//                                                                         width:
//                                                                             280.0,
//                                                                         padding: const EdgeInsets.symmetric(
//                                                                             vertical:
//                                                                                 10.0 // Inner padding for SnackBar content.
//                                                                             ),
//                                                                         behavior:
//                                                                             SnackBarBehavior.floating,
//                                                                         shape:
//                                                                             RoundedRectangleBorder(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(10.0),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     getPrimaryDetail(),
//                                                                   }
//                                                                 else
//                                                                   {
//                                                                     ScaffoldMessenger.of(
//                                                                             context)
//                                                                         .showSnackBar(
//                                                                       SnackBar(
//                                                                         backgroundColor:
//                                                                             Colors.black,
//                                                                         elevation:
//                                                                             4.0,
//                                                                         content:
//                                                                             Text(
//                                                                           "${value.msg.toString()}",
//                                                                           textAlign:
//                                                                               TextAlign.center,
//                                                                         ),
//                                                                         duration:
//                                                                             const Duration(milliseconds: 2000),
//                                                                         width:
//                                                                             280.0,
//                                                                         padding: const EdgeInsets.symmetric(
//                                                                             vertical:
//                                                                                 10.0 // Inner padding for SnackBar content.
//                                                                             ),
//                                                                         behavior:
//                                                                             SnackBarBehavior.floating,
//                                                                         shape:
//                                                                             RoundedRectangleBorder(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(10.0),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   }
//                                                               });
//                                                     },
//                                                     child: Padding(
//                                                       padding:
//                                                           EdgeInsets.all(5),
//                                                       child: ImageIcon(
//                                                           AssetImage(
//                                                               "assets/uncheck.png"),
//                                                           color: Color(
//                                                               0xFFFFFFFF)),
//                                                     ),
//                                                   )
//                                                 : Padding(
//                                                     padding: EdgeInsets.all(5),
//                                                     child: ImageIcon(
//                                                         AssetImage(
//                                                             "assets/check.png"),
//                                                         color:
//                                                             Color(0xFF358F0B)),
//                                                   ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 20,
//                                         ),
//                                         Center(
//                                           child: Text(
//                                             "${snapshot.data.cardList.data[index].expMonth}/${snapshot.data.cardList.data[index].expYear}",
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Text(
//                                           "${snapshot.data.cardList.data[index].name}",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.normal),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             });
//                       } else {
//                         return SizedBox(
//                             height: MediaQuery.of(context).size.height / 1.3,
//                             child: Center(
//                                 child: Text("No Card Save",
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold))));
//                       }
//                     } else {
//                       return SizedBox(
//                           height: MediaQuery.of(context).size.height / 1.3,
//                           child: Center(
//                               child: CircularProgressIndicator(
//                             valueColor:
//                                 AlwaysStoppedAnimation(Color(0xffF18910)),
//                           )));
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
