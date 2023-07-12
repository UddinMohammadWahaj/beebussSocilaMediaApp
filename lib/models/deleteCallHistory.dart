class DeleteCallHistoryModel {
  int? success;
  String? message;

  DeleteCallHistoryModel({this.success, this.message});

  DeleteCallHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
