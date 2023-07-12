class GetContactModel {
  String? messageId;
  String? typeMessage;
  String? fileName;
  String? messageData;
  String? inOut;
  String? image;
  String? name;
  String? numbers;
  String? fromuserid;
  String? timezone;
  String? time;
  String? date;
  String? readStatus;
  int? totalUnread;
  String? token;
  String? onlineStatus;
  String? userStatus;
  String? pictureStatus;
  String? aboutStatus;
  int? blocked;

  GetContactModel(
      {this.messageId,
      this.typeMessage,
      this.fileName,
      this.messageData,
      this.inOut,
      this.image,
      this.name,
      this.numbers,
      this.fromuserid,
      this.timezone,
      this.time,
      this.date,
      this.readStatus,
      this.totalUnread,
      this.token,
      this.onlineStatus,
      this.userStatus,
      this.pictureStatus,
      this.aboutStatus,
      this.blocked});

  GetContactModel.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'] ?? "";
    typeMessage = json['type_message'] ?? "";
    fileName = json['file_name'] ?? "";
    messageData = json['message_data'] ?? "";
    inOut = json['in_out'] ?? "";
    image = json['image'] ?? "";
    name = json['name'] ?? "";
    numbers = json['numbers'] ?? "";
    fromuserid = json['fromuserid'] ?? "";
    timezone = json['timezone'] ?? "";
    time = json['time'] ?? "";
    date = json['date'] ?? "";
    readStatus = json['read_status'] ?? "";
    totalUnread = json['total_unread'] ?? 0;
    token = json['token'] ?? "";
    onlineStatus = json['online_status'] ?? "";
    userStatus = json['user_status'] ?? "";
    pictureStatus = json['picture_status'] ?? "";
    aboutStatus = json['about_status'] ?? "";
    blocked = json['blocked'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_id'] = this.messageId;
    data['type_message'] = this.typeMessage;
    data['file_name'] = this.fileName;
    data['message_data'] = this.messageData;
    data['in_out'] = this.inOut;
    data['image'] = this.image;
    data['name'] = this.name;
    data['numbers'] = this.numbers;
    data['fromuserid'] = this.fromuserid;
    data['timezone'] = this.timezone;
    data['time'] = this.time;
    data['date'] = this.date;
    data['read_status'] = this.readStatus;
    data['total_unread'] = this.totalUnread;
    data['token'] = this.token;
    data['online_status'] = this.onlineStatus;
    data['user_status'] = this.userStatus;
    data['picture_status'] = this.pictureStatus;
    data['about_status'] = this.aboutStatus;
    data['blocked'] = this.blocked;
    return data;
  }
}
