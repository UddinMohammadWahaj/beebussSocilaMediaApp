// To parse this JSON data, do
//
//     final discoverFeedModel = discoverFeedModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<DiscoverFeedModel> discoverFeedModelFromJson(String str) =>
    List<DiscoverFeedModel>.from(
        json.decode(str).map((x) => DiscoverFeedModel.fromJson(x)));

String discoverFeedModelToJson(List<DiscoverFeedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscoverFeedModel {
  DiscoverFeedModel(
      {this.postId,
      this.postLikeIcon,
      this.totalPages,
      this.postDate,
      this.postPostbyuser,
      this.postPostonuser,
      this.postUserId,
      this.postUserFirstname,
      this.postUserLastname,
      this.postUserName,
      this.postUserPicture,
      this.postType,
      this.postUrl,
      this.postNumViews,
      this.postTotalComment,
      this.postTotalLikes,
      this.postVideoLogoTop,
      this.postVideoPlayLogo,
      this.postNumberOfViews,
      this.postLikeLogo,
      this.postUrlName,
      this.postAllImage,
      this.postCommentIcon,
      this.postAllImages,
      this.postTotalComments,
      this.postImgData,
      this.postHeaderUrl,
      this.postHeaderImage,
      this.postCommentResult,
      this.postMemberId,
      this.postMultiImage,
      this.postUrlData,
      this.postUrlNam,
      this.postDomainName,
      this.postTaggedData,
      this.postTaggedDataDetails,
      this.postUrlToShare,
      this.postEmbedData,
      this.timeStamp,
      this.postContent,
      this.postRebuz,
      this.postRebuzData,
      this.postShortcode,
      this.postHeaderLocation,
      this.postTotalReach,
      this.postTotalEngagement,
      this.postPromotePost,
      this.postViewInsight,
      this.postPromotedSlider,
      this.postDataLong,
      this.postDataLat,
      this.postImageWidth,
      this.postImageHeight,
      this.video,
      this.boostedLink,
      this.boostedTitle,
      this.color,
      this.boostedDescription,
      this.boostData,
      this.boostButton});

  String? postId;
  String? video;
  String? postLikeIcon;
  int? totalPages;
  DateTime? postDate;
  String? postPostbyuser;
  String? postPostonuser;
  String? postUserId;
  String? postUserFirstname;
  dynamic postUserLastname;
  String? postUserName;
  String? postUserPicture;
  dynamic postType;
  String? postUrl;
  int? boostData;
  dynamic postNumViews;
  String? postTotalComment;
  dynamic postTotalLikes;
  String? postVideoLogoTop;
  String? postVideoPlayLogo;
  dynamic postNumberOfViews;
  String? postLikeLogo;
  String? postUrlName;
  String? postAllImage;
  String? boostButton;
  String? postCommentIcon;
  String? postAllImages;
  int? postTotalComments;
  String? postImgData;
  String? postHeaderUrl;
  String? postHeaderImage;
  dynamic postCommentResult;
  String? postMemberId;
  int? postMultiImage;
  dynamic postUrlData;
  String? postUrlNam;
  String? postDomainName;
  dynamic postTaggedData;
  String? postTaggedDataDetails;
  dynamic postUrlToShare;
  dynamic postEmbedData;
  String? timeStamp;
  String? postContent;
  int? postRebuz;
  String? postRebuzData;
  String? postShortcode;
  String? postHeaderLocation;
  dynamic postTotalReach;
  dynamic postTotalEngagement;
  String? postPromotePost;
  String? postViewInsight;
  int? postPromotedSlider;
  String? postDataLong;
  String? postDataLat;
  int? postImageWidth;
  int? postImageHeight;
  String? color;
  String? boostedTitle;
  String? boostedLink;
  String? boostedDescription;
  int? pageIndex = 0;
  bool? mute = true;
  bool? whiteHeartLogo = false;
  String? hasRebuzzed = "Rebuzz";
  bool? showUserTags = false;
  TextEditingController postUpdateController = TextEditingController();
  TextEditingController emberController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  factory DiscoverFeedModel.fromJson(Map<String, dynamic> json) =>
      DiscoverFeedModel(
        postId: json["post_id"],
        boostButton: json["boosted_button"],
        boostData: json["boost_data"],
        boostedTitle: json["boosted_title"],
        boostedLink: json["boosted_link"],
        video: json['video'],
        postLikeIcon: json["post_like_icon"],
        totalPages: json["total_pages"],
        color: json["color"],
        boostedDescription: json["boosted_description"],
        postDate: DateTime.parse(json["post_date"]),
        postPostbyuser: json["post_postbyuser"],
        postPostonuser: json["post_postonuser"],
        postUserId: json["post_user_id"],
        postUserFirstname: json["post_user_firstname"],
        postUserLastname: json["post_user_lastname"],
        postUserName: json["post_user_name"],
        postUserPicture: json["post_user_picture"],
        postType: json["post_type"],
        postUrl: json["post_url"],
        postNumViews: json["post_num_views"],
        postTotalComment: json["post_total_comment"],
        postTotalLikes: json["post_total_likes"],
        postVideoLogoTop: json["post_video_logo_top"],
        postVideoPlayLogo: json["post_video_play_logo"],
        postNumberOfViews: json["post_number_of_views"],
        postLikeLogo: json["post_like_logo"],
        postUrlName: json["post_url_name"],
        postAllImage: json["post_all_image"],
        postCommentIcon: json["post_comment_icon"],
        postAllImages: json["post_all_images"],
        postTotalComments: json["post_total_comments"],
        postImgData: json["post_img_data"],
        postHeaderUrl: json["post_header_url"],
        postHeaderImage: json["post_header_image"],
        postCommentResult: json["post_comment_result"],
        postMemberId: json["post_user_id"],
        postMultiImage: json["post_multi_image"],
        postUrlData: json["post_url_data"],
        postUrlNam: json["post_url_nam"],
        postDomainName: json["post_domain_name"],
        postTaggedData: json["post_tagged_data"],
        postTaggedDataDetails: json["post_tagged_data_details"],
        postUrlToShare: json["post_url_to_share"],
        postEmbedData: json["post_embed_data"],
        timeStamp: json["time_stamp"],
        postContent: json["post_content"],
        postRebuz: json["post_rebuz"],
        postRebuzData: json["post_rebuz_data"],
        postShortcode: json["post_shortcode"],
        postHeaderLocation: json["post_header_location"],
        postTotalReach: json["post_total_reach"],
        postTotalEngagement: json["post_total_engagement"],
        postPromotePost: json["post_promote_post"],
        postViewInsight: json["post_view_insight"],
        postPromotedSlider: json["post_promoted_slider"],
        postDataLong: json["post_data_long"],
        postDataLat: json["post_data_lat"],
        postImageWidth: json["post_image_width"],
        postImageHeight: json["post_image_height"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "boosted_button": boostButton,
        "video": video,
        "boosted_title": boostedTitle,
        "boosted_link": boostedLink,
        "color": color,
        "boosted_description": boostedDescription,
        "post_like_icon": postLikeIcon,
        "total_pages": totalPages,
        "post_date": postDate!.toIso8601String(),
        "post_postbyuser": postPostbyuser,
        "post_postonuser": postPostonuser,
        "post_user_id": postUserId,
        "post_user_firstname": postUserFirstname,
        "post_user_lastname": postUserLastname,
        "post_user_name": postUserName,
        "post_user_picture": postUserPicture,
        "post_type": postType,
        "post_url": postUrl,
        "boost_data": boostData,
        "post_num_views": postNumViews,
        "post_total_comment": postTotalComment,
        "post_total_likes": postTotalLikes,
        "post_video_logo_top": postVideoLogoTop,
        "post_video_play_logo": postVideoPlayLogo,
        "post_number_of_views": postNumberOfViews,
        "post_like_logo": postLikeLogo,
        "post_url_name": postUrlName,
        "post_all_image": postAllImage,
        "post_comment_icon": postCommentIcon,
        "post_all_images": postAllImages,
        "post_total_comments": postTotalComments,
        "post_img_data": postImgData,
        "post_header_url": postHeaderUrl,
        "post_header_image": postHeaderImage,
        "post_comment_result": postCommentResult,
        "post_user_id": postMemberId,
        "post_multi_image": postMultiImage,
        "post_url_data": postUrlData,
        "post_url_nam": postUrlNam,
        "post_domain_name": postDomainName,
        "post_tagged_data": postTaggedData,
        "post_tagged_data_details": postTaggedDataDetails,
        "post_url_to_share": postUrlToShare,
        "post_embed_data": postEmbedData,
        "time_stamp": timeStamp,
        "post_content": postContent,
        "post_rebuz": postRebuz,
        "post_rebuz_data": postRebuzData,
        "post_shortcode": postShortcode,
        "post_header_location": postHeaderLocation,
        "post_total_reach": postTotalReach,
        "post_total_engagement": postTotalEngagement,
        "post_promote_post": postPromotePost,
        "post_view_insight": postViewInsight,
        "post_promoted_slider": postPromotedSlider,
        "post_data_long": postDataLong,
        "post_data_lat": postDataLat,
        "post_image_width": postImageWidth,
        "post_image_height": postImageHeight,
      };
}

class DiscoverFeeds {
  List<DiscoverFeedModel> discoverFeeds;

  DiscoverFeeds(this.discoverFeeds);

  factory DiscoverFeeds.fromJson(List<dynamic> parsed) {
    List<DiscoverFeedModel> discoverFeeds = <DiscoverFeedModel>[];
    discoverFeeds = parsed.map((i) => DiscoverFeedModel.fromJson(i)).toList();
    return new DiscoverFeeds(discoverFeeds);
  }
}
