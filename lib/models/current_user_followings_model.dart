// To parse this JSON data, do
//
//     final currentUserFollowingsModel = currentUserFollowingsModelFromJson(jsonString);

import 'dart:convert';

List<CurrentUserFollowingsModel> currentUserFollowingsModelFromJson(
        String str) =>
    List<CurrentUserFollowingsModel>.from(
        json.decode(str).map((x) => CurrentUserFollowingsModel.fromJson(x)));

String currentUserFollowingsModelToJson(
        List<CurrentUserFollowingsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CurrentUserFollowingsModel {
  CurrentUserFollowingsModel({
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

  factory CurrentUserFollowingsModel.fromJson(Map<String, dynamic> json) =>
      CurrentUserFollowingsModel(
        memberId: json["user_id"],
        memberFirstname: json["member_firstname"],
        memberLastname: json["member_lastname"],
        shortcode: json["shortcode"],
        userImage: json["user_image"],
        followText: json["follow_text"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "member_firstname": memberFirstname,
        "member_lastname": memberLastname,
        "shortcode": shortcode,
        "user_image": userImage,
        "follow_text": followText,
      };
}

class CurrentUserFollowings {
  List<CurrentUserFollowingsModel> followers;

  CurrentUserFollowings(this.followers);
  factory CurrentUserFollowings.fromJson(List<dynamic> parsed) {
    List<CurrentUserFollowingsModel> followers = <CurrentUserFollowingsModel>[];
    followers =
        parsed.map((i) => CurrentUserFollowingsModel.fromJson(i)).toList();
    return new CurrentUserFollowings(followers);
  }
}
