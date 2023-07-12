// To parse this JSON data, do
//
//     final findTradesmenCompanyDetailModel = findTradesmenCompanyDetailModelFromJson(jsonString);

import 'dart:convert';

FindTradesmenCompanyDetailModel findTradesmenCompanyDetailModelFromJson(
        String str) =>
    FindTradesmenCompanyDetailModel.fromJson(json.decode(str));

String findTradesmenCompanyDetailModelToJson(
        FindTradesmenCompanyDetailModel data) =>
    json.encode(data.toJson());

class FindTradesmenCompanyDetailModel {
  FindTradesmenCompanyDetailModel({
    this.status,
    this.data,
    this.review,
    this.reviewCount,
    this.subcategory,
    this.albumBaseUrl,
  });

  int? status;
  Data? data;
  List<Review>? review;
  int? reviewCount;
  List<FindTradesmenCompanyDetailModelSubcategory>? subcategory;
  String? albumBaseUrl;

  factory FindTradesmenCompanyDetailModel.fromJson(Map<String, dynamic> json) =>
      FindTradesmenCompanyDetailModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        review:
            List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        reviewCount: json["review_count"],
        subcategory: List<FindTradesmenCompanyDetailModelSubcategory>.from(
            json["subcategory"].map(
                (x) => FindTradesmenCompanyDetailModelSubcategory.fromJson(x))),
        albumBaseUrl: json["album_base_url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "review": List<dynamic>.from(review!.map((x) => x)),
        "review_count": reviewCount,
        "subcategory": List<dynamic>.from(subcategory!.map((x) => x.toJson())),
        "album_base_url": albumBaseUrl,
      };
}

class Data {
  Data({
    this.id,
    this.memberId,
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
    this.status,
    this.createdAt,
    this.updatedAt,
    this.country,
    this.companyAlbum,
    this.workArea,
  });

  int? id;
  int? memberId;
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
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Country? country;
  List<CompanyAlbum>? companyAlbum;
  List<WorkArea>? workArea;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        memberId: json["user_id"],
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
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        country: Country.fromJson(json["country"]),
        companyAlbum: List<CompanyAlbum>.from(
            json["company_album"].map((x) => CompanyAlbum.fromJson(x))),
        workArea: List<WorkArea>.from(
            json["work_area"].map((x) => WorkArea.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": memberId,
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
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "country": country!.toJson(),
        "company_album": List<CompanyAlbum>.from(companyAlbum!.map((x) => x)),
        "work_area": List<dynamic>.from(workArea!.map((x) => x.toJson())),
      };
}

class CompanyAlbum {
  CompanyAlbum({
    this.id,
    this.tradesmenId,
    this.companyId,
    this.albumName,
    this.albumPic,
    this.images,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  dynamic tradesmenId;
  int? companyId;
  String? albumName;
  String? albumPic;
  String? images;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CompanyAlbum.fromJson(Map<String, dynamic> json) => CompanyAlbum(
        id: json["id"],
        tradesmenId: json["tradesmen_id"],
        companyId: json["company_id"],
        albumName: json["album_name"],
        albumPic: json["album_pic"],
        images: json["images"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tradesmen_id": tradesmenId,
        "company_id": companyId,
        "album_name": albumName,
        "album_pic": albumPic,
        "images": images,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Country {
  Country({
    this.id,
    this.country,
    this.phonecode,
    this.currency,
    this.currencySymbol,
    this.latitude,
    this.longitude,
    this.region,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? country;
  String? phonecode;
  String? currency;
  String? currencySymbol;
  String? latitude;
  String? longitude;
  String? region;
  int? status;
  dynamic? createdAt;
  dynamic? updatedAt;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        country: json["country"],
        phonecode: json["phonecode"],
        currency: json["currency"],
        currencySymbol: json["currency_symbol"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        region: json["region"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "phonecode": phonecode,
        "currency": currency,
        "currency_symbol": currencySymbol,
        "latitude": latitude,
        "longitude": longitude,
        "region": region,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class WorkArea {
  WorkArea({
    this.id,
    this.areaId,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? areaId;
  int? companyId;
  dynamic? createdAt;
  dynamic? updatedAt;

  factory WorkArea.fromJson(Map<String, dynamic> json) => WorkArea(
        id: json["id"],
        areaId: json["area_id"],
        companyId: json["company_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "area_id": areaId,
        "company_id": companyId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class FindTradesmenCompanyDetailModelSubcategory {
  FindTradesmenCompanyDetailModelSubcategory({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.subcategory,
  });

  int? id;
  String? name;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  List<SubcategorySubcategory>? subcategory;

  factory FindTradesmenCompanyDetailModelSubcategory.fromJson(
          Map<String, dynamic> json) =>
      FindTradesmenCompanyDetailModelSubcategory(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        subcategory: List<SubcategorySubcategory>.from(
            json["subcategory"].map((x) => SubcategorySubcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "image": image,
        "subcategory": List<dynamic>.from(subcategory!.map((x) => x.toJson())),
      };
}

class SubcategorySubcategory {
  SubcategorySubcategory({
    this.id,
    this.subcatName,
    this.categoryId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? subcatName;
  int? categoryId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SubcategorySubcategory.fromJson(Map<String, dynamic> json) =>
      SubcategorySubcategory(
        id: json["id"],
        subcatName: json["subcat_name"],
        categoryId: json["category_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subcat_name": subcatName,
        "category_id": categoryId,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Review {
  Review({
    this.id,
    this.tradesmenId,
    this.companyId,
    this.memberId,
    this.reliability,
    this.tidiness,
    this.courtesy,
    this.workmanship,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.member,
  });

  int? id;
  dynamic? tradesmenId;
  int? companyId;
  int? memberId;
  int? reliability;
  int? tidiness;
  int? courtesy;
  int? workmanship;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Member? member;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        tradesmenId: json["tradesmen_id"],
        companyId: json["company_id"],
        memberId: json["user_id"],
        reliability: json["reliability"],
        tidiness: json["tidiness"],
        courtesy: json["courtesy"],
        workmanship: json["workmanship"],
        description: json["description"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        member: Member.fromJson(json["member"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tradesmen_id": tradesmenId,
        "company_id": companyId,
        "user_id": memberId,
        "reliability": reliability,
        "tidiness": tidiness,
        "courtesy": courtesy,
        "workmanship": workmanship,
        "description": description,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "member": member!.toJson(),
      };
}

class Member {
  Member({
    this.id,
    this.name,
    this.username,
    this.profileImage,
    this.email,
  });

  int? id;
  String? name;
  String? username;
  dynamic? profileImage;
  String? email;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        profileImage: json["profile_image"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "profile_image": profileImage,
        "email": email,
      };
}
