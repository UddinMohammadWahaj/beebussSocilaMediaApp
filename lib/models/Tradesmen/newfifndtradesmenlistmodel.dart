// To parse this JSON data, do
//
//     final findTradesmeenListModel = findTradesmeenListModelFromJson(jsonString);

import 'dart:convert';

FindTradesmeenListModel findTradesmeenListModelFromJson(String str) =>
    FindTradesmeenListModel.fromJson(json.decode(str));

String findTradesmeenListModelToJson(FindTradesmeenListModel data) =>
    json.encode(data.toJson());

class FindTradesmeenListModel {
  FindTradesmeenListModel({
    this.status,
    this.record,
  });

  int? status;
  List<FindTradesmenRecord>? record;

  factory FindTradesmeenListModel.fromJson(Map<String, dynamic> json) =>
      FindTradesmeenListModel(
        status: json["status"],
        record: List<FindTradesmenRecord>.from(
            json["record"].map((x) => FindTradesmenRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "record": List<dynamic>.from(record!.map((x) => x.toJson())),
      };
}

class FindTradesmenRecord {
  FindTradesmenRecord(
      {this.id,
      this.memberId,
      this.companyId,
      this.fullName,
      this.email,
      this.mobile,
      this.atMobile,
      this.profile,
      this.experience,
      this.countryId,
      this.location,
      this.categoryId,
      this.description,
      this.workType,
      this.callOutHours,
      this.publicLibility,
      this.workUndertaken,
      this.status,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.companyName,
      this.companyEmail,
      this.companyWebsite,
      this.companyLocation,
      this.companyCoverPhoto,
      this.country,
      this.count,
      this.distance,
      this.companyLogo});

  int? id;
  int? memberId;
  int? companyId;
  String? fullName;
  String? email;
  String? mobile;
  String? atMobile;
  dynamic? profile;
  String? experience;
  int? countryId;
  String? location;
  int? categoryId;
  String? description;
  String? workType;
  String? callOutHours;
  String? publicLibility;
  String? workUndertaken;
  String? status;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? companyName;
  String? companyEmail;
  String? companyWebsite;
  String? companyLocation;
  String? companyCoverPhoto;
  String? companyLogo;
  String? country;
  int? count;
  double? distance;

  factory FindTradesmenRecord.fromJson(Map<String, dynamic> json) =>
      FindTradesmenRecord(
        id: json["id"],
        memberId: json["user_id"],
        companyId: json["company_id"],
        fullName: json["full_name"],
        email: json["email"],
        mobile: json["mobile"],
        atMobile: json["at_mobile"],
        profile: json["profile"],
        experience: json["experience"],
        countryId: json["country_id"],
        location: json["location"],
        categoryId: json["category_id"],
        description: json["description"],
        workType: json["work_type"],
        callOutHours: json["call_out_hours"],
        publicLibility: json["public_libility"],
        workUndertaken: json["work_undertaken"],
        status: json["status"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        companyName: json["company_name"],
        companyEmail: json["company_email"],
        companyWebsite: json["company_website"],
        companyLocation: json["company_location"],
        companyCoverPhoto: json["company_cover_photo"],
        country: json["country"],
        count: json["count"],
        distance: json["distance"].toDouble(),
        companyLogo: json['company_logo'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": memberId,
        "company_id": companyId,
        "full_name": fullName,
        "email": email,
        "mobile": mobile,
        "at_mobile": atMobile,
        "profile": profile,
        "experience": experience,
        "country_id": countryId,
        "location": location,
        "category_id": categoryId,
        "description": description,
        "work_type": workType,
        "call_out_hours": callOutHours,
        "public_libility": publicLibility,
        "work_undertaken": workUndertaken,
        "status": status,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "company_name": companyName,
        "company_email": companyEmail,
        "company_website": companyWebsite,
        "company_location": companyLocation,
        "company_cover_photo": companyCoverPhoto,
        "country": country,
        "count": count,
        "distance": distance,
      };
}
