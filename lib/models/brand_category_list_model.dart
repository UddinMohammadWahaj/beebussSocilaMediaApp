// To parse this JSON data, do
//
//     final brandCategoryListModel = brandCategoryListModelFromJson(jsonString);

import 'dart:convert';

List<BrandCategoryListModel> brandCategoryListModelFromJson(String str) =>
    List<BrandCategoryListModel>.from(
        json.decode(str).map((x) => BrandCategoryListModel.fromJson(x)));

String brandCategoryListModelToJson(List<BrandCategoryListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BrandCategoryListModel {
  BrandCategoryListModel({
    this.category,
    this.categoryVal,
  });

  String? category;
  String? categoryVal;
  bool? isSelected = false;

  factory BrandCategoryListModel.fromJson(Map<String, dynamic> json) =>
      BrandCategoryListModel(
        category: json["category"],
        categoryVal: json["category_val"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "category_val": categoryVal,
      };
}

class BrandCategories {
  List<BrandCategoryListModel> categories;

  BrandCategories(this.categories);
  factory BrandCategories.fromJson(List<dynamic> parsed) {
    List<BrandCategoryListModel> categories = <BrandCategoryListModel>[];
    categories = parsed.map((i) => BrandCategoryListModel.fromJson(i)).toList();
    return new BrandCategories(categories);
  }
}
