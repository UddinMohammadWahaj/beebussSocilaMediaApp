// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../connection/wallet_connection.dart';
// import '../utils/constant.dart';

// class SendUser extends StatefulWidget {
//   // TransactionsUser? transactionsUser;

//   /* Record? record;*/

//   String userName;
//   String userProfile;
//   String otherUserId;
//   String amount;

//   SendUser(
//       {this.userName = "",
//       this.userProfile = "",
//       this.otherUserId = "",
//       this.amount = ""});

//   @override
//   State<SendUser> createState() => _SendUserState();
// }

// class _SendUserState extends State<SendUser> {
//   String currency = "\$";
//   int _validate = 0;
//   bool isLoading = false;

//   TextEditingController priceController = TextEditingController();
//   String price = "";
//   String userId = "1796768";
//   String customerId = "cus_MofXpz82rCSrKh";
//   String userCurrentBalance = "";

//   @override
//   void initState() {
//     userWalletBalance();
//     setState(() {
//       priceController.text = widget.amount;
//     });
//     super.initState();
//   }

//   onTextChanged(String text) async {
//     if (text.isNotEmpty) {
//       setState(() {
//         _validate = 0;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF010101),
//       body: Container(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 30,
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.pop(context);
//                 },
//                 child: ImageIcon(
//                   AssetImage("assets/back_arrow.png"),
//                   color: Color(0xFFFFFFFF),
//                   size: 20,
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: widget.userProfile.toString() == ""
//                           ? Image.asset(
//                               'assets/user_placeholder.png',
//                               width: 80.0,
//                               height: 80.0,
//                               fit: BoxFit.fill,
//                             )
//                           : Image.network(
//                               '${Constant.PROFILE_URL}${widget.userProfile}',
//                               height: 60,
//                               width: 60,
//                               fit: BoxFit.fill,
//                             )),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Flexible(
//                       child: Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '${widget.userName}',
//                           style: TextStyle(
//                               color: Color(0xFFFFFFFF),
//                               fontSize: 18,
//                               fontWeight: FontWeight.normal),
//                         ),
//                         /* Text(
//                           '${widget.record?.mobile}',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         )*/
//                       ],
//                     ),
//                   ))
//                 ],
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               TextField(
//                 style: TextStyle(color: Colors.white),
//                 onChanged: onTextChanged,
//                 controller: priceController,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.digitsOnly
//                 ],
//                 decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     enabledBorder: OutlineInputBorder(
//                       borderSide:
//                           const BorderSide(color: Colors.white, width: 2.0),
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide:
//                           const BorderSide(color: Colors.white, width: 2.0),
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     labelText: 'Enter Price',
//                     labelStyle: TextStyle(color: Colors.white),
//                     errorText: _validate == 1
//                         ? 'Please enter price'
//                         : _validate == 2
//                             ? 'You have not sufficient balance for transaction.'
//                             : null),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       priceController.text.isEmpty
//                           ? _validate = 1
//                           : int.parse(priceController.text.toString()) >
//                                   int.parse(userCurrentBalance)
//                               ? _validate = 2
//                               : isLoading = true;

//                       if (isLoading) {
//                         WalleteConnection()
//                             .sendMoney(userId, widget.otherUserId,
//                                 priceController.text.toString())
//                             .then((value) => {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.black,
//                                       elevation: 4.0,
//                                       content: Text(
//                                         "${value?.msg.toString()}",
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       duration:
//                                           const Duration(milliseconds: 2000),
//                                       width: 280.0,
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical:
//                                               10.0 // Inner padding for SnackBar content.
//                                           ),
//                                       behavior: SnackBarBehavior.floating,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                       ),
//                                     ),
//                                   ),
//                                   Navigator.pop(context),
//                                 });
//                       } else {}
//                     });
//                   },
//                   Widget: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 50,
//                     ),
//                     child: isLoading
//                         ? SizedBox(
//                             height: 25,
//                             width: 25,
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation(Colors.white),
//                             ),
//                           )
//                         : Text(
//                             'Pay',
//                             style:
//                                 TextStyle(fontSize: 20.0, color: Colors.white),
//                           ),
//                   ),
//                   style: TextButton.styleFrom(
//                     backgroundColor: Color(0xff3f63B5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20), // <-- Radius
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void userWalletBalance() {
//     WalleteConnection().walletBalance(userId, customerId).then((value) => {
//           if (value != null)
//             {
//               setState(() {
//                 userCurrentBalance = value.balance.toString() == "null"
//                     ? "0"
//                     : value.balance.toString();
//               }),
//             }
//         });
//   }
// }
