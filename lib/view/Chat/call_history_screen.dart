import 'dart:math';

// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/basic/newVcScreen.dart';
import 'package:bizbultest/main.dart';
import 'package:bizbultest/models/CallHistoryModel.dart';
import 'package:bizbultest/models/deleteCallHistory.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/playground/PlayVideoCallScreen.dart';
import 'package:bizbultest/playground/src/pages/callpage.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/Chat/callInfo_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({Key? key}) : super(key: key);

  @override
  _CallHistoryScreenState createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  CallHistoryModel objCallHistoryModel = new CallHistoryModel();

  List<CallData> lstCallData = [];
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

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  @override
  void initState() {
    super.initState();
    getCallHistory();
  }

  getCallHistory() async {
    objCallHistoryModel =
        await ApiProvider().callHistory(CurrentUser().currentUser.memberID!);
    if (objCallHistoryModel != null && objCallHistoryModel.data != null) {}
    setState(() {});
  }

  DeleteCallHistoryModel objDeleteCallHistoryModel =
      new DeleteCallHistoryModel();

  deleteCallHistory(String id, String type) async {
    try {
      objDeleteCallHistoryModel =
          await ApiProvider().deletecallHistory(id, type);

      if (objDeleteCallHistoryModel != null &&
          objDeleteCallHistoryModel.success == 1) {
        print(objDeleteCallHistoryModel.success);
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return objCallHistoryModel != null && objCallHistoryModel.data != null
        ? ListView.builder(
            padding: EdgeInsets.only(
                top: 14,
                right: 14,
                left: 14,
                bottom: MediaQuery.of(context).padding.bottom + 50),
            itemCount: objCallHistoryModel.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    objCallHistoryModel.data![index].isselect =
                        !objCallHistoryModel.data![index].isselect!;
                  });
                },
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallInfoScreen(
                        lstDetails: objCallHistoryModel.data![index],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        objCallHistoryModel.data![index].receiverImage !=
                                    null &&
                                objCallHistoryModel
                                        .data![index].receiverImage !=
                                    ""
                            ? Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 23.0,
                                    backgroundImage: NetworkImage(
                                      objCallHistoryModel
                                          .data![index].receiverImage!,
                                    ),
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  objCallHistoryModel.data![index].isselect!
                                      ? Icon(
                                          Icons.check,
                                          size: 20,
                                        )
                                      : SizedBox()
                                ],
                              )
                            : CircleAvatar(
                                radius: 23.0,
                                backgroundColor: Colors.grey[350],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                // Text(
                                //   '${objCallHistoryModel.data[index].receiverName[0]}',
                                // ),
                              ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              objCallHistoryModel.data![index].receiverName!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
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
                                  width: 4,
                                ),
                                Text(
                                  objCallHistoryModel.data![index].callTime!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: SizedBox()),
                        objCallHistoryModel.data![index].callType!
                                    .toLowerCase() ==
                                "video"
                            ? IconButton(
                                icon: Icon(
                                  Icons.videocam,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  print("call history press");
                                  // await sendPushMessage(
                                  //     isVideo: true,
                                  //     opp: objCallHistoryModel
                                  //         .data[index].receiverId);
                                  print(
                                      "BEBUZEE START my if=${CurrentUser().currentUser.memberID}rec-${objCallHistoryModel.data![index].receiverId}");

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlayVideoCallScreen(
                                              name: objCallHistoryModel
                                                      .data![index]
                                                      .receiverName ??
                                                  "",
                                              oppositeMemberId:
                                                  objCallHistoryModel
                                                          .data![index]
                                                          .receiverId ??
                                                      "",
                                              userImage: objCallHistoryModel
                                                      .data![index]
                                                      .receiverImage ??
                                                  "",
                                              callType: CallType.video,
                                            )),
                                  );

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => CallPage(
                                  //         role: ClientRole.Broadcaster,
                                  //         channelName: 'beeuzee',

                                  //         isFromHome: false,
                                  //         callFromButton: true,
                                  //         callType: CallType.video,
                                  //         oppositeMemberId: CurrentUser()
                                  //             .currentUser
                                  //             .memberID,
                                  //         // objUserDetailModel.memberId,
                                  //         name: objCallHistoryModel
                                  //                 .data[index].receiverName ??
                                  //             "",
                                  //         token: "",

                                  //         userImage: objCallHistoryModel
                                  //                 .data[index].receiverImage ??
                                  //             "",
                                  //       ),
                                  //     ));
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.call),
                                onPressed: () async {
                                  // await sendPushMessage(
                                  //     isVideo: false,
                                  //     opp: objCallHistoryModel
                                  //         .data[index].receiverId);
                                  print(
                                      "BEBUZEE START my if=${CurrentUser().currentUser.memberID}rec-${objCallHistoryModel.data![index].receiverId}");

                                  Fluttertoast.showToast(
                                    msg: "BEBUZEE START",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.7),
                                    textColor: Colors.white,
                                    fontSize: 15.0,
                                  );

                                  await Future.delayed(Duration(seconds: 2));
                                  //NPcom
                                  // await AwesomeNotifications()
                                  //     .createNotification(
                                  //         content: NotificationContent(
                                  //           id: createUniqueId(),
                                  //           channelKey: 'basic_channel',
                                  //           title:
                                  //               '${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!',
                                  //           body:
                                  //               'Florist at 123 Main St. has 2 in stock.',
                                  //           notificationLayout:
                                  //               NotificationLayout.Default,
                                  //         ),
                                  //         actionButtons: [
                                  //       NotificationActionButton(
                                  //         key: "okay_btn",
                                  //         label: "okay",
                                  //       ),
                                  //       NotificationActionButton(
                                  //         key: "cancel_btn",
                                  //         label: "cancel",
                                  //       ),
                                  //     ]);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlayVideoCallScreen(
                                              name: objCallHistoryModel
                                                      .data![index]
                                                      .receiverName ??
                                                  "",
                                              oppositeMemberId:
                                                  objCallHistoryModel
                                                          .data![index]
                                                          .receiverId ??
                                                      "",
                                              userImage: objCallHistoryModel
                                                      .data![index]
                                                      .receiverImage ??
                                                  "",
                                              callType: CallType.audio,
                                            )),
                                  );
                                },
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        objCallHistoryModel.data![index].isselect!
                            ? InkWell(
                                onTap: () {
                                  // await deleteCallHistory(
                                  //   objCallHistoryModel.data[index].callerId,
                                  //   "Select",
                                  // );
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    )
                  ],
                ),
              );
            },
          )
        : SizedBox();
  }
}
