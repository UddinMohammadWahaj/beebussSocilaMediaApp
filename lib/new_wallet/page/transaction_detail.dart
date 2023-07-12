// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// import '../connection/user_connection.dart';
// import '../model/transaction_detail.dart';
// import 'dart:ui' as ui;


// class TransactionDetailScreen extends StatefulWidget {
//   String transactionId;

//   TransactionDetailScreen({this.transactionId = ""});

//   @override
//   State<TransactionDetailScreen> createState() =>
//       _TransactionDetailScreenState();
// }

// class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
//   String currency = "\$";
//   String userId = "";
//   TransactionDetailModel model;
//   bool isLoading = false;

//   @override
//   void initState() {
//     UserConnection().transactionDetail(widget.transactionId).then((value) => {
//     setState((){
//     if(value.transaction.id.toString().isNotEmpty){
//     model = value;
//     isLoading = true;
//     }
//     }),
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       body:RepaintBoundary(
//         key: globalKey,
//         child:  SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15, top: 50, right: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         Navigator.of(context).pop(true);
//                       },
//                       child: ImageIcon(
//                         AssetImage("assets/back_arrow.png"),
//                         color: Color(0xFFFFFFFF),
//                         size: 20,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Text(
//                       'Transaction Detail',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Color(0xFFFFFFFF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 40,),
//               Padding(padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: isLoading ? Column(
//                   children: [
//                     Text(
//                       'To ${model.toUser.name.toString()}',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.normal,
//                           fontSize: 16),
//                     ),
//                     SizedBox(height: 5,),
//                     Text(
//                       '${model.toUser.mobile.toString()}',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.normal,
//                           fontSize: 16),
//                     ),
//                     SizedBox(height: 20,),
//                     Text(
//                       '$currency${model.transaction.amount.toString()}',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 30),
//                     ),
//                     SizedBox(height: 30,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ImageIcon(
//                             AssetImage(
//                                 "assets/check.png"),
//                             color:
//                             Color(0xFF358F0B)),
//                         SizedBox(width: 10,),
//                         Text(
//                           'Completed',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.normal,
//                               fontSize: 13),

//                         ),
//                         SizedBox(width: 5,),
//                       ],
//                     ),
//                     SizedBox(height: 8,),
//                     SizedBox(
//                       child: Container(height: 1, color: Color(0xFFFFFFFF),),
//                       width: 130,),
//                     SizedBox(height: 15,),
//                     /// Date Format
//                     Text(
//                       '${model.transaction.createdAt.toString().substring(0,model.transaction.createdAt.toString().indexOf("T")).trim()}',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.normal,
//                           fontSize: 18),

//                     ),
//                     SizedBox(height: 50,),
//                     Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(width: 1, color: Colors.white),

//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Transaction ID',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 18),
//                               ),
//                               Text(
//                                 '${model.transaction.walletTransactionId}',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 18),
//                               ),
//                               SizedBox(height: 20,),
//                               Text(
//                                 'To: ${model.toUser.name.toString()}',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 18),
//                               ),
//                               SizedBox(height: 20,),
//                               Text(
//                                 'From: ${model.fromUser.name.toString()}',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 18),
//                               ),
//                             ],
//                           ),
//                         )

//                     ),
//                     SizedBox(height: 50,),
//                     Row(
//                       children: [
//                         Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(width: 1, color: Colors.white),

//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 5),
//                               child: Text(
//                                 'Having issues?',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16),
//                               ),
//                             )


//                         ),
//                         SizedBox(width: 20,),
//                         GestureDetector(
//                           onTap: (){
//                          /*   setState((){
//                               print(tinypng.toString());
//                             });
//                         */
//                           },
//                           child:  Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(width: 1, color: Colors.white),

//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 5),
//                                 child: Text(
//                                   'Share',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: 16),
//                                 ),
//                               )


//                           )
//                         )
//                       ],
//                     ),
//                     isPng ? Image.memory(Uint8List.fromList(pngBytes)) :Container(),
//                   ],
//                 ) : SizedBox(
//                     height: MediaQuery
//                         .of(context)
//                         .size
//                         .height /1,
//                     child: Center(
//                         child: CircularProgressIndicator(
//                           valueColor:
//                           AlwaysStoppedAnimation(
//                               Color(0xffffffff)),
//                         ))),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   GlobalKey globalKey = GlobalKey();
//   Uint8List pngBytes = null;
//   bool isPng = false;
//   tinypng() async{
//     RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
//     ui.Image image = await boundary.toImage();
//     ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//      pngBytes = byteData.buffer.asUint8List();
//     isPng = true;
//     print(pngBytes);
// /*
//     final codec = await instantiateImageCodec(pngBytes);
//     final frameInfo = await codec.getNextFrame();
//     return frameInfo.image;*/
//   }
// }
