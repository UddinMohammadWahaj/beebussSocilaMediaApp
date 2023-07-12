// To parse this JSON data, do
//
//     final blogBuzzModel = blogBuzzModelFromJson(jsonString);

import 'dart:convert';

List<BlogBuzzModel> blogBuzzModelFromJson(String str) =>
    List<BlogBuzzModel>.from(
        json.decode(str).map((x) => BlogBuzzModel.fromJson(x)));

String blogBuzzModelToJson(List<BlogBuzzModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogBuzzModel {
  BlogBuzzModel({
    this.index,
    this.blogId,
    this.userId,
    this.category,
    this.categoryVal,
    this.userName,
    this.postContent,
    this.url,
    this.image,
  });

  int? index;
  String? blogId;
  String? userId;
  String? category;
  String? categoryVal;
  String? userName;
  String? postContent;
  String? url;
  String? image;

  factory BlogBuzzModel.fromJson(Map<String, dynamic> json) => BlogBuzzModel(
        index: json["index"] == null ? null : json["index"],
        blogId: json["blog_id"],
        userId: json["user_id"],
        category: json["category"],
        categoryVal: json["category_val"],
        userName: json["user_name"],
        postContent: json["post_content"],
        url: json["url"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "index": index == null ? null : index,
        "blog_id": blogId,
        "user_id": userId,
        "category": category,
        "category_val": categoryVal,
        "user_name": userName,
        "post_content": postContent,
        "url": url,
        "image": image,
      };
}

class Blogs {
  List<BlogBuzzModel> blogs;

  Blogs(this.blogs);
  factory Blogs.fromJson(List<dynamic> parsed) {
    List<BlogBuzzModel> blogs = <BlogBuzzModel>[];
    blogs = parsed.map((i) => BlogBuzzModel.fromJson(i)).toList();
    return new Blogs(blogs);
  }
}
