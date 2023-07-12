import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/Tradesmen/requested_tradesmen_enqury_model.dart';

class TrademenMaincontroller extends GetxController {
  var isSubscribed = false.obs;
  void getSubscriptionStatus() async {
    var data =
        await TradesmanApi.fetchSubscriptionStatus().then((value) => value);
    isSubscribed.value = data;
  }

  var ispayloading = false.obs;
  var paymentUrl = ''.obs;
  void subscribe(amount, VoidCallback next) async {
    ispayloading.value = true;
    print("current tradesmentyp=${CurrentUser().currentUser.tradesmanType}");
    var data =
        await TradesmanApi.subscribeTradesmen(amount: amount, type: 'company');
    ispayloading.value = false;
    paymentUrl.value = data;
    print("pay url=${data}");
    next();
  }

  var listofcacallbacack = <RequestedTradesmenRecord>[].obs;
  void fetchCallback() async {
    var data =
        await TradesmanApi.fetchTradesmenEnquiry().then((value) => value);
    listofcacallbacack.value = data!;
  }

  @override
  void onInit() {
    getSubscriptionStatus();
    fetchCallback();
    super.onInit();
  }
}
