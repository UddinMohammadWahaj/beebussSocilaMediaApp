class RecentlyLocationModel {
  String? area;
  String? country;

  RecentlyLocationModel({this.area, this.country});

  RecentlyLocationModel.fromJson(Map<String, dynamic> json) {
    area = json['area'] ?? "";
    country = json['country'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['country'] = this.country;
    return data;
  }
}
