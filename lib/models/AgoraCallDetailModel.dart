class AgoraCallDetail {
  int? success;
  Data? data;
  String? message;

  AgoraCallDetail({this.success, this.data, this.message});

  AgoraCallDetail.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? agoraChatId;
  String? callerId;
  String? receiverId;
  String? agoraId;
  String? callType;
  String? callTime;
  String? callLength;

  Data(
      {this.agoraChatId,
      this.callerId,
      this.receiverId,
      this.agoraId,
      this.callType,
      this.callTime,
      this.callLength});

  Data.fromJson(Map<String, dynamic> json) {
    agoraChatId = json['agora_chat_id'] ?? "";
    callerId = json['caller_id'] ?? "";
    receiverId = json['receiver_id'] ?? "";
    agoraId = json['agora_id'] ?? "";
    callType = json['call_type'] ?? "";
    callTime = json['call_time'] ?? "";
    callLength = json['call_length'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agora_chat_id'] = this.agoraChatId;
    data['caller_id'] = this.callerId;
    data['receiver_id'] = this.receiverId;
    data['agora_id'] = this.agoraId;
    data['call_type'] = this.callType;
    data['call_time'] = this.callTime;
    data['call_length'] = this.callLength;
    return data;
  }
}
