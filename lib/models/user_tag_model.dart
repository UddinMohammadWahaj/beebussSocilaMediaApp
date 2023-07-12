// To parse this JSON data, do
//
//     final tagModel = tagModelFromJson(jsonString);

import 'dart:convert';

List<TagModel> tagModelFromJson(String str) =>
    List<TagModel>.from(json.decode(str).map((x) => TagModel.fromJson(x)));

String tagModelToJson(List<TagModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TagModel {
  TagModel({
    this.memberId,
    this.shortcode,
    this.image,
    this.url,
    this.name,
    this.varifiedImage,
    this.varifiedStatus,
  });

  String? memberId;
  String? shortcode;
  String? image;
  String? url;
  String? name;
  String? varifiedImage;
  bool? varifiedStatus;

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        memberId: json["user_id"],
        shortcode: json["shortcode"],
        image: json["image"],
        url: json["url"],
        name: json["name"],
        varifiedImage: json["varified_image"],
        varifiedStatus: json["varified_status"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "shortcode": shortcode,
        "image": image,
        "url": url,
        "name": name,
        "varified_image": varifiedImage,
        "varified_status": varifiedStatus,
      };

  toStringAsFixed(int i) {}
}

class UserTags {
  List<TagModel> userTags;

  UserTags(this.userTags);
  factory UserTags.fromJson(List<dynamic> parsed) {
    List<TagModel> userTags = <TagModel>[];
    userTags = parsed.map((i) => TagModel.fromJson(i)).toList();
    return new UserTags(userTags);
  }
}
