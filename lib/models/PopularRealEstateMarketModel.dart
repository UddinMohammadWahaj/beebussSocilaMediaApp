class PopularRealEstateMarketModel {
  String? name;
  String? country;
  String? type;
  String? type_chk;
  PopularRealEstateMarketModel(
      {this.name, this.country, this.type, this.type_chk});

  PopularRealEstateMarketModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    country = json['country'] ?? "";
    type = json['type'] ?? "";
    type_chk = json['type_chk'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['country'] = this.country;
    data['type'] = this.type;
    data['type_chk'] = this.type_chk;
    return data;
  }
}
