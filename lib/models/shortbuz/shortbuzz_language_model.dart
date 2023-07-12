class ShortbuzzLanguageModel {
  int? success;
  int? status;
  String? message;
  List<ShortbuzzLanguageModelLanguage>? language;

  ShortbuzzLanguageModel(
      {this.success, this.status, this.message, this.language});

  ShortbuzzLanguageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['language'] != null) {
      language = <ShortbuzzLanguageModelLanguage>[];
      json['language'].forEach((v) {
        language!.add(new ShortbuzzLanguageModelLanguage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.language != null) {
      data['language'] = this.language!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShortbuzzLanguageModelLanguage {
  String? id;
  String? languageName;

  ShortbuzzLanguageModelLanguage({this.id, this.languageName});

  ShortbuzzLanguageModelLanguage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_name'] = this.languageName;
    return data;
  }
}
