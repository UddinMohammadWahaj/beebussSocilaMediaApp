import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/expanded_user_tags_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../current_user.dart';

class FeedBodyApiCalls {
  static Future<TaggedUsers?> getTaggedUsersImage(String postID) async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/post_tagged_user.php?user_id=${CurrentUser().currentUser.memberID}&post_id=$postID');

    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=get_all_tagged_user&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID");
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await client
        .postUri(
          newurl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((v) => v);

    // var response =  await http.get(url);
    print("get tagged user respone= ${response.data}");
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data.isNotEmpty) {
      TaggedUsers userData = TaggedUsers.fromJson(response.data['data']);
      return userData;
    } else {
      return null;
    }
  }

  static Future<TaggedUsers?> getTaggedUsersVideo(String postID) async {
    print("-----tagedApiurl--------");

    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=get_all_tagged_user&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&tag_type=feed_post");
    var newurl =
        'https://www.bebuzee.com/api/post_tagged_user.php?action=get_video_tagged_user&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&tag_type=video';

    print("-----tagedApiurl${newurl}");

    var response = await ApiProvider().fireApi(newurl);

    // var response = await http.get(url);
    print("-----tagedApi${response.data}");
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data.isNotEmpty) {
      TaggedUsers userData = TaggedUsers.fromJson(response.data['data']);
      print(userData.users[0].name);
      return userData;
    } else {
      return null;
    }
  }
}
