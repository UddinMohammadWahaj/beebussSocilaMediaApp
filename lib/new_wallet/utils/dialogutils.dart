// import 'package:flutter/material.dart';

// class DialogUtils{
//   showAlertDialog(BuildContext context, { Function() okBtnFunction}) {
//     Widget cancelButton = TextButton(
//       child: Text("Cancel",style: TextStyle(color: Color(0xff000000),fontSize: 15,fontWeight: FontWeight.bold),),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text("Continue",style: TextStyle(color: Color(0xff2B25CC),fontSize: 15,fontWeight: FontWeight.bold),),
//       onPressed: () {
//         okBtnFunction();
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text("Card Delete",style: TextStyle(color: Colors.red),textAlign: TextAlign.center,),
//       content: Text("Are you sure you want to remove this card from your wallet?",
//         style: TextStyle(fontSize: 17),
//         textAlign: TextAlign.center,),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }