// To parse this JSON data, do
//
//     final blogCountriesModel = blogCountriesModelFromJson(jsonString);

import 'dart:convert';

List<BlogCountriesModel> blogCountriesModelFromJson(String str) =>
    List<BlogCountriesModel>.from(
        json.decode(str).map((x) => BlogCountriesModel.fromJson(x)));

// To parse this JSON data, do
//
//     final blogCountriesModel = blogCountriesModelFromJson(jsonString);

class BlogCountriesModel {
  BlogCountriesModel({
    this.region,
    this.data,
  });

  String? region;
  List<Datum>? data;

  factory BlogCountriesModel.fromJson(Map<String, dynamic> json) =>
      BlogCountriesModel(
        region: json["region"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({this.country, this.value, this.flag, this.languages, this.hide});

  String? country;
  String? value;
  String? flag;
  List<dynamic>? languages;
  bool? hide = false;
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        country: json["country"],
        value: json["value"],
        flag: json["flag"],
        languages: json["languages"],
        hide: false,
      );
}

class BlogCountries {
  List<BlogCountriesModel> countries;
  BlogCountries(this.countries);
  factory BlogCountries.fromJson(List<dynamic> parsed) {
    List<BlogCountriesModel> countries = <BlogCountriesModel>[];
    countries = parsed.map((i) => BlogCountriesModel.fromJson(i)).toList();
    return new BlogCountries(countries);
  }
}
