import 'package:audioplayers/audioplayers.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/AgoraCallDetailModel.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/MyContactModel.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/detailed_chat_screen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/playground/controller/callpagecontroller.dart';
import 'package:bizbultest/playground/src/pages/cameratoggle.dart';
import 'package:bizbultest/playground/src/pages/mute.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/playground/utils/settings.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:flutter/material.dart';

// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart' as wakelock;

class CallPage extends StatefulWidget {
  final bool callFromMe;
  final bool isFromgroup;
  final String channelName;
  final dynamic role;
  final String oppositeMemberId;
  final bool isFromHome;
  final bool callFromButton;
  final String name;
  final String token;
  final String userImage;
  final String appID;
  final CallType callType;

  const CallPage(
      {Key? key,
      this.callFromMe = false,
      this.isFromgroup = false,
      this.channelName = 'beeuzee',
      required this.role,
      required this.oppositeMemberId,
      this.isFromHome = false,
      this.callFromButton = false,
      this.name = "",
      this.token = "",
      this.userImage = "",
      this.appID = '',
      this.callType = CallType.video})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late int _remoteUid;
  final _users = <int>[];
  int count = 0;
  List<String> fireuidlist = [];
  final _infoStrings = <String>[];
  bool muted = false;
  bool hasToggle = false;
  late AudioCache audioCache;
  late AudioPlayer instance;

  final CallPageController controller = Get.put(CallPageController());

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((message) async {
      print("here is this");
      RemoteNotification? notification = message.notification!;
      AndroidNotification? android = message.notification!.android!;

      if (notification != null && android != null) {
        List<String> splittext = notification.body!.split('+');
        String uid = splittext[0] ?? "";
        String callType = splittext[1] ?? "";
        if (callType.contains('bia')) {
          print("bia found");
          await _onCallEnd(context);
        }
      } else if (message.data != null) {
        var bodyData = message.data["body"].toString();
        if (bodyData.contains("cut") && bodyData.contains("bia")) {
          print("bia found");
          await _onCallEnd(context);
        }
      }
    });
    super.initState();
    print("this is iniot state token=${widget.token} appid=${widget.appID} ");
    audioCache = AudioCache();
    instance = AudioPlayer();
    // time!.addListener(() {});
    // initialize agora sdk
    wakelock.Wakelock.enable();
    initialize();
  }

  Future sendPushMessage(int noofusers) async {
    print("sent fcm bia $noofusers");

    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(widget.oppositeMemberId);

    await ChatApiCalls.sendFcmRequest(
        widget.name,
        "count=$count+cut+video+id=${(widget.callFromButton) ? CurrentUser().currentUser.memberID : widget.oppositeMemberId}",
        "call",
        "otherMemberID",
        objUserDetailModel.firebaseToken!,
        0,
        0,
        isVideo: true);
    // setState(() {});
  }

  @override
  void dispose() async {
    _users.clear();

    // clear users
    // controller.timer.cancel();
    controller.obs.close();
    Get.reset();

    // destroy sdk
    // await _engine.leaveChannel();
    print("disposed bi");

    controller.dispose();

    if (count <= 1) {
      // await _engine.destroy();

      print("This statement has been executed $count");
      await sendPushMessage(count);
    }
    //  if(!widget.isFromgroup){
    // await sendPushMessage(count);
    //  }
    super.dispose();
  }

  addCallData() async {
    String callTime = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString() +
        " " +
        DateTime.now().hour.toString() +
        ":" +
        DateTime.now().minute.toString() +
        ":" +
        DateTime.now().second.toString();
    String h = '${controller.hours.value}';
    String m = '${controller.minutes.value}';
    String s = '${controller.seconds.value}';
    print("addcalldata");
    // if (_remoteUid == null) {
    //   print("discon bia");
    //   await ApiProvider().agoraCallDetail(CurrentUser().currentUser.memberID,
    //       widget.oppositeMemberId, "Video", callTime, '0:0:0');
    //   return;
    // }
    AgoraCallDetail callDetail;
    if (widget.callFromButton) {
      callDetail = await ApiProvider().agoraCallDetail(
          CurrentUser().currentUser.memberID!,
          widget.oppositeMemberId,
          (widget.callType == CallType.video) ? "Video" : "Audio",
          callTime,
          '${h}:${m}:${s}');
    } else {
      return;
    }

    /*kishan = 07/02/2022*/
    // AgoraCallDetail callDetail;
    // if (widget.callFromButton) {
    //   callDetail = await ApiProvider().agoraCallDetail(
    //       CurrentUser().currentUser.memberID,
    //       widget.oppositeMemberId,
    //       (widget.callType == CallType.video) ? "Video" : "Audio",
    //       callTime,
    //       '${h}:${m}:${s}',
    //       widget.channelName);
    // } else {
    //   return;
    // }
    //
    // // AgoraCallDetail callDetail = await ApiProvider().agoraCallDetail(
    // //     (widget.isFromHome)
    // //         ? widget.oppositeMemberId
    // //         : CurrentUser().currentUser.memberID,
    // //     (widget.isFromHome)
    // //         ? CurrentUser().currentUser.memberID
    // //         : widget.oppositeMemberId,
    // //     (widget.callType == CallType.video) ? "Video" : "Audio",
    // //     callTime,
    // //     '${h}:${m}:${s}');
    // if (callDetail != null &&
    //     callDetail.data != null &&
    //     callDetail.success == 1) {
    //   print('success yo ');
    // }
  }

  // Display remote user's video
  Widget _remoteVideo() {
    return Container();
    // return RtcRemoteView.SurfaceView(uid: 1);
    // if (_remoteUid != null) {
    //   return RtcRemoteView.SurfaceView(
    //     uid: _remoteUid,
    //     channelId: '',
    //   );
    // } else {
    //   return Text(
    //     'Ringing ${widget.name}...',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       color: Colors.white,
    //     ),
    //   );
    // }
  }

  Future<void> initialize() async {
    //added this new

    if (widget.appID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    // if (widget.callFromButton) {
    //   final file = await audioCache.loadAsFile('tune/diallerTone.mp3');
    //   final bytes = await file.readAsBytes();
    //   instance = await audioCache.playBytes(bytes, loop: true, volume: 0.1);
    //   //added this new
    //    await testsendPushMessage();
    // }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    // VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.dimensions = VideoDimensions(1920, 1080);
    print('channel name ${widget.channelName}');
    // await _engine.setVideoEncoderConfiguration(configuration);

    // await _engine.joinChannel(
    //     // '00676906eec8e2148fbbaadf0db5faeb3c6IACQuqmuykYYC1n0ehxYykr2Levl9faPSAzw/s5FnTZWfXtTe6gAAAAAEADkBngOqPJKYQEAAQCk8kph',
    //    //forjoe  //
    //      // '006a86ce37533fb4d60932f23af4929cfedIAAHdQd4KnVrg4NGF/dfkjEfoUgBGZCU+LYA4mSUDZIeE3tTe6gAAAAAEADkBngOHgNMYQEAAQAeA0xh',
    //     // '006a86ce37533fb4d60932f23af4929cfedIAC49nvvRUTNYlsGMhKQEXCUSAK1RzFg/HIG7iJbtub93HtTe6gAAAAAEADkBngOKZJMYQEAAQApkkxh',
    //     // '006a86ce37533fb4d60932f23af4929cfedIADKBOYztROiOIqVTYW9nhHgMCxItOYG5tQBHYlSeTKMmu2exTgAAAAAEADkBngO+2FNYQEAAQD7YU1h',
    //     widget.token,
    //     widget.channelName,
    //     null,
    //     0

    //     // int.parse((widget.isFromHome)
    //     //     ? widget.oppositeMemberId
    //     //     : CurrentUser().currentUser.memberID)

    //     );
    if (widget.callFromButton)
    // FlutterRingtonePlayer.playNotification(
    //   looping: true,
    {
      // );
      final file = await audioCache.loadAsFile('tune/diallerTone.mp3');
      final bytes = await file.readAsBytes();
      instance = await audioCache.playBytes(bytes, loop: true, volume: 10);
    }
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    print("initiated agora yo");

    /*Kishan*/
    // RtcEngineContext context = RtcEngineContext(widget.appID);
    // _engine = await RtcEngine.createWithContext(context);

    /*Comment on- 24-1*/
    // _engine = await RtcEngine.create(widget.appID);
    // await _engine.enableAudio();
    // await _engine.enableLocalAudio(true);
    // await _engine.enableLocalVideo(true);

    // await _engine.enableRemoteSuperResolution(uid, enable)
    // await _engine.enableVideo();
    // print("my role is ${widget.role}");
    // await _engine.setChannelProfile(ChannelProfile.Communication);
    // await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    // _engine.setEventHandler(RtcEngineEventHandler(
    //     requestToken: () {},
    //     remoteVideoStateChanged: (uid, state, reason, elapsed) {
    //       print("bia remote video ${state.index}");
    //     },
    //     error: (code) {
    //       setState(() {
    //         print("Token=${widget.token},APpid=${APP_ID}");
    //         print("bia errror ${code}");
    //         final info = 'onError: ${code}';
    //         _infoStrings.add(info);
    //       });
    //     },
    //     joinChannelSuccess: (channel, uid, elapsed) async {
    //       print("bia sucesss join");
    //       setState(() {
    //         final info = 'onJoinChannel: $channel, uid: $uid';
    //         _infoStrings.add(info);
    //         fireuidlist.add(CurrentUser().currentUser.memberID!);
    //       });
    //     },
    //     leaveChannel: (stats) async {
    //       setState(() {
    //         print("current no of  user list=${_users.length}");
    //         _infoStrings.add('onLeaveChannel');
    //         _users.clear();
    //       });
    //     },
    //     userJoined: (uid, elapsed) async {
    //       await FlutterRingtonePlayer.stop();
    //       instance.dispose();
    //       setState(() {
    //         instance.dispose();
    //         _remoteUid = uid;

    //         controller.startTimer();
    //         controller.callStarted.value = true;
    //         final info = 'userJoined: $uid';
    //         _infoStrings.add(info);

    //         _users.add(uid);
    //         count++;
    //       });
    //     },
    //     userOffline: (uid, elapsed) async {
    //       if (_users.length <= 1) {
    //         print("an user is off");
    //         await _onCallEnd(context);
    //       }
    //       setState(() {
    //         //_remoteUid = null;
    //         print("no of users=${_users.length}");
    //         final info = 'useris offline: $uid';
    //         _infoStrings.add(info);
    //         _users.remove(uid);
    //         count--;
    //       });
    //     },
    //     firstRemoteVideoFrame: (uid, width, height, elapsed) {
    //       setState(() {
    //         final info = 'firstRemoteVideo: $uid ${width}x $height';
    //         _infoStrings.add(info);
    //       });
    //     }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];

    // list.add(RtcLocalView.SurfaceView());

    // _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
    //       uid: uid,
    //       channelId: '',
    //     )));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    print('total views=${views.length}   ');
    switch (views.length) {
      case 1:
        return Stack(
          children: [
            // Obx(
            //   () => Center(
            //     child: (controller.hasToggle.value)
            //         ? RtcLocalView.SurfaceView()
            //         : _remoteVideo(),
            //   ),
            // ),
            // Obx(
            //   () => InkWell(
            //     onTap: () {
            //       controller.toggle();
            //       print(
            //           "clickbi not${controller.hasToggle.value} uid=${_remoteUid}");
            //     },
            //     child: Align(
            //       alignment: Alignment.topLeft,
            //       child: Container(
            //         width: 140,
            //         height: 140,
            //         color: Colors.black,
            //         // child: RtcLocalView.SurfaceView(),
            //         child: Center(
            //             child: (!controller.hasToggle.value)
            //                 ? RtcLocalView.TextureView()
            //                 : _remoteVideo()),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );

      // return Container(
      //     child: Column(
      //   children: <Widget>[_videoView(views[0])],
      // ));
      case 2:
        return Stack(
          children: [
            // Obx(
            //   () => Center(
            //     child: (controller.hasToggle.value)
            //         ? RtcLocalView.SurfaceView()
            //         : _remoteVideo(),
            //   ),
            // ),
            // Obx(
            //   () => InkWell(
            //     onTap: () {
            //       controller.toggle();
            //       print(
            //           "clickbi not${controller.hasToggle.value} uid=${_remoteUid}");
            //     },
            //     child: Align(
            //       alignment: Alignment.topLeft,
            //       child: Container(
            //         width: 140,
            //         height: 140,
            //         color: Colors.black,
            //         // child: RtcLocalView.SurfaceView(),
            //         child: Center(
            //             child: (!controller.hasToggle.value)
            //                 ? RtcLocalView.TextureView()
            //                 : _remoteVideo()),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      // return Container(
      //     child: Column(
      //   children: <Widget>[
      //     _expandedVideoRow([views[0]]),
      //     _expandedVideoRow([views[1]])
      //   ],
      // ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      case 5:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 5))
          ],
        ));
      case 6:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6))
          ],
        ));
      case 7:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 7))
          ],
        ));
      case 8:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 8))
          ],
        ));
      case 9:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 8)),
            _expandedVideoRow(views.sublist(8, 9))
          ],
        ));
      case 10:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 8)),
            _expandedVideoRow(views.sublist(8, 10))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (true) {}
              if (_infoStrings.isEmpty) {
                return Text("null");
                // return type can't be null, a widget was
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future sendcallPushMessage(
      {bool isVideo = false,
      token,
      channelName,
      String? oppositeMemberId}) async {
    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(oppositeMemberId!);
    print('magia $token oppomemid=$oppositeMemberId');
    String aa = "";
    if (isVideo) {
      aa = CurrentUser().currentUser.memberID! +
          "+video+token=$token+channelName=${channelName}";
    } else {
      aa = CurrentUser().currentUser.memberID! +
          "+audio+token=$token+channelName=${channelName}";
    }

    /*User join created room call */
    String callTime = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString() +
        " " +
        DateTime.now().hour.toString() +
        ":" +
        DateTime.now().minute.toString() +
        ":" +
        DateTime.now().second.toString();
    String h = '${controller.hours.value}';
    String m = '${controller.minutes.value}';
    String s = '${controller.seconds.value}';

    // bool isJoin = await ApiProvider.sendRoomCallingInfo(CurrentUser().currentUser.memberID,
    //     widget.oppositeMemberId, channelName, 0,widget.callType == CallType.video ? "Video" : "Audio",
    //     callTime,
    //     '0:0:0');
    //
    // if (isJoin) {
    //   await ChatApiCalls.sendFcmRequest(CurrentUser().currentUser.fullName, aa,
    //       "call", "otherMemberID", objUserDetailModel.firebaseToken, 0, 0,
    //       isVideo: isVideo);
    // }
    await ChatApiCalls.sendFcmRequest(CurrentUser().currentUser.fullName!, aa,
        "call", "otherMemberID", objUserDetailModel.firebaseToken!, 0, 0,
        isVideo: isVideo);
  }

  Future<void> _onCallEnd(BuildContext context) async {
    // if (widget.role == ClientRole.Broadcaster)
    FlutterRingtonePlayer.stop();

    instance.dispose();
    if (widget.callFromButton) {
      await addCallData();
    }

    Navigator.pop(context);

    if (!widget.callFromButton) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            memberID: CurrentUser().currentUser.memberID,
            logo: CurrentUser().currentUser.logo,
            country: CurrentUser().currentUser.country,
            currentMemberImage: CurrentUser().currentUser.image,
          ),
        ),
      );
    }
  }

  void onToggleMute(muted) async {
    // await _engine.muteLocalAudioStream(muted);
  }

  myContact() async {
    await ChatApiCalls.getChatContactsList("").then((value) => {
          value!.users.forEach((element) {
            print(element.name);
          })
        });

    // try {
    //   var objMyContactModel =
    //       await ApiProvider().myContacts(CurrentUser().currentUser.memberID);

    //   if (objMyContactModel != null && objMyContactModel.contactList != null) {
    //     objMyContactModel.contactList.forEach((element) {
    //       if (element.memberId != CurrentUser().currentUser.memberID) {
    //         // lstContactList.add(element);
    //         print('yawah $element');
    //       }
    //     });
    //   }
    // } catch (e) {
    //   print(e);
    // } finally {}
  }

  // Future showGroupAdd(context) async {
  //   await showModalBottomSheet(
  //       context: context,
  //       elevation: 10,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //       builder: (context) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             gradientContainer(
  //               ListTile(
  //                 tileColor: Colors.indigo,
  //                 leading: new Icon(
  //                   Icons.add_call,
  //                   color: Colors.white,
  //                 ),
  //                 title: new Text('Add Participants',
  //                     style: TextStyle(color: Colors.white)),
  //                 onTap: () async {
  //                   // await ChatApiCalls.getChatsListLocal()
  //                   //     .then((value) => print(value.users));
  //                   await myContact();
  //
  //                   await showCupertinoDialog(
  //                       context: context,
  //                       builder: (context) => Scaffold(
  //                           appBar: AppBar(
  //                             flexibleSpace: gradientContainer(null),
  //                             title: Text("Add Participants"),
  //                           ),
  //                           body: Material(
  //                             child: SingleChildScrollView(
  //                               child: Column(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: <Widget>[
  //                                   FutureBuilder(
  //                                     future: ChatApiCalls.getChatsListLocal(),
  //                                     // future: ChatApiCalls.getChatContactsList(""),
  //                                     builder: (context,
  //                                         AsyncSnapshot<DirectUsers> snapshot) {
  //                                       if (snapshot.data != []) {
  //                                         var users = snapshot.data.users;
  //
  //                                         users = users
  //                                             .where((element) =>
  //                                                 element.fromuserid !=
  //                                                 widget.oppositeMemberId)
  //                                             .toList();
  //
  //                                         // controller.addedcalllist
  //                                         //     .forEach((element) {
  //                                         //   for (int i = 0;
  //                                         //       i < users.length;
  //                                         //       i++) {
  //                                         //     if (users[i].fromuserid ==
  //                                         //         element.fromuserid) {
  //                                         //       users.removeAt(i);
  //                                         //     }
  //                                         //   }
  //                                         //   // users.forEach((user) {
  //                                         //   //   if (user.fromuserid ==
  //                                         //   //       element.fromuserid) {
  //                                         //   //     users.remove(user);
  //                                         //   //   }
  //                                         //   // });
  //                                         // });
  //                                         // print('dhana ${users.length}');
  //                                         // return Text('${snapshot.data.users.length}');
  //                                         return Container(
  //                                           child: ListView.separated(
  //                                             separatorBuilder:
  //                                                 (context, index) => Divider(
  //                                               height: 2,
  //                                             ),
  //                                             shrinkWrap: true,
  //                                             itemCount: users.length,
  //                                             itemBuilder: (context, index) =>
  //                                                 ListTile(
  //                                               onTap: () {
  //                                                 if (controller
  //                                                     .addUser(users[index]))
  //                                                   sendcallPushMessage(
  //                                                       isVideo: (widget
  //                                                                   .callType ==
  //                                                               CallType.video)
  //                                                           ? true
  //                                                           : false,
  //                                                       token: widget.token,
  //                                                       channelName:
  //                                                           widget.channelName,
  //                                                       oppositeMemberId: controller
  //                                                           .addedcalllist[controller
  //                                                                   .addedcalllist
  //                                                                   .length -
  //                                                               1]
  //                                                           .fromuserid);
  //
  //                                                 Navigator.of(context).pop();
  //                                               },
  //                                               leading: users[index].image !=
  //                                                           null &&
  //                                                       users[index].image != ""
  //                                                   ? Container(
  //                                                       width: 50.0,
  //                                                       height: 50.0,
  //                                                       decoration:
  //                                                           new BoxDecoration(
  //                                                         shape:
  //                                                             BoxShape.circle,
  //                                                         image:
  //                                                             new DecorationImage(
  //                                                           fit: BoxFit.fill,
  //                                                           image:
  //                                                               new NetworkImage(
  //                                                                   users[index]
  //                                                                       .image),
  //                                                         ),
  //                                                       ),
  //                                                     )
  //                                                   : Container(
  //                                                       width: 100.0,
  //                                                       height: 100.0,
  //                                                       decoration:
  //                                                           new BoxDecoration(
  //                                                         shape:
  //                                                             BoxShape.circle,
  //                                                         color: Colors.black,
  //                                                       ),
  //                                                       child: Icon(
  //                                                         Icons.person,
  //                                                         color: Colors.grey,
  //                                                         size: 80,
  //                                                       ),
  //                                                     ),
  //                                               title: Text(
  //                                                   '${users[index].name}'),
  //                                             ),
  //                                           ),
  //                                         );
  //                                       }
  //                                       return Text('No participants');
  //                                     },
  //                                   ),
  //
  //                                   // ListTile(
  //                                   //   leading: new Icon(Icons.videocam),
  //                                   //   title: new Text('Video'),
  //                                   //   onTap: () {
  //                                   //     Navigator.pop(context);
  //                                   //   },
  //                                   // ),
  //                                   // ListTile(
  //                                   //   leading: new Icon(Icons.share),
  //                                   //   title: new Text('Share'),
  //                                   //   onTap: () {
  //                                   //     Navigator.pop(context);
  //                                   //   },
  //                                   // ),
  //                                 ],
  //                               ),
  //                             ),
  //                           )));
  //                 },
  //               ),
  //             ),
  //
  //             ListTile(
  //               leading: widget.userImage != null && widget.userImage != ""
  //                   ? Container(
  //                       width: 50.0,
  //                       height: 50.0,
  //                       decoration: new BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         image: new DecorationImage(
  //                           fit: BoxFit.fill,
  //                           image: new NetworkImage(
  //                             widget.userImage,
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : Container(
  //                       width: 100.0,
  //                       height: 100.0,
  //                       decoration: new BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Colors.black,
  //                       ),
  //                       child: Icon(
  //                         Icons.person,
  //                         color: Colors.grey,
  //                         size: 80,
  //                       ),
  //                     ),
  //               title: Text('${widget.name}'),
  //             ),
  //
  //             Obx(
  //               () => Container(
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: controller.addedcalllist.length,
  //                   itemBuilder: (context, index) => ListTile(
  //                     leading: controller.addedcalllist[index].image != null &&
  //                             controller.addedcalllist[index].image != ""
  //                         ? Container(
  //                             width: 50.0,
  //                             height: 50.0,
  //                             decoration: new BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               image: new DecorationImage(
  //                                 fit: BoxFit.fill,
  //                                 image: new NetworkImage(
  //                                     controller.addedcalllist[index].image),
  //                               ),
  //                             ),
  //                           )
  //                         : Container(
  //                             width: 100.0,
  //                             height: 100.0,
  //                             decoration: new BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color: Colors.black,
  //                             ),
  //                             child: Icon(
  //                               Icons.person,
  //                               color: Colors.grey,
  //                               size: 80,
  //                             ),
  //                           ),
  //                     title: Text('${controller.addedcalllist[index].name}'),
  //                   ),
  //                 ),
  //               ),
  //             )
  //
  //             // ListTile(
  //             //   leading: new Icon(Icons.videocam),
  //             //   title: new Text('Video'),
  //             //   onTap: () {
  //             //     Navigator.pop(context);
  //             //   },
  //             // ),
  //             // ListTile(
  //             //   leading: new Icon(Icons.share),
  //             //   title: new Text('Share'),
  //             //   onTap: () {
  //             //     Navigator.pop(context);
  //             //   },
  //             // ),
  //           ],
  //         );
  //       });
  // }

  Widget slideShow() {
    return SlidingUpPanel(
        body: (controller.callStarted.value)
            ? widget.userImage != null && widget.userImage != ""
                ? Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.7,
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                            widget.userImage,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.7,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 80,
                      ),
                    ),
                  )
            : null,
        onPanelOpened: () async {},
        color: Colors.black.withAlpha(100),
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        panel: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: WrapCrossAlignment.center,
            // alignment: WrapAlignment.center,
            children: [
              Center(
                  child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (widget.callType == CallType.video)
                      ? Obx(
                          () => RawMaterialButton(
                            onPressed: () async {
                              print("bia");

                              controller.togglevideocam();
                              // _engine
                              //     .enableLocalVideo(controller.videocam.value);
                              // await objAgoraClient.sessionController.endCall();

                              // await _stopFile();

                              //sendpushmessage
                              // await addCallData();
                            },
                            child: Icon(
                              (controller.videocam.value)
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              color: Colors.indigo,
                              size: 35.0,
                            ),
                            shape: CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(15.0),
                          ),
                        )
                      : SizedBox(width: 0),
                  Obx(
                    () => RawMaterialButton(
                      onPressed: () async {
                        print('video has ben enabled!!');
                        // await ChatApiCalls.getChatsListLocal().then((value) =>
                        //     print('duder nodu ${value.users[0].fromuserid}'));
                        controller.toggleMute();
                        onToggleMute(controller.isMute.value);
                      },
                      child: Icon(
                        (controller.isMute.value) ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                        // color: muted ? Colors.white : Colors.indigo,
                        size: 35.0,
                      ),
                      padding: const EdgeInsets.all(15.0),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      instance.dispose();

                      await _onCallEnd(context);

                      // await objAgoraClient.sessionController.endCall();

                      // await _stopFile();

                      //sendpushmessage
                      // await addCallData();
                    },
                    child: Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  ((!controller.callStarted.value) && (!widget.callFromMe))
                      ? RawMaterialButton(
                          onPressed: () async {
                            instance.dispose();

                            await _onCallEnd(context);

                            // await objAgoraClient.sessionController.endCall();

                            // await _stopFile();

                            //sendpushmessage
                            // await addCallData();
                          },
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.green,
                          padding: const EdgeInsets.all(15.0),
                        )
                      : SizedBox(),
                  (widget.callType == CallType.video)
                      ? CameraMuteWidget(
                          toggleMute: _onSwitchCamera,
                        )
                      : Obx(
                          () => RawMaterialButton(
                              padding: const EdgeInsets.all(15.0),
                              onPressed: () {
                                controller.toggleSpeaker();
                                // _engine.setEnableSpeakerphone(
                                //     controller.isSpeakerOn.value);
                              },
                              child: (controller.isSpeakerOn.value)
                                  ? Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : Icon(
                                      Icons.volume_down,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                        )
                ],
              ),
              SizedBox(height: 50, width: double.infinity),
              gradientContainer(
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  child: ListTile(
                    tileColor: Colors.indigo,
                    leading: new Icon(
                      Icons.add_call,
                      color: Colors.white,
                    ),
                    title: new Text('Add Participants',
                        style: TextStyle(color: Colors.white)),
                    onTap: () async {
                      // await ChatApiCalls.getChatsListLocal()
                      //     .then((value) => print(value.users));
                      await showCupertinoDialog(
                          context: context,
                          builder: (context) => Scaffold(
                              appBar: AppBar(
                                flexibleSpace: gradientContainer(null),
                                title: Text("Add Participants"),
                              ),
                              body: Material(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FutureBuilder(
                                        future: ChatApiCalls
                                            .getChatsListLocal() /*ChatApiCalls
                                                .getChatContactsList("")*/
                                        ,
                                        builder: (context,
                                            AsyncSnapshot<DirectUsers>
                                                snapshot) {
                                          if (snapshot.data != []) {
                                            var users = snapshot.data!.users;

                                            users = users
                                                .where((element) =>
                                                    element.fromuserid !=
                                                    widget.oppositeMemberId)
                                                .toList();

                                            // controller.addedcalllist
                                            //     .forEach((element) {
                                            //   for (int i = 0;
                                            //       i < users.length;
                                            //       i++) {
                                            //     if (users[i].fromuserid ==
                                            //         element.fromuserid) {
                                            //       users.removeAt(i);
                                            //     }
                                            //   }
                                            //   // users.forEach((user) {
                                            //   //   if (user.fromuserid ==
                                            //   //       element.fromuserid) {
                                            //   //     users.remove(user);
                                            //   //   }
                                            //   // });
                                            // });
                                            // print('dhana ${users.length}');
                                            // return Text('${snapshot.data.users.length}');
                                            return Container(
                                              child: ListView.separated(
                                                separatorBuilder:
                                                    (context, index) => Divider(
                                                  height: 2,
                                                ),
                                                shrinkWrap: true,
                                                itemCount: users.length,
                                                itemBuilder: (context, index) =>
                                                    ListTile(
                                                  onTap: () {
                                                    if (controller
                                                        .addUser(users[index]))
                                                      sendcallPushMessage(
                                                          isVideo:
                                                              (widget.callType ==
                                                                      CallType
                                                                          .video)
                                                                  ? true
                                                                  : false,
                                                          token: widget.token,
                                                          channelName: widget
                                                              .channelName,
                                                          oppositeMemberId: controller
                                                              .addedcalllist[controller
                                                                      .addedcalllist
                                                                      .length -
                                                                  1]
                                                              .fromuserid);

                                                    Navigator.of(context).pop();
                                                  },
                                                  leading: users[index].image !=
                                                              null &&
                                                          users[index].image !=
                                                              ""
                                                      ? Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image:
                                                                new DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: new NetworkImage(
                                                                  users[index]
                                                                      .image!),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.black,
                                                          ),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: Colors.grey,
                                                            size: 80,
                                                          ),
                                                        ),
                                                  title: Text(
                                                      '${users[index].name}'),
                                                ),
                                              ),
                                            );
                                          }
                                          return Text('No participants');
                                        },
                                      ),

                                      // ListTile(
                                      //   leading: new Icon(Icons.videocam),
                                      //   title: new Text('Video'),
                                      //   onTap: () {
                                      //     Navigator.pop(context);
                                      //   },
                                      // ),
                                      // ListTile(
                                      //   leading: new Icon(Icons.share),
                                      //   title: new Text('Share'),
                                      //   onTap: () {
                                      //     Navigator.pop(context);
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                              )));
                    },
                  ),
                ),
              ),
              Material(
                color: Colors.black.withAlpha(50),
                child: ListTile(
                  tileColor: Colors.white,
                  leading: widget.userImage != null && widget.userImage != ""
                      ? Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                widget.userImage,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 80,
                          ),
                        ),
                  title: Text('${widget.name}'),
                ),
              ),
              Obx(
                () => Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.addedcalllist.length,
                    itemBuilder: (context, index) => Material(
                      color: Colors.white,
                      child: ListTile(
                        tileColor: Colors.white,
                        leading: controller.addedcalllist[index].image !=
                                    null &&
                                controller.addedcalllist[index].image != ""
                            ? Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        controller.addedcalllist[index].image),
                                  ),
                                ),
                              )
                            : Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 80,
                                ),
                              ),
                        title: Text('${controller.addedcalllist[index].name}'),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
        //  ClipRRect(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        //   child: Container(
        //     height: MediaQuery.of(context).size.height / 6,
        //     width: MediaQuery.of(context).size.width,
        //     child:
        //      Material(
        //       color: Colors.black.withAlpha(100),
        //       child:

        //     ),
        //   ),
        // ),

        );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    // _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    // _engine.switchCamera();
// _engine.stopPreview()
  }

  Future getImage() async {
    var userdet = await ApiProvider().getUserDetail(widget.oppositeMemberId);
    print("bia here image ${userdet.image}");
  }

  @override
  Widget build(BuildContext context) {
    Widget _toolbar() {
      if (widget.callType == CallType.video)
        return Container(
          alignment: Alignment.bottomCenter,
          // color: (widget.callType == CallType.audio)
          //     ? Colors.transparent
          //     : Colors.white,
          // height: (widget.callType == CallType.audio) ? context.height / 5 : 100,
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (widget.callType == CallType.video)
                  ? Obx(
                      () => RawMaterialButton(
                        onPressed: () async {
                          print("bia");

                          controller.togglevideocam();
                          // _engine.enableLocalVideo(controller.videocam.value);
                          // await objAgoraClient.sessionController.endCall();

                          // await _stopFile();

                          //sendpushmessage
                          // await addCallData();
                        },
                        child: Icon(
                          (controller.videocam.value)
                              ? Icons.videocam
                              : Icons.videocam_off,
                          color: Colors.indigo,
                          size: 35.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                      ),
                    )
                  : SizedBox(width: 0),
              Obx(
                () => RawMaterialButton(
                  onPressed: () async {
                    print('video has ben enabled!!');
                    // await ChatApiCalls.getChatsListLocal().then((value) =>
                    //     print('duder nodu ${value.users[0].fromuserid}'));
                    controller.toggleMute();
                    onToggleMute(controller.isMute.value);
                  },
                  child: Icon(
                    (controller.isMute.value) ? Icons.mic_off : Icons.mic,
                    color: muted ? Colors.white : Colors.indigo,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.indigo : Colors.white,
                  padding: const EdgeInsets.all(15.0),
                ),
              ),
              RawMaterialButton(
                onPressed: () async {
                  instance.dispose();
                  await FlutterRingtonePlayer.stop();
                  await _onCallEnd(context);

                  // await objAgoraClient.sessionController.endCall();

                  // await _stopFile();

                  //sendpushmessage
                  // await addCallData();
                },
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(15.0),
              ),
              (!widget.callFromMe)
                  ? RawMaterialButton(
                      onPressed: () async {
                        instance.dispose();
                        await FlutterRingtonePlayer.stop();
                        await _onCallEnd(context);

                        // await objAgoraClient.sessionController.endCall();

                        // await _stopFile();

                        //sendpushmessage
                        // await addCallData();
                      },
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.green,
                      padding: const EdgeInsets.all(15.0),
                    )
                  : SizedBox(),
              (widget.callType == CallType.video)
                  ? CameraMuteWidget(
                      toggleMute: _onSwitchCamera,
                    )
                  : Obx(
                      () => RawMaterialButton(
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(15.0),
                          onPressed: () {
                            controller.toggleSpeaker();
                            // _engine.setEnableSpeakerphone(
                            //     controller.isSpeakerOn.value);
                          },
                          child: (controller.isSpeakerOn.value)
                              ? Icon(
                                  Icons.volume_up,
                                  color: Colors.indigo,
                                  size: 30,
                                )
                              : Icon(
                                  Icons.volume_down,
                                  color: Colors.grey,
                                  size: 30,
                                )),
                    )
            ],
          ),
        );
      else {
        if (controller.callStarted.value)
          return Container(
            alignment: Alignment.bottomCenter,
            // color: (widget.callType == CallType.audio)
            color: Colors.transparent,
            //     : Colors.white,
            height: context.height / 5,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (widget.callType == CallType.video)
                    ? Obx(
                        () => RawMaterialButton(
                          onPressed: () async {
                            print("bia");

                            controller.togglevideocam();
                            // _engine.enableLocalVideo(controller.videocam.value);
                            // await objAgoraClient.sessionController.endCall();

                            // await _stopFile();

                            //sendpushmessage
                            // await addCallData();
                          },
                          child: Icon(
                            (controller.videocam.value)
                                ? Icons.videocam
                                : Icons.videocam_off,
                            color: Colors.indigo,
                            size: 35.0,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(15.0),
                        ),
                      )
                    : SizedBox(width: 0),
                Obx(
                  () => RawMaterialButton(
                    onPressed: () async {
                      print('video has ben enabled!!');
                      // await ChatApiCalls.getChatsListLocal().then((value) =>
                      //     print('duder nodu ${value.users[0].fromuserid}'));
                      controller.toggleMute();
                      onToggleMute(controller.isMute.value);
                    },
                    child: Icon(
                      (controller.isMute.value) ? Icons.mic_off : Icons.mic,
                      color: muted ? Colors.white : Colors.indigo,
                      size: 35.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted ? Colors.indigo : Colors.white,
                    padding: const EdgeInsets.all(15.0),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    instance.dispose();
                    await FlutterRingtonePlayer.stop();
                    await _onCallEnd(context);

                    // await objAgoraClient.sessionController.endCall();

                    // await _stopFile();

                    //sendpushmessage
                    // await addCallData();
                  },
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
                (!widget.callFromMe)
                    ? RawMaterialButton(
                        onPressed: () async {
                          instance.dispose();
                          await FlutterRingtonePlayer.stop();
                          await _onCallEnd(context);

                          // await objAgoraClient.sessionController.endCall();

                          // await _stopFile();

                          //sendpushmessage
                          // await addCallData();
                        },
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.green,
                        padding: const EdgeInsets.all(15.0),
                      )
                    : SizedBox(),
                (widget.callType == CallType.video)
                    ? CameraMuteWidget(
                        toggleMute: _onSwitchCamera,
                      )
                    : Obx(
                        () => RawMaterialButton(
                            shape: CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(15.0),
                            onPressed: () {
                              controller.toggleSpeaker();
                              // _engine.setEnableSpeakerphone(
                              //     controller.isSpeakerOn.value);
                            },
                            child: (controller.isSpeakerOn.value)
                                ? Icon(
                                    Icons.volume_up,
                                    color: Colors.indigo,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.volume_down,
                                    color: Colors.grey,
                                    size: 30,
                                  )),
                      )
              ],
            ),
          );
        else {
          return slideShow();
        }
      }
    }

    print(
        'clickbi built calltype=${widget.callType} and ${widget.callType == CallType.video}');
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(
        () => Scaffold(
            appBar: AppBar(
              flexibleSpace: gradientContainer(null),
              leadingWidth: 0,
              toolbarHeight: (controller.callStarted.value &&
                      widget.callType == CallType.audio)
                  ? 170
                  : 0,
              elevation: 0,
              centerTitle: true,
              title: Column(children: [
                Text(widget.name, style: TextStyle(color: Colors.white)),
                Obx(
                  () => Text(
                    (!controller.callStarted.value)
                        ? 'Ringing...'
                        : '${controller.hours.value}:${controller.minutes.value}:${controller.seconds.value}',
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ]),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: (widget.callType == CallType.audio)
                ? Colors.transparent
                : Colors.black,
            body: (widget.callType == CallType.video)
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        //remoteview

                        //remoteview wend
                        // InkWell(
                        //   onTap: () {
                        //     // controller.toggle();
                        //     print(
                        //         "clickbi ${controller.hasToggle.value} uid=${_remoteUid}");
                        //   },
                        //   child: Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Container(
                        //       width: 140,
                        //       height: 140,
                        //       color: Colors.pink,
                        //       child: RtcLocalView.TextureView(),
                        //     ),
                        //   ),
                        // ),
                        // _viewRows(),
                        // Wrap(
                        //   children: [
                        //     Align(
                        //       alignment: Alignment.topLeft,
                        //       child: Container(
                        //         width: 140,
                        //         height: 140,
                        //         color: Colors.pink,
                        //         // child: RtcLocalView.SurfaceView(),
                        //         child: Center(child: RtcLocalView.TextureView()),
                        //       ),
                        //     ),
                        //     Align(
                        //       alignment: Alignment.topLeft,
                        //       child: Container(
                        //         width: 140,
                        //         height: 140,
                        //         color: Colors.pink,
                        //         // child: RtcLocalView.SurfaceView(),
                        //         child: Center(child: RtcLocalView.TextureView()),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        _viewRows(),

                        _toolbar()
                      ],
                    ),
                  )
                : (controller.callStarted.value)
                    ? widget.userImage != null && widget.userImage != ""
                        ? Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                    widget.userImage,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 50),
                              width: double.infinity,
                              height: double.infinity,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.black),
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 80,
                              ),
                            ),
                          )
                    :

                    //if image null
                    //  Container(

                    //     width: 100.0,
                    //     height: 100.0,
                    //     decoration: new BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Colors.black,
                    //     ),
                    //     child: Icon(
                    //       Icons.person,
                    //       color: Colors.grey,
                    //       size: 80,
                    //     ),
                    //   ),
                    //imagenullend

                    //Previous wrapper of call ui
                    Container(
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              const Color(0xff2B25CC),
                              const Color(0xffA6635B),
                              const Color(0xff91596F),
                              const Color(0xffB46A4D),
                              const Color(0xffF18910),
                              const Color(0xffA6635B),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                        // color: Colors.white,
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          Stack(alignment: Alignment.topCenter, children: [
                            Stack(
                              children: [
                                Center(
                                    child:
                                        Obx(() => (controller.callStarted.value)
                                            ? Text(
                                                '${controller.hours.value.toString().length < 2 ? 0 : ''}${controller.hours.value}:${controller.minutes.value.toString().length < 2 ? 0 : ''}${controller.minutes.value}:${controller.seconds.value.toString().length < 2 ? 0 : ''}${controller.seconds.value}',
                                                style: TextStyle(fontSize: 30),
                                              )
                                            : SpinKitWanderingCubes(
                                                size: 100,
                                                color: Colors.indigo,
                                              ))),
                              ],
                            ),
                            Positioned(
                                top: kToolbarHeight,
                                child: Column(
                                  children: [
                                    widget.userImage != null &&
                                            widget.userImage != ""
                                        ? Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new NetworkImage(
                                                  widget.userImage,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                              size: 80,
                                            ),
                                          ),
                                    SizedBox(height: 30),
                                    Text(
                                      '${widget.name}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (_remoteUid == null)
                                          ? 'Ringing  ${widget.name} ...'
                                          : 'On Call....',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                )),
                          ]),
                          Positioned(
                            child: _toolbar(),
                          )
                        ]),
                      ),

            //     Center(
            //         child: Stack(children: <Widget>[
            //   _viewRows(),
            //   _panel(),
            //   _toolbar(),
            // ]
            //             // Positioned(
            //             //   child: Center(child: Material(type: MaterialType.transparency)

            //             // : Material(
            //             //     type: MaterialType.transparency,
            //             //     child: CountdownTimer(
            //             //       widgetBuilder: (context, time) {
            //             //         print("${time!.min!}: ${time!.sec!}");
            //             //         return Material(
            //             //             type: MaterialType.transparency,
            //             //             child: Text(
            //             //               '${49 - time.min!}:${(59 - time!.sec!)}',
            //             //                style: TextStyle(
            //             //                   color: Colors.white, fontSize: 30),
            //             //             ));
            //             //       },
            //             //       textStyle:
            //             //           TextStyle(fontSize: 50, color: Colors.white),
            //             //       onEnd: () {
            //             //         setState(() {
            //             //           pass = true;
            //             //         });
            //             //       },
            //             //       endTime:
            //             //           DateTime.now().millisecondsSinceEpoch + 2500000,
            //             //     ))

            //             )),

            //FloatingButton
            /* floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndTop,
            floatingActionButton: FloatingActionButton(
              backgroundColor: fabBgColor,
              foregroundColor: Colors.white,
              onPressed: () async {
                //showgroupadd
                await showGroupAdd(context);
              },
              child:
                  gradientContainerForButton(Icon(Icons.add_ic_call_rounded)),
            ),*/
            bottomNavigationBar: (widget.callType == CallType.video)
                ? null
                : (controller.callStarted.value)
                    // ? slideShow()
                    ? Stack(alignment: Alignment.bottomCenter, children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(0)),
                          child: Container(
                            decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                colors: [
                                  const Color(0xff2B25CC),
                                  const Color(0xffA6635B),
                                  const Color(0xff91596F),
                                  const Color(0xffB46A4D),
                                  const Color(0xffF18910),
                                  const Color(0xffA6635B),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            height: context.height / 6,
                          ),
                        ),
                        slideShow()
                        // _toolbar(),

                        // SlidingUpPanel(
                        //     minHeight: MediaQuery.of(context).size.height / 6,
                        //     color: Colors.amber,
                        //     isDraggable: true,
                        //     panel: MediaQuery.removePadding(
                        //         removeTop: true,
                        //         context: context,
                        //         child: ListView(
                        //           scrollDirection: Axis.vertical,
                        //           children: [
                        //             Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 _toolbar(),
                        //               ],
                        //             ),
                        //             SizedBox(
                        //               height: 20,
                        //             ),
                        //             SizedBox(
                        //               height: 20,
                        //             ),
                        //           ],
                        //         ))),
                      ])
                    : null),
      ),
    );
  }
}
