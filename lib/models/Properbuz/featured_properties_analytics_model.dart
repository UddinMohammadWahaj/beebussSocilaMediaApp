import 'dart:convert';

List<FeaturedPropertiesAnalyticsModel> featuredPropertiesAnalyticsModelFromJson(
        String str) =>
    List<FeaturedPropertiesAnalyticsModel>.from(json
        .decode(str)
        .map((x) => FeaturedPropertiesAnalyticsModel.fromJson(x)));

class FeaturedPropertiesAnalyticsModel {
  FeaturedPropertiesAnalyticsModel({
    this.imagename,
    this.propertycode,
    this.propertytitle,
    this.listingtype,
    this.propertystatus,
  });
  String? imagename;
  String? propertycode;
  String? propertytitle;
  String? listingtype;
  String? propertystatus;

  factory FeaturedPropertiesAnalyticsModel.fromJson(
          Map<String, dynamic> json) =>
      FeaturedPropertiesAnalyticsModel(
        imagename: json['image_name'],
        propertycode: json['property_code'],
        propertytitle: json['property_title'],
        listingtype: json['listing_type'],
        propertystatus: json['property_status'],
      );
}

class FeaturedPropertiesAnalytics {
  List<FeaturedPropertiesAnalyticsModel> properties;
  FeaturedPropertiesAnalytics(this.properties);
  factory FeaturedPropertiesAnalytics.fromJson(List<dynamic> parsed) {
    List<FeaturedPropertiesAnalyticsModel> properties =
        <FeaturedPropertiesAnalyticsModel>[];
    properties = parsed
        .map((i) => FeaturedPropertiesAnalyticsModel.fromJson(i))
        .toList();
    return new FeaturedPropertiesAnalytics(properties);
    // reviews = parsed.map((i) => LocationReviewsModel.fromJson(i)).toList();
    // return new LocationReviews(reviews);
  }
}
