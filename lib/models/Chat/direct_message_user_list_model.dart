// To parse this JSON data, do
//
//     final directMessageUserListModel = directMessageUserListModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

List<DirectMessageUserListModel> directMessageUserListModelFromJson(
        String str) =>
    List<DirectMessageUserListModel>.from(
        json.decode(str).map((x) => DirectMessageUserListModel.fromJson(x)));

String directMessageUserListModelToJson(
        List<DirectMessageUserListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DirectMessageUserListModel {
  DirectMessageUserListModel({
    this.messageId,
    this.typeMessage,
    this.fileName,
    this.messageData,
    this.inOut,
    this.image,
    this.name,
    this.fromuserid,
    this.timezone,
    this.time,
    this.date,
    this.readStatus,
    this.totalUnread,
    this.token,
    this.onlineStatus,
    this.userStatus,
    this.groupId,
    this.chatType,
    this.topic,
    this.groupMembers,
    this.mute,
    this.admin,
    this.blocked,
    this.groupStatus,
    this.groupDescription,
    this.sendMessage,
    this.editInfo,
    this.selected,
    this.shortcode,
  });

  String? messageId;
  String? typeMessage;
  String? fileName;
  String? messageData;
  String? inOut;
  String? image;
  String? name;
  String? fromuserid;
  String? timezone;
  String? time;
  String? date;
  String? readStatus;
  int? totalUnread;
  String? token;
  String? onlineStatus;
  String? userStatus;
  String? groupId;
  String? chatType;
  String? topic;
  bool? isSelected = false;
  String? groupMembers;
  int? mute;
  int? admin;
  int? blocked;
  int? groupStatus;
  String? groupDescription;
  int? sendMessage;
  int? editInfo;
  RxBool? selected;
  String? shortcode;

  factory DirectMessageUserListModel.fromJson(Map<String, dynamic> json) =>
      DirectMessageUserListModel(
        messageId: json["message_id"],
        typeMessage: json["type_message"],
        fileName: json["file_name"],
        messageData: json["message_data"],
        inOut: json["in_out"],
        image: json["image"],
        name: json["name"],
        fromuserid: json["fromuserid"],
        timezone: json["timezone"],
        time: json["time"],
        date: json["date"],
        readStatus: json["read_status"],
        totalUnread: json["total_unread"] == null || json["total_unread"] == ""
            ? null
            : json["total_unread"],
        token: json["token"],
        onlineStatus: json["online_status"],
        userStatus: json["user_status"],
        groupId: json["group_id"] ?? "",
        chatType: json["chat_type"] ?? "",
        topic: json["topic"] ?? "",
        groupMembers: json["group_members"] ?? "",
        mute: (json["muted"] ?? 0),
        admin: (json["admin"] ?? 0),
        blocked: (json["blocked"] ?? 0),
        groupStatus: json["group_status"] ?? 0,
        groupDescription: json["group_description"] ?? "",
        sendMessage: json["send_message"] ?? 0,
        editInfo: json["edit_info"] ?? 0,
        shortcode: json["shortcode"] ?? "",
        selected: new RxBool(false),
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "type_message": typeMessage,
        "file_name": fileName,
        "message_data": messageData,
        "in_out": inOut,
        "image": image,
        "name": name,
        "fromuserid": fromuserid,
        "timezone": timezone,
        "time": time,
        "date": date,
        "shortcode": shortcode,
        "read_status": readStatus,
        "total_unread": totalUnread == null ? null : totalUnread,
        "token": token,
        "online_status": onlineStatus,
        "user_status": userStatus,
        "group_id": groupId,
        "chat_type": chatType,
        "topic": topic,
        "group_members": groupMembers,
        "muted": mute,
        "admin": admin,
        "blocked": blocked,
        "group_status": groupStatus,
        "group_description": groupDescription,
        "send_message": sendMessage,
        "edit_info": editInfo,
      };
}

class DirectUsers {
  List<DirectMessageUserListModel> users;

  DirectUsers(this.users);

  factory DirectUsers.fromJson(List<dynamic> parsed) {
    List<DirectMessageUserListModel> users = <DirectMessageUserListModel>[];
    users = parsed.map((i) => DirectMessageUserListModel.fromJson(i)).toList();
    return new DirectUsers(users);
  }
}
