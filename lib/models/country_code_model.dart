class CountryCodeModel {
  String value;
  String name;
  String display;
  CountryCodeModel({
    this.value = '',
    this.name = '',
    this.display = '',
  });

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      name: json['name'],
      value: json['value'],
      display: json['name'].toString().substring(0, 3),
    );
  }
}
