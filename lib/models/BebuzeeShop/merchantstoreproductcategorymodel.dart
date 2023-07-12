// To parse this JSON data, do
//
//     final merchantStoreProductCategory = merchantStoreProductCategoryFromJson(jsonString);

import 'dart:convert';

MerchantStoreProductCategory merchantStoreProductCategoryFromJson(String str) =>
    MerchantStoreProductCategory.fromJson(json.decode(str));

String merchantStoreProductCategoryToJson(MerchantStoreProductCategory data) =>
    json.encode(data.toJson());

class MerchantStoreProductCategory {
  MerchantStoreProductCategory({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<MerchantStoreProductCategoryDatum>? data;

  factory MerchantStoreProductCategory.fromJson(Map<String, dynamic> json) =>
      MerchantStoreProductCategory(
        status: json["status"],
        message: json["message"],
        data: List<MerchantStoreProductCategoryDatum>.from(json["data"]
            .map((x) => MerchantStoreProductCategoryDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MerchantStoreProductCategoryDatum {
  MerchantStoreProductCategoryDatum(
      {this.categoryId, this.categoryName, this.categoryImage});

  int? categoryId;
  String? categoryName;
  String? categoryImage;

  factory MerchantStoreProductCategoryDatum.fromJson(
          Map<String, dynamic> json) =>
      MerchantStoreProductCategoryDatum(
          categoryId: json["category_id"],
          categoryName: json["category_name"],
          categoryImage: json['category_image']);

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
      };
}
