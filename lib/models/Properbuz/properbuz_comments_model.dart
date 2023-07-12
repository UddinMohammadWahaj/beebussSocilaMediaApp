// To parse this JSON data, do
//
//     final properbuzCommentsModel = properbuzCommentsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<ProperbuzCommentsModel> properbuzCommentsModelFromJson(String str) =>
    List<ProperbuzCommentsModel>.from(
        json.decode(str).map((x) => ProperbuzCommentsModel.fromJson(x)));

class ProperbuzCommentsModel {
  ProperbuzCommentsModel(
      {this.memberId,
      this.name,
      this.shortcode,
      this.image,
      this.followData,
      this.designation,
      this.comment,
      this.likeStatus,
      this.likes,
      this.time,
      this.commentID,
      this.subComments,
      this.replies,
      this.hasSubComments});

  String? memberId;
  String? name;
  String? shortcode;
  String? image;
  String? followData;
  String? designation;
  RxString? comment;
  RxBool? likeStatus;
  RxInt? likes;
  String? time;
  String? commentID;
  RxList<SubComment>? subComments;
  RxInt? replies;
  RxBool? hasSubComments;

  factory ProperbuzCommentsModel.fromJson(Map<String, dynamic> json) =>
      ProperbuzCommentsModel(
        memberId: json["user_id"],
        name: json["name"],
        shortcode: json["shortcode"],
        image: json["image"],
        followData: json["follow_data"],
        designation: json["designation"],
        comment: new RxString(json["comment"]),
        likeStatus: new RxBool(json["like_status"]),
        likes: new RxInt(json["likes"]),
        time: json["time"],
        commentID: json["comment_id"],
        replies: new RxInt(json["replies"]),
        hasSubComments: new RxBool(json["has_subcomments"]),
        subComments: json["sub_comments"]! == null
            ? <SubComment>[].obs
            : RxList<SubComment>.from(
                json["sub_comments"]!.map((x) => SubComment.fromJson(x))),
      );
}

class SubComment {
  SubComment({
    this.subCommentId,
    this.memberId,
    this.name,
    this.shortcode,
    this.image,
    this.followData,
    this.designation,
    this.comment,
    this.likeStatus,
    this.likes,
    this.time,
    this.commentID,
  });

  String? subCommentId;
  String? commentID;
  String? memberId;
  String? name;
  String? shortcode;
  String? image;
  String? followData;
  String? designation;
  RxString? comment;
  RxBool? likeStatus;
  RxInt? likes;
  String? time;

  factory SubComment.fromJson(Map<String, dynamic> json) => SubComment(
        subCommentId: json["sub_comment_id"],
        commentID: json["comment_id"],
        memberId: json["user_id"],
        name: json["name"],
        shortcode: json["shortcode"],
        image: json["image"],
        followData: json["follow_data"],
        designation: json["designation"],
        comment: new RxString(json["comment"]),
        likeStatus: new RxBool(json["like_status"]),
        likes: new RxInt(json["likes"]),
        time: json["time"],
      );
}

class ProperbuzComments {
  List<ProperbuzCommentsModel> comments;
  ProperbuzComments(this.comments);
  factory ProperbuzComments.fromJson(List<dynamic> parsed) {
    List<ProperbuzCommentsModel> comments = <ProperbuzCommentsModel>[];
    comments = parsed.map((i) => ProperbuzCommentsModel.fromJson(i)).toList();
    return new ProperbuzComments(comments);
  }
}
