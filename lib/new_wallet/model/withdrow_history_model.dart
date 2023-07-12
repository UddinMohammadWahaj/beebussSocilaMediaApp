// class WithdrowHistoryModel {
//   int status;
//   List<WalletWithdrawList> walletWithdrawList;

//   WithdrowHistoryModel({this.status, this.walletWithdrawList});

//   WithdrowHistoryModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['wallet_withdraw_list'] != null) {
//       walletWithdrawList = <WalletWithdrawList>[];
//       json['wallet_withdraw_list'].forEach((v) {
//         walletWithdrawList.add(new WalletWithdrawList.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.walletWithdrawList != null) {
//       data['wallet_withdraw_list'] =
//           this.walletWithdrawList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class WalletWithdrawList {
//   int id;
//   int amount;
//   int userId;
//   int walletId;
//   String status;
//   Null transactionDetails;
//   String createdAt;
//   String updatedAt;

//   WalletWithdrawList(
//       {this.id,
//         this.amount,
//         this.userId,
//         this.walletId,
//         this.status,
//         this.transactionDetails,
//         this.createdAt,
//         this.updatedAt});

//   WalletWithdrawList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     amount = json['amount'];
//     userId = json['user_id'];
//     walletId = json['wallet_id'];
//     status = json['status'];
//     transactionDetails = json['transaction_details'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['amount'] = this.amount;
//     data['user_id'] = this.userId;
//     data['wallet_id'] = this.walletId;
//     data['status'] = this.status;
//     data['transaction_details'] = this.transactionDetails;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
