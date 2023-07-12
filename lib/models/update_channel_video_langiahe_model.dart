// To parse this JSON data, do
//
//     final updateChannelVideoLanguageModel = updateChannelVideoLanguageModelFromJson(jsonString);

import 'dart:convert';

List<UpdateChannelVideoLanguageModel> updateChannelVideoLanguageModelFromJson(
        String str) =>
    List<UpdateChannelVideoLanguageModel>.from(json
        .decode(str)
        .map((x) => UpdateChannelVideoLanguageModel.fromJson(x)));

String updateChannelVideoLanguageModelToJson(
        List<UpdateChannelVideoLanguageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdateChannelVideoLanguageModel {
  UpdateChannelVideoLanguageModel({
    this.countryId,
    this.countryName,
  });

  String? countryId;
  String? countryName;

  factory UpdateChannelVideoLanguageModel.fromJson(Map<String, dynamic> json) =>
      UpdateChannelVideoLanguageModel(
        countryId: json["country_id"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "country_id": countryId,
        "country_name": countryName,
      };
}

class ChannelLanguages {
  List<UpdateChannelVideoLanguageModel> languages;

  ChannelLanguages(this.languages);
  factory ChannelLanguages.fromJson(List<dynamic> parsed) {
    List<UpdateChannelVideoLanguageModel> languages =
        <UpdateChannelVideoLanguageModel>[];
    languages =
        parsed.map((i) => UpdateChannelVideoLanguageModel.fromJson(i)).toList();
    return new ChannelLanguages(languages);
  }
}
