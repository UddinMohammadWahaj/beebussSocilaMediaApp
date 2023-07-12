// To parse this JSON data, do
//
//     final videoCommentModel = videoCommentModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final videoCommentModel = videoCommentModelFromJson(jsonString);

import 'dart:convert';

List<VideoCommentModel> videoCommentModelFromJson(String str) =>
    List<VideoCommentModel>.from(
        json.decode(str).map((x) => VideoCommentModel.fromJson(x)));

String videoCommentModelToJson(List<VideoCommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoCommentModel {
  VideoCommentModel({
    this.commentId,
    this.shortcode,
    this.name,
    this.timeStamp,
    this.comment,
    this.numberOfLike,
    this.noOfChildCom,
    this.upicture,
    this.dislikeIcon,
    this.likeIcon,
    this.likeStatus,
    this.dislikeStatus,
    this.userID,
    this.noOfDislikes,
  });

  String? commentId;
  String? userID;
  String? shortcode;
  String? name;
  String? timeStamp;
  String? comment;
  int? numberOfLike;
  int? noOfChildCom;
  String? upicture;
  String? dislikeIcon;
  String? likeIcon;
  bool? likeStatus;
  bool? dislikeStatus;
  bool? showSubcomments = false;
  int? noOfDislikes;

  factory VideoCommentModel.fromJson(Map<String, dynamic> json) =>
      VideoCommentModel(
        commentId: json["comment_id"],
        noOfDislikes: json["number_of_dislike"],
        userID: json["user_id"],
        shortcode: json["shortcode"],
        name: json["name"],
        timeStamp: json["time_data"],
        comment: json["comment"],

        numberOfLike: json["total_likes"],

        noOfChildCom: json["no_of_child_com"],
        // upicture: json["upicture"] ?? " ",
        upicture: json['image'],
        dislikeIcon: json["dislike_icon"],
        likeIcon: json["like_logo"],
        likeStatus: json["like_status"],
        dislikeStatus: json["dislike_status"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "number_of_dislike": noOfDislikes,
        "comment_user_id": userID,
        "shortcode": shortcode,
        "name": name,
        "time_stamp": timeStamp,
        "comment": comment,
        "number_of_like": numberOfLike,
        "no_of_child_com": noOfChildCom,
        "image": upicture,
        "dislike_icon": dislikeIcon,
        "like_logo": likeIcon,
        "like_status": likeStatus,
        "dislike_status": dislikeStatus,
      };
}

class VideoComments {
  List<VideoCommentModel> comments;

  VideoComments(this.comments);
  factory VideoComments.fromJson(List<dynamic> parsed) {
    List<VideoCommentModel> comments = <VideoCommentModel>[];
    comments = parsed.map((i) => VideoCommentModel.fromJson(i)).toList();
    return new VideoComments(comments);
  }
}
