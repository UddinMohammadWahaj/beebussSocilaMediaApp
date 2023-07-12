// To parse this JSON data, do
//
//     final currentUserFollowersModel = currentUserFollowersModelFromJson(jsonString);

import 'dart:convert';

List<UserFollowersFollowingModel> currentUserFollowersModelFromJson(
        String str) =>
    List<UserFollowersFollowingModel>.from(
        json.decode(str).map((x) => UserFollowersFollowingModel.fromJson(x)));

String currentUserFollowersModelToJson(
        List<UserFollowersFollowingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserFollowersFollowingModel {
  UserFollowersFollowingModel({
    this.memberId,
    this.memberFirstname,
    this.memberLastname,
    this.shortcode,
    this.userImage,
    this.followText,
  });

  String? memberId;
  String? memberFirstname;
  String? memberLastname;
  String? shortcode;
  String? userImage;
  dynamic followText;

  factory UserFollowersFollowingModel.fromJson(Map<String, dynamic> json) =>
      UserFollowersFollowingModel(
        memberId: json["user_id"],
        memberFirstname: json["member_firstname"],
        memberLastname: json["member_lastname"],
        shortcode: json["shortcode"],
        userImage: json["userImage"],
        followText: json["followText"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "member_firstname": memberFirstname,
        "member_lastname": memberLastname,
        "shortcode": shortcode,
        "userImage": userImage,
        "followText": followText,
      };
}

class Users {
  List<UserFollowersFollowingModel> usersList;

  Users(this.usersList);
  factory Users.fromJson(List<dynamic> parsed) {
    List<UserFollowersFollowingModel> usersList =
        <UserFollowersFollowingModel>[];
    usersList =
        parsed.map((i) => UserFollowersFollowingModel.fromJson(i)).toList();
    return new Users(usersList);
  }
}
