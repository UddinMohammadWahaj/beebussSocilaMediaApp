import 'package:bizbultest/api/api.dart';
import 'package:get/get.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';
import '../../models/BebuzeeShop/merchantproductsubcategorylistmode.dart';
import '../current_user.dart';

class BebuzeeShopMainController extends GetxController {
  var currentCategory = "".obs;
  var bebuzeeshopapi = BebuzeeShopApi();
  var textString = 'Start Speaking..'.obs;
  var isListen = false.obs;
  var productSubCategoryList = <MerchantStoreProductSubCategoryDatum>[].obs;
  void setCurrentCategory(int currentCat) {
    currentCategory.value = "$currentCat";
  }

  void getProductSubCategoryList({catId: ''}) async {
    productSubCategoryList.value =
        await bebuzeeshopapi.getProductSubCategoryList(catId);
    productSubCategoryList.refresh();
  }

  var baseUrl = 'https://properbuzcoin.com/api';
  void callProperbuzApi() async {
    print("properbuz new api success called");
    var url = baseUrl + '/shopperUserMerge';
    var response = await ApiProvider().fireApiWithParams(url, params: {
      "user_id": "${CurrentUser().currentUser.memberID}",
      "name": "${CurrentUser().currentUser.fullName}",
      "email": "${CurrentUser().currentUser.email}",
      "mobile": "${CurrentUser().currentUser.contactNumber}",
      "profile": "${CurrentUser().currentUser.image}"
    }).then((value) {
      print(
          "properbuz new api success ${CurrentUser().currentUser.fullName} ${CurrentUser().currentUser.email} ${CurrentUser().currentUser.contactNumber}");
    });
  }

  @override
  void onInit() {
    callProperbuzApi();
    super.onInit();
  }
}
