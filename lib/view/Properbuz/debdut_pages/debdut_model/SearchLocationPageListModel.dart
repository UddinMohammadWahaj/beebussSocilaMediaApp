class SearchLocationPageListModel {
  String? id;
  String? reviewTitle;
  String? review;
  String? rating;
  String? country;
  String? memberId;
  String? memberType;
  String? memberFirstName;
  String? memberLastName;
  String? gender;
  String? memberEmail;
  String? countryCode;
  String? location;
  List<String>? images;

  var date;

  SearchLocationPageListModel(
      {this.id,
      this.reviewTitle,
      this.review,
      this.rating,
      this.location,
      this.country,
      this.date,
      this.memberFirstName,
      this.memberLastName,
      this.memberId,
      this.memberType,
      this.images});

  SearchLocationPageListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    memberId = json['user_id'] ?? "";
    review = json['review'] ?? "";
    reviewTitle = json['review_title'] ?? "";
    memberFirstName = json['member_firstname'];
    memberLastName = json['member_lastname'];
    rating = json['rating'] ?? "";
    country = json['country'] ?? "";
    images = json['images'] ?? "";
    location = json['location'] ?? " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['id'] = this.id;
    data['review'] = this.review;
    data['review_title'] = this.reviewTitle;
    data['member_firstname'] = this.memberFirstName;
    data['member_lastname'] = this.memberLastName;
    data['rating'] = this.rating;
    data['country'] = this.country;
    data['user_id'] = this.memberId;
    data['images'] = this.images;
    return data;
  }
}
