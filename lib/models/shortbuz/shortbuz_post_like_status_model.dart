class ShortbuzPostLikeStatusModel {
  int? success;
  int? status;
  String? message;
  String? imageData;
  bool? isLiked;

  ShortbuzPostLikeStatusModel(
      {this.success, this.status, this.message, this.imageData, this.isLiked});

  ShortbuzPostLikeStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    imageData = json['image_data'];
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['image_data'] = this.imageData;
    data['is_liked'] = this.isLiked;
    return data;
  }
}
