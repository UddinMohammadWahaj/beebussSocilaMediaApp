import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

List<ManagePropertiesModel> locationReviewsModelFromJson(String str) =>
    List<ManagePropertiesModel>.from(
        json.decode(str).map((x) => ManagePropertiesModel.fromJson(x)));

class ManagePropertiesModel {
  ManagePropertiesModel(
      {this.propertyid,
      this.featuredproperty,
      this.propertycode,
      this.listingtype,
      this.propertytype,
      this.propertySubType,
      this.propertytitle,
      this.propertydescription,
      this.propertystatus,
      this.images,
      this.video,
      this.selectedVirtualIndex,
      this.floorPlan,
      this.lat,
      this.shareurl,
      this.long,
      this.selectedPhotoIndex,
      this.selectedFloorIndex,
      this.virtualTour,
      this.bedrooms,
      this.bathrooms,
      this.cost,
      this.currency,
      this.sqft,
      this.propertySold,
      this.propertyCategory,
      this.defaultImage});
  String? video;
  String? sqft;
  List<String>? floorPlan;
  String? lat;
  RxInt? selectedVirtualIndex;
  String? long;
  String? propertyid;
  String? featuredproperty;
  String? propertycode;
  String? listingtype;
  String? propertytype;
  String? propertySubType;
  String? propertytitle;
  String? propertydescription;
  String? propertystatus;
  String? shareurl;
  List<String>? images;
  RxInt? selectedPhotoIndex;
  RxInt? selectedFloorIndex;
  String? propertySold;
  String? propertyCategory;
  List<String>? virtualTour;
  String? bedrooms;
  String? cost;
  String? currency;
  String? bathrooms;
  String? defaultImage;
  factory ManagePropertiesModel.fromJson(Map<String, dynamic> json) {
    return ManagePropertiesModel(
      propertyid: json['property_id'].toString(),
      propertycode: json['property_code'],
      listingtype: json['listing_type'],
      propertytype: json['property_type'],
      propertytitle: json['property_title'],
      propertydescription: json['property_description'],
      propertystatus: json['property_status'],
      bedrooms: json["bedrooms"].toString(),
      bathrooms: json["bathrooms"].toString(),
      cost: json["cost"],
      currency: json["currency"],
      propertySold: json['property_sold'] == 0 ? "NO" : "YES",
      propertyCategory: json['property_category'],
      floorPlan: json['floorplan'] ?? [],
      lat: json['latitude'],
      long: json['longitude'],
      images: List<String>.from(json["images"].map((x) => x)) ?? [],
      defaultImage: json['default_image'],
      shareurl: json['shareurl'] ?? '',

      sqft: json['sqft'].toString(),
      video: json['youtube_video'],

      // virtualTour: List<String>.from(json["virtual_tour"].map((x) => x)),
      selectedVirtualIndex: new RxInt(0),
      featuredproperty: json['featured_property'],

      propertySubType: json['propertySubType'] ?? "",

      selectedPhotoIndex: new RxInt(0),
      selectedFloorIndex: new RxInt(0),
    );
  }

  Map<String, dynamic> toJson() => {
        "shareurl": shareurl,
        "bedrooms": bedrooms,
        "bathrooms": bathrooms,
        'sqMeter': sqft,
        "cost": cost,
        "currency": currency,
        "floorplan": floorPlan,
        "virtual_tour": virtualTour,
        "latitude": lat,
        "longitude": long,
        "youtube_video": video,
        "property_id": propertyid,
        "featured_property": featuredproperty,
        "property_code": propertycode,
        "listing_type": listingtype,
        "property_type": propertytype,
        "property_sub_type": propertySubType,
        "property_title": propertytitle,
        "property_description": propertydescription,
        "property_status": propertystatus,
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}

class ManageProperties {
  List<ManagePropertiesModel> properties;
  ManageProperties(this.properties);
  factory ManageProperties.fromJson(List<dynamic> parsed) {
    List<ManagePropertiesModel> properties = <ManagePropertiesModel>[];
    print("yo $properties");
    properties = parsed.map((e) => ManagePropertiesModel.fromJson(e)).toList();
    return ManageProperties(properties);
  }
}
