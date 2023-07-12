// To parse this JSON data, do
//
//     final buzzerfeedCommentListModel = buzzerfeedCommentListModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

BuzzerfeedCommentListModel buzzerfeedCommentListModelFromJson(String str) =>
    BuzzerfeedCommentListModel.fromJson(json.decode(str));

String buzzerfeedCommentListModelToJson(BuzzerfeedCommentListModel data) =>
    json.encode(data.toJson());

class BuzzerfeedCommentListModel {
  BuzzerfeedCommentListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  int? success;
  int? status;
  String? message;
  List<BuzzerfeedCommentDatum>? data;

  factory BuzzerfeedCommentListModel.fromJson(Map<String, dynamic> json) =>
      BuzzerfeedCommentListModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<BuzzerfeedCommentDatum>.from(
            json["data"].map((x) => BuzzerfeedCommentDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BuzzerfeedCommentDatum {
  BuzzerfeedCommentDatum(
      {this.commentId,
      this.buzzerfeedId,
      this.memberId,
      this.memberName,
      this.userPicture,
      this.shortcode,
      this.comment,
      this.location,
      this.type,
      this.images,
      this.video,
      this.thumb,
      this.pollStatus,
      this.pollTime,
      this.pollQuestion,
      this.pollAnswer,
      this.gifFile,
      this.followStatus,
      this.totalLikes,
      this.totalReplay,
      this.likeStatus,
      this.timeStamp,
      this.page,
      this.replyId,
      this.showReplies,
      this.listofreply});

  String? commentId;
  String? replyId;
  String? buzzerfeedId;
  String? memberId;
  String? memberName;
  String? userPicture;
  String? shortcode;
  String? comment;
  String? location;
  String? type;
  List<dynamic>? images;
  String? video;
  String? thumb;
  String? pollStatus;
  String? pollTime;
  String? pollQuestion;
  List<dynamic>? pollAnswer;
  String? gifFile;
  int? followStatus;
  int? totalLikes;
  int? totalReplay;
  RxBool? likeStatus;
  String? timeStamp;
  int? page;
  RxBool? showReplies;
  RxList<BuzzerfeedCommentDatum>? listofreply;
  factory BuzzerfeedCommentDatum.fromJson(Map<String, dynamic> json) =>
      BuzzerfeedCommentDatum(
          commentId: json["comment_id"],
          buzzerfeedId: json["buzzerfeed_id"],
          memberId: json["user_id"],
          memberName: json["member_name"],
          userPicture: json["user_picture"],
          shortcode: json["shortcode"],
          comment: json["comment"],
          location: json["location"],
          type: json["type"],
          images: List<dynamic>.from(json["images"].map((x) => x)),
          video: json["video"],
          thumb: json["thumb"],
          pollStatus: json["poll_status"],
          pollTime: json["poll_time"],
          pollQuestion: json["poll_question"],
          pollAnswer: List<dynamic>.from(json["poll_answer"].map((x) => x)),
          gifFile: json["gif_file"],
          followStatus: json["follow_status"],
          totalLikes: json["total_likes"],
          totalReplay: json["total_replay"],
          likeStatus: new RxBool(json["like_status"]),
          timeStamp: json["time_stamp"],
          page: json["page"],
          replyId: json['replay_id'] ?? "",
          listofreply: new RxList(<BuzzerfeedCommentDatum>[]),
          showReplies: RxBool(false));

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "buzzerfeed_id": buzzerfeedId,
        "user_id": memberId,
        "member_name": memberName,
        "user_picture": userPicture,
        "shortcode": shortcode,
        "comment": comment,
        "location": location,
        "type": type,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "video": video,
        "thumb": thumb,
        "poll_status": pollStatus,
        "poll_time": pollTime,
        "poll_question": pollQuestion,
        "poll_answer": List<dynamic>.from(pollAnswer!.map((x) => x)),
        "gif_file": gifFile,
        "follow_status": followStatus,
        "total_likes": totalLikes,
        "total_replay": totalReplay,
        "like_status": likeStatus,
        "time_stamp": timeStamp,
        "page": page,
      };
}
