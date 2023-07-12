// To parse this JSON data, do
//
//     final subCommentModel = subCommentModelFromJson(jsonString);

import 'dart:convert';

SubCommentModel subCommentModelFromJson(String str) =>
    SubCommentModel.fromJson(json.decode(str));

String subCommentModelToJson(SubCommentModel data) =>
    json.encode(data.toJson());

class SubCommentModel {
  SubCommentModel({
    this.userImage,
    this.shortcode,
    this.comment,
    this.timeStamp,
    this.subCommentId,
    this.likeLogo,
    this.totalLikes,
  });

  String? userImage;
  String? shortcode;
  String? comment;
  String? timeStamp;
  String? subCommentId;
  String? likeLogo;
  String? totalLikes;
  bool? isLiked = false;

  factory SubCommentModel.fromJson(Map<String, dynamic> json) =>
      SubCommentModel(
        userImage: json["image"].toString(),
        shortcode: json["shortcode"].toString(),
        comment: json["message"].toString(),
        timeStamp: json["time_data"].toString(),
        subCommentId: json["sub_comment_id"].toString(),
        likeLogo: json["like_logo"].toString(),
        totalLikes: json["total_likes"].toString().length > 1
            ? json["total_likes"].toString()
            : json["total_likes"].toString() + ' Likes',
      );

  Map<String, dynamic> toJson() => {
        "image": userImage,
        "shortcode": shortcode,
        "message": comment,
        "time_data": timeStamp,
        "sub_comment_id": subCommentId,
        "like_logo": likeLogo,
        "total_likes": totalLikes,
      };
}

class SubComments {
  List<SubCommentModel> subComments;

  SubComments(this.subComments);
  factory SubComments.fromJson(List<dynamic> parsed) {
    List<SubCommentModel> subComments = <SubCommentModel>[];
    subComments = parsed.map((i) => SubCommentModel.fromJson(i)).toList();
    return new SubComments(subComments);
  }
}
