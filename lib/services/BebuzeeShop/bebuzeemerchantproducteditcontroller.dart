import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';
import '../../models/BebuzeeShop/colorlistmodel.dart';
import '../../models/BebuzeeShop/merchantproductdetailmodel.dart';
import '../../models/BebuzeeShop/merchantproductsubcategorylistmode.dart';
import '../../models/BebuzeeShop/merchantstorecurrencylistmodel.dart';
import '../../models/BebuzeeShop/merchantstorelistmodel.dart';
import '../../models/BebuzeeShop/merchantstoreproductcategorymodel.dart';
import '../../models/BebuzeeShop/merchantstoreproductlistmodel.dart';
import '../../models/BebuzeeShop/shopcountrymodel.dart';
import '../current_user.dart';

class BebuzeeMerchantProductEditController extends GetxController {
  var currentCategory = "".obs;
  BebuzeeMerchantProductEditController({this.currentProductId});
  var currentProductId;
  var countryList = <ShopSettingsModelCountry>[].obs;
  var bebuzeeshopapi = BebuzeeShopApi();
  var currentCountry = '${CurrentUser().currentUser.country}'.obs;
  var currentFlagIcon = ''.obs;
  var currentCountryId = ''.obs;
  var currentProductUrl = TextEditingController();
  var currentStoreDescription = TextEditingController();
  var currentStoreName = TextEditingController();
  var currentStoreAddress = TextEditingController();
  var pickedPhotosFile = false.obs;
  var photos = <String>[].obs;
  var updatePhotos = <File>[].obs;
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
  var currentProductSubCategoryId = ''.obs;
  var currentstoreId = ''.obs;
  var productPrice = TextEditingController();
  var productSellingPrice = TextEditingController();
  var productBrand = TextEditingController();
  var productDescription = TextEditingController();
  var productVideoUrl = TextEditingController();
  var productDetail = <MerchantStoreProductDetailDatum>[].obs;
  var selectedColors = <ColorDatum>[].obs;
  void clearProductDetail() {
    productDetail.clear();
    productDetail.refresh();
  }

  void parseProductColor() {}
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

  void setProductData() {
    productPrice.text = productDetail.value[0].productPrise.toString();
    productSellingPrice.text = productDetail.value[0].sellingPrise.toString();
    currentCurrency.value = productDetail.value[0].priseCurrency!;
    productVideoUrl.text = productDetail.value[0].embedVideo!;
    productBrand.text = productDetail.value[0].productBrand!;
    currentProductUrl.text = productDetail.value[0].buyLink!;
    productDescription.text = productDetail.value[0].productDetails!;
    productname.text = productDetail.value[0].productName!;
    currentProductCategory.value = productDetail.value[0].categoryName!;
    currentProductCategoryId.value = productDetail.value[0].categoryId!;
    currentProductSubCategory.value = productDetail.value[0].subCategoryname!;
    currentProductSubCategoryId.value = productDetail.value[0].subCategoryId!;
    photos.value = productDetail.value[0].productImages!;
  }

  void deleteImage({productId: '', productimage: ''}) async {
    await bebuzeeshopapi.deleteProductImage(productId, productimage);
  }

  void pickPhotosFiles(index) async {
    pickedPhotosFile.value = true;
    List<XFile> allFiles = await ImagePicker().pickMultiImage();
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i].path));
      print("images length=${imgFiles.length}");

      updatePhotos.value = imgFiles;
      if (updatePhotos == null || updatePhotos.length == 0) {
        print("null photo");
      } else {
        print(
            "image added ${updatePhotos.first} length ${updatePhotos.length}");
        var imageUrl = await deleteandUpdate(
          updatePhotos.first,
          productId: currentProductId,
          productimage: photos[index],
        );
        if (imageUrl.toString().isNotEmpty) {
          print("update image url=${imageUrl}");
          updatePhotos.clear();
          photos[index] = imageUrl.toString();
          photos.refresh();
        }
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  Future<String> deleteandUpdate(File file,
      {productId: '', productimage: ''}) async {
    return await bebuzeeshopapi.deleteAndUpdateProductImage(
        productId, productimage, file);
  }

  var colorlist = <ColorDatum>[].obs;

  void parseProductColors() {}
  void getColorList() async {
    print("get color edit");
    var data = await bebuzeeshopapi.getColorList().then((value) => value);
    colorlist.value = data;
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

  unselectColor(index) {
    selectedColors.removeAt(index);
    selectedColors.refresh();
  }

  void getProductDetail({productId: ''}) async {
    var data = await bebuzeeshopapi.getProductDetail(productId);

    print("product data edit id=${productId} ${data!.subCategoryname}");

    productDetail.value = [data!];
    var selcolors = <ColorDatum>[];
    var colorsid = [];
    if (data!.productColor != '') {
      var colordata =
          await bebuzeeshopapi.getColorList().then((value) => value);
      colorlist.value = colordata;
      colorsid = data.productColor!.split(',');
      print("selcolor = entered");
      print("colorsid=${colorsid}");
      colorlist.forEach((colorelement) {
        print("check color");
        colorsid.forEach((element) {
          print(
              "check color ${element.toString().trimLeft()}== ${colorelement.colorId.toString()}");

          if (element.toString().trimLeft() ==
              colorelement.colorId.toString()) {
            selcolors.add(colorelement);
            print(
                "check color got${element.toString().trimLeft()}== ${colorelement.colorId.toString()}");
          }
        });
      });
    } else {}
    selectedColors.value = selcolors;
    print(
        "selcolor =${selcolors} selected color=${selectedColors.value} ${colorlist}");
    selectedColors.refresh();
    setProductData();
  }

  String getSelectedColors() {
    if (selectedColors.length == 0) return '';
    var pickedColors =
        selectedColors.map((element) => element.colorId.toString()).toString();

    pickedColors = pickedColors.substring(1, pickedColors.length - 1);
    print("picked colors=${CurrentUser().currentUser.code}");
    return pickedColors;
  }

  void updateProduct() async {
    var data = {
      "user_id": "${CurrentUser().currentUser.memberID}",
      "product_id": currentProductId,
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
      "prise_currency": currentCurrency.value,
      "embed_video": productVideoUrl.text,
      "buy_link": currentProductUrl.text,
      "country_id": CurrentUser().currentUser.code,
      // "product_images[]": "file multiple"
    };
    print("store data=$data");
    await bebuzeeshopapi.updateProduct(data);
  }

  @override
  void onInit() {
    // getColorList();
    getProductDetail(productId: this.currentProductId);
    super.onInit();
  }
}
