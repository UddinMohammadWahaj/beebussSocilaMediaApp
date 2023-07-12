// To parse this JSON data, do
//
//     final postLikedUsersModel = postLikedUsersModelFromJson(jsonString);

import 'dart:convert';

List<PostLikedUsersModel> postLikedUsersModelFromJson(String str) =>
    List<PostLikedUsersModel>.from(
        json.decode(str).map((x) => PostLikedUsersModel.fromJson(x)));

class PostLikedUsersModel {
  PostLikedUsersModel({
    this.memberId,
    this.name,
    this.shortcode,
    this.image,
    this.followData,
    this.designation,
  });

  String? memberId;
  String? name;
  String? shortcode;
  String? image;
  String? followData;
  String? designation;

  factory PostLikedUsersModel.fromJson(Map<String, dynamic> json) =>
      PostLikedUsersModel(
        memberId: json["user_id"],
        name: json["name"],
        shortcode: json["shortcode"],
        image: json["image"],
        followData: json["follow_data"],
        designation: json["designation"],
      );
}

class PostLikedUsers {
  List<PostLikedUsersModel> users;

  PostLikedUsers(this.users);

  factory PostLikedUsers.fromJson(List<dynamic> parsed) {
    List<PostLikedUsersModel> users = <PostLikedUsersModel>[];
    users = parsed.map((i) => PostLikedUsersModel.fromJson(i)).toList();
    return new PostLikedUsers(users);
  }
}
