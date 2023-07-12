// To parse this JSON data, do
//
//     final placeModel = placeModelFromJson(jsonString);

import 'dart:convert';

List<PlaceModel> placeModelFromJson(String str) =>
    List<PlaceModel>.from(json.decode(str).map((x) => PlaceModel.fromJson(x)));

String placeModelToJson(List<PlaceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaceModel {
  PlaceModel({
    this.name,
    this.formattedAddress,
  });

  String? name;
  String? formattedAddress;

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        name: json["name"],
        formattedAddress: json["formatted_address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "formatted_address": formattedAddress,
      };
}

class Places {
  List<PlaceModel> places;

  Places(this.places);
  factory Places.fromJson(List<dynamic> parsed) {
    List<PlaceModel> places = <PlaceModel>[];
    places = parsed.map((i) => PlaceModel.fromJson(i)).toList();
    return new Places(places);
  }
}
