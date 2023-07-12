// To parse this JSON data, do
//
//     final recipeCategoryModel = recipeCategoryModelFromJson(jsonString);

import 'dart:convert';

List<RecipeCategoryModel> recipeCategoryModelFromJson(String str) =>
    List<RecipeCategoryModel>.from(
        json.decode(str).map((x) => RecipeCategoryModel.fromJson(x)));

String recipeCategoryModelToJson(List<RecipeCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecipeCategoryModel {
  RecipeCategoryModel({
    this.category,
    this.cateID,
    this.categorySub,
    this.image,
    this.color,
  });

  String? category;
  String? cateID;
  String? categorySub;
  String? image;
  String? color;

  factory RecipeCategoryModel.fromJson(Map<String, dynamic> json) =>
      RecipeCategoryModel(
          category: json["category"],
          cateID: json["cateid"],
          categorySub: json["category_sub"],
          image: json["image"],
          color: json["color"]);

  Map<String, dynamic> toJson() => {
        "category": category,
        "cateid": cateID,
        "category_sub": categorySub,
        "image": image,
        "color": color
      };
}

class Recipes {
  List<RecipeCategoryModel> recipes;

  Recipes(this.recipes);
  factory Recipes.fromJson(List<dynamic> parsed) {
    List<RecipeCategoryModel> recipes = <RecipeCategoryModel>[];
    recipes = parsed.map((i) => RecipeCategoryModel.fromJson(i)).toList();
    return new Recipes(recipes);
  }
}
