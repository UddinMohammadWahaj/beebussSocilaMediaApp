class UserDetailModel {
  String? response;
  String? memberId;
  String? memberName;
  String? memberEmail;
  String? shortcode;
  String? image;
  String? countryCode;
  String? countryName;
  String? locationLogo;
  bool? twoStepVerification;
  String? firebaseToken;
  String? twoStepVerificationPin;
  String? chatsend;
  String? meadiavisibility;
  String? fontsize;
  String? memebertype;

  UserDetailModel({
    this.response,
    this.memberId,
    this.memberName,
    this.memberEmail,
    this.shortcode,
    this.memebertype,
    this.image,
    this.countryCode,
    this.countryName,
    this.locationLogo,
    this.twoStepVerification,
    this.twoStepVerificationPin,
    this.firebaseToken,
    this.chatsend,
    this.meadiavisibility,
    this.fontsize,
  });

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] ?? "";
    memberId = json['user_id'] ?? "";
    memberName = json['member_name'] ?? "";
    memberEmail = json['member_email'] ?? "";
    shortcode = json['shortcode'] ?? "";
    image = json['image'] ?? "";
    countryCode = json['country_code'] ?? "";
    memebertype = json['member_type'] ?? "";
    countryName = json['country_name'] ?? "";
    locationLogo = json['location_logo'] ?? "";
    twoStepVerificationPin = json['two_step_verification_pin'] ?? "";
    twoStepVerification = json['two_step_verification'] ?? false;
    firebaseToken = json['firebase_token'] ?? "";
    chatsend = json['chat_send'] ?? "";
    meadiavisibility = json['meadia_visibility'] ?? "";
    fontsize = json['font_size'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['user_id'] = this.memberId;
    data['member_name'] = this.memberName;
    data['member_email'] = this.memberEmail;
    data['member_type'] = this.memebertype;
    data['shortcode'] = this.shortcode;
    data['image'] = this.image;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['location_logo'] = this.locationLogo;
    data['two_step_verification'] = this.twoStepVerification;
    data['two_step_verification_pin'] = this.twoStepVerificationPin;
    data['firebase_token'] = this.firebaseToken;
    data['chat_send'] = this.chatsend;
    data['meadia_visibility'] = this.meadiavisibility;
    data['font_size'] = this.fontsize;
    return data;
  }
}

// class UserDetailModel {
//   String response;
//   String memberId;
//   String memberName;
//   String shortcode;
//   String image;
//   String countryCode;
//   String countryName;
//   String locationLogo;
//   String firebaseToken;

//   UserDetailModel({
//     this.response,
//     this.memberId,
//     this.memberName,
//     this.shortcode,
//     this.image,
//     this.countryCode,
//     this.countryName,
//     this.locationLogo,
//     this.firebaseToken,
//   });

//   UserDetailModel.fromJson(var json) {
//     response = json['response'] ?? "";
//     memberId = json['user_id'] ?? "";
//     memberName = json['member_name'] ?? "";
//     shortcode = json['shortcode'] ?? "";
//     image = json['image'] ?? "";
//     countryCode = json['country_code'] ?? "";
//     countryName = json['country_name'] ?? "";
//     locationLogo = json['location_logo'] ?? "";
//     firebaseToken = json['firebase_token'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['response'] = this.response;
//     data['user_id'] = this.memberId;
//     data['member_name'] = this.memberName;
//     data['shortcode'] = this.shortcode;
//     data['image'] = this.image;
//     data['country_code'] = this.countryCode;
//     data['country_name'] = this.countryName;
//     data['location_logo'] = this.locationLogo;
//     data['firebase_token'] = this.firebaseToken;
//     return data;
//   }
// }
