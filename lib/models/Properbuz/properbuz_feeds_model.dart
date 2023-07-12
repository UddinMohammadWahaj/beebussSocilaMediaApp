// To parse this JSON data, do
//
//     final propertyFeedsModel = propertyFeedsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<ProperbuzFeedsModel> propertyFeedsModelFromJson(String str) =>
    List<ProperbuzFeedsModel>.from(
        json.decode(str).map((x) => ProperbuzFeedsModel.fromJson(x)));

class ProperbuzFeedsModel {
  ProperbuzFeedsModel(
      {this.postId,
      this.memberProfile,
      this.memberId,
      this.memberName,
      this.memberDesignation,
      this.shortcode,
      this.share,
      this.boostStatus,
      this.boostPost,
      this.boostData,
      this.likeStatus,
      this.totalLike,
      this.totalComment,
      this.description,
      this.images,
      this.video,
      this.postType,
      this.createdAt,
      this.urlCaption,
      this.liked,
      this.urlLink,
      this.isVideoPlaying,
      this.saved});

  String? postId;
  String? memberId;
  String? memberName;
  String? memberDesignation;
  String? shortcode;
  bool? share;
  bool? boostStatus;
  bool? boostPost;
  BoostData? boostData;
  bool? likeStatus;
  RxInt? totalLike;
  RxInt? totalComment;
  RxString? description;
  List<String>? images;
  Video? video;
  String? postType;
  String? createdAt;
  String? urlCaption;
  String? memberProfile;
  RxBool? liked;
  RxBool? saved;
  List<UrlLink>? urlLink;
  RxBool? isVideoPlaying;

  factory ProperbuzFeedsModel.fromJson(Map<String, dynamic> json) =>
      ProperbuzFeedsModel(
          postId: json["post_id"].toString(),
          memberId: json["user_id"].toString(),
          memberName: json["member_name"],
          memberDesignation: json["member_designation"],
          shortcode: json["shortcode"],
          share: json["share"],
          memberProfile: json["member_profile"],
          boostStatus: json["boost_status"],
          boostPost: json["boost_post"],
          boostData:
              json["boost_data"]! is Iterable || json["boost_data"]! == null
                  ? null
                  : BoostData.fromJson(json["boost_data"]!),
          likeStatus: json["like_status"],
          totalLike: new RxInt(json["total_like"]),
          totalComment: new RxInt(json["total_comment"]),
          description: new RxString(json["description"]),
          images: List<String>.from(json["images"].map((x) => x)),
          video: Video.fromJson(json["video"]),
          urlLink: json["url_link"].length != 0
              ? List<UrlLink>.from(
                  json["url_link"].map((x) => UrlLink.fromJson(x)))
              : [],
          //  json["url_link"] is Iterable || json["url_link"] == null
          //     ? null
          // :
          // List<UrlLink>.from(json["url_link"].map((x) => x)),
          // UrlLink.fromJson(json["url_link"]),
          postType: json["post_type"],
          createdAt: json["created_at"],
          urlCaption: json["url_caption"] == null ? null : json["url_caption"],
          liked: new RxBool(json["like_status"]),
          isVideoPlaying: new RxBool(false),
          saved: new RxBool(json["saved"]));
}

class BoostData {
  BoostData({
    this.peopleReached,
    this.engagements,
  });

  String? peopleReached;
  int? engagements;

  factory BoostData.fromJson(Map<String, dynamic> json) => BoostData(
        peopleReached: json["people_reached"],
        engagements: json["engagements"],
      );

  Map<String, dynamic> toJson() => {
        "people_reached": peopleReached,
        "engagements": engagements,
      };
}

class Video {
  Video({
    this.videoUrl,
    this.videoThumb,
    this.urlCaption,
  });

  String? videoUrl;
  String? videoThumb;
  String? urlCaption;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        videoUrl: json["video_url"],
        videoThumb: json["video_thumb"],
        urlCaption: json["url_caption"],
      );

  Map<String, dynamic> toJson() => {
        "video_url": videoUrl,
        "video_thumb": videoThumb,
        "url_caption": urlCaption,
      };
}

class UrlLink {
  UrlLink({
    this.title,
    this.image,
    this.domain,
    this.url,
  });

  String? title;
  String? image;
  String? domain;
  String? url;

  factory UrlLink.fromJson(Map<String, dynamic> json) => UrlLink(
        title: json["title"],
        image: json["image"],
        domain: json["domain"],
        url: json["url"],
      );
}

class ProperbuzFeeds {
  List<ProperbuzFeedsModel> feeds;

  ProperbuzFeeds(this.feeds);

  factory ProperbuzFeeds.fromJson(List<dynamic> parsed) {
    List<ProperbuzFeedsModel> feeds = <ProperbuzFeedsModel>[];
    feeds = parsed.map((i) => ProperbuzFeedsModel.fromJson(i)).toList();
    return new ProperbuzFeeds(feeds);
  }
}
