// To parse this JSON data, do
//
//     final discoverHashtags = discoverHashtagsFromJson(jsonString);

import 'dart:convert';

List<DiscoverHashtagsModel> discoverHashtagsFromJson(String str) =>
    List<DiscoverHashtagsModel>.from(
        json.decode(str).map((x) => DiscoverHashtagsModel.fromJson(x)));

String discoverHashtagsToJson(List<DiscoverHashtagsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscoverHashtagsModel {
  DiscoverHashtagsModel({
    this.hashtag,
    this.color,
  });

  String? hashtag;
  String? color;

  factory DiscoverHashtagsModel.fromJson(Map<String, dynamic> json) =>
      DiscoverHashtagsModel(
        hashtag: json["hashtag"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "hashtag": hashtag,
        "color": color,
      };
}

class DiscoverHashtags {
  List<DiscoverHashtagsModel> discoverHashtags;

  DiscoverHashtags(this.discoverHashtags);
  factory DiscoverHashtags.fromJson(List<dynamic> parsed) {
    List<DiscoverHashtagsModel> discoverHashtags = <DiscoverHashtagsModel>[];
    discoverHashtags =
        parsed.map((i) => DiscoverHashtagsModel.fromJson(i)).toList();
    return new DiscoverHashtags(discoverHashtags);
  }
}
