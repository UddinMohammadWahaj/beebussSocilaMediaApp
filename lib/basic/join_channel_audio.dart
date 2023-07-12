import 'dart:async';
import 'dart:developer';
// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/config/agora.config.dart' as config;
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

/// JoinChannelAudio Example
class JoinChannelAudio extends StatefulWidget {
  final String? img;
  final String? oppositeMemberId;
  final bool? isFromHome;
  final bool? callFromButton;
  final String? name;
  final bool? isCallFromGroup;
  final String? token;

  const JoinChannelAudio({
    Key? key,
    this.img,
    this.oppositeMemberId,
    this.isFromHome = false,
    this.callFromButton = false,
    this.name = "",
    this.isCallFromGroup = false,
    this.token = "",
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudio> {
  late dynamic _engine;
  String channelId = config.channelId;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  // bool _enableInEarMonitoring = false;
  // double _recordingVolume = 0, _playbackVolume = 0, _inEarMonitoringVolume = 0;
  late TextEditingController _controller;

  String callTime = "";
  String callLength = "";

  late DateTime startTime;

  late AudioCache audioCache;
  late AudioPlayer instance;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: channelId);
    audioCache = AudioCache();
    instance = AudioPlayer();
    this._initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _engine.destroy();
    instance.dispose();
  }

  _initEngine() async {
    try {
      if (widget.callFromButton!) {
        final file = await audioCache.loadAsFile('tune/diallerTone.mp3');
        final bytes = await file.readAsBytes();
        await audioCache.playBytes(bytes, loop: true, volume: 0.1);
      }

      // _engine =
      //     await RtcEngine.createWithContext(RtcEngineContext(config.appId));
      // this._addListeners();

      // await _engine.enableAudio();
      // await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      // await _engine.setClientRole(ClientRole.Broadcaster);

      if (widget.callFromButton!) {
        setState(() {
          isJoined = true;
        });
        await _joinChannel();
      }
    } catch (E) {
      print(E);
      instance?.stop();
    } finally {}
  }

  _addListeners() {
    // _engine.setEventHandler(
    //   RtcEngineEventHandler(
    //     joinChannelSuccess: (channel, uid, elapsed) {
    //       log('joinChannelSuccess $channel $uid $elapsed');
    //       setState(() {
    //         isJoined = true;
    //       });
    //     },
    //     userJoined: (uid, elapsed) async {
    //       log('userJoined  $uid $elapsed');
    //       await instance.pause();
    //       startTimer();
    //       setState(() {
    //         print(uid);
    //       });
    //     },
    //     userOffline: (uid, reason) async {
    //       log('userOffline  $uid $reason');
    //       await instance.pause();
    //       setState(() {
    //         print(uid);
    //       });
    //       if (!widget.isCallFromGroup!) {
    //         await _leaveChannel();
    //       }
    //       // remoteUid.clear();
    //     },
    //     leaveChannel: (stats) async {
    //       await instance.pause();
    //       log('leaveChannel ${stats.toJson()}');
    //       if (!widget.isCallFromGroup!) {
    //         await _leaveChannel();
    //       }
    //       // await _engine.joinChannel(config.token, config.channelId, null, config.uid).catchError((err) {
    //       //   print('error ${err.toString()}');
    //       // });
    //     },
    //   ),
    // );
  }

  late Timer? _timer;
  int _start = 0;
  int min = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          min++;
          if (min > 59) {
            _start = _start + 1;
            min = 0;
          }
        });
      },
    );
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    try {
      // await audioCache.loadAsFile('tune/beep-01a.mp3');
      // final bytes = await file.readAsBytes();
      // audioCache.playBytes(bytes);

      await _engine
          .joinChannel(config.token, config.channelId, null, config.uid)
          .catchError((onError) async {
        print('error ${onError.toString()}');
        await _leaveChannel();
      });

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
    } catch (e) {
      print(e);
    } finally {
      await FlutterRingtonePlayer.stop();
      await Vibration.cancel();
      await instance.pause();
      instance?.stop();
    }
  }

  bool isSentCutNotification = false;

  Future sendPushMessage({bool isVideo = false}) async {
    await ChatApiCalls.sendFcmRequest(
        widget.name!, "cut+audio", "call", "otherMemberID", widget.token!, 0, 0,
        isVideo: isVideo);
    setState(() {
      isSentCutNotification = true;
    });
  }

  _leaveChannel() async {
    try {
      if (!isSentCutNotification) {
        await sendPushMessage(isVideo: false);

        var totalTime = DateTime.now().difference(startTime).inSeconds;

        int minutes = (totalTime / 60).truncate();
        callLength = (minutes % 60).toString().padLeft(2, '0');

        if (callLength == "00") {
          callLength = totalTime.toString();
        }

        var objAgoraCallDetail = await ApiProvider().agoraCallDetail(
            CurrentUser().currentUser.memberID!,
            widget.oppositeMemberId!,
            "Audio",
            callTime,
            callLength);

        if (objAgoraCallDetail != null &&
            objAgoraCallDetail.data != null &&
            objAgoraCallDetail.success == 1) {
          print(objAgoraCallDetail.success);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      await _engine.disableAudio();
      await _engine.leaveChannel();
      instance?.stop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            memberID: CurrentUser().currentUser.memberID!,
            logo: CurrentUser().currentUser.logo,
            country: CurrentUser().currentUser.country,
            currentMemberImage: CurrentUser().currentUser.image,
          ),
        ),
      );
    }
  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      log('setEnableSpeakerphone $err');
    });
  }

  // _switchEffect() async {
  //   if (playEffect) {
  //     _engine.stopEffect(1).then((value) {
  //       setState(() {
  //         playEffect = false;
  //       });
  //     }).catchError((err) {
  //       log('stopEffect $err');
  //     });
  //   } else {
  //     _engine
  //         .playEffect(
  //             1,
  //             await (_engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3")),
  //             -1,
  //             1,
  //             1,
  //             100,
  //             true)
  //         .then((value) {
  //       setState(() {
  //         playEffect = true;
  //       });
  //     }).catchError((err) {
  //       log('playEffect $err');
  //     });
  //   }
  // }

  // _onChangeInEarMonitoringVolume(double value) {
  //   setState(() {
  //     _inEarMonitoringVolume = value;
  //   });
  //   _engine.setInEarMonitoringVolume(value.toInt());
  // }

  // _toggleInEarMonitoring(value) {
  //   setState(() {
  //     _enableInEarMonitoring = value;
  //   });
  //   _engine.enableInEarMonitoring(value);
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 14, right: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    child: InkWell(
                      child: Icon(Icons.arrow_back_ios),
                      onTap: () async {
                        await instance.pause();
                        await _leaveChannel();
                        if (widget.isFromHome!) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                memberID: CurrentUser().currentUser.memberID!,
                                logo: CurrentUser().currentUser.logo,
                                country: CurrentUser().currentUser.country,
                                currentMemberImage:
                                    CurrentUser().currentUser.image,
                              ),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    height: AppBar().preferredSize.height,
                  ),
                  Expanded(child: SizedBox()),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.img!),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    !isJoined
                        ? Text(
                            "${widget.name} is calling...",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                          )
                        : Text(
                            "${widget.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                    SizedBox(
                      height: 8,
                    ),
                    isJoined
                        ? Text(
                            "$_start:$min",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      _switchMicrophone();
                    },
                    child: openMicrophone
                        ? Icon(
                            Icons.mic,
                            color: Colors.grey,
                            size: 30,
                          )
                        : Icon(
                            Icons.mic_off,
                            color: Colors.grey,
                            size: 30,
                          ),
                  ),
                  InkWell(
                    onTap: () {
                      _switchSpeakerphone();
                    },
                    child: enableSpeakerphone
                        ? Icon(
                            Icons.volume_up,
                            color: Colors.blue,
                            size: 30,
                          )
                        : Icon(
                            Icons.volume_up,
                            color: Colors.grey,
                            size: 30,
                          ),
                  ),

//                   InkWell(
//                       onTap: () {
// Navigator.of(context).push(MaterialPageRoute(builder: (context) => ,))

//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Card(
//                             elevation: 0,
//                             color: isJoined ? Colors.red : Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(40),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Icon(
//                                 Icons.phone,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),

                  InkWell(
                    onTap: () {
                      isJoined ? _leaveChannel() : _joinChannel();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 0,
                          color: isJoined ? Colors.red : Colors.blue,
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30 + MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        )
      ],
    );
  }
}
