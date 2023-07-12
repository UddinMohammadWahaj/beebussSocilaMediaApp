class OverViewData {
  String? message;
  int? success;
  num? views;
  List<OverViewGraphData>? graphViews;
  String? watchTime;
  List<OverViewGraphData>? graphWatchTime;
  num? followers;
  List<OverViewGraphData>? graphFollowers;
  num? revenue;
  List<OverViewGraphData>? graphRevenue;
  List<TopVideo>? topVideo;

  OverViewData(
      {this.message,
      this.success,
      this.views,
      this.graphViews,
      this.watchTime,
      this.graphWatchTime,
      this.followers,
      this.graphFollowers,
      this.revenue,
      this.graphRevenue,
      this.topVideo});

  OverViewData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    views = num.parse(json['views'].toString());
    if (json['graphViews'] != null) {
      graphViews = <OverViewGraphData>[];
      json['graphViews'].forEach((v) {
        graphViews!.add(new OverViewGraphData.fromJson(v));
      });
    }
    watchTime = json['watchTime'];
    if (json['graphWatchTime'] != null) {
      graphWatchTime = <OverViewGraphData>[];
      json['graphWatchTime'].forEach((v) {
        graphWatchTime!.add(new OverViewGraphData.fromJson(v));
      });
    }
    followers = json['followers'];
    if (json['graphFollowers'] != null) {
      graphFollowers = <OverViewGraphData>[];
      json['graphFollowers'].forEach((v) {
        graphFollowers!.add(new OverViewGraphData.fromJson(v));
      });
    }
    revenue = json['revenue'];
    if (json['graphRevenue'] != null) {
      graphRevenue = <OverViewGraphData>[];
      json['graphRevenue'].forEach((v) {
        graphRevenue!.add(new OverViewGraphData.fromJson(v));
      });
    }
    if (json['topVideo'] != null) {
      topVideo = <TopVideo>[];
      json['topVideo'].forEach((v) {
        topVideo!.add(new TopVideo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['views'] = this.views;
    if (this.graphViews != null) {
      data['graphViews'] = this.graphViews!.map((v) => v.toJson()).toList();
    }
    data['watchTime'] = this.watchTime;
    if (this.graphWatchTime != null) {
      data['graphWatchTime'] =
          this.graphWatchTime!.map((v) => v.toJson()).toList();
    }
    data['followers'] = this.followers;
    if (this.graphFollowers != null) {
      data['graphFollowers'] =
          this.graphFollowers!.map((v) => v.toJson()).toList();
    }
    data['revenue'] = this.revenue;
    if (this.graphRevenue != null) {
      data['graphRevenue'] = this.graphRevenue!.map((v) => v.toJson()).toList();
    }
    if (this.topVideo != null) {
      data['topVideo'] = this.topVideo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OverViewGraphData {
  String? value;
  String? date;

  OverViewGraphData({this.value, this.date});

  OverViewGraphData.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Date'] = this.date;
    return data;
  }
}

class TopVideo {
  String? postId;
  String? videoTitle;
  String? videoVideo;
  String? videoCreated;
  String? totalTime;
  String? totalPer;
  String? totalViews;

  TopVideo(
      {this.postId,
      this.videoTitle,
      this.videoVideo,
      this.videoCreated,
      this.totalTime,
      this.totalPer,
      this.totalViews});

  TopVideo.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    videoTitle = json['video_title'];
    videoVideo = json['video_video'];
    videoCreated = json['video_created'];
    totalTime = json['total_time'];
    totalPer = json['total_per'];
    totalViews = json['total_views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['video_title'] = this.videoTitle;
    data['video_video'] = this.videoVideo;
    data['video_created'] = this.videoCreated;
    data['total_time'] = this.totalTime;
    data['total_per'] = this.totalPer;
    data['total_views'] = this.totalViews;
    return data;
  }
}
