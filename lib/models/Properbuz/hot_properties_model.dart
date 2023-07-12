// To parse this JSON data, do
//
//     final hotPropertiesModel = hotPropertiesModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<HotPropertiesModel> hotPropertiesModelFromJson(String str) =>
    List<HotPropertiesModel>.from(
        json.decode(str).map((x) => HotPropertiesModel.fromJson(x)));

class HotPropertiesModel {
  HotPropertiesModel({
    this.floorPlan,
    this.propertyId,
    this.featured,
    this.price,
    this.currency,
    this.agentId,
    this.type,
    this.location,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.propertyDescription,
    // this.photos,
    this.neighboorhood,
    this.latitude,
    this.longitude,
    this.youtubeVideo,
    this.sqft,
    this.images,
    this.shareurl,
    this.virtualTour,
    this.sqMeter,
    this.memberName,
    this.memberContactNo,
    this.memberEmail,
    this.memberLocation,
    this.savedStatus,
    this.alertStatus,
    this.newConstruction,

    //   this.propertyId,
    //   this.featured,
    //   this.price,
    //   this.currency,
    //   this.agentId,
    //   this.type,
    //   this.location,
    //   this.bedrooms,
    //   this.bathrooms,
    //   this.area,
    //   this.propertyDescription,
    //   this.photos,
    //   this.images,
    //   this.savedStatus,
    //   this.alertStatus,
    //   this.newConstruction,
    this.selectedPhotoIndex,
    //   this.memberName,
    //   this.memberContactNo,
    //   this.memberEmail,
    //   this.memberLocation,
    //   this.floorPlan,
    this.video,
    //   this.latitude,
    //   this.longitude,
    //   this.shareurl,
    this.selectedVirtualIndex,
    this.selectedFloorIndex,
    //   this.virtualTour,
    //   this.sqft,
    //   this.sqMeter,
  });

  // String shareurl;
  // String propertyId;
  // bool featured;
  // String price;
  // String currency;
  // String type;
  // String location;
  // String bedrooms;
  // String bathrooms;
  // String area;
  // String agentId;
  // String propertyDescription;
  // int photos;
  // List<String> images;
  RxBool? savedStatus;
  RxBool? alertStatus;
  // bool newConstruction;
  RxInt? selectedPhotoIndex;
  RxInt? selectedVirtualIndex;
  RxInt? selectedFloorIndex;
  // String memberName;
  // String memberContactNo;
  // String memberEmail;
  // String memberLocation;
  // List<dynamic> floorPlan;
  // List<String> virtualTour;
  String? video;
  // String latitude;
  // String longitude;
  // String sqft;
  // String sqMeter;

  List<String>? floorPlan;
  String? propertyId;
  bool? featured;
  String? price;
  String? currency;
  String? agentId;
  String? type;
  String? location;
  String? bedrooms;
  String? bathrooms;
  String? area;
  String ?propertyDescription;
  // String photos;
  String? neighboorhood;
  String? latitude;
  String? longitude;
  String? youtubeVideo;
  String? sqft;
  List<String>? images;
  String? shareurl;
  String? virtualTour;
  String? sqMeter;
  String? memberName;
  String? memberContactNo;
  String? memberEmail;
  String? memberLocation;
  // bool savedStatus;
  // bool alertStatus;
  bool? newConstruction;

  factory HotPropertiesModel.fromJson(Map<String, dynamic> json) =>
      HotPropertiesModel(
        // shareurl: json['shareurl'],
        // propertyId: json["property_id"],
        // featured: json["featured"],
        // price: json["price"],
        // currency: json["currency"],
        // type: json["type"],
        // location: json["location"],
        // bedrooms: json["bedrooms"],
        // bathrooms: json["bathrooms"],
        // area: json["area"],
        // propertyDescription: json["description"],
        // photos: json["photos"],
        // images: List<String>.from(json["images"].map((x) => x)),
        savedStatus: new RxBool(json["saved_status"]),
        alertStatus: new RxBool(json["alert_status"]),
        newConstruction: json["new_construction"],
        selectedPhotoIndex: new RxInt(0),
        selectedVirtualIndex: new RxInt(0),
        selectedFloorIndex: new RxInt(0),
        memberName: json["member_name"],
        memberContactNo: json["member_contact_no"],
        memberEmail: json["member_email"],
        memberLocation: json["location"],
        // floorPlan:
        //     List<dynamic>.from(json["floorPlan"]?.map((x) => x) ?? ["", ""]),
        // latitude: json["latitude"],
        // longitude: json["longitude"],
        virtualTour: json["virtual_tour"],
        // List<String>.from(json["virtual_tour"]?.map((x) => x) ?? []),
        video: json["youtube_video"],
        // sqft: json['sqft'],
        sqMeter: json['sqMeter'].toString(),
        floorPlan: json['floorPlan'].length == 0
            ? []
            : json['floorPlan'].cast<String>(),
        propertyId: json['property_id'].toString(),
        featured: json['featured'],
        price: json['price'].toString(),
        currency: json['currency'],
        agentId: json['agent_id'].toString(),
        type: json['listing_type'],
        location: json['location'],
        bedrooms: json['bedrooms'].toString(),
        bathrooms: json['bathrooms'],
        area: json['area'].toString(),
        propertyDescription: json['description'],
        // photos: json['photos'],
        neighboorhood: json['neighboorhood'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        youtubeVideo: json['video_link'],
        sqft: json['sqft'].toString(),
        images: json['images'].cast<String>(),
        shareurl: json['shareurl'],
        // cancelable
        // if (json['virtual_tour'] != null) {
        //   virtualTour = <Null>[];
        //   json['virtual_tour'].forEach((v) {
        //     virtualTour!.add(new Null.fromJson(v));
      );
}

enum Type { SALE, RENTAL }

final typeValues = EnumValues({"RENTAL": Type.RENTAL, "SALE": Type.SALE});

class EnumValues<T> {
 late  Map<String, T> map;
 late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class HotProperties {
  List<HotPropertiesModel> properties;

  HotProperties(this.properties);

  factory HotProperties.fromJson(List<dynamic> parsed) {
    List<HotPropertiesModel> properties = <HotPropertiesModel>[];
    properties = parsed.map((i) => HotPropertiesModel.fromJson(i)).toList();
    return new HotProperties(properties);
  }
}
