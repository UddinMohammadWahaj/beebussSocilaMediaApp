import 'dart:math';

import 'package:flutter/material.dart';

final _random = Random();

class SeeMoreAllData {
  late String message;
  late num success;
  late List<GraphData> graphData;
  late num totalRevenue;
  late String totalViews;
  late String totalTime;
  late List<VideoData> videoData;
  late List<TrafficData> trafficData;
  late List<GeographyData> geographyData;
  late List<ViewerGender> viewerGender;
  late String watchHours;
  late List<ViewerAge> viewerAge;
  late String watchTimeHours;
  late String estimatdRevenue;
  late List<DateData> dateData;
  late String watchTime;
  late List<Playlist> playlist;
  late List<Devices> devices;

  SeeMoreAllData({
    required this.message,
    required this.success,
    required this.graphData,
    required this.totalRevenue,
    required this.totalViews,
    required this.totalTime,
    required this.videoData,
    required this.trafficData,
    required this.geographyData,
    required this.viewerGender,
    required this.watchHours,
    required this.viewerAge,
    required this.watchTimeHours,
    required this.estimatdRevenue,
    required this.dateData,
    required this.watchTime,
    required this.playlist,
    required this.devices,
  });

  SeeMoreAllData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['graphData'] != null) {
      graphData = <GraphData>[];
      json['graphData'].forEach((v) {
        graphData.add(new GraphData.fromJson(v));
      });
    }
    totalRevenue = json['totalRevenue'];
    totalViews = json['totalViews'].toString();
    totalTime = json['totalTime'].toString();
    if (json['videoData'] != null) {
      videoData = <VideoData>[];
      json['videoData'].forEach((v) {
        videoData.add(new VideoData.fromJson(v));
      });
    }
    if (json['trafficData'] != null) {
      trafficData = <TrafficData>[];
      json['trafficData'].forEach((v) {
        trafficData.add(new TrafficData.fromJson(v));
      });
    }
    if (json['geographyData'] != null) {
      geographyData = <GeographyData>[];
      json['geographyData'].forEach((v) {
        geographyData.add(new GeographyData.fromJson(v));
      });
    }
    if (json['viewerGender'] != null) {
      viewerGender = <ViewerGender>[];
      json['viewerGender'].forEach((v) {
        viewerGender.add(new ViewerGender.fromJson(v));
      });
    }
    watchHours = json['watchHours'];

    if (json['viewerAge'] != null) {
      viewerAge = <ViewerAge>[];
      json['viewerAge'].forEach((v) {
        viewerAge.add(new ViewerAge.fromJson(v));
      });
    }
    watchTimeHours = json['watchTimeHours'];
    estimatdRevenue = json['estimatdRevenue'];
    if (json['dateData'] != null) {
      dateData = <DateData>[];
      json['dateData'].forEach((v) {
        dateData.add(new DateData.fromJson(v));
      });
    }
    watchTime = json['watchTime'];
    if (json['Playlist'] != null) {
      playlist = <Playlist>[];
      json['Playlist'].forEach((v) {
        playlist.add(new Playlist.fromJson(v));
      });
    }
    if (json['deviceType'] != null) {
      devices = <Devices>[];
      json['deviceType'].forEach((v) {
        devices.add(new Devices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.graphData != null) {
      data['graphData'] = this.graphData.map((v) => v.toJson()).toList();
    }
    data['totalRevenue'] = this.totalRevenue;
    data['totalViews'] = this.totalViews;
    data['totalTime'] = this.totalTime;
    if (this.videoData != null) {
      data['videoData'] = this.videoData.map((v) => v.toJson()).toList();
    }
    if (this.trafficData != null) {
      data['trafficData'] = this.trafficData.map((v) => v.toJson()).toList();
    }
    if (this.geographyData != null) {
      data['geographyData'] =
          this.geographyData.map((v) => v.toJson()).toList();
    }
    if (this.viewerGender != null) {
      data['viewerGender'] = this.viewerGender.map((v) => v.toJson()).toList();
    }
    data['watchHours'] = this.watchHours;
    if (this.viewerAge != null) {
      data['viewerAge'] = this.viewerAge.map((v) => v.toJson()).toList();
    }
    data['watchTimeHours'] = this.watchTimeHours;
    data['estimatdRevenue'] = this.estimatdRevenue;
    if (this.dateData != null) {
      data['dateData'] = this.dateData.map((v) => v.toJson()).toList();
    }
    data['watchTime'] = this.watchTime;
    if (this.playlist != null) {
      data['Playlist'] = this.playlist.map((v) => v.toJson()).toList();
    }
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GraphData {
  num? value;
  String? date;
  String? platform;
  Color? barColor;

  GraphData({this.value, this.date, this.platform});

  GraphData.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    date = json['Date'];
    platform = json['Platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Date'] = this.date;
    data['Platform'] = this.platform;
    return data;
  }
}

class VideoData {
  String? postId;
  String? videoTitle;
  String? totalViews;
  String? totalViewsPercent;
  String? totalTime;
  String? totalTimePercent;
  String? totalRevenue;
  String? totalRevenuePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  VideoData({
    this.postId,
    this.videoTitle,
    this.totalViews,
    this.totalViewsPercent,
    this.totalTime,
    this.totalTimePercent,
    this.totalRevenue,
    this.totalRevenuePercent,
  });

  VideoData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    videoTitle = json['video_title'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    totalTime = json['total_time'];
    totalTimePercent = json['total_time_percent'];
    totalRevenue = json['total_revenue'];
    totalRevenuePercent = json['total_revenue_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['video_title'] = this.videoTitle;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['total_time'] = this.totalTime;
    data['total_time_percent'] = this.totalTimePercent;
    data['total_revenue'] = this.totalRevenue;
    data['total_revenue_percent'] = this.totalRevenuePercent;
    return data;
  }
}

class TrafficData {
  String? postId;
  String? trafficVal;
  String? videoTitle;
  String? totalViews;
  String? totalViewsPercent;
  String? totalTime;
  String? totalTimePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  TrafficData(
      {this.postId,
      this.trafficVal,
      this.videoTitle,
      this.totalViews,
      this.totalViewsPercent,
      this.totalTime,
      this.totalTimePercent});

  TrafficData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    trafficVal = json['traffic_val'];
    videoTitle = json['video_title'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    totalTime = json['total_time'];
    totalTimePercent = json['total_time_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['traffic_val'] = this.trafficVal;
    data['video_title'] = this.videoTitle;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['total_time'] = this.totalTime;
    data['total_time_percent'] = this.totalTimePercent;
    return data;
  }
}

class GeographyData {
  String? postId;
  String? countryName;
  String? totalViews;
  String? totalViewsPercent;
  String? totalTime;
  String? totalTimePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  GeographyData(
      {this.postId,
      this.countryName,
      this.totalViews,
      this.totalViewsPercent,
      this.totalTime,
      this.totalTimePercent});

  GeographyData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    countryName = json['country_name'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    totalTime = json['total_time'];
    totalTimePercent = json['total_time_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['country_name'] = this.countryName;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['total_time'] = this.totalTime;
    data['total_time_percent'] = this.totalTimePercent;
    return data;
  }
}

class ViewerGender {
  String? viewerAge;
  int? totalViews;
  String? totalViewsPercent;
  String? watchTime;
  String? watchTimePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  ViewerGender(
      {this.viewerAge,
      this.totalViews,
      this.totalViewsPercent,
      this.watchTime,
      this.watchTimePercent});

  ViewerGender.fromJson(Map<String, dynamic> json) {
    viewerAge = json['viewer_age'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    watchTime = json['watch_time'];
    watchTimePercent = json['watch_time_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['viewer_age'] = this.viewerAge;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['watch_time'] = this.watchTime;
    data['watch_time_percent'] = this.watchTimePercent;
    return data;
  }
}

class ViewerAge {
  String? viewerAge;
  int? totalViews;
  String? totalViewsPercent;
  String? watchTime;
  String? watchTimePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  ViewerAge(
      {this.viewerAge,
      this.totalViews,
      this.totalViewsPercent,
      this.watchTime,
      this.watchTimePercent});

  ViewerAge.fromJson(Map<String, dynamic> json) {
    viewerAge = json['viewer_age'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    watchTime = json['watch_time'];
    watchTimePercent = json['watch_time_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['viewer_age'] = this.viewerAge;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['watch_time'] = this.watchTime;
    data['watch_time_percent'] = this.watchTimePercent;
    return data;
  }
}

class DateData {
  String? date;
  String? totalViews;
  String? totalViewsPercent;
  String? watchTime;
  String? watchTimePercent;
  String? estimatedRevenue;
  String? estimatedRevenuePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  DateData(
      {this.date,
      this.totalViews,
      this.totalViewsPercent,
      this.watchTime,
      this.watchTimePercent,
      this.estimatedRevenue,
      this.estimatedRevenuePercent});

  DateData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    watchTime = json['watch_time'];
    watchTimePercent = json['watch_time_percent'];
    estimatedRevenue = json['estimated_revenue'];
    estimatedRevenuePercent = json['estimated_revenue_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['watch_time'] = this.watchTime;
    data['watch_time_percent'] = this.watchTimePercent;
    data['estimated_revenue'] = this.estimatedRevenue;
    data['estimated_revenue_percent'] = this.estimatedRevenuePercent;
    return data;
  }
}

class Playlist {
  String? playlistId;
  String? playlistTitle;
  String? totalViews;
  String? totalViewsPercent;
  String? watchTime;
  String? watchTimePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  Playlist(
      {this.playlistId,
      this.playlistTitle,
      this.totalViews,
      this.totalViewsPercent,
      this.watchTime,
      this.watchTimePercent});

  Playlist.fromJson(Map<String, dynamic> json) {
    playlistId = json['playlist_id'];
    playlistTitle = json['playlist_title'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    watchTime = json['watch_time'];
    watchTimePercent = json['watch_time_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playlist_id'] = this.playlistId;
    data['playlist_title'] = this.playlistTitle;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['watch_time'] = this.watchTime;
    data['watch_time_percent'] = this.watchTimePercent;
    return data;
  }
}

class Devices {
  String? postId;
  String? deviceType;
  String? totalViews;
  String? totalViewsPercent;
  String? watchTime;
  String? watchTimePercent;
  Color? barColor = Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(9) * 100];

  Devices(
      {this.postId,
      this.deviceType,
      this.totalViews,
      this.totalViewsPercent,
      this.watchTime,
      this.watchTimePercent});

  Devices.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    deviceType = json['device_type'];
    totalViews = json['total_views'];
    totalViewsPercent = json['total_views_percent'];
    watchTime = json['watch_time'];
    watchTimePercent = json['watch_time_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['device_type'] = this.deviceType;
    data['total_views'] = this.totalViews;
    data['total_views_percent'] = this.totalViewsPercent;
    data['watch_time'] = this.watchTime;
    data['watch_time_percent'] = this.watchTimePercent;
    return data;
  }
}
