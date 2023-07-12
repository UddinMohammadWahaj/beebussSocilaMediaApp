// To parse this JSON data, do
//
//     final settingsCountryModel = settingsCountryModelFromJson(jsonString);

import 'dart:convert';

List<SettingsCountryModel> settingsCountryModelFromJson(String str) =>
    List<SettingsCountryModel>.from(
        json.decode(str).map((x) => SettingsCountryModel.fromJson(x)));

String settingsCountryModelToJson(List<SettingsCountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingsCountryModel {
  SettingsCountryModel({
    this.name,
    this.value,
    this.flagIcon,
    this.countryName,
    this.countryValue,
    this.flag,
  });

  String? name;
  String? value;
  String? flagIcon;
  String? countryName;
  String? countryValue;
  String? flag;

  factory SettingsCountryModel.fromJson(Map<String, dynamic> json) =>
      SettingsCountryModel(
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"],
        flagIcon: json["flag_icon"],
        countryName: json["country_name"] == null ? null : json["country_name"],
        countryValue:
            json["country_value"] == null ? null : json["country_value"],
        flag: json["flag"] == null ? null : json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "value": value == null ? null : value,
        "flag_icon": flagIcon,
        "country_name": countryName == null ? null : countryName,
        "country_value": countryValue == null ? null : countryValue,
        "flag": flag == null ? null : flag,
      };
}

class SettingsCountry {
  List<SettingsCountryModel> countries;

  SettingsCountry(this.countries);
  factory SettingsCountry.fromJson(List<dynamic> parsed) {
    List<SettingsCountryModel> countries = <SettingsCountryModel>[];
    countries = parsed.map((i) => SettingsCountryModel.fromJson(i)).toList();
    return new SettingsCountry(countries);
  }
}
