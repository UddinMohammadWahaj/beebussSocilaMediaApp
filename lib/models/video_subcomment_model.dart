// To parse this JSON data, do
//
//     final videoSubcommentModel = videoSubcommentModelFromJson(jsonString);

import 'dart:convert';

List<VideoSubcommentModel> videoSubcommentModelFromJson(String str) =>
    List<VideoSubcommentModel>.from(
        json.decode(str).map((x) => VideoSubcommentModel.fromJson(x)));

String videoSubcommentModelToJson(List<VideoSubcommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoSubcommentModel {
  VideoSubcommentModel({
    this.commentId,
    this.childCommentId,
    this.noOfLikes,
    this.postId,
    this.commentMemberId,
    this.likeStatus,
    this.dislikeStatus,
    this.timeStamp,
    this.commentShortcode,
    this.comment,
    this.name,
    this.picture,
    this.userID,
    this.noOfDislikes,
  });

  String? commentId;
  String? userID;
  String? childCommentId;
  int? noOfLikes;
  String? postId;
  String? commentMemberId;
  int? likeStatus;
  int? dislikeStatus;
  String? timeStamp;
  String? commentShortcode;
  String? comment;
  String? name;
  String? picture;
  int? noOfDislikes;

  factory VideoSubcommentModel.fromJson(Map<String, dynamic> json) =>
      VideoSubcommentModel(
        commentId: json["comment_id"],
        noOfDislikes: json["number_of_dislike"],
        userID: json["comment_user_id"],
        childCommentId: json["child_comment_id"],
        noOfLikes: json["no_of_likes"],
        postId: json["post_id"],
        commentMemberId: json["comment_user_id"],
        likeStatus: json["like_status"] ? 1 : 0,
        dislikeStatus: json["dislike_status"] ? 1 : 0,
        timeStamp: json["time_stamp"],
        commentShortcode: json["comment_shortcode"],
        comment: json["comment"],
        name: json["name"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "number_of_dislike": noOfDislikes,
        "comment_user_id": userID,
        "child_comment_id": childCommentId,
        "no_of_likes": noOfLikes,
        "post_id": postId,
        "like_status": likeStatus,
        "dislike_status": dislikeStatus,
        "time_stamp": timeStamp,
        "comment_shortcode": commentShortcode,
        "comment": comment,
        "name": name,
        "picture": picture,
      };
}

class VideoSubcomments {
  List<VideoSubcommentModel> subcomments;

  VideoSubcomments(this.subcomments);
  factory VideoSubcomments.fromJson(List<dynamic> parsed) {
    List<VideoSubcommentModel> subcomments = <VideoSubcommentModel>[];
    subcomments = parsed.map((i) => VideoSubcommentModel.fromJson(i)).toList();
    return new VideoSubcomments(subcomments);
  }
}
