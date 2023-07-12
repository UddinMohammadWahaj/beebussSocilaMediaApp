class TradesmenCountryModel {
  String? countryId;
  String? country;

  TradesmenCountryModel({this.countryId, this.country});

  TradesmenCountryModel.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'] ?? "";
    country = json['country'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country'] = this.country;
    return data;
  }
}

class TradsmenWorkLocationModel {
  String? areaId;
  String? area;

  TradsmenWorkLocationModel({this.areaId, this.area});

  TradsmenWorkLocationModel.fromJson(Map<String, dynamic> json) {
    areaId = json['area_id'] ?? "";
    area = json['area'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area_id'] = this.areaId;
    data['area'] = this.area;
    return data;
  }
}
