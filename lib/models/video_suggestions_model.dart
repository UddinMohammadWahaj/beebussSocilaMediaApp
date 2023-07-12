// To parse this JSON data, do
//
//     final videoSuggestionsModel = videoSuggestionsModelFromJson(jsonString);

import 'dart:convert';

List<VideoSuggestionsModel> videoSuggestionsModelFromJson(String str) =>
    List<VideoSuggestionsModel>.from(
        json.decode(str).map((x) => VideoSuggestionsModel.fromJson(x)));

String videoSuggestionsModelToJson(List<VideoSuggestionsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoSuggestionsModel {
  VideoSuggestionsModel(
      {this.image, this.category, this.postId, this.color, this.sequence});

  String? image;
  String? category;
  int? postId;
  String? color;
  String? sequence;

  factory VideoSuggestionsModel.fromJson(Map<String, dynamic> json) =>
      VideoSuggestionsModel(
        image: json["image"],
        color: json["color"],
        category: json["category"],
        postId: json["post_id"],
        sequence: json["sequence"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "color": color,
        "category": category,
        "post_id": postId,
        "sequence": sequence,
      };
}

class SuggestedVideos {
  List<VideoSuggestionsModel> videos;

  SuggestedVideos(this.videos);

  factory SuggestedVideos.fromJson(List<dynamic> parsed) {
    List<VideoSuggestionsModel> videos = <VideoSuggestionsModel>[];
    videos = parsed.map((i) => VideoSuggestionsModel.fromJson(i)).toList();
    return new SuggestedVideos(videos);
  }
}
