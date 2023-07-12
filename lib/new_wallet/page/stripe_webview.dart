// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class StripeWebview extends StatefulWidget {
//   String url;

//   StripeWebview({this.url=""});

//   @override
//   State<StripeWebview> createState() => _StripeWebviewState();
// }

// class _StripeWebviewState extends State<StripeWebview> {
//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//     startTimer();
//   }

//    Timer _timer;
//   int _start = 10;

//   void startTimer() {
//     const oneSec =  Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//           (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//             Navigator.pop(context);
//           });
//         } else {
//           setState(() {
//             _start--;
//           });
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//           WebView(
//           initialUrl: widget.url,
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text("$_start"),
//             SizedBox(height: 20,),
//             Center(
//               child:Text("Authenticate Process...",style: TextStyle(fontSize: 17,color: Colors.black54),)
//             )
//           ],
//         )
//       ],
//     );

//   }
// }
