import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Activity/activity_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiRepo.dart' as ApiRepo;

class FollowRequestNotificationCard extends StatefulWidget {
  final ActivityNotifyData? activity;
  final VoidCallback? delete;
  final VoidCallback? accept;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  const FollowRequestNotificationCard(
      {Key? key,
      this.activity,
      this.delete,
      this.accept,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  _FollowRequestNotificationCardState createState() =>
      _FollowRequestNotificationCardState();
}

class _FollowRequestNotificationCardState
    extends State<FollowRequestNotificationCard> {
  Future<String> followUser(String otherMemberId) async {
    setState(() {
      widget.activity!.followStatus = 1;
    });

    // var response = await http.get(Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId"));
    var response = await ApiRepo.postWithToken("api/follow_user.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": otherMemberId,
    });
    print(response!.data);
    if (response!.success == 1) {
      print("followUser");
    }
    return "success";
  }

  Future<String> cancelRequest(String otherMemberId) async {
    setState(() {
      widget.activity!.followStatus = 0;
    });
    // var response = await http.get(Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=cancel_follow_request&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId"));
    var response =
        await ApiRepo.postWithToken("api/cancel_follow_request.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": otherMemberId,
    });
    print(response!.data['data']);
    if (response!.success == 1) {
      print("cancelRequest");
      print(response!.data['data']);
      setState(() {
        widget.activity!.followStatus = response.data['data']['return_val'];
      });
    }
    return "success";
  }

  Future<String> unfollow(String unfollowerID) async {
    print("unfollow");
    setState(() {
      widget.activity!.followStatus = 0;
    });
    // var response = await http.get(Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID"));
    var response = await ApiRepo.postWithToken("api/unfollow_user.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": unfollowerID,
    });
    if (response!.success == 1) {
      print(response!.data['data']);
      print("unfollow");
    }

    return "success";
  }

  Future<String> acceptRequest(String otherMemberId) async {
    // setState(() {
    //   widget.activity.followStatus = 0;
    // });
    // var response = await http.get(Uri.parse(
    //   "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=accept_request&user_id=${CurrentUser().currentUser.memberID}&from_user_id=$otherMemberId"));
    var response = await ApiRepo.postWithToken("api/accept_request.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "from_user_id": otherMemberId,
    });
    print("-----123 ${response!.data['data']}");
    if (response!.success == 1 && response.data != null) {
      setState(() {
        widget.activity!.followStatus = 4;
      });
      print(response.data['data']);
    }
    return "success";
  }

  String followStatus() {
    int val = widget.activity!.followStatus!;
    if (val == 1) {
      return "Following";
    } else if (val == 0) {
      return "Follow";
    } else if (val == 4) {
      return "Followed";
    } else {
      return "Requested";
    }
  }

  // String followStatus2() {
  //   int val = widget.activity.followStatus;
  //   if (val == 1) {
  //     return "Following";
  //   } else if (val == 0 || val == 2) {
  //     return "Follow";
  //   } else {
  //     return "";
  //   }
  // }

  Widget _actionButton() {
    return GestureDetector(
      onTap: () {
        if (widget.activity!.followStatus == 0) {
          followUser(widget.activity!.memberId!);
        } else if (widget.activity!.followStatus == 1) {
          unfollow(widget.activity!.memberId!);
          // acceptRequest(widget.activity.memberId);
        } else {
          cancelRequest(widget.activity!.memberId!);
        }
      },
      child: Container(
        width: 80,
        decoration: new BoxDecoration(
          color: primaryBlueColor,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            // prvtval == 1 ?
            followStatus(),
            // : followStatus2(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _acceptStatusButton(VoidCallback onTap, String text, Color buttonColor,
      Color textColor, BoxBorder? border) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 60,
        decoration: new BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          shape: BoxShape.rectangle,
          border: border,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        onTap: () {
          setState(() {
            OtherUser().otherUser.memberID = widget.activity!.memberId!;
            OtherUser().otherUser.shortcode = widget.activity!.fullName!;
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePageMain(
                        setNavBar: widget.setNavBar!,
                        isChannelOpen: widget.isChannelOpen!,
                        changeColor: widget.changeColor!,
                        otherMemberID: widget.activity!.memberId,
                      )));
        },
        leading: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(widget.activity!.profile!),
          ),
        ),
        title: RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: <TextSpan>[
              TextSpan(
                  text: widget.activity!.shortcode,
                  style: blackBold.copyWith(fontSize: 15)),
              TextSpan(text: widget.activity!.title),
              TextSpan(
                  text: widget.activity!.timeStamp!.replaceAll(" ", ""),
                  style: greyNormal.copyWith(fontSize: 14)),
            ])),
        trailing: widget.activity!.followStatus == 3
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _acceptStatusButton(() {
                    acceptRequest(widget.activity!.memberId!);
                    setState(() {
                      widget.activity!.followStatus = 4;
                    });
                  },
                      AppLocalizations.of(
                        "Accept",
                      ),
                      primaryBlueColor,
                      Colors.white,
                      null),
                  _acceptStatusButton(
                    widget.delete!,
                    AppLocalizations.of(
                      "Delete",
                    ),
                    Colors.white,
                    Colors.black,
                    new Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ],
              )
            : _actionButton());
  }
}
