// To parse this JSON data, do
//
//     final blogBuzzListModel = blogBuzzListModelFromJson(jsonString);

import 'dart:convert';

List<BlogBuzzListModel> blogBuzzListModelFromJson(String str) =>
    List<BlogBuzzListModel>.from(
        json.decode(str).map((x) => BlogBuzzListModel.fromJson(x)));

String blogBuzzListModelToJson(List<BlogBuzzListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogBuzzListModel {
  BlogBuzzListModel({
    this.categoryName,
    this.categoryVal,
    this.color,
  });

  String? categoryName;
  bool? color = false;
  dynamic categoryVal;

  factory BlogBuzzListModel.fromJson(Map<String, dynamic> json) =>
      BlogBuzzListModel(
        categoryName: json["category_name"],
        categoryVal: json["category_val"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "category_name": categoryName,
        "category_val": categoryVal,
      };
}

class Categories {
  List<BlogBuzzListModel> categories;

  Categories(this.categories);
  factory Categories.fromJson(List<dynamic> parsed) {
    List<BlogBuzzListModel> categories = <BlogBuzzListModel>[];
    categories = parsed.map((i) => BlogBuzzListModel.fromJson(i)).toList();
    return new Categories(categories);
  }
}
