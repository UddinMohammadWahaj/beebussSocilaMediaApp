import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/models/user_subscription.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ProperbuzMenuController extends GetxController {
  var isAgent = false.obs;
  var isLoaded = false.obs;
  var isAlreadyMember = false.obs;

  getData() async {
    print('getting data ');

    String memberId = CurrentUser().currentUser.memberID!;
    //  String memberId = CurrentUser().currentUser.memberID;
    // https://www.version1.properbuz.com/premium_member
    UserSubscription userSubscription =
        await ApiProvider().getUserSubscriptionDetail(memberId);

    // print(userSubscription.premimum.toString() + memberId + "   :premium");

    isAlreadyMember.value = userSubscription?.premimum ?? false;

    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(memberId);

    print(objUserDetailModel.memebertype);

    print('got all data');

    // isAgent.value = true;

    if (objUserDetailModel.memebertype == "3") {
      isAgent.value = true;
    }

    isLoaded.value = true;
  }

  updateSubscription(String orderNumber) async {
    isLoaded.value = false;
    String memberId = CurrentUser().currentUser.memberID!;
    UserDetailModel objUserDetailModel =
        await ApiProvider().getUserDetail(memberId);
    var amount = objUserDetailModel.memebertype == 3 ? "99.99" : "29.99";
    await ApiProvider().updateSubscription(
        memberId, objUserDetailModel.memebertype!, orderNumber, amount);

    getData();
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
