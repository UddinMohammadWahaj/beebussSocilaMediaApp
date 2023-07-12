// To parse this JSON data, do
//
//     final addMultipleStoriesModel = addMultipleStoriesModelFromJson(jsonString);

import 'dart:convert';

List<AddMultipleStoriesModel> addMultipleStoriesModelFromJson(String str) =>
    List<AddMultipleStoriesModel>.from(
      json.decode(str).map(
            (x) => AddMultipleStoriesModel.fromJson(x),
          ),
    );

String addMultipleStoriesModelToJson(List<AddMultipleStoriesModel> data) =>
    json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class AddMultipleStoriesModel {
  AddMultipleStoriesModel({
    this.postId,
    this.files,
  });

  String? postId;
  List<FileElement>? files;
  bool isSelected = false;

  factory AddMultipleStoriesModel.fromJson(Map<String, dynamic> json) =>
      AddMultipleStoriesModel(
        postId: json["post_id"],
        files: List<FileElement>.from(
          json["files"].map(
            (x) => FileElement.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "files": List<dynamic>.from(
          files!.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class FileElement {
  FileElement({
    this.image,
    this.video,
    this.link,
    this.viewStatus,
    this.count,
    this.storyId,
    this.watchedUserImage,
    this.id,
    this.time,
    this.position,
  });

  String? image;
  int? video;
  String? link;
  int? viewStatus;
  int? count;
  int? storyId;
  String? watchedUserImage;
  String? id;
  String? time;
  List<Position>? position;
  bool? isSelected = false;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        image: json["image"],
        video: json["video"],
        link: json["link"],
        viewStatus: json["view_status"],
        count: json["count"],
        storyId: json["story_id"],
        watchedUserImage: json["watched_user_image"],
        id: json["id"],
        time: json["time"],
        position: List<Position>.from(
          json["position"].map(
            (x) => Position.fromJson(
              x,
            ),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "video": video,
        "link": link,
        "view_status": viewStatus,
        "count": count,
        "story_id": storyId,
        "watched_user_image": watchedUserImage,
        "id": id,
        "time": time,
        "position": List<dynamic>.from(
          position!.map(
            (x) => x.toJson(),
          ),
        ),
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

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class MultipleStories {
  List<AddMultipleStoriesModel> stories;
  MultipleStories(this.stories);
  factory MultipleStories.fromJson(List<dynamic> parsed) {
    List<AddMultipleStoriesModel> stories = <AddMultipleStoriesModel>[];
    stories = parsed.map((i) => AddMultipleStoriesModel.fromJson(i)).toList();
    return new MultipleStories(stories);
  }
}
