// To parse this JSON data, do
//
//     final horizontalVideoModel = horizontalVideoModelFromJson(jsonString);

import 'dart:convert';

List<HorizontalVideoModel> horizontalVideoModelFromJson(String str) =>
    List<HorizontalVideoModel>.from(
        json.decode(str).map((x) => HorizontalVideoModel.fromJson(x)));

String horizontalVideoModelToJson(List<HorizontalVideoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HorizontalVideoModel {
  HorizontalVideoModel({
    this.image,
    this.category,
    this.categoryIt,
    this.postId,
    this.video,
    this.videoHeight,
    this.videoWidth,
    this.videoUrl,
    this.postMemberId,
    this.likeIcon,
    this.dislikeIcon,
    this.numberOfLike,
    this.numberOfDislike,
    this.followData,
    this.totalComments,
    this.likeStatus,
    this.dislikeStatus,
    this.userImage,
    this.timeStamp,
    this.shortcode,
    this.name,
    this.postContent,
    this.numViews,
  });

  String? image;
  Category? category;
  Category? categoryIt;
  String? postId;
  String? video;
  int? videoHeight;
  int? videoWidth;
  String? videoUrl;
  String? postMemberId;
  String? likeIcon;
  String? dislikeIcon;
  int? numberOfLike;
  int? numberOfDislike;
  FollowData? followData;
  int? totalComments;
  int? likeStatus;
  int? dislikeStatus;
  String? userImage;
  TimeStamp? timeStamp;
  String? shortcode;
  String? name;
  String? postContent;
  String? numViews;

  factory HorizontalVideoModel.fromJson(Map<String, dynamic> json) =>
      HorizontalVideoModel(
        image: json["image"],
        category: categoryValues.map[json["category"]],
        categoryIt: categoryValues.map[json["category_it"]],
        postId: json["post_id"],
        video: json["video"],
        videoHeight: json["video_height"],
        videoWidth: json["video_width"],
        videoUrl: json["video_url"],
        postMemberId: json["post_user_id"],
        likeIcon: json["like_icon"],
        dislikeIcon: json["dislike_icon"],
        numberOfLike: json["number_of_like"],
        numberOfDislike: json["number_of_dislike"],
        followData: followDataValues.map[json["follow_data"]],
        totalComments: json["total_comments"],
        likeStatus: json["like_status"],
        dislikeStatus: json["dislike_status"],
        userImage: json["user_image"],
        timeStamp: timeStampValues.map[json["time_stamp"]],
        shortcode: json["shortcode"],
        name: json["name"],
        postContent: json["post_content"],
        numViews: json["num_views"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "category": categoryValues.reverse[category],
        "category_it": categoryValues.reverse[categoryIt],
        "post_id": postId,
        "video": video,
        "video_height": videoHeight,
        "video_width": videoWidth,
        "video_url": videoUrl,
        "post_user_id": postMemberId,
        "like_icon": likeIcon,
        "dislike_icon": dislikeIcon,
        "number_of_like": numberOfLike,
        "number_of_dislike": numberOfDislike,
        "follow_data": followDataValues.reverse[followData],
        "total_comments": totalComments,
        "like_status": likeStatus,
        "dislike_status": dislikeStatus,
        "user_image": userImage,
        "time_stamp": timeStampValues.reverse[timeStamp],
        "shortcode": shortcode,
        "name": name,
        "post_content": postContent,
        "num_views": numViews,
      };
}

enum Category { ART_AND_DESIGN }

final categoryValues = EnumValues({"Art and Design": Category.ART_AND_DESIGN});

enum FollowData { FOLLOWING, FOLLOW }

final followDataValues = EnumValues(
    {"Follow": FollowData.FOLLOW, "Following": FollowData.FOLLOWING});

enum TimeStamp { THE_2_WEEKS_AGO, THE_5_MONTHS_AGO, THE_7_MONTHS_AGO }

final timeStampValues = EnumValues({
  "2 weeks ago": TimeStamp.THE_2_WEEKS_AGO,
  "5 months ago": TimeStamp.THE_5_MONTHS_AGO,
  "7 months ago": TimeStamp.THE_7_MONTHS_AGO
});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
