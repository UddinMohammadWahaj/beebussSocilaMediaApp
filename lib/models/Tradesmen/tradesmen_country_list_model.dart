class TradesmenCountryListModel {
  int? success;
  int? status;
  String? message;
  List<TradesCountry>? country;

  TradesmenCountryListModel(
      {this.success, this.status, this.message, this.country});

  TradesmenCountryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      country = <TradesCountry>[];
      json['data'].forEach((v) {
        country!.add(new TradesCountry.fromJson(v));
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

class TradesCountry {
  String? countryId;
  String? country;

  TradesCountry({this.countryId, this.country});

  TradesCountry.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country'] = this.country;
    return data;
  }
}
