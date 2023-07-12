// To parse this JSON data, do
//
//     final urlMetadataModel = urlMetadataModelFromJson(jsonString);

import 'dart:convert';

UrlMetadataModel urlMetadataModelFromJson(String str) =>
    UrlMetadataModel.fromJson(json.decode(str));

class UrlMetadataModel {
  UrlMetadataModel({
    this.title,
    this.image,
    this.domain,
  });

  String? title;
  String? image;
  String? domain;

  factory UrlMetadataModel.fromJson(Map<String, dynamic> json) =>
      UrlMetadataModel(
        title: json["title"],
        image: json["image"],
        domain: json["domain"],
      );
}

class UrlMetadata {
  List<UrlMetadataModel> metadata;
  UrlMetadata(this.metadata);
  factory UrlMetadata.fromJson(List<dynamic> parsed) {
    List<UrlMetadataModel> metadata = <UrlMetadataModel>[];
    metadata = parsed.map((i) => UrlMetadataModel.fromJson(i)).toList();
    return new UrlMetadata(metadata);
  }
}
