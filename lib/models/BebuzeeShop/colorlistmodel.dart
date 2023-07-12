// To parse this JSON data, do
//
//     final colorListModel = colorListModelFromJson(jsonString);

import 'dart:convert';

ColorListModel colorListModelFromJson(String str) =>
    ColorListModel.fromJson(json.decode(str));

String colorListModelToJson(ColorListModel data) => json.encode(data.toJson());

class ColorListModel {
  ColorListModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<ColorDatum>? data;

  factory ColorListModel.fromJson(Map<String, dynamic> json) => ColorListModel(
        status: json["status"],
        message: json["message"],
        data: List<ColorDatum>.from(
            json["data"].map((x) => ColorDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ColorDatum {
  ColorDatum({
    this.colorId,
    this.colorName,
    this.hasCode,
  });

  int? colorId;
  String? colorName;
  String? hasCode;

  factory ColorDatum.fromJson(Map<String, dynamic> json) => ColorDatum(
        colorId: json["color_id"],
        colorName: json["color_name"],
        hasCode: json["has_code"],
      );

  Map<String, dynamic> toJson() => {
        "color_id": colorId,
        "color_name": colorName,
        "has_code": hasCode,
      };
}
