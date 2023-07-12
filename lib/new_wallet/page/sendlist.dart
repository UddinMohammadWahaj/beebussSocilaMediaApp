// import 'package:bizbultest/new_wallet/model/user_model.dart';
// import 'package:bizbultest/new_wallet/page/single_user_send_list.dart';
// import 'package:flutter/material.dart';
// import '../connection/user_connection.dart';
// import '../model/user_recent_model.dart';
// import '../utils/constant.dart';

// class SendList extends StatefulWidget {
//   static const String identificaiton = "";

//   @override
//   State<SendList> createState() => _SendListState();
// }

// class _SendListState extends State<SendList> {
//   TextEditingController searchController = TextEditingController();
//   bool isSearch = false;
//   bool isRecentUser = false;


//   onSearchTextChanged(String text) async {
//     print("onSearchTextChanged Key $text");
//     if (text.isEmpty) {
//       setState(() {
//         searchController.clear();
//         isSearch = false;
//       });
//     } else {
//       setState(() {
//         isSearch = true;
//       });
//     }
//   }

//   onTextChanged(String text) async {
//     if (text.isEmpty) {
//       setState(() {
//         print("OnTextEmplty Key $text");
//         searchController.clear();
//         isSearch = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(
//                 top: 50.0, left: 20, right: 20, bottom: 15),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.pop(context);
//                   },
//                   child: ImageIcon(
//                     AssetImage("assets/back_arrow.png"),
//                     color: Color(0xFF000000),
//                     size: 20,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       enabledBorder: new OutlineInputBorder(
//                         borderRadius: new BorderRadius.circular(25.0),
//                         borderSide: BorderSide(color: Color(0xffA6635B)),
//                       ),
//                       focusedBorder: new OutlineInputBorder(
//                         borderRadius: new BorderRadius.circular(250.0),
//                         borderSide: BorderSide(color: Color(0xffA6635B)),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                       hintText: 'Enter a search',
//                     ),
//                     onChanged: onTextChanged,
//                     controller: searchController,
//                     onSubmitted: onSearchTextChanged,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           ///  Recent send contact

//           SizedBox(
//               child: FutureBuilder<UserRecentModel>(
//                   future: UserConnection().getUserListWalletTransaction("1796768"),
//                   builder: (context, snapshot) {
//                       if (snapshot.hasData){
//                         return snapshot.data.transactions?.length != 0 ?
//                             Container(
//                               height: 100,
//                               child: ListView.builder(
//                                   itemCount: snapshot.data?.transactions?.length,
//                                   scrollDirection: Axis.horizontal,
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       width: 90,
//                                       child: GestureDetector(onTap: () {
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     SingleUserSendListScreen(otherUserId:snapshot.data.transactions[index].id.toString() ?? "",
//                                                         userProfile:snapshot.data.transactions[index].profileImage.toString()  ?? "",
//                                                         userName:snapshot.data.transactions[index].name.toString()  ?? "")));
//                                       },
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 12.0,
//                                               bottom: 12.0,
//                                               left: 15.0,
//                                               right: 15.0),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children: [
//                                               CircleAvatar(
//                                                 backgroundColor: Colors.brown.shade800,
//                                                 backgroundImage: NetworkImage(
//                                                   '${Constant.PROFILE_URL}${snapshot.data
//                                                       .transactions[index].profileImage}',),
//                                               ),
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Text(
//                                                 '${snapshot.data.transactions[index]
//                                                     .name}',
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 1,
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.w800,
//                                                     fontSize: 15),
//                                               ),
//                                             ],
//                                           ),
//                                         ),)
//                                       ,
//                                     );
//                                   }) ,
//                             )
//                        :Container();
//                     }else{
//                         return Container();
//                       }
//                   })

//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Text(
//               'Bebuzee Contacts',
//               maxLines: 1,
//               style: TextStyle(
//                   fontSize: 17,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),

//           /// All contact and search contact
//           isSearch ? Expanded(
//             child: FutureBuilder<UserModel>(
//               future: UserConnection().getSearchList(
//                   searchController.text.toString().trim()),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return snapshot.data.record.length != 0 ? ListView.builder(
//                       itemCount: snapshot.data.record.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 0),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => SingleUserSendListScreen(
//                                       otherUserId: snapshot.data.record[index]
//                                           .id.toString(),
//                                       userName: snapshot.data.record[index]
//                                           .name.toString(),
//                                       userProfile: snapshot.data.record[index]
//                                           .profileImage.toString())),);
//                             },
//                             child: Card(
//                               elevation: 1,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 10.0,
//                                     bottom: 12.0,
//                                     left: 15.0,
//                                     right: 15.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.brown.shade800,
//                                       backgroundImage: NetworkImage(
//                                         '${Constant.PROFILE_URL}${snapshot.data
//                                             .record[index].profileImage}',),
//                                     ),
//                                     SizedBox(
//                                       width: 25,
//                                     ),
//                                     Flexible(child: Container(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Text(
//                                             '${snapshot.data.record[index]
//                                                 .name}',
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w800,
//                                                 fontSize: 17),
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                             '${snapshot.data.record[index]
//                                                 .mobile}',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                                 fontSize: 13),
//                                           ),
//                                         ],
//                                       ),
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }) : SizedBox(
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height / 1.5,
//                       child: Center(
//                           child: Text("No user found",
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold))));
//                 } else {
//                   return SizedBox(
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height / 1.3,
//                       child: Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Color(
//                                 0xffF18910)),
//                           )));
//                 }
//               },
//             ),
//           ) : Expanded(
//             child: FutureBuilder<UserModel>(
//               future: UserConnection().getContactList("2"),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return snapshot.data.record?.length != 0 ? ListView.builder(
//                       itemCount: snapshot.data.record?.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 0),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => SingleUserSendListScreen(
//                                       otherUserId: snapshot.data.record[index]
//                                           .id.toString(),
//                                       userName: snapshot.data.record[index]
//                                           .name.toString(),
//                                       userProfile: snapshot.data.record[index]
//                                           .profileImage.toString())),);
//                             },
//                             child: Card(
//                               elevation: 1,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 10.0,
//                                     bottom: 12.0,
//                                     left: 15.0,
//                                     right: 15.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.brown.shade800,
//                                       backgroundImage: NetworkImage(
//                                         '${Constant.PROFILE_URL}${snapshot.data
//                                             .record[index].profileImage}',),
//                                     ),
//                                     SizedBox(
//                                       width: 25,
//                                     ),
//                                     Flexible(child: Container(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Text(
//                                             '${snapshot.data.record[index]
//                                                 .name}',
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w800,
//                                                 fontSize: 17),
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                             '${snapshot.data.record[index]
//                                                 .mobile}',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                                 fontSize: 13),
//                                           ),
//                                         ],
//                                       ),
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       })
//                       : SizedBox(
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height / 1.5,
//                       child: Center(
//                           child: Text("No user found",
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold))));
//                 } else {
//                   return SizedBox(
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height / 1.3,
//                       child: Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Color(
//                                 0xffF18910)),
//                           )));
//                 }
//               },
//             ),
//             /* child: ListView.builder(
//                 itemCount: 15,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//               return Container(
//                 child: Card(
//                   elevation: 1,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10.0,bottom: 12.0,left: 15.0,right: 15.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children:  [
//                         CircleAvatar(
//                           backgroundColor: Colors.transparent,
//                           backgroundImage: NetworkImage(
//                               'https://www.bnl.gov/today/body_pics/2017/06/stephanhruszkewycz-hr.jpg'),
//                         ),
//                         SizedBox(width: 20,),
//                         Column(
//                           children: [
//                             Text('Abc Rocky',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
//                             SizedBox(height: 5,),
//                             Text('**** 1234',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13),),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),*/
//           ),
//         ],
//       ),
//     );
//   }
// }
