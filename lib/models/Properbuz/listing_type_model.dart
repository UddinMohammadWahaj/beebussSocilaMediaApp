import 'dart:convert';

List<ListingTypeModel> listingTypeModelFromJson(String str) =>
    List<ListingTypeModel>.from(
        json.decode(str).map((x) => ListingTypeModel.fromJson(x)));

class ListingTypeModel {
  ListingTypeModel({
    this.typeID,
    this.typeName,
  });
  String? typeID;
  String? typeName;

  factory ListingTypeModel.fromJson(Map<String, dynamic> json) {
    return ListingTypeModel(
        typeID: json['type_id'], typeName: json['type_name']);
  }
}

class ListingType {
  List<ListingTypeModel> listingtypelist = [];
  ListingType(this.listingtypelist);
  factory ListingType.fromJson(List<dynamic> parsed) {
    List<ListingTypeModel> listingtypelist = <ListingTypeModel>[];
    listingtypelist = parsed.map((e) => ListingTypeModel.fromJson(e)).toList();
    return ListingType(listingtypelist);
  }
}
