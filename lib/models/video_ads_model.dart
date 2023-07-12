// To parse this JSON data, do
//
//     final videoAdsModel = videoAdsModelFromJson(jsonString);

import 'dart:convert';

List<VideoAdsModel> videoAdsModelFromJson(String str) =>
    List<VideoAdsModel>.from(
        json.decode(str).map((x) => VideoAdsModel.fromJson(x)));

String videoAdsModelToJson(List<VideoAdsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoAdsModel {
  VideoAdsModel({
    this.id,
    this.video,
    this.videoWidth,
    this.videoHeight,
    this.poster,
    this.circleImage,
    this.title,
    this.link,
    this.button,
    this.playTime,
  });

  String? id;
  String? video;
  int? videoWidth;
  int? videoHeight;
  String? poster;
  String? circleImage;
  String? title;
  String? link;
  String? button;
  String? playTime;

  factory VideoAdsModel.fromJson(Map<String, dynamic> json) => VideoAdsModel(
        id: json["id"],
        video: json["video"],
        videoWidth: json["video_width"],
        videoHeight: json["video_height"],
        poster: json["poster"],
        circleImage: json["circle_image"],
        title: json["title"] == null ? null : json["title"],
        link: json["link"] == null ? null : json["link"],
        button: json["button"] == null ? null : json["button"],
        playTime: json["play_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "video": video,
        "video_width": videoWidth,
        "video_height": videoHeight,
        "poster": poster,
        "circle_image": circleImage,
        "title": title == null ? null : title,
        "link": link == null ? null : link,
        "button": button == null ? null : button,
        "play_time": playTime,
      };
}

class VideoAds {
  List<VideoAdsModel> ads;

  VideoAds(this.ads);
  factory VideoAds.fromJson(List<dynamic> parsed) {
    List<VideoAdsModel> ads = <VideoAdsModel>[];
    ads = parsed.map((i) => VideoAdsModel.fromJson(i)).toList();
    return new VideoAds(ads);
  }
}
