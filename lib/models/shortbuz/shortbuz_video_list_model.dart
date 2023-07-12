class ShortbuzVideoListModel {
  int? success;
  int? status;
  String? message;
  List<Data>? data;

  ShortbuzVideoListModel({this.success, this.status, this.message, this.data});

  ShortbuzVideoListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? postId;
  String? postType;
  int? boostData;
  int? boostedCount;
  String? video;
  String? color;
  String? boostedButton;
  String? boostedTitle;
  String? boostedLink;
  String? boostedDomain;
  String? boostedDescription;
  String? postContent;
  String? postPostbyuser;
  String? postPostonuser;
  String? postUserId;
  String? postUserFirstname;
  String? postUserLastname;
  String? postUserName;
  String? postUserPicture;
  String? postShortcode;
  String? postNumViews;
  String? postTotalLikes;
  int? postTotalComments;
  String? postLikeIcon;
  String? postCommentIcon;
  String? postImgData;
  String? thumbnailUrl;
  String? postVideoData;
  String? postVideoThumb;
  String? postHeaderImage;
  String? postHeaderUrl;
  int? postMultiImage;
  int? postRebuz;
  String? postRebuzData;
  String? postHeaderLocation;
  int? postUrlData;
  String? postUrlNam;
  String? postDomainName;
  int? postTaggedData;
  String? postTaggedDataDetails;
  int? blogId;
  String? blogContent;
  String? postBlogCategory;
  String? postBlogData;
  String? postUrlToShare;
  String? postTotalReach;
  String? postTotalEngagement;
  String? postPromotePost;
  String? postViewInsight;
  int? postPromotedSlider;
  String? postCommentResult;
  String? postEmbedData;
  int? postVideoHeight;
  int? postVideoWidth;
  String? postVideoReso;
  String? postDataLong;
  String? postDataLat;
  int? postImageWidth;
  int? postImageHeight;
  int? videoTag;
  int? postSingle;
  int? cropped;
  String? varified;
  List<String>? position;
  List<StickerVideo>? stickers;
  String? timeStamp;
  String? postDate;
  int? dataSequence;
  bool? isHidden = false;
  bool? isLoaded = false;
  bool? notInterested = false;

  Data(
      {this.postId,
      this.postType,
      this.boostData,
      this.boostedCount,
      this.video,
      this.color,
      this.boostedButton,
      this.boostedTitle,
      this.boostedLink,
      this.boostedDomain,
      this.boostedDescription,
      this.postContent,
      this.postPostbyuser,
      this.postPostonuser,
      this.postUserId,
      this.postUserFirstname,
      this.postUserLastname,
      this.postUserName,
      this.postUserPicture,
      this.postShortcode,
      this.postNumViews,
      this.postTotalLikes,
      this.postTotalComments,
      this.postLikeIcon,
      this.postCommentIcon,
      this.postImgData,
      this.thumbnailUrl,
      this.postVideoData,
      this.postVideoThumb,
      this.postHeaderImage,
      this.postHeaderUrl,
      this.postMultiImage,
      this.postRebuz,
      this.postRebuzData,
      this.postHeaderLocation,
      this.postUrlData,
      this.postUrlNam,
      this.postDomainName,
      this.postTaggedData,
      this.postTaggedDataDetails,
      this.blogId,
      this.blogContent,
      this.postBlogCategory,
      this.postBlogData,
      this.postUrlToShare,
      this.postTotalReach,
      this.postTotalEngagement,
      this.postPromotePost,
      this.postViewInsight,
      this.postPromotedSlider,
      this.postCommentResult,
      this.postEmbedData,
      this.postVideoHeight,
      this.postVideoWidth,
      this.postVideoReso,
      this.postDataLong,
      this.postDataLat,
      this.postImageWidth,
      this.postImageHeight,
      this.videoTag,
      this.postSingle,
      this.cropped,
      this.varified,
      this.position,
      this.stickers,
      this.timeStamp,
      this.notInterested,
      this.postDate,
      this.dataSequence});

  Data.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'].toString();
    postType = json['post_type'].toString();
    boostData = json['boost_data'];
    boostedCount = json['boosted_count'];
    video = json['video'];
    color = json['color'];
    boostedButton = json['boosted_button'];
    boostedTitle = json['boosted_title'];
    boostedLink = json['boosted_link'];
    boostedDomain = json['boosted_domain'];
    boostedDescription = json['boosted_description'];
    postContent = json['post_content'];
    postPostbyuser = json['post_postbyuser'].toString();
    postPostonuser = json['post_postonuser'].toString();
    postUserId = json['post_user_id'].toString();
    postUserFirstname = json['post_user_firstname'];
    postUserLastname = json['post_user_lastname'];
    postUserName = json['post_user_name'];
    postUserPicture = json['post_user_picture'];
    postShortcode = json['post_shortcode'];
    postNumViews = json['post_num_views'].toString();
    postTotalLikes = json['post_total_likes'].toString();
    postTotalComments = json['post_total_comments'];
    postLikeIcon = json['post_like_icon'];
    postCommentIcon = json['post_comment_icon'];
    postImgData = json['post_img_data'];
    thumbnailUrl = json['thumbnail_url'];
    postVideoData = json['post_video_data'];
    postVideoThumb = json['post_video_thumb'];
    postHeaderImage = json['post_header_image'];
    postHeaderUrl = json['post_header_url'];
    postMultiImage = json['post_multi_image'];
    postRebuz = json['post_rebuz'];
    postRebuzData = json['post_rebuz_data'];
    postHeaderLocation = json['post_header_location'];
    postUrlData = json['post_url_data'];
    postUrlNam = json['post_url_nam'];
    postDomainName = json['post_domain_name'];
    postTaggedData = json['post_tagged_data'];
    postTaggedDataDetails = json['post_tagged_data_details'];
    blogId = json['blog_id'];
    blogContent = json['blog_content'];
    postBlogCategory = json['post_blog_category'];
    postBlogData = json['post_blog_data'];
    postUrlToShare = json['post_url_to_share'];
    postTotalReach = json['post_total_reach'].toString();
    postTotalEngagement = json['post_total_engagement'].toString();
    postPromotePost = json['post_promote_post'];
    postViewInsight = json['post_view_insight'];
    postPromotedSlider = json['post_promoted_slider'];
    postCommentResult = json['post_comment_result'];
    postEmbedData = json['post_embed_data'];
    postVideoHeight = json['post_video_height'];
    postVideoWidth = json['post_video_width'];
    postVideoReso = json['post_video_reso'];
    postDataLong = json['post_data_long'];
    postDataLat = json['post_data_lat'];
    postImageWidth = json['post_image_width'];
    postImageHeight = json['post_image_height'];
    videoTag = json['video_tag'];
    postSingle = json['post_single'];
    cropped = json['cropped'];
    varified = json['varified'];
    notInterested = json['not_interested'] ?? false;
    if (json['position'] != null) {
      position = <String>[];
      json['position'].forEach((v) {
        position!.add(v.toString());
      });
    }
    if (json['stickers'] != null) {
      stickers = <StickerVideo>[];
      json['stickers'].forEach((v) {
        stickers!.add(StickerVideo.fromJson(v));
      });
    }
    timeStamp = json['time_stamp'];
    postDate = json['post_date'];
    dataSequence = json['data_sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['post_type'] = this.postType;
    data['boost_data'] = this.boostData;
    data['boosted_count'] = this.boostedCount;
    data['video'] = this.video;
    data['color'] = this.color;
    data['boosted_button'] = this.boostedButton;
    data['boosted_title'] = this.boostedTitle;
    data['boosted_link'] = this.boostedLink;
    data['boosted_domain'] = this.boostedDomain;
    data['boosted_description'] = this.boostedDescription;
    data['post_content'] = this.postContent;
    data['post_postbyuser'] = this.postPostbyuser;
    data['post_postonuser'] = this.postPostonuser;
    data['post_user_id'] = this.postUserId;
    data['post_user_firstname'] = this.postUserFirstname;
    data['post_user_lastname'] = this.postUserLastname;
    data['post_user_name'] = this.postUserName;
    data['post_user_picture'] = this.postUserPicture;
    data['post_shortcode'] = this.postShortcode;
    data['post_num_views'] = this.postNumViews;
    data['post_total_likes'] = this.postTotalLikes;
    data['post_total_comments'] = this.postTotalComments;
    data['post_like_icon'] = this.postLikeIcon;
    data['post_comment_icon'] = this.postCommentIcon;
    data['post_img_data'] = this.postImgData;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['post_video_data'] = this.postVideoData;
    data['post_video_thumb'] = this.postVideoThumb;
    data['post_header_image'] = this.postHeaderImage;
    data['post_header_url'] = this.postHeaderUrl;
    data['post_multi_image'] = this.postMultiImage;
    data['post_rebuz'] = this.postRebuz;
    data['post_rebuz_data'] = this.postRebuzData;
    data['post_header_location'] = this.postHeaderLocation;
    data['post_url_data'] = this.postUrlData;
    data['post_url_nam'] = this.postUrlNam;
    data['post_domain_name'] = this.postDomainName;
    data['post_tagged_data'] = this.postTaggedData;
    data['post_tagged_data_details'] = this.postTaggedDataDetails;
    data['blog_id'] = this.blogId;
    data['blog_content'] = this.blogContent;
    data['post_blog_category'] = this.postBlogCategory;
    data['post_blog_data'] = this.postBlogData;
    data['post_url_to_share'] = this.postUrlToShare;
    data['post_total_reach'] = this.postTotalReach;
    data['post_total_engagement'] = this.postTotalEngagement;
    data['post_promote_post'] = this.postPromotePost;
    data['post_view_insight'] = this.postViewInsight;
    data['post_promoted_slider'] = this.postPromotedSlider;
    data['post_comment_result'] = this.postCommentResult;
    data['post_embed_data'] = this.postEmbedData;
    data['post_video_height'] = this.postVideoHeight;
    data['post_video_width'] = this.postVideoWidth;
    data['post_video_reso'] = this.postVideoReso;
    data['post_data_long'] = this.postDataLong;
    data['post_data_lat'] = this.postDataLat;
    data['post_image_width'] = this.postImageWidth;
    data['post_image_height'] = this.postImageHeight;
    data['video_tag'] = this.videoTag;
    data['post_single'] = this.postSingle;
    data['cropped'] = this.cropped;
    data['varified'] = this.varified;
    data['not_interested'] = this.notInterested;
    if (this.position != null) {
      data['position'] = this.position!.map((v) => v).toList();
    }
    if (this.stickers != null) {
      data['stickers'] = this.stickers!.map((v) => v).toList();
    }
    data['time_stamp'] = this.timeStamp;
    data['post_date'] = this.postDate;
    data['data_sequence'] = this.dataSequence;
    return data;
  }
}

class StickerVideo {
  StickerVideo({
    this.posx,
    this.posy,
    this.name,
    this.id,
    this.scale,
  });

  String? posx;
  String? posy;
  String? name;
  String? id;
  String? scale;

  factory StickerVideo.fromJson(Map<String, dynamic> json) => StickerVideo(
        posx: json["posx"],
        posy: json["posy"],
        name: json["name"],
        id: json["id"],
        scale: json["scale"],
      );

  Map<String, dynamic> toJson() => {
        "posx": posx,
        "posy": posy,
        "name": name,
        "id": id,
        "scale": scale,
      };
}
