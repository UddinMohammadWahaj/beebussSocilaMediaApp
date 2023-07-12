// To parse this JSON data, do
//
//     final boardFilterModel = boardFilterModelFromJson(jsonString);

import 'dart:convert';

List<BoardFilterModel> boardFilterModelFromJson(String str) =>
    List<BoardFilterModel>.from(
        json.decode(str).map((x) => BoardFilterModel.fromJson(x)));

String boardFilterModelToJson(List<BoardFilterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BoardFilterModel {
  BoardFilterModel({
    this.name,
    this.isDefault,
  });

  String? name;
  bool? isDefault;

  factory BoardFilterModel.fromJson(Map<String, dynamic> json) =>
      BoardFilterModel(
        name: json["name"],
        isDefault: json["default"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "default": isDefault,
      };
}

class BoardFilter {
  List<BoardFilterModel> filters;
  BoardFilter(this.filters);
  factory BoardFilter.fromJson(List<dynamic> parsed) {
    List<BoardFilterModel> filters = <BoardFilterModel>[];
    filters = parsed.map((i) => BoardFilterModel.fromJson(i)).toList();
    return new BoardFilter(filters);
  }
}
