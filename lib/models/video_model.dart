// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';
// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<VideoModel> videoModelFromJson(String str) =>
    List<VideoModel>.from(json.decode(str).map((x) => VideoModel.fromJson(x)));

String videoModelToJson(List<VideoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoModel {
  VideoModel({
    this.image,
    this.category,
    this.categoryIt,
    this.postId,
    this.video,
    this.countryName,
    this.countryId,
    this.languageName,
    this.languageId,
    this.videoHeight,
    this.videoWidth,
    this.likeIcon,
    this.dislikeIcon,
    this.numberOfLike,
    this.numberOfDislike,
    this.followData,
    this.totalComments,
    this.likeStatus,
    this.followStatus,
    this.dislikeStatus,
    this.userImage,
    this.timeStamp,
    this.shortcode,
    this.name,
    this.postContent,
    this.numViews,
    this.shareUrl,
    this.userID,
    this.totalVideos,
    this.content,
    this.videoTags,
    this.quality,
  });

  // var image;
  // var category;
  // var categoryIt;
  // var postId;
  // var video;
  // var videoHeight;
  // var videoWidth;
  // var likeIcon;
  // var dislikeIcon;
  // var numberOfLike;
  // var numberOfDislike;
  // var followData;
  // var totalComments;
  // var likeStatus;
  // var dislikeStatus;
  // var userImage;
  // var timeStamp;
  // var shortcode;
  // var name;
  // var quality;
  // var postContent;
  // var numViews;
  // var shareUrl;
  // var userID;
  // var totalVideos;
  // bool isSelected = false;
  // var countryName;
  // var countryId;
  // var languageName;
  // var languageId;
  // var content;
  // var videoTags;
  // TextEditingController embedController = TextEditingController();

  String? image;
  String? category;
  String? categoryIt;
  String? postId;
  String? video;
  int? videoHeight;
  int? videoWidth;
  String? likeIcon;
  String? dislikeIcon;
  int? numberOfLike;
  int? numberOfDislike;
  String? followData;
  int? totalComments;
  int? likeStatus;
  int? dislikeStatus;
  String? userImage;
  String? timeStamp;
  String? shortcode;
  String? name;
  String? quality;
  String? postContent;
  String? numViews;
  String? shareUrl;
  String? userID;
  int? totalVideos;
  bool? isSelected = false;
  String? countryName;
  String? countryId;
  String? languageName;
  String? languageId;
  String? content;
  String? videoTags;
  int? followStatus = 0;
  TextEditingController embedController = TextEditingController();

  // factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
  //   image: json["image"],
  //   quality : json["quality"],
  //   videoTags: json["video_tags"],
  //   content: json["post_content"],
  //   totalVideos: json["total_count"],
  //   userID: json["post_user_id"],
  //   shareUrl: json["video_url"],
  //   category: json["category"],
  //   categoryIt: json["category_it"],
  //   postId: json["post_id"],
  //   video: json["video"],
  //   countryName: json["country_name"],
  //   countryId: json["country_id"],
  //   languageName: json["language_name"],
  //   languageId: json["language_id"],
  //   videoHeight: json["post_video_height"],
  //   videoWidth: json["post_video_width"],
  //   likeIcon: json["post_like_icon"],
  //   dislikeIcon: json["dislike_icon"],
  //   numberOfLike: json["number_of_like"],
  //   numberOfDislike: json["number_of_dislike"],
  //   followData: json["follow_data"],
  //   totalComments: json["total_comments"],
  //   likeStatus: json["like_status"],
  //   dislikeStatus: json["dislike_status"],
  //   userImage: json["post_user_picture"],
  //   timeStamp: json["time_stamp"],
  //   shortcode: json["post_shortcode"],
  //   name: json["post_user_name"],
  //   postContent: json["post_content"],
  //   numViews: json["num_views"],
  // );

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
      image: json["image"],
      quality: json["quality"],
      videoTags: json["video_tags"].toString(),
      content: json["content"],
      totalVideos: json["total_count"] ?? 0,
      userID: json["post_user_id"].toString(),
      shareUrl: json["video"],
      category: json["category"],
      categoryIt: json["category_it"],
      postId: json["post_id"].toString(),
      video: json["video"],
      countryName: json["country_name"],
      countryId: json["country_id"].toString(),
      languageName: json["language_name"],
      languageId: json["language_id"].toString(),
      videoHeight: json["video_height"],
      videoWidth: json["video_width"],
      likeIcon: json["like_icon"],
      dislikeIcon: json["dislike_icon"],
      numberOfLike: json["number_of_like"],
      numberOfDislike: json["number_of_dislike"],
      followData: json["follow_data"].toString(),
      totalComments: json["total_comments"],
      likeStatus: json["like_status"] ?? false ? 1 : 0,
      dislikeStatus: json["dislike_status"] ?? false ? 1 : 0,
      userImage: json["user_image"],
      timeStamp: json["time_stamp"],
      shortcode: json["shortcode"],
      postContent: json["post_content"],
      numViews: json["num_views"].toString(),
      name: json["name"],
      followStatus: json['follow_status']);

  Map<String, dynamic> toJson() => {
        "video_url": shareUrl,
        "quality": quality,
        "total_count": totalVideos,
        "video_tags": videoTags,
        "post_user_id": userID,
        "content": content,
        "image": image,
        "category": category,
        "category_it": categoryIt,
        "country_name": countryName,
        "country_id": countryId,
        "language_name": languageName,
        "language_id": languageId,
        "post_id": postId,
        "video": video,
        "video_height": videoHeight,
        "video_width": videoWidth,
        "like_icon": likeIcon,
        "dislike_icon": dislikeIcon,
        "number_of_like": numberOfLike,
        "number_of_dislike": numberOfDislike,
        "follow_data": followData,
        "total_comments": totalComments,
        "like_status": likeStatus,
        "dislike_status": dislikeStatus,
        "user_image": userImage,
        "time_stamp": timeStamp,
        "shortcode": shortcode,
        "name": name,
        "post_content": postContent,
        "num_views": numViews,
      };
}

class Video {
  List<VideoModel> videos;

  Video(this.videos);
  factory Video.fromJson(List<dynamic> parsed) {
    List<VideoModel> videos = <VideoModel>[];
    videos = parsed.map((i) => VideoModel.fromJson(i)).toList();
    return new Video(videos);
  }
}
