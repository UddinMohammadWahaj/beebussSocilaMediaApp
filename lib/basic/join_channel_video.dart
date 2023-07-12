// import 'dart:developer';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:bizbultest/api/api.dart';
// import 'package:bizbultest/config/agora.config.dart' as config;
// import 'package:bizbultest/models/AgoraCallDetailModel.dart';
// import 'package:bizbultest/models/userDetailModel.dart';
// import 'package:bizbultest/services/Chat/chat_api.dart';
// import 'package:bizbultest/services/current_user.dart';
// import 'package:bizbultest/view/homepage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vibration/vibration.dart';

// /// MultiChannel Example
// class JoinChannelVideo extends StatefulWidget {
//   final String oppositeMemberId;
//   final bool isFromHome;
//   final bool callFromButton;
//   final String name;
//   final String token;
//   final String userImage;

//   const JoinChannelVideo({
//     Key key,
//     this.oppositeMemberId,
//     this.isFromHome = false,
//     this.callFromButton = false,
//     this.name =   "",
//     this.token = "",
//     this.userImage = "",
//   }) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => _State();
// }

// class _State extends State<JoinChannelVideo> {
//   RtcEngine _engine;

//   String channelId = config.channelId;
//   // String channelId = CurrentUser().currentUser.memberID;

//   bool isJoined = false, switchCamera = true, switchRender = true, openMicrophone = true, enableSpeakerphone = false;
//   List<int> remoteUid = [];
//   TextEditingController _controller;

//   String callTime = "";
//   String callLength = "";

//   DateTime startTime;

//   AudioCache audioCache;
//   AudioPlayer instance;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: channelId);
//     audioCache = AudioCache();
//     instance = AudioPlayer();
//     this._initEngine();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _engine.leaveChannel();
//     _engine.destroy();
//     instance.dispose();
//   }

//   void _stopFile() {
//     instance?.stop(); // stop the file like this
//   }

//   bool isSentCutNotification = false;

//   Future sendPushMessage({bool isVideo = true}) async {
//     UserDetailModel objUserDetailModel = await ApiProvider().getUserDetail(widget.oppositeMemberId);
//     await ChatApiCalls.sendFcmRequest(widget.name, "cut+video", "call", "otherMemberID", objUserDetailModel.firebaseToken, 0, 0, isVideo: isVideo);
//     setState(() {
//       isSentCutNotification = true;
//     });
//   }

//   _initEngine() async {
//     try {
//       if (widget.callFromButton) {
//         final file = await audioCache.loadAsFile('tune/diallerTone.mp3');
//         final bytes = await file.readAsBytes();
//         instance = await audioCache.playBytes(bytes, loop: true, volume: 0.1);
//       }

//       _engine = await RtcEngine.createWithContext(RtcEngineContext(config.appId));

//       this._addListeners();

//       await _engine.enableVideo();
//       await _engine.startPreview();
//       await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//       await _engine.setClientRole(ClientRole.Broadcaster);

//       if (widget.callFromButton) {
//         setState(() {
//           isJoined = true;
//         });
//         await _joinChannel();
//       }
//     } catch (e) {
//       print(e);

//       await _engine.leaveChannel();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(
//             memberID: CurrentUser().currentUser.memberID,
//             logo: CurrentUser().currentUser.logo,
//             country: CurrentUser().currentUser.country,
//             currentMemberImage: CurrentUser().currentUser.image,
//           ),
//         ),
//       );
//     }
//   }

//   _switchSpeakerphone() {
//     _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
//       setState(() {
//         enableSpeakerphone = !enableSpeakerphone;
//       });
//     }).catchError((err) {
//       log('setEnableSpeakerphone $err');
//     });
//   }

//   _switchMicrophone() {
//     _engine.enableLocalAudio(!openMicrophone).then((value) {
//       setState(() {
//         openMicrophone = !openMicrophone;
//       });
//     }).catchError((err) {
//       log('enableLocalAudio $err');
//     });
//   }

//   _addListeners() {
//     _engine.setEventHandler(RtcEngineEventHandler(
//       joinChannelSuccess: (channel, uid, elapsed) {
//         log('joinChannelSuccess $channel $uid $elapsed');
//         setState(() {
//           isJoined = true;
//         });
//       },
//       userJoined: (uid, elapsed) {
//         _stopFile();
//         log('userJoined  $uid $elapsed');
//         setState(() {
//           remoteUid.add(uid);
//         });
//       },
//       userOffline: (uid, reason) {
//         _stopFile();
//         log('userOffline  $uid $reason');
//         setState(() {
//           remoteUid.removeWhere((element) => element == uid);
//         });
//         // remoteUid.clear();
//         // Navigator.pop(context);
//       },
//       leaveChannel: (stats) {
//         _stopFile();
//         log('leaveChannel ${stats.toJson()}');
//         remoteUid.clear();
//       },
//     ));
//   }

//   _joinChannel() async {
//     startTime = DateTime.now();

//     callTime = DateTime.now().year.toString() +
//         "-" +
//         DateTime.now().month.toString() +
//         "-" +
//         DateTime.now().day.toString() +
//         " " +
//         DateTime.now().hour.toString() +
//         ":" +
//         DateTime.now().minute.toString() +
//         ":" +
//         DateTime.now().second.toString();

//     try {
//       if (defaultTargetPlatform == TargetPlatform.android) {
//         await [Permission.microphone, Permission.camera].request();
//       }
//       await _engine.joinChannel(config.token, channelId, null, 0);
//     } catch (e) {
//       print(e);

//       await _engine.leaveChannel();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(
//             memberID: CurrentUser().currentUser.memberID,
//             logo: CurrentUser().currentUser.logo,
//             country: CurrentUser().currentUser.country,
//             currentMemberImage: CurrentUser().currentUser.image,
//           ),
//         ),
//       );
//     } finally {
//       await FlutterRingtonePlayer.stop();
//       await Vibration.cancel();
//     }
//   }

//   _leaveChannel() async {
//     print("object");
//     try {
//       var totalTime = DateTime.now().difference(startTime).inSeconds;

//       int minutes = (totalTime / 60).truncate();
//       callLength = (minutes % 60).toString().padLeft(2, '0');

//       if (callLength == "00") {
//         callLength = totalTime.toString();
//       }

//       AgoraCallDetail objAgoraCallDetail =
//           await ApiProvider().agoraCallDetail(CurrentUser().currentUser.memberID, widget.oppositeMemberId, "Video", callTime, callLength);

//       if (objAgoraCallDetail != null && objAgoraCallDetail.data != null && objAgoraCallDetail.success == 1) {
//         print(objAgoraCallDetail.success);
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       await _engine.leaveChannel();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(
//             memberID: CurrentUser().currentUser.memberID,
//             logo: CurrentUser().currentUser.logo,
//             country: CurrentUser().currentUser.country,
//             currentMemberImage: CurrentUser().currentUser.image,
//           ),
//         ),
//       );
//     }
//   }

//   _switchCamera() {
//     _engine.switchCamera().then((value) {
//       setState(() {
//         switchCamera = !switchCamera;
//       });
//     }).catchError((err) {
//       log('switchCamera $err');
//     });
//   }

//   _switchRender() {
//     setState(() {
//       switchRender = !switchRender;
//       remoteUid = List.of(remoteUid.reversed);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _renderVideo(),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 14, right: 14),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(
//                       child: InkWell(
//                         child: Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.black,
//                         ),
//                         onTap: () async {
//                           await _leaveChannel();
//                           if (widget.isFromHome) {
//                             // Navigator.pushReplacementNamed(context, '/view/homepage');
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => HomePage(
//                                   memberID: CurrentUser().currentUser.memberID,
//                                   logo: CurrentUser().currentUser.logo,
//                                   country: CurrentUser().currentUser.country,
//                                   currentMemberImage: CurrentUser().currentUser.image,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             Navigator.pop(context);
//                           }
//                         },
//                       ),
//                       height: AppBar().preferredSize.height,
//                     ),
//                     Expanded(child: SizedBox()),
//                     Icon(
//                       Icons.lock,
//                       size: 18,
//                     ),
//                     Text(
//                       "End-to-end encrypted",
//                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
//                     ),
//                     Expanded(child: SizedBox()),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 !isJoined
//                     ? Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               widget.userImage != null && widget.userImage != ""
//                                   ? Container(
//                                       width: 100.0,
//                                       height: 100.0,
//                                       decoration: new BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         image: new DecorationImage(
//                                           fit: BoxFit.fill,
//                                           image: new NetworkImage(
//                                             widget.userImage,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   : Container(
//                                       width: 100.0,
//                                       height: 100.0,
//                                       decoration: new BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.white,
//                                       ),
//                                       child: Icon(
//                                         Icons.person,
//                                         color: Colors.grey,
//                                         size: 80,
//                                       ),
//                                     ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 16,
//                           ),
//                           Text(
//                             widget.name,
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           )
//                         ],
//                       )
//                     : SizedBox(),
//                 Expanded(child: SizedBox()),
//                 InkWell(
//                     onTap: () {
//                       isJoined ? _leaveChannel() : _joinChannel();
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Card(
//                           elevation: 0,
//                           color: isJoined ? Colors.red : Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Icon(
//                               Icons.phone,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         _switchCamera();
//                       },
//                       child: Icon(
//                         Icons.flip_camera_ios,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         _switchMicrophone();
//                       },
//                       child: openMicrophone
//                           ? Icon(
//                               Icons.mic,
//                               color: Colors.white.withOpacity(0.6),
//                               size: 30,
//                             )
//                           : Icon(
//                               Icons.mic_off,
//                               color: Colors.white.withOpacity(0.6),
//                               size: 30,
//                             ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         _switchSpeakerphone();
//                       },
//                       child: enableSpeakerphone
//                           ? Icon(
//                               Icons.volume_up,
//                               color: Colors.blue,
//                               size: 30,
//                             )
//                           : Icon(
//                               Icons.volume_up,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                     ),
//                     // ElevatedButton(
//                     //   onPressed: this._switchCamera,
//                     //   child: Text('Camera ${switchCamera ? 'front' : 'rear'}'),
//                     // ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 30 + MediaQuery.of(context).padding.bottom,
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   _renderVideo() {
//     return Expanded(
//       child: Stack(
//         children: [
//           RtcLocalView.SurfaceView(),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Padding(
//                 padding: EdgeInsets.only(right: 15, bottom: MediaQuery.of(context).padding.bottom + 100),
//                 child: Row(
//                   children: List.of(
//                     remoteUid.map(
//                       (e) => GestureDetector(
//                         onTap: this._switchRender,
//                         child: Container(
//                           height: 150,
//                           width: 110,
//                           child: RtcRemoteView.SurfaceView(
//                             uid: e,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
