// To parse this JSON data, do
//
//     final hashtag = hashtagFromJson(jsonString);

// To parse this JSON data, do
//
//     final hashtag = hashtagFromJson(jsonString);

// To parse this JSON data, do
//
//     final hashtag = hashtagFromJson(jsonString);

import 'dart:convert';

List<TrendingTopicsModel> hashtagFromJson(String str) =>
    List<TrendingTopicsModel>.from(
        json.decode(str).map((x) => TrendingTopicsModel.fromJson(x)));

String hashtagToJson(List<TrendingTopicsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrendingTopicsModel {
  TrendingTopicsModel({
    this.url,
    this.hashtag,
    this.color,
  });

  String? url;
  String? hashtag;
  String? color;

  factory TrendingTopicsModel.fromJson(Map<String, dynamic> json) =>
      TrendingTopicsModel(
        url: json["url"],
        hashtag: json["hashtag"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "hashtag": hashtag,
        "color": color,
      };
}

class TrendingTopics {
  List<TrendingTopicsModel> topics;

  TrendingTopics(this.topics);
  factory TrendingTopics.fromJson(List<dynamic> parsed) {
    List<TrendingTopicsModel> topics = <TrendingTopicsModel>[];
    topics = parsed.map((i) => TrendingTopicsModel.fromJson(i)).toList();
    return new TrendingTopics(topics);
  }
}
