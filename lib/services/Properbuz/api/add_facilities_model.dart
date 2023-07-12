import 'dart:convert';

List<AddFacilitiesModel> addFacilitiesModelFromJson(String str) =>
    List<AddFacilitiesModel>.from(
        json.decode(str).map((x) => AddFacilitiesModel.fromJson(x)));

class AddFacilitiesModel {
  AddFacilitiesModel({
    required this.facilityID,
    required this.facility,
  });
  String facilityID;
  String facility;

  factory AddFacilitiesModel.fromJson(Map<String, dynamic> json) {
    return AddFacilitiesModel(
        facilityID: json['facility_id'], facility: json['facility']);
  }
}

class AddFacilities {
  List<AddFacilitiesModel> addfacilitiesList = [];
  AddFacilities(this.addfacilitiesList);
  factory AddFacilities.fromJson(List<dynamic> parsed) {
    List<AddFacilitiesModel> addfacilitiesList = <AddFacilitiesModel>[];
    addfacilitiesList =
        parsed.map((e) => AddFacilitiesModel.fromJson(e)).toList();
    return AddFacilities(addfacilitiesList);
  }
}
