// To parse this JSON data, do
//
//     final videoQualityModel = videoQualityModelFromJson(jsonString);

import 'dart:convert';

List<VideoQualityModel> videoQualityModelFromJson(String str) =>
    List<VideoQualityModel>.from(
        json.decode(str).map((x) => VideoQualityModel.fromJson(x)));

String videoQualityModelToJson(List<VideoQualityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoQualityModel {
  VideoQualityModel({
    this.quality,
    this.video,
    this.defaultQuality,
  });

  String? quality;
  String? video;
  int? defaultQuality;

  factory VideoQualityModel.fromJson(Map<String, dynamic> json) =>
      VideoQualityModel(
        quality: json["quality"],
        video: json["video"],
        defaultQuality: json["default"] ? 1 : 0,
      );

  Map<String, dynamic> toJson() => {
        "quality": quality,
        "video": video,
        "default": defaultQuality,
      };
}

class Qualities {
  List<VideoQualityModel> qualities;

  Qualities(this.qualities);
  factory Qualities.fromJson(List<dynamic> parsed) {
    List<VideoQualityModel> qualities = <VideoQualityModel>[];
    qualities = parsed.map((i) => VideoQualityModel.fromJson(i)).toList();
    return new Qualities(qualities);
  }
}
