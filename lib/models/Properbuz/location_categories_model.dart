// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:bizbultest/services/Properbuz/api/add_prop_api.dart';
import 'package:get/get.dart';

List<LocationCategoriesModel> locationcatFromJson(String str) =>
    List<LocationCategoriesModel>.from(
        json.decode(str).map((x) => LocationCategoriesModel.fromJson(x)));

String locationcatToJson(List<LocationCategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationCategoriesModel {
  LocationCategoriesModel(
      {this.ifFeat,
      this.ifpremagt,
      this.galleryExist,
      this.imageGallery,
      this.updDateXml,
      this.propertyId,
      this.propertyCreatedDate,
      this.agentId,
      this.featuredProperty,
      this.slug,
      this.propertyTitle,
      this.memberType,
      this.companyLogo,
      this.cost,
      this.currency,
      this.listingType,
      this.propertyCode,
      this.streetNo,
      this.streetName1,
      this.streetName2,
      this.postcode,
      this.bedrooms,
      this.bathrooms,
      this.landDimensionWidth,
      this.landDimensionHeight,
      this.landDimensionMeasure,
      this.builtUpDimensionWidth,
      this.builtUpDimensionHeight,
      this.builtUpDimensionMeasure,
      this.memberFirstname,
      this.memberLastname,
      this.companyName,
      this.propertyDescription,
      this.memberId,
      this.areaid,
      this.photos,
      this.images,
      this.video,
      this.selectedVirtualIndex,
      this.virtualTour,
      this.lat,
      this.followStatus,
      this.sqft,
      this.floorPlan,
      this.selectedPhotoIndex,
      this.selectedFloorIndex,
      this.long,
      this.shareUrl,
      this.page,
      this.propertyType,
      this.savedStatus,
      this.memberContactNo,
      this.memberEmail});
  String? shareUrl;
  String? ifFeat;

  String? lat;
  String? propertyType;
  String? long;
  String? ifpremagt;
  String? galleryExist;
  String? imageGallery;
  DateTime? updDateXml;
  String? propertyId;
  DateTime? propertyCreatedDate;
  RxInt? selectedVirtualIndex;
  String? agentId;
  String? featuredProperty;
  String? slug;
  String? propertyTitle;
  String? memberType;
  String? companyLogo;
  String? cost;
  String? currency;
  String? listingType;
  String? propertyCode;
  String? streetNo;
  String? streetName1;
  String? streetName2;
  String? postcode;
  String? bedrooms;
  String? bathrooms;
  String? landDimensionWidth;
  String? landDimensionHeight;
  String? landDimensionMeasure;
  String? builtUpDimensionWidth;
  String? builtUpDimensionHeight;
  String? builtUpDimensionMeasure;
  String? memberFirstname;
  String? memberLastname;
  String? companyName;
  String? propertyDescription;
  String? video;
  String? memberId;
  String? areaid;
  String? sqft;
  int? photos;
  String? memberEmail;
  String? memberContactNo;
  List<String>? images;
  List<String>? floorPlan;
  List<String>? virtualTour;
  RxInt? selectedPhotoIndex;
  RxInt? selectedFloorIndex;
  RxBool? savedStatus;
  RxInt? followStatus;
  String? page;

  factory LocationCategoriesModel.fromJson(Map<String, dynamic> json) =>
      LocationCategoriesModel(
          sqft: json['sqMeter'],
          video: json['youtube_video'],
          floorPlan:
              List<String>.from(json["floorPlan"]?.map((x) => x) ?? ["", ""]),
          savedStatus: new RxBool(json["saved_status"]),
          followStatus: new RxInt(json["follow_status"]),
          lat: json['latitude'],
          long: json['longitude'],
          propertyType: json['property_type'],
          memberEmail: json['member_email'],
          memberContactNo: json['member_contact_no'],
          shareUrl: json['shareurl'],
          ifFeat: json["if_feat"],
          selectedVirtualIndex: new RxInt(0),
          ifpremagt: json["ifpremagt"],
          virtualTour: List<String>.from(json["virtual_tour"].map((x) => x)),
          galleryExist: json["gallery_exist"],
          imageGallery: json["image_gallery"],
          updDateXml: json["upd_date_xml"] != null
              ? DateTime.parse(json["upd_date_xml"])
              : null,
          propertyId: json["property_id"],
          propertyCreatedDate: DateTime.parse(json["property_created_date"]),
          agentId: json["agent_id"],
          featuredProperty: json["featured_property"],
          slug: json["slug"],
          propertyTitle: json["property_title"],
          memberType: json["member_type"],
          companyLogo: json["company_logo"],
          cost: json["cost"],
          selectedPhotoIndex: new RxInt(0),
          selectedFloorIndex: new RxInt(0),
          currency: json["currency"],
          listingType: json["listing_type"],
          propertyCode: json["property_code"],
          streetNo: json["street_no"],
          streetName1: json["street_name_1"],
          streetName2: json["street_name_2"],
          postcode: json["postcode"],
          bedrooms: json["bedrooms"],
          bathrooms: json["bathrooms"],
          landDimensionWidth: json["land_dimension_width"],
          landDimensionHeight: json["land_dimension_height"],
          landDimensionMeasure: json["land_dimension_measure"],
          builtUpDimensionWidth: json["built_up_dimension_width"],
          builtUpDimensionHeight: json["built_up_dimension_height"],
          builtUpDimensionMeasure: json["built_up_dimension_measure"],
          memberFirstname: json["member_firstname"],
          memberLastname: json["member_lastname"],
          companyName: json["company_name"],
          propertyDescription: json["property_description"],
          memberId: json["user_id"],
          areaid: json["areaid"],
          photos: json["photos"],
          images: List<String>.from(json["images"].map((x) => x)),
          page: json['page']);

  Map<String, dynamic> toJson() => {
        "follow_status": followStatus,
        'sqMeter': sqft,
        "youtube_video": video,
        "floorplan": floorPlan,
        "latitude": lat,
        "longitude": long,
        "virtual_tour": virtualTour,
        "property_type": propertyType,
        "shareurl": shareUrl,
        "member_email": memberEmail,
        "member_contact_no": memberContactNo,
        "if_feat": ifFeat,
        "ifpremagt": ifpremagt,
        "gallery_exist": galleryExist,
        "image_gallery": imageGallery,
        "upd_date_xml": updDateXml!.toIso8601String(),
        "property_id": propertyId,
        "property_created_date": propertyCreatedDate!.toIso8601String(),
        "agent_id": agentId,
        "featured_property": featuredProperty,
        "slug": slug,
        "property_title": propertyTitle,
        "member_type": memberType,
        "company_logo": companyLogo,
        "cost": cost,
        "currency": currency,
        "listing_type": listingType,
        "property_code": propertyCode,
        "street_no": streetNo,
        "street_name_1": streetName1,
        "street_name_2": streetName2,
        "postcode": postcode,
        "bedrooms": bedrooms,
        "bathrooms": bathrooms,
        "land_dimension_width": landDimensionWidth,
        "land_dimension_height": landDimensionHeight,
        "land_dimension_measure": landDimensionMeasure,
        "built_up_dimension_width": builtUpDimensionWidth,
        "built_up_dimension_height": builtUpDimensionHeight,
        "built_up_dimension_measure": builtUpDimensionMeasure,
        "member_firstname": memberFirstname,
        "member_lastname": memberLastname,
        "company_name": companyName,
        "property_description": propertyDescription,
        "user_id": memberId,
        "areaid": areaid,
        "photos": photos,
        "saved_status": savedStatus,
        "images": List<String>.from(images!.map((x) => x)),
        "page": page
      };
}

class LocationCategories {
  List<LocationCategoriesModel> lstloccatmodel;
  LocationCategories(this.lstloccatmodel);
  factory LocationCategories.fromJson(List<dynamic> parsed) {
    List<LocationCategoriesModel> lstloccatmodel = <LocationCategoriesModel>[];
    lstloccatmodel =
        parsed.map((e) => LocationCategoriesModel.fromJson(e)).toList();
    return LocationCategories(lstloccatmodel);
  }
}
