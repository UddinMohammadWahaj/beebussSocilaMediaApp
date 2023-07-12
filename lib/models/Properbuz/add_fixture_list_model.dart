import 'dart:convert';

List<AddFixtureListModel> addFixtureListModelfromJson(String str) =>
    List<AddFixtureListModel>.from(
        json.decode(str).map((x) => AddFixtureListModel.fromJson(x)));

class AddFixtureListModel {
  AddFixtureListModel({
    this.fixtureID,
    this.fixture,
  });
  String? fixtureID;
  String? fixture;

  factory AddFixtureListModel.fromJson(Map<String, dynamic> json) {
    return AddFixtureListModel(
        fixtureID: json['fixture_id'].toString(), fixture: json['fixture']);
  }
}

class AddFixtureList {
  List<AddFixtureListModel> addfixtureList = [];
  AddFixtureList(this.addfixtureList);
  factory AddFixtureList.fromJson(List<dynamic> parsed) {
    List<AddFixtureListModel> addfixtureList = <AddFixtureListModel>[];
    addfixtureList =
        parsed.map((e) => AddFixtureListModel.fromJson(e)).toList();
    return AddFixtureList(addfixtureList);
  }
}
