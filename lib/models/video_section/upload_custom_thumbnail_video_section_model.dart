class UploadCustomThumbnailVideoSectionModel {
  int? success;
  int? status;
  String? message;
  UploadCustomThumbnailVideoSectionModelData? data;

  UploadCustomThumbnailVideoSectionModel(
      {this.success, this.status, this.message, this.data});

  UploadCustomThumbnailVideoSectionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new UploadCustomThumbnailVideoSectionModelData.fromJson(json['data'])
        : null;
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

class UploadCustomThumbnailVideoSectionModelData {
  String? video;
  String? imageOne;
  String? imageTwo;
  String? imageThree;

  UploadCustomThumbnailVideoSectionModelData(
      {this.video, this.imageOne, this.imageTwo, this.imageThree});

  UploadCustomThumbnailVideoSectionModelData.fromJson(
      Map<String, dynamic> json) {
    video = json['video'];
    imageOne = json['image_one'];
    imageTwo = json['image_two'];
    imageThree = json['image_three'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video'] = this.video;
    data['image_one'] = this.imageOne;
    data['image_two'] = this.imageTwo;
    data['image_three'] = this.imageThree;
    return data;
  }
}
