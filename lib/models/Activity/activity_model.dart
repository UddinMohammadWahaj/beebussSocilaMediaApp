import 'dart:convert';

import 'package:bizbultest/models/horizontal_video_model.dart';

List<ActivityModel> activityModelFromJson(String str) =>
    List<ActivityModel>.from(
        json.decode(str).map((x) => ActivityModel.fromJson(x)));

String activityModelToJson(List<ActivityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActivityModel {
  ActivityModel({
    this.getrequest,
    this.isPrivate,
    this.dateCard,
    this.timestamp,
    this.name,
    this.image,
    this.text,
    this.type,
    this.reason,
    this.memberId,
    this.imagePost,
    this.requestStatus,
    this.shortcode,
    this.postId,
    this.followRequest,
    this.followStatus,
    this.acceptStatus,
  });
  int? getrequest;
  bool? isPrivate;
  String? dateCard;
  dynamic? postId;
  String? timestamp;
  String? name;
  String? image;
  String? text;
  String? type;
  String? reason;
  String? memberId;
  String? imagePost;
  String? requestStatus;
  String? shortcode;
  int? followRequest;
  int? followStatus;
  int? acceptStatus;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        getrequest: json["get_request"],
        isPrivate: json["is_private"],
        postId: json["post_id"],
        dateCard: json["date_card"],
        timestamp: json["timestamp"],
        name: json["name"],
        image: json["image"],
        text: json["text"],
        type: json["type"],
        reason: json["reason"],
        memberId: json["user_id"],
        imagePost: json["image_post"],
        requestStatus:
            json["request_status"] == null ? null : json["request_status"],
        shortcode: json["shortcode"],
        followRequest: json["follow_request"],
        followStatus: json["follow_status"],
        acceptStatus: json["accept_status"],
      );

  Map<String, dynamic> toJson() => {
        "date_card": dateCard,
        "timestamp": timestamp,
        "name": name,
        "image": image,
        "text": text,
        "type": type,
        "reason": reason,
        "user_id": memberId,
        "image_post": imagePost,
      };
}

class Activities {
  List<ActivityModel> notifications;

  Activities(this.notifications);
  factory Activities.fromJson(List<dynamic> parsed) {
    List<ActivityModel> notifications = <ActivityModel>[];
    notifications = parsed.map((i) => ActivityModel.fromJson(i)).toList();
    return new Activities(notifications);
  }
}

class ActivityNotify {
  int? success;
  int? status;
  String? message;
  List<ActivityNotifyData>? data;

  ActivityNotify({this.success, this.status, this.message, this.data});

  ActivityNotify.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ActivityNotifyData>[];
      json['data'].forEach((v) {
        data!.add(new ActivityNotifyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityNotifyData {
  String? notificationId;
  String? memberId;
  String? fullName;
  String? profile;
  String? image;
  String? shortcode;
  String? type;
  String? title;
  String? postId;
  String? isRead;
  int? followStatus;
  String? timeStamp;

  ActivityNotifyData(
      {this.notificationId,
      this.memberId,
      this.fullName,
      this.image,
      this.shortcode,
      this.type,
      this.title,
      this.isRead,
      this.followStatus,
      this.timeStamp,
      this.postId,
      this.profile});

  ActivityNotifyData.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    memberId = json['user_id'];
    postId = json['post_id'];
    fullName = json['full_name'];
    image = json['image'];
    profile = json['profile'];
    shortcode = json['shortcode'];
    type = json['type'];
    title = json['title'];
    isRead = json['is_read'];
    followStatus = json['follow_status'];
    timeStamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['user_id'] = this.memberId;
    data['post_id'] = this.postId;
    data['full_name'] = this.fullName;
    data['image'] = this.image;
    data['profile'] = this.profile;
    data['shortcode'] = this.shortcode;
    data['type'] = this.type;
    data['title'] = this.title;
    data['is_read'] = this.isRead;
    data['follow_status'] = this.followStatus;
    data['time_stamp'] = this.timeStamp;
    return data;
  }
}
