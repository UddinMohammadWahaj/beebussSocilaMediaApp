// To parse this JSON data, do
//
//     final shopbuzWishlistListModel = shopbuzWishlistListModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

ShopbuzWishlistListModel shopbuzWishlistListModelFromJson(String str) =>
    ShopbuzWishlistListModel.fromJson(json.decode(str));

String shopbuzWishlistListModelToJson(ShopbuzWishlistListModel data) =>
    json.encode(data.toJson());

class ShopbuzWishlistListModel {
  ShopbuzWishlistListModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<ShopbuzWishlistListDatum>? data;

  factory ShopbuzWishlistListModel.fromJson(Map<String, dynamic> json) =>
      ShopbuzWishlistListModel(
        status: json["status"],
        message: json["message"],
        data: List<ShopbuzWishlistListDatum>.from(
            json["data"].map((x) => ShopbuzWishlistListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShopbuzWishlistListDatum {
  ShopbuzWishlistListDatum(
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
      this.categoryName,
      this.categoryId,
      this.wishlistId,
      this.inWishlist,
      this.isCollection});

  int? productId;
  String? productName;
  String? productDetails;
  String? productBrand;
  String? productColor;
  int? productPrise;
  int? sellingPrise;
  String? priseCurrency;
  String? buyLink;
  List<String>? productImages;
  bool? productWishlist;
  int? productReview;
  String? createdAt;
  String? categoryName;
  String? categoryId;
  RxBool? inWishlist;
  RxBool? isCollection;
  String? wishlistId;
  factory ShopbuzWishlistListDatum.fromJson(Map<String, dynamic> json) =>
      ShopbuzWishlistListDatum(
          productId: json["product_id"],
          productName: json["product_name"],
          productDetails: json["product_details"],
          productBrand: json["product_brand"],
          productColor: json["product_color"],
          productPrise: json["product_prise"],
          sellingPrise: json["selling_prise"],
          priseCurrency: json["prise_currency"],
          wishlistId: json['wishlist_id'].toString(),
          buyLink: json["buy_link"],
          productImages:
              List<String>.from(json["product_images"].map((x) => x)),
          productWishlist: json["product_wishlist"],
          productReview: json["product_review"],
          createdAt: json["created_at"],
          categoryId: json["category_id"].toString(),
          categoryName: json["category_name"],
          inWishlist: true.obs,
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
