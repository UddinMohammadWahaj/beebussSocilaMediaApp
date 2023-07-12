import 'dart:convert';

List<AddFeatureListModel> addFeatureListModelfromJson(String str) =>
    List<AddFeatureListModel>.from(
        json.decode(str).map((x) => AddFeatureListModel.fromJson(x)));

class AddFeatureListModel {
  AddFeatureListModel({
    this.featureID,
    this.specialfeature,
  });
  String? featureID;
  String? specialfeature;

  factory AddFeatureListModel.fromJson(Map<String, dynamic> json) {
    return AddFeatureListModel(
        featureID: json['feature_id'].toString(),
        specialfeature: json['special_feature']);
  }
}

class AddFeatureList {
  List<AddFeatureListModel> addFeatureList = [];
  AddFeatureList(this.addFeatureList);
  factory AddFeatureList.fromJson(List<dynamic> parsed) {
    List<AddFeatureListModel> addFeatureList = <AddFeatureListModel>[];
    addFeatureList =
        parsed.map((e) => AddFeatureListModel.fromJson(e)).toList();
    return AddFeatureList(addFeatureList);
  }
}
