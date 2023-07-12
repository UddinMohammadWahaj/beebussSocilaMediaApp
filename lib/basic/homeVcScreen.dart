import 'package:agora_uikit/agora_uikit.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/main.dart';
import 'package:bizbultest/models/AgoraCallDetailModel.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/playground/playgroundfcm.dart';
import 'package:bizbultest/playground/src/pages/callpage.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/playground/utils/settings.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:bizbultest/config/agora.config.dart' as config;

class HomeVideoCallScreen extends StatefulWidget {
  final String oppositeMemberId;
  final bool isFromHome;
  final bool callFromButton;
  final String name;
  final String token;
  final String userImage;
  final CallType callType;
  final String channelName;
  final bool frommain;

  const HomeVideoCallScreen(
      {Key? key,
      this.frommain = false,
      required this.oppositeMemberId,
      this.isFromHome = false,
      this.callFromButton = false,
      this.name = "",
      this.token = "",
      this.userImage = "",
      this.channelName = "",
      this.callType = CallType.video})
      : super(key: key);

  @override
  _HomeVideoCallScreenState createState() => _HomeVideoCallScreenState();
}

class _HomeVideoCallScreenState extends State<HomeVideoCallScreen> {
  late AudioCache audioCache;
  late AudioPlayer instance;

  bool isJoined = false;

  String callTime = "";
  String callLength = "";

  late DateTime startTime;

  late AgoraClient objAgoraClient;

  @override
  void initState() {
    print("dudhara token video call screen ${widget.token} ");
    audioCache = AudioCache();
    instance = AudioPlayer();
    initEngine();
    super.initState();
  }

  initEngine() async {
    await [Permission.microphone, Permission.camera].request();
    // await flutterLocalNotificationsPlugin.cancelAll();
    try {
      if (widget.callFromButton) {
        final file = await audioCache.loadAsFile('tune/diallerTone.mp3');
        final bytes = await file.readAsBytes();
        instance = await audioCache.playBytes(bytes, loop: true, volume: 0.1);
        //added this new
        // await testsendPushMessage();
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  void dispose() async {
    print("dispose of agora called");

    super.dispose();

    await sendPushMessage();
    // objAgoraClient.sessionController.dispose();
  }

  void stopFile() {
    instance?.stop();
  }

  Future sendPushMessage() async {
    print("bia nia");
    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(widget.oppositeMemberId);
    await ChatApiCalls.sendFcmRequest(widget.name, "cut+videobia", "call",
        "otherMemberID", objUserDetailModel.firebaseToken!, 0, 0,
        isVideo: true);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: CallPage(
              // callFromMe: true,
              channelName: widget.channelName,
              role: ' ClientRole.Audience',
              oppositeMemberId: widget.oppositeMemberId,
              isFromHome: true,
              callFromButton: false,
              callType: widget.callType,
              name: widget.name ?? "",
              token: widget.token,
              userImage: widget.userImage ?? "",
              appID: APP_ID),
        ),
      ),
    );
  }
}
