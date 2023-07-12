import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/current_user_followers_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/personal_blog_model.dart';
import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:bizbultest/services/MainVideo/main_video_api_calls.dart';
import 'package:bizbultest/settings_model.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/ApiRepo.dart' as ApiRepo;
import 'FeedAllApi/feed_controller.dart';
import 'current_user.dart';

class ProfileApiCalls {
  static HomepageRefreshState refresh = new HomepageRefreshState();
  static RefreshMainVideo refreshMainVideo = new RefreshMainVideo();

  static Future<AllFeeds> getPosts(
      BuildContext context, String currentId, String from) async {
    print("reach in the posts getting data sectionnn");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? postData = prefs.getString("profilePosts");

    try {

      // var response = await ApiRepo.postWithToken("api/member_post_data.php", {
      var response = await ApiRepo.postWithToken("api/newsfeed/userFeedList", {
        "user_id": CurrentUser().currentUser.memberID,
        "country": CurrentUser().currentUser.country,
        "current_user_id": currentId,
        "page": 1
        // "post_ids": ""
      });
      print("reach in the posts getting data sectionnn 12");

      if (response!.data['data'] != null &&
          response.data['status'] == 1) {
        print("reach in the posts getting data sectionnn 345");
        AllFeeds postsData = AllFeeds.fromJson(response.data['data']);
        // await Future.wait(postsData.feeds.map((e) => PreloadCached.cacheImage(context, e.thumbnailUrl.split("~~")[0]?.replaceAll(".mp4", ".jpg"))).toList());
        if (from == "appbar") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("profilePosts", jsonEncode(response.data['data']));
        }
        return postsData;
      } else {
        if (postData != null && from == "appbar") {
          AllFeeds postsData = AllFeeds.fromJson(jsonDecode(postData));
          // await Future.wait(postsData.feeds.map((e) => PreloadCached.cacheImage(context, e.postImgData.split("~~")[0])).toList());
          return postsData;
        } else {
          return AllFeeds([]);
        }
      }
    } on SocketException {
      print("socket exception");
      print(from);
      if (postData != null && from == "appbar") {
        print("found postssssss");
        AllFeeds postsData = AllFeeds.fromJson(jsonDecode(postData));
        // await Future.wait(postsData.feeds
        //     .map((e) =>
        //         PreloadCached.cacheImage(context, e.postImgData.split("~~")[0]))
        //     .toList());
        return postsData;
      } else {
        return AllFeeds([]);
      }
    }
  }

  static Future<AllFeeds> getPostsLocal(
      BuildContext context, String from) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? postData = prefs.getString("profilePosts");

    if (postData != null && from == "appbar") {
      AllFeeds postsData = AllFeeds.fromJson(jsonDecode(postData));
      //await Future.wait(postsData.feeds.map((e) => PreloadCached.cacheImage(context, e.postImgData.split("~~")[0])).toList());
      return postsData;
    } else {
      return AllFeeds([]);
    }
  }

  static Future<PersonalBlogs> getBlogs(int page, String currentId) async {
    // var response = await ApiRepo.postWithToken("api/member_blog_data.php", {
    var response = await ApiRepo.postWithToken("api/blog/userBlogList", {
      "user_id": currentId,
      // "profile_user_id": currentId,
      "current_user_id": currentId,
      "page": page,
    });

    if (response!.data['data'] != null &&
        response.data['status'] == 1) {
      PersonalBlogs blogsData = PersonalBlogs.fromJson(response.data['data']);
      return blogsData;
    } else {
      return PersonalBlogs([]);
    }
  }

  static Future<AllFeeds?> onLoadingPosts(
      AllFeeds postsList,
      BuildContext context,
      RefreshController _postRefreshController,
      String currentId,
      {page}) async {
    // int len = postsList.feeds.length;
    // String urlStr = "";
    // for (int i = 0; i < len; i++) {
    //   urlStr += postsList.feeds[i].postId;
    //   if (i != len - 1) {
    //     urlStr += ",";
    //   }
    // }
    // urlStr = postsList.feeds[i].postId;
    //   if (i != len  ) {
    //     urlStr = ",";
    //   }
    try {
      // var url = Uri.parse("https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php");

      // final response = await http.post(url, body: {
      //   "user_id": currentId,
      //   "current_user_id": currentId,
      //   "post_ids": urlStr,
      //   "action": "member_profile_post_data",
      //   "country": CurrentUser().currentUser.country,
      // });

      var response = await ApiRepo.postWithToken("api/member_post_data.php", {
        "user_id": CurrentUser().currentUser.memberID,
        "current_user_id": currentId,
        "page": page,
        "country": CurrentUser().currentUser.country,
      });
      // print("----response profile=${response!.data['data']}");
      if (response!.data != null &&
          response!.data['data'] != null &&
          response!.data['data'] != "") {
        AllFeeds feedData = AllFeeds.fromJson(response!.data['data']);
        await Future.wait(feedData.feeds
            .map((e) => PreloadCached.cacheImage(
                context, e.postImgData!.split("~~")[0]))
            .toList());
        // await Future.wait(feedData.feeds.map((e) {
        //   print("----thumb--- ${e.thumbnailUrl}");
        //   PreloadCached.cacheImage(context, e.postImgData.split("~~")[0]);
        // }).toList());
        _postRefreshController.loadComplete();
        return feedData;
      } else {
        _postRefreshController.loadComplete();
        return AllFeeds([]);
      }
    } on SocketException catch (e) {
      print("----error-- $e");
      Fluttertoast.showToast(
        msg: "Couldn't refresh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
    _postRefreshController.loadComplete();
// return AllFeeds([]);
  }

  static Future<Users> getFollowers(
      BuildContext context, String memberID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followers_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=$memberID&all_user_ids=");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/user/followingData", {
      "user_id": CurrentUser().currentUser.memberID,
      "profile_user_id": memberID,
      "all_user_ids": "",
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      Users followerData = Users.fromJson(response!.data['data']);
      await Future.wait(followerData.usersList
          .map((e) => PreloadCached.cacheImage(context, e.userImage!))
          .toList());
      return followerData;
    } else {
      return Users([]);
    }
  }

  static Future<Users> getFollowing(
      BuildContext context, String memberID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followings_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=$memberID&all_user_ids=");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/user/followersData", {
      "user_id": CurrentUser().currentUser.memberID,
      "profile_user_id": memberID,
      "all_user_ids": "",
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      Users followingData = Users.fromJson(response!.data['data']);
      await Future.wait(followingData.usersList
          .map((e) => PreloadCached.cacheImage(context, e.userImage!))
          .toList());
      return followingData;
    } else {
      return Users([]);
    }
  }

  static Future<Users?> onLoadingFollowers(
      Users followersList,
      BuildContext context,
      RefreshController _followersRefreshController,
      String memberID) async {
    int len = followersList.usersList.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += followersList.usersList[i].memberId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    print(urlStr);
    try {
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followers_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=$memberID&all_user_ids=$urlStr");

      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/user/followingData", {
        "user_id": CurrentUser().currentUser.memberID,
        "profile_user_id": memberID,
        "all_user_ids": urlStr,
      });

      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "" &&
          response!.data['data'] != "null") {
        Users followerData = Users.fromJson(response!.data['data']);
        await Future.wait(followerData.usersList
            .map((e) => PreloadCached.cacheImage(context, e.userImage!))
            .toList());
        _followersRefreshController.loadComplete();
        return followerData;
      } else {
        _followersRefreshController.loadComplete();
        return Users([]);
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _followersRefreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _followersRefreshController.loadComplete();
    return null;
  }

  static Future<Users?> onLoadingFollowing(
      Users followingList,
      BuildContext context,
      RefreshController _followingRefreshController,
      String memberID) async {
    int len = followingList.usersList.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += followingList.usersList[i].memberId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    try {
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followings_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=$memberID&all_user_ids=$urlStr");

      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/user/followersData", {
        "user_id": CurrentUser().currentUser.memberID,
        "profile_user_id": memberID,
        "all_user_ids": urlStr,
      });

      if (response!.success == 1) {
        Users followingData = Users.fromJson(response!.data['data']);
        await Future.wait(followingData.usersList
            .map((e) => PreloadCached.cacheImage(context, e.userImage!))
            .toList());
        _followingRefreshController.loadComplete();
        return followingData;
      } else {
        _followingRefreshController.loadComplete();
        return Users([]);
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
    _followingRefreshController.loadComplete();
    return null;
  }

  static Future<UserHighlightsList> getUserHighlights(
      String memberID, BuildContext context, String from) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? highlightData = prefs.getString("highlights");

    try {
      var response =
          await ApiRepo.postWithToken("api/storyDataDetailHighlight", {
        "user_id": memberID,
        "country": CurrentUser().currentUser.country,
      });


      if (response!.data['status'] == 1 &&
          response.data['data'] != null &&
          response.data['data'] != "" &&
          response.data['data'] != "null") {
        UserHighlightsList userHighlightData =
            UserHighlightsList.fromJson(response.data['data']);
        if (from == "appbar") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("highlights", jsonEncode(response.data['data']));
        }
        return userHighlightData;
      } else {
        if (highlightData != null && from == "appbar") {
          UserHighlightsList userHighlightData =
              UserHighlightsList.fromJson(jsonDecode(highlightData));
          await Future.wait(userHighlightData.highlights
              .map((e) => PreloadCached.cacheImage(
                  context, e.firstImageOrVideo!.replaceAll(".mp4", ".jpg")))
              .toList());
          return userHighlightData;
        } else {
          return UserHighlightsList([]);
        }
      }
    } on SocketException {
      if (highlightData != null && from == "appbar") {
        UserHighlightsList userHighlightData =
            UserHighlightsList.fromJson(jsonDecode(highlightData));
        await Future.wait(userHighlightData.highlights
            .map((e) => PreloadCached.cacheImage(
                context, e.firstImageOrVideo!.replaceAll(".mp4", ".jpg")))
            .toList());
        return userHighlightData;
      } else {
        return UserHighlightsList([]);
      }
    }
  }

  static Future<UserHighlightsList> getLocalHighlights(
      String from, BuildContext context) async {
    if (from == "appbar") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? highlightData = prefs.getString("highlights");

      if (highlightData != null) {
        UserHighlightsList userHighlightData =
            UserHighlightsList.fromJson(jsonDecode(highlightData));
        await Future.wait(userHighlightData.highlights
            .map((e) => PreloadCached.cacheImage(
                context, e.firstImageOrVideo!.replaceAll(".mp4", ".jpg")))
            .toList());
        return userHighlightData;
      } else {
        return UserHighlightsList([]);
      }
    } else {
      return UserHighlightsList([]);
    }
  }

  static Future<SettingsModel?> getSettingsCountries() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/localization.php?action=get_countries&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);
    print("country resp called");
    var response;
    try {
      print("country resp called inner");
      response = await ApiProvider().fireApiWithParams(
          'https://www.bebuzee.com/api/countries_list.php',
          params: {
            "user_id": CurrentUser().currentUser.memberID,
          }).then((value) => value);

      // ApiRepo.postWithToken("api/countries_list.php", {
      //   "user_id": CurrentUser().currentUser.memberID,
      // });
    } catch (e) {
      print("country resp error=$e");
    }
    if (response!.data['data'] != null && response!.data['data'] != "") {
      print('country resp= ${response!.data['data']}');
      SettingsModel countryData = SettingsModel.fromJson(response!.data);
      return countryData;
    } else {
      return null;
    }
  }

  static Future<void> changeCountry(String countryName) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/localization.php?action=change_member_country&user_id=${CurrentUser().currentUser.memberID}&country_name=$countryName");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_country_change.php", {
      "action": "change_member_country",
      "user_id": CurrentUser().currentUser.memberID,
      "country_name": countryName
    });

    if (response!.success == 1) {
      print("country inserted");
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("country", countryName);
      FeedController feedController = Get.put(FeedController());
      feedController.hideNavBar.value = true;
      refresh.updateRefresh(true);
      refreshMainVideo.updateRefresh(true);

      print(response!.data);
    }
  }
}
