// To parse this JSON data, do
//
//     final propertyTypeFilterModel = propertyTypeFilterModelFromJson(jsonString);

import 'dart:convert';

List<PropertyTypeFilterModel> propertyTypeFilterModelFromJson(String str) =>
    List<PropertyTypeFilterModel>.from(
        json.decode(str).map((x) => PropertyTypeFilterModel.fromJson(x)));

class PropertyTypeFilterModel {
  PropertyTypeFilterModel({
    this.propertyTypeId,
    this.propertyType,
  });

  String? propertyTypeId;
  String? propertyType;

  factory PropertyTypeFilterModel.fromJson(Map<String, dynamic> json) =>
      PropertyTypeFilterModel(
        propertyTypeId: json["property_type_id"],
        propertyType: json["property_type"],
      );
}

class PropertyTypes {
  List<PropertyTypeFilterModel> types;
  PropertyTypes(this.types);
  factory PropertyTypes.fromJson(List<dynamic> parsed) {
    List<PropertyTypeFilterModel> types = <PropertyTypeFilterModel>[];
    types = parsed.map((i) => PropertyTypeFilterModel.fromJson(i)).toList();
    return new PropertyTypes(types);
  }
}
