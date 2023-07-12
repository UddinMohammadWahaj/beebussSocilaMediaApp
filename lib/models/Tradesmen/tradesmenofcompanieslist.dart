// To parse this JSON data, do
//
//     final trandemenUnderCompanyModelList = trandemenUnderCompanyModelListFromJson(jsonString);

import 'dart:convert';

TrandemenUnderCompanyModelList trandemenUnderCompanyModelListFromJson(
        String str) =>
    TrandemenUnderCompanyModelList.fromJson(json.decode(str));

String trandemenUnderCompanyModelListToJson(
        TrandemenUnderCompanyModelList data) =>
    json.encode(data.toJson());

class TrandemenUnderCompanyModelList {
  TrandemenUnderCompanyModelList({
    this.status,
    this.data,
  });

  int? status;
  TradesmenUnderCompanyData? data;

  factory TrandemenUnderCompanyModelList.fromJson(Map<String, dynamic> json) =>
      TrandemenUnderCompanyModelList(
        status: json["status"],
        data: TradesmenUnderCompanyData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
      };
}

class TradesmenUnderCompanyData {
  TradesmenUnderCompanyData({
    this.companyId,
    this.companyName,
    this.companyEmail,
    this.companyContactNumber,
    this.companyWebsite,
    this.companyCoverPhoto,
    this.companyLogo,
    this.countryId,
    this.countryLocation,
    this.managerName,
    this.managerContactNumber,
    this.serviceDescription,
    this.tradesmen,
  });

  int? companyId;
  String? companyName;
  String? companyEmail;
  String? companyContactNumber;
  String? companyWebsite;
  String? companyCoverPhoto;
  String? companyLogo;
  String? countryId;
  dynamic countryLocation;
  String? managerName;
  String? managerContactNumber;
  String? serviceDescription;
  List<Tradesman>? tradesmen;

  factory TradesmenUnderCompanyData.fromJson(Map<String, dynamic> json) =>
      TradesmenUnderCompanyData(
        companyId: json["company_id"],
        companyName: json["company_name"],
        companyEmail: json["company_email"],
        companyContactNumber: json["company_contact_number"],
        companyWebsite: json["company_website"],
        companyCoverPhoto: json["company_cover_photo"],
        companyLogo: json["company_logo"],
        countryId: json["country_id"],
        countryLocation: json["country_location"],
        managerName: json["manager_name"],
        managerContactNumber: json["manager_contact_number"],
        serviceDescription: json["service_description"],
        tradesmen: List<Tradesman>.from(
            json["tradesmen"].map((x) => Tradesman.fromJson(x))),
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
        "country_location": countryLocation,
        "manager_name": managerName,
        "manager_contact_number": managerContactNumber,
        "service_description": serviceDescription,
        "tradesmen": List<dynamic>.from(tradesmen!.map((x) => x.toJson())),
      };
}

class Tradesman {
  Tradesman({
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
  });

  int? tradesmenId;
  String? fullName;
  int? companyId;
  String? email;
  String? contactNumber;
  dynamic? alternativeContactNumber;
  String? profileImage;
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

  factory Tradesman.fromJson(Map<String, dynamic> json) => Tradesman(
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
      };
}
