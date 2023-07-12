// To parse this JSON data, do
//
//     final propertyBuyingFilterModel = propertyBuyingFilterModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

List<PropertyBuyingFilterModel> propertyBuyingFilterModelFromJson(String str) =>
    List<PropertyBuyingFilterModel>.from(
        json.decode(str).map((x) => PropertyBuyingFilterModel.fromJson(x)));

String propertyBuyingFilterModelToJson(List<PropertyBuyingFilterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PropertyBuyingFilterModel {
  PropertyBuyingFilterModel({
    this.filter,
    this.value,
    required this.selected,
  });

  String? filter;
  int? value;
  Rx<bool> selected;

  factory PropertyBuyingFilterModel.fromJson(Map<String, dynamic> json) =>
      PropertyBuyingFilterModel(
        filter: json["filter"],
        value: json["value"],
        selected: false.obs,
      );

  Map<String, dynamic> toJson() => {
        "filter": filter,
        "value": value,
      };
}
