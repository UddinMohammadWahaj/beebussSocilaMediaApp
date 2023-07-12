import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/feeds_likes_user_model.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../api/ApiRepo.dart' as ApiRepo;
import '../current_user.dart';

class FeedLikeApiCalls {
  Future<LikedUsers> getUsers(
      String search, String postID, BuildContext context,
      {postType: " "}) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_like_list.php?action=get_all_likes_members&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&all_members_data=&keyword=$search");
    var url =
        "https://www.bebuzee.com/api/all_likes_members_data.php?action=get_all_likes_members&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&all_members_data=&keyword=$search&post_type=$postType";
    print(url);
    var response = await ApiProvider().fireApi(url);
    try {
      if (response.statusCode == 200) {
        print('get users like ${response.data}');
        LikedUsers userData = LikedUsers.fromJson(response.data['data']);
        await Future.wait(userData.users
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());

        return userData;
      } else {
        return LikedUsers([]);
      }
    } catch (e) {
      return LikedUsers([]);
    }
  }

  static Future<LikedUsers?> onLoading(LikedUsers likedUsers,
      BuildContext context, RefreshController _refreshController, String postID,
      {String postType = ""}) async {
    print("on loading");
    int len = likedUsers.users.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += likedUsers.users[i].memberId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    print(urlStr);
    try {
      var url =
          "https://www.bebuzee.com/api/all_likes_members_data.php?action=get_all_likes_members&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&all_members_data=$urlStr&keyword=&post_type=$postType";

      var response = await ApiProvider().fireApi(url);

      if (response.statusCode == 200) {
        LikedUsers userData = LikedUsers.fromJson(response.data['data']);
        await Future.wait(userData.users
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());
        _refreshController.loadComplete();
        return userData;
      } else {
        _refreshController.loadComplete();
        return null;
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh feed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _refreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _refreshController.loadComplete();
    return null;
  }

  static Future<int> memberfollowunfollow(
      String unfollowerID, followStatus) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_follow_unfollow.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": unfollowerID,
      "follow_status": followStatus,
    });

    print("memberfollowunfollow response =${response!.data}");

    return response.data['data']['follow_status'];
  }

  static Future<String> followUser(String otherMemberId, int index) async {
    var url =
        "https://www.bebuzee.com/api/member_follow1.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId";

    var response = await ApiProvider().fireApi(url);
    print("called");
    if (response.statusCode == 200) {
      print(response.data);
    }
    return "success";
  }

  static Future<String> cancelRequest(String otherMemberId, int index) async {
    var url =
        "https://www.bebuzee.com/api/member_cancel_follow1.php?action=cancel_follow_request&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId";

    var response = await ApiProvider().fireApi(url);

    if (response.statusCode == 200) {
      print(response.data);
    }
    return "success";
  }

  static Future<String> unfollow(String unfollowerID, int index) async {
    var url =
        "https://www.bebuzee.com/api/member_unfollow1.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID";

    var response = await ApiProvider().fireApi(url);

    if (response.statusCode == 200) {
      print('unfollow stat=${response.data}');
    }

    return "success";
  }

  static Future<String> checkFollowStatus(String memberID) async {
    var url =
        "https://www.bebuzee.com/api/member_follow_check.php?action=check_user_to_follow&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$memberID";

    var response = await ApiProvider().fireApi(url);

    if (response.statusCode == 200) {
      String followStatus = response.data['message'];
      return followStatus;
    } else {
      return "";
    }
  }

  Future<void> newcheckFollowStatus(String memberID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=check_user_to_follow&user_id=${CurrentUser().currentUser.memberID}&user_id_to=${widget.memberID}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_follow_check_status.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": memberID,
    });

    if (response!.success == 1) {
      print(response.data['data']);

      return response.data['data']['follow_status'];
    }
  }

  Future<List<String>> likeUnlike(String postType, String postID) async {
    print("LikeUnlike");
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=post_like_data&user_id=${CurrentUser().currentUser.memberID}&post_type=$postType&post_id=$postID");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      String postLikeIcon = jsonDecode(response.body)['image_data'];
      String postTotalLikes = jsonDecode(response.body)['total_likes'];
      return [postLikeIcon, postTotalLikes];
    } else {
      return ["", ""];
    }
  }
}
