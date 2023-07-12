// To parse this JSON data, do
//
//     final highlightsModel = highlightsModelFromJson(jsonString);

import 'dart:convert';

import 'expanded_story_model.dart';

List<HighlightsModel> highlightsModelFromJson(String str) =>
    List<HighlightsModel>.from(
        json.decode(str).map((x) => HighlightsModel.fromJson(x)));

String highlightsModelToJson(List<HighlightsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HighlightsModel {
  HighlightsModel({
    this.highlightId,
    this.files,
  });

  String? highlightId;
  List<FileElement>? files;

  factory HighlightsModel.fromJson(Map<String, dynamic> json) =>
      HighlightsModel(
        highlightId: json["highlight_id"],
        files: List<FileElement>.from(
            json["files"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "highlight_id": highlightId,
        "files": List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class FileElement {
  FileElement({
    this.image,
    this.video,
    this.link,
    this.storyId,
    this.viewStatus,
    this.count,
    this.postId,
    this.watchedUserImage,
    this.id,
    this.timeStamp,
    this.position,
    //Added new
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
    this.musicPosData,
    this.stickers,
    this.musicStyle,
    this.videoDuration,

    //Added new end
  });

  String? image;
  String? musicStyle;
  int? video;
  String? link;
  String? storyId;
  int? viewStatus;
  int? count;
  String? postId;
  String? watchedUserImage;
  String? id;
  String? timeStamp;
  int? videoDuration;
  List<Position>? position;
//Add new start
  String? musicData;

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
  String? storyType;

//add new end
  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        musicStyle: json['music_Style'],
        image: json["image"],
        video: json["video"],

        link: json["link"],
        storyId: json["story_id"],
        viewStatus: json["view_status"],
        count: json["count"],
        postId: json["post_id"],
        watchedUserImage: json["watched_user_image"],
        id: json["id"],
        videoDuration: json['video_duration'],
        timeStamp: json["time_stamp"],
        position: List<Position>.from(
            json["position"].map((x) => Position.fromJson(x))),
        stickers: List<Sticker>.from(
            json["stickers"].map((x) => Sticker.fromJson(x))),
        // postParameters: List<PostParameter>.from(
        //     json["post_parameters"].map((x) => PostParameter.fromJson(x))),
        backgroundColors: json['background_colors'],
        taggedPerson: json['tagged_person'],
        assetImageData: json['assetImageData'] != null
            ? Sticker.fromJson(json['assetImageData'])
            : null,
        musicPosData: json['music_data'] != null
            ? Sticker.fromJson(json['music_data'])
            : null,
        timeView: json['timeView'] != null && !(json['timeView'] is Iterable)
            ? Sticker.fromJson(json['timeView'])
            : null,
        hashtag: json['hashtag'] != null && !(json['hashtag'] is Iterable)
            ? Sticker.fromJson(json['hashtag'])
            : null,
        musicData: json['music'],
        mantion: json["mantion"] == null
            ? null
            : List<Sticker>.from(
                json["mantion"].map((x) => Sticker.fromJson(x))),
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
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "video": video,
        "link": link,
        "story_id": storyId,
        "view_status": viewStatus,
        "count": count,
        "post_id": postId,
        "watched_user_image": watchedUserImage,
        "id": id,
        "time_stamp": timeStamp,
        "position": List<dynamic>.from(position!.map((x) => x.toJson())),
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

class ExpandedHighlights {
  List<HighlightsModel> highlights;

  ExpandedHighlights(this.highlights);
  factory ExpandedHighlights.fromJson(List<dynamic> parsed) {
    List<HighlightsModel> highlights = <HighlightsModel>[];
    highlights = parsed.map((i) => HighlightsModel.fromJson(i)).toList();
    return new ExpandedHighlights(highlights);
  }
}
