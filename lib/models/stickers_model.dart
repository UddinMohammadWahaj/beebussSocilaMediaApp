// To parse this JSON data, do
//
//     final stickersModel = stickersModelFromJson(jsonString);

import 'dart:convert';

List<StickersModel> stickersModelFromJson(String str) =>
    List<StickersModel>.from(
        json.decode(str).map((x) => StickersModel.fromJson(x)));

String stickersModelToJson(List<StickersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StickersModel {
  StickersModel({
    this.id,
    this.name,
    this.stickerName,
  });

  String? id;
  String? name;
  String? stickerName;

  factory StickersModel.fromJson(Map<String, dynamic> json) => StickersModel(
        id: json["id"],
        name: json["name"],
        stickerName: json["sticker_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sticker_name": stickerName,
      };
}

class Stickers {
  List<StickersModel> stickers;
  Stickers(this.stickers);
  factory Stickers.fromJson(List<dynamic> parsed) {
    List<StickersModel> stickers = <StickersModel>[];
    stickers = parsed.map((i) => StickersModel.fromJson(i)).toList();
    return new Stickers(stickers);
  }
}
