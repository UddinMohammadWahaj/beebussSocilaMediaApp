// class AllTransactionHistoryModel {
//   int status;
//   List<Transactions> transactions;

//   AllTransactionHistoryModel({this.status, this.transactions});

//   AllTransactionHistoryModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['transactions'] != null) {
//       transactions = <Transactions>[];
//       json['transactions'].forEach((v) {
//         transactions.add(new Transactions.fromJson(v));
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

// class Transactions {
//   String transaction;
//   String transactionType;
//   String amount;
//   int id;
//   String name;
//   String username;
//   String mobile;
//   String profileImage;
//   String createdAt;

//   Transactions(
//       {this.transaction,
//         this.transactionType,
//         this.amount,
//         this.id,
//         this.name,
//         this.username,
//         this.mobile,
//         this.profileImage,
//         this.createdAt});

//   Transactions.fromJson(Map<String, dynamic> json) {
//     transaction = json['transaction'];
//     transactionType = json['transaction_type'];
//     amount = json['amount'].toString();
//     id = json['id'];
//     name = json['name'];
//     username = json['username'];
//     mobile = json['mobile'];
//     profileImage = json['profile_image'];
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['transaction'] = this.transaction;
//     data['transaction_type'] = this.transactionType;
//     data['amount'] = this.amount;
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['username'] = this.username;
//     data['mobile'] = this.mobile;
//     data['profile_image'] = this.profileImage;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }
