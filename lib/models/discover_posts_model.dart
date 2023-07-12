// To parse this JSON data, do
//
//     final discoverPostsModel = discoverPostsModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<DiscoverPostsModel> discoverPostsModelFromJson(String str) =>
    List<DiscoverPostsModel>.from(
        json.decode(str).map((x) => DiscoverPostsModel.fromJson(x)));

String discoverPostsModelToJson(List<DiscoverPostsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscoverPostsModel {
  DiscoverPostsModel({
    this.countLoop,
    this.postId,
    this.boostData,
    this.shortVideo,
    this.boostedCount,
    this.video,
    this.color,
    this.boostedButton,
    this.boostedTitle,
    this.boostedLink,
    this.boostedDomain,
    this.boostedDescription,
    this.imageWidth,
    this.imageHeight,
    this.postVideoData,
    this.postPostbyuser,
    this.postPostonuser,
    this.postDate,
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
    this.postAllImage,
    this.postAllImages,
    this.postImgData,
    this.postUserFirstname,
    this.postUserLastname,
    this.postUserName,
    this.postVideoThumb,
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
    this.postTaggedData,
    this.postTaggedDataDetails,
    this.postDataLong,
    this.postDataLat,
    this.postTotalComments,
    this.postVideoHeight,
    this.postVideoWidth,
    this.postVideoReso,
  });

  int? countLoop;
  String? postId;
  int? boostData;
  int? shortVideo;
  int? boostedCount;
  String? video;
  dynamic color;
  String? boostedButton;
  String? boostedTitle;
  String? boostedLink;
  String? boostedDomain;
  String? boostedDescription;
  int? imageWidth;
  int? imageHeight;
  String? postVideoData;
  String? postPostbyuser;
  String? postPostonuser;
  DateTime? postDate;
  int? totalPages;
  dynamic postType;
  String? postUrl;
  String? postTotalComment;
  String? postTotalLikes;
  String? postVideoLogoTop;
  String? postVideoPlayLogo;
  dynamic postNumberOfViews;
  String? postLikeLogo;
  String? postLikeIcon;
  String? postUrlName;
  String? postDomainName;
  dynamic postNumViews;
  String? postAllImage;
  String? postAllImages;
  String? postImgData;
  String? postUserFirstname;
  String? postUserLastname;
  String? postUserName;
  String? postVideoThumb;
  dynamic postCommentData;
  String? postMemberId;
  int? dataMultiImage;
  int? postMultiImage;
  String? postHeaderImage;
  String? timeStamp;
  String? postContent;
  String? postUserPicture;
  int? postRebuz;
  String? postRebuzData;
  String? postShortcode;
  dynamic postHeaderLocation;
  dynamic postTaggedData;
  dynamic postTaggedDataDetails;
  dynamic postDataLong;
  dynamic postDataLat;
  int? postTotalComments;
  int? postVideoHeight;
  int? postVideoWidth;
  dynamic postVideoReso;

  int? long = 0;
  int? pageIndex = 0;
  bool? mute = true;
  bool? whiteHeartLogo = false;
  String? hasRebuzzed = "Rebuzz";
  bool? showUserTags = false;
  TextEditingController postUpdateController = TextEditingController();
  TextEditingController emberController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  factory DiscoverPostsModel.fromJson(Map<String, dynamic> json) =>
      DiscoverPostsModel(
        countLoop: json["count_loop"],
        postId: json["post_id"],
        boostData: json["boost_data"],
        shortVideo: json["short_video"],
        boostedCount: json["boosted_count"],
        video: json["video"],
        color: json["color"],
        boostedButton: json["boosted_button"],
        boostedTitle: json["boosted_title"],
        boostedLink: json["boosted_link"],
        boostedDomain: json["boosted_domain"],
        boostedDescription: json["boosted_description"],
        imageWidth: json["image_width"],
        imageHeight: json["image_height"],
        postVideoData: json["post_video_data"],
        postPostbyuser: json["post_postbyuser"],
        postPostonuser: json["post_postonuser"],
        postDate: DateTime.parse(json["post_date"]),
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
        postAllImage: json["post_all_image"],
        postAllImages: json["post_all_images"],
        postImgData: json["post_img_data"],
        postUserFirstname: json["post_user_firstname"],
        postUserLastname: json["post_user_lastname"],
        postUserName: json["post_user_name"],
        postVideoThumb: json["post_video_thumb"],
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
        postHeaderLocation: json["post_header_location"],
        postTaggedData: json["post_tagged_data"],
        postTaggedDataDetails: json["post_tagged_data_details"],
        postDataLong: json["post_data_long"],
        postDataLat: json["post_data_lat"],
        postTotalComments: json["post_total_comments"],
        postVideoHeight: json["post_video_height"] == null
            ? null
            : json["post_video_height"],
        postVideoWidth:
            json["post_video_width"] == null ? null : json["post_video_width"],
        postVideoReso: json["post_video_reso"],
      );

  Map<String, dynamic> toJson() => {
        "count_loop": countLoop,
        "post_id": postId,
        "boost_data": boostData,
        "short_video": shortVideo,
        "boosted_count": boostedCount,
        "video": video,
        "color": color,
        "boosted_button": boostedButton,
        "boosted_title": boostedTitle,
        "boosted_link": boostedLink,
        "boosted_domain": boostedDomain,
        "boosted_description": boostedDescription,
        "image_width": imageWidth,
        "image_height": imageHeight,
        "post_video_data": postVideoData,
        "post_postbyuser": postPostbyuser,
        "post_postonuser": postPostonuser,
        "post_date": postDate!.toIso8601String(),
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
        "post_all_image": postAllImage,
        "post_all_images": postAllImages,
        "post_img_data": postImgData,
        "post_user_firstname": postUserFirstname,
        "post_user_lastname": postUserLastname,
        "post_user_name": postUserName,
        "post_video_thumb": postVideoThumb,
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
        "post_header_location": postHeaderLocation,
        "post_tagged_data": postTaggedData,
        "post_tagged_data_details": postTaggedDataDetails,
        "post_data_long": postDataLong,
        "post_data_lat": postDataLat,
        "post_total_comments": postTotalComments,
        "post_video_height": postVideoHeight == null ? null : postVideoHeight,
        "post_video_width": postVideoWidth == null ? null : postVideoWidth,
        "post_video_reso": postVideoReso,
      };
}

class DiscoverPosts {
  List<DiscoverPostsModel> discoverPosts;

  DiscoverPosts(this.discoverPosts);
  factory DiscoverPosts.fromJson(List<dynamic> parsed) {
    List<DiscoverPostsModel> discoverPosts = <DiscoverPostsModel>[];
    discoverPosts = parsed.map((i) => DiscoverPostsModel.fromJson(i)).toList();
    return new DiscoverPosts(discoverPosts);
  }
}
