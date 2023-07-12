// class PayUserModel {
//   int status;
//   List<User> user;

//   PayUserModel({this.status, this.user});

//   PayUserModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['user'] != null) {
//       user = <User>[];
//       json['user'].forEach((v) {
//         user.add(new User.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.user != null) {
//       data['user'] = this.user.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class User {
//   int id;
//   String name;
//   String username;
//   String profileImage;
//   String mobile;
//   int walletId;

//   User({this.id, this.name, this.username, this.profileImage, this.walletId,this.mobile});

//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     username = json['username'];
//     profileImage = json['profile_image'];
//     walletId = json['wallet_id'];
//     mobile = json['mobile'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['username'] = this.username;
//     data['profile_image'] = this.profileImage;
//     data['wallet_id'] = this.walletId;
//     data['mobile'] = this.mobile;
//     return data;
//   }
// }
