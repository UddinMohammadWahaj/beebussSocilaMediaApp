import 'package:agora_uikit/agora_uikit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/AgoraCallDetailModel.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/playground/playgroundfcm.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:bizbultest/config/agora.config.dart' as config;

class PlayVcScreen extends StatefulWidget {
  final String oppositeMemberId;
  final bool isFromHome;
  final bool callFromButton;
  final String name;
  final String token;
  final String userImage;

  const PlayVcScreen({
    Key? key,
    required this.oppositeMemberId,
    this.isFromHome = false,
    this.callFromButton = false,
    this.name = "",
    this.token = "",
    this.userImage = "",
  }) : super(key: key);

  @override
  _PlayVcScreenState createState() => _PlayVcScreenState();
}

class _PlayVcScreenState extends State<PlayVcScreen> {
  late AudioCache audioCache;
  late AudioPlayer instance;
  bool isJoined = false;
  String callTime = "";
  String callLength = "";

  late DateTime startTime;
  late AgoraClient objAgoraClient;

  initEngine() async {
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
    } finally {
      if (widget.callFromButton) {
        setState(() {
          print("isjoined bia true");
          isJoined = true;
        });
      }
    }
  }

  @override
  void initState() {
    audioCache = AudioCache();
    instance = AudioPlayer();

    initEngine();
    super.initState();
  }

  @override
  void dispose() {
    print("dispose of agora called");
    super.dispose();
    instance.dispose();
    objAgoraClient.sessionController.dispose();
  }

  void stopFile() {
    instance?.stop();
  }

  Future<void> testsendPushMessage() async {
    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(CurrentUser().currentUser.memberID!);
    await playgroundsendFcmRequest(widget.name, "cut+video", "call",
        "otherMemberID", objUserDetailModel.firebaseToken!, 0, 0,
        isVideo: true);
    print("this is called");
  }

  Future sendPushMessage() async {
    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(widget.oppositeMemberId);
    await ChatApiCalls.sendFcmRequest(widget.name, "cut+video", "call",
        "otherMemberID", objUserDetailModel.firebaseToken!, 0, 0,
        isVideo: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !isJoined
            ? Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 14,
                    right: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        Icon(
                          Icons.lock,
                          size: 18,
                        ),
                        Text(
                          "End-to-end encrypted",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    !isJoined
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                widget.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        : SizedBox(),
                    Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            await FlutterRingtonePlayer.stop();
                            await Vibration.cancel();
                            setState(() {
                              isJoined = true;
                            });
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            print("end call called");
                            await FlutterRingtonePlayer.stop();
                            await Vibration.cancel();
                            await sendPushMessage();

                            if (widget.callFromButton) {
                              Navigator.pop(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    memberID:
                                        CurrentUser().currentUser.memberID,
                                    logo: CurrentUser().currentUser.logo,
                                    country: CurrentUser().currentUser.country,
                                    currentMemberImage:
                                        CurrentUser().currentUser.image,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 30 + MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  // AgoraVideoViewer(
                  //   client: agoraClient(),
                  //   showNumberOfUsers: true,
                  //   layoutType: Layout.floating,
                  //   showAVState: true,
                  //   disabledVideoWidget: Container(
                  //     color: Colors.pinkAccent,
                  //   ),
                  // ),
                  // AgoraVideoButtons(
                  //   client: agoraClient(),
                  //   disconnectButtonChild: InkWell(
                  //     onTap: () async {
                  //       print("the end is called");
                  //       // await objAgoraClient.sessionController.endCall();

                  //       await _stopFile();
                  //       await sendPushMessage();

                  //       //sendpushmessage
                  //       await addCallData();
                  //     },
                  //     child: CircleAvatar(
                  //       backgroundColor: Colors.red,
                  //       radius: 30,
                  //       child: Icon(
                  //         Icons.call,
                  //         color: Colors.white,
                  //         size: 24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }

  Future<void> _stopFile() async {
    await instance?.stop(); // stop the file like this
  }

  //Agora function

  // AgoraClient agoraClient() {
  //   objAgoraClient = new AgoraClient(
  //     agoraConnectionData: AgoraConnectionData(
  //         appId: "518ef511a4f344be87f4d71a94f05701 ",
  //         channelName: "beeuzee",
  //         tempToken:
  //             '006518ef511a4f344be87f4d71a94f05701IAAdJwLUYk84+fveEoojC2h8jKQblxj6Nou9wMg1IpvIFXtTe6gAAAAAEAD+bihbD8xBYQEAAQAMzEFh'),
  //     enabledPermission: [
  //       Permission.camera,
  //       Permission.microphone,
  //     ],
  //     agoraEventHandlers: AgoraEventHandlers(
  //       // onError: (error) {
  //       //   print(error);
  //       // },
  //       // activeSpeaker: (int uid) {},
  //       // joinChannelSuccess: (String channel, int uid, int elapsed) {
  //       //   print(uid);
  //       // },
  //       // leaveChannel: (RtcStats stats) async {
  //       //   print(stats.rxKBitRate);
  //       //   // await objAgoraClient.sessionController.endCall();
  //       //   _stopFile();
  //       // },
  //       // localAudioStateChanged: (AudioLocalState state, AudioLocalError error) {
  //       //   print(state);
  //       // },
  //       // localVideoStateChanged: (LocalVideoStreamState localVideoState,
  //       //     LocalVideoStreamError error) {
  //       //   print(localVideoState);
  //       // },
  //       // remoteAudioStateChanged: (int uid, AudioRemoteState state,
  //       //     AudioRemoteStateReason reason, int elapsed) {
  //       //   print(uid);
  //       // },
  //       // remoteVideoStateChanged: (int uid, VideoRemoteState state,
  //       //     VideoRemoteStateReason reason, int elapsed) {
  //       //   print(uid);
  //       // },
  //       // tokenPrivilegeWillExpire: (String token) {
  //       //   print(token);
  //       // },
  //       // userJoined: (int uid, int elapsed) {
  //       //   _stopFile();
  //       //   print(uid);
  //       // },
  //       // userOffline: (int uid, UserOfflineReason reason) async {
  //       //   await _stopFile();
  //       //   await addCallData();
  //       //   print(uid);
  //       //   print(reason);
  //       // },
  //     ),
  //   );

  //   return objAgoraClient;
  // }

  addCallData() async {
    startTime = DateTime.now();

    callTime = DateTime.now().year.toString() +
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

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await [Permission.microphone, Permission.camera].request();
      }

      var totalTime = DateTime.now().difference(startTime).inSeconds;

      int minutes = (totalTime / 60).truncate();
      callLength = (minutes % 60).toString().padLeft(2, '0');

      if (callLength == "00") {
        callLength = totalTime.toString();
      }

      AgoraCallDetail objAgoraCallDetail = await ApiProvider().agoraCallDetail(
          CurrentUser().currentUser.memberID!,
          widget.oppositeMemberId,
          "Video",
          callTime,
          callLength);

      if (objAgoraCallDetail != null &&
          objAgoraCallDetail.data != null &&
          objAgoraCallDetail.success == 1) {
        print(objAgoraCallDetail.success);
      }
    } catch (e) {
      print(e);
    } finally {
      await FlutterRingtonePlayer.stop();
      await Vibration.cancel();
      if (widget.callFromButton) {
        Navigator.pop(context);
      } else {
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
  }
}

class AgoraEventHandlers {}
