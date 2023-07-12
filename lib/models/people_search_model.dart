// To parse this JSON data, do
//
//     final peopleSearchModel = peopleSearchModelFromJson(jsonString);

import 'dart:convert';

List<PeopleSearchModel> peopleSearchModelFromJson(String str) =>
    List<PeopleSearchModel>.from(
        json.decode(str).map((x) => PeopleSearchModel.fromJson(x)));

String peopleSearchModelToJson(List<PeopleSearchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PeopleSearchModel {
  PeopleSearchModel({
    this.memberId,
    this.image,
    this.name,
    this.shortcode,
    this.varified,
    this.url,
  });

  String? memberId;
  String? image;
  String? name;
  String? shortcode;
  String? varified;
  String? url;

  factory PeopleSearchModel.fromJson(Map<String, dynamic> json) =>
      PeopleSearchModel(
        memberId: json["user_id"],
        image: json["image"],
        name: json["name"],
        shortcode: json["shortcode"],
        varified: json["varified"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "image": image,
        "name": name,
        "shortcode": shortcode,
        "varified": varified,
        "url": url,
      };
}

class TagsSearch {
  List<PeopleSearchModel> people;

  TagsSearch(this.people);

  factory TagsSearch.fromJson(List<dynamic> parsed) {
    List<PeopleSearchModel> people = <PeopleSearchModel>[];
    people = parsed.map((i) => PeopleSearchModel.fromJson(i)).toList();
    return new TagsSearch(people);
  }
}
