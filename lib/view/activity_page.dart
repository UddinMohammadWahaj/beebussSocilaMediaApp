import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Activity/activity_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/widgets/Notifications/follow_request_card.dart';
import 'package:bizbultest/widgets/Notifications/like_notification_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import '../../api/ApiRepo.dart' as ApiRepo;
import '../utilities/custom_icons.dart';
import '../utilities/loading_indicator.dart';
import '../widgets/Properbuz/utils/header_footer.dart';

class ActivityPage extends StatefulWidget {
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  ActivityPage({Key? key, this.changeColor, this.isChannelOpen, this.setNavBar})
      : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  // Activities activityList;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var areActivitiesLoaded = false.obs;
  var page = 1.obs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var ActivityNotifyList = <ActivityNotifyData>[].obs;

  Future<List<ActivityNotifyData?>?>? getNotifications() async {
    page.value = 1;
    ActivityNotifyList.value = [];
    areActivitiesLoaded.value = true;
    var response = await ApiRepo.postWithToken("api/notification_list.php",
        {"user_id": CurrentUser().currentUser.memberID, "page": page.value});
    areActivitiesLoaded.value = false;
    if (response!.success == 1 && response!.data['data'] != null) {
      response!.data['data'].forEach((element) {
        ActivityNotifyData objPropertyBuyingModel = new ActivityNotifyData();
        objPropertyBuyingModel = ActivityNotifyData.fromJson(element);
        ActivityNotifyList.add(objPropertyBuyingModel);
      });
    } else {
      ActivityNotifyList.value = [];
    }
    print("=========1111 ${ActivityNotifyList.length}");
  }

  Future<List<ActivityNotifyData?>?>? refrshNotifications() async {
    ActivityNotifyList.value = [];
    page.value = 1;
    areActivitiesLoaded.value = true;
    var response = await ApiRepo.postWithToken("api/notification_list.php",
        {"user_id": CurrentUser().currentUser.memberID, "page": page.value});
    areActivitiesLoaded.value = false;
    if (response!.success == 1 && response!.data['data'] != null) {
      response!.data['data'].forEach((element) {
        ActivityNotifyData objPropertyBuyingModel = new ActivityNotifyData();
        objPropertyBuyingModel = ActivityNotifyData.fromJson(element);
        ActivityNotifyList.add(objPropertyBuyingModel);
      });
    }
  }

  Future<List<ActivityNotifyData?>?>? loadMoreData() async {
    page.value++;

    var response = await ApiRepo.postWithToken("api/notification_list.php",
        {"user_id": CurrentUser().currentUser.memberID, "page": page.value});

    if (response!.success == 1 && response!.data['data'] != null) {
      response!.data['data'].forEach((element) {
        ActivityNotifyData objPropertyBuyingModel = new ActivityNotifyData();
        objPropertyBuyingModel = ActivityNotifyData.fromJson(element);
        ActivityNotifyList.add(objPropertyBuyingModel);
      });
    }

    refreshController.loadComplete();
  }

  Widget _placeHolderList() {
    return ListView.builder(
        itemCount: 25,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            leading: SkeletonAnimation(
              child: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
            title: SkeletonAnimation(
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                ),
                width: 100.0.w - 100,
                height: 10,
              ),
            ),
            subtitle: SkeletonAnimation(
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                ),
                width: 70.0.w - 100,
                height: 10,
              ),
            ),
            trailing: SkeletonAnimation(
              child: Container(
                height: 50,
                width: 50,
                color: Colors.grey.shade200,
              ),
            ),
          );
        });
  }

  Future<String> deleteRequest(String otherMemberId) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=delete_request&user_id=${CurrentUser().currentUser.memberID}&from_user_id=$otherMemberId");

    // var response = await http.get(url);.  var response =
    var response =
        await ApiRepo.postWithToken("api/follow_delete_request.php", {
      "user_id": {CurrentUser().currentUser.memberID},
      "from_user_id": otherMemberId,
    });

    if (response!.success == 1 && response!.data != null) {
      print(response!.data);
      getNotifications();
    }
    return "success";
  }

  Future<String> acceptRequest(String otherMemberId) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=accept_request&
    // =${CurrentUser().currentUser.memberID}&from_user_id=$otherMemberId");

    // var response = await http.get(url);

    // if (response!.statusCode == 200) {
    //   print(response!.body);
    var response =
        await ApiRepo.postWithToken("api/follow_accept_request.php", {
      "user_id": {CurrentUser().currentUser.memberID},
      "from_user_id": otherMemberId,
    });

    if (response!.success == 1 && response!.data != null) {
      setState(() {
        print(response!.data);

        getNotifications();
      });
    }
    return "success";
  }

  @override
  void initState() {
    getNotifications();
    // activityNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(
            "Activity",
          ),
          style: blackBold.copyWith(fontSize: 25),
        ),
      ),
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Obx(
          () => areActivitiesLoaded.isTrue
              ? _placeHolderList()
              : Container(
                  child: ActivityNotifyList.length == 0 ||
                          ActivityNotifyList == null
                      ? Center(child: Text("No Activity.!!"))
                      : SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: CustomHeader(
                            builder: (context, mode) {
                              return Container(
                                child: Center(child: loadingAnimation()),
                              );
                            },
                          ),
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;

                              if (mode == LoadStatus.idle) {
                                body = Text("");
                              } else if (mode == LoadStatus.loading) {
                                body = loadingAnimation();
                              } else if (mode == LoadStatus.failed) {
                                body = Container(
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                          color: Colors.black, width: 0.7),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(CustomIcons.reload),
                                    ));
                              } else if (mode == LoadStatus.canLoading) {
                                body = Text("");
                              } else {
                                body = Text(
                                  AppLocalizations.of("No more Data"),
                                );
                              }
                              return Container(
                                height: 55.0,
                                child: Center(child: body),
                              );
                            },
                          ),
                          controller: refreshController,
                          onRefresh: () => getNotifications(),
                          onLoading: () => loadMoreData(),
                          child: ListView.builder(
                              itemCount: ActivityNotifyList.length,
                              itemBuilder: (context, index) {
                                var notification = ActivityNotifyList[index];
                                return Container(
                                    child: notification.type ==
                                                "followRequest" ||
                                            notification.type == "Follow_req"
                                        ? FollowRequestNotificationCard(
                                            setNavBar: widget.setNavBar,
                                            isChannelOpen: widget.isChannelOpen,
                                            changeColor: widget.changeColor,
                                            delete: () {
                                              setState(() {
                                                deleteRequest(
                                                    notification.memberId!);

                                                ActivityNotifyList.removeAt(
                                                    index);
                                                ScaffoldMessenger.of(
                                                        _scaffoldKey
                                                            .currentState!
                                                            .context)
                                                    .showSnackBar(showSnackBar(
                                                  AppLocalizations.of(
                                                      'Notification Removed'),
                                                ));
                                              });
                                            },
                                            accept: () {
                                              setState(() {
                                                acceptRequest(
                                                    notification.memberId!);
                                                ScaffoldMessenger.of(
                                                        _scaffoldKey
                                                            .currentState!
                                                            .context)
                                                    .showSnackBar(showSnackBar(
                                                  AppLocalizations.of(
                                                      'Request Accepted'),
                                                ));
                                              });
                                            },
                                            activity: notification,
                                          )
                                        : LikeNotificationCard(
                                            setNavBar: widget.setNavBar,
                                            isChannelOpen: widget.isChannelOpen,
                                            changeColor: widget.changeColor,
                                            activity: notification,
                                          ));
                              })
                          // : _placeHolderList(),
                          // ),
                          ),
                ),
        ),
      ),
    );
  }
}
