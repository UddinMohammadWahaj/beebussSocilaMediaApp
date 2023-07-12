class ShortbuzzCategoryModel {
  int? success;
  int? status;
  String? message;
  List<ShortbuzzCategoryModelCategory>? category;

  ShortbuzzCategoryModel(
      {this.success, this.status, this.message, this.category});

  ShortbuzzCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['category'] != null) {
      category = <ShortbuzzCategoryModelCategory>[];
      json['category'].forEach((v) {
        category!.add(new ShortbuzzCategoryModelCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShortbuzzCategoryModelCategory {
  String? id;
  String? cateName;

  ShortbuzzCategoryModelCategory({this.id, this.cateName});

  ShortbuzzCategoryModelCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cateName = json['cate_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cate_name'] = this.cateName;
    return data;
  }
}
