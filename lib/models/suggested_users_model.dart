// To parse this JSON data, do
//
//     final suggestedUsers = suggestedUsersFromJson(jsonString);

import 'dart:convert';

List<SuggestedUsers> suggestedUsersFromJson(String str) =>
    List<SuggestedUsers>.from(
        json.decode(str).map((x) => SuggestedUsers.fromJson(x)));

String suggestedUsersToJson(List<SuggestedUsers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuggestedUsers {
  SuggestedUsers({
    this.memberId,
    this.shortcode,
    this.image,
    this.name,
    this.url,
    this.followStatus,
  });

  String? memberId;
  String? shortcode;
  String? image;
  String? name;
  String? url;
  int? followStatus;

  factory SuggestedUsers.fromJson(Map<String, dynamic> json) => SuggestedUsers(
        memberId: json["memberId"],
        shortcode: json["shortcode"],
        image: json["image"],
        name: json["name"],
        url: json["url"],
        followStatus: json["follow_status"],
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "shortcode": shortcode,
        "image": image,
        "name": name,
        "url": url,
        "follow_status": followStatus,
      };
}

class Suggestions {
  List<SuggestedUsers> suggestions;

  Suggestions(this.suggestions);
  factory Suggestions.fromJson(List<dynamic> parsed) {
    List<SuggestedUsers> suggestions = <SuggestedUsers>[];
    suggestions = parsed.map((i) => SuggestedUsers.fromJson(i)).toList();
    return new Suggestions(suggestions);
  }
}
