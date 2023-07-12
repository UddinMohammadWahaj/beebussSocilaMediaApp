class TradesmensWorkCategoryModel {
  int? success;
  int? status;
  String? message;
  List<WorkCategory>? workCategory;

  TradesmensWorkCategoryModel(
      {this.success, this.status, this.message, this.workCategory});

  TradesmensWorkCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      workCategory = <WorkCategory>[];
      json['data'].forEach((v) {
        workCategory!.add(new WorkCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.workCategory != null) {
      data['work_category'] =
          this.workCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkCategory {
  String? tradeCatId;
  String? tradeCatName;

  WorkCategory({this.tradeCatId, this.tradeCatName});

  WorkCategory.fromJson(Map<String, dynamic> json) {
    tradeCatId = json['trade_cat_id'].toString();
    tradeCatName = json['trade_cat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_cat_id'] = this.tradeCatId;
    data['trade_cat_name'] = this.tradeCatName;
    return data;
  }
}

// class TradesMan {

class TradesMan {
  int? success;
  int? status;
  String? message;
  List<Data1>? data1;

  TradesMan({this.success, this.status, this.message, this.data1});

  TradesMan.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data1 = <Data1>[];
      json['data'].forEach((v) {
        data1!.add(new Data1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data1 != null) {
      data['data'] = this.data1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data1 {
  String? tradesmanId;
  String? companyName;
  String? zipCode;
  String? managerName;
  String? houseName;

  Data1(
      {this.tradesmanId,
      this.companyName,
      this.zipCode,
      this.managerName,
      this.houseName});

  Data1.fromJson(Map<String, dynamic> json) {
    tradesmanId = json['tradesman_id'];
    companyName = json['company_name'];
    zipCode = json['zip_code'];
    managerName = json['manager_name'];
    houseName = json['house_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tradesman_id'] = this.tradesmanId;
    data['company_name'] = this.companyName;
    data['zip_code'] = this.zipCode;
    data['manager_name'] = this.managerName;
    data['house_name'] = this.houseName;
    return data;
  }
}

class ExistingCompany {
  int? success;
  int? status;
  String? message;
  List<DataCompany>? data;

  ExistingCompany({this.success, this.status, this.message, this.data});

  ExistingCompany.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataCompany>[];
      json['data'].forEach((v) {
        data!.add(new DataCompany.fromJson(v));
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

class DataCompany {
  String? companyId;
  String? name;
  String? email;
  String? mobile;
  String? logo;
  String? coverPic;
  String? managerName;
  String? managerMobile;
  String? website;
  String? countryId;
  String? location;
  String? workArea;
  String? details;
  String? status;
  String? createdAt;

  DataCompany(
      {this.companyId,
      this.name,
      this.email,
      this.mobile,
      this.logo,
      this.coverPic,
      this.managerName,
      this.managerMobile,
      this.website,
      this.countryId,
      this.location,
      this.workArea,
      this.details,
      this.status,
      this.createdAt});

  DataCompany.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    logo = json['logo'];
    coverPic = json['cover_pic'];
    managerName = json['manager_name'];
    managerMobile = json['manager_mobile'];
    website = json['website'];
    countryId = json['country_id'];
    location = json['location'];
    workArea = json['work_area'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['logo'] = this.logo;
    data['cover_pic'] = this.coverPic;
    data['manager_name'] = this.managerName;
    data['manager_mobile'] = this.managerMobile;
    data['website'] = this.website;
    data['country_id'] = this.countryId;
    data['location'] = this.location;
    data['work_area'] = this.workArea;
    data['details'] = this.details;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ManageTradesmen {
  int? success;
  int? status;
  String? message;
  List<ManageData>? data;

  ManageTradesmen({this.success, this.status, this.message, this.data});

  ManageTradesmen.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ManageData>[];
      json['data'].forEach((v) {
        data!.add(new ManageData.fromJson(v));
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

class ManageData {
  String? tradesmanId;
  String? type;
  String? fullName;
  String? email;
  String? mobile;
  String? atMobile;
  String? profile;
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
  String? status;
  String? createdAt;

  ManageData(
      {this.tradesmanId,
      this.type,
      this.fullName,
      this.email,
      this.mobile,
      this.atMobile,
      this.profile,
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
      this.status,
      this.createdAt});

  ManageData.fromJson(Map<String, dynamic> json) {
    tradesmanId = json['tradesman_id'];
    type = json['type'];
    fullName = json['full_name'];
    email = json['email'];
    mobile = json['mobile'];
    atMobile = json['at_mobile'];
    profile = json['profile'];
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
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tradesman_id'] = this.tradesmanId;
    data['type'] = this.type;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['at_mobile'] = this.atMobile;
    data['profile'] = this.profile;
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
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
