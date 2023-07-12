class Revenue {
  String? message;
  int? success;
  String? estimatedRevenue;
  int? rPM;
  List<GhaphEstimatedRevenue>? ghaphEstimatedRevenue;
  List<MonthEstimatedRevenue>? monthEstimatedRevenue;
  List<TopVideos>? topVideos;
  List<RevenueSources>? revenueSources;

  Revenue(
      {this.message,
      this.success,
      this.estimatedRevenue,
      this.rPM,
      this.ghaphEstimatedRevenue,
      this.monthEstimatedRevenue,
      this.topVideos,
      this.revenueSources});

  Revenue.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    estimatedRevenue = json['estimatedRevenue'];
    rPM = json['RPM'];
    if (json['ghaphEstimatedRevenue'] != null) {
      ghaphEstimatedRevenue = <GhaphEstimatedRevenue>[];
      json['ghaphEstimatedRevenue'].forEach((v) {
        ghaphEstimatedRevenue!.add(new GhaphEstimatedRevenue.fromJson(v));
      });
    }
    if (json['monthEstimatedRevenue'] != null) {
      monthEstimatedRevenue = <MonthEstimatedRevenue>[];
      json['monthEstimatedRevenue'].forEach((v) {
        monthEstimatedRevenue!.add(new MonthEstimatedRevenue.fromJson(v));
      });
    }
    if (json['topVideos'] != null) {
      topVideos = <TopVideos>[];
      json['topVideos'].forEach((v) {
        topVideos!.add(new TopVideos.fromJson(v));
      });
    }
    if (json['revenueSources'] != null) {
      revenueSources = <RevenueSources>[];
      json['revenueSources'].forEach((v) {
        revenueSources!.add(new RevenueSources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['estimatedRevenue'] = this.estimatedRevenue;
    data['RPM'] = this.rPM;
    if (this.ghaphEstimatedRevenue != null) {
      data['ghaphEstimatedRevenue'] =
          this.ghaphEstimatedRevenue!.map((v) => v.toJson()).toList();
    }
    if (this.monthEstimatedRevenue != null) {
      data['monthEstimatedRevenue'] =
          this.monthEstimatedRevenue!.map((v) => v.toJson()).toList();
    }
    if (this.topVideos != null) {
      data['topVideos'] = this.topVideos!.map((v) => v.toJson()).toList();
    }
    if (this.revenueSources != null) {
      data['revenueSources'] =
          this.revenueSources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GhaphEstimatedRevenue {
  String? date;
  String? value;
  DateTime? eData;

  GhaphEstimatedRevenue({this.date, this.value});

  GhaphEstimatedRevenue.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['value'] = this.value;
    return data;
  }
}

class MonthEstimatedRevenue {
  String? month;
  num? value;

  MonthEstimatedRevenue({this.month, this.value});

  MonthEstimatedRevenue.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['Value'] = this.value;
    return data;
  }
}

class TopVideos {
  String? postId;
  String? videoName;
  String? videoThumb;
  String? created;
  String? earning;

  TopVideos(
      {this.postId,
      this.videoName,
      this.videoThumb,
      this.created,
      this.earning});

  TopVideos.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    videoName = json['videoName'];
    videoThumb = json['videoThumb'];
    created = json['created'];
    earning = json['earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['videoName'] = this.videoName;
    data['videoThumb'] = this.videoThumb;
    data['created'] = this.created;
    data['earning'] = this.earning;
    return data;
  }
}

class RevenueSources {
  String? postId;
  String? videoName;
  String? earning;

  RevenueSources({this.postId, this.videoName, this.earning});

  RevenueSources.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    videoName = json['videoName'];
    earning = json['earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['videoName'] = this.videoName;
    data['earning'] = this.earning;
    return data;
  }
}
