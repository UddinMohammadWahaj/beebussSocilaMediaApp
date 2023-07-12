
// // To parse this JSON data, do
// //
// //     final cardDeleteModel = cardDeleteModelFromJson(jsonString);

// import 'dart:convert';

// CommonModel commonModelFromJson(String str) => CommonModel.fromJson(json.decode(str));

// String commonModelToJson(CommonModel data) => json.encode(data.toJson());

// class CommonModel {
//   CommonModel({
//      this.status,
//      this.msg,
//   });

//   int status;
//   String msg;

//   factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
//     status: json["status"],
//     msg: json["msg"],
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "msg": msg,
//   };
// }
