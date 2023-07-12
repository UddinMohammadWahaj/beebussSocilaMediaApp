import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/discover_hashtags.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/FeedAllApi/main_feeds_page_api_calls.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../current_user.dart';

class DiscoverApiCalls {
  static Future<AllFeeds> getPosts(String tag, BuildContext context) async {
    print("this has called by bia");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/image/list?user_id=${CurrentUser().currentUser.memberID!}&post_id=&country=${CurrentUser().currentUser.country}&page=1');
    print("discove bia url=${newurl}");
    // var newurl = Uri.parse(
    //     'https://www.bebuzee.com/api/new_feed_data.php?user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&hash_tag=$tag');

    var client = Dio();
    String? token = await ApiProvider().getTheToken();
    return await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      print("discover people ${value.data}");
      if (value.statusCode == 200) {
        AllFeeds postsData = AllFeeds.fromJson(value.data['data']);
        await Future.wait(postsData.feeds
            .map((e) => PreloadCached.cacheImage(
                context, e.postImgData!.split("~~")[0]))
            .toList());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("discover_main", jsonEncode(value.data['data']));
        // print("${prefs.get(key)}")
        return postsData;
      } else {
        return AllFeeds([]);
      }
    });
  }

  static Future<AllFeeds> getPostsSearch(
      String postid, BuildContext context) async {
    print("this has called by bia");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/image/list?user_id=${CurrentUser().currentUser.memberID!}&post_id=&country=${CurrentUser().currentUser.country}&page=1&from_post_id=${postid}');
    print("discove bia url=${newurl}");
    // var newurl = Uri.parse(
    //     'https://www.bebuzee.com/api/new_feed_data.php?user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&hash_tag=$tag');

    var client = Dio();
    String? token = await ApiProvider().getTheToken();
    return await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      print("discover people ${value.data}");
      if (value.statusCode == 200) {
        AllFeeds postsData = AllFeeds.fromJson(value.data['data']);
        await Future.wait(postsData.feeds
            .map((e) => PreloadCached.cacheImage(
                context, e.postImgData!.split("~~")[0]))
            .toList());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("discover_main", jsonEncode(value.data['data']));
        // print("${prefs.get(key)}")
        return postsData;
      } else {
        return AllFeeds([]);
      }
    });
  }

  static Future<List<NewsFeedModel>> getPostsFromTag(
      String tag, BuildContext context) async {
    tag = tag.substring(1);
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/image/hastagList?action=hash_tag&user_id=${CurrentUser().currentUser.memberID!}&post_ids=&country=${CurrentUser().currentUser.country}&hash_tag=$tag&page=1');

    print("getPost From tags getting called url=$newurl");
    var client = Dio();
    String? token = await ApiProvider().getTheToken();
    print('hasshtag ${newurl} ${token}');
    return await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      print('hasshtag=${value.data}');
      if (value.statusCode == 200) {
        try {
          print("get from tag =${value.data['data']}");

          AllFeeds postsData = AllFeeds.fromJson(value.data['data']);

          await Future.wait(postsData.feeds
              .map((e) => PreloadCached.cacheImage(
                  context, e.postImgData!.split("~~")[0]))
              .toList());
          return postsData.feeds;
        } catch (e) {
          print("Hashtag exception=$e");
          return <NewsFeedModel>[];
        }
      } else {
        return <NewsFeedModel>[];
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/people_images_api_call.php?action=fetch_post_data_people_images&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&hash_tag=$tag");
    // var response = await http.get(url);
    // if (response.statusCode == 200 &&
    //     response.body != null &&
    //     response.body != "") {
    //   print(response.body);
    //   AllFeeds postsData = AllFeeds.fromJson(jsonDecode(response.body));
    //   await Future.wait(postsData.feeds
    //       .map((e) =>
    //           PreloadCached.cacheImage(context, e.postImgData.split("~~")[0]))
    //       .toList());
    //   return postsData.feeds;
    // } else {
    //   return <NewsFeedModel>[];
    // }
  }

  static Future<AllFeeds> getLocalPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("discover_main");
    if (data != null) {
      AllFeeds postsData = AllFeeds.fromJson(jsonDecode(data));
      return postsData;
    } else {
      return AllFeeds([]);
    }
  }

  static Future<List<DiscoverHashtagsModel>> getHashtags(String tag) async {
    print("hashtag function discover");
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/people_images_api_call.php?action=fetch_post_data_people_images_hashtag_data&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&hash_tag=$tag");
    String? token = await ApiProvider().getTheToken();
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/image/searchHastagData?action=fetch_post_data_people_images_hashtag_data&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&hash_tag=$tag');
    var client = Dio();
    print("hash set url=${newurl} $token");
    var response = await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      print("hashtag resp=0");
      print("hashtag resp=${value}");
      return value;
    });

    // var response = await http.get(url);

    if (response.statusCode == 200) {
      print("hassshhhh ${response.data}");
      DiscoverHashtags hashTagData =
          DiscoverHashtags.fromJson(response.data['data']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("discover_hashtags", jsonEncode(response.data['data']));
      return hashTagData.discoverHashtags;
    } else {
      return <DiscoverHashtagsModel>[];
    }
  }

  static Future<DiscoverHashtags> getLocalHashtags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("discover_hashtags");
    try {
      if (data != null) {
        print("hashtag is not null $data");

        DiscoverHashtags hashTagData =
            DiscoverHashtags.fromJson(jsonDecode(data));
        return hashTagData;
      } else {
        print("hastag is null");
        return DiscoverHashtags([]);
      }
    } catch (e) {
      return DiscoverHashtags([]);
    }
  }

  static Future<List<NewsFeedModel>?> onLoadingPosts(
      List<NewsFeedModel> posts,
      String selectedHashtag,
      BuildContext context,
      RefreshController _refreshController,
      {page: 1}) async {
    int len = posts.length;
    String urlStr = "";
    // for (int i = 0; i < len; i++) {
    //   urlStr += posts[i].postId;
    //   if (i != len - 1) {
    //     urlStr += ",";
    //   }
    // }
    print("hashtag post loading");
    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/hashtag_data.php?action=hash_tag&page=$page&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&hash_tag=$selectedHashtag');
      print('url hash= ${newurl}');
      var client = Dio();
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

      return await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("get from tag 2=${value.data}");

        try {
          print("hashtag val=${value.data}");
          if (value.statusCode == 200 && value.data['status'] == 201) {
            print("get from tag =${value.data['data']}");
            AllFeeds postsData = AllFeeds.fromJson(value.data['data']);
            await Future.wait(postsData.feeds
                .map((e) => PreloadCached.cacheImage(
                    context, e.postsmlImgData!.split("~~")[0]))
                .toList());
            return postsData.feeds;
          } else {
            _refreshController.loadComplete();
            return <NewsFeedModel>[];
          }
        } catch (e) {
          _refreshController.loadComplete();
          return <NewsFeedModel>[];
        }
      });
    } on SocketException catch (e) {
      print("loading exception!! ");
      print("422 error hashtag");
      Fluttertoast.showToast(
        msg: "Couldn't refresh feed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      _refreshController.loadComplete();
      return null;
    }
  }
}
