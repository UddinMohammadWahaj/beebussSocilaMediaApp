import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../view/profile_page_main.dart';

class VideoUserCard extends StatefulWidget {
  final String? userImage;
  final String? username;
  var followStatus;
  final String? userID;
  Function? setNavBar;
  Function? changeColor;
  String? shortcode;

  VideoUserCard(
      {Key? key,
      this.userImage,
      this.username,
      this.followStatus,
      this.userID,
      this.setNavBar,
      this.shortcode,
      this.changeColor})
      : super(key: key);

  @override
  _VideoUserCardState createState() => _VideoUserCardState();
}

class _VideoUserCardState extends State<VideoUserCard> {
  var followStatus;

  Future<void> checkFollowStatus() async {
    var url =
        "https://www.bebuzee.com/api/member_follow_check_status.php?action=check_user_to_follow&user_id=${CurrentUser().currentUser.memberID}&user_id_to=${widget.userID}";
    var newurl =
        "https://www.bebuzee.com/api/member_follow_request.php?user_id=${CurrentUser().currentUser.memberID}&user_id_to=${widget.userID}";
    var response = await ApiProvider().fireApi(url);
    print("check follow status response=${response.data}");
    if (response.statusCode == 200) {
      print(response.data);
      if (mounted) {
        setState(() {
          followStatus = response.data['data']['follow_status'];
        });
      }
    }
  }

  Future<String> followUser(String otherMemberId) async {
    var url =
        "https://www.bebuzee.com/api/member_follow.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId";
    var newurl =
        "https://www.bebuzee.com/api/member_follow_unfollow.php?user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId&status=$followStatus";
    print("follow user response url=$newurl");
    var response = await ApiProvider().fireApi(newurl);

    print('follow user response=${response.data}');

    if (response.statusCode == 200) {
      setState(() {
        followStatus = response.data['data']['follow_status'];
      });
    }

    return "success";
  }

  Future<String> unfollowUser(String otherMemberId) async {
    var url =
        "https://www.bebuzee.com/api/member_follow_unfollow.php?user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId&status=$followStatus";

    var response = await ApiProvider().fireApi(url);

    print(response.data);

    if (response.statusCode == 200) {
      print("unfollowed");
      setState(() {
        followStatus = response.data['data']['follow_status'];
      });
    }

    return "success";
  }

  @override
  void initState() {
    checkFollowStatus();
    setState(() {
      followStatus = widget.followStatus;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w),
        child: Row(
          children: [
            Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      OtherUser().otherUser.memberID = widget.userID!;
                      OtherUser().otherUser.shortcode = widget.shortcode!;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                    body: ProfilePageMain(
                                  from: "feed",
                                  // setNavBar: widget.setNavBar,
                                  // profileOpen: widget.profileOpen,
                                  // isChannelOpen: widget.isChannelOpen,
                                  // changeColor: widget.changeColor,

                                  otherMemberID: widget.userID!,
                                ))));
                  },
                  child: CircleAvatar(
                    radius: 3.0.h,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.userImage!),
                  ),
                )),
            Flexible(
              child: TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.grey.withOpacity(0.3))),
                // splashColor: Colors.grey.withOpacity(0.3),
                onPressed: () {
                  if (followStatus == 1) {
                    showModalBottomSheet(
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        //isScrollControlled:true,
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            child: Wrap(
                              children: [
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0.h),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 4.0.h,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              NetworkImage(widget.userImage!),
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    unfollowUser(widget.userID!);
                                    Navigator.pop(context);
                                  },
                                  child: ListTile(
                                    title: Text(
                                      AppLocalizations.of("Unfollow") +
                                          " " +
                                          widget.username!,
                                      style: whiteNormal.copyWith(
                                          fontSize: 12.0.sp),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    AppLocalizations.of(
                                      "Cancel",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 12.0.sp),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    followUser(widget.userID!);
                  }
                },
                child: Container(
                  width: 50.0.w,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username!,
                        style: whiteBold.copyWith(fontSize: 9.0.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Container(
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            shape: BoxShape.rectangle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3.h, horizontal: 3.0.w),
                            child: Text(
                              followStatus == 0
                                  ? "Follow"
                                  : followStatus == 1
                                      ? "Following"
                                      : "Requested",
                              style: whiteBold.copyWith(fontSize: 9.0.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
