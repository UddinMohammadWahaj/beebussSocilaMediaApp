// To parse this JSON data, do
//
//     final shopbuzStoreDetails = shopbuzStoreDetailsFromJson(jsonString);

import 'dart:convert';

ShopbuzStoreDetails shopbuzStoreDetailsFromJson(String str) =>
    ShopbuzStoreDetails.fromJson(json.decode(str));

String shopbuzStoreDetailsToJson(ShopbuzStoreDetails data) =>
    json.encode(data.toJson());

class ShopbuzStoreDetails {
  ShopbuzStoreDetails({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  ShopbuzStoreDetailsData? data;

  factory ShopbuzStoreDetails.fromJson(Map<String, dynamic> json) =>
      ShopbuzStoreDetails(
        status: json["status"],
        message: json["message"],
        data: ShopbuzStoreDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class ShopbuzStoreDetailsData {
  ShopbuzStoreDetailsData({
    this.storeId,
    this.userId,
    this.userName,
    this.userProfile,
    this.storeName,
    this.storeDetails,
    this.websiteLink,
    this.storeAddress,
    this.countryId,
    this.userToken,
    this.storeIcon,
  });

  int? storeId;
  int? userId;
  String? userName;
  String? userProfile;
  String? storeName;
  String? storeDetails;
  String? websiteLink;
  String? storeAddress;
  String? countryId;
  String? storeIcon;
  String? userToken;

  factory ShopbuzStoreDetailsData.fromJson(Map<String, dynamic> json) =>
      ShopbuzStoreDetailsData(
          storeId: json["store_id"],
          userId: json["user_id"],
          userName: json["user_name"],
          userProfile: json["user_profile"],
          storeName: json["store_name"],
          storeDetails: json["store_details"],
          websiteLink: json["website_link"],
          storeAddress: json["store_address"],
          countryId: json["country_id"].toString(),
          storeIcon: json["store_icon"],
          userToken: json['user_token']);

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "user_id": userId,
        "user_name": userName,
        "user_profile": userProfile,
        "store_name": storeName,
        "store_details": storeDetails,
        "website_link": websiteLink,
        "store_address": storeAddress,
        "country_id": countryId,
        "store_icon": storeIcon,
      };
}
