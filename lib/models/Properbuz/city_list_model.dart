import 'dart:convert';

List<CityListModel> countryListModelFromJson(String str) =>
    List<CityListModel>.from(
        json.decode(str).map((x) => CityListModel.fromJson(x)));

class CityListModel {
  CityListModel({
    this.areaID,
    this.city,
  });
  String? areaID;
  String? city;

  factory CityListModel.fromJson(Map<String, dynamic> json) {
    return CityListModel(areaID: json['area_id'], city: json['area']);
  }
}

class CityList {
  List<CityListModel> citylist = [];
  CityList(this.citylist);
  factory CityList.fromJson(List<dynamic> parsed) {
    List<CityListModel> countrylist = <CityListModel>[];
    countrylist = parsed.map((e) => CityListModel.fromJson(e)).toList();
    return CityList(countrylist);
  }
}
