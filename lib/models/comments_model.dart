// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(
    json.decode(str).map((x) => CommentModel.fromJson(x)));

String commentModelToJson(List<CommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
  CommentModel({
    this.totalLikes,
    this.timeData,
    this.subComment,
    this.commentId,
    this.shortcodeUrl,
    this.shortcode,
    this.message,
    this.image,
    this.likeLogo,
    this.memberId,
  });

  String? totalLikes;
  String? timeData;
  dynamic subComment;
  String? commentId;
  String? shortcodeUrl;
  String? shortcode;
  String? message;
  String? image;
  String? likeLogo;
  String? memberId;
  bool? isSubCommentOpen = false;
  bool? isLiked = false;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        totalLikes: json["total_likes"].toString(),
        timeData: json["time_data"],
        subComment: json["no_of_child_com"].toString(),
        commentId: json["comment_id"].toString(),
        shortcodeUrl: json["shortcode_url"],
        shortcode: json["shortcode"],
        message: json["message"],
        image: json["image"],
        likeLogo: json["like_logo"],
        memberId: json["user_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "total_likes": totalLikes,
        "time_data": timeData,
        "sub_comment": subComment,
        "comment_id": commentId,
        "shortcode_url": shortcodeUrl,
        "shortcode": shortcode,
        "message": message,
        "image": image,
        "like_logo": likeLogo,
        "user_id": memberId,
      };
}

class Comments {
  List<CommentModel> comments;

  Comments(this.comments);
  factory Comments.fromJson(List<dynamic> parsed) {
    List<CommentModel> comments = <CommentModel>[];
    comments = parsed.map((i) => CommentModel.fromJson(i)).toList();
    return new Comments(comments);
  }
}
