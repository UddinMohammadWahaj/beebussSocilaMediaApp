// // To parse this JSON data, do
// //
// //     final cardModel = cardModelFromJson(jsonString);

// import 'dart:convert';

// CardModel cardModelFromJson(String str) => CardModel.fromJson(json.decode(str));

// String cardModelToJson(CardModel data) => json.encode(data.toJson());

// class CardModel {
//   CardModel({
//     this.status,
//     this.customer,
//   });

//   int status;
//   Customer customer;

//   factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
//         status: json["status"],
//         customer: Customer.fromJson(json["customer"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "customer": customer.toJson(),
//       };
// }

// class Customer {
//   Customer({
//     this.id,
//     this.object,
//     this.addressCity,
//     this.addressCountry,
//     this.addressLine1,
//     this.addressLine1Check,
//     this.addressLine2,
//     this.addressState,
//     this.addressZip,
//     this.addressZipCheck,
//     this.brand,
//     this.country,
//     this.customer,
//     this.cvcCheck,
//     this.dynamicLast4,
//     this.expMonth,
//     this.expYear,
//     this.fingerprint,
//     this.funding,
//     this.last4,
//     this.metadata,
//     this.name,
//     this.tokenizationMethod,
//   });

//   String id;
//   String object;
//   dynamic addressCity;
//   dynamic addressCountry;
//   dynamic addressLine1;
//   dynamic addressLine1Check;
//   dynamic addressLine2;
//   dynamic addressState;
//   dynamic addressZip;
//   dynamic addressZipCheck;
//   String brand;
//   String country;
//   String customer;
//   String cvcCheck;
//   dynamic dynamicLast4;
//   int expMonth;
//   int expYear;
//   String fingerprint;
//   String funding;
//   String last4;
//   List<dynamic> metadata;
//   String name;
//   dynamic tokenizationMethod;

//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//         id: json["id"],
//         object: json["object"],
//         addressCity: json["address_city"],
//         addressCountry: json["address_country"],
//         addressLine1: json["address_line1"],
//         addressLine1Check: json["address_line1_check"],
//         addressLine2: json["address_line2"],
//         addressState: json["address_state"],
//         addressZip: json["address_zip"],
//         addressZipCheck: json["address_zip_check"],
//         brand: json["brand"],
//         country: json["country"],
//         customer: json["customer"],
//         cvcCheck: json["cvc_check"],
//         dynamicLast4: json["dynamic_last4"],
//         expMonth: json["exp_month"],
//         expYear: json["exp_year"],
//         fingerprint: json["fingerprint"],
//         funding: json["funding"],
//         last4: json["last4"],
//         metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
//         name: json["name"],
//         tokenizationMethod: json["tokenization_method"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "object": object,
//         "address_city": addressCity,
//         "address_country": addressCountry,
//         "address_line1": addressLine1,
//         "address_line1_check": addressLine1Check,
//         "address_line2": addressLine2,
//         "address_state": addressState,
//         "address_zip": addressZip,
//         "address_zip_check": addressZipCheck,
//         "brand": brand,
//         "country": country,
//         "customer": customer,
//         "cvc_check": cvcCheck,
//         "dynamic_last4": dynamicLast4,
//         "exp_month": expMonth,
//         "exp_year": expYear,
//         "fingerprint": fingerprint,
//         "funding": funding,
//         "last4": last4,
//         "metadata": List<dynamic>.from(metadata.map((x) => x)),
//         "name": name,
//         "tokenization_method": tokenizationMethod,
//       };
// }
