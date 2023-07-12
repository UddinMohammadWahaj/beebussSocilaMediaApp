class TradeDescriptionModel {
  List<Profile>? profile;
  String? description;
  String? basedIn;
  String? worksIn;
  Review? review;
  Services? services;

  TradeDescriptionModel(
      {this.profile,
      this.description,
      this.basedIn,
      this.worksIn,
      this.review,
      this.services});

  TradeDescriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['profile'] != null) {
      // ignore: deprecated_member_use
      profile = <Profile>[];
      json['profile'].forEach((v) {
        profile!.add(new Profile.fromJson(v));
      });
    }
    description = json['description'] ?? "";
    basedIn = json['based_in'] ?? "";
    worksIn = json['works_in'] ?? "";
    review =
        json['review'] != null ? new Review.fromJson(json['review']) : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
  }

  TradeDescriptionModel.obs();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['based_in'] = this.basedIn;
    data['works_in'] = this.worksIn;
    if (this.review != null) {
      data['review'] = this.review!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    return data;
  }
}

class Profile {
  String? serviceCompanyName;
  String? serviceCompanyAuthName;
  String? serviceCompanyContact1;
  String? serviceCompanyContact2;
  String? serviceCompanyEmail;
  String? serviceCompanyWebsite;
  String? serviceHouseNumber;
  String? serviceStreetLineOne;
  String? serviceStreetLineTwo;
  String? serviceAreaId;
  String? serviceCountryId;
  String? serviceZipcode;
  String? serviceLatitude;
  String? serviceLongitude;

  Profile(
      {this.serviceCompanyName,
      this.serviceCompanyAuthName,
      this.serviceCompanyContact1,
      this.serviceCompanyContact2,
      this.serviceCompanyEmail,
      this.serviceCompanyWebsite,
      this.serviceHouseNumber,
      this.serviceStreetLineOne,
      this.serviceStreetLineTwo,
      this.serviceAreaId,
      this.serviceCountryId,
      this.serviceZipcode,
      this.serviceLatitude,
      this.serviceLongitude});

  Profile.fromJson(Map<String, dynamic> json) {
    serviceCompanyName = json['service_company_name'];
    serviceCompanyAuthName = json['service_company_auth_name'];
    serviceCompanyContact1 = json['service_company_contact1'];
    serviceCompanyContact2 = json['service_company_contact2'];
    serviceCompanyEmail = json['service_company_email'];
    serviceCompanyWebsite = json['service_company_website'];
    serviceHouseNumber = json['service_house_number'];
    serviceStreetLineOne = json['service_street_line_one'];
    serviceStreetLineTwo = json['service_street_line_two'];
    serviceAreaId = json['service_area_id'];
    serviceCountryId = json['service_country_id'];
    serviceZipcode = json['service_zipcode'];
    serviceLatitude = json['service_latitude'];
    serviceLongitude = json['service_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_company_name'] = this.serviceCompanyName;
    data['service_company_auth_name'] = this.serviceCompanyAuthName;
    data['service_company_contact1'] = this.serviceCompanyContact1;
    data['service_company_contact2'] = this.serviceCompanyContact2;
    data['service_company_email'] = this.serviceCompanyEmail;
    data['service_company_website'] = this.serviceCompanyWebsite;
    data['service_house_number'] = this.serviceHouseNumber;
    data['service_street_line_one'] = this.serviceStreetLineOne;
    data['service_street_line_two'] = this.serviceStreetLineTwo;
    data['service_area_id'] = this.serviceAreaId;
    data['service_country_id'] = this.serviceCountryId;
    data['service_zipcode'] = this.serviceZipcode;
    data['service_latitude'] = this.serviceLatitude;
    data['service_longitude'] = this.serviceLongitude;
    return data;
  }
}

class Review {
  String? totalreviewaverage;
  int? totalreviewcount;
  String? reliability;
  String? tidy;
  String? courtesy;
  String? workship;

  Review(
      {this.totalreviewaverage,
      this.totalreviewcount,
      this.reliability,
      this.tidy,
      this.courtesy,
      this.workship});

  Review.fromJson(Map<String, dynamic> json) {
    totalreviewaverage = json['totalreviewaverage'];
    totalreviewcount = json['totalreviewcount'];
    reliability = json['reliability'];
    tidy = json['tidy'];
    courtesy = json['courtesy'];
    workship = json['workship'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalreviewaverage'] = this.totalreviewaverage;
    data['totalreviewcount'] = this.totalreviewcount;
    data['reliability'] = this.reliability;
    data['tidy'] = this.tidy;
    data['courtesy'] = this.courtesy;
    data['workship'] = this.workship;
    return data;
  }
}

class Services {
  List<String>? electricianCategory;

  Services({this.electricianCategory});

  Services.fromJson(Map<String, dynamic> json) {
    electricianCategory = json['Electrician Category'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Electrician Category'] = this.electricianCategory;
    return data;
  }
}
