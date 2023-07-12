class CallHistoryModel {
  int? success;
  List<CallData>? data;
  String? message;

  CallHistoryModel({this.success, this.data, this.message});

  CallHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new CallData.fromJson(v));
      });
    }
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CallData {
  String? agoraChatId;
  String? callerId;
  String? receiverId;
  String? receiverName;
  String? receiverImage;
  String? agoraId;
  String? callType;
  String? callTime;
  String? callLength;
  bool? isselect = false;
  int? callflag;

  CallData({
    this.agoraChatId,
    this.callerId,
    this.receiverId,
    this.receiverName,
    this.receiverImage,
    this.agoraId,
    this.callType,
    this.callTime,
    this.callLength,
    this.isselect = false,
    this.callflag,
  });

  CallData.fromJson(Map<String, dynamic> json) {
    agoraChatId = json['agora_chat_id'] ?? "";
    callerId = json['caller_id'] ?? "";
    receiverId = json['receiver_id'] ?? "";
    receiverName = json['receiver_name'] ?? "";
    receiverImage = json['receiver_image'] ?? "";
    agoraId = json['agora_id'] ?? "";
    callType = json['call_type'] ?? "";
    callTime = json['call_time'] ?? "";
    callLength = json['call_length'] ?? "";
    callflag = json['call_flag'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agora_chat_id'] = this.agoraChatId;
    data['caller_id'] = this.callerId;
    data['receiver_id'] = this.receiverId;
    data['receiver_name'] = this.receiverName;
    data['receiver_image'] = this.receiverImage;
    data['agora_id'] = this.agoraId;
    data['call_type'] = this.callType;
    data['call_time'] = this.callTime;
    data['call_length'] = this.callLength;
    data['call_flag'] = this.callflag;
    return data;
  }
}
