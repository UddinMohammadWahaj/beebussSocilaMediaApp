class VideoSectionTopSliderModel {
  int? success;
  int? status;
  String? message;
  List<VideoSectionTopSliderModelCategory>? category;

  VideoSectionTopSliderModel(
      {this.success, this.status, this.message, this.category});

  VideoSectionTopSliderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      category = <VideoSectionTopSliderModelCategory>[];
      json['data'].forEach((v) {
        category!.add(new VideoSectionTopSliderModelCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.category != null) {
      data['data'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoSectionTopSliderModelCategory {
  String? id;
  String? cateName;
  String? cateNameIt;
  String? cateImage;

  VideoSectionTopSliderModelCategory(
      {this.id, this.cateName, this.cateNameIt, this.cateImage});

  VideoSectionTopSliderModelCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    cateName = json['cate_name'];
    cateNameIt = json['cate_name_it'];
    cateImage = json['cate_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cate_name'] = this.cateName;
    data['cate_name_it'] = this.cateNameIt;
    data['cate_image'] = this.cateImage;
    return data;
  }
}
