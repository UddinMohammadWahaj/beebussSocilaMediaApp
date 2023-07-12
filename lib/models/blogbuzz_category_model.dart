// To parse this JSON data, do
//
//     final blogBuzzCategoryModel = blogBuzzCategoryModelFromJson(jsonString);

import 'dart:convert';

List<BlogBuzzCategoryModel> blogBuzzCategoryModelFromJson(String str) =>
    List<BlogBuzzCategoryModel>.from(
        json.decode(str).map((x) => BlogBuzzCategoryModel.fromJson(x)));

String blogBuzzCategoryModelToJson(List<BlogBuzzCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogBuzzCategoryModel {
  BlogBuzzCategoryModel({
    this.blogId,
    this.blogImage,
    this.blogUrl,
    this.blogCategory,
    this.blogContent,
    this.blogUser,
    this.blogTimeStamp,
    this.blogUserName,
    this.categoryVal,
    this.totalPages,
    this.currentPage,
    this.postID,
  });

  String? blogId;
  String? blogImage;
  String? blogUrl;
  String? blogCategory;
  String? blogContent;
  String? blogUser;
  String? blogTimeStamp;
  String? blogUserName;
  String? categoryVal;
  int? totalPages;
  int? currentPage;
  String? postID;

  factory BlogBuzzCategoryModel.fromJson(Map<String, dynamic> json) =>
      BlogBuzzCategoryModel(
          blogId: json["blog_id"],
          blogImage: json["blog_image"],
          blogUrl: json["blog_url"],
          blogCategory: json["blog_category"],
          blogContent: json["blog_content"],
          blogUser: json["blog_user"],
          blogTimeStamp: json["blog_time_stamp"],
          blogUserName: json["blog_user_name"],
          categoryVal: json["category_val"],
          totalPages: json["total_pages"],
          currentPage: json["current_page"],
          postID: json["post_id"]);

  Map<String, dynamic> toJson() => {
        "blog_id": blogId,
        "blog_image": blogImage,
        "blog_url": blogUrl,
        "blog_category": blogCategory,
        "blog_content": blogContent,
        "blog_user": blogUser,
        "blog_time_stamp": blogTimeStamp,
        "blog_user_name": blogUserName,
        "category_val": categoryVal,
        "total_pages": totalPages,
        "current_page": currentPage,
      };
}

class BlogCategories {
  List<BlogBuzzCategoryModel> categories;

  BlogCategories(this.categories);
  factory BlogCategories.fromJson(List<dynamic> parsed) {
    List<BlogBuzzCategoryModel> categories = <BlogBuzzCategoryModel>[];
    categories = parsed.map((i) => BlogBuzzCategoryModel.fromJson(i)).toList();
    return new BlogCategories(categories);
  }
}
