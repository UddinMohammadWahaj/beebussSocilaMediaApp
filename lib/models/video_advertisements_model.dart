// To parse this JSON data, do
//
//     final videoAdvertisementsModel = videoAdvertisementsModelFromJson(jsonString);

import 'dart:convert';

List<VideoAdvertisementsModel> videoAdvertisementsModelFromJson(String str) =>
    List<VideoAdvertisementsModel>.from(
        json.decode(str).map((x) => VideoAdvertisementsModel.fromJson(x)));

String videoAdvertisementsModelToJson(List<VideoAdvertisementsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoAdvertisementsModel {
  VideoAdvertisementsModel({
    this.dataId,
    this.linkTitle,
    this.imageVideo,
    this.image,
    this.video,
    this.status,
    this.date,
    this.totalViews,
    this.totalClicks,
    this.totalRow,
  });

  String? dataId;
  String? linkTitle;
  String? imageVideo;
  String? image;
  String? video;
  String? status;
  String? date;
  String? totalViews;
  String? totalClicks;
  int? totalRow;

  factory VideoAdvertisementsModel.fromJson(Map<String, dynamic> json) =>
      VideoAdvertisementsModel(
        dataId: json["data_id"],
        linkTitle: json["link_title"],
        imageVideo: json["image_video"],
        image: json["image"],
        video: json["video"],
        status: json["status"],
        date: json["date"],
        totalViews: json["total_views"],
        totalClicks: json["total_clicks"],
        totalRow: json["total_row"],
      );

  Map<String, dynamic> toJson() => {
        "data_id": dataId,
        "link_title": linkTitle,
        "image_video": imageVideo,
        "image": image,
        "video": video,
        "status": status,
        "date": date,
        "total_views": totalViews,
        "total_clicks": totalClicks,
        "total_row": totalRow,
      };
}

class VideoAdvertisements {
  List<VideoAdvertisementsModel> adverts;

  VideoAdvertisements(this.adverts);
  factory VideoAdvertisements.fromJson(List<dynamic> parsed) {
    List<VideoAdvertisementsModel> adverts = <VideoAdvertisementsModel>[];
    adverts = parsed.map((i) => VideoAdvertisementsModel.fromJson(i)).toList();
    return new VideoAdvertisements(adverts);
  }
}
