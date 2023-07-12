class TradesmenSubCatModel {
  int? success;
  int? status;
  String? message;
  List<TradesmenSubCatModelWorkSubCategory>? workSubCategory;

  TradesmenSubCatModel(
      {this.success, this.status, this.message, this.workSubCategory});

  TradesmenSubCatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      workSubCategory = <TradesmenSubCatModelWorkSubCategory>[];
      json['data'].forEach((v) {
        workSubCategory!
            .add(new TradesmenSubCatModelWorkSubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.workSubCategory != null) {
      data['work_sub_category'] =
          this.workSubCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TradesmenSubCatModelWorkSubCategory {
  String? tradeSubcatId;
  String? tradeSubcatName;

  TradesmenSubCatModelWorkSubCategory(
      {this.tradeSubcatId, this.tradeSubcatName});

  TradesmenSubCatModelWorkSubCategory.fromJson(Map<String, dynamic> json) {
    tradeSubcatId = json['trade_subcat_id'].toString();
    tradeSubcatName = json['trade_subcat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_subcat_id'] = this.tradeSubcatId.toString();
    data['trade_subcat_name'] = this.tradeSubcatName.toString();
    return data;
  }
}
