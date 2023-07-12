// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/basic/newVcScreen.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/playground/src/pages/callpage.dart';
import 'package:bizbultest/playground/testapicall.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/tokengeneartor/generatetoken.dart';
import 'package:flutter/material.dart';

class PlayVideoCallScreen extends StatefulWidget {
  final oppositeMemberId;
  final name;
  final userImage;
  final CallType callType;
  final usertok;

  PlayVideoCallScreen(
      {this.oppositeMemberId,
      this.name,
      this.userImage,
      required this.callType,
      this.usertok});

  @override
  _PlayVideoCallScreenState createState() => _PlayVideoCallScreenState();
}

class _PlayVideoCallScreenState extends State<PlayVideoCallScreen> {
  Future sendPushMessage({bool isVideo = false, token, channelName}) async {
    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(widget.oppositeMemberId);
    print('magia $token');
    String aa = "";
    if (isVideo) {
      aa = CurrentUser().currentUser.memberID! +
          "+video+token=$token+channelName=$channelName";
    } else {
      aa = CurrentUser().currentUser.memberID! +
          "+audio+token=$token+channelName=$channelName";
    }

    /*Owner created Room for join user in call */
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

    // await ApiProvider.sendRoomCallingInfo(CurrentUser().currentUser.memberID,
    //    widget.oppositeMemberId, channelName, 0,widget.callType == CallType.video ? "Video" : "Audio",
    //    callTime,
    //    '0:0:0');

    await ChatApiCalls.sendFcmRequest(CurrentUser().currentUser.fullName!, aa,
        "call", "otherMemberID", objUserDetailModel.firebaseToken!, 0, 0,
        isVideo: isVideo);
  }

  Future<Map<String, dynamic>> getToken() async {
    print("current id=${CurrentUser().currentUser.memberID}");

    var token = new GenerateToken(
        memberId: CurrentUser().currentUser.memberID,
        channelName:
            '2${CurrentUser().currentUser.memberID}${widget.oppositeMemberId}');

    var resp = await token.responseAgora();
    print('response is${resp}');
    await sendPushMessage(
        isVideo: (widget.callType == CallType.video) ? true : false,
        token: resp['token'],
        channelName: resp['channelName']);
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: getToken(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return CallPage(
                  callFromMe: true,
                  channelName: snapshot.data!['channelName'],
                  role: '',
                  oppositeMemberId: widget.oppositeMemberId,
                  callType: widget.callType,
                  isFromHome: false,
                  callFromButton: true,
                  name: widget.name ?? "",
                  token: snapshot.data!['token'],
                  userImage: widget.userImage ?? "",
                  appID: snapshot.data!['appID']);

              // return CallPage(
              //     channelName:
              //         '${CurrentUser().currentUser.memberID}${widget.oppositeMemberId}',
              //     role: ClientRole.Broadcaster,
              //     oppositeMemberId: widget.oppositeMemberId,
              //     isFromHome: false,
              //     callFromButton: true,
              //     name: widget.name ?? "",
              //     token: snapshot.data['token'],
              //     userImage: widget.userImage ?? "",
              //     appID: snapshot.data['appID']);

              //changed this
              // return VideoCallScreen(
              //   isFromHome: true,
              //   oppositeMemberId: widget.oppositeMemberId,
              //   name: widget.name ?? "",
              //   token: snapshot.data['token'],
              //   userImage: widget.userImage ?? "",
              // );
            } else
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.indigo,
              ));
          },
        ),
      ),
    );
  }
}
