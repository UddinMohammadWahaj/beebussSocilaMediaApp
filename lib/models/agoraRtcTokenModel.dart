class AgoraRtcTokenModel {
  String? message;
  int? success;
  String? memberId;
  String? appID;
  String? appCertificate;
  String? channelName;
  String? token;

  AgoraRtcTokenModel(
      {this.message,
      this.success,
      this.memberId,
      this.appID,
      this.appCertificate,
      this.channelName,
      this.token});

  AgoraRtcTokenModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    success = json['success'] ?? 0;
    memberId = json['user_id'] ?? "";
    appID = json['appID'] ?? "";
    appCertificate = json['appCertificate'] ?? "";
    channelName = json['channelName'] ?? "";
    token = json['token'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['user_id'] = this.memberId;
    data['appID'] = this.appID;
    data['appCertificate'] = this.appCertificate;
    data['channelName'] = this.channelName;
    data['token'] = this.token;
    return data;
  }
}
