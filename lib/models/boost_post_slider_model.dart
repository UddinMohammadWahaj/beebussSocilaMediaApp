// To parse this JSON data, do
//
//     final boostPostSliderModel = boostPostSliderModelFromJson(jsonString);

import 'dart:convert';

List<BoostPostSliderModel> boostPostSliderModelFromJson(String str) =>
    List<BoostPostSliderModel>.from(
        json.decode(str).map((x) => BoostPostSliderModel.fromJson(x)));

String boostPostSliderModelToJson(List<BoostPostSliderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BoostPostSliderModel {
  BoostPostSliderModel({
    this.postId,
    this.boostId,
    this.postType,
    this.boostStatus,
    this.boostDate,
    this.boostedBy,
    this.peopleReached,
    this.linksClicks,
    this.viewResult,
  });

  String? postId;
  String? boostId;
  String? postType;
  String? boostStatus;
  String? boostDate;
  String? boostedBy;
  int? peopleReached;
  int? linksClicks;
  String? viewResult;

  factory BoostPostSliderModel.fromJson(Map<String, dynamic> json) =>
      BoostPostSliderModel(
        postId: json["post_id"],
        boostId: json["boost_id"],
        postType: json["post_type"],
        boostStatus: json["boost_status"],
        boostDate: json["boost_date"],
        boostedBy: json["boosted_by"],
        peopleReached: json["people_reached"],
        linksClicks: json["links_clicks"],
        viewResult: json["view_result"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "boost_id": boostId,
        "post_type": postType,
        "boost_status": boostStatus,
        "boost_date": boostDate,
        "boosted_by": boostedBy,
        "people_reached": peopleReached,
        "links_clicks": linksClicks,
        "view_result": viewResult,
      };
}

class BoostPosts {
  List<BoostPostSliderModel> boosts;

  BoostPosts(this.boosts);
  factory BoostPosts.fromJson(List<dynamic> parsed) {
    List<BoostPostSliderModel> boosts = <BoostPostSliderModel>[];
    boosts = parsed.map((i) => BoostPostSliderModel.fromJson(i)).toList();
    return new BoostPosts(boosts);
  }
}
