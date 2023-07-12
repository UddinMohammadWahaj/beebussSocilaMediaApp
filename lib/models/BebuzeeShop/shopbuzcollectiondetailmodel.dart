// To parse this JSON data, do
//
//     final shopbuzCollectionDetailModel = shopbuzCollectionDetailModelFromJson(jsonString);

import 'dart:convert';

ShopbuzCollectionDetailModel shopbuzCollectionDetailModelFromJson(String str) =>
    ShopbuzCollectionDetailModel.fromJson(json.decode(str));

String shopbuzCollectionDetailModelToJson(ShopbuzCollectionDetailModel data) =>
    json.encode(data.toJson());

class ShopbuzCollectionDetailModel {
  ShopbuzCollectionDetailModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory ShopbuzCollectionDetailModel.fromJson(Map<String, dynamic> json) =>
      ShopbuzCollectionDetailModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.collectionId,
    this.collectionName,
    this.wishlistIds,
    this.totalWish,
    this.wishlistData,
    this.createdAt,
  });

  int? collectionId;
  String? collectionName;
  String? wishlistIds;
  int? totalWish;
  List<WishlistDatum>? wishlistData;
  String? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        collectionId: json["collection_id"],
        collectionName: json["collection_name"],
        wishlistIds: json["wishlist_ids"],
        totalWish: json["total_wish"],
        wishlistData: List<WishlistDatum>.from(
            json["wishlist_Data"].map((x) => WishlistDatum.fromJson(x))),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "collection_id": collectionId,
        "collection_name": collectionName,
        "wishlist_ids": wishlistIds,
        "total_wish": totalWish,
        "wishlist_Data":
            List<dynamic>.from(wishlistData!.map((x) => x.toJson())),
        "created_at": createdAt,
      };
}

class WishlistDatum {
  WishlistDatum({
    this.wishlistId,
    this.productId,
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
  });

  int? wishlistId;
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

  factory WishlistDatum.fromJson(Map<String, dynamic> json) => WishlistDatum(
        wishlistId: json["wishlist_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        productDetails: json["product_details"],
        productBrand: json["product_brand"],
        productColor: json["product_color"],
        productPrise: json["product_prise"],
        sellingPrise: json["selling_prise"],
        priseCurrency: json["prise_currency"],
        buyLink: json["buy_link"],
        productImages: List<String>.from(json["product_images"].map((x) => x)),
        productWishlist: json["product_wishlist"],
        productReview: json["product_review"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "wishlist_id": wishlistId,
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
