// To parse this JSON data, do
//
//     final shopbuzCollectionListModel = shopbuzCollectionListModelFromJson(jsonString);

import 'dart:convert';

ShopbuzCollectionListModel shopbuzCollectionListModelFromJson(String str) =>
    ShopbuzCollectionListModel.fromJson(json.decode(str));

String shopbuzCollectionListModelToJson(ShopbuzCollectionListModel data) =>
    json.encode(data.toJson());

class ShopbuzCollectionListModel {
  ShopbuzCollectionListModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<ShopbuzCollectionListDatum>? data;

  factory ShopbuzCollectionListModel.fromJson(Map<String, dynamic> json) =>
      ShopbuzCollectionListModel(
        status: json["status"],
        message: json["message"],
        data: List<ShopbuzCollectionListDatum>.from(
            json["data"].map((x) => ShopbuzCollectionListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShopbuzCollectionListDatum {
  ShopbuzCollectionListDatum({
    this.collectionId,
    this.collectionName,
    this.wishlistIds,
    this.totalWish,
    this.productImages,
    this.createdAt,
  });

  int? collectionId;
  String? collectionName;
  String? wishlistIds;
  int? totalWish;
  List<String>? productImages;
  String? createdAt;

  factory ShopbuzCollectionListDatum.fromJson(Map<String, dynamic> json) =>
      ShopbuzCollectionListDatum(
        collectionId: json["collection_id"],
        collectionName: json["collection_name"],
        wishlistIds: json["wishlist_ids"],
        totalWish: json["total_wish"],
        productImages: List<String>.from(json["product_images"].map((x) => x)),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "collection_id": collectionId,
        "collection_name": collectionName,
        "wishlist_ids": wishlistIds,
        "total_wish": totalWish,
        "product_images": List<dynamic>.from(productImages!.map((x) => x)),
        "created_at": createdAt,
      };
}
