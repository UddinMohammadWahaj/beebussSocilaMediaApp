import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/MostViewdPropertyModel.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MostViewedController extends GetxController {
  var currentIndex = 0.obs;
  var totalsales = 0.obs;

  // ignore: deprecated_member_use
  var lstMostViewdPropertyModel = <MostViewdPropertyModel>[].obs;
  // ignore: deprecated_member_use
  var lstMostRentalPropertyModel = <MostViewdPropertyModel>[].obs;
  // ignore: deprecated_member_use

  late TabController userPropertiesController;
  late TabController managePropertiesController;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  // var agentId = "3736";

  var mostViewLoder = false.obs;

  fetchData() async {
    String memberId = CurrentUser().currentUser.memberID!;
    mostViewLoder.value = true;
    List<MostViewdPropertyModel> data =
        await ApiProvider().mostViewedProperty(memberId);
    for (var i = 0; i < data.length; i++) {
      print("--- ${data[i].listingType!.toLowerCase()}");
      if (data[i].listingType == "1") {
        lstMostViewdPropertyModel.add(data[i]);
      } else {
        lstMostRentalPropertyModel.add(data[i]);
      }
    }
    mostViewLoder.value = false;
  }

  void switchTabs(int index) {
    currentIndex.value = index;
  }
}
