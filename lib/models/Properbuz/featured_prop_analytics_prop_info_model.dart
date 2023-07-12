// To parse this JSON data, do
//
//     final featuredAnalyticsPropertyInfoModel = featuredAnalyticsPropertyInfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:bizbultest/models/Properbuz/featured_properties_analytics_model.dart';

FeaturedAnalyticsPropertyInfoModel featuredAnalyticsPropertyInfoModelFromJson(
        String str) =>
    FeaturedAnalyticsPropertyInfoModel.fromJson(json.decode(str));

String featuredAnalyticsPropertyInfoModelToJson(
        FeaturedAnalyticsPropertyInfoModel data) =>
    json.encode(data.toJson());

class FeaturedAnalyticsPropertyInfoModel {
  FeaturedAnalyticsPropertyInfoModel({
    this.totalProperty,
    this.totalSaleProperty,
    this.totalRentalProperty,
    this.totalNewProperty,
  });

  int? totalProperty;
  int? totalSaleProperty;
  int? totalRentalProperty;
  int? totalNewProperty;

  factory FeaturedAnalyticsPropertyInfoModel.fromJson(
          Map<String, dynamic> json) =>
      FeaturedAnalyticsPropertyInfoModel(
        totalProperty: json["total_property"],
        totalSaleProperty: json["total_sale_property"],
        totalRentalProperty: json["total_rental_property"],
        totalNewProperty: json["total_new_property"],
      );

  Map<String, dynamic> toJson() => {
        "total_property": totalProperty,
        "total_sale_property": totalSaleProperty,
        "total_rental_property": totalRentalProperty,
        "total_new_property": totalNewProperty,
      };
}

class FeautredAnalyticsPropertyInfo {
  List<FeaturedAnalyticsPropertyInfoModel> lstfeaturedpropanalyticsinfo = [];
  FeautredAnalyticsPropertyInfo(this.lstfeaturedpropanalyticsinfo);
  factory FeautredAnalyticsPropertyInfo.fromJson(List<dynamic> parsed) {
    var data = parsed
        .map((e) => FeaturedAnalyticsPropertyInfoModel.fromJson(e))
        .toList();
    return FeautredAnalyticsPropertyInfo(data);
  }
}
