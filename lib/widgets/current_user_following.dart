import 'dart:convert';

import 'package:bizbultest/models/current_user_followers_model.dart';
import 'package:bizbultest/models/current_user_followings_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class CurrentUserFollowingPage extends StatefulWidget {
  final CurrentUserFollowingsModel? followers;
  final VoidCallback? onTap;

  const CurrentUserFollowingPage({Key? key, this.followers, this.onTap})
      : super(key: key);

  @override
  _CurrentUserFollowingPageState createState() =>
      _CurrentUserFollowingPageState();
}

class _CurrentUserFollowingPageState extends State<CurrentUserFollowingPage> {
  Future<String> followUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        widget.followers!.followText = jsonDecode(response.body)['return_val'];
      });
    }

    return "success";
  }

  Future<String> unfollowUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      print("unfollowed");
      setState(() {
        widget.followers!.followText = "Follow";
      });
    }

    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.5.h),
      child: InkWell(
        onTap: widget.onTap ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 3.5.h,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.followers!.userImage!),
                  ),
                ),
                SizedBox(
                  width: 4.0.w,
                ),
                Container(
                  width: 30.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.followers!.shortcode!,
                        style: blackBold.copyWith(fontSize: 10.0.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.followers!.memberFirstname!,
                        style: TextStyle(fontSize: 9.0.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  child: ElevatedButton(
                    // padding: EdgeInsets.zero,
                    // color: primaryBlueColor,
                    // disabledColor: primaryBlueColor,
                    onPressed: () {
                      if (widget.followers!.followText == "Following") {
                        unfollowUser(widget.followers!.memberId!);
                      } else {
                        followUser(widget.followers!.memberId!);
                      }
                    },
                    child: Text(
                      widget.followers!.followText,
                      style: whiteBold.copyWith(fontSize: 9.0.sp),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
