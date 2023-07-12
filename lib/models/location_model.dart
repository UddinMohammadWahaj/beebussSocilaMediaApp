// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel({
    this.postId,
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
    this.postAllImage,
    this.postAllImages,
    this.postCommentData,
    this.postMemberId,
    this.dataLong,
    this.dataLat,
    this.dataMultiImage,
    this.timeStamp,
    this.postContent,
    this.postUserPicture,
    this.postRebuz,
    this.postRebuzData,
    this.postShortcode,
    this.postHeaderLocation,
  });

  String? postId;
  String? postType;
  String? postUrl;
  String? postTotalComment;
  dynamic postTotalLikes;
  String? postVideoLogoTop;
  String? postVideoPlayLogo;
  String? postNumberOfViews;
  String? postLikeLogo;
  dynamic postUrlName;
  dynamic postDomainName;
  String? postAllImage;
  String? postAllImages;
  String? postCommentData;
  String? postMemberId;
  String? dataLong;
  String? dataLat;
  int? dataMultiImage;
  String? timeStamp;
  String? postContent;
  String? postUserPicture;
  int? postRebuz;
  String? postRebuzData;
  String? postShortcode;
  String? postHeaderLocation;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        postId: json["post_id"],
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
        postAllImage: json["post_all_image"],
        postAllImages: json["post_all_images"],
        postCommentData: json["post_comment_data"],
        postMemberId: json["post_user_id"],
        dataLong: json["data_long"],
        dataLat: json["data_lat"],
        dataMultiImage: json["data_multi_image"],
        timeStamp: json["time_stamp"],
        postContent: json["post_content"],
        postUserPicture: json["post_user_picture"],
        postRebuz: json["post_rebuz"],
        postRebuzData: json["post_rebuz_data"],
        postShortcode: json["post_shortcode"],
        postHeaderLocation: json["post_header_location"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
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
        "post_all_image": postAllImage,
        "post_all_images": postAllImages,
        "post_comment_data": postCommentData,
        "post_user_id": postMemberId,
        "data_long": dataLong,
        "data_lat": dataLat,
        "data_multi_image": dataMultiImage,
        "time_stamp": timeStamp,
        "post_content": postContent,
        "post_user_picture": postUserPicture,
        "post_rebuz": postRebuz,
        "post_rebuz_data": postRebuzData,
        "post_shortcode": postShortcode,
        "post_header_location": postHeaderLocation,
      };
}

class Locations {
  List<LocationModel> locations;

  Locations(this.locations);

  factory Locations.fromJson(List<dynamic> parsed) {
    List<LocationModel> locations = <LocationModel>[];
    locations = parsed.map((i) => LocationModel.fromJson(i)).toList();
    return new Locations(locations);
  }
}
