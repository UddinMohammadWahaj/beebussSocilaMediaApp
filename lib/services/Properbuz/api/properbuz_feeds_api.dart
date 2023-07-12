import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/models/Properbuz/boost_post_model.dart';
import 'package:bizbultest/models/Properbuz/properbuz_comments_model.dart';
import 'package:bizbultest/models/Properbuz/properbuz_feeds_model.dart';
import 'package:bizbultest/models/Properbuz/url_metadata_model.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import '../../../api/ApiRepo.dart' as ApiRepo;
import 'package:bizbultest/models/newsfeed_likes_user_model.dart';

class ProperbuzFeedsAPI {
  static final String memberID = CurrentUser().currentUser.memberID!;
  static final String country = "India";

  static Future<List<dynamic>> getTagsList() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/news_feed_hashtag_list.php?country=World Wide");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/news_feed_hashtag_list.php", {"country": "World Wide"});
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      print("got tags");
      List<dynamic> tags = response!.data['data'];
      return tags;
    } else {
      return [];
    }
  }

  Future<NewsFeedLikedUsers> getUsersPropbuz(
      String search, String postID, BuildContext context,
      {postType: " "}) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_like_list.php?action=get_all_likes_members&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&all_members_data=&keyword=$search");
    var url =
        "https://www.bebuzee.com/api/all_likes_members_data1.php?action=get_all_likes_members&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&all_members_data=&keyword=$search&post_type=$postType";
    print(url);
    var response = await ApiProvider().fireApi(url);
    try {
      if (response!.statusCode == 200) {
        print('get users like ${response!.data}');
        NewsFeedLikedUsers userData =
        NewsFeedLikedUsers.fromJson(response!.data['data']);
        // await Future.wait(userData.users
        //     .map((e) => Preload.cacheImage(context, e.image))
        //     .toList());

        return userData;
      } else {
        return NewsFeedLikedUsers([]);
      }
    } catch (e) {
      return NewsFeedLikedUsers([]);
    }
  }

  static Future<NewsFeedLikedUsers?> newsfeedonLoading(
      NewsFeedLikedUsers likedUsers,
      BuildContext context,
      RefreshController _refreshController,
      String postID,
      {String postType = ""}) async {
    print("on loading");
    int len = likedUsers.newsfeedusers.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += likedUsers.newsfeedusers[i].memberId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    print(urlStr);
    try {
      var url =
          "https://www.bebuzee.com/api/all_likes_members_data.php?action=get_all_likes_members&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&all_members_data=$urlStr&keyword=&post_type=$postType";

      var response = await ApiProvider().fireApi(url);

      if (response!.statusCode == 200) {
        NewsFeedLikedUsers userData =
        NewsFeedLikedUsers.fromJson(response!.data['data']);
        await Future.wait(userData.newsfeedusers
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

  static Future<List<ProperbuzFeedsModel>> getFeeds(int page) async {
    //var url = Uri.parse("https://www.bebuzee.com/webservices/properbuzz_news_feed.php?user_id=$memberID&country=$country&page=$page");
    // print(url);
    // var response = await http.get(url);
    // var newurl = 'https://www.bebuzee.com/api/properbuz/newsFeed';
    // var response = await ApiProvider().fireApiWithParamsPost(newurl, params: {
    //   "user_id": memberID,
    //   "country_id": 101,
    //   "page": page,
    // }).then((value) => value);
    // print('properbuz news feed response=${response!.data}');

    var response = await ApiRepo.postWithToken("api/properbuzz_news_feed.php",
        {"user_id": memberID, "country": country, "page": page});

    if (response!.data['data'] != null && response!.data['data'] != "") {
      print(
          "-----------------------${response!.data['data']}-------------------------");
      ProperbuzFeeds properbuzFeeds =
      ProperbuzFeeds.fromJson(response!.data['data']);
      return properbuzFeeds.feeds;
    } else {
      return [];
    }
  }

  static Future<List<ProperbuzFeedsModel>> getTagsFeeds(
      int page, String tag, String sort, String keyword) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_filter.php?user_id=$memberID&country=$country&page=$page&tag=${tag.replaceAll("#", "")}&sort=$sort&keyword=$keyword");
    // print(url);
    // var response = await http.get(url);

    var response =
    await ApiRepo.postWithToken("api/properbuzz_news_feed_filter.php", {
      "user_id": memberID,
      "country": country,
      "page": page,
      "tag": tag.replaceAll("#", ""),
      "sort": sort,
      "keyword": keyword,
    });
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      ProperbuzFeeds properbuzFeeds =
      ProperbuzFeeds.fromJson(response!.data['data']);
      return properbuzFeeds.feeds;
    } else {
      return [];
    }
  }

  static Future<List<ProperbuzFeedsModel>> getSavedPosts(int page) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_saved_news_feed.php?user_id=$memberID&country=India&page=$page");
    // print(url);
    // var response = await http.get(url);
    var response =
    await ApiRepo.postWithToken("api/properbuzz_saved_news_feed.php", {
      "user_id": memberID,
      "country": "India",
      "page": page,
    });
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      ProperbuzFeeds properbuzFeeds =
      ProperbuzFeeds.fromJson(response!.data['data']);
      return properbuzFeeds.feeds;
    } else {
      return [];
    }
  }

  static Future<List<ProperbuzFeedsModel>> getUserPosts(int page) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_my_news_feed.php?user_id=$memberID&page=$page");
    // print(url);
    var response = await ApiRepo.postWithToken(
        "api/properbuzz_my_news_feed.php",
        {"member_id": memberID, "page": page, "country": country});
    // var response = await http.get(url);
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      ProperbuzFeeds properbuzFeeds =
      ProperbuzFeeds.fromJson(response!.data['data']);
      return properbuzFeeds.feeds;
    } else {
      return [];
    }
  }

  static Future<List<ProperbuzFeedsModel>> getSinglePost(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_post.php?user_id=$memberID&post_id=$postID");
    // print(url);
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/properbuzz_news_feed.php",
        {"user_id": memberID, "country": country, "post_id": postID});
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      ProperbuzFeeds properbuzFeeds =
      ProperbuzFeeds.fromJson(response!.data['data']);
      return properbuzFeeds.feeds;
    } else {
      return [];
    }
  }

  static Future<void> sendDirectMessage(
      String postID, String members, String message) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuz_feed_post_share_on_chat.php?user_id=$memberID&post_id=$postID&share_user_ids=$members&message=$message");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/properbuz_feed_post_share_on_chat.php", {
      "user_id": memberID,
      "post_id": postID,
      "share_user_ids": members,
      "message": message
    });
    if (response!.success == 1) {
      print(response!.data);
      return response!.data;
    }
  }

  static Future<int> likeUnlike(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/new_feed_like_unlike.php?user_id=$memberID&post_id=$postID");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_like_unlike.php",
        {"user_id": memberID, "post_id": postID});
    if (response!.success == 1) {
      int likeCount = response!.data['total_likes'];
      print(response!.data);
      return likeCount;
    } else {
      return 0;
    }
  }

  static Future<UrlMetadataModel> getURLMetadata(String link) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/url_metadata.php?url=$link");
    // var response = await http.get(url);
    var response =
    await ApiRepo.postWithToken("api/url_metadata.php", {"url": link});
    if (response!.success == 1) {
      print(response!.data['data']);
      UrlMetadataModel urlMetadata =
      UrlMetadataModel.fromJson(response!.data['data']);
      print("-----title is-----${response!.data['data']}");
      print("----- ${urlMetadata.image}");

      return urlMetadata;
    } else {
      return UrlMetadataModel();
    }
  }

  static Future<List<AudienceModel>> getAudienceData() async {
    //var url = Uri.parse( "https://www.bebuzee.com/app_devlope_all_boosted.php?action=get_all_audience_user&user_id=$memberID");
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/audience_data_seperate.php",
        {"action": "get_all_audience_user", "user_id": memberID});

    if (response!.success == 1) {
      Audiences audienceData =
      Audiences.fromJson(jsonDecode(response!.data['data']));
      return audienceData.audiences;
    } else {
      return <AudienceModel>[];
    }
  }

  static Future<BoostPostModel> getBoostPostData(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_boost.php?user_id=$memberID&post_id=$postID");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_boost.php",
        {"user_id": memberID, "post_id": postID});
    if (response!.success == 1) {
      print(response!.data['data']);
      BoostPostModel boostPostModel =
      BoostPostModel.fromJson(response!.data['data']);
      print("post_id is");
      print(boostPostModel.postId);
      return boostPostModel;
    } else {
      return BoostPostModel();
    }
  }

  static Future<int> postComment(String postID, String comment) async {
    // var url = Uri.parse( "https://www.bebuzee.com/webservices/properbuzz_news_feed_comment.php?user_id=$memberID&post_id=$postID&message=$comment");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_comment.php",
        {"user_id": memberID, "post_id": postID, "message": comment});

    if (response!.success == 1) {
      int comments = response!.data['data']['comments'];
      print(response!.data['data']);
      return comments;
    } else {
      return 0;
    }
  }

  static Future<void> boostPost(
      String postID,
      String audienceID,
      String adDuration,
      String adBudget,
      String adButton,
      String adUrl,
      String title,
      String domain,
      String payerID,
      String paymentID,
      String walletAmount) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_boost_post.php?user_id=$memberID&post_id=$postID&audience_id=$audienceID&ad_duration=$adDuration&ad_budget=$adBudget&ad_button=$adButton&ad_url=$adUrl&title=$title&domain=$domain&payer_id=$payerID&payment_id=$paymentID&wallet_amount=$walletAmount");
    // var response = await http.get(url);
    var response =
    await ApiRepo.postWithToken("api/properbuzz_news_feed_boost_post.php", {
      "user_id": memberID,
      "post_id": postID,
      "audience_id": audienceID,
      "ad_duration": adDuration,
      "ad_budget": adBudget,
      "ad_button": adButton,
      "ad_url": adUrl,
      "title": title,
      "domain": domain,
      "payer_id": payerID,
      "payment_id": paymentID,
      "wallet_amount": walletAmount
    });
    if (response!.success == 1) {
      print(response!.data['data']);
    } else {}
  }

  static Future<String> editComment(String commentID, String comment) async {
    //var url = Uri.parse("https://www.bebuzee.com/webservices/properbuzz_news_feed_comment_edit.php?comment_id=$commentID&message=$comment&user_id=$memberID");
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_comment_edit.php",
        {"comment_id": commentID, "message": comment, "user_id": memberID});

    if (response!.success == 1) {
      String message = response!.data['data']['comment'];
      print(response!.data['data']);

      return message;
    } else {
      return comment;
    }
  }

  static Future<String> editSubComment(String commentID, String comment) async {
    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_sub_comment_edit.php",
        {"sub_comment_id": commentID, "user_id": memberID, "message": comment});

    if (response!.success == 1) {
      String message = response!.data['data']['sub_comments'];
      print(response!.data['data']);
      print(commentID);
      return message;
    } else {
      return comment;
    }
  }

  static Future<SubComment> replyToComment(
      String postID, String commentID, String comment) async {
    // var url = Uri.parse( "https://www.bebuzee.com/webservices/properbuzz_news_feed_sub_comment.php?user_id=$memberID&post_id=$postID&comment_id=$commentID&message=$comment");
    // print(url);
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_sub_comment.php", {
      "user_id": memberID,
      "post_id": postID,
      "comment_id": commentID,
      "message": comment
    });

    if (response!.success == 1) {
      SubComment message = SubComment.fromJson(response!.data['data'][0]);

      return message;
    } else {
      return SubComment();
    }
  }

  static Future<void> uploadImagePostTest(
      String description, List<File> images) async {
    print("type is image");

    var formData = FormData.fromMap({
      "user_id": memberID,
      "country_id": '101',
      "description": description,
    });
    for (var file in images) {
      formData.files.addAll([
        MapEntry("files[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    await ApiRepo.TestpostWithTokenAndFormData(
      "api/properbuz/addPost",
      formData,
          (int sent, int total) {
        final progress = (sent / total) * 100;
        print('image progress: $progress');
      },
    );
  }

  static Future<void> uploadImagePost(
      String description, List<File> images) async {
    print("type is image");
    var client = new Dio();
    var formData = FormData.fromMap({
      "user_id": memberID,
      "country": country,
      "description": description,
      "post_type": "image"
    });
    for (var file in images) {
      formData.files.addAll([
        MapEntry("images[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    await ApiRepo.postWithTokenAndFormData(
        "api/properbuzz_add_post.php", formData, (int sent, int total) {
      final progress = (sent / total) * 100;
      print('image progress: $progress');
    });
  }

  static Future<void> newPostTest(
      String description, List<File> imageFiles) async {
    String url =
        'https://www.bebuzee.com/api/properbuz/addPost?user_id=${CurrentUser().currentUser.memberID}&country_id=101&description=${description}';
    print("new post upload url=$url");
    var formData = FormData();
    formData.files.add(
        MapEntry("files[]", await MultipartFile.fromFile(imageFiles[0].path)));
    var dio = Dio();
    var response;
    response = dio
        .post(
      url,
      data: formData,
    )
        .then((value) => value);
  }

  static Future<void> newPostFeeds(
      String description, List<File> imagefiles) async {
    var url = 'https://www.bebuzee.com/api/properbuz/addPost';
    var formData = FormData();

    var params = {
      "user_id": CurrentUser().currentUser.memberID,
      "country_id": 101,
      "description": description,
    };
    params.forEach((key, value) {
      formData.fields.add(MapEntry(key.toString(), value.toString()));
    });
    print("image=${imagefiles[0].path}");
    formData.files.add(
        MapEntry("files[]", await MultipartFile.fromFile(imagefiles[0].path)));

    // await ApiRepo.TestpostWithTokenAndFormData(
    //     "api/properbuz/addPost", formData, (int sent, int total) {
    //   final progress = (sent / total) * 100;
    //   print('image progress: $progress');
    // });
    print('formdata file length=${formData.files.length}');
    var response;
    try {
      response = await ApiProvider()
          .fireApiWithParamsPost(url, formdata: formData)
          .then((value) => value);
      print("response of upload=${response!.data}");
    } catch (e) {
      print('error=$e');
    }
  }

  static Future<void> unfollowUser(String otherMemberId) async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=$memberID&user_id_to=$otherMemberId");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_follow_check1.php", {
      "action": "unfollow_user",
      "user_id": memberID,
      "user_id_to": otherMemberId
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    }
  }

  static Future<bool> saveUnsave(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/news_feed_save_unsave.php?user_id=$memberID&post_id=$postID");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/news_feed_save_unsave.php",
        {"user_id": memberID, "post_id": postID});
    if (response!.success == 1) {
      bool savedStatus = response!.data['saved_status'];
      print(response!.data);
      return savedStatus;
    } else {
      return false;
    }
  }

  static Future<void> deletePost(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/news_feed_delete.php?user_id=$memberID&post_id=$postID");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/news_feed_delete.php", {"user_id": memberID, "post_id": postID});
    if (response!.success == 1) {
      print(response!.data);
    } else {
      print("not deleted");
    }
  }

  static Future<String> editPost(String postID, String description) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_edit_post.php");
    // var response = await http.post(url, body: {
    //   "user_id": memberID,
    //   "post_id": postID,
    //   "description": description
    // });

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_edit_post_description.php",
        {"user_id": memberID, "post_id": postID, "description": description});
    if (response!.success == 1) {
      String data = (response!.data)['description'];
      print(response!.data);
      return data;
    } else {
      return description;
    }
  }

  static Future<void> uploadTextPost(
      String description, bool hasLink, String link) async {
    // var url = Uri.parse( "https://www.bebuzee.com/webservices/properbuzz_add_post.php");
    // print(url);
    // var response = await http.post(url, body: {
    //   "user_id": memberID,
    //   "country": country,
    //   "description": description,
    //   "post_type": "post",
    //   "has_link": hasLink.toString(),
    //   "url": link
    // });

    var response = await ApiRepo.postWithToken("api/properbuzz_add_post.php", {
      "user_id": memberID,
      "country": country,
      "description": description,
      "post_type": "post",
      "has_link": hasLink.toString(),
      "url": link
    });

    if (response!.success == 1) {
      print(response!.data['data']);
    } else {}
  }

  static Future<void> uploadVideoPost(String description, String path) async {
    var client = new Dio();
    FormData formData = new FormData.fromMap({
      "video": await MultipartFile.fromFile(path),
      "user_id": memberID,
      "country": country,
      "description": description,
      "post_type": "video"
    });

    await ApiRepo.postWithTokenAndFormData(
      "api/properbuzz_add_post.php",
      formData,
          (int sent, int total) {
        final progress = (sent / total) * 100;
        print('video progress: $progress');
      },
    );
  }
}