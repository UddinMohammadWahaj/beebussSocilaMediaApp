// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<PopularRealEstateListModel> popularrealestatelisteFromJson(String str) =>
    List<PopularRealEstateListModel>.from(
        json.decode(str).map((x) => PopularRealEstateListModel.fromJson(x)));

String popularrealestatelisteToJson(List<PopularRealEstateListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopularRealEstateListModel {
  PopularRealEstateListModel({
    this.ifFeat,
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
  });

  String? ifFeat;
  String? ifpremagt;
  String? galleryExist;
  String? imageGallery;
  DateTime? updDateXml;
  String? propertyId;
  DateTime? propertyCreatedDate;
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
  String? memberId;
  String? areaid;
  int? photos;
  List<String>? images;

  factory PopularRealEstateListModel.fromJson(Map<String, dynamic> json) =>
      PopularRealEstateListModel(
        ifFeat: json["if_feat"],
        ifpremagt: json["ifpremagt"],
        galleryExist: json["gallery_exist"],
        imageGallery: json["image_gallery"],
        updDateXml: DateTime.parse(json["upd_date_xml"]),
        propertyId: json["property_id"],
        propertyCreatedDate: DateTime.parse(json["property_created_date"]),
        agentId: json["agent_id"],
        featuredProperty: json["featured_property"],
        slug: json["slug"],
        propertyTitle: json["property_title"],
        memberType: json["member_type"],
        companyLogo: json["company_logo"],
        cost: json["cost"],
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
      );

  Map<String, dynamic> toJson() => {
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
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}

class PopularRealEstateList {
  List<PopularRealEstateListModel> popularrealestatelistmodel;
  PopularRealEstateList(this.popularrealestatelistmodel);
  factory PopularRealEstateList.fromJson(List<dynamic> parsed) {
    List<PopularRealEstateListModel> popularrealestatelistmodel =
        <PopularRealEstateListModel>[];
    popularrealestatelistmodel =
        parsed.map((e) => PopularRealEstateListModel.fromJson(e)).toList();
    return PopularRealEstateList(popularrealestatelistmodel);
  }
}
