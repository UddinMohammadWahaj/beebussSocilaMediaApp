import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

List<ManageTradesmanModel> locationReviewsModelFromJson(String str) =>
    List<ManageTradesmanModel>.from(
        json.decode(str).map((x) => ManageTradesmanModel.fromJson(x)));

class ManageTradesmanModel {
  ManageTradesmanModel({
    this.tradesmanid,
    this.companyname,
    this.zipcode,
    this.managername,
    this.housename,
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
    this.virtualTour,
    this.bedrooms,
    this.bathrooms,
    this.cost,
    this.currency,
    this.sqft,
  });
  String? video;
  String? sqft;
  String? floorPlan;
  String? lat;
  RxInt? selectedVirtualIndex;
  String? long;
  String? tradesmanid;
  String? companyname;
  String? zipcode;
  String? managername;
  String? housename;
  String? propertySubType;
  String? propertytitle;
  String? propertydescription;
  String? propertystatus;
  String? shareurl;
  List<String>? images;
  RxInt? selectedPhotoIndex;
  List<String>? virtualTour;
  String? bedrooms;
  String? cost;
  String? currency;
  String? bathrooms;
  factory ManageTradesmanModel.fromJson(Map<String, dynamic> json) {
    return ManageTradesmanModel(
        shareurl: json['shareurl'],
        bedrooms: json["bedrooms"],
        bathrooms: json["bathrooms"],
        cost: json["cost"],
        sqft: json['sqft'],
        video: json['youtube_video'],
        floorPlan: json['floorplan'],
        lat: json['latitude'],
        currency: json["currency"],
        long: json['longitude'],
        // virtualTour: List<String>.from(json["virtual_tour"].map((x) => x)),
        selectedVirtualIndex: new RxInt(0),
        companyname: json['company_name'],
        images: List<String>.from(json["images"].map((x) => x)) ?? [],
        propertySubType: json['propertySubType'] ?? "",
        managername: json['manager_name'],
        zipcode: json['zip_code'],
        propertydescription: json['property_description'],
        tradesmanid: json['tradesman_id'],
        selectedPhotoIndex: new RxInt(0),
        propertystatus: json['property_status'],
        propertytitle: json['property_title'],
        housename: json['house_name']);
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
        "tradesman_id": tradesmanid,
        "company_name": companyname,
        "zip_code": zipcode,
        "manager_name": managername,
        "house_name": housename,
        "property_sub_type": propertySubType,
        "property_title": propertytitle,
        "property_description": propertydescription,
        "property_status": propertystatus,
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}

class ManageTradesman {
  List<ManageTradesmanModel> properties;
  ManageTradesman(this.properties);
  factory ManageTradesman.fromJson(List<dynamic> parsed) {
    List<ManageTradesmanModel> properties = <ManageTradesmanModel>[];
    print("yo $properties");
    properties = parsed.map((e) => ManageTradesmanModel.fromJson(e)).toList();
    return ManageTradesman(properties);
  }
}
