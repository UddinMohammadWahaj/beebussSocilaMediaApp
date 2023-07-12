// To parse this JSON data, do
//
//     final horizontalVideoModel = horizontalVideoModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<ProfilePostModel> horizontalVideoModelFromJson(String str) =>
    List<ProfilePostModel>.from(
        json.decode(str).map((x) => ProfilePostModel.fromJson(x)));

String horizontalVideoModelToJson(List<ProfilePostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfilePostModel {
  ProfilePostModel({
    this.countLoop,
    this.postId,
    this.shortVideo,
    this.video,
    this.totalPages,
    this.postType,
    this.postUrl,
    this.postTotalComment,
    this.postTotalLikes,
    this.postVideoLogoTop,
    this.postVideoPlayLogo,
    this.postNumberOfViews,
    this.postLikeLogo,
    this.postLikeIcon,
    this.postUrlName,
    this.postDomainName,
    this.postNumViews,
    this.postDataLong,
    this.postDataLat,
    this.postAllImage,
    this.postAllImages,
    this.postImgData,
    this.postVideo,
    this.postUserFirstname,
    this.postUserLastname,
    this.postUserName,
    this.postVideoThumb,
    this.postTaggedData,
    this.postTaggedDataDetails,
    this.postCommentData,
    this.postMemberId,
    this.dataMultiImage,
    this.postMultiImage,
    this.postHeaderImage,
    this.timeStamp,
    this.postContent,
    this.postUserPicture,
    this.postRebuz,
    this.postRebuzData,
    this.postShortcode,
    this.postHeaderLocation,
    this.postTotalComments,
    this.postVideoHeight,
    this.postVideoWidth,
    this.postImageWidth,
    this.postImageHeight,
  });

  int? countLoop;
  String? postId;
  int? shortVideo;
  String? video;
  dynamic totalPages;
  dynamic postType;
  String? postUrl;
  String? postTotalComment;
  String? postTotalLikes;
  String? postVideoLogoTop;
  String? postVideoPlayLogo;
  String? postNumberOfViews;
  String? postLikeLogo;
  String? postLikeIcon;
  String? postUrlName;
  String? postDomainName;
  String? postNumViews;
  String? postDataLong;
  String? postDataLat;
  String? postAllImage;
  String? postAllImages;
  String? postImgData;
  String? postVideo;
  dynamic? postUserFirstname;
  String? postUserLastname;
  dynamic postUserName;
  String? postVideoThumb;
  dynamic postTaggedData;
  String? postTaggedDataDetails;
  dynamic postCommentData;
  String? postMemberId;
  int? dataMultiImage;
  int? postMultiImage;
  String? postHeaderImage;
  String? timeStamp;
  String? postContent;
  String? postUserPicture;
  int? postRebuz;
  dynamic postRebuzData;
  dynamic postShortcode;
  String? postHeaderLocation;
  int? postTotalComments;
  int? postVideoHeight;
  int? postVideoWidth;
  int? postImageWidth;
  int? postImageHeight;

  int? long = 0;
  int? pageIndex = 0;
  bool? mute = true;
  bool? whiteHeartLogo = false;
  String? hasRebuzzed = "Rebuzz";
  bool? showUserTags = false;
  TextEditingController postUpdateController = TextEditingController();
  TextEditingController emberController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  factory ProfilePostModel.fromJson(Map<String, dynamic> json) =>
      ProfilePostModel(
        countLoop: json["count_loop"],
        postId: json["post_id"],
        shortVideo: json["short_video"] == null ? null : json["short_video"],
        video: json["video"] == null ? null : json["video"],
        totalPages: json["total_pages"],
        postType: json["post_type"],
        postUrl: json["post_url"],
        postTotalComment: json["post_total_comment"],
        postTotalLikes: json["post_total_likes"],
        postVideoLogoTop: json["post_video_logo_top"],
        postVideoPlayLogo: json["post_video_play_logo"],
        postNumberOfViews: json["post_number_of_views"],
        postLikeLogo: json["post_like_logo"],
        postLikeIcon: json["post_like_icon"],
        postUrlName: json["post_url_name"],
        postDomainName: json["post_domain_name"],
        postNumViews: json["post_num_views"],
        postDataLong:
            json["post_data_long"] == null ? null : json["post_data_long"],
        postDataLat:
            json["post_data_lat"] == null ? null : json["post_data_lat"],
        postAllImage: json["post_all_image"],
        postAllImages: json["post_all_images"],
        postImgData: json["post_img_data"],
        postVideo: json["post_video"] == null ? null : json["post_video"],
        postUserFirstname: json["post_user_firstname"],
        postUserLastname: json["post_user_lastname"],
        postUserName: json["post_user_name"],
        postVideoThumb: json["post_video_thumb"],
        postTaggedData: json["post_tagged_data"],
        postTaggedDataDetails: json["post_tagged_data_details"],
        postCommentData: json["post_comment_data"],
        postMemberId: json["post_user_id"],
        dataMultiImage: json["data_multi_image"],
        postMultiImage: json["post_multi_image"],
        postHeaderImage: json["post_header_image"],
        timeStamp: json["time_stamp"],
        postContent: json["post_content"],
        postUserPicture: json["post_user_picture"],
        postRebuz: json["post_rebuz"],
        postRebuzData: json["post_rebuz_data"],
        postShortcode: json["post_shortcode"],
        postHeaderLocation: json["post_header_location"] == null
            ? null
            : json["post_header_location"],
        postTotalComments: json["post_total_comments"],
        postVideoHeight: json["post_video_height"],
        postVideoWidth: json["post_video_width"],
        postImageWidth: json["post_image_width"],
        postImageHeight: json["post_image_height"],
      );

  Map<String, dynamic> toJson() => {
        "count_loop": countLoop,
        "post_id": postId,
        "short_video": shortVideo == null ? null : shortVideo,
        "video": video == null ? null : video,
        "total_pages": totalPages,
        "post_type": postType,
        "post_url": postUrl,
        "post_total_comment": postTotalComment,
        "post_total_likes": postTotalLikes,
        "post_video_logo_top": postVideoLogoTop,
        "post_video_play_logo": postVideoPlayLogo,
        "post_number_of_views": postNumberOfViews,
        "post_like_logo": postLikeLogo,
        "post_like_icon": postLikeIcon,
        "post_url_name": postUrlName,
        "post_domain_name": postDomainName,
        "post_num_views": postNumViews,
        "post_data_long": postDataLong == null ? null : postDataLong,
        "post_data_lat": postDataLat == null ? null : postDataLat,
        "post_all_image": postAllImage,
        "post_all_images": postAllImages,
        "post_img_data": postImgData,
        "post_video": postVideo == null ? null : postVideo,
        "post_user_firstname": postUserFirstname,
        "post_user_lastname": postUserLastname,
        "post_user_name": postUserName,
        "post_video_thumb": postVideoThumb,
        "post_tagged_data": postTaggedData,
        "post_tagged_data_details": postTaggedDataDetails,
        "post_comment_data": postCommentData,
        "post_user_id": postMemberId,
        "data_multi_image": dataMultiImage,
        "post_multi_image": postMultiImage,
        "post_header_image": postHeaderImage,
        "time_stamp": timeStamp,
        "post_content": postContent,
        "post_user_picture": postUserPicture,
        "post_rebuz": postRebuz,
        "post_rebuz_data": postRebuzData,
        "post_shortcode": postShortcode,
        "post_header_location":
            postHeaderLocation == null ? null : postHeaderLocation,
        "post_total_comments": postTotalComments,
        "post_video_height": postVideoHeight,
        "post_video_width": postVideoWidth,
        "post_image_width": postImageWidth,
        "post_image_height": postImageHeight,
      };
}

class ProfilePosts {
  List<ProfilePostModel> posts;

  ProfilePosts(this.posts);
  factory ProfilePosts.fromJson(List<dynamic> parsed) {
    List<ProfilePostModel> posts = <ProfilePostModel>[];
    posts = parsed.map((i) => ProfilePostModel.fromJson(i)).toList();
    return new ProfilePosts(posts);
  }
}
