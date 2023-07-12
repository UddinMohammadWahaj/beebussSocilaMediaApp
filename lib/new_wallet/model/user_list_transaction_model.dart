// class UserListTrasactionModel {
//   int status;
//   List<Transactions> transactions;

//   UserListTrasactionModel({this.status, this.transactions});

//   UserListTrasactionModel.fromJson(Map<String, dynamic> json) {
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
//   int id;
//   int amount;
//   int userId;
//   int walletUserId;
//   String createdAt;
//   String updatedAt;
//   String description;
//   String transactionType;
//   String transaction;
//   String transactionStatus;
//   String paymentMethod;
//   String transactionId;
//   int walletId;

//   Transactions(
//       {this.id,
//         this.amount,
//         this.userId,
//         this.walletUserId,
//         this.createdAt,
//         this.updatedAt,
//         this.description,
//         this.transactionType,
//         this.transaction,
//         this.transactionStatus,
//         this.paymentMethod,
//         this.transactionId,
//         this.walletId});

//   Transactions.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     amount = json['amount'];
//     userId = json['user_id'];
//     walletUserId = json['wallet_user_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     description = json['description'];
//     transactionType = json['transaction_type'];
//     transaction = json['transaction'];
//     transactionStatus = json['transaction_status'];
//     paymentMethod = json['payment_method'];
//     transactionId = json['transaction_id'];
//     walletId = json['wallet_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['amount'] = this.amount;
//     data['user_id'] = this.userId;
//     data['wallet_user_id'] = this.walletUserId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['description'] = this.description;
//     data['transaction_type'] = this.transactionType;
//     data['transaction'] = this.transaction;
//     data['transaction_status'] = this.transactionStatus;
//     data['payment_method'] = this.paymentMethod;
//     data['transaction_id'] = this.transactionId;
//     data['wallet_id'] = this.walletId;
//     return data;
//   }
// }
