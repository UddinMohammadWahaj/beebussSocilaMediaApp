// To parse this JSON data, do
//
//     final AllTradesmenUnderCompanyModelList = AllTradesmenUnderCompanyModelListFromJson(jsonString);

import 'dart:convert';

AllTradesmenUnderCompanyModelList AllTradesmenUnderCompanyModelListFromJson(
        String str) =>
    AllTradesmenUnderCompanyModelList.fromJson(json.decode(str));

String AllTradesmenUnderCompanyModelListToJson(
        AllTradesmenUnderCompanyModelList data) =>
    json.encode(data.toJson());

class AllTradesmenUnderCompanyModelList {
  AllTradesmenUnderCompanyModelList({
    this.status,
    this.data,
  });

  int? status;
  List<TradesmenUnderCompanyDatum>? data;

  factory AllTradesmenUnderCompanyModelList.fromJson(
          Map<String, dynamic> json) =>
      AllTradesmenUnderCompanyModelList(
        status: json["status"],
        data: List<TradesmenUnderCompanyDatum>.from(
            json["data"].map((x) => TradesmenUnderCompanyDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TradesmenUnderCompanyDatum {
  TradesmenUnderCompanyDatum({
    this.tradesmenId,
    this.fullName,
    this.companyId,
    this.email,
    this.contactNumber,
    this.alternativeContactNumber,
    this.profileImage,
    this.experience,
    this.countryId,
    this.location,
    this.workCategory,
    this.serviceDescription,
    this.workType,
    this.callOutHours,
    this.publicLibility,
    this.workUndertaken,
    this.status,
    this.workArea,
    this.workSubcategory,
  });

  int? tradesmenId;
  String? fullName;
  int? companyId;
  String? email;
  dynamic contactNumber;
  String? alternativeContactNumber;
  dynamic profileImage;
  String? experience;
  int? countryId;
  String? location;
  int? workCategory;
  String? serviceDescription;
  String? workType;
  String? callOutHours;
  String? publicLibility;
  String? workUndertaken;
  String? status;
  List<WorkArea>? workArea;
  List<int>? workSubcategory;

  factory TradesmenUnderCompanyDatum.fromJson(Map<String, dynamic> json) =>
      TradesmenUnderCompanyDatum(
        tradesmenId: json["tradesmen_id"],
        fullName: json["full_name"],
        companyId: json["company_id"],
        email: json["email"],
        contactNumber: json["contact_number"],
        alternativeContactNumber: json["alternative_contact_number"],
        profileImage: json["profile_image"],
        experience: json["experience"],
        countryId: json["country_id"],
        location: json["location"],
        workCategory: json["work_category"],
        serviceDescription: json["service_description"],
        workType: json["work_type"],
        callOutHours: json["call_out_hours"],
        publicLibility: json["public_libility"],
        workUndertaken: json["work_undertaken"],
        status: json["status"],
        workArea: List<WorkArea>.from(
            json["work_area"].map((x) => WorkArea.fromJson(x))),
        workSubcategory: List<int>.from(json["work_subcategory"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "tradesmen_id": tradesmenId,
        "full_name": fullName,
        "company_id": companyId,
        "email": email,
        "contact_number": contactNumber,
        "alternative_contact_number": alternativeContactNumber,
        "profile_image": profileImage,
        "experience": experience,
        "country_id": countryId,
        "location": location,
        "work_category": workCategory,
        "service_description": serviceDescription,
        "work_type": workType,
        "call_out_hours": callOutHours,
        "public_libility": publicLibility,
        "work_undertaken": workUndertaken,
        "status": status,
        "work_area": List<dynamic>.from(workArea!.map((x) => x.toJson())),
        "work_subcategory": List<dynamic>.from(workSubcategory!.map((x) => x)),
      };
}

class WorkArea {
  WorkArea({
    this.area,
    this.areaId,
  });

  String? area;
  int? areaId;

  factory WorkArea.fromJson(Map<String, dynamic> json) => WorkArea(
        area: json["area"],
        areaId: json["area_id"],
      );

  Map<String, dynamic> toJson() => {
        "area": area,
        "area_id": areaId,
      };
}
