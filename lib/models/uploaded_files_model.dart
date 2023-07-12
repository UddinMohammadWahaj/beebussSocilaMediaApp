// To parse this JSON data, do
//
//     final uploadedFilesModel = uploadedFilesModelFromJson(jsonString);

import 'dart:convert';

List<UploadedFilesModel> uploadedFilesModelFromJson(String str) =>
    List<UploadedFilesModel>.from(
        json.decode(str).map((x) => UploadedFilesModel.fromJson(x)));

String uploadedFilesModelToJson(List<UploadedFilesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UploadedFilesModel {
  UploadedFilesModel({
    this.type,
    this.name,
    this.videoThumb,
  });

  String? type;
  String? name;
  String? videoThumb;

  factory UploadedFilesModel.fromJson(Map<String, dynamic> json) =>
      UploadedFilesModel(
        type: json["type"],
        name: json["name"],
        videoThumb: json["video_thumb"] == null ? null : json["video_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "video_thumb": videoThumb == null ? null : videoThumb,
      };
}

class UploadedFiles {
  List<UploadedFilesModel> files;

  UploadedFiles(this.files);
  factory UploadedFiles.fromJson(List<dynamic> parsed) {
    List<UploadedFilesModel> files = <UploadedFilesModel>[];
    files = parsed.map((i) => UploadedFilesModel.fromJson(i)).toList();
    return new UploadedFiles(files);
  }
}
