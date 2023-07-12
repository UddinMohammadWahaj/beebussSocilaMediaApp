// To parse this JSON data, do
//
//     final tagSearchModel = tagSearchModelFromJson(jsonString);

import 'dart:convert';

List<TagSearchModel> tagSearchModelFromJson(String str) =>
    List<TagSearchModel>.from(
        json.decode(str).map((x) => TagSearchModel.fromJson(x)));

String tagSearchModelToJson(List<TagSearchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TagSearchModel {
  TagSearchModel({
    this.name,
  });

  String? name;

  factory TagSearchModel.fromJson(Map<String, dynamic> json) => TagSearchModel(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class TagPlaces {
  List<TagSearchModel> searchTags;

  TagPlaces(this.searchTags);
  factory TagPlaces.fromJson(List<dynamic> parsed) {
    List<TagSearchModel> searchTags = <TagSearchModel>[];
    searchTags = parsed.map((i) => TagSearchModel.fromJson(i)).toList();
    return new TagPlaces(searchTags);
  }
}
