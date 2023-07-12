// To parse this JSON data, do
//
//     final boardModel = boardModelFromJson(jsonString);

import 'dart:convert';

List<BoardModel> boardModelFromJson(String str) =>
    List<BoardModel>.from(json.decode(str).map((x) => BoardModel.fromJson(x)));

String boardModelToJson(List<BoardModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BoardModel {
  BoardModel({
    this.boardId,
    this.name,
    this.isSecrete,
    this.posts,
    this.time,
    this.image1,
    this.image2,
    this.image3,
    this.description,
  });

  String? boardId;
  String? name;
  bool? isSecrete;
  String? posts;
  String? time;
  String? image1;
  String? image2;
  String? image3;
  String? description;

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
      boardId: json["board_id"],
      name: json["name"],
      isSecrete: json["secrate"],
      posts: json["posts"],
      time: json["time"],
      image1: json["image1"],
      image2: json["image2"],
      image3: json["image3"],
      description: json["description"]);

  Map<String, dynamic> toJson() => {
        "board_id": boardId,
        "name": name,
        "secrate": isSecrete,
        "posts": posts,
        "time": time,
        "image1": image1,
        "image2": image2,
        "image3": image3,
      };
}

class SavedBoards {
  List<BoardModel> boards;

  SavedBoards(this.boards);
  factory SavedBoards.fromJson(List<dynamic> parsed) {
    List<BoardModel> boards = <BoardModel>[];
    boards = parsed.map((i) => BoardModel.fromJson(i)).toList();
    return new SavedBoards(boards);
  }
}
