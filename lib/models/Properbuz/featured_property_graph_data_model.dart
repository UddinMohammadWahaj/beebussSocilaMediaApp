// To parse this JSON data, do
//
//     final featuredAnalyticsGraphDataModel = featuredAnalyticsGraphDataModelFromJson(jsonString);

import 'dart:convert';

FeaturedAnalyticsGraphDataModel featuredAnalyticsGraphDataModelFromJson(
        String str) =>
    FeaturedAnalyticsGraphDataModel.fromJson(json.decode(str));

String featuredAnalyticsGraphDataModelToJson(
        FeaturedAnalyticsGraphDataModel data) =>
    json.encode(data.toJson());

class FeaturedAnalyticsGraphDataModel {
  FeaturedAnalyticsGraphDataModel({
    this.totalProperty,
    this.totalSaleProperty,
    this.totalRentalProperty,
    this.totalNewProperty,
    this.saveProperty,
    this.savePercentage,
    this.searchProperty,
    this.searchPercentage,
    this.enquiryProperty,
    this.enquiryPercentage,
    this.graphData,
  });

  int? totalProperty;
  int? totalSaleProperty;
  int? totalRentalProperty;
  int? totalNewProperty;
  int? saveProperty;
  int? savePercentage;
  int? searchProperty;
  int? searchPercentage;
  int? enquiryProperty;
  int? enquiryPercentage;
  List<GraphDatum>? graphData;

  factory FeaturedAnalyticsGraphDataModel.fromJson(Map<String, dynamic> json) =>
      FeaturedAnalyticsGraphDataModel(
        totalProperty: json["total_property"],
        totalSaleProperty: json["total_sale_property"],
        totalRentalProperty: json["total_rental_property"],
        totalNewProperty: json["total_new_property"],
        saveProperty: json["save_property"],
        savePercentage: json["save_percentage"],
        searchProperty: json["search_property"],
        searchPercentage: json["search_percentage"],
        enquiryProperty: json["enquiry_property"],
        enquiryPercentage: json["enquiry_percentage"],
        graphData: List<GraphDatum>.from(
            json["graph_data"].map((x) => GraphDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_property": totalProperty,
        "total_sale_property": totalSaleProperty,
        "total_rental_property": totalRentalProperty,
        "total_new_property": totalNewProperty,
        "save_property": saveProperty,
        "save_percentage": savePercentage,
        "search_property": searchProperty,
        "search_percentage": searchPercentage,
        "enquiry_property": enquiryProperty,
        "enquiry_percentage": enquiryPercentage,
        "graph_data": List<dynamic>.from(graphData!.map((x) => x.toJson())),
      };
}

class GraphDatum {
  GraphDatum({
    this.data,
    this.viewed,
  });

  String? data;
  String? viewed;

  factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
        data: json["data"],
        viewed: json["viewed"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "viewed": viewed,
      };
}

class FeaturedAnalyticsGraphData {
  FeaturedAnalyticsGraphDataModel datamodel;
  FeaturedAnalyticsGraphData(this.datamodel);
  factory FeaturedAnalyticsGraphData.fromJson(Map<String, dynamic> parsed) {
    var data = FeaturedAnalyticsGraphDataModel.fromJson(parsed);
    return FeaturedAnalyticsGraphData(data);
  }
}
