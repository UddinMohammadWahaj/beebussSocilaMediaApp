// To parse this JSON data, do
//
//     final episodesModel = episodesModelFromJson(jsonString);

import 'dart:convert';

List<EpisodesModel> episodesModelFromJson(String str) =>
    List<EpisodesModel>.from(
        json.decode(str).map((x) => EpisodesModel.fromJson(x)));

String episodesModelToJson(List<EpisodesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EpisodesModel {
  EpisodesModel({
    this.videoId,
    this.title,
    this.description,
    this.poster,
    this.video,
    this.episode,
    this.duration,
  });

  String? videoId;
  String? title;
  String? description;
  String? poster;
  String? video;
  String? episode;
  String? duration;

  factory EpisodesModel.fromJson(Map<String, dynamic> json) => EpisodesModel(
        videoId: json["video_id"],
        title: json["title"],
        description: json["description"],
        poster: json["poster"],
        video: json["video"],
        episode: json["episode"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "title": title,
        "description": description,
        "poster": poster,
        "video": video,
        "episode": episode,
        "duration": duration,
      };
}

class Episodes {
  List<EpisodesModel> episodes;

  Episodes(this.episodes);
  factory Episodes.fromJson(List<dynamic> parsed) {
    List<EpisodesModel> categories = <EpisodesModel>[];
    categories = parsed.map((i) => EpisodesModel.fromJson(i)).toList();
    return new Episodes(categories);
  }
}
