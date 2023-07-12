// To parse this JSON data, do
//
//     final follower = followerFromJson(jsonString);

import 'dart:convert';

List<Follower> followerFromJson(String str) =>
    List<Follower>.from(json.decode(str).map((x) => Follower.fromJson(x)));

String followerToJson(List<Follower> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Follower {
  Follower(
      {this.memberId,
      this.name,
      this.shortcode,
      this.officalRecommended,
      this.varified,
      this.image,
      this.status});

  String? memberId;
  String? name;
  String? shortcode;
  String? officalRecommended;
  String? varified;
  String? image;
  String? status;
  bool? isFollowed;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
      memberId: json["user_id"],
      name: json["name"],
      shortcode: json["shortcode"],
      officalRecommended: json["offical_recommended"],
      varified: json["varified"],
      image: json["image"],
      status: "Follow");

  Map<String, dynamic> toJson() => {
        "user_id": memberId,
        "name": name,
        "shortcode": shortcode,
        "offical_recommended": officalRecommended,
        "varified": varified,
        "image": image,
      };
}

class Followers {
  List<Follower> followers;

  Followers(this.followers);
  factory Followers.fromJson(List<dynamic> parsed) {
    List<Follower> followers = <Follower>[];
    followers = parsed.map((i) => Follower.fromJson(i)).toList();
    return new Followers(followers);
  }
}
