// To parse this JSON data, do
//
//     final findTradesmenSoloDetailModel = findTradesmenSoloDetailModelFromJson(jsonString);

import 'dart:convert';

FindTradesmenSoloDetailModel findTradesmenSoloDetailModelFromJson(String str) =>
    FindTradesmenSoloDetailModel.fromJson(json.decode(str));

String findTradesmenSoloDetailModelToJson(FindTradesmenSoloDetailModel data) =>
    json.encode(data.toJson());

class FindTradesmenSoloDetailModel {
  FindTradesmenSoloDetailModel({
    this.status,
    this.tradesmen,
    this.review,
    this.reviewCount,
    this.subcategory,
    this.albumBaseUrl,
  });

  int? status;
  Tradesmen? tradesmen;
  List<Review>? review;
  int? reviewCount;
  List<SubcategoryElement>? subcategory;
  String? albumBaseUrl;

  factory FindTradesmenSoloDetailModel.fromJson(Map<String, dynamic> json) =>
      FindTradesmenSoloDetailModel(
        status: json["status"],
        tradesmen: Tradesmen.fromJson(json["tradesmen"]),
        review:
            List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        reviewCount: json["review_count"],
        subcategory: List<SubcategoryElement>.from(
            json["subcategory"].map((x) => SubcategoryElement.fromJson(x))),
        albumBaseUrl: json["album_base_url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "tradesmen": tradesmen!.toJson(),
        "review": List<dynamic>.from(review!.map((x) => x.toJson())),
        "review_count": reviewCount,
        "subcategory": List<dynamic>.from(subcategory!.map((x) => x.toJson())),
        "album_base_url": albumBaseUrl,
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
  int? tradesmenId;
  dynamic companyId;
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
  String? profileImage;
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

class SubcategoryElement {
  SubcategoryElement({
    this.id,
    this.tradesmenId,
    this.subcategoryId,
    this.subcategory,
  });

  int? id;
  int? tradesmenId;
  int? subcategoryId;
  SubcategorySubcategory? subcategory;

  factory SubcategoryElement.fromJson(Map<String, dynamic> json) =>
      SubcategoryElement(
        id: json["id"],
        tradesmenId: json["tradesmen_id"],
        subcategoryId: json["subcategory_id"],
        subcategory: SubcategorySubcategory.fromJson(json["subcategory"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tradesmen_id": tradesmenId,
        "subcategory_id": subcategoryId,
        "subcategory": subcategory!.toJson(),
      };
}

class SubcategorySubcategory {
  SubcategorySubcategory({
    this.id,
    this.subcatName,
    this.categoryId,
  });

  int? id;
  String? subcatName;
  int? categoryId;

  factory SubcategorySubcategory.fromJson(Map<String, dynamic> json) =>
      SubcategorySubcategory(
        id: json["id"],
        subcatName: json["subcat_name"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subcat_name": subcatName,
        "category_id": categoryId,
      };
}

class Tradesmen {
  Tradesmen({
    this.id,
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
    this.country,
    this.album,
    this.category,
    this.workArea,
  });

  int? id;
  int? memberId;
  dynamic? companyId;
  String? fullName;
  String? email;
  String? mobile;
  dynamic? atMobile;
  String? profile;
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
  Country? country;
  List<Album>? album;
  Category? category;
  List<WorkArea>? workArea;

  factory Tradesmen.fromJson(Map<String, dynamic> json) => Tradesmen(
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
        country: Country.fromJson(json["country"]),
        album: List<Album>.from(json["album"].map((x) => Album.fromJson(x))),
        category: Category.fromJson(json["category"]),
        workArea: List<WorkArea>.from(
            json["work_area"].map((x) => WorkArea.fromJson(x))),
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
        "country": country!.toJson(),
        "album": List<dynamic>.from(album!.map((x) => x.toJson())),
        "category": category!.toJson(),
        "work_area": List<dynamic>.from(workArea!.map((x) => x.toJson())),
      };
}

class Album {
  Album({
    this.id,
    this.tradesmenId,
    this.albumName,
    this.albumPic,
    this.images,
  });

  int? id;
  int? tradesmenId;
  String? albumName;
  String? albumPic;
  String? images;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"],
        tradesmenId: json["tradesmen_id"],
        albumName: json["album_name"],
        albumPic: json["album_pic"],
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tradesmen_id": tradesmenId,
        "album_name": albumName,
        "album_pic": albumPic,
        "images": images,
      };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Country {
  Country({
    this.id,
    this.country,
  });

  int? id;
  String? country;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
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
  dynamic createdAt;
  dynamic updatedAt;

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
