// To parse this JSON data, do
//
//     final searchPropertiesList = searchPropertiesListFromJson(jsonString);

import 'dart:convert';

SearchPropertiesList searchPropertiesListFromJson(String str) =>
    SearchPropertiesList.fromJson(json.decode(str));

String searchPropertiesListToJson(SearchPropertiesList data) =>
    json.encode(data.toJson());

class SearchPropertiesList {
  SearchPropertiesList({
    this.id,
    this.userId,
    this.propertyTitle,
    this.streetName1,
    this.propertyPrice,
    this.currency,
    this.listingType,
    this.status,
    this.createdAt,
    this.defaultImage,
    this.propertyCategory,
  });

  int? id;
  int? userId;
  String? propertyTitle;
  String? streetName1;
  String? propertyPrice;
  String? currency;
  String? listingType;
  String? status;
  DateTime? createdAt;
  String? defaultImage;
  String? propertyCategory;

  factory SearchPropertiesList.fromJson(Map<String, dynamic> json) =>
      SearchPropertiesList(
        id: json["id"],
        userId: json["user_id"],
        propertyTitle: json["property_title"],
        streetName1: json["street_name1"],
        propertyPrice: json["property_price"],
        currency: json["currency"],
        listingType: json["listing_type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        defaultImage: json["default_image"],
        propertyCategory: json["property_category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "property_title": propertyTitle,
        "street_name1": streetName1,
        "property_price": propertyPrice,
        "currency": currency,
        "listing_type": listingType,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "default_image": defaultImage,
        "property_category": propertyCategory,
      };
}
