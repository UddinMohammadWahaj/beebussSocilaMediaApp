// // To parse this JSON data, do
// //
// //     final cardDeleteModel = cardDeleteModelFromJson(jsonString);

// import 'dart:convert';

// CardPrimaryModel cardPrimaryModelFromJson(String str) => CardPrimaryModel.fromJson(json.decode(str));

// String cardPrimaryModelToJson(CardPrimaryModel data) => json.encode(data.toJson());

// class CardPrimaryModel {
//   CardPrimaryModel({
//     this.status,
//      this.card,
//   });

//   int status;
//   String card;

//   factory CardPrimaryModel.fromJson(Map<String, dynamic> json) => CardPrimaryModel(
//     status: json["status"],
//     card: json["card"],
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "card": card,
//   };
// }
