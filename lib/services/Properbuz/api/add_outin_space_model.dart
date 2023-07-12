import 'dart:convert';

List<AddOutinSpaceListModel> addoutinspaceListModelFromJson(String str) =>
    List<AddOutinSpaceListModel>.from(
        json.decode(str).map((x) => AddOutinSpaceListModel.fromJson(x)));

class AddOutinSpaceListModel {
  AddOutinSpaceListModel({
    this.outinspaceID,
    this.outinspace,
  });
  String? outinspaceID;
  String? outinspace;

  factory AddOutinSpaceListModel.fromJson(Map<String, dynamic> json) {
    return AddOutinSpaceListModel(
        outinspaceID: json['outin_space_id'], outinspace: json['outin_space']);
  }
}

class AddOutinSpaceList {
  List<AddOutinSpaceListModel> addoutinspaceList = [];
  AddOutinSpaceList(this.addoutinspaceList);
  factory AddOutinSpaceList.fromJson(List<dynamic> parsed) {
    List<AddOutinSpaceListModel> addoutinspaceList = <AddOutinSpaceListModel>[];
    addoutinspaceList =
        parsed.map((e) => AddOutinSpaceListModel.fromJson(e)).toList();
    return AddOutinSpaceList(addoutinspaceList);
  }
}
