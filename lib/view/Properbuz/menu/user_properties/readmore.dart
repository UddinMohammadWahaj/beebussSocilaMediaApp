// import 'package:bizbultest/Language/appLocalization.dart';
// import 'package:bizbultest/models/Properbuz/property_buying_guide_model.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// class ReadMore extends StatefulWidget {
//   final Message message;
//   const ReadMore({Key key, this.message}) : super(key: key);
//
//   @override
//   _ReadMoreState createState() => _ReadMoreState();
// }
//
// class _ReadMoreState extends State<ReadMore> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           AppLocalizations.of(
//             "Read More",
//           ),
//           style: TextStyle(fontSize: 22, color: Colors.black),
//         ),
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(15),
//         children: [
//           Column(
//             children: [
//               CachedNetworkImage(
//                 imageUrl: "https://properbuz.bebuzee.com/images/blog/" +
//                     widget.message.blogImage,
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     CircularProgressIndicator(value: downloadProgress.progress),
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//                 fit: BoxFit.fill,
//                 height: 200.0,
//                 width: 200.0,
//               ),
//               Html(
//                 data: widget.message.description,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
