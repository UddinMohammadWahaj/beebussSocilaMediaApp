// To parse this JSON data, do
//
//     final brandModel = brandModelFromJson(jsonString);

import 'dart:convert';

List<BrandModel> brandModelFromJson(String str) =>
    List<BrandModel>.from(json.decode(str).map((x) => BrandModel.fromJson(x)));

String brandModelToJson(List<BrandModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BrandModel {
  BrandModel({
    this.image,
    this.link,
    this.profileLink,
    this.content,
    this.name,
    this.categoryVal,
    this.brandCategory,
  });

  String? image;
  String? link;
  String? profileLink;
  String? content;
  String? name;
  String? categoryVal;
  String? brandCategory;

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        image: json["image"],
        link: json["link"],
        profileLink: json["profile_link"],
        content: json["content"],
        name: json["name"],
        categoryVal: json["category_val"],
        brandCategory: json["brand_category"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "link": link,
        "profile_link": profileLink,
        "content": content,
        "name": name,
        "category_val": categoryVal,
        "brand_category": brandCategory,
      };
}

class Brands {
  List<BrandModel> brands;

  Brands(this.brands);
  factory Brands.fromJson(List<dynamic> parsed) {
    List<BrandModel> brands = <BrandModel>[];
    brands = parsed.map((i) => BrandModel.fromJson(i)).toList();
    return new Brands(brands);
  }
}
