import 'dart:convert';

List<AutoPlayVideoModel> autoPlayVideoModelFromJson(String str) =>
    List<AutoPlayVideoModel>.from(
      json.decode(str).map(
            (x) => AutoPlayVideoModel.fromJson(x),
          ),
    );

String autoPlayVideoModelToJson(List<AutoPlayVideoModel> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class AutoPlayVideoModel {
  AutoPlayVideoModel(
      {this.image,
      this.category,
      this.categoryIt,
      this.postId,
      this.video,
      this.videoHeight,
      this.videoWidth,
      this.timeStamp,
      this.shortcode,
      this.name,
      this.postContent,
      this.numViews,
      this.likeIcon,
      this.dislikeIcon,
      this.numberOfLike,
      this.numberOfDislike,
      this.followData,
      this.totalComments,
      this.likeStatus,
      this.dislikeStatus,
      this.userImage,
      this.shareUrl,
      this.userID,
      this.quality,
      this.followStatus});

  String? image;
  String? category;
  String? categoryIt;
  String? postId;
  String? video;
  int? videoHeight;
  int? videoWidth;
  String? timeStamp;
  String? shortcode;
  String? name;
  String? postContent;
  String? numViews;
  String? likeIcon;
  String? dislikeIcon;
  int? numberOfLike;
  int? numberOfDislike;
  dynamic followData;
  dynamic totalComments;
  bool? likeStatus;
  bool? dislikeStatus;
  int? followStatus;
  dynamic userImage;
  String? shareUrl;
  String? userID;
  String? quality;

  factory AutoPlayVideoModel.fromJson(Map<String, dynamic> json) =>
      AutoPlayVideoModel(
        image: json["image"],
        quality: json['quality'],
        userID: json["user_id"].toString(),
        shareUrl: json["video_url"],
        category: json["category"],
        categoryIt: json["category_it"],
        postId: json["post_id"].toString(),
        video: json["video"],
        videoHeight: json["video_height"],
        videoWidth: json["video_width"],
        timeStamp: json["time_stamp"],
        shortcode: json["shortcode"],
        name: json["name"],
        followStatus: json['follow_status'],
        postContent: json["post_content"],
        numViews: json["num_views"].toString(),
        likeIcon: json["like_icon"],
        dislikeIcon: json["dislike_icon"],
        numberOfLike: json["number_of_like"],
        numberOfDislike: json["number_of_dislike"],
        followData: json["follow_data"],
        totalComments: json["total_comments"].toString(),
        likeStatus: json["like_status"],
        dislikeStatus: json["dislike_status"],
        userImage: json["user_image"],
      );

  Map<String, dynamic> toJson() => {
        "video_url": shareUrl,
        "quality": quality,
        "post_user_id": userID,
        "image": image,
        "category": category,
        "category_it": categoryIt,
        "post_id": postId,
        "video": video,
        "follow_status": followStatus,
        "video_height": videoHeight,
        "video_width": videoWidth,
        "time_stamp": timeStamp,
        "shortcode": shortcode,
        "name": name,
        "post_content": postContent,
        "num_views": numViews,
        "like_icon": likeIcon,
        "dislike_icon": dislikeIcon,
        "number_of_like": numberOfLike,
        "number_of_dislike": numberOfDislike,
        "follow_data": followData,
        "total_comments": totalComments,
        "like_status": likeStatus,
        "dislike_status": dislikeStatus,
        "user_image": userImage,
      };
}

class AutoPlayVideos {
  List<AutoPlayVideoModel> videos;

  AutoPlayVideos(this.videos);

  factory AutoPlayVideos.fromJson(List<dynamic> parsed) {
    List<AutoPlayVideoModel> videos = <AutoPlayVideoModel>[];
    videos = parsed.map((i) => AutoPlayVideoModel.fromJson(i)).toList();
    return new AutoPlayVideos(videos);
  }
}
