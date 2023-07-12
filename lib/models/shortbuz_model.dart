// To parse this JSON data, do
//
//     final shortbuzModel = shortbuzModelFromJson(jsonString);

import 'dart:convert';

List<ShortbuzModel> shortbuzModelFromJson(String str) =>
    List<ShortbuzModel>.from(
        json.decode(str).map((x) => ShortbuzModel.fromJson(x)));

String shortbuzModelToJson(List<ShortbuzModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShortbuzModel {
  ShortbuzModel({
    this.postId,
    this.timeStamp,
    this.boostData,
    this.dataSeq,
    this.boostedCount,
    this.video,
    this.color,
    this.boostedButton,
    this.boostedTitle,
    this.boostedLink,
    this.boostedDomain,
    this.boostedDescription,
    this.followData,
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
    this.position,
    this.stickers,
  });

  String? postId;
  String? timeStamp;
  int? boostData;
  int? dataSeq;
  dynamic? boostedCount;
  String? video;
  dynamic? color;
  String? boostedButton;
  String? boostedTitle;
  String? boostedLink;
  String? boostedDomain;
  String? boostedDescription;
  String? followData;
  DateTime? postDate;
  String? postContent;
  String? postPostbyuser;
  String? postPostonuser;
  String? postUserId;
  String? postUserFirstname;
  dynamic? postUserLastname;
  String? postUserName;
  String? postUserPicture;
  String? postType;
  String? postNumViews;
  String? postCommentIcon;
  String? postTotalLikes;
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
  dynamic? postUrlData;
  dynamic? postUrlNam;
  dynamic? postDomainName;
  String? postTaggedData;
  String? postTaggedDataDetails;
  String? postBlogCategory;
  String? postBlogData;
  String? postUrlToShare;
  dynamic? postTotalReach;
  String? postTotalEngagement;
  String? postPromotePost;
  String? postViewInsight;
  int? postPromotedSlider;
  String? postCommentResult;
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
  bool? isLoaded = false;
  List<Position>? position;
  List<Sticker>? stickers;
  bool? isHidden = false;

  factory ShortbuzModel.fromJson(Map<String, dynamic> json) => ShortbuzModel(
        postId: json["post_id"],
        timeStamp: json["time_stamp"],
        boostData: json["boost_data"],
        dataSeq: json["data_sequence"],
        boostedCount: json["boosted_count"],
        video: json["video"],
        color: json["color"],
        boostedButton: json["boosted_button"],
        boostedTitle: json["boosted_title"],
        boostedLink: json["boosted_link"],
        boostedDomain: json["boosted_domain"],
        boostedDescription: json["boosted_description"],
        followData: json["follow_data"],
        postDate: DateTime.parse(json["post_date"]),
        postContent: json["post_content"],
        postPostbyuser: json["post_postbyuser"],
        postPostonuser: json["post_postonuser"],
        postUserId: json["post_user_id"],
        postUserFirstname: json["post_user_firstname"],
        postUserLastname: json["post_user_lastname"],
        postUserName: json["post_user_name"],
        postUserPicture: json["post_user_picture"],
        postType: json["post_type"],
        postNumViews: json["post_num_views"],
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
        postTotalEngagement: json["post_total_engagement"] == null
            ? null
            : json["post_total_engagement"],
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
        blogId: json["blog_id"],
        blogContent: json["blog_content"],
        postImageWidth: json["post_image_width"],
        postImageHeight: json["post_image_height"],
        position: List<Position>.from(
            json["position"].map((x) => Position.fromJson(x))),
        stickers: List<Sticker>.from(
            json["stickers"].map((x) => Sticker.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "time_stamp": timeStamp,
        "boost_data": boostData,
        "data_sequence": dataSeq,
        "boosted_count": boostedCount,
        "video": video,
        "color": color,
        "boosted_button": boostedButton,
        "boosted_title": boostedTitle,
        "boosted_link": boostedLink,
        "boosted_domain": boostedDomain,
        "boosted_description": boostedDescription,
        "follow_data": followData,
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
        "post_total_engagement":
            postTotalEngagement == null ? null : postTotalEngagement,
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
        "position": List<dynamic>.from(position!.map((x) => x.toJson())),
        "stickers": List<dynamic>.from(stickers!.map((x) => x.toJson())),
      };
}

class Position {
  Position({
    this.posx,
    this.posy,
    this.text,
    this.color,
    this.name,
    this.scale,
    this.height,
    this.width,
  });

  String? posx;
  String? posy;
  String? text;
  String? color;
  String? name;
  String? scale;
  String? height;
  String? width;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        posx: json["posx"],
        posy: json["posy"],
        text: json["text"],
        color: json["color"],
        name: json["name"],
        scale: json["scale"],
        height: json["height"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "posx": posx,
        "posy": posy,
        "text": text,
        "color": color,
        "name": name,
        "scale": scale,
        "height": height,
        "width": width,
      };
}

class Sticker {
  Sticker({
    this.posx,
    this.posy,
    this.name,
    this.id,
    this.scale,
  });

  String? posx;
  String? posy;
  String? name;
  String? id;
  String? scale;

  factory Sticker.fromJson(Map<String, dynamic> json) => Sticker(
        posx: json["posx"],
        posy: json["posy"],
        name: json["name"],
        id: json["id"],
        scale: json["scale"],
      );

  Map<String, dynamic> toJson() => {
        "posx": posx,
        "posy": posy,
        "name": name,
        "id": id,
        "scale": scale,
      };
}

class Shortbuz {
  List<ShortbuzModel> videos;

  Shortbuz(this.videos);

  factory Shortbuz.fromJson(List<dynamic> parsed) {
    List<ShortbuzModel> videos = <ShortbuzModel>[];
    videos = parsed.map((i) => ShortbuzModel.fromJson(i)).toList();
    return new Shortbuz(videos);
  }
}
