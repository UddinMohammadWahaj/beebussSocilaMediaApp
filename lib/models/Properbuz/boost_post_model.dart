// To parse this JSON data, do
//
//     final boostPostModel = boostPostModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

BoostPostModel boostPostModelFromJson(String str) =>
    BoostPostModel.fromJson(json.decode(str));

class BoostPostModel {
  BoostPostModel({
    this.postId,
    this.walletBalance,
    this.duration,
    this.date,
    this.budget,
    this.minReach,
    this.maxReach,
  });

  String? postId;
  RxInt? walletBalance;
  int? duration;
  DateTime? date;
  RxInt? budget;
  RxString? minReach;
  RxString? maxReach;

  factory BoostPostModel.fromJson(Map<String, dynamic> json) => BoostPostModel(
        postId: json["post_id"],
        walletBalance: new RxInt(json["wallet_balance"]),
        duration: json["duration"],
        date: json["date"] != null && json["date"] != ""
            ? DateTime.parse(json["date"])
            : DateTime.now(),
        budget: new RxInt(json["budget"]),
        minReach: json["min_reach"] != null && json["min_reach"] != ""
            ? RxString(json["min_reach"].toString())
            : "2".obs,
        maxReach: json["max_reach"] != null && json["max_reach"] != ""
            ? RxString(json["max_reach"].toString())
            : "100".obs,
      );
}
