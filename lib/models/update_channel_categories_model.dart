// To parse this JSON data, do
//
//     final updateChannelVideoCategoryModel = updateChannelVideoCategoryModelFromJson(jsonString);

import 'dart:convert';

List<UpdateChannelVideoCategoryModel> updateChannelVideoCategoryModelFromJson(String str) => List<UpdateChannelVideoCategoryModel>.from(json.decode(str).map((x) => UpdateChannelVideoCategoryModel.fromJson(x)));

String updateChannelVideoCategoryModelToJson(List<UpdateChannelVideoCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdateChannelVideoCategoryModel {
  UpdateChannelVideoCategoryModel({
    this.dataCategory,
  });

  String? dataCategory;

  factory UpdateChannelVideoCategoryModel.fromJson(Map<String, dynamic> json) => UpdateChannelVideoCategoryModel(
    dataCategory: json["data_category"],
  );

  Map<String, dynamic> toJson() => {
    "data_category": dataCategory,
  };
}

class ChannelCategories {
  List<UpdateChannelVideoCategoryModel> categories;

  ChannelCategories(this.categories);
  factory ChannelCategories.fromJson(List<dynamic> parsed) {
    List<UpdateChannelVideoCategoryModel> categories = <UpdateChannelVideoCategoryModel>[];
    categories = parsed.map((i) => UpdateChannelVideoCategoryModel.fromJson(i)).toList();
    return new ChannelCategories(categories);
  }
}