// To parse this JSON data, do
//
//     final feedLikedUsersModel = feedLikedUsersModelFromJson(jsonString);

import 'dart:convert';

List<FeedLikedUsersModel> feedLikedUsersModelFromJson(String str) =>
    List<FeedLikedUsersModel>.from(
        json.decode(str).map((x) => FeedLikedUsersModel.fromJson(x)));

String feedLikedUsersModelToJson(List<FeedLikedUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedLikedUsersModel {
  FeedLikedUsersModel({
    this.image,
    this.shortcode,
    this.timeStamp,
    this.name,
    this.followData,
    this.memberId,
  });

  String? image;
  String? shortcode;
  String? timeStamp;
  String? name;
  String? followData;
  String? memberId;

  factory FeedLikedUsersModel.fromJson(Map<String, dynamic> json) =>
      FeedLikedUsersModel(
        image: json["image"],
        shortcode: json["shortcode"],
        timeStamp: json["time_stamp"],
        name: json["name"],
        followData: json["follow_data"],
        memberId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "shortcode": shortcode,
        "time_stamp": timeStamp,
        "name": name,
        "follow_data": followData,
        "user_id": memberId,
      };
}

class LikedUsers {
  List<FeedLikedUsersModel> users;

  LikedUsers(this.users);
  factory LikedUsers.fromJson(List<dynamic> parsed) {
    List<FeedLikedUsersModel> users = <FeedLikedUsersModel>[];
    users = parsed.map((i) => FeedLikedUsersModel.fromJson(i)).toList();
    return new LikedUsers(users);
  }
}
