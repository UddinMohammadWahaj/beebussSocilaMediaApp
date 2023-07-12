import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/post_liked_users_model.dart';
import 'package:bizbultest/models/Properbuz/properbuz_comments_model.dart';
import 'package:http/http.dart' as http;

import '../../current_user.dart';
import '../../../api/ApiRepo.dart' as ApiRepo;

class ProperbuzCommentsAPI {
  static final String memberID = CurrentUser().currentUser.memberID!;
  static final String country = "India";

  static Future<List<PostLikedUsersModel>> fetchUsers(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_comment_like_list.php?user_id=$memberID&post_id=$postID");
    // //print(url);
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_comment_like_list.php",
        {"user_id": memberID, "post_id": postID});

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      PostLikedUsers likedUsers =
          PostLikedUsers.fromJson(response!.data['data']);
      return likedUsers.users;
    } else {
      return <PostLikedUsersModel>[];
    }
  }

  static Future<List<ProperbuzCommentsModel>> fetchComments(
      String postID) async {
    //var url = Uri.parse("https://www.bebuzee.com/webservices/properbuzz_news_feed_comment_list.php?user_id=$memberID&post_id=$postID");
    //print(url);
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_comment_list.php",
        {"user_id": memberID, "post_id": postID});

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      ProperbuzComments comments =
          ProperbuzComments.fromJson(response!.data['data']);
      return comments.comments;
    } else {
      return <ProperbuzCommentsModel>[];
    }
  }

  static Future<int> deleteComment(String commentID) async {
    // var url = Uri.parse("https://www.bebuzee.com/webservices/properbuzz_news_feed_comment_delete.php?comment_id=$commentID&user_id=$memberID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_comment_delete.php",
        {"comment_id": commentID, "user_id": memberID});

    if (response!.success == 1) {
      print(response!.data['data']);
      int comments = response!.data['data']['comments'];
      return comments;
    } else {
      return 0;
    }
  }

  static Future<void> deleteSubComment(String subCommentID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_sub_comment_delete.php?sub_comment_id=$subCommentID&user_id=$memberID");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_sub_comment_delete.php",
        {"sub_comment_id": subCommentID, "user_id": memberID});
    if (response!.success == 1) {
      print(response!.data['data']);
    } else {}
  }

  static Future<void> likeUnlikeComment(String postID, String commentID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_comment_like_unlike.php?user_id=$memberID&post_id=$postID&comment_id=$commentID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_comment_like_unlike.php", {});

    if (response!.success == 1) {
      print(response!.data['data']);
    } else {}
  }

  static Future<void> likeUnlikeSubComment(String subCommentID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properbuzz_news_feed_sub_comment_like_unlike.php?user_id=$memberID&sub_comment_id=$subCommentID");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/properbuzz_news_feed_sub_comment_like_unlike.php",
        {"user_id": memberID, "sub_comment_id": subCommentID});
    if (response!.success == 1) {
      print(response!.data['data']);
    } else {}
  }
}
