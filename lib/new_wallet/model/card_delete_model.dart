// // To parse this JSON data, do
// //
// //     final cardDeleteModel = cardDeleteModelFromJson(jsonString);

// import 'dart:convert';

// CardDeleteModel cardDeleteModelFromJson(String str) => CardDeleteModel.fromJson(json.decode(str));

// String cardDeleteModelToJson(CardDeleteModel data) => json.encode(data.toJson());

// class CardDeleteModel {
//   CardDeleteModel({
//     this.status,
//      this.msg,
//   });

//   int status;
//   String msg;

//   factory CardDeleteModel.fromJson(Map<String, dynamic> json) => CardDeleteModel(
//     status: json["status"],
//     msg: json["msg"],
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "msg": msg,
//   };
// }
