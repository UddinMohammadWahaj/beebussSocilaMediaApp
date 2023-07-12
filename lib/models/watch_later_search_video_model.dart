// To parse this JSON data, do
//
//     final watchLaterSeachVideosModel = watchLaterSeachVideosModelFromJson(jsonString);

import 'dart:convert';

List<WatchLaterSearchVideosModel> watchLaterSeachVideosModelFromJson(
        String str) =>
    List<WatchLaterSearchVideosModel>.from(
        json.decode(str).map((x) => WatchLaterSearchVideosModel.fromJson(x)));

String watchLaterSeachVideosModelToJson(
        List<WatchLaterSearchVideosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WatchLaterSearchVideosModel {
  WatchLaterSearchVideosModel({
    this.postId,
    this.image,
    this.title,
    this.description,
    this.date,
  });

  String? postId;
  String? image;
  String? title;
  String? description;
  String? date;
  bool? isSelected = false;

  factory WatchLaterSearchVideosModel.fromJson(Map<String, dynamic> json) =>
      WatchLaterSearchVideosModel(
        postId: json["post_id"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "image": image,
        "title": title,
        "description": description,
        "date": date,
      };
}

class WatchLaterSearch {
  List<WatchLaterSearchVideosModel> videos;

  WatchLaterSearch(this.videos);
  factory WatchLaterSearch.fromJson(List<dynamic> parsed) {
    List<WatchLaterSearchVideosModel> videos = <WatchLaterSearchVideosModel>[];
    videos =
        parsed.map((i) => WatchLaterSearchVideosModel.fromJson(i)).toList();
    return new WatchLaterSearch(videos);
  }
}
