// To parse this JSON data, do
//
//     final videoStudioModel = videoStudioModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final videoStudioModel = videoStudioModelFromJson(jsonString);

import 'dart:convert';

List<VideoStudioModel> videoStudioModelFromJson(String str) =>
    List<VideoStudioModel>.from(
        json.decode(str).map((x) => VideoStudioModel.fromJson(x)));

String videoStudioModelToJson(List<VideoStudioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoStudioModel {
  VideoStudioModel({
    this.totalCount,
    this.title,
    this.type,
    this.playlistId,
    this.urlData,
    this.dataUrlVal,
    this.postId,
    this.allImage,
    this.total,
  });

  int? totalCount;
  String? title;
  dynamic type;
  String? playlistId;
  String? urlData;
  String? dataUrlVal;
  String? postId;
  String? allImage;
  int? total;

  factory VideoStudioModel.fromJson(Map<String, dynamic> json) => VideoStudioModel(
      totalCount: json["total_count"],
      title: json["title"],
      type: json["type"],
      playlistId: json["playlist_id"],
      urlData: json["url_data"],
      dataUrlVal: json["data_url_val"],
      postId: json["post_id"],
      allImage: json["all_image"],
      //total: int.parse(json["total"].toString().trim()!=""?json["total"].toString().trim():"0"),total
      total: json["total_video"]);

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "title": title,
        "type": type,
        "playlist_id": playlistId,
        "url_data": urlData,
        "data_url_val": dataUrlVal,
        "post_id": postId,
        "all_image": allImage,
        "total": total,
      };
}

class Studio {
  List<VideoStudioModel> playlists;
  Studio(this.playlists);
  factory Studio.fromJson(List<dynamic> parsed) {
    List<VideoStudioModel> playlists = <VideoStudioModel>[];
    playlists = parsed.map((i) => VideoStudioModel.fromJson(i)).toList();
    return new Studio(playlists);
  }
}
