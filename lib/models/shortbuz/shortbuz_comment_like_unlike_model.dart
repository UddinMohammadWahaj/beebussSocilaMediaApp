class ShortbuzCommentLikeUnlikeModel {
  int? success;
  int? status;
  String? message;
  String? imageData;
  int? totalLike;

  ShortbuzCommentLikeUnlikeModel(
      {this.success,
      this.status,
      this.message,
      this.imageData,
      this.totalLike});

  ShortbuzCommentLikeUnlikeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    imageData = json['image_data'];
    totalLike = json['total_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['image_data'] = this.imageData;
    data['total_like'] = this.totalLike;
    return data;
  }
}
