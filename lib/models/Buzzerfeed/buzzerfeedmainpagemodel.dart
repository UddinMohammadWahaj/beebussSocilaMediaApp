// To parse this JSON data, do
//
//     final buzzerfeedMain = buzzerfeedMainFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

BuzzerfeedMain buzzerfeedMainFromJson(String str) =>
    BuzzerfeedMain.fromJson(json.decode(str));

String buzzerfeedMainToJson(BuzzerfeedMain data) => json.encode(data.toJson());

class BuzzerfeedMain {
  BuzzerfeedMain({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  int? success;
  int? status;
  String? message;
  List<BuzzerfeedDatum>? data;

  void getErrorParam() {}

  factory BuzzerfeedMain.fromJson(Map<String, dynamic> json) => BuzzerfeedMain(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<BuzzerfeedDatum>.from(
            json["data"].map((x) => BuzzerfeedDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PollDatum {
  PollDatum({
    this.answerId,
    this.answer,
    this.status,
    this.totalVotes,
  });

  String? answerId;
  String? answer;
  bool? status;
  String? totalVotes;

  factory PollDatum.fromJson(Map<String, dynamic> json) => PollDatum(
        answerId: json["answer_id"],
        answer: json["answer"],
        status: json["status"],
        totalVotes: json["total_votes"],
      );

  Map<String, dynamic> toJson() => {
        "answer_id": answerId,
        "answer": answer,
        "status": status,
        "total_votes": totalVotes,
      };
}

class BuzzerfeedDatum {
  BuzzerfeedDatum(
      {this.buzzerfeedId,
      this.memberId,
      this.memberName,
      this.userPicture,
      this.shortcode,
      this.description,
      this.privacy,
      this.location,
      this.type,
      this.images,
      this.video,
      this.thumb,
      this.pollStatus,
      this.pollTime,
      this.pollQuestion,
      this.pollAnswer,
      this.gifFile,
      this.numViews,
      this.followStatus,
      this.totalLikes,
      this.totalComments,
      this.likeStatus,
      this.totalReBuzzerfeed,
      this.reBuzzerfeedStatus,
      this.reBuzzerquoteStatus,
      this.quotes,
      this.timeStamp,
      this.page,
      this.linkImages,
      this.linkLink,
      this.linkDomain,
      this.linkHeader,
      this.varified,
      this.reBuzzerfeedMessage,
      this.linkDesc,
      this.isvoting,
      this.testpoll});
  String? varified;
  String? buzzerfeedId;
  String? memberId;
  String? memberName;
  String? userPicture;
  String? shortcode;
  String? description;
  String? privacy;
  String? location;
  String? type;
  List<String>? images;
  String? video;
  String? thumb;
  // int pollStatus;
  String? pollTime;
  String? pollQuestion;
  List<PollDatum>? pollAnswer;
  String? gifFile;
  String? numViews;
  // int followStatus;
  // int totalLikes;
  // int totalComments;
  RxBool? likeStatus;
  // int totalReBuzzerfeed;
  RxBool? reBuzzerfeedStatus;
  RxBool? reBuzzerquoteStatus;
  List<Quote>? quotes;
  String? timeStamp;

  //int to string

  String? page;
  String? pollStatus;
  String? followStatus;
  RxString? totalLikes;
  String? totalComments;
  RxString? totalReBuzzerfeed;
  List? linkImages;
  List? linkDesc;
  List? linkLink;
  List? linkHeader;
  List? linkDomain;
  RxList? testpoll;
  RxBool? isvoting;
  String? reBuzzerfeedMessage;
  // = [].obs;
  // List<PollDatum> testpoll = [].obs;
  printType() {}

  factory BuzzerfeedDatum.fromJson(Map<String, dynamic> json) {
    // json.forEach((key, value) {
    //   print("$key, type=${value.r}")
    // });
    var data = json["poll_answer"].length == 0
        ? []
        : List<PollDatum>.from(
            json["poll_answer"].map((x) => PollDatum.fromJson(x)));

    return BuzzerfeedDatum(
        reBuzzerfeedMessage: json['re_buzzerfeed_message'],
        varified: json['varified'],
        linkLink: json['link_link'],
        linkHeader: json['link_header'],
        linkDomain: json['link_domain'],
        linkDesc: json['link_desc'],
        linkImages: json['link_images'],
        buzzerfeedId: json["buzzerfeed_id"].toString(),
        memberId: json["user_id"].toString(),
        memberName: json["member_name"],
        userPicture: json["user_picture"],
        shortcode: json["shortcode"],
        description: json["description"],
        privacy: json["privacy"],
        location: json["location"],
        type: json["type"],
        images: List<String>.from(json["images"].map((x) => x)),
        video: json["video"],
        thumb: json["thumb"],
        pollStatus: json["poll_status"].toString(),
        pollTime: json["poll_time"],
        pollQuestion: json["poll_question"],
        pollAnswer: json["poll_answer"].length != 0
            ? List<PollDatum>.from(
                json["poll_answer"].map((x) => PollDatum.fromJson(x)))
            : [],
        gifFile: json["gif_file"],
        numViews: json["num_views"].toString(),
        followStatus: json["follow_status"].toString(),
        totalLikes: new RxString(json["total_likes"].toString()),
        totalComments: json["total_comments"].toString(),
        likeStatus: new RxBool(json["like_status"]),
        totalReBuzzerfeed: RxString(json["total_re_buzzerfeed"].toString()),
        reBuzzerfeedStatus: new RxBool(json["re_buzzerfeed_status"]),
        reBuzzerquoteStatus: new RxBool(json["re_buzzerquote_status"]),
        quotes: json['quotes'].length != 0
            ? List<Quote>.from(json["quotes"].map((x) => Quote.fromJson(x)))
            : [],
        timeStamp: json["time_stamp"],
        page: json["page"].toString(),
        isvoting: new RxBool(json['is_voting']),
        testpoll: data.length != 0 ? new RxList(data) : new RxList([]));
  }
  Map<String, dynamic> toJson() => {
        "varified": varified,
        "link_link": linkLink,
        "link_domain": linkDomain,
        "link_header": linkHeader,
        "link_images": linkImages,
        "link_desc": linkDesc,
        "buzzerfeed_id": buzzerfeedId,
        "user_id": memberId,
        "member_name": memberName,
        "user_picture": userPicture,
        "shortcode": shortcode,
        "description": description,
        "privacy": privacy,
        "location": location,
        "type": type,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "video": video,
        "thumb": thumb,
        "poll_status": pollStatus,
        "poll_time": pollTime,
        "poll_question": pollQuestion,
        "poll_answer": List<PollDatum>.from(pollAnswer!.map((x) => x)),
        "gif_file": gifFile,
        "num_views": numViews,
        "follow_status": followStatus,
        "total_likes": totalLikes,
        "total_comments": totalComments,
        "like_status": likeStatus,
        "re_buzzerfeed_message": reBuzzerfeedMessage,
        "total_re_buzzerfeed": totalReBuzzerfeed,
        "re_buzzerfeed_status": reBuzzerfeedStatus!.value,
        "re_buzzerquote_status": reBuzzerquoteStatus!.value,
        "quotes": List<Quote>.from(quotes!.map((x) => x)),
        "time_stamp": timeStamp,
        // "is_voting":isvo
        "page": page,
      };
}

class Quote {
  Quote({
    this.buzzerfeedId,
    this.memberId,
    this.memberName,
    this.userPicture,
    this.shortcode,
    this.description,
    this.location,
    this.type,
    this.images,
    this.video,
    this.thumb,
    this.pollStatus,
    this.pollTime,
    this.pollQuestion,
    this.pollAnswer,
    this.gifFile,
    this.linkLink,
    // this.linkHeader,
    // this.linkDomain,
    this.linkImages,
    this.linkDesc,
    this.numViews,
    this.timeStamp,
  });

  String? buzzerfeedId;
  String? memberId;
  String? memberName;
  String? userPicture;
  String? shortcode;
  String? description;
  String? location;
  String? type;
  List<dynamic>? images;
  String? video;
  String? thumb;
  String? pollStatus;
  String? pollTime;
  String? pollQuestion;
  List<PollDatum>? pollAnswer;
  String? gifFile;
  List<dynamic>? linkLink;
  // List linkHeader;
  // List linkDomain;
  List<dynamic>? linkImages;
  List<dynamic>? linkDesc;
  String? numViews;
  String? timeStamp;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        buzzerfeedId: json["buzzerfeed_id"],
        memberId: json["user_id"],
        memberName: json["member_name"],
        userPicture: json["user_picture"],
        shortcode: json["shortcode"],
        description: json["description"],
        location: json["location"],
        type: json["type"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        video: json["video"],
        thumb: json["thumb"],
        pollStatus: json["poll_status"].toString(),
        pollTime: json["poll_time"],
        pollQuestion: json["poll_question"],
        pollAnswer: json["poll_answer"].length != 0
            ? List<PollDatum>.from(
                json["poll_answer"].map((x) => PollDatum.fromJson(x)))
            : [],
        gifFile: json["gif_file"],
        linkLink: List<dynamic>.from(json["link_link"].map((x) => x)),
        // linkHeader: List<dynamic>.from(json["link_header"].map((x) => x)),
        // linkDomain: List<dynamic>.from(json["link_domain"].map((x) => x)),
        linkImages: List<dynamic>.from(json["link_images"].map((x) => x)),
        linkDesc: List<dynamic>.from(json["link_desc"].map((x) => x)),
        numViews: json["num_views"],
        timeStamp: json["time_stamp"],
      );

  Map<String, dynamic> toJson() => {
        "buzzerfeed_id": buzzerfeedId,
        "user_id": memberId,
        "member_name": memberName,
        "user_picture": userPicture,
        "shortcode": shortcode,
        "description": description,
        "location": location,
        "type": type,
        "images": [],
        "video": video,
        "thumb": thumb,
        "poll_status": pollStatus,
        "poll_time": pollTime,
        "poll_question": pollQuestion,
        "poll_answer": List<PollDatum>.from(pollAnswer!.map((x) => x)),
        "gif_file": gifFile,
        "link_link": List<dynamic>.from(linkLink!.map((x) => x)),
        // "link_domain": List<dynamic>.from(linkDomain.map((x) => x)),
        // "link_header": List<dynamic>.from(linkHeader.map((x) => x)),/
        "link_images": List<dynamic>.from(linkImages!.map((x) => x)),
        "link_desc": List<dynamic>.from(linkDesc!.map((x) => x)),
        "num_views": numViews,
        "time_stamp": timeStamp,
      };
}
