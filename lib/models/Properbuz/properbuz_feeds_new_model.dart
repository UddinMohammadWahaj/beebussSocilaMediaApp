// To parse this JSON data, do
//
//     final propertyFeedsModel = propertyFeedsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<ProperbuzFeedsNewModel> propertyFeedsModelFromJson(String str) =>
    List<ProperbuzFeedsNewModel>.from(
        json.decode(str).map((x) => ProperbuzFeedsNewModel.fromJson(x)));

class ProperbuzFeedsNewModel {
  ProperbuzFeedsNewModel(
      {  required this.postId,
         required this.memberProfile,
         required this.memberId,
         required this.memberName,
         required this.memberDesignation,
         required this.shortcode,
         required this.share,
         required this.boostStatus,
         required  this.boostPost,
         required this.boostData,
         required this.likeStatus,
         required this.totalLike,
         required this.totalComment,
         required this.description,
         required this.images,
         required this.video,
         required this.postType,
         required this.createdAt,
         required this.urlCaption,
         required this.liked,
         required this.urlLink,
         required this.isVideoPlaying,
         required this.saved});

  String postId;
  String memberId;
  String memberName;
  String memberDesignation;
  String shortcode;
  bool share;
  bool boostStatus;
  bool boostPost;
  BoostData? boostData;
  bool likeStatus;
  RxInt totalLike;
  RxInt totalComment;
  RxString description;
  List<String> images;
  Video video;
  String postType;
  String createdAt;
  String urlCaption;
  String memberProfile;
  RxBool liked;
  RxBool saved;
  List urlLink;
  RxBool isVideoPlaying;

  factory ProperbuzFeedsNewModel.fromJson(Map<String, dynamic> json) =>
      ProperbuzFeedsNewModel(
          postId: json["post_id"],
          memberId: json["member_id"],
          memberName: json["member_name"],
          memberDesignation: json["member_designation"],
          shortcode: json["shortcode"],
          share: json["share"],
          memberProfile: json["member_profile"],
          boostStatus: json["boost_status"],
          boostPost: json["boost_post"],

          boostData:
          json["boost_data"] is Iterable || json["boost_data"] == null
                  ? null
                  : BoostData.fromJson(json["boost_data"]),
          likeStatus: json["like_status"],
          totalLike: new RxInt(json["total_like"]),
          totalComment: new RxInt(json["total_comment"]),
          description: new RxString(json["description"]),
          images: List<String>.from(json["images"].map((x) => x)),
          video: Video.fromJson(json["video"]),
          urlLink: json["url_link"].length != 0
              ? List<dynamic>.from(json["url_link"].map((x) => x))
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
    required this.peopleReached,
    required this.engagements,
  });

  String peopleReached;
  int engagements;

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
    required this.videoUrl,
    required this.videoThumb,
    required this.urlCaption,
  });

  String videoUrl;
  String videoThumb;
  String urlCaption;

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
    required this.title,
    required this.image,
    required this.domain,
    required this.url,
  });

  String title;
  String image;
  String domain;
  String url;

  factory UrlLink.fromJson(Map<String, dynamic> json) => UrlLink(
        title: json["title"],
        image: json["image"],
        domain: json["domain"],
        url: json["url"],
      );
}

class ProperbuzFeedsNew {
  List<ProperbuzFeedsNewModel> feedss;

  ProperbuzFeedsNew(this.feedss);

  factory ProperbuzFeedsNew.fromJson(List<dynamic> parsed) {
    List<ProperbuzFeedsNewModel> feedss = <ProperbuzFeedsNewModel>[];
    feedss = parsed.map((i) => ProperbuzFeedsNewModel.fromJson(i)).toList();
    return new ProperbuzFeedsNew(feedss);
  }
}
