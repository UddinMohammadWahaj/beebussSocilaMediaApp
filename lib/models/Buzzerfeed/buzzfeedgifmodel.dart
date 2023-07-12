// To parse this JSON data, do
//
//     final buzzerfeedGif = buzzerfeedGifFromJson(jsonString);

import 'dart:convert';

BuzzerfeedGif buzzerfeedGifFromJson(String str) =>
    BuzzerfeedGif.fromJson(json.decode(str));

String buzzerfeedGifToJson(BuzzerfeedGif data) => json.encode(data.toJson());

class BuzzerfeedGif {
  BuzzerfeedGif({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  int? success;
  int? status;
  String? message;
  List<Datum>? data;

  factory BuzzerfeedGif.fromJson(Map<String, dynamic> json) => BuzzerfeedGif(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.stickerName,
    this.name,
  });

  String? id;
  String? stickerName;
  String? name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        stickerName: json["sticker_name"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sticker_name": stickerName,
        "name": name,
      };
}
