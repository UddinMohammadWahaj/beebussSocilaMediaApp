// To parse this JSON data, do
//
//     final genresModel = genresModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<GenresModel> genresModelFromJson(String str) => List<GenresModel>.from(
    json.decode(str).map((x) => GenresModel.fromJson(x)));

class GenresModel {
  GenresModel({this.categoryId, this.categoryName, this.selected});

  String? categoryId;
  String? categoryName;
  RxBool? selected;

  factory GenresModel.fromJson(Map<String, dynamic> json) => GenresModel(
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      selected: new RxBool(false));
}

class Genres {
  List<GenresModel> genres;

  Genres(this.genres);
  factory Genres.fromJson(List<dynamic> parsed) {
    List<GenresModel> categories = <GenresModel>[];
    categories = parsed.map((i) => GenresModel.fromJson(i)).toList();
    return new Genres(categories);
  }
}
