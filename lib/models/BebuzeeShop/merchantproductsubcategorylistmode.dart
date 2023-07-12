// To parse this JSON data, do
//
//     final merchantStoreProductSubCategory = merchantStoreProductSubCategoryFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

MerchantStoreProductSubCategory merchantStoreProductSubCategoryFromJson(
        String str) =>
    MerchantStoreProductSubCategory.fromJson(json.decode(str));

String merchantStoreProductSubCategoryToJson(
        MerchantStoreProductSubCategory data) =>
    json.encode(data.toJson());

class MerchantStoreProductSubCategory {
  MerchantStoreProductSubCategory({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<MerchantStoreProductSubCategoryDatum>? data;

  factory MerchantStoreProductSubCategory.fromJson(Map<String, dynamic> json) =>
      MerchantStoreProductSubCategory(
        status: json["status"],
        message: json["message"],
        data: List<MerchantStoreProductSubCategoryDatum>.from(json["data"]
            .map((x) => MerchantStoreProductSubCategoryDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MerchantStoreProductSubCategoryDatum {
  MerchantStoreProductSubCategoryDatum(
      {this.subcategoryId,
      this.subcategoryName,
      this.subCategoryHeader,
      this.isSelected});

  int? subcategoryId;
  String? subcategoryName;
  RxBool? isSelected = false.obs;
  String? subCategoryHeader;

  factory MerchantStoreProductSubCategoryDatum.fromJson(
          Map<String, dynamic> json) =>
      MerchantStoreProductSubCategoryDatum(
          subcategoryId: json["subcategory_id"],
          isSelected: false.obs,
          subcategoryName: json["subcategory_name"],
          subCategoryHeader: json["subcategory_header"].toString());

  Map<String, dynamic> toJson() => {
        "subcategory_id": subcategoryId,
        "subcategory_name": subcategoryName,
        "subcategory_header": subCategoryHeader
      };
}
