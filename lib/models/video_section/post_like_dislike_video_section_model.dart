class PostLikeDislikeVideoSection {
  int? success;
  int? status;
  String? message;
  bool? likeStatus;
  bool? dislikeStatus;
  int? totalLikes;
  int? totalDislikes;

  PostLikeDislikeVideoSection(
      {this.success,
      this.status,
      this.message,
      this.likeStatus,
      this.dislikeStatus,
      this.totalLikes,
      this.totalDislikes});

  PostLikeDislikeVideoSection.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    likeStatus = json['like_status'];
    dislikeStatus = json['dislike_status'];
    totalLikes = json['total_likes'];
    totalDislikes = json['total_dislikes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['like_status'] = this.likeStatus;
    data['dislike_status'] = this.dislikeStatus;
    data['total_likes'] = this.totalLikes;
    data['total_dislikes'] = this.totalDislikes;
    return data;
  }
}
