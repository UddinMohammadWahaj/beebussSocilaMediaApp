import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/CallHistoryModel.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/playground/PlayVideoCallScreen.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallInfoScreen extends StatefulWidget {
  final CallData? lstDetails;
  const CallInfoScreen({Key? key, this.lstDetails}) : super(key: key);

  @override
  _CallInfoScreenState createState() => _CallInfoScreenState();
}

class _CallInfoScreenState extends State<CallInfoScreen> {
  String img = "";
  String name = "";
  String status = "";
  String time = "";
  String length = "";

  bool isLoading = false;

  CallHistoryModel objCallHistoryModel = new CallHistoryModel();

  @override
  void initState() {
    img = widget.lstDetails!.receiverImage!;
    name = widget.lstDetails!.receiverName!;
    status = widget.lstDetails!.callType!;
    time = widget.lstDetails!.callTime!;
    length = widget.lstDetails!.callLength!;
    getUserCallDetail();
    super.initState();
  }

  Future sendPushMessage({bool isVideo = false, opp}) async {
    print("sent fcm bia");
    UserDetailModel objUserDetailModel = await ApiProvider().getUserDetail(opp);

    String aa = "";
    if (isVideo) {
      aa = CurrentUser().currentUser.memberID! + "+video";
    } else {
      aa = CurrentUser().currentUser.memberID! + "+audio";
    }
    await ChatApiCalls.sendFcmRequest(CurrentUser().currentUser.fullName!, aa,
        "call", "otherMemberID", objUserDetailModel.firebaseToken!, 0, 0,
        isVideo: isVideo);
  }

  getUserCallDetail() async {
    try {
      objCallHistoryModel = await ApiProvider().callDetail(
        widget.lstDetails!.callerId!,
        widget.lstDetails!.receiverId!,
      );
    } catch (e) {
      print(e);
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text("Call Info"),
        actions: [
          Icon(Icons.message),
          SizedBox(
            width: 15,
          ),
          Icon(Icons.more_vert)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                img != null && img != ""
                    ? CircleAvatar(
                        radius: 23.0,
                        backgroundImage: NetworkImage(
                          img,
                        ),
                        backgroundColor: Colors.grey[300],
                      )
                    : CircleAvatar(
                        radius: 23.0,
                        backgroundColor: Colors.grey[350],
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                SizedBox(
                  width: 8,
                ),
                Text(name ?? ""),
                Expanded(child: SizedBox()),
                InkWell(
                  onTap: () async {
                    print(
                        "from onclick ${await SharedPreferences.getInstance().then((value) => value.getString('notification'))}");
                    print("call history press");
                    await sendPushMessage(
                        isVideo: false, opp: widget.lstDetails!.receiverId);
                    print(
                        "BEBUZEE START my if=${CurrentUser().currentUser.memberID}rec-${widget.lstDetails!.receiverId}");

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayVideoCallScreen(
                                name: widget.lstDetails!.receiverName ?? "",
                                oppositeMemberId:
                                    widget.lstDetails!.receiverId ?? "",
                                userImage:
                                    widget.lstDetails!.receiverImage ?? "",
                                callType: CallType.audio,
                              )),
                    );
                    // await sendPushMessage(isVideo: false);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => JoinChannelAudio(
                    //       img: widget.image,
                    //       isFromHome: false,
                    //       callFromButton: true,
                    //       token: widget.token,
                    //       name: widget.name,
                    //       oppositeMemberId: widget.memberID,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Icon(Icons.call),
                ),
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  child: Icon(Icons.videocam),
                  onTap: () async {
                    print("call history video call");
                    await sendPushMessage(
                        isVideo: true, opp: widget.lstDetails!.receiverId);
                    print(
                        "BEBUZEE START my if=${CurrentUser().currentUser.memberID}rec-${widget.lstDetails!.receiverId}");

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayVideoCallScreen(
                                name: widget.lstDetails!.receiverName ?? "",
                                oppositeMemberId:
                                    widget.lstDetails!.receiverId ?? "",
                                userImage:
                                    widget.lstDetails!.receiverImage ?? "",
                                callType: CallType.video,
                              )),
                    );
                  },
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),

            objCallHistoryModel != null && objCallHistoryModel.data != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: objCallHistoryModel.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                objCallHistoryModel.data![index].callflag == 1
                                    ? Icon(
                                        Icons.north_east,
                                        color: Colors.green,
                                        size: 16,
                                      )
                                    : objCallHistoryModel
                                                .data![index].callflag ==
                                            11
                                        ? Icon(
                                            Icons.north_east,
                                            color: Colors.green,
                                            size: 16,
                                          )
                                        : objCallHistoryModel
                                                    .data![index].callflag ==
                                                2
                                            ? Icon(
                                                Icons.south_west,
                                                color: Colors.green,
                                                size: 16,
                                              )
                                            : Icon(
                                                Icons.south_west,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      objCallHistoryModel
                                                  .data![index].callflag ==
                                              11
                                          ? "Outgoing"
                                          : objCallHistoryModel
                                                      .data![index].callflag ==
                                                  2
                                              ? "Incoming"
                                              : objCallHistoryModel.data![index]
                                                          .callflag ==
                                                      1
                                                  ? "Missed"
                                                  : "Missed",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      objCallHistoryModel
                                          .data![index].callTime!,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  "0:" +
                                      objCallHistoryModel
                                          .data![index].callLength!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : SizedBox(),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.arrow_back,
            //       color: Colors.green,
            //     ),
            //     SizedBox(
            //       width: 20,
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           status,
            //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //         ),
            //         Text(time),
            //       ],
            //     ),
            //     Expanded(child: SizedBox()),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text(
            //           length,
            //           style: TextStyle(),
            //         ),
            //         Text("1.1 MB"),
            //       ],
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

// Future sendPushMessage({bool isVideo = false}) async {
//   String aa = "";
//   if (isVideo) {
//     aa = widget.memberID + "+video";
//   } else {
//     aa = widget.memberID + "+audio";
//   }
//   await ChatApiCalls.sendFcmRequest(widget.name, aa, "call", "otherMemberID", widget.token, 0, 0, isVideo: isVideo);
// }
}
