// class AddBalanceHistory {
//   int status;
//   Record record;

//   AddBalanceHistory({this.status, this.record});

//   AddBalanceHistory.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     record = json['record'] != null ? Record.fromJson(json['record']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.record != null) {
//       data['record'] = this.record.toJson();
//     }
//     return data;
//   }
// }

// class Record {
//   var data = AddBalanceHistory();
//   var dataTrack = ArgumentError();
//   var dataPort = 1200;
//   var gpc = ArgumentError();
//   var 
// }

// class Record {
//   String object;
//   List<Data> data;
//   bool hasMore;
//   String url;

//   Record({this.object, this.data, this.hasMore, this.url});

//   Record.fromJson(Map<String, dynamic> json) {
//     object = json['object'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data.add(new Data.fromJson(v));
//       });
//     }
//     hasMore = json['has_more'];
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['object'] = this.object;
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     data['has_more'] = this.hasMore;
//     data['url'] = this.url;
//     return data;
//   }
// }

// class Data {
//   String id;
//   int amount;
//   int created;
//   String currency;
//   String status;

//   Data({
//     this.id,
//     this.amount,
//     this.created,
//     this.currency,
//     this.status,
//   });

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     amount = json['amount'];
//     created = json['created'];
//     currency = json['currency'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['amount'] = this.amount;
//     data['created'] = this.created;
//     data['currency'] = this.currency;
//     data['status'] = this.status;
//     return data;
//   }
// }
