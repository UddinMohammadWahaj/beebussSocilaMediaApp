class TwoFactorEnableModel {
  int? success;
  String? message;

  TwoFactorEnableModel({this.success, this.message});

  TwoFactorEnableModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
