// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../connection/wallet_connection.dart';
// import '../utils/constant.dart';

// class RequestPayScreen extends StatefulWidget {
//   String userName;
//   String userProfile;
//   String otherUserId;

//   RequestPayScreen(
//       {this.userName = "", this.userProfile = "", this.otherUserId = ""});

//   @override
//   State<RequestPayScreen> createState() => _RequestPayScreenState();
// }

// class _RequestPayScreenState extends State<RequestPayScreen> {
//   String currency = "\$";
//   bool _validate = true;
//   bool isLoading = false;
//   TextEditingController priceController = TextEditingController();
//   String price = "";
//   String userId = "1796768";

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
//                               width: 60.0,
//                               height: 60.0,
//                               fit: BoxFit.fill,
//                             )
//                           : Image.network(
//                               '${Constant.PROFILE_URL}${widget.userProfile}',
//                               height: 80,
//                               width: 80,
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
//                         /*Text(
//                               '${widget.record?.mobile}',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             )*/
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
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                     labelText: 'Enter Price',
//                     labelStyle: TextStyle(color: Colors.white),
//                     errorText: !_validate ? 'Please enter price' : null),
//                 onChanged: (int) {
//                   price = '$currency$int';
//                 },
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       priceController.text.isEmpty
//                           ? _validate = false
//                           : isLoading = true;
//                       setState(() {
//                         if (isLoading) {
//                           _validate = true;
//                           WalleteConnection()
//                               .requestMoney(userId, widget.otherUserId,
//                                   priceController.text.toString())
//                               .then((value) => {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         backgroundColor: Colors.black,
//                                         elevation: 4.0,
//                                         content: Text(
//                                           "${value?.msg.toString()}",
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         duration:
//                                             const Duration(milliseconds: 2000),
//                                         width: 280.0,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical:
//                                                 10.0 // Inner padding for SnackBar content.
//                                             ),
//                                         behavior: SnackBarBehavior.floating,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                         ),
//                                       ),
//                                     ),
//                                     Navigator.pop(context),
//                                   });
//                         }
//                       });
//                     });
//                   },
//                   Widget: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
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
//                             'Payment Request',
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
// }
