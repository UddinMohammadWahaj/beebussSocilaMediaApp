import 'dart:convert';

List<PopularOverviewModel> popularoverviewFromJson(String str) =>
    List<PopularOverviewModel>.from(
        json.decode(str).map((x) => PopularOverviewModel.fromJson(x)));

String popularoverviewToJson(List<PopularOverviewModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopularOverviewModel {
  PopularOverviewModel(
      {this.furnished,
      this.features,
      this.propertyDescription,
      this.propertyNeighbourhood,
      this.propertyPaymentOption});

  String? furnished;
  String? propertyDescription;
  String? propertyNeighbourhood;
  String? propertyPaymentOption;
  List<dynamic>? features;

  factory PopularOverviewModel.fromJson(Map<String, dynamic> json) =>
      PopularOverviewModel(
          furnished: json['furnished'],
          propertyDescription: json['property_description'],
          propertyNeighbourhood: json['property_neighbourhood'],
          propertyPaymentOption: json['property_payment_option'],
          features: json['features']);

  Map<String, dynamic> toJson() => {
        "furnished": furnished,
        "property_description": propertyDescription,
        "property_neighbourhood": propertyNeighbourhood,
        "property_payment_option": propertyPaymentOption,
        "features": features
      };
}

class PopularOverview {
  List<PopularOverviewModel> lstpopoverviewmodel;
  PopularOverview(this.lstpopoverviewmodel);
  factory PopularOverview.fromJson(List<dynamic> parsed) {
    List<PopularOverviewModel> lst = <PopularOverviewModel>[];
    lst = parsed.map((e) => PopularOverviewModel.fromJson(e)).toList();
    return PopularOverview(lst);
  }
}
