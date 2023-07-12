// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../model/add_wallet_model.dart';
// import '../model/balance_model.dart';
// import '../model/card_delete_model.dart';
// import '../model/card_primary_model.dart';
// import '../model/cardlist_model.dart';
// import '../model/add_balance_history_model.dart';
// import '../model/comman_model.dart';

// class WalleteConnection {
//   String server_url = "http://www.bebuzee.com/api";
//   Future<CardDeleteModel> storeCard(
//       String cardToken, String stripeCustomerId) async {
//     CardDeleteModel model;

//     final response = await http.post(
//       Uri.parse('$server_url/wallet/createCard'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'card_token': cardToken,
//         'customer_id': stripeCustomerId,
//       }),
//     );

//     print("storeCard API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       model = CardDeleteModel.fromJson(jsonDecode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       return null;
//     }
//   }

//   Future<CardListModel> getCardList(String stripeCustomerId) async {
//     CardListModel model;
//     String url = '$server_url/wallet/listCard';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'customer_id': stripeCustomerId,
//       }),
//     );
//     print("getCardList API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       model = CardListModel.fromJson(json.decode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       print('Failed to card list.');
//       throw Exception('Failed to store card.');
//     }
//   }

//   Future<CardDeleteModel> primaryCard(
//       String stripeCustomerId, String cardId) async {
//     final response = await http.post(
//       Uri.parse('$server_url/wallet/setPrimary'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'customer_id': stripeCustomerId,
//         'card_id': cardId,
//       }),
//     );

//     print("primaryCard API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       return cardDeleteModelFromJson(response.body.toString());
//     } else {
//       throw Exception('Failed to primaryCard.');
//     }
//   }

//   Future<CardPrimaryModel> getPrimaryCard(String stripeCustomerId) async {
//     final response = await http.post(
//       Uri.parse('$server_url/wallet/getPrimaryCard'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'customer_id': stripeCustomerId,
//       }),
//     );

//     print("Get primaryCard Detail API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       return cardPrimaryModelFromJson(response.body.toString());
//     } else {
//       throw Exception('Failed to Get primaryCard Detail.');
//     }
//   }

//   Future<CardDeleteModel> deleteCard(
//       String stripeCustomerId, String cardId) async {
//     final response = await http.post(
//       Uri.parse('$server_url/wallet/deleteCard'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'customer_id': stripeCustomerId,
//         'card_id': cardId,
//       }),
//     );

//     print("deleteCard API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       return cardDeleteModelFromJson(response.body.toString());
//     } else {
//       throw Exception('Failed to store card.');
//     }
//   }

//   Future<AddWalletModel> addMoney(
//       String userId, String customerId, String cardId, String amount) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     AddWalletModel model;
//     final response = await http.post(
//       Uri.parse('$server_url/wallet/addWaletAmount'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//         'customer_id': customerId,
//         'card_id': cardId,
//         'amount': amount,
//       }),
//     );
//     print("addMoney API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       return model = AddWalletModel.fromJson(json.decode(response.body));
//     } else {
//       print(json.decode(response.body));
//       return model;
//     }
//   }

//   Future<CommonModel> withdrowMoneyRequest(String userId, String amount) async {
//     // SharedPreferences pref = await SharedPreferences.getInstance();
//     // userId = pref.getString("memberID");
//     CommonModel model;
//     final response = await http.post(
//       Uri.parse('$server_url/wallet/walletWithdraw'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//         'amount': amount,
//       }),
//     );
//     print("withdrowMoney API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       return model = CommonModel.fromJson(json.decode(response.body));
//     } else {
//       print("withdrowMoney API -- ${json.decode(response.body)}");
//       return model;
//     }
//   }

//   Future<bool> addMoneyWithAuth(String userId, String paymentId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     final response = await http.post(
//       Uri.parse('$server_url/wallet/stripePaymentCheck'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//         'payment_id': paymentId,
//       }),
//     );
//     print("addMoneyWithAuth API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       if (json.decode(response.body)["status"] == 1) {
//         return true;
//       } else {
//         return false;
//       }
//     } else {
//       print("addMoneyWithAuth == " + json.decode(response.body));
//       return false;
//     }
//   }

//   Future<AddBalanceHistory> walletHistory(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     AddBalanceHistory model;
//     String url = '${server_url}/wallet/walletWithdrawList';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//       }),
//     );
//     print("walletHistory API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       model = AddBalanceHistory.fromJson(json.decode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       return null;
//     }
//   }

//   Future<BalanceModel> walletBalance(String userId, String customerId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     BalanceModel model;
//     String url =
//         '${server_url}/wallet/walletAmount?user_id=${userId}&customer_id=${customerId}';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );
//     print("walletBalance API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       model = BalanceModel.fromJson(json.decode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       return null;
//     }
//   }

//   Future<CommonModel> sendMoney(
//       String userId, String receiverId, String amount) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     CommonModel model;
//     String url = '${server_url}/stripe/walletToWalletTransfer';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//         'wallet_user_id': receiverId,
//         'amount': amount,
//       }),
//     );
//     print("sendMoney API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       model = CommonModel.fromJson(json.decode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       return null;
//     }
//   }

//   Future<CommonModel> requestMoney(
//       String userId, String receiverId, String amount) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     CommonModel model;
//     String url = "${server_url}/stripe/walletPaymentRequest";
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//         'wallet_user_id': receiverId,
//         'amount': amount,
//       }),
//     );
//     print("sendMoney API -- ${json.decode(response.body)}");
//     if (response.statusCode == 200) {
//       model = CommonModel.fromJson(json.decode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       return null;
//     }
//   }
// }
