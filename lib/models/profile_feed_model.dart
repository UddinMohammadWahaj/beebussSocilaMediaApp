import 'dart:convert';

import 'package:flutter/cupertino.dart';

// To parse this JSON data, do
//
//     final profileFeedModel = profileFeedModelFromJson(jsonString);

import 'dart:convert';

List<ProfileFeedModel> profileFeedModelFromJson(String str) =>
    List<ProfileFeedModel>.from(
        json.decode(str).map((x) => ProfileFeedModel.fromJson(x)));

String profileFeedModelToJson(List<ProfileFeedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileFeedModel {
  ProfileFeedModel({
    this.countLoop,
    this.postId,
    this.totalPages,
    this.postType,
    this.postUrl,
    this.postTotalComment,
    this.postTotalLikes,
    this.postVideoLogoTop,
    this.postVideoPlayLogo,
    this.postNumberOfViews,
    this.postLikeLogo,
    this.postUrlName,
    this.postDomainName,
    this.postDataLong,
    this.postDataLat,
    this.postAllImage,
    this.postAllImages,
    this.postVideo,
    this.postTaggedData,
    this.postTaggedDataDetails,
    this.postCommentData,
    this.postMemberId,
    this.dataMultiImage,
    this.timeStamp,
    this.postContent,
    this.postUserPicture,
    this.postRebuz,
    this.postRebuzData,
    this.postShortcode,
    this.postHeaderLocation,
    this.postVideoHeight,
    this.postVideoWidth,
    this.postImageWidth,
    this.postImageHeight,
  });

  int? countLoop;
  String? postId;
  dynamic? totalPages;
  String? postType;
  String? postUrl;
  String? postTotalComment;
  String? postTotalLikes;
  String? postVideoLogoTop;
  String? postVideoPlayLogo;
  String? postNumberOfViews;
  String? postLikeLogo;
  dynamic? postUrlName;
  dynamic? postDomainName;
  String? postDataLong;
  String? postDataLat;
  String? postAllImage;
  String? postAllImages;
  String? postVideo;
  dynamic? postTaggedData;
  String? postTaggedDataDetails;
  String? postCommentData;
  String? postMemberId;
  int? dataMultiImage;
  String? timeStamp;
  String? postContent;
  String? postUserPicture;
  int? postRebuz;
  String? postRebuzData;
  String? postShortcode;
  String? postHeaderLocation;
  int? postVideoHeight;
  int? postVideoWidth;
  int? postImageWidth;
  int? postImageHeight;
  int? pageIndex = 0;
  bool mute = true;
  bool? whiteHeartLogo = false;
  String? hasRebuzzed = "Rebuzz";
  bool? showUserTags = false;
  TextEditingController postUpdateController = TextEditingController();
  TextEditingController emberController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  factory ProfileFeedModel.fromJson(Map<String, dynamic> json) =>
      ProfileFeedModel(
        countLoop: json["count_loop"],
        postId: json["post_id"],
        totalPages: json["total_pages"],
        postType: json["post_type"],
        postUrl: json["post_url"],
        postTotalComment: json["post_total_comment"],
        postTotalLikes: json["post_total_likes"],
        postVideoLogoTop: json["post_video_logo_top"],
        postVideoPlayLogo: json["post_video_play_logo"],
        postNumberOfViews: json["post_number_of_views"],
        postLikeLogo: json["post_like_logo"],
        postUrlName: json["post_url_name"],
        postDomainName: json["post_domain_name"],
        postDataLong:
            json["post_data_long"] == null ? null : json["post_data_long"],
        postDataLat:
            json["post_data_lat"] == null ? null : json["post_data_lat"],
        postAllImage: json["post_all_image"],
        postAllImages: json["post_all_images"],
        postVideo: json["post_video"] == null ? null : json["post_video"],
        postTaggedData: json["post_tagged_data"],
        postTaggedDataDetails: json["post_tagged_data_details"],
        postCommentData: json["post_comment_data"],
        postMemberId: json["post_user_id"],
        dataMultiImage: json["data_multi_image"],
        timeStamp: json["time_stamp"],
        postContent: json["post_content"],
        postUserPicture: json["post_user_picture"],
        postRebuz: json["post_rebuz"],
        postRebuzData: json["post_rebuz_data"],
        postShortcode: json["post_shortcode"],
        postHeaderLocation: json["post_header_location"] == null
            ? null
            : json["post_header_location"],
        postVideoHeight: json["post_video_height"],
        postVideoWidth: json["post_video_width"],
        postImageWidth: json["post_image_width"],
        postImageHeight: json["post_image_height"],
      );

  Map<String, dynamic> toJson() => {
        "count_loop": countLoop,
        "post_id": postId,
        "total_pages": totalPages,
        "post_type": postType,
        "post_url": postUrl,
        "post_total_comment": postTotalComment,
        "post_total_likes": postTotalLikes,
        "post_video_logo_top": postVideoLogoTop,
        "post_video_play_logo": postVideoPlayLogo,
        "post_number_of_views": postNumberOfViews,
        "post_like_logo": postLikeLogo,
        "post_url_name": postUrlName,
        "post_domain_name": postDomainName,
        "post_data_long": postDataLong == null ? null : postDataLong,
        "post_data_lat": postDataLat == null ? null : postDataLat,
        "post_all_image": postAllImage,
        "post_all_images": postAllImages,
        "post_video": postVideo == null ? null : postVideo,
        "post_tagged_data": postTaggedData,
        "post_tagged_data_details": postTaggedDataDetails,
        "post_comment_data": postCommentData,
        "post_user_id": postMemberId,
        "data_multi_image": dataMultiImage,
        "time_stamp": timeStamp,
        "post_content": postContent,
        "post_user_picture": postUserPicture,
        "post_rebuz": postRebuz,
        "post_rebuz_data": postRebuzData,
        "post_shortcode": postShortcode,
        "post_header_location":
            postHeaderLocation == null ? null : postHeaderLocation,
        "post_video_height": postVideoHeight,
        "post_video_width": postVideoWidth,
        "post_image_width": postImageWidth,
        "post_image_height": postImageHeight,
      };
}

class ProfileFeeds {
  List<ProfileFeedModel> profileFeeds;

  ProfileFeeds(this.profileFeeds);

  factory ProfileFeeds.fromJson(List<dynamic> parsed) {
    List<ProfileFeedModel> profileFeeds = <ProfileFeedModel>[];
    profileFeeds = parsed.map((i) => ProfileFeedModel.fromJson(i)).toList();
    return new ProfileFeeds(profileFeeds);
  }
}
