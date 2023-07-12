// class TransactionDetailModel {
//   int status;
//   Transaction transaction;
//   FromUser fromUser;
//   FromUser toUser;

//   TransactionDetailModel(
//       {this.status, this.transaction, this.fromUser, this.toUser});

//   TransactionDetailModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     transaction = json['transaction'] != null
//         ? new Transaction.fromJson(json['transaction'])
//         : null;
//     fromUser = json['fromUser'] != null
//         ? new FromUser.fromJson(json['fromUser'])
//         : null;
//     toUser =
//     json['toUser'] != null ? new FromUser.fromJson(json['toUser']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.transaction != null) {
//       data['transaction'] = this.transaction.toJson();
//     }
//     if (this.fromUser != null) {
//       data['fromUser'] = this.fromUser.toJson();
//     }
//     if (this.toUser != null) {
//       data['toUser'] = this.toUser.toJson();
//     }
//     return data;
//   }
// }

// class Transaction {
//   int id;
//   String description;
//   int amount;
//   String transactionType;
//   String transaction;
//   String transactionStatus;
//   String paymentMethod;
//   String transactionId;
//   String walletTransactionId;
//   int walletId;
//   int userId;
//   int walletUserId;
//   String createdAt;
//   String updatedAt;

//   Transaction(
//       {this.id,
//         this.description,
//         this.amount,
//         this.transactionType,
//         this.transaction,
//         this.transactionStatus,
//         this.paymentMethod,
//         this.transactionId,
//         this.walletTransactionId,
//         this.walletId,
//         this.userId,
//         this.walletUserId,
//         this.createdAt,
//         this.updatedAt});

//   Transaction.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     amount = json['amount'];
//     transactionType = json['transaction_type'];
//     transaction = json['transaction'];
//     transactionStatus = json['transaction_status'];
//     paymentMethod = json['payment_method'];
//     transactionId = json['transaction_id'];
//     walletTransactionId = json['wallet_transaction_id'];
//     walletId = json['wallet_id'];
//     userId = json['user_id'];
//     walletUserId = json['wallet_user_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['description'] = this.description;
//     data['amount'] = this.amount;
//     data['transaction_type'] = this.transactionType;
//     data['transaction'] = this.transaction;
//     data['transaction_status'] = this.transactionStatus;
//     data['payment_method'] = this.paymentMethod;
//     data['transaction_id'] = this.transactionId;
//     data['wallet_transaction_id'] = this.walletTransactionId;
//     data['wallet_id'] = this.walletId;
//     data['user_id'] = this.userId;
//     data['wallet_user_id'] = this.walletUserId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

// class FromUser {
//   String name;
//   String mobile;

//   FromUser({this.name, this.mobile});

//   FromUser.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     mobile = json['mobile'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['mobile'] = this.mobile;
//     return data;
//   }
// }
