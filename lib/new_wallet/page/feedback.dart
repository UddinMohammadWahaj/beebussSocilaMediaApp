// import 'package:flutter/material.dart';

// import '../connection/user_connection.dart';

// class FeedbackScreen extends StatefulWidget {
//   const FeedbackScreen({Key key}) : super(key: key);

//   @override
//   State<FeedbackScreen> createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen> {
//   String userId = "1796768";

//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController messageController = TextEditingController();
//   bool isName = false;
//   bool isEmail = false;
//   bool isMobile = false;
//   bool isMessage = false;
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF010101),
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xFF010101),
//         title: Text(
//           'Feedback',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 40,
//             ),
//             TextField(
//               style: TextStyle(color: Colors.white),
//               controller: nameController,
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//               decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   labelText: 'Enter name',
//                   labelStyle: TextStyle(color: Colors.white),
//                   errorText: isName ? 'Please enter name' : null),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             TextField(
//               style: TextStyle(color: Colors.white),
//               controller: emailController,
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//               decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   labelText: 'Enter email',
//                   labelStyle: TextStyle(color: Colors.white),
//                   errorText: isEmail ? 'Please enter email' : null),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             TextField(
//               style: TextStyle(color: Colors.white),
//               controller: mobileController,
//               keyboardType: TextInputType.number,
//               textInputAction: TextInputAction.next,
//               decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   labelText: 'Enter mobile',
//                   labelStyle: TextStyle(color: Colors.white),
//                   errorText: isMobile ? 'Please enter mobile number' : null),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             TextField(
//               style: TextStyle(color: Colors.white),
//               controller: messageController,
//               keyboardType: TextInputType.multiline,
//               minLines: 3,
//               maxLines: 5,
//               textInputAction: TextInputAction.done,
//               decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         const BorderSide(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   labelText: 'Enter message',
//                   alignLabelWithHint: true,
//                   labelStyle: TextStyle(color: Colors.white),
//                   errorText: isMessage ? 'Please enter message' : null),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   nameController.text.toString().isEmpty
//                       ? isName = true
//                       : emailController.text.toString().isEmpty
//                           ? isEmail = true
//                           : mobileController.text.toString().isEmpty
//                               ? isMobile = true
//                               : messageController.text.toString().isEmpty
//                                   ? isMessage = true
//                                   : isLoading = true;
//                   setState(() {
//                     if (isLoading) {
//                       UserConnection()
//                           .sendFeedback(
//                               userId,
//                               nameController.text.toString(),
//                               emailController.text.toString(),
//                               mobileController.text.toString(),
//                               messageController.text.toString())
//                           .then((value) => {
//                                 if (value.status == 1)
//                                   {
//                                     setState(() {
//                                       nameController.clear();
//                                       emailController.clear();
//                                       mobileController.clear();
//                                       messageController.clear();
//                                       isLoading = false;
//                                     })
//                                   }
//                               });
//                     }
//                   });
//                 },
//                 Widget: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 50,
//                   ),
//                   child: isLoading
//                       ? SizedBox(
//                           height: 25,
//                           width: 25,
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Colors.white),
//                           ),
//                         )
//                       : Text(
//                           'Submit',
//                           style: TextStyle(fontSize: 20.0, color: Colors.white),
//                         ),
//                 ),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Color(0xff3f63B5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20), // <-- Radius
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
