// To parse this JSON data, do
//
//     final relatedBlogModel = relatedBlogModelFromJson(jsonString);

import 'dart:convert';

List<RelatedBlogModel> relatedBlogModelFromJson(String str) =>
    List<RelatedBlogModel>.from(
        json.decode(str).map((x) => RelatedBlogModel.fromJson(x)));

String relatedBlogModelToJson(List<RelatedBlogModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RelatedBlogModel {
  RelatedBlogModel(
      {this.blogId,
      this.category,
      this.url,
      this.user,
      this.blogTitle,
      this.userUrl,
      this.dateDt,
      this.image});

  String? blogId;
  String? image;
  String? category;
  String? url;
  String? user;
  String? blogTitle;
  String? userUrl;
  String? dateDt;

  factory RelatedBlogModel.fromJson(Map<String, dynamic> json) =>
      RelatedBlogModel(
        blogId: json["blog_id"].toString(),
        image: json["blog_image"],
        category: json["blog_category"],
        url: json["blog_full_url"],
        user: json["user_name"],
        blogTitle: json["blog_title"],
        userUrl: json["user_url"],
        dateDt: json["blog_time_stamp"],
      );

  Map<String, dynamic> toJson() => {
        "blog_id": blogId,
        "blog_category": category,
        "blog_image": image,
        "blog_full_url": url,
        "user": user,
        "blog_title": blogTitle,
        "user_url": userUrl,
        "blog_time_stamp": dateDt,
      };
}

class RelatedBlogs {
  List<RelatedBlogModel> blogs;

  RelatedBlogs(this.blogs);
  factory RelatedBlogs.fromJson(List<dynamic> parsed) {
    List<RelatedBlogModel> blogs = <RelatedBlogModel>[];
    blogs = parsed.map((i) => RelatedBlogModel.fromJson(i)).toList();
    return new RelatedBlogs(blogs);
  }
}
