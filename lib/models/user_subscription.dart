class UserSubscription {
  bool? premimum;
  String? dueDate;

  UserSubscription({this.premimum, this.dueDate});

  UserSubscription.fromJson(Map<String, dynamic> json) {
    premimum = json['premimum'];
    dueDate = json['due_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['premimum'] = this.premimum;
    data['due_date'] = this.dueDate;
    return data;
  }
}
