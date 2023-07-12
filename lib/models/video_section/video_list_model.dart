import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class VideoListModel {
  int? success;
  int? status;
  String? message;
  List<VideoListModelData>? data;

  VideoListModel({this.success, this.status, this.message, this.data});

  VideoListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VideoListModelData>[];
      json['data'].forEach((v) {
        data!.add(new VideoListModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoListModelData {
  int? postId;
  String? category;
  String? categoryIt;
  String? image;
  String? video;
  int? videoHeight;
  int? videoWidth;
  String? likeIcon;
  bool? likeStatus;
  String? dislikeIcon;
  bool? dislikeStatus;
  int? numberOfLike;
  int? numberOfDislike;
  String? followData;
  int? totalComments;
  String? userId;
  String? name;
  String? shortcode;
  String? userImage;
  String? quality;
  String? postDate;
  String? postContent;
  String? numViews;
  String? shareUrl;
  int? totalVideos;
  String? countryId;
  String? countryName;
  String? languageId;
  String? languageName;
  String? content;
  String? videoTags;
  String? timeStamp;
  bool? isSelected = false;
  String? smallImageData = '';
  int? followStatus = 0;
  TextEditingController embedController = TextEditingController();

  VideoListModelData(
      {this.postId,
      this.category,
      this.categoryIt,
      this.image,
      this.video,
      this.videoHeight,
      this.videoWidth,
      this.likeIcon,
      this.likeStatus,
      this.dislikeIcon,
      this.dislikeStatus,
      this.numberOfLike,
      this.numberOfDislike,
      this.followStatus,
      this.followData,
      this.totalComments,
      this.userId,
      this.name,
      this.shortcode,
      this.userImage,
      this.quality,
      this.postContent,
      this.numViews,
      this.shareUrl,
      this.totalVideos,
      this.countryId,
      this.countryName,
      this.languageId,
      this.languageName,
      this.content,
      this.videoTags,
      this.smallImageData,
      this.timeStamp});

  VideoListModelData.fromJson(Map<String, dynamic> json) {
    postId = int.parse(json['post_id'].toString());
    category = json['category'];
    categoryIt = json['category_it'];
    image = json['image'];
    video = json['video'];
    videoHeight = json['video_height'];
    videoWidth = json['video_width'];
    likeIcon = json['like_icon'];
    likeStatus = (json['like_status'] is bool)
        ? json['like_status']
        : json['like_status'] == 1
            ? true
            : false;
    dislikeIcon = json['dislike_icon'];
    dislikeStatus = (json['dislike_status'] is bool)
        ? json['dislike_status']
        : json['dislike_status'] == 1
            ? true
            : false;
    followStatus = json['follow_status'];
    numberOfLike = json['number_of_like'];
    numberOfDislike = json['number_of_dislike'];
    followData = json['follow_data'].toString();
    totalComments = json['total_comments'];
    userId = json['user_id'].toString();
    name = json['name'];
    shortcode = json['shortcode'];
    userImage = json['user_image'];
    quality = json['quality'];
    postContent = json['post_content'];
    numViews = json['num_views'].toString();
    shareUrl = json['share_url'];
    totalVideos = json['total_videos'];
    countryId = json['country_id'].toString();
    countryName = json['country_name'];
    languageId = json['language_id'].toString();
    languageName = json['language_name'];
    content = json['content'];
    videoTags = json['video_tags'];
    timeStamp = json['time_stamp'];
    smallImageData = json['image_small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_small'] = this.smallImageData;
    data['post_id'] = this.postId;
    data['category'] = this.category;
    data['category_it'] = this.categoryIt;
    data['image'] = this.image;
    data['video'] = this.video;
    data['video_height'] = this.videoHeight;
    data['video_width'] = this.videoWidth;
    data['like_icon'] = this.likeIcon;
    data['like_status'] = this.likeStatus;
    data['follow_status'] = this.followStatus;
    data['dislike_icon'] = this.dislikeIcon;
    data['dislike_status'] = this.dislikeStatus;
    data['number_of_like'] = this.numberOfLike;
    data['number_of_dislike'] = this.numberOfDislike;
    data['follow_data'] = this.followData;
    data['total_comments'] = this.totalComments;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['shortcode'] = this.shortcode;
    data['user_image'] = this.userImage;
    data['quality'] = this.quality;
    data['post_content'] = this.postContent;
    data['num_views'] = this.numViews;
    data['share_url'] = this.shareUrl;
    data['total_videos'] = this.totalVideos;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['language_id'] = this.languageId;
    data['language_name'] = this.languageName;
    data['content'] = this.content;
    data['video_tags'] = this.videoTags;
    data['time_stamp'] = this.timeStamp;
    return data;
  }
}
