// To parse this JSON data, do
//
//     final streamCategoriesModel = streamCategoriesModelFromJson(jsonString);

import 'dart:convert';

import 'package:bizbultest/models/Streaming/episodes_model.dart';
import 'package:get/get.dart';

List<StreamCategoriesModel> streamCategoriesModelFromJson(String str) =>
    List<StreamCategoriesModel>.from(
        json.decode(str).map((x) => StreamCategoriesModel.fromJson(x)));

String streamCategoriesModelToJson(List<StreamCategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StreamCategoriesModel {
  StreamCategoriesModel({
    this.name,
    this.value,
    this.categoryData,
    this.category,
  });

  String? name;
  String? value;
  List<CategoryDataModel>? categoryData;
  String? category;

  factory StreamCategoriesModel.fromJson(Map<String, dynamic> json) =>
      StreamCategoriesModel(
        name: json["name"],
        value: json["value"],
        categoryData: List<CategoryDataModel>.from(
            json["category_data"].map((x) => CategoryDataModel.fromJson(x))),
        category: json["category"] == null ? null : json["category"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "category_data":
            List<dynamic>.from(categoryData!.map((x) => x.toJson())),
        "category": category == null ? null : category,
      };
}

class CategoryDataModel {
  CategoryDataModel({
    this.vmRating,
    this.videoReso,
    this.videoId,
    this.sprite,
    this.poster,
    this.videoM3U8,
    this.video,
    this.vid1080M3U8,
    this.vid720M3U8,
    this.vid480M3U8,
    this.vid360M3U8,
    this.vid240M3U8,
    this.vid144M3U8,
    this.season,
    this.videoYear,
    this.videoMaturityRating,
    this.title,
    this.added,
    this.like,
    this.likeStatus,
    this.dislike,
    this.videoType,
    this.cast,
    this.description,
    this.duration,
    this.videoPreviewTrailer,
    this.videoPreviewTrailerPoster,
    this.videoPreviewTrailerM3U8,
    this.episodes,
    this.seasons,
  });

  String? vmRating;
  String? videoReso;
  String? videoId;
  String? sprite;
  String? poster;
  String? videoM3U8;
  String? video;
  String? vid1080M3U8;
  String? vid720M3U8;
  String? vid480M3U8;
  String? vid360M3U8;
  String? vid240M3U8;
  String? vid144M3U8;
  String? season;
  String? videoYear;
  String? videoMaturityRating;
  String? title;
  int? added;
  int? likeStatus;
  dynamic like;
  dynamic dislike;
  int? videoType;
  String? cast;
  String? description;
  String? duration;
  String? videoPreviewTrailer;
  String? videoPreviewTrailerPoster;
  String? videoPreviewTrailerM3U8;
  bool? isAdded = false;
  RxList<EpisodesModel>? episodes;
  RxList<String>? seasons;

  factory CategoryDataModel.fromJson(Map<String, dynamic> json) =>
      CategoryDataModel(
          vmRating: json["vm_rating"],
          videoReso: json["video_reso"],
          videoId: json["video_id"],
          sprite: json["sprite"],
          poster: json["poster"],
          videoM3U8: json["video_m3u8"],
          video: json["video"],
          vid1080M3U8: json["vid_1080_m3u8"],
          vid720M3U8: json["vid_720_m3u8"],
          vid480M3U8: json["vid_480_m3u8"],
          vid360M3U8: json["vid_360_m3u8"],
          vid240M3U8: json["vid_240_m3u8"],
          vid144M3U8: json["vid_144_m3u8"],
          season: json["season"],
          videoYear: json["video_year"],
          videoMaturityRating: json["video_maturity_rating"],
          title: json["title"],
          added: json["added"],
          like: json["like"],
          likeStatus: json["like_status"],
          dislike: json["dislike"],
          videoType: json["video_type"],
          cast: json["cast"],
          description: json["description"],
          duration: json["duration"],
          videoPreviewTrailer: json["video_preview_trailer"],
          videoPreviewTrailerPoster: json["video_preview_trailer_poster"],
          videoPreviewTrailerM3U8: json["video_preview_trailer_m3u8"],
          episodes: new RxList(<EpisodesModel>[]),
          seasons: new RxList([""]));

  Map<String, dynamic> toJson() => {
        "vm_rating": vmRating,
        "video_reso": videoReso,
        "video_id": videoId,
        "sprite": sprite,
        "poster": poster,
        "video_m3u8": videoM3U8,
        "video": video,
        "vid_1080_m3u8": vid1080M3U8,
        "vid_720_m3u8": vid720M3U8,
        "vid_480_m3u8": vid480M3U8,
        "vid_360_m3u8": vid360M3U8,
        "vid_240_m3u8": vid240M3U8,
        "vid_144_m3u8": vid144M3U8,
        "season": season,
        "video_year": videoYear,
        "video_maturity_rating": videoMaturityRating,
        "title": title,
        "added": added,
        "like": like,
        "like_status": likeStatus,
        "dislike": dislike,
        "video_type": videoType,
        "cast": cast,
        "description": description,
        "duration": duration,
        "video_preview_trailer": videoPreviewTrailer,
        "video_preview_trailer_poster": videoPreviewTrailerPoster,
        "video_preview_trailer_m3u8": videoPreviewTrailerM3U8,
      };
}

class CategoryData {
  List<CategoryDataModel> videos;

  CategoryData(this.videos);
  factory CategoryData.fromJson(List<dynamic> parsed) {
    List<CategoryDataModel> categories = <CategoryDataModel>[];
    categories = parsed.map((i) => CategoryDataModel.fromJson(i)).toList();
    return new CategoryData(categories);
  }
}

class StreamCategoryVideos {
  List<StreamCategoriesModel> videos;

  StreamCategoryVideos(this.videos);
  factory StreamCategoryVideos.fromJson(List<dynamic> parsed) {
    List<StreamCategoriesModel> categories = <StreamCategoriesModel>[];
    categories = parsed.map((i) => StreamCategoriesModel.fromJson(i)).toList();
    return new StreamCategoryVideos(categories);
  }
}
