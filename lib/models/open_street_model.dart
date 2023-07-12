// To parse this JSON data, do
//
//     final openStreetModel = openStreetModelFromJson(jsonString);

import 'dart:convert';

List<OpenStreetModel> openStreetModelFromJson(String str) =>
    List<OpenStreetModel>.from(
        json.decode(str).map((x) => OpenStreetModel.fromJson(x)));

String openStreetModelToJson(List<OpenStreetModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OpenStreetModel {
  OpenStreetModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.boundingbox,
    this.lat,
    this.lon,
    this.displayName,
    this.openStreetModelClass,
    this.type,
    this.importance,
    this.icon,
  });

  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  List<String>? boundingbox;
  String? lat;
  String? lon;
  String? displayName;
  String? openStreetModelClass;
  String? type;
  double? importance;
  String? icon;

  factory OpenStreetModel.fromJson(Map<String, dynamic> json) =>
      OpenStreetModel(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        openStreetModelClass: json["class"],
        type: json["type"],
        importance: json["importance"].toDouble(),
        icon: json["icon"] == null ? null : json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "boundingbox": List<dynamic>.from(boundingbox!.map((x) => x)),
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "class": openStreetModelClass,
        "type": type,
        "importance": importance,
        "icon": icon == null ? null : icon,
      };
}

class OpenStreet {
  List<OpenStreetModel> coordinates;

  OpenStreet(this.coordinates);

  factory OpenStreet.fromJson(List<dynamic> parsed) {
    List<OpenStreetModel> coordinates = <OpenStreetModel>[];
    coordinates = parsed.map((i) => OpenStreetModel.fromJson(i)).toList();
    return new OpenStreet(coordinates);
  }
}
