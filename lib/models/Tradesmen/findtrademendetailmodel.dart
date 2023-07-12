// To parse this JSON data, do
//
//     final findTradesmenDetatilModel = findTradesmenDetatilModelFromJson(jsonString);

import 'dart:convert';

FindTradesmenDetatilModel findTradesmenDetatilModelFromJson(String str) =>
    FindTradesmenDetatilModel.fromJson(json.decode(str));

String findTradesmenDetatilModelToJson(FindTradesmenDetatilModel data) =>
    json.encode(data.toJson());

class FindTradesmenDetatilModel {
  FindTradesmenDetatilModel({
    this.status,
    this.tradesmen,
    this.review,
    this.reviewCount,
    this.subcategory,
  });

  int? status;
  Tradesmen? tradesmen;
  List<FindTradesmenReview>? review;
  int? reviewCount;
  List<FindTradesmenSubcategoryElement>? subcategory;

  factory FindTradesmenDetatilModel.fromJson(Map<String, dynamic> json) =>
      FindTradesmenDetatilModel(
        status: json["status"],
        tradesmen: Tradesmen.fromJson(json["tradesmen"]),
        review: List<FindTradesmenReview>.from(
            json["review"].map((x) => FindTradesmenReview.fromJson(x))),
        reviewCount: json["review_count"],
        subcategory: List<FindTradesmenSubcategoryElement>.from(
            json["subcategory"]
                .map((x) => FindTradesmenSubcategoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "tradesmen": tradesmen!.toJson(),
        "review": List<dynamic>.from(review!.map((x) => x.toJson())),
        "review_count": reviewCount,
        "subcategory": List<dynamic>.from(subcategory!.map((x) => x.toJson())),
      };
}

class FindTradesmenReview {
  FindTradesmenReview({
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
  FindTradesmenMember? member;

  factory FindTradesmenReview.fromJson(Map<String, dynamic> json) =>
      FindTradesmenReview(
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
        member: FindTradesmenMember.fromJson(json["member"]),
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

class FindTradesmenMember {
  FindTradesmenMember({
    this.id,
    this.name,
    this.username,
    this.accountType,
    this.profileImage,
    this.email,
    this.emailVerifiedAt,
    this.countryCode,
    this.mobile,
    this.gender,
    this.birthdate,
    this.relationshipStatus,
    this.minimalFollowing,
    this.homePicOfTheDay,
    this.status,
    this.verified,
    this.accessStatus,
    this.viewCount,
    this.creator,
    this.bio,
    this.designation,
    this.privateAccount,
    this.directMessage,
    this.profileCategoryId,
    this.categoryDisplay,
    this.contactDisplay,
    this.deviceType,
    this.firebaseToken,
    this.tradesmenType,
    this.activatedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.tradeSubscribe,
    this.tradeStartDate,
    this.subscriptionId,
    this.merchantSubscriptionType,
  });

  int? id;
  String? name;
  String? username;
  String? accountType;
  String? profileImage;
  String? email;
  dynamic emailVerifiedAt;
  String? countryCode;
  String? mobile;
  String? gender;
  String? birthdate;
  String? relationshipStatus;
  String? minimalFollowing;
  String? homePicOfTheDay;
  String? status;
  int? verified;
  String? accessStatus;
  int? viewCount;
  String? creator;
  String? bio;
  String? designation;
  String? privateAccount;
  String? directMessage;
  int? profileCategoryId;
  String? categoryDisplay;
  String? contactDisplay;
  String? deviceType;
  String? firebaseToken;
  dynamic? tradesmenType;
  String? activatedAt;
  String? lastLoginAt;
  DateTime? createdAt;
  String? updatedAt;
  int? tradeSubscribe;
  dynamic tradeStartDate;
  dynamic subscriptionId;
  dynamic merchantSubscriptionType;

  factory FindTradesmenMember.fromJson(Map<String, dynamic> json) =>
      FindTradesmenMember(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        accountType: json["account_type"],
        profileImage: json["profile_image"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        relationshipStatus: json["relationship_status"],
        minimalFollowing: json["minimal_following"],
        homePicOfTheDay: json["home_pic_of_the_day"],
        status: json["status"],
        verified: json["verified"],
        accessStatus: json["access_status"],
        viewCount: json["view_count"],
        creator: json["creator"],
        bio: json["bio"],
        designation: json["designation"],
        privateAccount: json["private_account"],
        directMessage: json["direct_message"],
        profileCategoryId: json["profile_category_id"],
        categoryDisplay: json["category_display"],
        contactDisplay: json["contact_display"],
        deviceType: json["device_type"],
        firebaseToken: json["firebase_token"],
        tradesmenType: json["tradesmen_type"],
        activatedAt: json["activated_at"],
        lastLoginAt: json["last_login_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        tradeSubscribe: json["trade_subscribe"],
        tradeStartDate: json["trade_start_date"],
        subscriptionId: json["subscription_id"],
        merchantSubscriptionType: json["merchant_subscription_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "account_type": accountType,
        "profile_image": profileImage,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "country_code": countryCode,
        "mobile": mobile,
        "gender": gender,
        "birthdate": birthdate,
        "relationship_status": relationshipStatus,
        "minimal_following": minimalFollowing,
        "home_pic_of_the_day": homePicOfTheDay,
        "status": status,
        "verified": verified,
        "access_status": accessStatus,
        "view_count": viewCount,
        "creator": creator,
        "bio": bio,
        "designation": designation,
        "private_account": privateAccount,
        "direct_message": directMessage,
        "profile_category_id": profileCategoryId,
        "category_display": categoryDisplay,
        "contact_display": contactDisplay,
        "device_type": deviceType,
        "firebase_token": firebaseToken,
        "tradesmen_type": tradesmenType,
        "activated_at": activatedAt,
        "last_login_at": lastLoginAt,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at": updatedAt,
        "trade_subscribe": tradeSubscribe,
        "trade_start_date": tradeStartDate,
        "subscription_id": subscriptionId,
        "merchant_subscription_type": merchantSubscriptionType,
      };
}

class FindTradesmenSubcategoryElement {
  FindTradesmenSubcategoryElement({
    this.id,
    this.tradesmenId,
    this.subcategoryId,
    this.subcategory,
  });

  int? id;
  int? tradesmenId;
  int? subcategoryId;
  SubcategorySubcategory? subcategory;

  factory FindTradesmenSubcategoryElement.fromJson(Map<String, dynamic> json) =>
      FindTradesmenSubcategoryElement(
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
  List<dynamic>? workArea;

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
        workArea: List<dynamic>.from(json["work_area"].map((x) => x)),
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
        "work_area": List<dynamic>.from(workArea!.map((x) => x)),
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
