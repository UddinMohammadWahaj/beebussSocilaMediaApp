// To parse this JSON data, do
//
//     final merchantStoreProductList = merchantStoreProductListFromJson(jsonString);

import 'dart:convert';

MerchantStoreProductList merchantStoreProductListFromJson(String str) =>
    MerchantStoreProductList.fromJson(json.decode(str));

String merchantStoreProductListToJson(MerchantStoreProductList data) =>
    json.encode(data.toJson());

class MerchantStoreProductList {
  MerchantStoreProductList({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<MerchantStoreProductListDatum>? data;

  factory MerchantStoreProductList.fromJson(Map<String, dynamic> json) =>
      MerchantStoreProductList(
        status: json["status"],
        message: json["message"],
        data: List<MerchantStoreProductListDatum>.from(
            json["data"].map((x) => MerchantStoreProductListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MerchantStoreProductListDatum {
  MerchantStoreProductListDatum({
    this.productId,
    this.userId,
    this.userName,
    this.userProfile,
    this.storeId,
    this.storeName,
    this.productName,
    this.productDetails,
    this.productBrand,
    this.productSku,
    this.productColor,
    this.productSize,
    this.productPrise,
    this.sellingPrise,
    this.priseCurrency,
    this.embedVideo,
    this.buyLink,
    this.productImages,
  });

  int? productId;
  int? userId;
  String? userName;
  String? userProfile;
  int? storeId;
  String? storeName;
  String? productName;
  String? productDetails;
  String? productBrand;
  String? productSku;
  String? productColor;
  String? productSize;
  int? productPrise;
  int? sellingPrise;
  String? priseCurrency;
  String? embedVideo;
  String? buyLink;
  List<String>? productImages;

  factory MerchantStoreProductListDatum.fromJson(Map<String, dynamic> json) =>
      MerchantStoreProductListDatum(
        productId: json["product_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        userProfile: json["user_profile"],
        storeId: json["store_id"],
        storeName: json["store_name"],
        productName: json["product_name"],
        productDetails: json["product_details"],
        productBrand: json["product_brand"],
        productSku: json["product_sku"],
        productColor: json["product_color"],
        productSize: json["product_size"],
        productPrise: json["product_prise"],
        sellingPrise: json["selling_prise"],
        priseCurrency: json["prise_currency"],
        embedVideo: json["embed_video"],
        buyLink: json["buy_link"],
        productImages: List<String>.from(json["product_images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "user_id": userId,
        "user_name": userName,
        "user_profile": userProfile,
        "store_id": storeId,
        "store_name": storeName,
        "product_name": productName,
        "product_details": productDetails,
        "product_brand": productBrand,
        "product_sku": productSku,
        "product_color": productColor,
        "product_size": productSize,
        "product_prise": productPrise,
        "selling_prise": sellingPrise,
        "prise_currency": priseCurrency,
        "embed_video": embedVideo,
        "buy_link": buyLink,
        "product_images": List<dynamic>.from(productImages!.map((x) => x)),
      };
}
