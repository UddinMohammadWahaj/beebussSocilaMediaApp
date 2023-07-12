import 'dart:convert';

List<PropertyCountryFilterModel> propertyCountryFilterModelFromJson(
        String str) =>
    List<PropertyCountryFilterModel>.from(
        json.decode(str).map((x) => PropertyCountryFilterModel.fromJson(x)));

class PropertyCountryFilterModel {
  PropertyCountryFilterModel({
    this.countryId,
    this.country,
  });

  String? countryId;
  String? country;

  factory PropertyCountryFilterModel.fromJson(Map<String, dynamic> json) =>
      PropertyCountryFilterModel(
        countryId: json["country_id"],
        country: json["country"],
      );
}

class PropertyCountries {
  List<PropertyCountryFilterModel> countries;
  PropertyCountries(this.countries);
  factory PropertyCountries.fromJson(List<dynamic> parsed) {
    List<PropertyCountryFilterModel> countries = <PropertyCountryFilterModel>[];
    countries =
        parsed.map((i) => PropertyCountryFilterModel.fromJson(i)).toList();
    return new PropertyCountries(countries);
  }
}
