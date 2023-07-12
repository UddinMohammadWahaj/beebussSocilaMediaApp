import 'package:bizbultest/models/BebuzeeShop/shopbuzproductlistmodel.dart';
import 'package:get/get.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';
import '../current_user.dart';

class BebuzeeShopSearchController extends GetxController {
  var searchProductList = <ShopBuzProductDatum>[].obs;
  var searchText = ''.obs;
  void searchProduct(searchText) async {
    var data;
    // Future.delayed(Duration(milliseconds: 200), () async {

    // });
    data = await BebuzeeShopApi().getProductList(data: {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": searchText
    });
    if (data != null) {
      searchProductList.value = data;
    }
  }

  @override
  void onInit() {
    debounce(searchText, (_) => searchProduct(searchText),
        time: Duration(milliseconds: 300));
    super.onInit();
  }
}
