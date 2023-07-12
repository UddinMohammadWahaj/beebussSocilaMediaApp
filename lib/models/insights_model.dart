// To parse this JSON data, do
//
//     final insightsModel = insightsModelFromJson(jsonString);

import 'dart:convert';

InsightsModel insightsModelFromJson(String str) =>
    InsightsModel.fromJson(json.decode(str));

String insightsModelToJson(InsightsModel data) => json.encode(data.toJson());

class InsightsModel {
  InsightsModel({
    this.response,
    this.postId,
    this.postInsight,
    this.totalLikes,
    this.totalComments,
    this.noOfShare,
    this.profileVisit,
    this.totalReach,
    this.actionTakenFeomPost,
    this.discovery,
    this.impression,
    this.followCount,
  });

  String? response;
  String? postId;
  String? postInsight;
  int? totalLikes;
  String? totalComments;
  String? noOfShare;
  String? profileVisit;
  int? totalReach;
  String? actionTakenFeomPost;
  String? discovery;
  String? impression;
  String? followCount;

  factory InsightsModel.fromJson(Map<String, dynamic> json) => InsightsModel(
        response: json["response"],
        postId: json["post_id"],
        postInsight: json["post_insight"],
        totalLikes: json["total_likes"],
        totalComments: json["total_comments"],
        noOfShare: json["no_of_share"],
        profileVisit: json["profile_visit"],
        totalReach: json["total_reach"],
        actionTakenFeomPost: json["action_taken_feom_post"],
        discovery: json["discovery"],
        impression: json["impression"],
        followCount: json["follow_count"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "post_id": postId,
        "post_insight": postInsight,
        "total_likes": totalLikes,
        "total_comments": totalComments,
        "no_of_share": noOfShare,
        "profile_visit": profileVisit,
        "total_reach": totalReach,
        "action_taken_feom_post": actionTakenFeomPost,
        "discovery": discovery,
        "impression": impression,
        "follow_count": followCount,
      };
}

class Insights {
  List<InsightsModel> insights;

  Insights(this.insights);

  factory Insights.fromJson(List<dynamic> parsed) {
    List<InsightsModel> insights = <InsightsModel>[];
    insights = parsed.map((i) => InsightsModel.fromJson(i)).toList();
    return new Insights(insights);
  }
}
