// To parse this JSON data, do
//
//     final boardsListModel = boardsListModelFromJson(jsonString);

import 'dart:convert';

List<BoardsListModel> boardsListModelFromJson(String str) =>
    List<BoardsListModel>.from(
        json.decode(str).map((x) => BoardsListModel.fromJson(x)));

String boardsListModelToJson(List<BoardsListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BoardsListModel {
  BoardsListModel({
    this.boardId,
    this.name,
    this.images,
    this.posts,
  });

  String? boardId;
  String? name;
  String? images;
  String? posts;

  factory BoardsListModel.fromJson(Map<String, dynamic> json) =>
      BoardsListModel(
        boardId: json["board_id"],
        name: json["name"],
        images: json["image1"],
        posts: json["posts"],
      );

  Map<String, dynamic> toJson() => {
        "board_id": boardId,
        "name": name,
        "image1": images,
      };
}

class BoardsList {
  List<BoardsListModel> boards;

  BoardsList(this.boards);
  factory BoardsList.fromJson(List<dynamic> parsed) {
    List<BoardsListModel> boards = <BoardsListModel>[];
    boards = parsed.map((i) => BoardsListModel.fromJson(i)).toList();
    return new BoardsList(boards);
  }
}
