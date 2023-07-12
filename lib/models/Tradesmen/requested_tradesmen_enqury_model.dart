// To parse this JSON data, do
//
//     final requestedTradesmenModelList = requestedTradesmenModelListFromJson(jsonString);

import 'dart:convert';

RequestedTradesmenModelList requestedTradesmenModelListFromJson(String str) =>
    RequestedTradesmenModelList.fromJson(json.decode(str));

String requestedTradesmenModelListToJson(RequestedTradesmenModelList data) =>
    json.encode(data.toJson());

class RequestedTradesmenModelList {
  RequestedTradesmenModelList({
    this.status,
    this.record,
  });

  int? status;
  List<RequestedTradesmenRecord>? record;

  factory RequestedTradesmenModelList.fromJson(Map<String, dynamic> json) =>
      RequestedTradesmenModelList(
        status: json["status"],
        record: List<RequestedTradesmenRecord>.from(
            json["record"].map((x) => RequestedTradesmenRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "record": List<dynamic>.from(record!.map((x) => x.toJson())),
      };
}

class RequestedTradesmenRecord {
  RequestedTradesmenRecord({
    this.id,
    this.name,
    this.description,
    this.contactNumber,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? description;
  String? contactNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory RequestedTradesmenRecord.fromJson(Map<String, dynamic> json) =>
      RequestedTradesmenRecord(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        contactNumber: json["contact_number"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "contact_number": contactNumber,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
