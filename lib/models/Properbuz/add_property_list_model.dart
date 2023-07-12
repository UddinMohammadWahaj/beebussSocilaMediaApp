import 'dart:convert';

List<AddPropertyListModel> addPropertyListModelFromJson(String str) =>
    List<AddPropertyListModel>.from(
        json.decode(str).map((x) => AddPropertyListModel.fromJson(x)));

class AddPropertyListModel {
  AddPropertyListModel({
    this.propertytypeID,
    this.propertytype,
  });
  String? propertytypeID;
  String? propertytype;

  factory AddPropertyListModel.fromJson(Map<String, dynamic> json) {
    return AddPropertyListModel(
        propertytypeID: json['property_type_id'].toString(),
        propertytype: json['property_type']);
  }
}

class AddPropertyList {
  List<AddPropertyListModel> addpropertyList = [];
  AddPropertyList(this.addpropertyList);
  factory AddPropertyList.fromJson(List<dynamic> parsed) {
    List<AddPropertyListModel> addpropertyList = <AddPropertyListModel>[];
    addpropertyList =
        parsed.map((e) => AddPropertyListModel.fromJson(e)).toList();
    return AddPropertyList(addpropertyList);
  }
}
