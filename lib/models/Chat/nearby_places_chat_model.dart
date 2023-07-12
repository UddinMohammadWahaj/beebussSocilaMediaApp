// To parse this JSON data, do
//
//     final nearbyPlacesChatModel = nearbyPlacesChatModelFromJson(jsonString);

import 'dart:convert';

List<NearbyPlacesChatModel> nearbyPlacesChatModelFromJson(String str) =>
    List<NearbyPlacesChatModel>.from(
        json.decode(str).map((x) => NearbyPlacesChatModel.fromJson(x)));

String nearbyPlacesChatModelToJson(List<NearbyPlacesChatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NearbyPlacesChatModel {
  NearbyPlacesChatModel({
    this.name,
    this.phone,
    this.type,
    this.latitude,
    this.longitude,
    this.addressLine,
    this.formattedAddress,
  });

  String? name;
  String? phone;
  String? type;
  double? latitude;
  double? longitude;
  String? addressLine;
  String? formattedAddress;

  factory NearbyPlacesChatModel.fromJson(Map<String, dynamic> json) =>
      NearbyPlacesChatModel(
        name: json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        type: json["type"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        addressLine: json["addressLine"],
        formattedAddress: json["formattedAddress"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone == null ? null : phone,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "addressLine": addressLine,
        "formattedAddress": formattedAddress,
      };
}

class NearbyPlaces {
  List<NearbyPlacesChatModel> places;

  NearbyPlaces(this.places);
  factory NearbyPlaces.fromJson(List<dynamic> parsed) {
    List<NearbyPlacesChatModel> places = <NearbyPlacesChatModel>[];
    places = parsed.map((i) => NearbyPlacesChatModel.fromJson(i)).toList();
    return new NearbyPlaces(places);
  }
}
