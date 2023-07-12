import 'dart:convert';

List<NewsFeedLikedUsersModel> NewsfeedLikedUsersModelFromJson(String str) =>
    List<NewsFeedLikedUsersModel>.from(
        json.decode(str).map((x) => NewsFeedLikedUsersModel.fromJson(x)));

String NewsfeedLikedUsersModelToJson(List<NewsFeedLikedUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsFeedLikedUsersModel {
  NewsFeedLikedUsersModel({
    this.image,
    this.shortcode,
    this.timeStamp,
    this.name,
    this.followData,
    this.memberId,
  });

  String? image;
  String? shortcode;
  String? timeStamp;
  String? name;
  String? followData;
  String? memberId;

  factory NewsFeedLikedUsersModel.fromJson(Map<String, dynamic> json) =>
      NewsFeedLikedUsersModel(
        image: json["image"],
        shortcode: json["shortcode"],
        timeStamp: json["time_stamp"],
        name: json["name"],
        followData: json["follow_data"],
        memberId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "shortcode": shortcode,
        "time_stamp": timeStamp,
        "name": name,
        "follow_data": followData,
        "user_id": memberId,
      };
}

class NewsFeedLikedUsers {
  List<NewsFeedLikedUsersModel> newsfeedusers;

  NewsFeedLikedUsers(this.newsfeedusers);
  factory NewsFeedLikedUsers.fromJson(List<dynamic> parsed) {
    List<NewsFeedLikedUsersModel> newsfeedusers = <NewsFeedLikedUsersModel>[];
    newsfeedusers =
        parsed.map((i) => NewsFeedLikedUsersModel.fromJson(i)).toList();
    return new NewsFeedLikedUsers(newsfeedusers);
  }
}
