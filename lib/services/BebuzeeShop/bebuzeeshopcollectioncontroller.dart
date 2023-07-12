import 'package:get/get.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';
import '../../models/BebuzeeShop/collectionlistdatamodel.dart';
import '../../models/BebuzeeShop/shopbuzcollectionlistmodel.dart';

class BebuzeeShopCollectionController extends GetxController {
  var hasCollection = false.obs;
  var bebuzeeshopapi = BebuzeeShopApi();
  var listofcollections = <ShopbuzCollectionListDatum>[].obs;
  var currentcollectionlist = <WishlistCollectionDatum>[].obs;
  void addToCollection(listofproductids, collectionName) async {
    await bebuzeeshopapi.addToCollection(listofproductids, collectionName);
  }

  void fetchCollecttionDetaillist(var collectionid) async {
    var data = await bebuzeeshopapi.fetchCollectionDetail(collectionid);
    currentcollectionlist.value = data;
  }

  void deleteCollection(index) async {
    await bebuzeeshopapi
        .deleteCollection(listofcollections[index].collectionId);
    listofcollections.removeAt(index);
    listofcollections.refresh();
  }

  void getUserCollection() async {
    var data = await bebuzeeshopapi.fetchUserCollectionData();
    listofcollections.value = data;
  }

  @override
  void onInit() {
    getUserCollection();
    super.onInit();
  }
}
