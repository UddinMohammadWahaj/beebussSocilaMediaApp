class ShortbuzzCountryModel {
  int? success;
  int? status;
  String? message;
  List<ShortbuzzCountryModelCountry>? country;

  ShortbuzzCountryModel(
      {this.success, this.status, this.message, this.country});

  ShortbuzzCountryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['country'] != null) {
      country = <ShortbuzzCountryModelCountry>[];
      json['country'].forEach((v) {
        country!.add(new ShortbuzzCountryModelCountry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShortbuzzCountryModelCountry {
  String? id;
  String? countryName;

  ShortbuzzCountryModelCountry({this.id, this.countryName});

  ShortbuzzCountryModelCountry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    return data;
  }
}
