import 'package:bizbultest/api/api.dart';
import 'package:get/get.dart';

import '../current_user.dart';

class BebuzeeWalletController extends GetxController {
  var response;
  var wallletHistoryList = <WalletModel>[].obs;
  var walletBal = ''.obs;
  void getWalletHistory() async {
    var response = await ApiProvider()
        .fireApi(
            'https://www.bebuzee.com/api/wallet_balance_history.php?user_id=${CurrentUser().currentUser.memberID}')
        .then((value) => value);
    if (response.data['success'] == 1) {
      print("response of wallet =${response.data['wallet_history']}");
      var res = WalletList.fromJson(response.data['wallet_history']);
      wallletHistoryList.value = res.walletList;
      walletBal.value = response.data['balance'];
    }
  }

  @override
  void onInit() {
    getWalletHistory();
    super.onInit();
  }
}

class WalletModel {
  var description;
  var credited;
  var debited;
  var creditedAt;

  WalletModel({
    this.description,
    this.credited,
    this.creditedAt,
    this.debited,
  });
  // "wallet_history": [
  //     {
  //         "description": "Testing Amount added\r\n",
  //         "credited": "8800",
  //         "debited": "0",
  //         "created_at": "1 day ago"
  //     }
  // ]
}

class WalletList {
  List<WalletModel> walletList;
  WalletList(this.walletList);
  factory WalletList.fromJson(List<dynamic> parsed) {
    List<WalletModel> walletList = [];
    walletList = parsed
        .map((e) => WalletModel(
            credited: e["credited"],
            creditedAt: e['created_at'],
            debited: e['debited'],
            description: e['description']))
        .toList();
    return WalletList(walletList);
  }
}
