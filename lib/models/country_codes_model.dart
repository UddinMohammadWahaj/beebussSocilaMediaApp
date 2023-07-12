// To parse this JSON data, do
//
//     final countryCodesModel = countryCodesModelFromJson(jsonString);

import 'dart:convert';

List<CountryCodesModel> countryCodesModelFromJson(String str) =>
    List<CountryCodesModel>.from(
        json.decode(str).map((x) => CountryCodesModel.fromJson(x)));

String countryCodesModelToJson(List<CountryCodesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryCodesModel {
  CountryCodesModel({
    this.name,
    this.value,
    this.usersCountry,
  });

  String? name;
  String? value;
  int? usersCountry;

  factory CountryCodesModel.fromJson(Map<String, dynamic> json) =>
      CountryCodesModel(
        name: json["name"],
        value: json["value"],
        usersCountry: json["users_country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "users_country": usersCountry,
      };
}

class CountryCodes {
  List<CountryCodesModel> codes;

  CountryCodes(this.codes);
  factory CountryCodes.fromJson(List<dynamic> parsed) {
    List<CountryCodesModel> codes = <CountryCodesModel>[];
    codes = parsed.map((i) => CountryCodesModel.fromJson(i)).toList();
    return new CountryCodes(codes);
  }
}
