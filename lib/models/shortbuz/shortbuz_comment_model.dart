class ShortbuzCommentModel {
  int? success;
  int? status;
  String? message;
  List<ShortbuzCommentModelData>? data;

  ShortbuzCommentModel({this.success, this.status, this.message, this.data});

  ShortbuzCommentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShortbuzCommentModelData>[];
      json['data'].forEach((v) {
        data!.add(new ShortbuzCommentModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShortbuzCommentModelData {
  String? totalLikes;
  String? timeData;
  int? subComment;
  String? commentId;
  String? shortcodeUrl;
  String? shortcode;
  String? message;
  String? image;
  String? likeLogo;
  String? memberId;
  bool? isSubCommentOpen = false;
  bool? isLiked = false;

  ShortbuzCommentModelData(
      {this.totalLikes,
      this.timeData,
      this.subComment,
      this.commentId,
      this.shortcodeUrl,
      this.shortcode,
      this.message,
      this.image,
      this.likeLogo,
      this.memberId});

  ShortbuzCommentModelData.fromJson(Map<String, dynamic> json) {
    totalLikes = json['total_likes'];
    timeData = json['time_data'];
    subComment = json['sub_comment'];
    commentId = json['comment_id'];
    shortcodeUrl = json['shortcode_url'];
    shortcode = json['shortcode'];
    message = json['message'];
    image = json['image'];
    likeLogo = json['like_logo'];
    memberId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_likes'] = this.totalLikes;
    data['time_data'] = this.timeData;
    data['sub_comment'] = this.subComment;
    data['comment_id'] = this.commentId;
    data['shortcode_url'] = this.shortcodeUrl;
    data['shortcode'] = this.shortcode;
    data['message'] = this.message;
    data['image'] = this.image;
    data['like_logo'] = this.likeLogo;
    data['user_id'] = this.memberId;
    return data;
  }
}
