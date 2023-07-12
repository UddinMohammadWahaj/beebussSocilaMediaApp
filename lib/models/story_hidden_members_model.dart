// To parse this JSON data, do
//
//     final storyHiddenMembersModel = storyHiddenMembersModelFromJson(jsonString);

import 'dart:convert';

List<StoryHiddenMembersModel> storyHiddenMembersModelFromJson(String str) =>
    List<StoryHiddenMembersModel>.from(
        json.decode(str).map((x) => StoryHiddenMembersModel.fromJson(x)));

String storyHiddenMembersModelToJson(List<StoryHiddenMembersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoryHiddenMembersModel {
  StoryHiddenMembersModel({
    this.memberId,
    this.memberFirstname,
    this.shortcode,
    this.userImage,
    this.hiddenStatus,
  });

  String? memberId;
  String? memberFirstname;
  String? shortcode;
  String? userImage;
  int? hiddenStatus;
  bool? isHidden = false;

  factory StoryHiddenMembersModel.fromJson(Map<String, dynamic> json) =>
      StoryHiddenMembersModel(
        memberId: json["user_id"],
        memberFirstname: json["member_firstname"],
        shortcode: json["shortcode"],
        userImage: json["user_image"],
        hiddenStatus: json["hidden_status"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "member_firstname": memberFirstname,
        "shortcode": shortcode,
        "user_image": userImage,
        "hidden_status": hiddenStatus,
      };
}

class StoryHiddenMembers {
  List<StoryHiddenMembersModel> users;
  StoryHiddenMembers(this.users);
  factory StoryHiddenMembers.fromJson(List<dynamic> parsed) {
    List<StoryHiddenMembersModel> users = <StoryHiddenMembersModel>[];
    users = parsed.map((i) => StoryHiddenMembersModel.fromJson(i)).toList();
    return new StoryHiddenMembers(users);
  }
}
