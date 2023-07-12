// To parse this JSON data, do
//
//     final directUserList = directUserListFromJson(jsonString);

import 'dart:convert';

List<DirectUserModel> directUserListFromJson(String str) =>
    List<DirectUserModel>.from(
        json.decode(str).map((x) => DirectUserModel.fromJson(x)));

String directUserListToJson(List<DirectUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DirectUserModel {
  DirectUserModel({
    this.memberId,
    this.name,
    this.image,
  });

  String? memberId;
  String? name;
  String? image;

  factory DirectUserModel.fromJson(Map<String, dynamic> json) =>
      DirectUserModel(
        memberId: json["user_id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "name": name,
        "image": image,
      };
}

class DirectUsersSearch {
  List<DirectUserModel> users;

  DirectUsersSearch(this.users);
  factory DirectUsersSearch.fromJson(List<dynamic> parsed) {
    List<DirectUserModel> users = <DirectUserModel>[];
    users = parsed.map((i) => DirectUserModel.fromJson(i)).toList();
    return new DirectUsersSearch(users);
  }
}
