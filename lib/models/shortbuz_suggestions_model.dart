// To parse this JSON data, do
//
//     final shorbuzSuggestionsModel = shorbuzSuggestionsModelFromJson(jsonString);

import 'dart:convert';

List<ShorbuzSuggestionsModel> shorbuzSuggestionsModelFromJson(String str) =>
    List<ShorbuzSuggestionsModel>.from(
        json.decode(str).map((x) => ShorbuzSuggestionsModel.fromJson(x)));

String shorbuzSuggestionsModelToJson(List<ShorbuzSuggestionsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShorbuzSuggestionsModel {
  ShorbuzSuggestionsModel({
    this.postId,
    this.timeStamp,
    this.boostData,
    this.boostedCount,
    this.video,
    this.color,
    this.boostedButton,
    this.boostedTitle,
    this.boostedLink,
    this.boostedDomain,
    this.boostedDescription,
    this.postDate,
    this.postContent,
    this.postPostbyuser,
    this.postPostonuser,
    this.postUserId,
    this.postUserFirstname,
    this.postUserLastname,
    this.postUserName,
    this.postUserPicture,
    this.postType,
    this.postNumViews,
    this.postCommentIcon,
    this.postTotalLikes,
    this.postTotalComments,
    this.postImgData,
    this.postVideoData,
    this.postVideoThumb,
    this.postHeaderImage,
    this.postHeaderUrl,
    this.postLikeIcon,
    this.postMultiImage,
    this.postRebuz,
    this.postRebuzData,
    this.postShortcode,
    this.postHeaderLocation,
    this.postUrlData,
    this.postUrlNam,
    this.postDomainName,
    this.postTaggedData,
    this.postTaggedDataDetails,
    this.postBlogCategory,
    this.postBlogData,
    this.postUrlToShare,
    this.postTotalReach,
    this.postTotalEngagement,
    this.postPromotePost,
    this.postViewInsight,
    this.postPromotedSlider,
    this.postCommentResult,
    this.postEmbedData,
    this.postVideoHeight,
    this.postVideoWidth,
    this.postVideoReso,
    this.postDataLong,
    this.postDataLat,
    this.blogId,
    this.blogContent,
    this.postImageWidth,
    this.postImageHeight,
  });

  String? postId;
  String? timeStamp;
  int? boostData;
  dynamic boostedCount;
  String? video;
  dynamic color;
  String? boostedButton;
  String? boostedTitle;
  String? boostedLink;
  String? boostedDomain;
  String? boostedDescription;
  DateTime? postDate;
  String? postContent;
  String? postPostbyuser;
  String? postPostonuser;
  String? postUserId;
  String? postUserFirstname;
  String? postUserLastname;
  String? postUserName;
  String? postUserPicture;
  dynamic postType;
  String? postNumViews;
  String? postCommentIcon;
  dynamic postTotalLikes;
  int? postTotalComments;
  String? postImgData;
  String? postVideoData;
  String? postVideoThumb;
  String? postHeaderImage;
  String? postHeaderUrl;
  String? postLikeIcon;
  int? postMultiImage;
  int? postRebuz;
  String? postRebuzData;
  String? postShortcode;
  String? postHeaderLocation;
  dynamic postUrlData;
  dynamic postUrlNam;
  dynamic postDomainName;
  int? postTaggedData;
  String? postTaggedDataDetails;
  String? postBlogCategory;
  String? postBlogData;
  String? postUrlToShare;
  dynamic postTotalReach;
  dynamic postTotalEngagement;
  String? postPromotePost;
  String? postViewInsight;
  int? postPromotedSlider;
  dynamic postCommentResult;
  String? postEmbedData;
  int? postVideoHeight;
  int? postVideoWidth;
  String? postVideoReso;
  dynamic postDataLong;
  dynamic postDataLat;
  dynamic blogId;
  dynamic blogContent;
  dynamic postImageWidth;
  dynamic postImageHeight;

  factory ShorbuzSuggestionsModel.fromJson(Map<String, dynamic> json) =>
      ShorbuzSuggestionsModel(
        postId: json["post_id"].toString(),
        timeStamp: json["time_stamp"],
        boostData: json["boost_data"],
        boostedCount: json["boosted_count"],
        video: json["video"],
        color: json["color"],
        boostedButton: json["boosted_button"],
        boostedTitle: json["boosted_title"],
        boostedLink: json["boosted_link"],
        boostedDomain: json["boosted_domain"],
        boostedDescription: json["boosted_description"],
        postDate: DateTime.parse(json["post_date"]),
        postContent: json["post_content"],
        postPostbyuser: json["post_postbyuser"].toString(),
        postPostonuser: json["post_postonuser"].toString(),
        postUserId: json["post_user_id"].toString(),
        postUserFirstname: json["post_user_firstname"],
        postUserLastname: json["post_user_lastname"],
        postUserName: json["post_user_name"],
        postUserPicture: json["post_user_picture"],
        postType: json["post_type"],
        postNumViews: json["post_num_views"].toString(),
        postCommentIcon: json["post_comment_icon"],
        postTotalLikes: json["post_total_likes"],
        postTotalComments: json["post_total_comments"],
        postImgData: json["post_img_data"],
        postVideoData: json["post_video_data"],
        postVideoThumb: json["post_video_thumb"],
        postHeaderImage: json["post_header_image"],
        postHeaderUrl: json["post_header_url"],
        postLikeIcon: json["post_like_icon"],
        postMultiImage: json["post_multi_image"],
        postRebuz: json["post_rebuz"],
        postRebuzData: json["post_rebuz_data"],
        postShortcode: json["post_shortcode"],
        postHeaderLocation: json["post_header_location"],
        postUrlData: json["post_url_data"],
        postUrlNam: json["post_url_nam"],
        postDomainName: json["post_domain_name"],
        postTaggedData: json["post_tagged_data"],
        postTaggedDataDetails: json["post_tagged_data_details"],
        postBlogCategory: json["post_blog_category"],
        postBlogData: json["post_blog_data"],
        postUrlToShare: json["post_url_to_share"],
        postTotalReach: json["post_total_reach"],
        postTotalEngagement: json["post_total_engagement"],
        postPromotePost: json["post_promote_post"],
        postViewInsight: json["post_view_insight"],
        postPromotedSlider: json["post_promoted_slider"],
        postCommentResult: json["post_comment_result"],
        postEmbedData: json["post_embed_data"],
        postVideoHeight: json["post_video_height"],
        postVideoWidth: json["post_video_width"],
        postVideoReso: json["post_video_reso"],
        postDataLong: json["post_data_long"],
        postDataLat: json["post_data_lat"],
        blogId: json["blog_id"].toString(),
        blogContent: json["blog_content"],
        postImageWidth: json["post_image_width"],
        postImageHeight: json["post_image_height"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "time_stamp": timeStamp,
        "boost_data": boostData,
        "boosted_count": boostedCount,
        "video": video,
        "color": color,
        "boosted_button": boostedButton,
        "boosted_title": boostedTitle,
        "boosted_link": boostedLink,
        "boosted_domain": boostedDomain,
        "boosted_description": boostedDescription,
        "post_date": postDate!.toIso8601String(),
        "post_content": postContent,
        "post_postbyuser": postPostbyuser,
        "post_postonuser": postPostonuser,
        "post_user_id": postUserId,
        "post_user_firstname": postUserFirstname,
        "post_user_lastname": postUserLastname,
        "post_user_name": postUserName,
        "post_user_picture": postUserPicture,
        "post_type": postType,
        "post_num_views": postNumViews,
        "post_comment_icon": postCommentIcon,
        "post_total_likes": postTotalLikes,
        "post_total_comments": postTotalComments,
        "post_img_data": postImgData,
        "post_video_data": postVideoData,
        "post_video_thumb": postVideoThumb,
        "post_header_image": postHeaderImage,
        "post_header_url": postHeaderUrl,
        "post_like_icon": postLikeIcon,
        "post_multi_image": postMultiImage,
        "post_rebuz": postRebuz,
        "post_rebuz_data": postRebuzData,
        "post_shortcode": postShortcode,
        "post_header_location": postHeaderLocation,
        "post_url_data": postUrlData,
        "post_url_nam": postUrlNam,
        "post_domain_name": postDomainName,
        "post_tagged_data": postTaggedData,
        "post_tagged_data_details": postTaggedDataDetails,
        "post_blog_category": postBlogCategory,
        "post_blog_data": postBlogData,
        "post_url_to_share": postUrlToShare,
        "post_total_reach": postTotalReach,
        "post_total_engagement": postTotalEngagement,
        "post_promote_post": postPromotePost,
        "post_view_insight": postViewInsight,
        "post_promoted_slider": postPromotedSlider,
        "post_comment_result": postCommentResult,
        "post_embed_data": postEmbedData,
        "post_video_height": postVideoHeight,
        "post_video_width": postVideoWidth,
        "post_video_reso": postVideoReso,
        "post_data_long": postDataLong,
        "post_data_lat": postDataLat,
        "blog_id": blogId,
        "blog_content": blogContent,
        "post_image_width": postImageWidth,
        "post_image_height": postImageHeight,
      };
}

class ShortbuzSuggestions {
  List<ShorbuzSuggestionsModel> videos;

  ShortbuzSuggestions(this.videos);

  factory ShortbuzSuggestions.fromJson(List<dynamic> parsed) {
    List<ShorbuzSuggestionsModel> videos = <ShorbuzSuggestionsModel>[];
    videos = parsed.map((i) => ShorbuzSuggestionsModel.fromJson(i)).toList();
    return new ShortbuzSuggestions(videos);
  }
}
