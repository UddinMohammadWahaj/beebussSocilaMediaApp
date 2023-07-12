// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// import '../model/PayUserModel.dart';
// import '../model/all_transaction_history_model.dart';
// import '../model/comman_model.dart';
// import '../model/recent_ransaction_model.dart';
// import '../model/transaction_detail.dart';
// import '../model/user_list_transaction_model.dart';
// import '../model/user_model.dart';
// import 'package:http/http.dart' as http;

// import '../model/user_recent_model.dart';
// import '../model/withdrow_history_model.dart';

// class UserConnection {
//   String server_url = "http://www.bebuzee.com/api/";

//   Future<UserModel> getSearchList(String keyword) async {
//     String url = '${server_url}userList?keyword=${keyword}';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );

//     if (response.statusCode == 200) {
//       UserModel model = UserModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to user search list.');
//       throw Exception('Failed user search list api');
//     }
//   }

//   Future<UserModel> getContactList(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     String url = '${server_url}userFollower?user_id=$userId';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );

//     if (response.statusCode == 200) {
//       UserModel model = UserModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to user list.');
//       throw Exception('Failed user list api');
//     }
//   }

//   Future<UserModel> getWalletToWalletTransaction(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     String url = '${server_url}userFollower?user_id=$userId';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );

//     if (response.statusCode == 200) {
//       UserModel model = UserModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to user list.');
//       throw Exception('Failed user list api');
//     }
//   }

//   Future<UserListTrasactionModel> getUserToUserTransaction(
//       String userId, String otherId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");

//     String url = '${server_url}wallet/userWalletTransaction';
//     final response = await http.post(Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'user_id': userId,
//           'wallet_user_id': otherId,
//         }));

//     print("GetUserToUserTransaction ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       UserListTrasactionModel model =
//           UserListTrasactionModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to getUserToUserTransaction .');
//       throw Exception('Failed getUserToUserTransaction api');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getDoubleData(String userId) async {
//     String recentUrl = '$server_url/listCard';
//     String allUser = '$server_url//listCard';
//     var value = <Map<String, dynamic>>[];
//     var r1 = http.post(
//       Uri.parse(recentUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'userId': userId,
//       }),
//     );
//     var r2 = http.post(
//       Uri.parse(allUser),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'userId': userId,
//       }),
//     );
//     var results = await Future.wait([r1, r2]);
//     for (var response in results) {
//       print(response.statusCode);
//       value.add(json.decode(response.body));
//     }
//     return value;
//   }

//   Future<RecentTransactionModel> getRecentTransactionHome(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     String url = '${server_url}wallet/otherWalletTransactionRecentFew';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//       }),
//     );

//     print("getRecentTransactionHome ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       RecentTransactionModel model =
//           RecentTransactionModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to getRecentTransactionHome.');
//       throw Exception('Failed getRecentTransactionHome api');
//     }
//   }

//   Future<RecentTransactionModel> otherWalletTransaction(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     String url = '${server_url}wallet/otherWalletTransaction';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//       }),
//     );

//     print("getRecentTransactionHome ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       RecentTransactionModel model =
//           RecentTransactionModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to getRecentTransactionHome.');
//       throw Exception('Failed getRecentTransactionHome api');
//     }
//   }

//   Future<UserRecentModel> getRecentUserHome(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     String url = '${server_url}wallet/userWalletTransactionRecentFew';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//       }),
//     );

//     print("getRecentUserHome ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       UserRecentModel model =
//           UserRecentModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to getRecentUserHome.');
//       throw Exception('Failed getRecentUserHome api');
//     }
//   }

//   Future<UserRecentModel> getUserListWalletTransaction(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     String url = '${server_url}wallet/userListWalletTransaction';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//       }),
//     );

//     print("getUserListWalletTransaction ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       UserRecentModel model =
//           UserRecentModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to getUserListWalletTransaction.');
//       throw Exception('Failed getUserListWalletTransaction api');
//     }
//   }

//   Future<AllTransactionHistoryModel> getFilterTransaction(
//       String userId, String filterType, String search) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     String url = '${server_url}wallet/allWalletTransaction';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//         'filter': filterType,
//         'search': search,
//       }),
//     );

//     print("getFilterTransaction ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       AllTransactionHistoryModel model =
//           AllTransactionHistoryModel.fromJson(jsonDecode(response.body));
//       return model;
//     } else {
//       print('Failed to getFilterTransaction.');
//       throw Exception('Failed getFilterTransaction api');
//     }
//   }

//   Future<TransactionDetailModel> transactionDetail(String transactionId) async {
//     String url = '${server_url}wallet/walletTransactionDetail';
//     TransactionDetailModel model;
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'transaction_id': transactionId,
//       }),
//     );

//     print("transactionDetail ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       model = TransactionDetailModel.fromJson(jsonDecode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       print('Failed to transactionDetail.');
//       throw Exception('Failed transactionDetail api');
//     }
//   }

//   Future<PayUserModel> payByNumber(String number) async {
//     PayUserModel model;
//     String url = '${server_url}wallet/searchByNumber';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'search': number,
//       }),
//     );

//     print("Pay Number ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       model = PayUserModel.fromJson(jsonDecode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       print('Failed to payByNumber list.');
//       throw Exception('Failed user payByNumber api');
//     }
//   }

//   Future<PayUserModel> payByContact(String name) async {
//     PayUserModel model;
//     String url = '${server_url}wallet/searchByName';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'search': name,
//       }),
//     );

//     if (response.statusCode == 200) {
//       model = PayUserModel.fromJson(jsonDecode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       print('Failed to payByContact list.');
//       throw Exception('Failed user payByContact api');
//     }
//   }

//   Future<WithdrowHistoryModel> getWithdrowHistory(String userId) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     WithdrowHistoryModel model;
//     String url = '${server_url}wallet/walletWithdrawList';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': userId,
//       }),
//     );

//     print("getRecentTransactionHome ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       model = WithdrowHistoryModel.fromJson(jsonDecode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       print('Failed to getRecentTransactionHome.');
//       throw Exception('Failed getRecentTransactionHome api');
//     }
//   }

//   Future<CommonModel> sendFeedback(String userId, String name, String email,
//       String mobile, String message) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     CommonModel model;
//     String url = '${server_url}wallet/sendFeedback';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'name': userId,
//         'email': name,
//         'mobile': email,
//         'message': message,
//       }),
//     );

//     print("getRecentTransactionHome ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       model = CommonModel.fromJson(jsonDecode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       print('Failed to getRecentTransactionHome.');
//       throw Exception('Failed getRecentTransactionHome api');
//     }
//   }

//   Future<CommonModel> getNewRegister(
//       String userId,
//       String name,
//       String email,
//       String mobile,
//       String password,
//       String gender,
//       String accountType,
//       String birthdate,
//       String code) async {
// //    SharedPreferences pref = await SharedPreferences.getInstance();
//     //   userId = pref.getString("memberID");
//     CommonModel model;
//     String url = '${server_url}wallet/sendFeedback';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'name': name,
//         'email': email,
//         'mobile': mobile,
//         'password': password,
//         'account_type': "",
//         'username': "",
//         'country_code': "",
//         'gender': "",
//         'birthdate': "",
//         'tradesmen_type': "",
//       }),
//     );

//     print("getRecentTransactionHome ${jsonDecode(response.body)}");
//     if (response.statusCode == 200) {
//       model = CommonModel.fromJson(jsonDecode(response.body));
//       if (model.status == 1) {
//         return model;
//       } else {
//         return model;
//       }
//     } else {
//       print('Failed to getRecentTransactionHome.');
//       throw Exception('Failed getRecentTransactionHome api');
//     }
//   }
// }
