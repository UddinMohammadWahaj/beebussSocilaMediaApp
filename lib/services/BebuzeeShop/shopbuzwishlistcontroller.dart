import 'package:bizbultest/api/bebuzeeshopapis/bebuzeeshopapi.dart';
import 'package:bizbultest/models/BebuzeeShop/shopbuzwishlistlistmodel.dart';
import 'package:get/get.dart';

class ShopbuzWishlistController extends GetxController {
  var bebuzeeshopapi = BebuzeeShopApi();
  var wishlistlistdata = <ShopbuzWishlistListDatum>[].obs;
  var wishlistcategories = [].obs;
  var filterwishlistdata = <ShopbuzWishlistListDatum>[].obs;
  var currentSelectedCategory = 'All'.obs;
  var productForCollection = <ShopbuzWishlistListDatum>[].obs;
  void selectForCollection(index) {
    wishlistlistdata[index].isCollection!.value =
        !wishlistlistdata[index].isCollection!.value;
    var data = <ShopbuzWishlistListDatum>[];
    if (wishlistlistdata[index].isCollection!.isTrue) {
      productForCollection.add(wishlistlistdata[index]);
    } else {
      productForCollection.removeWhere(
          (element) => element.productId == wishlistlistdata[index].productId);
    }

    productForCollection.refresh();
  }

  void unselectForCollection(index) {}
  void getWishlistData() async {
    var data = await bebuzeeshopapi.getWishlistData();
    wishlistlistdata.value = data;
    getWishlistCat();
  }

  void filterWishlistByCat() {
    if (currentSelectedCategory.value != 'All') {
      print("currentfiltercat=${currentSelectedCategory.value}");

      var data = <ShopbuzWishlistListDatum>[];
      wishlistlistdata.forEach((element) {
        if (currentSelectedCategory.value == element.categoryName) {
          data.add(element);
        }
      });
      print("currentfiltercat data length=${data}");
      filterwishlistdata.value = data;
      filterwishlistdata.refresh();
    }
    // switch (currentSelectedCategory.value) {
    //   case 'All':
    //     break;
    //   default:
    //     print("currentfiltercat=${currentSelectedCategory.value}");

    //     var data = [];
    //     wishlistlistdata.forEach((element) {
    //       if (currentSelectedCategory.value == element.categoryName) {
    //         data.add(element);
    //       }
    //     });
    //     filterwishlistdata.value = data;
    //     filterwishlistdata.refresh();
    //     break;
    // }
  }

  void getWishlistCat() {
    var data = {};
    wishlistlistdata.forEach((element) {
      print("element=${element.categoryName}");
      data['${element.categoryName}'] = true;
    });
    print("wishlist categories data=${data}");

    data.forEach((key, value) {
      wishlistcategories.add('$key');
    });
    print("wishlist categories=${wishlistcategories}");
    wishlistcategories.refresh();
  }

  void removeWishlistData(productId) async {
    var data = await bebuzeeshopapi.addOrRemoveFromWishlist(productId);
    wishlistlistdata.removeWhere(
        (element) => element.productId.toString() == productId.toString());
    wishlistlistdata.refresh();

    print("removed from wishlist successfully");
  }

  void createCollection() async {}
  @override
  void onInit() {
    getWishlistData();
    // getWishlistCat();

    super.onInit();
  }
}
