// To parse this JSON data, do
//
//     final blockedUsersModel = blockedUsersModelFromJson(jsonString);

import 'dart:convert';

List<BlockedUsersModel> blockedUsersModelFromJson(String str) =>
    List<BlockedUsersModel>.from(
        json.decode(str).map((x) => BlockedUsersModel.fromJson(x)));

String blockedUsersModelToJson(List<BlockedUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlockedUsersModel {
  BlockedUsersModel({
    this.name,
    this.image,
    this.memberId,
  });

  String? name;
  String? image;
  String? memberId;

  factory BlockedUsersModel.fromJson(Map<String, dynamic> json) =>
      BlockedUsersModel(
        name: json["name"],
        image: json["image"],
        memberId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "user_id": memberId,
      };
}

class BlockedUsers {
  List<BlockedUsersModel> users;

  BlockedUsers(this.users);

  factory BlockedUsers.fromJson(List<dynamic> parsed) {
    List<BlockedUsersModel> users = <BlockedUsersModel>[];
    users = parsed.map((i) => BlockedUsersModel.fromJson(i)).toList();
    return new BlockedUsers(users);
  }
}
