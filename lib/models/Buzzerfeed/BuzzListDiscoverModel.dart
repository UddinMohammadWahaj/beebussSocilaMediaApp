import 'package:get/get_rx/src/rx_types/rx_types.dart';

class BuzzListDisover {
  int? success;
  int? status;
  String? message;
  List<Data>? data;

  BuzzListDisover({this.success, this.status, this.message, this.data});

  BuzzListDisover.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? listId;
  String? memberId;
  String? memberName;
  String? userPicture;
  String? shortcode;
  String? name;
  String? description;
  String? privacy;
  String? images;
  String? totalMember;
  String? totalFollow;
  int? followStatus;
  String? timeStamp;
  int? page;
  RxBool? isFollowing;

  Data(
      {this.listId,
      this.memberId,
      this.memberName,
      this.userPicture,
      this.shortcode,
      this.name,
      this.description,
      this.privacy,
      this.images,
      this.totalMember,
      this.totalFollow,
      this.followStatus,
      this.timeStamp,
      this.isFollowing,
      this.page});

  Data.fromJson(Map<String, dynamic> json) {
    listId = json['list_id'];
    memberId = json['user_id'];
    memberName = json['member_name'];
    userPicture = json['user_picture'];
    shortcode = json['shortcode'];
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    images = json['images'];
    totalMember = json['total_member'];
    totalFollow = json['total_follow'];
    followStatus = json['follow_status'];
    timeStamp = json['time_stamp'];
    page = json['page'];
    isFollowing = json['follow_status'] == 0 ? false.obs : true.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_id'] = this.listId;
    data['user_id'] = this.memberId;
    data['member_name'] = this.memberName;
    data['user_picture'] = this.userPicture;
    data['shortcode'] = this.shortcode;
    data['name'] = this.name;
    data['description'] = this.description;
    data['privacy'] = this.privacy;
    data['images'] = this.images;
    data['total_member'] = this.totalMember;
    data['total_follow'] = this.totalFollow;
    data['follow_status'] = this.followStatus;
    data['time_stamp'] = this.timeStamp;
    data['page'] = this.page;
    return data;
  }
}

class BuzzListDiscoverList {
  List<Data> buzzlist;
  BuzzListDiscoverList(this.buzzlist);
// ignore: empty_constructor_bodies
  factory BuzzListDiscoverList.fromJson(List<dynamic> parsed) {
    List<Data> datalist = parsed.map((e) => Data.fromJson(e)).toList();
    return BuzzListDiscoverList(datalist);
  }
}
