// To parse this JSON data, do
//
//     final addressSearchModel = addressSearchModelFromJson(jsonString);

import 'dart:convert';

List<AddressSearchModel> addressSearchModelFromJson(String str) => List<AddressSearchModel>.from(
      json.decode(str).map(
            (x) => AddressSearchModel.fromJson(x),
          ),
    );

String addressSearchModelToJson(List<AddressSearchModel> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class AddressSearchModel {
  AddressSearchModel({
    this.name,
    this.formattedAddress,
    this.imageIcon,
  });

  String? name;
  String? formattedAddress;
  String? imageIcon;

  factory AddressSearchModel.fromJson(Map<String, dynamic> json) => AddressSearchModel(
        name: json["name"],
        formattedAddress: json["formatted_address"],
        imageIcon: json["image_icon"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "formatted_address": formattedAddress,
        "image_icon": imageIcon,
      };
}

class Addresses {
  List<AddressSearchModel> addresses;

  Addresses(this.addresses);

  factory Addresses.fromJson(List<dynamic> parsed) {
    List<AddressSearchModel> locations = <AddressSearchModel>[];
    locations = parsed.map((i) => AddressSearchModel.fromJson(i)).toList();
    return new Addresses(locations);
  }
}
