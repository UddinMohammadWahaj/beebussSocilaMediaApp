import 'dart:convert';

import 'dart:typed_data';

List<ExpandedStoryModel> expandedStoryModelFromJson(String str) =>
    List<ExpandedStoryModel>.from(
        json.decode(str).map((x) => ExpandedStoryModel.fromJson(x)));

String expandedStoryModelToJson(List<ExpandedStoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpandedStoryModel {
  ExpandedStoryModel({
    this.postId,
    this.files,
  });

  String? postId;
  List<FileElement>? files;

  factory ExpandedStoryModel.fromJson(Map<String, dynamic> json) =>
      ExpandedStoryModel(
        postId: json["post_id"],
        files: List<FileElement>.from(
            json["files"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "files": List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class FileElement {
  FileElement(
      {this.image,
      this.video,
      this.link,
      this.viewStatus,
      this.count,
      this.storyId,
      this.watchedUserImage,
      this.id,
      this.timeStamp,
      this.position,
      this.stickers,
      this.videoDuration,
      this.postParameters,
      this.fromFeed,
      this.backgroundColors,
      this.taggedPerson,
      this.assetImageData,
      this.timeView,
      this.hashtag,
      this.mantion,
      this.locationtext,
      this.questionstext,
      this.questionsReplyData,
      this.musicData,
      this.videoVolume,
      this.musicStyle,
      this.musicPosData});

  String? image;
  int? video;
  String? link;
  String? musicData;
  int? viewStatus;
  int? count;
  int? storyId;
  String? watchedUserImage;
  String? id;
  int? videoDuration;
  String? timeStamp;
  List<Position>? position;
  List<PostParameter>? postParameters;
  List<Sticker>? stickers;
  bool? fromFeed;
  String? backgroundColors;
  String? taggedPerson;
  Sticker? assetImageData;
  Sticker? musicPosData;
  Sticker? timeView;
  Sticker? hashtag;
  List<Sticker>? mantion;
  Sticker? locationtext;
  Sticker? questionstext;
  String? questionsReplyData;
  Uint8List? memoryFile;
  bool? videoVolume;
  String? musicStyle;
  checkMusic(data) {
    try {
      return Sticker.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
      image: json["image"],
      musicData: json['music'],
      video: json["video"],
      musicStyle: json['music_style'],
      link: json["link"],
      viewStatus: json["view_status"],
      videoDuration: json["video_play"],
      count: json["count"],
      storyId: json["story_id"],
      watchedUserImage: json["watched_user_image"],
      id: json["id"],
      timeStamp: json["time_stamp"],
      fromFeed: json["from_feed"],
      position: List<Position>.from(
          json["position"].map((x) => Position.fromJson(x))),
      stickers:
          List<Sticker>.from(json["stickers"].map((x) => Sticker.fromJson(x))),
      postParameters: List<PostParameter>.from(
          json["post_parameters"].map((x) => PostParameter.fromJson(x))),
      backgroundColors: json['background_colors'],
      taggedPerson: json['tagged_member'],
      assetImageData: json['assetImageData'] != null
          ? Sticker.fromJson(json['assetImageData'])
          : null,
      musicPosData: json['music_data'] != null && json['music'] != ""
          ? Sticker.fromJson(json['music_data'])
          : null,
      timeView: json['timeView'] != null && !(json['timeView'] is Iterable)
          ? Sticker.fromJson(json['timeView'])
          : null,
      // List<Sticker>.from(
      //   json["assetImageData"].map((x) => Sticker.fromJson(x))),
      // timeView: List<Sticker>.from(
      //     json["timeView"].map((x) => Sticker.fromJson(x))),

      // hashtag:
      //     List<Sticker>.from(json["hashtag"].map((x) => Sticker.fromJson(x))),

      hashtag: json['hashtag'] != null && !(json['hashtag'] is Iterable)
          ? Sticker.fromJson(json['hashtag'])
          : null,
      mantion:
          List<Sticker>.from(json["mantion"].map((x) => Sticker.fromJson(x))),
      //locationtext: List<Sticker>.from(json["locationtext"].map((x) => Sticker.fromJson(x))),
      locationtext:
          json['locationtext'] != null && !(json['locationtext'] is Iterable)
              ? Sticker.fromJson(json['locationtext'])
              : null,
      // questionstext: List<Sticker>.from(json["questions"].map((x) => Sticker.fromJson(x))),
      questionstext:
          json['questions'] != null && !(json['questions'] is Iterable)
              ? Sticker.fromJson(json['questions'])
              : null,
      questionsReplyData: json['questionsReplyData'],
      videoVolume: json['video_volume']);

  Map<String, dynamic> toJson() => {
        "image": image,
        "video": video,
        "link": link,
        "video_play": videoDuration,
        "view_status": viewStatus,
        "count": count,
        "story_id": storyId,
        "watched_user_image": watchedUserImage,
        "id": id,
        "time_stamp": timeStamp,
        "position": List<dynamic>.from(position!.map((x) => x.toJson())),
        "stickers": List<dynamic>.from(stickers!.map((x) => x.toJson())),
        "background_colors": this.backgroundColors,
        "tagged_person": this.taggedPerson,
        "assetImageData": List<dynamic>.from(stickers!.map((x) => x.toJson())),
        "timeView": List<dynamic>.from(stickers!.map((x) => x.toJson())),
        "hashtag": List<dynamic>.from(stickers!.map((x) => x.toJson())),
        "mantion": List<dynamic>.from(stickers!.map((x) => x.toJson())),
        "locationtext": List<dynamic>.from(stickers!.map((x) => x.toJson())),
        "questions": List<dynamic>.from(stickers!.map((x) => x.toJson())),
        "questionsReplyData": this.questionsReplyData,
      };
}

class Position {
  Position({
    this.posx,
    this.posy,
    this.text,
    this.color,
    this.name,
    this.scale,
    this.height,
    this.width,
  });

  String? posx;
  String? posy;
  String? text;
  String? color;
  String? name;
  String? scale;
  String? height;
  String? width;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        posx: json["posx"],
        posy: json["posy"],
        text: json["text"],
        color: json["color"],
        name: json["name"],
        scale: json["scale"],
        height: json["height"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "posx": posx,
        "posy": posy,
        "text": text,
        "color": color,
        "name": name,
        "scale": scale,
        "height": height,
        "width": width,
      };
}

class Sticker {
  Sticker({
    this.posx,
    this.posy,
    this.name,
    this.id,
    this.scale,
    this.rotation,
    this.style,
  });

  String? posx;
  String? posy;
  String? name;
  String? id;
  String? scale;
  String? rotation;
  String? style;

  factory Sticker.fromJson(Map<String, dynamic> json) => Sticker(
      posx: json["posx"],
      posy: json["posy"],
      name: json["name"],
      id: json["id"],
      scale: json["scale"],
      rotation: json["rotation"],
      style: json['style']);

  Map<String, dynamic> toJson() => {
        "posx": posx,
        "posy": posy,
        "name": name,
        "id": id,
        "scale": scale,
        "rotation": rotation,
      };
}

class PostParameter {
  PostParameter({
    this.postId,
    this.memberId,
    this.thumbnailUrl,
    this.userImage,
    this.userName,
    this.shortcode,
    this.description,
    this.blogTitle,
    this.message,
    this.isMultiple,
    this.color,
  });

  String? postId;
  String? memberId;
  String? thumbnailUrl;
  String? userImage;
  String? userName;
  String? shortcode;
  String? description;
  String? blogTitle;
  String? message;
  bool? isMultiple;
  String? color;

  factory PostParameter.fromJson(Map<String, dynamic> json) => PostParameter(
        postId: json["post_id"],
        memberId: json["user_id"],
        thumbnailUrl: json["thumbnail_url"],
        userImage: json["user_image"],
        userName: json["user_name"],
        shortcode: json["shortcode"],
        description: json["description"],
        blogTitle: json["blog_title"],
        message: json["message"],
        isMultiple: json["isMultiple"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": memberId,
        "thumbnail_url": thumbnailUrl,
        "user_image": userImage,
        "user_name": userName,
        "shortcode": shortcode,
        "description": description,
        "blog_title": blogTitle,
        "message": message,
        "isMultiple": isMultiple,
        "color": color,
      };
}

class ExpandedStories {
  List<ExpandedStoryModel> stories;
  ExpandedStories(this.stories);
  factory ExpandedStories.fromJson(List<dynamic> parsed) {
    List<ExpandedStoryModel> stories = <ExpandedStoryModel>[];
    stories = parsed.map((i) => ExpandedStoryModel.fromJson(i)).toList();
    return new ExpandedStories(stories);
  }
}
