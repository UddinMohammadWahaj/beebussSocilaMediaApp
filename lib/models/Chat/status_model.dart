// To parse this JSON data, do
//
//     final statusModelChat = statusModelChatFromJson(jsonString);

import 'dart:convert';

List<StatusModelChat> statusModelChatFromJson(String str) =>
    List<StatusModelChat>.from(
        json.decode(str).map((x) => StatusModelChat.fromJson(x)));

String statusModelChatToJson(List<StatusModelChat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusModelChat {
  StatusModelChat({
    this.status,
    this.selectedStatus,
  });

  String? status;
  int? selectedStatus;

  factory StatusModelChat.fromJson(Map<String, dynamic> json) =>
      StatusModelChat(
        status: json["status"],
        selectedStatus: json["selected_status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "selected_status": selectedStatus,
      };
}

class ChatStatus {
  List<StatusModelChat> status;

  ChatStatus(this.status);

  factory ChatStatus.fromJson(List<dynamic> parsed) {
    List<StatusModelChat> status = <StatusModelChat>[];
    status = parsed.map((i) => StatusModelChat.fromJson(i)).toList();
    return new ChatStatus(status);
  }
}
