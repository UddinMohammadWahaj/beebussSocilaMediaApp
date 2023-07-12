// class RecentTransactionModel {
//   int status;
//   List<Transactions> transactions;

//   RecentTransactionModel({this.status, this.transactions});

//   RecentTransactionModel.fromJson(Map<String, dynamic> json) {
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
//   String description;
//   int amount;
//   String transaction;
//   String transactionType;
//   String createdAt;

//   Transactions(
//       {this.id,
//         this.description,
//         this.amount,
//         this.transaction,
//         this.transactionType,
//         this.createdAt});

//   Transactions.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     amount = json['amount'];
//     transaction = json['transaction'];
//     transactionType = json['transaction_type'];
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['description'] = this.description;
//     data['amount'] = this.amount;
//     data['transaction'] = this.transaction;
//     data['transaction_type'] = this.transactionType;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }
