// To parse this JSON data, do
//
//     final expandedUserTagsModel = expandedUserTagsModelFromJson(jsonString);

import 'dart:convert';

import 'package:bizbultest/models/user.dart';

List<TaggedUsersModel> expandedUserTagsModelFromJson(String str) =>
    List<TaggedUsersModel>.from(
        json.decode(str).map((x) => TaggedUsersModel.fromJson(x)));

String expandedUserTagsModelToJson(List<TaggedUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaggedUsersModel {
  TaggedUsersModel({
    this.postId,
    this.memberId,
    this.name,
    this.shortcode,
    this.imageUser,
    this.imageNumber,
    this.followData,
  });

  String? postId;
  String? memberId;
  String? name;
  String? shortcode;
  String? imageUser;
  String? imageNumber;
  String? followData;

  factory TaggedUsersModel.fromJson(Map<String, dynamic> json) =>
      TaggedUsersModel(
        postId: json["post_id"].toString(),
        memberId: json["user_id"].toString(),
        name: json["name"].toString(),
        shortcode: json["shortcode"].toString(),
        imageUser: json["image_user"].toString(),
        imageNumber: json["image_number"].toString(),
        followData: json["follow_data"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": memberId,
        "name": name,
        "shortcode": shortcode,
        "image_user": imageUser,
        "image_number": imageNumber,
        "follow_data": followData,
      };
}

class TaggedUsers {
  List<TaggedUsersModel> users;
  TaggedUsers(this.users);

  factory TaggedUsers.fromJson(List<dynamic> parsed) {
    List<TaggedUsersModel> users = <TaggedUsersModel>[];
    users = parsed.map((i) => TaggedUsersModel.fromJson(i)).toList();
    return new TaggedUsers(users);
  }
}
