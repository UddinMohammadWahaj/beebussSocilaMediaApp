// To parse this JSON data, do
//
//     final userPlaylistsModel = userPlaylistsModelFromJson(jsonString);

import 'dart:convert';

List<UserPlaylistsModel> userPlaylistsModelFromJson(String str) =>
    List<UserPlaylistsModel>.from(
        json.decode(str).map((x) => UserPlaylistsModel.fromJson(x)));

String userPlaylistsModelToJson(List<UserPlaylistsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPlaylistsModel {
  UserPlaylistsModel(
      {this.playlistId,
      this.memberId,
      this.shortcode,
      this.image,
      this.playlistTitle,
      this.playlistDescription,
      this.videoPrivate,
      this.videoPublic,
      this.playlistThumb,
      this.updatedDate,
      this.urlData,
      this.totalVideos,
      this.postId,
      this.dataUrlVal,
      this.totalPlaylists});

  String? playlistId;
  String? memberId;
  dynamic shortcode;
  String? image;
  dynamic playlistTitle;
  String? playlistDescription;
  int? videoPrivate;
  int? videoPublic;
  String? playlistThumb;
  String? updatedDate;
  String? urlData;
  int? totalVideos;
  String? postId;
  dynamic dataUrlVal;
  int? totalPlaylists;
  bool? showVideos = false;

  factory UserPlaylistsModel.fromJson(Map<String, dynamic> json) =>
      UserPlaylistsModel(
        playlistId: json["playlist_id"],
        memberId: json["user_id"],
        totalPlaylists: json["total_lists"],
        shortcode: json["shortcode"],
        image: json["image"],
        playlistTitle: json["playlist_title"],
        playlistDescription: json["playlist_description"],
        videoPrivate: json["video_private"] ?? false ? 1 : 0,
        videoPublic: json["video_public"] ?? false ? 1 : 0,
        playlistThumb: json["playlist_thumb"],
        updatedDate: json["updated_date"],
        urlData: json["url_data"],
        totalVideos: json["total_videos"],
        postId: json["post_id"],
        dataUrlVal: json["data_url_val"],
      );

  Map<String, dynamic> toJson() => {
        "playlist_id": playlistId,
        "user_id": memberId,
        "shortcode": shortcode,
        "total_lists": totalPlaylists,
        "image": image,
        "playlist_title": playlistTitle,
        "playlist_description": playlistDescription,
        "video_private": videoPrivate,
        "video_public": videoPublic,
        "playlist_thumb": playlistThumb,
        "updated_date": updatedDate,
        "url_data": urlData,
        "total_videos": totalVideos,
        "post_id": postId,
        "data_url_val": dataUrlVal,
      };
}

class UserPlaylists {
  List<UserPlaylistsModel> playlists;
  UserPlaylists(this.playlists);
  factory UserPlaylists.fromJson(List<dynamic> parsed) {
    List<UserPlaylistsModel> playlists = <UserPlaylistsModel>[];
    playlists = parsed.map((i) => UserPlaylistsModel.fromJson(i)).toList();
    return new UserPlaylists(playlists);
  }
}
