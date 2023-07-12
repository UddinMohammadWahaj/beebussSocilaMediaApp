import 'package:bizbultest/api/bebuzeeshopapis/bebuzeeshopapi.dart';
import 'package:get/get.dart';

import '../../models/BebuzeeShop/merchantstoredetailsmodel.dart';
import '../../models/BebuzeeShop/merchantstorelistmodel.dart';
import '../../models/BebuzeeShop/shopbuzproductlistmodel.dart';
import '../../models/BebuzeeShop/shopbuzsearchbystoredetailmodel.dart';
import '../current_user.dart';

class ShopBuzSearchByStoreController extends GetxController {
  var merchantstorelist = <MerchantStoreListDatum>[].obs;
  var bebuzeeshopapi = BebuzeeShopApi();
  var merchantStoreData = <ShopbuzStoreDetailsData>[].obs;
  var merchantStoreProductDetails = <SearchByStoreDatum>[].obs;
  void getMerchantStores() async {
    var data = await bebuzeeshopapi.getStoreData();
    print("merchant store list=$data");
    merchantstorelist.value = data;
    merchantstorelist.refresh();
  }

  void getStoreProductData(storeId) async {
    var data = await bebuzeeshopapi.getSearchByStoreDetailModel(storeId);
    merchantStoreProductDetails.value = data!;
  }

  var productList = <ShopBuzProductDatum>[].obs;
  var viewall = false.obs;

  void fetchMerchantStoreDetails(storeId) async {
    print("store id=${storeId}");
    var data = await bebuzeeshopapi.getMerchantStoreDetaild(storeId);
    merchantStoreData.value = data;
    // setMerchantStoreData(merchantStoreData.value[0]);
  }

  void getProductListByFilterBySubCategory(String listofsubId) async {
    var dataSend = {
      "user_id": CurrentUser().currentUser.memberID,
      "subcategory_id": listofsubId
    };
    print("selected cat datasend=$dataSend");
    var data = await bebuzeeshopapi.getProductList(data: dataSend);
    productList.value = data;
    productList.refresh();
  }

  void getSeparatedStoreList() {}
  void contactMerchant() {}

  @override
  void onInit() {
    // TODO: implement onInit
    getMerchantStores();
    super.onInit();
  }
}
