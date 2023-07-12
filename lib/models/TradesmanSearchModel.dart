class TradesmanSearchModel {
  String? serviceId;
  String? serviceCompanyName;
  String? serviceDetails;
  String? serviceAreaId;

  TradesmanSearchModel(
      {this.serviceId,
      this.serviceCompanyName,
      this.serviceDetails,
      this.serviceAreaId});

  TradesmanSearchModel.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'] ?? "";
    serviceCompanyName = json['service_company_name'] ?? "";
    serviceDetails = json['service_details'] ?? "";
    serviceAreaId = json['service_area_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_company_name'] = this.serviceCompanyName;
    data['service_details'] = this.serviceDetails;
    data['service_area_id'] = this.serviceAreaId;
    return data;
  }
}
