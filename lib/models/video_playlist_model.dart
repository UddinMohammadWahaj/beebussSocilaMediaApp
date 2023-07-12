// To parse this JSON data, do
//
//     final videoPlayListModel = videoPlayListModelFromJson(jsonString);

import 'dart:convert';

List<VideoPlayListModel> videoPlayListModelFromJson(String str) =>
    List<VideoPlayListModel>.from(
        json.decode(str).map((x) => VideoPlayListModel.fromJson(x)));

String videoPlayListModelToJson(List<VideoPlayListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoPlayListModel {
  VideoPlayListModel({
    this.name,
    this.id,
    this.type,
    this.checked,
  });

  String? name;
  String? id;
  String? type;
  int? checked;

  factory VideoPlayListModel.fromJson(Map<String, dynamic> json) =>
      VideoPlayListModel(
        name: json["name"],
        id: json["id"],
        type: json["type"] == null ? null : json["type"],
        checked: json["checked"] ? 1 : 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "type": type == null ? null : type,
        "checked": checked,
      };
}

class VideoPlaylist {
  List<VideoPlayListModel> playlists;

  VideoPlaylist(this.playlists);
  factory VideoPlaylist.fromJson(List<dynamic> parsed) {
    List<VideoPlayListModel> playlists = <VideoPlayListModel>[];
    playlists = parsed.map((i) => VideoPlayListModel.fromJson(i)).toList();
    return new VideoPlaylist(playlists);
  }
}
