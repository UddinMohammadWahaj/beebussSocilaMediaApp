// To parse this JSON data, do
//
//     final updateChannelVideoCountryModel = updateChannelVideoCountryModelFromJson(jsonString);

import 'dart:convert';

List<UpdateChannelVideoCountryModel> updateChannelVideoCountryModelFromJson(
        String str) =>
    List<UpdateChannelVideoCountryModel>.from(json
        .decode(str)
        .map((x) => UpdateChannelVideoCountryModel.fromJson(x)));

String updateChannelVideoCountryModelToJson(
        List<UpdateChannelVideoCountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdateChannelVideoCountryModel {
  UpdateChannelVideoCountryModel({
    this.countryId,
    this.countryName,
  });

  String? countryId;
  String? countryName;

  factory UpdateChannelVideoCountryModel.fromJson(Map<String, dynamic> json) =>
      UpdateChannelVideoCountryModel(
        countryId: json["country_id"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "country_id": countryId,
        "country_name": countryName,
      };
}

class ChannelCountries {
  List<UpdateChannelVideoCountryModel> countries;

  ChannelCountries(this.countries);
  factory ChannelCountries.fromJson(List<dynamic> parsed) {
    List<UpdateChannelVideoCountryModel> countries =
        <UpdateChannelVideoCountryModel>[];
    countries =
        parsed.map((i) => UpdateChannelVideoCountryModel.fromJson(i)).toList();
    return new ChannelCountries(countries);
  }
}
