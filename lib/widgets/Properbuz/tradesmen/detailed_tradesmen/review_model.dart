class ReviewDataListModel {
  int? success;
  int? status;
  String? message;
  ReviewData? data;

  ReviewDataListModel({this.success, this.status, this.message, this.data});

  ReviewDataListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = (json['data'] != null ? new ReviewData.fromJson(json['data']) : 0)
        as ReviewData?;
    // data = new ReviewData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReviewData {
  ReviewCount? reviewCount;
  List<ReviewList>? reviewList;

  ReviewData({this.reviewCount, this.reviewList});

  ReviewData.fromJson(Map<String, dynamic> json) {
    reviewCount = (json['review_count'] != null
        ? new ReviewCount.fromJson(json['review_count'])
        : 0) as ReviewCount?;
    // reviewCount = new ReviewCount.fromJson(json['review_count']);

    if (json['review_list'] != null) {
      reviewList = <ReviewList>[];
      json['review_list'].forEach((v) {
        reviewList!.add(new ReviewList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reviewCount != null) {
      data['review_count'] = this.reviewCount!.toJson();
    }
    if (this.reviewList != null) {
      data['review_list'] = this.reviewList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewCount {
  String? timeRate;
  String? workRate;
  String? satisfactionRate;
  String? serviceRate;
  String? totalRating;

  ReviewCount(
      {this.timeRate,
      this.workRate,
      this.satisfactionRate,
      this.serviceRate,
      this.totalRating});

  ReviewCount.fromJson(Map<String, dynamic> json) {
    timeRate = json['time_rate'];
    workRate = json['work_rate'];
    satisfactionRate = json['satisfaction_rate'];
    serviceRate = json['service_rate'];
    totalRating = json['total_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_rate'] = this.timeRate;
    data['work_rate'] = this.workRate;
    data['satisfaction_rate'] = this.satisfactionRate;
    data['service_rate'] = this.serviceRate;
    data['total_rating'] = this.totalRating;
    return data;
  }
}

class ReviewList {
  String? reviewId;
  String? review;
  String? memberId;
  String? memberName;
  String? timeRate;
  String? workRate;
  String? satisfactionRate;
  String? serviceRate;
  String? createdAt;

  ReviewList(
      {this.reviewId,
      this.review,
      this.memberId,
      this.memberName,
      this.timeRate,
      this.workRate,
      this.satisfactionRate,
      this.serviceRate,
      this.createdAt});

  ReviewList.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    review = json['review'];
    memberId = json['user_id'];
    memberName = json['member_name'];
    timeRate = json['time_rate'];
    workRate = json['work_rate'];
    satisfactionRate = json['satisfaction_rate'];
    serviceRate = json['service_rate'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review_id'] = this.reviewId;
    data['review'] = this.review;
    data['user_id'] = this.memberId;
    data['member_name'] = this.memberName;
    data['time_rate'] = this.timeRate;
    data['work_rate'] = this.workRate;
    data['satisfaction_rate'] = this.satisfactionRate;
    data['service_rate'] = this.serviceRate;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class SearchTradesmenModel {
  int? success;
  int? status;
  String? message;
  List<searchTradesmenData>? data;

  SearchTradesmenModel({this.success, this.status, this.message, this.data});

  SearchTradesmenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <searchTradesmenData>[];
      json['data'].forEach((v) {
        data!.add(new searchTradesmenData.fromJson(v));
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

class searchTradesmenData {
  String? tradesmanId;
  String? companyId;
  String? type;
  String? fullName;
  String? email;
  String? mobile;
  String? atMobile;
  String? profile;
  String? logo;
  String? coverPic;
  String? experience;
  String? countryId;
  String? location;
  String? category;
  String? subcategory;
  String? workArea;
  String? details;
  String? workType;
  String? callOutHours;
  String? publicLibility;
  String? workUndertaken;
  String? latitude;
  String? longitude;
  String? status;
  String? createdAt;

  searchTradesmenData(
      {this.tradesmanId,
      this.companyId,
      this.type,
      this.fullName,
      this.email,
      this.mobile,
      this.atMobile,
      this.profile,
      this.logo,
      this.coverPic,
      this.experience,
      this.countryId,
      this.location,
      this.category,
      this.subcategory,
      this.workArea,
      this.details,
      this.workType,
      this.callOutHours,
      this.publicLibility,
      this.workUndertaken,
      this.latitude,
      this.longitude,
      this.status,
      this.createdAt});

  searchTradesmenData.fromJson(Map<String, dynamic> json) {
    tradesmanId = json['tradesman_id'];
    companyId = json['company_id'];
    type = json['type'];
    fullName = json['full_name'];
    email = json['email'];
    mobile = json['mobile'];
    atMobile = json['at_mobile'];
    profile = json['profile'];
    logo = json['logo'];
    coverPic = json['cover_pic'];
    experience = json['experience'];
    countryId = json['country_id'];
    location = json['location'];
    category = json['category'];
    subcategory = json['subcategory'];
    workArea = json['work_area'];
    details = json['details'];
    workType = json['work_type'];
    callOutHours = json['call_out_hours'];
    publicLibility = json['public_libility'];
    workUndertaken = json['work_undertaken'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tradesman_id'] = this.tradesmanId;
    data['company_id'] = this.companyId;
    data['type'] = this.type;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['at_mobile'] = this.atMobile;
    data['profile'] = this.profile;
    data['logo'] = this.logo;
    data['cover_pic'] = this.coverPic;
    data['experience'] = this.experience;
    data['country_id'] = this.countryId;
    data['location'] = this.location;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['work_area'] = this.workArea;
    data['details'] = this.details;
    data['work_type'] = this.workType;
    data['call_out_hours'] = this.callOutHours;
    data['public_libility'] = this.publicLibility;
    data['work_undertaken'] = this.workUndertaken;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class serviceDataModel {
  int? success;
  int? status;
  String? message;
  List<serviceData>? data;

  serviceDataModel({this.success, this.status, this.message, this.data});

  serviceDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <serviceData>[];
      json['data'].forEach((v) {
        data!.add(new serviceData.fromJson(v));
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

class serviceData {
  String? category;
  List<String>? subcategory;

  serviceData({this.category, this.subcategory});

  serviceData.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    subcategory = json['subcategory'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    return data;
  }
}

class AlbumListModel {
  int? success;
  int? status;
  String? message;
  List<AlbumData>? data;

  AlbumListModel({this.success, this.status, this.message, this.data});

  AlbumListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AlbumData>[];
      json['data'].forEach((v) {
        data!.add(new AlbumData.fromJson(v));
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

class AlbumData {
  String? albumId;
  String? albumName;
  String? albumPic;
  List<String>? albumImage;
  int? totalImage;

  AlbumData(
      {this.albumId,
      this.albumName,
      this.albumPic,
      this.albumImage,
      this.totalImage});

  AlbumData.fromJson(Map<String, dynamic> json) {
    albumId = json['album_id'];
    albumName = json['album_name'];
    albumPic = json['album_pic'];
    albumImage = json['album_image'].cast<String>();
    totalImage = json['total_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album_id'] = this.albumId;
    data['album_name'] = this.albumName;
    data['album_pic'] = this.albumPic;
    data['album_image'] = this.albumImage;
    data['total_image'] = this.totalImage;
    return data;
  }
}

class enquiryListDataModel {
  int? success;
  int? status;
  String? message;
  List<enquiryData>? data;

  enquiryListDataModel({this.success, this.status, this.message, this.data});

  enquiryListDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <enquiryData>[];
      json['data'].forEach((v) {
        data!.add(new enquiryData.fromJson(v));
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

class enquiryData {
  String? enquiryId;
  String? name;
  String? mobile;
  String? memberId;
  String? memberName;
  bool? isRead;
  String? createdAt;

  enquiryData(
      {this.enquiryId,
      this.name,
      this.mobile,
      this.memberId,
      this.memberName,
      this.isRead,
      this.createdAt});

  enquiryData.fromJson(Map<String, dynamic> json) {
    enquiryId = json['enquiry_id'];
    name = json['name'];
    mobile = json['mobile'];
    memberId = json['user_id'];
    memberName = json['member_name'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enquiry_id'] = this.enquiryId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['user_id'] = this.memberId;
    data['member_name'] = this.memberName;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class RequestedListModel {
  int? success;
  int? status;
  String? message;
  List<RequestedData>? data;

  RequestedListModel({this.success, this.status, this.message, this.data});

  RequestedListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RequestedData>[];
      json['data'].forEach((v) {
        data!.add(new RequestedData.fromJson(v));
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

class RequestedData {
  String? tradesmanId;
  String? companyId;
  String? type;
  String? fullName;
  String? email;
  String? mobile;
  String? profile;
  String? logo;
  String? coverPic;
  String? status;
  String? createdAt;
  int? totalRequest;

  RequestedData(
      {this.tradesmanId,
      this.companyId,
      this.type,
      this.fullName,
      this.email,
      this.mobile,
      this.profile,
      this.logo,
      this.coverPic,
      this.status,
      this.createdAt,
      this.totalRequest});

  RequestedData.fromJson(Map<String, dynamic> json) {
    tradesmanId = json['tradesman_id'];
    companyId = json['company_id'];
    type = json['type'];
    fullName = json['full_name'];
    email = json['email'];
    mobile = json['mobile'];
    profile = json['profile'];
    logo = json['logo'];
    coverPic = json['cover_pic'];
    status = json['status'];
    createdAt = json['created_at'];
    totalRequest = json['total_request'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tradesman_id'] = this.tradesmanId;
    data['company_id'] = this.companyId;
    data['type'] = this.type;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['profile'] = this.profile;
    data['logo'] = this.logo;
    data['cover_pic'] = this.coverPic;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['total_request'] = this.totalRequest;
    return data;
  }
}
