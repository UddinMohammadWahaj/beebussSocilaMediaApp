// To parse this JSON data, do
//
//     final audienceModel = audienceModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<AudienceModel> audienceModelFromJson(String str) =>
    List<AudienceModel>.from(
        json.decode(str).map((x) => AudienceModel.fromJson(x)));

String audienceModelToJson(List<AudienceModel> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class AudienceModel {
  AudienceModel(
      {this.audienceId,
      this.audienceName,
      this.audienceLocation,
      this.audienceAgeData,
      this.audienceGenderType,
      this.selected});

  String? audienceId;
  String? audienceName;
  String? audienceLocation;
  String? audienceAgeData;
  String? audienceGenderType;
  RxBool? selected;

  factory AudienceModel.fromJson(Map<String, dynamic> json) => AudienceModel(
      audienceId: json["audience_id"],
      audienceName: json["audience_name"],
      audienceLocation: json["audience_location"],
      audienceAgeData: json["audience_age_data"],
      audienceGenderType: json["audience_gender_type"],
      selected: new RxBool(false));

  Map<String, dynamic> toJson() => {
        "audience_id": audienceId,
        "audience_name": audienceName,
        "audience_location": audienceLocation,
        "audience_age_data": audienceAgeData,
        "audience_gender_type": audienceGenderType,
      };
}

class Audiences {
  List<AudienceModel> audiences;

  Audiences(this.audiences);

  factory Audiences.fromJson(List<dynamic> parsed) {
    List<AudienceModel> audiences = <AudienceModel>[];
    audiences = parsed.map((i) => AudienceModel.fromJson(i)).toList();
    return new Audiences(audiences);
  }
}
