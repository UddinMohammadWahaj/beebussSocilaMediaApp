// To parse this JSON data, do
//
//     final merchantStoreCurrency = merchantStoreCurrencyFromJson(jsonString);

import 'dart:convert';

MerchantStoreCurrency merchantStoreCurrencyFromJson(String str) =>
    MerchantStoreCurrency.fromJson(json.decode(str));

String merchantStoreCurrencyToJson(MerchantStoreCurrency data) =>
    json.encode(data.toJson());

class MerchantStoreCurrency {
  MerchantStoreCurrency({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<MerchantStoreCurrencyDatum>? data;

  factory MerchantStoreCurrency.fromJson(Map<String, dynamic> json) =>
      MerchantStoreCurrency(
        status: json["status"],
        message: json["message"],
        data: List<MerchantStoreCurrencyDatum>.from(
            json["data"].map((x) => MerchantStoreCurrencyDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MerchantStoreCurrencyDatum {
  MerchantStoreCurrencyDatum({this.symbol, this.currencyName, this.code});

  String? symbol;
  String? currencyName;
  String? code;

  factory MerchantStoreCurrencyDatum.fromJson(Map<String, dynamic> json) =>
      MerchantStoreCurrencyDatum(
          symbol: json["symbol"],
          currencyName: json["currency_name "],
          code: json['code']);

  Map<String, dynamic> toJson() =>
      {"symbol": symbol, "currency_name ": currencyName, "code": code};
}
