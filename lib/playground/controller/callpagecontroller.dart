import 'dart:async';

// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:get/get.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';

class CallPageController extends GetxController {
  final hasToggle = false.obs;
  final isSpeakerOn = false.obs;
  final callStarted = false.obs;
  final isMute = false.obs;
  final seconds = 0.obs;
  final minutes = 0.obs;
  final hours = 0.obs;
  final videocam = true.obs;
  final List addedcalllist = [].obs;
  final isPanelOpened = false.obs;
  final Widget body = SizedBox(
    height: 0,
  );
  late Timer timer;
  bool addUser(userid) {
    if (addedcalllist.isEmpty) {
      addedcalllist.add(userid);
    } else
      for (int i = 0; i < addedcalllist.length; i++) {
        print("bia ${addedcalllist[i].fromuserid} == ${userid.fromuserid} ");
        if (addedcalllist[i].fromuserid == userid.fromuserid) return false;
        if (i == addedcalllist.length - 1) {
          addedcalllist.add(userid);
        }
      }
    return true;
  }

  togglevideocam() {
    videocam.value = !videocam.value;
  }

  toggle() {
    return hasToggle.value = !hasToggle.value;
  }

  void callStart() {
    callStarted.value = true;
  }

  void startPanel() async {
    isPanelOpened.value = true;
  }

  void closePanel() {
    isPanelOpened.value = false;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds.value = seconds.value + 1;
            if (seconds > 59) {
              minutes.value += 1;
              seconds.value = 0;
              if (minutes > 59) {
                hours.value += 1;
                minutes.value = 0;
              }
            }
          }
        }
      },
    );
  }

  toggleSpeaker() {
    return isSpeakerOn.value = !isSpeakerOn.value;
  }

  toggleMute() {
    isMute.value = !isMute.value;
  }
}
