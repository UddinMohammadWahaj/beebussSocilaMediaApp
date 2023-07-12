// To parse this JSON data, do
//
//     final userHighlightsModel = userHighlightsModelFromJson(jsonString);

import 'dart:convert';

List<UserHighlightsModel> userHighlightsModelFromJson(String str) =>
    List<UserHighlightsModel>.from(
        json.decode(str).map((x) => UserHighlightsModel.fromJson(x)));

String userHighlightsModelToJson(List<UserHighlightsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserHighlightsModel {
  UserHighlightsModel({
    this.memberId,
    this.highlightId,
    this.image,
    this.highlightText,
    this.shortcode,
    this.totalCountStory,
    this.firstImageOrVideo,
  });

  String? memberId;
  String? highlightId;
  String? image;
  String? highlightText;
  String? shortcode;
  int? totalCountStory;
  String? firstImageOrVideo;

  factory UserHighlightsModel.fromJson(Map<String, dynamic> json) =>
      UserHighlightsModel(
        memberId: json["user_id"],
        highlightId: json["highlight_id"],
        image: json["image"],
        highlightText: json["highlight_text"],
        shortcode: json["shortcode"],
        totalCountStory: json["total_count_story"],
        firstImageOrVideo: json["first_image_or_video"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "highlight_id": highlightId,
        "image": image,
        "highlight_text": highlightText,
        "shortcode": shortcode,
        "total_count_story": totalCountStory,
        "first_image_or_video": firstImageOrVideo,
      };
}

class UserHighlightsList {
  List<UserHighlightsModel> highlights;
  UserHighlightsList(this.highlights);
  factory UserHighlightsList.fromJson(List<dynamic> parsed) {
    List<UserHighlightsModel> highlights = <UserHighlightsModel>[];
    highlights = parsed.map((i) => UserHighlightsModel.fromJson(i)).toList();
    return new UserHighlightsList(highlights);
  }
}
