// To parse this JSON data, do
//
//     final shopBuzProductList = shopBuzProductListFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

ShopBuzProductList shopBuzProductListFromJson(String str) =>
    ShopBuzProductList.fromJson(json.decode(str));

String shopBuzProductListToJson(ShopBuzProductList data) =>
    json.encode(data.toJson());

class ShopBuzProductList {
  ShopBuzProductList({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<ShopBuzProductDatum>? data;

  factory ShopBuzProductList.fromJson(Map<String, dynamic> json) =>
      ShopBuzProductList(
        status: json["status"],
        message: json["message"],
        data: List<ShopBuzProductDatum>.from(
            json["data"].map((x) => ShopBuzProductDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShopBuzProductDatum {
  ShopBuzProductDatum(
      {this.productId,
      this.productName,
      this.productDetails,
      this.productBrand,
      this.productColor,
      this.productPrise,
      this.sellingPrise,
      this.priseCurrency,
      this.buyLink,
      this.productImages,
      this.productWishlist,
      this.productReview,
      this.createdAt,
      this.categoryId,
      this.page,
      this.isCollection});

  int? productId;
  String? productName;
  String? productDetails;
  String? productBrand;
  String? productColor;
  int? productPrise;
  int? sellingPrise;
  String? priseCurrency;
  String? categoryId;
  String? buyLink;
  List<String>? productImages;
  RxBool? productWishlist;
  int? productReview;
  String? createdAt;
  RxBool? isCollection;
  String? page;
  factory ShopBuzProductDatum.fromJson(Map<String, dynamic> json) =>
      ShopBuzProductDatum(
          categoryId: json['category_id'].toString(),
          productId: json["product_id"],
          productName: json["product_name"],
          productDetails: json["product_details"],
          productBrand: json["product_brand"],
          productColor: json["product_color"],
          productPrise: json["product_prise"],
          sellingPrise: json["selling_prise"],
          priseCurrency: json["prise_currency"],
          buyLink: json["buy_link"],
          productImages:
              List<String>.from(json["product_images"].map((x) => x)),
          productWishlist:
              json["product_wishlist"] == true ? true.obs : false.obs,
          productReview: json["product_review"],
          createdAt: json["created_at"],
          page: json['page'].toString(),
          isCollection: false.obs);

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_details": productDetails,
        "product_brand": productBrand,
        "product_color": productColor,
        "product_prise": productPrise,
        "selling_prise": sellingPrise,
        "prise_currency": priseCurrency,
        "buy_link": buyLink,
        "product_images": List<dynamic>.from(productImages!.map((x) => x)),
        "product_wishlist": productWishlist,
        "product_review": productReview,
        "created_at": createdAt,
      };
}
