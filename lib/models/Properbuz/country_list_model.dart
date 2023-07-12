import 'dart:convert';

List<CountryListModel> countryListModelFromJson(String str) =>
    List<CountryListModel>.from(
        json.decode(str).map((x) => CountryListModel.fromJson(x)));

class CountryListModel {
  CountryListModel({
    this.countryID,
    this.country,
  });
  String? countryID;
  String? country;

  factory CountryListModel.fromJson(Map<String, dynamic> json) {
    return CountryListModel(
        countryID: json['country_id'], country: json['country']);
  }
}

class CountryList {
  List<CountryListModel> countrylist = [];
  CountryList(this.countrylist);
  factory CountryList.fromJson(List<dynamic> parsed) {
    List<CountryListModel> countrylist = <CountryListModel>[];
    countrylist = parsed.map((e) => CountryListModel.fromJson(e)).toList();
    return CountryList(countrylist);
  }
}
