// To parse this JSON data, do
//
//     final collectionDetailListModel = collectionDetailListModelFromJson(jsonString);

import 'dart:convert';

CollectionDetailListModel collectionDetailListModelFromJson(String str) =>
    CollectionDetailListModel.fromJson(json.decode(str));

String collectionDetailListModelToJson(CollectionDetailListModel data) =>
    json.encode(data.toJson());

class CollectionDetailListModel {
  CollectionDetailListModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  CollectionDatumData? data;

  factory CollectionDetailListModel.fromJson(Map<String, dynamic> json) =>
      CollectionDetailListModel(
        status: json["status"],
        message: json["message"],
        data: CollectionDatumData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class CollectionDatumData {
  CollectionDatumData({
    this.collectionId,
    this.collectionName,
    this.wishlistIds,
    this.totalWish,
    this.wishlistCollectionDatumData,
    this.createdAt,
  });

  late int? collectionId;
  String? collectionName;
  String? wishlistIds;
  int? totalWish;
  List<WishlistCollectionDatum>? wishlistCollectionDatumData;
  String? createdAt;

  factory CollectionDatumData.fromJson(Map<String, dynamic> json) =>
      CollectionDatumData(
        collectionId: json["collection_id"],
        collectionName: json["collection_name"],
        wishlistIds: json["wishlist_ids"],
        totalWish: json["total_wish"],
        wishlistCollectionDatumData: List<WishlistCollectionDatum>.from(
            json["wishlist_CollectionDatumData"]
                .map((x) => WishlistCollectionDatum.fromJson(x))),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "collection_id": collectionId,
        "collection_name": collectionName,
        "wishlist_ids": wishlistIds,
        "total_wish": totalWish,
        "wishlist_CollectionDatumData": List<dynamic>.from(
            wishlistCollectionDatumData!.map((x) => x.toJson())),
        "created_at": createdAt,
      };
}

class WishlistCollectionDatum {
  WishlistCollectionDatum({
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

  factory WishlistCollectionDatum.fromJson(Map<String, dynamic> json) =>
      WishlistCollectionDatum(
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
