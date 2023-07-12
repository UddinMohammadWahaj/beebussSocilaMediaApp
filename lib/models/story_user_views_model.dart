// To parse this JSON data, do
//
//     final storyUserViewsModel = storyUserViewsModelFromJson(jsonString);

import 'dart:convert';

List<StoryUserViewsModel> storyUserViewsModelFromJson(String str) =>
    List<StoryUserViewsModel>.from(
        json.decode(str).map((x) => StoryUserViewsModel.fromJson(x)));

String storyUserViewsModelToJson(List<StoryUserViewsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoryUserViewsModel {
  StoryUserViewsModel({
    this.memberId,
    this.shortcode,
    this.image,
    this.userName,
    this.followStatus,
  });

  String? memberId;
  String? shortcode;
  String? image;
  String? userName;
  String? followStatus;

  factory StoryUserViewsModel.fromJson(Map<String, dynamic> json) =>
      StoryUserViewsModel(
        memberId: json["user_id"],
        followStatus: json["follow_status"],
        shortcode: json["shortcode"],
        image: json["image"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "shortcode": shortcode,
        "image": image,
        "user_name": userName,
        "follow_status": followStatus,
      };
}

class StoryUserViews {
  List<StoryUserViewsModel> users;
  StoryUserViews(this.users);
  factory StoryUserViews.fromJson(List<dynamic> parsed) {
    List<StoryUserViewsModel> users = <StoryUserViewsModel>[];
    users = parsed.map((i) => StoryUserViewsModel.fromJson(i)).toList();
    return new StoryUserViews(users);
  }
}
