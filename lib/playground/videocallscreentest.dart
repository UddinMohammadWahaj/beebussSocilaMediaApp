// import 'dart:async';
// import 'dart:developer';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:englishlearn/src/pages/rating.dart';
// import 'package:englishlearn/src/pages/timecall.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_countdown_timer/index.dart';

// import '../utils/settings.dart';

// class CallPage extends StatefulWidget {
//   /// non-modifiable channel name of the page
//   final String? channelName;

//   /// non-modifiable client role of the page
//   final ClientRole? role;

//   /// Creates a call page with given channel name.
//   const CallPage({Key? key, this.channelName, this.role}) : super(key: key);

//   @override
//   _CallPageState createState() => _CallPageState();
// }

// class _CallPageState extends State<CallPage> {
//   final _users = <int>[];
//   List<String> fireuidlist = [];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   bool pass = false;
//   late RtcEngine _engine;
//   CountdownTimerController? time;
//   bool hasShare = false;
//   @override
//   void dispose() async {
//     // clear users
//     _users.clear();
//     // destroy sdk

//     _engine.leaveChannel();

//     _engine.destroy();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // time!.addListener(() {});
//     // initialize agora sdk
//     initialize();
//   }

//   Future<void> initialize() async {
//     if (APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }

//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await _engine.enableWebSdkInteroperability(true);
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     // configuration.dimensions = VideoDimensions(1920, 1080);
//     await _engine.setVideoEncoderConfiguration(configuration);
//     await _engine.joinChannel(Token, widget.channelName!, null, 0);
//   }

//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(APP_ID);
//     await _engine.enableAudio();
//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _engine.setClientRole(widget.role!);
//   }

//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     }, joinChannelSuccess: (channel, uid, elapsed) {
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//         fireuidlist.add(FirebaseAuth.instance.currentUser!.uid);
//       });
//     }, leaveChannel: (stats) {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     }, userJoined: (uid, elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     }, userOffline: (uid, elapsed) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//     }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//       });
//     }));
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(RtcLocalView.SurfaceView());
//     }
//     _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
//     return list;
//   }

//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]])
//           ],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   showpop(context, List<String> filterlist) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Share your contact?'),
//             actions: [
//               ButtonBar(children: [
//                 TextButton(
//                   onPressed: () async {
//                     String name = await FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(filterlist.first)
//                         .get()
//                         .then((value) => value['name']);

//                     await FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(filterlist.first)
//                         .collection('contactcard')
//                         .add({
//                       "phonenumber":
//                           '${FirebaseAuth.instance.currentUser!.phoneNumber}',
//                       "name": name,
//                     });

//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Yes'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('No'),
//                 ),
//               ])
//             ],
//             contentPadding: EdgeInsets.all(10.0),
//           );
//         },
//         barrierLabel: 'Are you sure to share your contact?');
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           MuteWidget(
//             toggleMute: onToggleMute,
//           ),
//           // RawMaterialButton(
//           //   onPressed: _onToggleMute,
//           //   child: Icon(
//           //     muted ? Icons.mic_off : Icons.mic,
//           //     color: muted ? Colors.white : Colors.indigo,
//           //     size: 35.0,
//           //   ),
//           //   shape: CircleBorder(),
//           //   elevation: 2.0,
//           //   fillColor: muted ? Colors.indigo : Colors.white,
//           //   padding: const EdgeInsets.all(15.0),
//           // ),
//           RawMaterialButton(
//             onPressed: () async {
//               await _onCallEnd(context);
//             },
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           (pass)
//               ? RawMaterialButton(
//                   onPressed: () async {
//                     List<String> filterlist = [];

//                     if (filterlist.length == 0) {
//                       print("empty");
//                       return;
//                     }
//                     filterlist = fireuidlist
//                         .where((element) => (element !=
//                             '${FirebaseAuth.instance.currentUser!.uid}'))
//                         .toList();

//                     showpop(context, filterlist);
//                   },
//                   child: Icon(
//                     Icons.share,
//                     color: Colors.blueAccent,
//                     size: 35.0,
//                   ),
//                   shape: CircleBorder(),
//                   elevation: 2.0,
//                   fillColor: Colors.white,
//                   padding: const EdgeInsets.all(12.0),
//                 )
//               : SizedBox(
//                   height: 1,
//                   width: 1,
//                 )
//         ],
//       ),
//     );
//   }

//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return Text(
//                     "null"); // return type can't be null, a widget was required
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _onCallEnd(BuildContext context) async {

//     }

//     Navigator.pop(context);
//   }

//   void onToggleMute() {
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _viewRows(),
//             _panel(),
//             _toolbar(),
//             Positioned(
//               child: Center(
//                 child: (_users.length < 2)
//                     ? Material(type: MaterialType.transparency)
//                     : (!pass)
//                         ? Material(
//                             type: MaterialType.transparency,
//                             child: CountdownTimer(
//                               widgetBuilder: (context, time) => Material(
//                                   type: MaterialType.transparency,
//                                   child: Text(
//                                     '${(time!.min == null) ? '00' : 35 + time.min!}: ${time.sec!}',
//                                     style: TextStyle(
//                                         fontSize: 30, color: Colors.white),
//                                   )),
//                               textStyle:
//                                   TextStyle(fontSize: 50, color: Colors.white),
//                               onEnd: () {
//                                 setState(() {
//                                   print("heree");
//                                   pass = true;
//                                 });
//                               },
//                               endTime: DateTime.now().millisecondsSinceEpoch +
//                                   600000,
//                             ))
//                         : Material(
//                             type: MaterialType.transparency,
//                             child: CountdownTimer(
//                               widgetBuilder: (context, time) {
//                                 return Material(
//                                     type: MaterialType.transparency,
//                                     child: Text(
//                                       '${(time!.min == null) ? '00' : time.min!}: ${time.sec!}',
//                                       style: TextStyle(
//                                           fontSize: 30, color: Colors.white),
//                                     ));
//                               },
//                               textStyle:
//                                   TextStyle(fontSize: 50, color: Colors.white),
//                               onEnd: () {
//                                 Navigator.of(context).pop();
//                               },
//                               endTime: DateTime.now().millisecondsSinceEpoch +
//                                   2100000,
//                             )),
//                 // : Material(
//                 //     type: MaterialType.transparency,
//                 //     child: CountdownTimer(
//                 //       widgetBuilder: (context, time) {
//                 //         print("${time!.min!}: ${time!.sec!}");
//                 //         return Material(
//                 //             type: MaterialType.transparency,
//                 //             child: Text(
//                 //               '${49 - time.min!}:${(59 - time!.sec!)}',
//                 //               style: TextStyle(
//                 //                   color: Colors.white, fontSize: 30),
//                 //             ));
//                 //       },
//                 //       textStyle:
//                 //           TextStyle(fontSize: 50, color: Colors.white),
//                 //       onEnd: () {
//                 //         setState(() {
//                 //           pass = true;
//                 //         });
//                 //       },
//                 //       endTime:
//                 //           DateTime.now().millisecondsSinceEpoch + 2500000,
//                 //     ))
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
