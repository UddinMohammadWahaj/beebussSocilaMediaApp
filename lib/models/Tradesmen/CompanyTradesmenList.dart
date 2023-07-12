// To parse this JSON data, do
//
//     final companyTradesmenListModel = companyTradesmenListModelFromJson(jsonString);

import 'dart:convert';

CompanyTradesmenListModel companyTradesmenListModelFromJson(String str) =>
    CompanyTradesmenListModel.fromJson(json.decode(str));

String companyTradesmenListModelToJson(CompanyTradesmenListModel data) =>
    json.encode(data.toJson());

class CompanyTradesmenListModel {
  CompanyTradesmenListModel({
    this.status,
    this.record,
  });

  int? status;
  List<CompanyTradesmenListRecord>? record;

  factory CompanyTradesmenListModel.fromJson(Map<String, dynamic> json) =>
      CompanyTradesmenListModel(
        status: json["status"],
        record: List<CompanyTradesmenListRecord>.from(
            json["record"].map((x) => CompanyTradesmenListRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "record": List<dynamic>.from(record!.map((x) => x.toJson())),
      };
}

class CompanyTradesmenListRecord {
  CompanyTradesmenListRecord({
    this.companyId,
    this.companyName,
    this.companyEmail,
    this.companyContactNumber,
    this.companyWebsite,
    this.companyCoverPhoto,
    this.companyLogo,
    this.countryId,
    this.companyLocation,
    this.managerName,
    this.managerContactNumber,
    this.serviceDescription,
    this.createdAt,
    this.updatedAt,
    this.albumImageUrl,
    this.workArea,
    this.albumMedia,
  });

  int? companyId;
  String? companyName;
  String? companyEmail;
  String? companyContactNumber;
  String? companyWebsite;
  String? companyCoverPhoto;
  String? companyLogo;
  String? countryId;
  String? companyLocation;
  String? managerName;
  String? managerContactNumber;
  String? serviceDescription;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? albumImageUrl;
  List<WorkArea>? workArea;
  List<AlbumMedia>? albumMedia;

  factory CompanyTradesmenListRecord.fromJson(Map<String, dynamic> json) =>
      CompanyTradesmenListRecord(
        companyId: json["company_id"],
        companyName: json["company_name"],
        companyEmail: json["company_email"],
        companyContactNumber: json["company_contact_number"],
        companyWebsite: json["company_website"],
        companyCoverPhoto: json["company_cover_photo"],
        companyLogo: json["company_logo"],
        countryId: json["country_id"],
        companyLocation: json["company_location"],
        managerName: json["manager_name"],
        managerContactNumber: json["manager_contact_number"],
        serviceDescription: json["service_description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        albumImageUrl: json["album_image_url"],
        workArea: List<WorkArea>.from(
            json["work_area"].map((x) => WorkArea.fromJson(x))),
        albumMedia: List<AlbumMedia>.from(
            json["album_media"].map((x) => AlbumMedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "company_name": companyName,
        "company_email": companyEmail,
        "company_contact_number": companyContactNumber,
        "company_website": companyWebsite,
        "company_cover_photo": companyCoverPhoto,
        "company_logo": companyLogo,
        "country_id": countryId,
        "company_location": companyLocation,
        "manager_name": managerName,
        "manager_contact_number": managerContactNumber,
        "service_description": serviceDescription,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "album_image_url": albumImageUrl,
        "work_area": List<dynamic>.from(workArea!.map((x) => x.toJson())),
        "album_media": List<dynamic>.from(albumMedia!.map((x) => x.toJson())),
      };
}

class AlbumMedia {
  AlbumMedia({
    this.id,
    this.albumName,
    this.albumPic,
    this.images,
  });

  int? id;
  String? albumName;
  String? albumPic;
  List<dynamic>? images;

  factory AlbumMedia.fromJson(Map<String, dynamic> json) => AlbumMedia(
        id: json["id"],
        albumName: json["album_name"],
        albumPic: json["album_pic"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "album_name": albumName,
        "album_pic": albumPic,
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}

class WorkArea {
  WorkArea({
    this.city,
    this.areaId,
  });

  String? city;
  int? areaId;

  factory WorkArea.fromJson(Map<String, dynamic> json) => WorkArea(
        city: json["area"] ?? json['city'],
        areaId: json["area_id"],
      );

  Map<String, dynamic> toJson() => {
        "area": city,
        "area_id": areaId,
      };
}
