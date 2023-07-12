class RefreshTokenModel {
  int? success;
  String? message;
  String? memberId;
  String? name;
  String? userImage;
  String? token;

  RefreshTokenModel(
      {this.success,
      this.message,
      this.memberId,
      this.name,
      this.userImage,
      this.token});

  RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    memberId = json['user_id'];
    name = json['name'];
    userImage = json['user_image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['user_id'] = this.memberId;
    data['name'] = this.name;
    data['user_image'] = this.userImage;
    data['token'] = this.token;
    return data;
  }
}
