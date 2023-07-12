// To parse this JSON data, do
//
//     final searchTextLocationModel = searchTextLocationModelFromJson(jsonString);

import 'dart:convert';

SearchTextLocationModel searchTextLocationModelFromJson(String str) =>
    SearchTextLocationModel.fromJson(json.decode(str));

String searchTextLocationModelToJson(SearchTextLocationModel data) =>
    json.encode(data.toJson());

class SearchTextLocationModel {
  SearchTextLocationModel({
    this.results,
    this.status,
  });

  List<dynamic>? htmlAttributions = [];
  List<Result>? results;
  String? nextPageToken;
  String? status;

  factory SearchTextLocationModel.fromJson(Map<String, dynamic> json) =>
      SearchTextLocationModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
      };
}

class Result {
  Result({
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.photos,
    this.placeId,
    this.reference,
    this.types,
  });

  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<Photo>? photos;
  String? placeId;
  String? reference;
  List<String>? types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        // icon: json["icon"],
        // iconBackgroundColor: json["icon_background_color"],
        // iconMaskBaseUri: json["icon_mask_base_uri"],
        name: json["name"],
        // photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        // placeId: json["place_id"],
        // reference: json["reference"],
        // types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry!.toJson(),
        // "icon": icon,
        // "icon_background_color": iconBackgroundColor,
        // "icon_mask_base_uri": iconMaskBaseUri,
        "name": name,
        // "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        // "place_id": placeId,
        // "reference": reference,
        // "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Location? location;
  Viewport? viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "viewport": viewport!.toJson(),
      };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location? northeast;
  Location? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast!.toJson(),
        "southwest": southwest!.toJson(),
      };
}

class Photo {
  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  int? height;
  List<dynamic>? htmlAttributions;
  String? photoReference;
  int? width;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        height: json["height"],
        htmlAttributions:
            List<dynamic>.from(json["html_attributions"].map((x) => x)),
        photoReference: json["photo_reference"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "html_attributions":
            List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "photo_reference": photoReference,
        "width": width,
      };
}
