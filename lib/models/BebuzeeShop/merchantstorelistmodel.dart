// To parse this JSON data, do
//
//     final merchantStoreList = merchantStoreListFromJson(jsonString);

import 'dart:convert';

MerchantStoreList merchantStoreListFromJson(String str) =>
    MerchantStoreList.fromJson(json.decode(str));

String merchantStoreListToJson(MerchantStoreList data) =>
    json.encode(data.toJson());

class MerchantStoreList {
  MerchantStoreList({
    this.data,
  });

  List<MerchantStoreListDatum>? data;

  factory MerchantStoreList.fromJson(Map<String, dynamic> json) =>
      MerchantStoreList(
        data: List<MerchantStoreListDatum>.from(
            json["data"].map((x) => MerchantStoreListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MerchantStoreListDatum {
  MerchantStoreListDatum({
    this.storeId,
    this.userId,
    this.userName,
    this.userProfile,
    this.storeName,
    this.storeDetails,
    this.websiteLink,
    this.storeAddress,
    this.countryId,
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

  factory MerchantStoreListDatum.fromJson(Map<String, dynamic> json) =>
      MerchantStoreListDatum(
        storeId: json["store_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        userProfile: json["user_profile"],
        storeName: json["store_name"],
        storeDetails: json["store_details"],
        websiteLink: json["website_link"],
        storeAddress: json["store_address"],
        countryId: json["country_id"],
        storeIcon: json["store_icon"],
      );

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
