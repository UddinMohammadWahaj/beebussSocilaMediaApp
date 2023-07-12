
// import 'package:bizbultest/new_wallet/page/pay_phone_number.dart';
// import 'package:bizbultest/new_wallet/page/sendlist.dart';
// import 'package:bizbultest/new_wallet/page/transaction.dart';
// import 'package:bizbultest/new_wallet/page/withdrow_history.dart';
// import 'package:flutter/material.dart';

// import 'feedback.dart';

// class MoreScreen extends StatefulWidget {
//   const MoreScreen({Key key}) : super(key: key);

//   @override
//   State<MoreScreen> createState() => _MoreScreenState();
// }

// class _MoreScreenState extends State<MoreScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 15),
//             child: GestureDetector(
//                 onTap: () async {
//                   Navigator.pop(context, false);
//                 },
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: ImageIcon(
//                     AssetImage("assets/back_arrow.png"),
//                     color: Colors.black,
//                     size: 20,
//                   ),
//                 )),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//             child:GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (_, __, ___) => TransacationScreen(),
//                     transitionDuration: Duration(milliseconds: 0),
//                     transitionsBuilder: (_, a, __, c) =>
//                         FadeTransition(opacity: a, child: c),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 child:  Row(
//                   children: [
//                     ImageIcon(
//                       AssetImage("assets/clock.png"),
//                       color: Color(0xff91596F),size: 35,),
//                     SizedBox(width: 10,),
//                     Text('Show transaction history',style: TextStyle(color: Colors.black87,fontSize: 17)),
//                     Spacer(),
//                     ImageIcon(
//                         AssetImage("assets/right_arrow.png"),
//                         color: Color(0xff91596F)),

//                   ],
//                 ),
//               ) ,
//             ),
//           ),
//           Padding(padding: EdgeInsets.symmetric(horizontal: 40),
//             child:Container(height: 1,color: Color(0xff91596F),) ,),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//             child:GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (_, __, ___) => PayPhoneNumberScreen(),
//                     transitionDuration: Duration(milliseconds: 0),
//                     transitionsBuilder: (_, a, __, c) =>
//                         FadeTransition(opacity: a, child: c),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 child:  Row(
//                   children: [
//                     ImageIcon(
//                       AssetImage("assets/smartphone.png"),
//                       color: Color(0xff91596F),size: 35,),
//                     SizedBox(width: 10,),
//                     Text('Pay phone number',style: TextStyle(color: Colors.black87,fontSize: 17)),
//                     Spacer(),
//                     ImageIcon(
//                         AssetImage("assets/right_arrow.png"),
//                         color: Color(0xff91596F)),

//                   ],
//                 ),
//               ) ,
//             ),
//           ),
//           Padding(padding: EdgeInsets.symmetric(horizontal: 40),
//             child:Container(height: 1,color: Color(0xff91596F),) ,),

//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//             child:GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (_, __, ___) => SendList(),
//                     transitionDuration: Duration(milliseconds: 0),
//                     transitionsBuilder: (_, a, __, c) =>
//                         FadeTransition(opacity: a, child: c),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 child:  Row(
//                   children: [
//                     SizedBox(width: 3,),
//                     ImageIcon(
//                       AssetImage("assets/pay_contact.png"),
//                       color: Color(0xff91596F),size: 30,),
//                     SizedBox(width: 12,),
//                     Text('Pay contact',style: TextStyle(color: Colors.black87,fontSize: 17)),
//                     Spacer(),
//                     ImageIcon(
//                         AssetImage("assets/right_arrow.png"),
//                         color: Color(0xff91596F)),

//                   ],
//                 ),
//               ) ,
//             ),
//           ),
//           Padding(padding: EdgeInsets.symmetric(horizontal: 40),
//             child:Container(height: 1,color: Color(0xff91596F),) ,),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//             child:GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (_, __, ___) => WithdrowHistoryScreen(),
//                     transitionDuration: Duration(milliseconds: 0),
//                     transitionsBuilder: (_, a, __, c) =>
//                         FadeTransition(opacity: a, child: c),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 child:  Row(
//                   children: [
//                     SizedBox(width: 3,),
//                     ImageIcon(
//                       AssetImage("assets/withdrow.png"),
//                       color: Color(0xff91596F),size: 30,),
//                     SizedBox(width: 12,),
//                     Text('Withdraw  history',style: TextStyle(color: Colors.black87,fontSize: 17)),
//                     Spacer(),
//                     ImageIcon(
//                         AssetImage("assets/right_arrow.png"),
//                         color: Color(0xff91596F)),

//                   ],
//                 ),
//               ) ,
//             ),
//           ),
//           Padding(padding: EdgeInsets.symmetric(horizontal: 40),
//             child:Container(height: 1,color: Color(0xff91596F),) ,),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//             child:GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (_, __, ___) => FeedbackScreen(),
//                     transitionDuration: Duration(milliseconds: 0),
//                     transitionsBuilder: (_, a, __, c) =>
//                         FadeTransition(opacity: a, child: c),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 child:  Row(
//                   children: [
//                     SizedBox(width: 3,),
//                     ImageIcon(
//                       AssetImage("assets/withdrow.png"),
//                       color: Color(0xff91596F),size: 30,),
//                     SizedBox(width: 12,),
//                     Text('Send Feedback',style: TextStyle(color: Colors.black87,fontSize: 17)),
//                     Spacer(),
//                     ImageIcon(
//                         AssetImage("assets/right_arrow.png"),
//                         color: Color(0xff91596F)),

//                   ],
//                 ),
//               ) ,
//             ),
//           ),
//           Padding(padding: EdgeInsets.symmetric(horizontal: 40),
//             child:Container(height: 1,color: Color(0xff91596F),) ,),

//         ],
//       ),
//     );
//   }
// }
