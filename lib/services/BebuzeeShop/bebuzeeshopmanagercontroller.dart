import 'package:bizbultest/models/BebuzeeShop/shopbuzproductlistmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';
import '../../models/BebuzeeShop/merchantproductdetailmodel.dart';
import '../../models/BebuzeeShop/merchantproductsubcategorylistmode.dart';
import '../current_user.dart';

class BebuzeeShopManagerController extends GetxController {
  var wishlistdata = [].obs;
  var hascollection = false.obs;
  var subscriptionType = ''.obs;

  final shopmainrefreshController = RefreshController(
    initialRefresh: false,
  );

  var sortBy = ''.obs;
  toggleSortBy(currentSortBy) {
    if (currentSortBy == sortBy.value) {
      sortBy.value = '';
    } else {
      sortBy.value = currentSortBy;
    }
  }

  var submit = false.obs;
  var rating = [
    false,
    false,
    false,
    false,
    false,
  ].obs;
  void rate(index) {
    var dummyRate = [
      false,
      false,
      false,
      false,
      false,
    ];
    for (int i = 0; i <= index; i++) {
      dummyRate[i] = true;
    }
    rating.value = dummyRate;
  }

  var productList = <ShopBuzProductDatum>[].obs;
  var searchProductId = ''.obs;
  var searchProductKeyword = ''.obs;
  var searchProductCatId = ''.obs;
  var searchSubProductId = ''.obs;
  var currentPage = ''.obs;
  var currentFilterCatId = ''.obs;
  var bebuzeeshopapi = BebuzeeShopApi();
  var productSubCategoryList = <MerchantStoreProductSubCategoryDatum>[].obs;
  var visibilityKey = GlobalKey();
  var isContactVisible = false.obs;

  void fetchsubscriptionType() async {
    var data = await bebuzeeshopapi.getSubscriptionType();
    subscriptionType.value = data;
  }

  void refreshProducts() async {
    var dataSend = {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": searchProductKeyword,
      "category_id": searchProductCatId,
      "subcategory_id": searchSubProductId,
      "page": '1',
      'sort_by': sortBy.value
    };
    print("selected cat datasend=$dataSend");
    var data = await bebuzeeshopapi.getProductList(data: dataSend);

    productList.value = data;
    shopmainrefreshController.refreshCompleted();
    productList.refresh();
  }

  void loadProducts({page: '1'}) async {
    print("load products called $page");
    var dataSend = {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": searchProductKeyword,
      "category_id": searchProductCatId,
      "subcategory_id": searchSubProductId,
      "page": page,
      "sort_by": sortBy.value
    };
    print("selected cat datasend=$dataSend");
    var data = await bebuzeeshopapi.getProductList(data: dataSend);

    productList.addAll(data);
    shopmainrefreshController.loadComplete();
    productList.refresh();
  }

  void getProductSubCategoryList({catId: ''}) async {
    print("fliter section called $catId");
    productSubCategoryList.value =
        await bebuzeeshopapi.getProductSubCategoryList(catId);

    productSubCategoryList.refresh();
  }

// void getSimilarProducts()async{
//   await bebuzeeshopapi.add
// }
  void addToWishList(productId) async {
    await bebuzeeshopapi.addOrRemoveFromWishlist(productId);
  }

  var searchSubCatIds = ''.obs;
  var searchSubCatIdsList = <MerchantStoreProductSubCategoryDatum>[].obs;
  var listofstores = [
    {"store_id": "198", "store_name": "Adidas", "store_title": "store_plaza"}
  ].obs;
  var listofproductcategory = [
    {
      "category_id": 4,
      "category_name": "Appliances",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/appliances.jpg"
    },
    {
      "category_id": 8,
      "category_name": "Baby",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/baby.jpg"
    },
    {
      "category_id": 11,
      "category_name": "Beauty",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/beauty.webp"
    },
    {
      "category_id": 3,
      "category_name": "Clothing",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/clothing.jpg"
    },
    {
      "category_id": 2,
      "category_name": "Electronics",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/electronics.jpg"
    },
    {
      "category_id": 5,
      "category_name": "Games",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/games.jpg"
    },
    {
      "category_id": 9,
      "category_name": "Garden",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/garden.jpg"
    },
    {
      "category_id": 1,
      "category_name": "Grocery",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/grocery.jpg"
    },
    {
      "category_id": 16,
      "category_name": "Industrial",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/industrial.jpg"
    },
    {
      "category_id": 17,
      "category_name": "Party Supplies",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/party_supplies.webp"
    },
    {
      "category_id": 15,
      "category_name": "Pets",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/pets.png"
    },
    {
      "category_id": 13,
      "category_name": "Pharmacy",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/pharmacy.jpg"
    },
    {
      "category_id": 14,
      "category_name": "Sports",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/sports.jpg"
    },
    {
      "category_id": 7,
      "category_name": "Supplies",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/supplies.jpg"
    }
  ];

  String createCsvIds(List<MerchantStoreProductSubCategoryDatum> data) {
    var csv = '';

    data.forEach((element) {
      csv += element.subcategoryId.toString() + ',';
    });

    csv = csv.substring(0, csv.length - 1);
    print("selectedids=$csv");
    return csv;
  }

  void addIds(MerchantStoreProductSubCategoryDatum data) {
    searchSubCatIdsList.add(data);
    print("selected id=${data.subcategoryId}");

    searchSubCatIdsList.forEach((element) {
      print("${element.subcategoryId} aha");
    });
    searchSubCatIdsList.refresh();
  }

  void removeIds(MerchantStoreProductSubCategoryDatum data) {
    searchSubCatIdsList
        .removeWhere((element) => element.subcategoryId == data.subcategoryId);
    searchSubCatIdsList.refresh();
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

  void getProductByCategoryLst(categoryId) async {
    var dataSend = {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": '',
      "category_id": '$categoryId',
      "subcategory_id": '',
    };
    print("data send=${dataSend}");
    var data = await bebuzeeshopapi.getProductList(data: dataSend);
    productList.value = data;
    productList.refresh();
  }

  void getProductByKeywordLst(keyword) async {
    var dataSend = {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": keyword,
      "category_id": '',
      "subcategory_id": '',
    };
    print("data send=${dataSend}");
    var data = await bebuzeeshopapi.getProductList(data: dataSend);
    productList.value = data;
    productList.refresh();
  }

  void getProductList() async {
    var dataSend = {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": searchProductKeyword,
      "category_id": searchProductCatId,
      "subcategory_id": searchSubProductId
    };
    print("selected cat datasend=$dataSend");
    var data = await bebuzeeshopapi.getProductList(data: dataSend);
    productList.value = data;
    productList.refresh();
  }

  var tappedFilterByCat = false.obs;
  void toggleFilterByCat() {
    tappedFilterByCat.value = !tappedFilterByCat.value;
  }

  @override
  void onInit() {
    fetchsubscriptionType();
    super.onInit();
  }

  var wishlistselect = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ].obs;
  void addToWishlist(index) {
    wishlistselect[index] = !wishlistselect[index];
    wishlistselect.refresh();
  }

  var productDetail = <MerchantStoreProductDetailDatum>[].obs;
  void clearProductDetail() {
    productDetail.clear();
    productDetail.refresh();
  }

  void getProductDetail({productId: ''}) async {
    var data = await bebuzeeshopapi.getProductDetail(productId);
    productDetail.value = [data!];
  }
}
