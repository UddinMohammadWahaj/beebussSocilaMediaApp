import 'dart:io';

import 'package:bizbultest/api/bebuzeeshopapis/bebuzeeshopapi.dart';
import 'package:bizbultest/models/BebuzeeShop/colorlistmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/merchantproductdetailmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/merchantstorecurrencylistmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/merchantstoreproductlistmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/shopbuzproductlistmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/BebuzeeShop/merchantproductsubcategorylistmode.dart';
import '../../models/BebuzeeShop/merchantstoredetailsmodel.dart';
import '../../models/BebuzeeShop/merchantstorelistmodel.dart';
import '../../models/BebuzeeShop/merchantstoreproductcategorymodel.dart';
import '../../models/BebuzeeShop/shopcountrymodel.dart';
import '../current_user.dart';

class BebuzeeShopMerchantController extends GetxController {
  var storeid;

  BebuzeeShopMerchantController({Key? key, this.storeid});

  var colorlist = <ColorDatum>[].obs;
  var currentCategory = "".obs;
  var countryList = <ShopSettingsModelCountry>[].obs;
  var bebuzeeshopapi = BebuzeeShopApi();
  var currentCountry = 'Select Country'.obs;
  var currentFlagIcon = ''.obs;
  var currentCountryId = ''.obs;
  var currentStoreUrl = TextEditingController();
  var currentStoreDescription = TextEditingController();
  var currentStoreName = TextEditingController();
  var currentStoreAddress = TextEditingController();
  var pickedPhotosFile = false.obs;
  var photos = <File?>[].obs;
  var videos = <File>[].obs;
  var currencyList = <MerchantStoreCurrencyDatum>[].obs;
  var merchantstorelist = <MerchantStoreListDatum>[].obs;
  var currentCurrency = ''.obs;
  var currentCurrencyCode = ''.obs;
  var merchantproductList = <MerchantStoreProductListDatum>[].obs;
  var productCategorylist = <MerchantStoreProductCategoryDatum>[].obs;
  var productSubCategoryList = <MerchantStoreProductSubCategoryDatum>[].obs;
  var currentProductCategory = ''.obs;
  var productname = TextEditingController();
  var currentProductCategoryId = ''.obs;
  var currentProductSubCategory = ''.obs;
  var currentProductSku = ''.obs;
  var currentProductSubCategoryId = ''.obs;
  var currentstoreId = ''.obs;
  var productPrice = TextEditingController();
  var productSellingPrice = TextEditingController();
  var productBrand = TextEditingController();
  var productDescription = TextEditingController();
  var productVideoUrl = TextEditingController();
  var merchantStoreData = <ShopbuzStoreDetailsData>[].obs;
  var storeEditPhotos = <String?>[].obs;
  var storeEditPhotoFile = <File?>[].obs;
  var ismerchantstoreloading = false.obs;
  var pressedNext = false.obs;
  var pressedAddStore = false.obs;
  var pressedAddProduct = false.obs;
  var selectedColors = <ColorDatum>[].obs;

  unselectColor(index) {
    selectedColors.removeAt(index);
    selectedColors.refresh();
  }

  selectColor(ColorDatum color) {
    var selected = false;
    selectedColors.forEach((element) {
      if (element.colorId == color.colorId) {
        selected = true;
        return;
      }
    });
    if (!selected) {
      selectedColors.add(color);
      selectedColors.refresh();
    }
  }

  void refreshMerchantStoreData() {
    currentCountry.value = '';
    currentCountryId.value = '';
    currentStoreAddress.text = '';
    currentStoreDescription.text = '';
    currentStoreName.text = '';
    currentStoreName.text = '';
  }

  void getColorList() async {
    var data = await bebuzeeshopapi.getColorList().then((value) => value);
    colorlist.value = data;
  }

  void setMerchantStoreData(ShopbuzStoreDetailsData data) {
    print("merchant store data set=${data}");
    currentCountry.value = data.countryId.toString();
    currentCountryId.value = data.countryId.toString();
    currentStoreAddress.text = data.storeAddress.toString();
    currentStoreDescription.text = data.storeDetails.toString();
    storeEditPhotos.value = [data.storeIcon.toString()];
    currentStoreName.text = data.storeName.toString();
    currentCategory.value = '';
    currentStoreUrl.text = data.websiteLink.toString();
  }

  void pickVideoFiles() async {
    pickedPhotosFile.value = true;
    XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    List<XFile> allFiles = [video!];
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i].path));
      print("images length=${imgFiles.length}");

      videos.value = imgFiles;
      if (videos == null) {
        print("null photo");
      } else {
        print("image added ${videos.first} length ${videos.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  void fetchMerchantStoreDetails(storeId) async {
    var data = await bebuzeeshopapi.getMerchantStoreDetaild(storeId);
    merchantStoreData.value = data;
    setMerchantStoreData(merchantStoreData.value[0]);
  }

  var isproductlistloading = false.obs;
  void fetchProductList() async {
    var data;
    isproductlistloading.value = true;
    try {
      data = await bebuzeeshopapi.fetchProducts(storeid);
      merchantproductList.value = data;
      merchantproductList.refresh();
    } catch (e) {
      merchantproductList.value = [];
      merchantproductList.refresh();
    }
    isproductlistloading.value = false;

    print("product fetched ${data}");
  }

  void refreshAddProduct() {
    //   currentProductCategoryId,
    // currentProductSubCategoryId
    productname.text = '';
    productDescription.text = '';
    productBrand.text = '';

    productPrice.text = '';
    productSellingPrice.text = '';
    productVideoUrl.text = '';
    currentStoreUrl.text = '';
    photos.value = [];
  }

  String getSelectedColors() {
    if (selectedColors.length == 0) return '';
    var pickedColors =
        selectedColors.map((element) => element.colorId.toString()).toString();

    pickedColors = pickedColors.substring(1, pickedColors.length - 1);
    print("picked colors=${CurrentUser().currentUser.code}");
    return pickedColors;
  }

  void addProduct({
    storeId: '',
    categoryId: '',
  }) async {
    var data = {
      "user_id": "${CurrentUser().currentUser.memberID}",
      "store_id": storeid,
      "category_id": currentProductCategoryId,
      "subcategory_id": currentProductSubCategoryId,
      "product_name": productname.text,
      "product_details": productDescription.text,
      "product_brand": productBrand.text,
      "product_sku": "#eer458",
      "product_color": getSelectedColors(),
      "product_size": "8 inch",
      "product_prise": productPrice.text,
      "selling_prise": productSellingPrice.text,
      "prise_currency": currentCurrencyCode.value,
      "embed_video": productVideoUrl.text,
      "buy_link": currentStoreUrl.text,
      "country_id": CurrentUser().currentUser.code
      // "product_images[]": "file multiple"
    };
    print("store data=$data");
    await bebuzeeshopapi.addProduct(data, photos.value);
  }

  void pickPhotosFilesStore() async {
    pickedPhotosFile.value = true;
    List<XFile?> allFiles = [
      await ImagePicker().pickImage(source: ImageSource.gallery)
    ];
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i]!.path));
      print("images length=${imgFiles.length}");

      storeEditPhotoFile.value = imgFiles;
      if (photos == null) {
        print("null photo");
      } else {
        print("image added ${photos.first} length ${photos.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  void pickPhotosFiles() async {
    pickedPhotosFile.value = true;
    List<XFile> allFiles = await ImagePicker().pickMultiImage();
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i].path));
      print("images length=${imgFiles.length}");

      photos.value = imgFiles;
      if (photos == null) {
        print("null photo");
      } else {
        print("image added ${photos.first} length ${photos.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  void pickPhotosFilesProduct() async {
    pickedPhotosFile.value = true;
    List<XFile> allFiles = await ImagePicker().pickMultiImage();
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i].path));

      photos.value = imgFiles;
      if (photos == null) {
        print("null photo");
      } else {
        print("image added ${photos.first} length ${photos.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  void removestore(storeid, index) async {
    await bebuzeeshopapi.deleteStore(storeid);
    merchantstorelist.removeAt(index);
    merchantstorelist.refresh();
  }

  void getCurrencyList() async {
    currencyList.value = await bebuzeeshopapi.getCurrencyList();
    currencyList.refresh();
  }

  void getProductCategoryList() async {
    productCategorylist.value = await bebuzeeshopapi.getProductCategoryList();
    productCategorylist.refresh();
  }

  void getProductSubCategoryList({catId: ''}) async {
    productSubCategoryList.value =
        await bebuzeeshopapi.getProductSubCategoryList(catId);
    productSubCategoryList.refresh();
  }

  void getMerchantStores() async {
    ismerchantstoreloading.value = true;
    var data = await bebuzeeshopapi.getStoreData();
    print("merchant store list=$data");
    merchantstorelist.value = data;
    ismerchantstoreloading.value = false;
    merchantstorelist.refresh();
  }

  void updateStore() async {
    var dataSend = {
      "storeAddress": currentStoreAddress.text,
      "storeCountry": currentCountry.string,
      "storeCountryId": currentCountryId.value,
      "storeDetails": currentStoreDescription.text,
      "storeUrl": currentStoreUrl.text,
      "storeName": currentStoreName.text,
    };
    await bebuzeeshopapi.updateMerchantStore(dataSend,
        storeEditPhotoFile.length != 0 ? storeEditPhotoFile.first : null);
  }

  void publishStore() async {
    try {
      await bebuzeeshopapi.createMerchantStore(
          photos.length != 0 ? photos[0] : null,
          storeAddress: currentStoreAddress.text,
          storeCountry: currentCountry.string,
          storeCountryId: currentCountryId.value,
          storeDetails: currentStoreDescription.text,
          storeUrl: currentStoreUrl.text,
          storeName: currentStoreName.text,
          logopath: photos.length != 0 ? photos[0]!.path : '');
    } catch (e) {
      print("store error=$e");
    }
  }

  void getCountry() async {
    var response = await bebuzeeshopapi.getShopCountryList();
    if (response == null) return;

    var data = response;

    countryList.value = data;
    // data.map((e) => ShopSettingsModelCountry.fromJson(e)).toList();
    print("country list value=${countryList.length}");
    // currentFlagIcon.value = countryList
    //     .where((p0) => p0.countryName == currentCountry.value)
    //     .first
    //     .flagIcon;

    countryList.refresh();
  }

  void setCurrentCategory(int currentCat) {
    currentCategory.value = "$currentCat";
  }

//PRODUCT

  var productDetail = <MerchantStoreProductDetailDatum>[].obs;

  void clearProductDetail() {
    productDetail.clear();
    productDetail.refresh();
  }

  void getProductDetail({productId: ''}) async {
    var data = await bebuzeeshopapi.getProductDetail(productId);

    productDetail.value = [data!];
  }

//PRODUICTEND
  @override
  void onInit() {
    // getCountry();
    getMerchantStores();
    getColorList();
    super.onInit();
  }
}
