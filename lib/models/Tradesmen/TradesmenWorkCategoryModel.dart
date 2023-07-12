class TradesmenWorkCategoryModel {
  String? tradeCatId;
  String? tradeCatName;

  TradesmenWorkCategoryModel({this.tradeCatId, this.tradeCatName});

  TradesmenWorkCategoryModel.fromJson(Map<String, dynamic> json) {
    tradeCatId = json['trade_cat_id'] ?? "";
    tradeCatName = json['trade_cat_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_cat_id'] = this.tradeCatId;
    data['trade_cat_name'] = this.tradeCatName;
    return data;
  }
}

class TradesmenWorkSubCatModel {
  String? tradeSubcatId;
  String? tradeSubcatName;

  TradesmenWorkSubCatModel({this.tradeSubcatId, this.tradeSubcatName});

  TradesmenWorkSubCatModel.fromJson(Map<String, dynamic> json) {
    tradeSubcatId = json['trade_subcat_id'] ?? "";
    tradeSubcatName = json['trade_subcat_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_subcat_id'] = this.tradeSubcatId;
    data['trade_subcat_name'] = this.tradeSubcatName;
    return data;
  }
}
