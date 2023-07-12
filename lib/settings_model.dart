class SettingsModel {
  late int? success;
  late int? status;
  late String? message;
  late List<SettingsModelCountry>? country;

  SettingsModel({this.success, this.status, this.message, this.country});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      country = <SettingsModelCountry>[];
      json['data'].forEach((v) {
        country!.add(new SettingsModelCountry.fromJson(v));
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

class SettingsModelCountry {
  late String name;
  late String value;
  late String flagIcon;
  late String countryName;
  late String countryValue;
  late String flag;

  SettingsModelCountry(
      {required this.name,
      required this.value,
      required this.flagIcon,
      required this.countryName,
      required this.countryValue,
      required this.flag});

  SettingsModelCountry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    flagIcon = json['flagIcon'];
    countryName = json['countryName'];
    countryValue = json['countryValue'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    data['flagIcon'] = this.flagIcon;
    data['countryName'] = this.countryName;
    data['countryValue'] = this.countryValue;
    data['flag'] = this.flag;
    return data;
  }
}
