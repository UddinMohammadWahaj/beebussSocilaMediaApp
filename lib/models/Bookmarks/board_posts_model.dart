// To parse this JSON data, do
//
//     final boardPostsModel = boardPostsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<BoardPostsModel> boardPostsModelFromJson(String str) =>
    List<BoardPostsModel>.from(
        json.decode(str).map((x) => BoardPostsModel.fromJson(x)));

String boardPostsModelToJson(List<BoardPostsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BoardPostsModel {
  BoardPostsModel({
    this.postId,
    this.thumbnail,
    this.memberId,
    this.userName,
    this.userImage,
    this.shortcode,
    this.isStarred,
    this.starred,
  });

  String? postId;
  String? thumbnail;
  String? memberId;
  String? userName;
  String? userImage;
  String? shortcode;
  bool? isStarred;
  Rx<bool>? starred;

  factory BoardPostsModel.fromJson(Map<String, dynamic> json) =>
      BoardPostsModel(
          postId: json["post_id"],
          thumbnail: json["thumbnail"],
          memberId: json["user_id"],
          userName: json["user_name"],
          userImage: json["user_image"],
          shortcode: json["shortcode"],
          isStarred: json["isStarred"],
          starred: false.obs);

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "thumbnail": thumbnail,
        "user_id": memberId,
        "user_name": userName,
        "user_image": userImage,
        "shortcode": shortcode,
      };
}

class BoardPosts {
  List<BoardPostsModel> posts;

  BoardPosts(this.posts);

  factory BoardPosts.fromJson(List<dynamic> parsed) {
    List<BoardPostsModel> posts = <BoardPostsModel>[];
    posts = parsed.map((i) => BoardPostsModel.fromJson(i)).toList();
    return new BoardPosts(posts);
  }
}
