// To parse this JSON data, do
//
//     final locationReviewsModel = locationReviewsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<LocationReviewsModel> locationReviewsModelFromJson(String str) =>
    List<LocationReviewsModel>.from(
        json.decode(str).map((x) => LocationReviewsModel.fromJson(x)));

class LocationReviewsModel {
  LocationReviewsModel({
    this.images,
    this.videos,
    this.reviewId,
    this.ratings,
    this.title,
    this.description,
    this.userName,
    this.userImage,
    this.reviewTime,
    this.currentIndex,
    this.videoThumbnails,
  });

  List<String>? images;
  List<String>? videos;
  List<String>? videoThumbnails;
  String? reviewId;
  int? ratings;
  String? title;
  String? description;
  String? userName;
  String? userImage;
  String? reviewTime;
  RxInt? currentIndex;

  factory LocationReviewsModel.fromJson(Map<String, dynamic> json) =>
      LocationReviewsModel(
        images: List<String>.from(json["images"].map((x) => x)),
        videos: List<String>.from(json["videos"].map((x) => x)),
        videoThumbnails:
            List<String>.from(json["video_thumbnails"].map((x) => x)),
        reviewId: json["review_id"],
        ratings: json["ratings"],
        title: json["title"],
        description: json["description"],
        userName: json["user_name"],
        userImage: json["user_image"],
        reviewTime: json["review_time"],
        currentIndex: 1.obs,
      );
}

class LocationReviews {
  List<LocationReviewsModel> reviews;
  LocationReviews(this.reviews);
  factory LocationReviews.fromJson(List<dynamic> parsed) {
    List<LocationReviewsModel> reviews = <LocationReviewsModel>[];
    reviews = parsed.map((i) => LocationReviewsModel.fromJson(i)).toList();
    return new LocationReviews(reviews);
  }
}
