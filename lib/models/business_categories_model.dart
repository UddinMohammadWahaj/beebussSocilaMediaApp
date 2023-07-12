// To parse this JSON data, do
//
//     final businessCategoryModel = businessCategoryModelFromJson(jsonString);

import 'dart:convert';

List<BusinessCategoryModel> businessCategoryModelFromJson(String str) =>
    List<BusinessCategoryModel>.from(
        json.decode(str).map((x) => BusinessCategoryModel.fromJson(x)));

String businessCategoryModelToJson(List<BusinessCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessCategoryModel {
  BusinessCategoryModel({
    this.category,
    this.categoryId,
  });

  String? category;
  String? categoryId;

  factory BusinessCategoryModel.fromJson(Map<String, dynamic> json) =>
      BusinessCategoryModel(
        category: json["category"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "category_id": categoryId,
      };
}

class BusinessCategories {
  List<BusinessCategoryModel> categories;

  BusinessCategories(this.categories);
  factory BusinessCategories.fromJson(List<dynamic> parsed) {
    List<BusinessCategoryModel> categories = <BusinessCategoryModel>[];
    categories = parsed.map((i) => BusinessCategoryModel.fromJson(i)).toList();
    return new BusinessCategories(categories);
  }
}
