class ShopSettingsModel {
  int? success;
  int? status;
  String? message;
  List<ShopSettingsModelCountry>? country;

  ShopSettingsModel({this.success, this.status, this.message, this.country});

  ShopSettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      country = <ShopSettingsModelCountry>[];
      json['data'].forEach((v) {
        country!.add(new ShopSettingsModelCountry.fromJson(v));
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

class ShopSettingsModelCountry {
  String? name;
  String? value;
  String? flagIcon;
  String? countryName;
  String? countryValue;
  String? flag;

  ShopSettingsModelCountry(
      {this.name,
      this.value,
      this.flagIcon,
      this.countryName,
      this.countryValue,
      this.flag});

  ShopSettingsModelCountry.fromJson(Map<String, dynamic> json) {
    flagIcon = json['flag_icon'];
    countryName = json['country_name'];
    countryValue = json['country_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['flag_icon'] = this.flagIcon;
    data['country_name'] = this.countryName;
    data['country_id'] = this.countryValue;

    return data;
  }
}
