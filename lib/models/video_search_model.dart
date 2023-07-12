// To parse this JSON data, do
//
//     final videoSearchModel = videoSearchModelFromJson(jsonString);

import 'dart:convert';

List<VideoSearchModel> videoSearchModelFromJson(String str) =>
    List<VideoSearchModel>.from(
        json.decode(str).map((x) => VideoSearchModel.fromJson(x)));

String videoSearchModelToJson(List<VideoSearchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoSearchModel {
  VideoSearchModel({
    this.postId,
    this.videoUrl,
    this.userName,
    this.image,
    this.postContent,
    this.usrShortcode,
    this.totalViews,
    this.timeStamp,
  });

  String? postId;
  String? videoUrl;
  String? userName;
  String? image;
  String? postContent;
  String? usrShortcode;
  String? totalViews;
  String? timeStamp;

  factory VideoSearchModel.fromJson(Map<String, dynamic> json) =>
      VideoSearchModel(
        postId: json["post_id"].toString(),
        videoUrl: json["video_url"],
        userName: json["user_name"],
        image: json["image"],
        postContent: json["post_content"],
        usrShortcode: json["usr_shortcode"],
        totalViews: json["total_views"],
        timeStamp: json["time_stamp"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "video_url": videoUrl,
        "user_name": userName,
        "image": image,
        "post_content": postContent,
        "usr_shortcode": usrShortcode,
        "total_views": totalViews,
        "time_stamp": timeStamp,
      };
}

class Videos {
  List<VideoSearchModel> videos;

  Videos(this.videos);
  factory Videos.fromJson(List<dynamic> parsed) {
    List<VideoSearchModel> videos = <VideoSearchModel>[];
    videos = parsed.map((i) => VideoSearchModel.fromJson(i)).toList();
    return new Videos(videos);
  }
}
