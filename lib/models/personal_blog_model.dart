// To parse this JSON data, do
//
//     final personalBlogModel = personalBlogModelFromJson(jsonString);

import 'dart:convert';

List<PersonalBlogModel> personalBlogModelFromJson(String str) =>
    List<PersonalBlogModel>.from(
        json.decode(str).map((x) => PersonalBlogModel.fromJson(x)));

String personalBlogModelToJson(List<PersonalBlogModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonalBlogModel {
  PersonalBlogModel({
    this.currentPage,
    this.totalPages,
    this.blogId,
    this.postId,
    this.postType,
    this.url,
    this.image,
    this.category,
    this.content,
    this.userUrl,
    this.userName,
    this.timeStamp,
    this.promote,
    this.edit,
    this.delete,
  });

  int? currentPage;
  int? totalPages;
  String? blogId;
  dynamic postId;
  String? postType;
  String? url;
  String? image;
  String? category;
  String? content;
  String? userUrl;
  String? userName;
  String? timeStamp;
  String? promote;
  String? edit;
  String? delete;

  factory PersonalBlogModel.fromJson(Map<String, dynamic> json) =>
      PersonalBlogModel(
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
        blogId: json["blog_id"].toString(),
        postId: json["post_id"],
        postType: json["post_type"],
        url: json["url"],
        image: json["image"],
        category: json["category"].toString(),
        content: json["content"],
        userUrl: json["user_url"],
        userName: json["user_name"],
        timeStamp: json["timestemp"],
        promote: json["promote"],
        edit: json["edit"],
        delete: json["delete"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total_pages": totalPages,
        "blog_id": blogId,
        "post_id": postId,
        "post_type": postType,
        "url": url,
        "image": image,
        "category": category,
        "content": content,
        "user_url": userUrl,
        "user_name": userName,
        "time_stamp": timeStamp,
        "promote": promote,
        "edit": edit,
        "delete": delete,
      };
}

class PersonalBlogs {
  List<PersonalBlogModel> blogs;

  PersonalBlogs(this.blogs);
  factory PersonalBlogs.fromJson(List<dynamic> parsed) {
    List<PersonalBlogModel> blogs = <PersonalBlogModel>[];
    blogs = parsed.map((i) => PersonalBlogModel.fromJson(i)).toList();
    return new PersonalBlogs(blogs);
  }
}
