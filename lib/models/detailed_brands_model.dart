// To parse this JSON data, do
//
//     final detailedBrandModel = detailedBrandModelFromJson(jsonString);

import 'dart:convert';

List<DetailedBrandModel> detailedBrandModelFromJson(String str) =>
    List<DetailedBrandModel>.from(
        json.decode(str).map((x) => DetailedBrandModel.fromJson(x)));

String detailedBrandModelToJson(List<DetailedBrandModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailedBrandModel {
  DetailedBrandModel({
    this.id,
    this.image,
    this.description,
    this.name,
    this.category,
    this.categoryVal,
  });

  String? id;
  String? image;
  String? description;
  String? name;
  String? category;
  String? categoryVal;
  bool showInfo = false;

  factory DetailedBrandModel.fromJson(Map<String, dynamic> json) =>
      DetailedBrandModel(
        id: json["id"],
        image: json["image"],
        description: json["description"],
        name: json["name"],
        category: json["category"],
        categoryVal: json["category_val"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "description": description,
        "name": name,
        "category": category,
        "category_val": categoryVal,
      };
}

class DetailedBrands {
  List<DetailedBrandModel> brands;

  DetailedBrands(this.brands);
  factory DetailedBrands.fromJson(List<dynamic> parsed) {
    List<DetailedBrandModel> brands = <DetailedBrandModel>[];
    brands = parsed.map((i) => DetailedBrandModel.fromJson(i)).toList();
    return new DetailedBrands(brands);
  }
}
