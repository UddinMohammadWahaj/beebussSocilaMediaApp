class MyContactModel {
  int? success;
  List<ContactList>? contactList;
  String? message;

  MyContactModel({this.success, this.contactList, this.message});

  MyContactModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    if (json['contactList'] != null) {
      contactList = <ContactList>[];
      json['contactList'].forEach((v) {
        contactList!.add(new ContactList.fromJson(v));
      });
    }
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.contactList != null) {
      data['contactList'] = this.contactList!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ContactList {
  String? memberId;
  String? contactName;
  String? memberName;
  String? shortcode;
  dynamic firebaseToken;
  String? memberImage;
  String? contactNumbers;

  ContactList(
      {this.memberId,
      this.contactName,
      this.memberName,
      this.shortcode,
      this.firebaseToken,
      this.memberImage,
      this.contactNumbers});

  ContactList.fromJson(Map<String, dynamic> json) {
    memberId = json['user_id'] ?? "";
    contactName = json['contact_name'] ?? "";
    memberName = json['member_name'] ?? "";
    shortcode = json['shortcode'] ?? "";
    firebaseToken = json['firebase_token'] ?? "";
    memberImage = json['member_image'];
    contactNumbers = json['contact_numbers'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.memberId;
    data['contact_name'] = this.contactName;
    data['member_name'] = this.memberName;
    data['shortcode'] = this.shortcode;
    data['firebase_token'] = this.firebaseToken;
    data['member_image'] = this.memberImage;
    data['contact_numbers'] = this.contactNumbers;
    return data;
  }
}
