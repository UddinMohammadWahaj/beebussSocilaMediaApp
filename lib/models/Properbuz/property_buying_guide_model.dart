// To parse this JSON data, do
//
//     final propertyBuyingModel = propertyBuyingModelFromJson(jsonString);

import 'dart:convert';

List<PropertyBuyingModel> propertyBuyingModelFromJson(String str) =>
    List<PropertyBuyingModel>.from(
        json.decode(str).map((x) => PropertyBuyingModel.fromJson(x)));

String propertyBuyingModelToJson(List<PropertyBuyingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PropertyBuyingModel {
  PropertyBuyingModel({
    this.id,
    this.title,
    this.description,
    this.blogImage,
    this.blogThumb,
    this.blogType,
    this.addedBy,
    this.blogUser,
    this.addedDate,
    this.status,
    this.blogImageBaseUrl,
  });

  String? id;
  String? title;
  String? description;
  String? blogImage;
  String? blogThumb;
  String? blogType;
  String? addedBy;
  String? blogUser;
  DateTime? addedDate;
  String? status;
  String? blogImageBaseUrl;

  factory PropertyBuyingModel.fromJson(Map<String, dynamic> json) =>
      PropertyBuyingModel(
        id: json["id"].toString(),
        title: json["title"],
        description: json["description"],
        blogImage: json["blog_image"],
        blogThumb: json["blog_thumb"],
        blogType: json["blog_type"],
        addedBy: json["added_by"].toString(),
        blogUser: json["blog_user"],
        addedDate: DateTime.parse(json["added_date"]),
        status: json["status"].toString(),
        blogImageBaseUrl: json["blog_image_base_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "blog_image": blogImage,
        "blog_thumb": blogThumb,
        "blog_type": blogType,
        "added_by": addedBy,
        "blog_user": blogUser,
        "added_date": addedDate!.toIso8601String(),
        "status": status,
      };
}

class GuideBlogs {
  List<PropertyBuyingModel> blogs;
  GuideBlogs(this.blogs);
  factory GuideBlogs.fromJson(List<dynamic> parsed) {
    List<PropertyBuyingModel> blogs = <PropertyBuyingModel>[];
    blogs = parsed.map((i) => PropertyBuyingModel.fromJson(i)).toList();
    return new GuideBlogs(blogs);
  }
}
