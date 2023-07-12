// class UserRecentModel {
//   int status;
//   List<TransactionsUser> transactions;

//   UserRecentModel({this.status, this.transactions});

//   UserRecentModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['transactions'] != null) {
//       transactions = <TransactionsUser>[];
//       json['transactions'].forEach((v) {
//         transactions.add(new TransactionsUser.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.transactions != null) {
//       data['transactions'] = this.transactions.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class TransactionsUser {
//   int id;
//   String name;
//   String username;
//   String profileImage;
//   String createdAt;

//   TransactionsUser(
//       {this.id, this.name, this.username, this.profileImage, this.createdAt});

//   TransactionsUser.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     username = json['username'];
//     profileImage = json['profile_image'];
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['username'] = this.username;
//     data['profile_image'] = this.profileImage;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }
