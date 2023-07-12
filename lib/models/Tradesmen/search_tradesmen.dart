class TradesmenSearch {
  String? serviceId;
  String? serviceCompanyName;
  String? serviceDetails;
  String? serviceAreaId;
  String? memberSince;

  TradesmenSearch(
      {this.serviceId,
      this.serviceCompanyName,
      this.serviceDetails,
      this.serviceAreaId,
      this.memberSince});

  TradesmenSearch.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceCompanyName = json['service_company_name'];
    serviceDetails = json['service_details'];
    serviceAreaId = json['service_area_id'];
    memberSince = json['member_since'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_company_name'] = this.serviceCompanyName;
    data['service_details'] = this.serviceDetails;
    data['service_area_id'] = this.serviceAreaId;
    data['member_since'] = this.memberSince;
    return data;
  }
}
