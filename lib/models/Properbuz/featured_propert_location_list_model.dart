// To parse this JSON data, do
//
//     final featuredPropertyLocationListModel = featuredPropertyLocationListModelFromJson(jsonString);

import 'dart:convert';

List<FeaturedPropertyLocationListModel>
    featuredPropertyLocationListModelFromJson(String str) =>
        List<FeaturedPropertyLocationListModel>.from(json
            .decode(str)
            .map((x) => FeaturedPropertyLocationListModel.fromJson(x)));

String featuredPropertyLocationListModelToJson(
        List<FeaturedPropertyLocationListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeaturedPropertyLocationListModel {
  FeaturedPropertyLocationListModel({
    this.propertyId,
    this.propertyTitle,
  });

  String? propertyId;
  String? propertyTitle;

  factory FeaturedPropertyLocationListModel.fromJson(
          Map<String, dynamic> json) =>
      FeaturedPropertyLocationListModel(
        propertyId: json["property_id"],
        propertyTitle: json["property_title"],
      );

  Map<String, dynamic> toJson() => {
        "property_id": propertyId,
        "property_title": propertyTitle,
      };
}

class FeaturedPropertyLocationList {
  List<FeaturedPropertyLocationListModel> lstfeaturedproploc = [];
  FeaturedPropertyLocationList(this.lstfeaturedproploc);
  factory FeaturedPropertyLocationList.fromJson(List<dynamic> parsed) {
    List<FeaturedPropertyLocationListModel> lst =
        <FeaturedPropertyLocationListModel>[];
    lst = parsed
        .map((e) => FeaturedPropertyLocationListModel.fromJson(e))
        .toList();
    return FeaturedPropertyLocationList(lst);
  }
}
