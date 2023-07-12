// To parse this JSON data, do
//
//     final newTradesmenDetailModel = newTradesmenDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:bizbultest/models/Tradesmen/CompanyTradesmenList.dart';
import 'package:get/get.dart';

NewTradesmenDetailModel newTradesmenDetailModelFromJson(String str) =>
    NewTradesmenDetailModel.fromJson(json.decode(str));

String newTradesmenDetailModelToJson(NewTradesmenDetailModel data) =>
    json.encode(data.toJson());

class NewTradesmenDetailModel {
  NewTradesmenDetailModel({
    this.status,
    this.record,
  });

  int? status;
  Record? record;

  factory NewTradesmenDetailModel.fromJson(Map<String, dynamic> json) =>
      NewTradesmenDetailModel(
        status: json["status"],
        record: Record.fromJson(json["record"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "record": record!.toJson(),
      };
}

class Record {
  Record({
    this.fullName,
    this.email,
    this.contactNumber,
    this.alternativeContactNumber,
    this.experience,
    this.profileImage,
    this.countryId,
    this.categoryId,
    this.location,
    this.serviceDescription,
    this.workType,
    this.callOut,
    this.insurance,
    this.undertaken,
    this.workArea,
    this.workSubcategory,
    this.albumData,
    this.albumImageUrl,
  });

  String? fullName;
  String? email;
  String? contactNumber;
  dynamic alternativeContactNumber;
  String? experience;
  dynamic profileImage;
  int? countryId;
  int? categoryId;
  String? location;
  String? serviceDescription;
  String? workType;
  String? callOut;
  String? insurance;
  String? undertaken;
  List<WorkArea>? workArea;
  List<int>? workSubcategory;
  List<AlbumDatum>? albumData;
  String? albumImageUrl;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        fullName: json["full_name"],
        email: json["email"],
        contactNumber: json["contact_number"],
        alternativeContactNumber: json["alternative_contact_number"],
        experience: json["experience"],
        profileImage: json["profile_image"],
        countryId: json["country_id"],
        categoryId: json["category_id"] ?? json['work_category'],
        location: json["location"],
        serviceDescription: json["service_description"],
        workType: json["work_type"],
        callOut: json["call_out"],
        insurance: json["insurance"],
        undertaken: json["undertaken"],
        workArea:
            // [],

            List<WorkArea>.from(
                json["work_area"].map((x) => WorkArea.fromJson(x))),
        workSubcategory: List<int>.from(json["work_subcategory"].map((x) => x)),
        albumData: json["album_data"] != null
            ? List<AlbumDatum>.from(
                json["album_data"].map((x) => AlbumDatum.fromJson(x)))
            : [],
        albumImageUrl: json["album_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "email": email,
        "contact_number": contactNumber,
        "alternative_contact_number": alternativeContactNumber,
        "experience": experience,
        "profile_image": profileImage,
        "country_id": countryId,
        "category_id": categoryId,
        "location": location,
        "service_description": serviceDescription,
        "work_type": workType,
        "call_out": callOut,
        "insurance": insurance,
        "undertaken": undertaken,
        "work_area": List<dynamic>.from(workArea!.map((x) => x)),
        "work_subcategory": List<dynamic>.from(workSubcategory!.map((x) => x)),
        "album_data": List<dynamic>.from(albumData!.map((x) => x.toJson())),
        "album_image_url": albumImageUrl,
      };
}

class AlbumDatum2 {
  AlbumDatum2(
      {this.id, this.albumName, this.albumPic, this.images, this.type = 'url'});
  String? type;
  String? id;
  String? albumName;
  String? albumPic;
  String? images;

  factory AlbumDatum2.fromJson(Map<String, dynamic> json) => AlbumDatum2(
      id: json["id"],
      albumName: json["album_name"],
      albumPic: json["album_pic"],
      images: json["images"],
      type: 'url');

  Map<String, dynamic> toJson() => {
        "id": id,
        "album_name": albumName,
        "album_pic": albumPic,
        "images": images,
      };
}

class AlbumDatum {
  AlbumDatum(
      {this.id, this.albumName, this.albumPic, this.images, this.type = 'url'});
  String? type;
  int? id;
  String? albumName;
  String? albumPic;
  RxList<String>? images;

  factory AlbumDatum.fromJson(Map<String, dynamic> json) => AlbumDatum(
      id: json["id"],
      albumName: json["album_name"],
      albumPic: json["album_pic"],
      images: RxList<String>.from(json["images"].map((x) => x)),
      type: 'url');

  Map<String, dynamic> toJson() => {
        "id": id,
        "album_name": albumName,
        "album_pic": albumPic,
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}
