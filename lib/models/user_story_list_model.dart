// To parse this JSON data, do
//
//     final userStoryListModel = userStoryListModelFromJson(jsonString);

import 'dart:convert';

List<UserStoryListModel> userStoryListModelFromJson(String str) =>
    List<UserStoryListModel>.from(
        json.decode(str).map((x) => UserStoryListModel.fromJson(x)));

String userStoryListModelToJson(List<UserStoryListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserStoryListModel {
  UserStoryListModel({
    this.story,
    this.memberId,
    this.shortcode,
    this.image,
    this.postId,
    this.imagesVideos,
    this.taggedPerson,
    this.viewStatus,
    this.token,
  });

  int? story;
  String? memberId;
  String? shortcode;
  String? image;
  String? postId;
  String? imagesVideos;
  String? taggedPerson;
  int? viewStatus;
  String? token;

  factory UserStoryListModel.fromJson(Map<String, dynamic> json) =>
      UserStoryListModel(
        story: json["story"] == null ? null : json["story"],
        memberId: json["user_id"].toString(),
        shortcode: json["shortcode"],
        image: json["image"],
        postId: json["post_id"].toString(),
        imagesVideos: json["images_videos"],
        taggedPerson: json["tagged_person"],
        viewStatus: json["view_status"],
        token: json["member_token"],
      );

  Map<String, dynamic> toJson() => {
        "story": story == null ? null : story,
        "user_id": memberId,
        "shortcode": shortcode,
        "image": image,
        "post_id": postId,
        "images_videos": imagesVideos,
        "tagged_person": taggedPerson,
        "view_status": viewStatus,
        "member_token": token,
      };
}

class UserStoryList {
  List<UserStoryListModel> users;
  UserStoryList(this.users);
  factory UserStoryList.fromJson(List<dynamic> parsed) {
    List<UserStoryListModel> users = <UserStoryListModel>[];
    users = parsed.map((i) => UserStoryListModel.fromJson(i)).toList();
    return new UserStoryList(users);
  }
}
