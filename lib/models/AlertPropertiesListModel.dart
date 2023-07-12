class AlertProperiesList {
  String? imageGallery;
  String? propertyId;
  String? slug;
  String? propertyTitle;
  String? cost;
  String? currency;
  String? area;
  String? streetName1;
  String? streetName2;
  String? saveDate;
  String? proSearchId;
  String? oneImage;

  AlertProperiesList({
    this.imageGallery,
    this.propertyId,
    this.slug,
    this.propertyTitle,
    this.cost,
    this.oneImage,
    this.currency,
    this.area,
    this.streetName1,
    this.streetName2,
    this.saveDate,
    this.proSearchId,
  });

  AlertProperiesList.fromJson(Map<String, dynamic> json) {
    imageGallery = json['image_gallery'] ?? "";
    propertyId = json['property_id'] ?? "";
    slug = json['slug'] ?? "";
    propertyTitle = json['property_title'] ?? "";
    cost = json['cost'] ?? "";
    currency = json['currency'] ?? "";
    area = json['area'] ?? "";
    streetName1 = json['street_name_1'] ?? "";
    streetName2 = json['street_name_2'] ?? "";
    saveDate = json['save_date'] ?? "";
    proSearchId = json['pro_search_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_gallery'] = this.imageGallery;
    data['property_id'] = this.propertyId;
    data['slug'] = this.slug;
    data['property_title'] = this.propertyTitle;
    data['cost'] = this.cost;
    data['currency'] = this.currency;
    data['area'] = this.area;
    data['street_name_1'] = this.streetName1;
    data['street_name_2'] = this.streetName2;
    data['save_date'] = this.saveDate;
    data['pro_search_id'] = this.proSearchId;
    return data;
  }
}
