// To parse this JSON data, do
//
//     final editPropertModel = editPropertModelFromJson(jsonString);

import 'dart:convert';

EditPropertModel editPropertModelFromJson(String str) =>
    EditPropertModel.fromJson(json.decode(str));

String editPropertModelToJson(EditPropertModel data) =>
    json.encode(data.toJson());

class EditPropertModel {
  EditPropertModel({
    this.success,
    this.typeId,
    this.propertyTypeId,
    this.propertyTitle,
    this.slug,
    this.cost,
    this.currency,
    this.bedrooms,
    this.builtUpRate,
    this.builtUpMeasure,
    this.builtUpDimensionWidth,
    this.builtUpDimensionHeight,
    this.builtUpDimensionMeasure,
    this.landAreaMeasure,
    this.landDimensionWidth,
    this.landDimensionHeight,
    this.landDimensionMeasure,
    this.propertyDescription,
    this.furnished,
    this.homeListed,
    this.floor,
    this.bathrooms,
    this.specialFeatures,
    this.fixtureFitting,
    this.outdoorIndoorSpace,
    this.facility,
    this.countryId,
    this.country,
    this.location,
    this.areaId,
    this.streetNo,
    this.streetName1,
    this.streetName2,
    this.postcode,
    this.latitude,
    this.longitude,
    this.propertyType,
    this.preference,
    this.ownerFirstName,
    this.ownerLastName,
    this.ownerAddress,
    this.ownerContactNo,
    this.floorimages,
    this.ownerEmailId,
    this.propertyAvailableDate,
    this.proPaid,
    this.propertyNeighboorhood,
    this.sharedOwnership,
    this.retHomes,
    this.undOffer,
    this.images,
  });

  int? success;
  String? typeId;
  String? propertyTypeId;
  String? propertyType;
  String? propertyTitle;
  String? slug;
  String? cost;
  String? currency;
  String? bedrooms;
  String? builtUpRate;
  String? builtUpMeasure;
  String? builtUpDimensionWidth;
  String? builtUpDimensionHeight;
  String? builtUpDimensionMeasure;
  String? landAreaMeasure;
  String? landDimensionWidth;
  String? landDimensionHeight;
  String? landDimensionMeasure;
  String? propertyDescription;
  String? furnished;
  String? homeListed;
  String? floor;
  String? bathrooms;
  String? specialFeatures;
  String? fixtureFitting;
  String? outdoorIndoorSpace;
  String? facility;
  String? countryId;
  String? country;
  String? location;
  String? areaId;
  String? streetNo;
  String? streetName1;
  String? streetName2;
  String? postcode;
  String? latitude;
  String? longitude;
  String? preference;
  String? ownerFirstName;
  String? ownerLastName;
  String? ownerAddress;
  String? ownerContactNo;
  String? ownerEmailId;
  DateTime? propertyAvailableDate;
  String? proPaid;
  String? propertyNeighboorhood;
  String? sharedOwnership;
  String? retHomes;
  String? undOffer;
  List<dynamic>? images;
  List<dynamic>? floorimages;

  factory EditPropertModel.fromJson(Map<String, dynamic> json) =>
      EditPropertModel(
        success: json["success"],
        floorimages: json['floorplan'],
        typeId: json["type_id"],
        propertyTypeId: json["property_type_id"],
        propertyType: json['property_type'],
        propertyTitle: json["property_title"],
        slug: json["slug"],
        cost: json["cost"],
        currency: json["currency"],
        bedrooms: json["bedrooms"],
        builtUpRate: json["built_up_rate"],
        builtUpMeasure: json["built_up_measure"],
        builtUpDimensionWidth: json["built_up_dimension_width"],
        builtUpDimensionHeight: json["built_up_dimension_height"],
        builtUpDimensionMeasure: json["built_up_dimension_measure"],
        landAreaMeasure: json["land_area_measure"],
        landDimensionWidth: json["land_dimension_width"],
        landDimensionHeight: json["land_dimension_height"],
        landDimensionMeasure: json["land_dimension_measure"],
        propertyDescription: json["property_description"],
        furnished: json["furnished"],
        homeListed: json["home_listed"],
        floor: json["floor"],
        bathrooms: json["bathrooms"],
        specialFeatures: json["special_features"],
        fixtureFitting: json["fixture_fitting"],
        outdoorIndoorSpace: json["outdoor_indoor_space"],
        facility: json["facility"],
        countryId: json["country_id"],
        country: json["country"],
        location: json["location"],
        areaId: json["area_id"],
        streetNo: json["street_no"],
        streetName1: json["street_name_1"],
        streetName2: json["street_name_2"],
        postcode: json["postcode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        preference: json["preference"],
        ownerFirstName: json["owner_first_name"],
        ownerLastName: json["owner_last_name"],
        ownerAddress: json["owner_address"],
        ownerContactNo: json["owner_contact_no"],
        ownerEmailId: json["owner_email_id"],
        propertyAvailableDate: DateTime.parse(json["property_available_date"]),
        proPaid: json["pro_paid"],
        propertyNeighboorhood: json["property_neighboorhood"],
        sharedOwnership: json["shared_ownership"],
        retHomes: json["ret_homes"],
        undOffer: json["und_offer"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "type_id": typeId,
        "property_type_id": propertyTypeId,
        "property_title": propertyTitle,
        "slug": slug,
        "cost": cost,
        "floorplan": List<dynamic>.from(floorimages!.map((x) => x)),
        "currency": currency,
        "bedrooms": bedrooms,
        "built_up_rate": builtUpRate,
        "built_up_measure": builtUpMeasure,
        "built_up_dimension_width": builtUpDimensionWidth,
        "built_up_dimension_height": builtUpDimensionHeight,
        "built_up_dimension_measure": builtUpDimensionMeasure,
        "land_area_measure": landAreaMeasure,
        "land_dimension_width": landDimensionWidth,
        "land_dimension_height": landDimensionHeight,
        "land_dimension_measure": landDimensionMeasure,
        "property_description": propertyDescription,
        "furnished": furnished,
        "home_listed": homeListed,
        "floor": floor,
        "bathrooms": bathrooms,
        "special_features": specialFeatures,
        "fixture_fitting": fixtureFitting,
        "outdoor_indoor_space": outdoorIndoorSpace,
        "facility": facility,
        "country_id": countryId,
        "country": country,
        "location": location,
        "area_id": areaId,
        "street_no": streetNo,
        "street_name_1": streetName1,
        "street_name_2": streetName2,
        "postcode": postcode,
        "latitude": latitude,
        "longitude": longitude,
        "preference": preference,
        "owner_first_name": ownerFirstName,
        "owner_last_name": ownerLastName,
        "owner_address": ownerAddress,
        "owner_contact_no": ownerContactNo,
        "owner_email_id": ownerEmailId,
        "property_available_date": propertyAvailableDate!.toIso8601String(),
        "pro_paid": proPaid,
        "property_neighboorhood": propertyNeighboorhood,
        "shared_ownership": sharedOwnership,
        "ret_homes": retHomes,
        "und_offer": undOffer,
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}
