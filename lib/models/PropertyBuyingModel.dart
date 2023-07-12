class PropertyBuyingModel {
  String? id;
  String? title;
  String? description;
  String? blogImage;
  String? blogThumb;
  String? blogType;
  String? addedBy;
  String? blogUser;
  String? addedDate;
  String? status;
  String? blogBaseURL;
  String? blogThumbURL;

  PropertyBuyingModel(
      {this.id,
      this.title,
      this.description,
      this.blogImage,
      this.blogThumb,
      this.blogType,
      this.addedBy,
      this.blogUser,
      this.blogBaseURL,
      this.blogThumbURL,
      this.addedDate,
      this.status});

  PropertyBuyingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    blogImage = json['blog_image'] ?? "";
    blogThumb = json['blog_thumb'] ?? "";
    blogType = json['blog_type'] ?? "";
    addedBy = json['added_by'] ?? "";
    blogUser = json['blog_user'] ?? "";
    addedDate = json['added_date'] ?? "";
    status = json['status'] ?? "";
    blogBaseURL = json['blog_image_base_url'] ?? "";
    blogThumbURL = json['blog_thumb_base_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['blog_image'] = this.blogImage;
    data['blog_thumb'] = this.blogThumb;
    data['blog_type'] = this.blogType;
    data['added_by'] = this.addedBy;
    data['blog_user'] = this.blogUser;
    data['added_date'] = this.addedDate;
    data['status'] = this.status;
    data['blog_image_base_url'] = this.blogBaseURL;
    data['blog_thumb_base_url'] = this.blogThumbURL;
    return data;
  }
}

// class PropertyBuyingModel {
//   int success;
//   List<Message> message;
//   int count;

//   PropertyBuyingModel({this.success, this.message, this.count});

//   PropertyBuyingModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'] ?? 0;
//     if (json['message'] != null) {
//       message = new List<Message>();
//       json['message'].forEach((v) {
//         message.add(new Message.fromJson(v));
//       });
//     }
//     count = json['count'] ?? 0;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.message != null) {
//       data['message'] = this.message.map((v) => v.toJson()).toList();
//     }
//     data['count'] = this.count;
//     return data;
//   }
// }

// class Message {
//   String id;
//   String title;
//   String description;
//   String blogImage;
//   String blogThumb;
//   String blogType;
//   String addedBy;
//   String blogUser;
//   String addedDate;
//   String status;

//   Message(
//       {this.id,
//       this.title,
//       this.description,
//       this.blogImage,
//       this.blogThumb,
//       this.blogType,
//       this.addedBy,
//       this.blogUser,
//       this.addedDate,
//       this.status});

//   Message.fromJson(Map<String, dynamic> json) {
//     id = json['id'] ?? "";
//     title = json['title'] ?? "";
//     description = json['description'] ?? "";
//     blogImage = json['blog_image'] ?? "";
//     blogThumb = json['blog_thumb'] ?? "";
//     blogType = json['blog_type'] ?? "";
//     addedBy = json['added_by'] ?? "";
//     blogUser = json['blog_user'] ?? "";
//     addedDate = json['added_date'] ?? "";
//     status = json['status'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['blog_image'] = this.blogImage;
//     data['blog_thumb'] = this.blogThumb;
//     data['blog_type'] = this.blogType;
//     data['added_by'] = this.addedBy;
//     data['blog_user'] = this.blogUser;
//     data['added_date'] = this.addedDate;
//     data['status'] = this.status;
//     return data;
//   }
// }
