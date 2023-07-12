import 'dart:collection';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/BebuzeeShop/merchantstorecurrencylistmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/merchantstoredetailsmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/merchantstorelistmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/shopbuzcollectionlistmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/shopbuzproductlistmodel.dart';
import 'package:bizbultest/models/BebuzeeShop/shopcountrymodel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/BebuzeeShop/collectionlistdatamodel.dart';
import '../../models/BebuzeeShop/colorlistmodel.dart';
import '../../models/BebuzeeShop/merchantproductdetailmodel.dart';
import '../../models/BebuzeeShop/merchantproductsubcategorylistmode.dart';
import '../../models/BebuzeeShop/merchantstoreproductcategorymodel.dart';
import '../../models/BebuzeeShop/merchantstoreproductlistmodel.dart';
import '../../models/BebuzeeShop/shopbuzcollectiondetailmodel.dart';
import '../../models/BebuzeeShop/shopbuzsearchbystoredetailmodel.dart';
import '../../models/BebuzeeShop/shopbuzwishlistlistmodel.dart';

class BebuzeeShopApi {
  var baseUrl = 'http://www.bebuzee.com/api';
  Future getMerchantAccountStatus({userId: ''}) async {
    var url = baseUrl + '/merchantAccountStauts';
    var response = ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!
    }).then((value) => value.data);

    return response;
  }



  Future<String> getSubscriptionType() async {
    var url = baseUrl + '/merchantAccountStauts';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!
    }).then((value) => value.data);

    if (response['status'] == 1) {
      print('subscription type=${response['data']['subscription_type']}');

      return response['data']['subscription_type'];
    }
    return '';
  }

  Future<String> bulkUpload(storeId, File? xmlfile) async {
    var url = baseUrl + '/bulkUploadProduct';
    var formdata = FormData();
    //  formdata.files.addAll(
    //       [MapEntry("store_icon", await MultipartFile.fromFile(logo.path))]);
    print(
        "bulkupload storeid=${storeId} ${CurrentUser().currentUser.memberID!}");
    formdata.fields.addAll([
      MapEntry("store_id", storeId.toString()),
      MapEntry("user_id", CurrentUser().currentUser.memberID!)
    ]);

    formdata.files
        .add(MapEntry("file", await MultipartFile.fromFile(xmlfile!.path)));
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, formdata: formdata)
        .then((value) => value);
    print("bulk upload response=${response.data}");
    return '';
  }

  Future<String> subscribeMerchant(String amount, String type) async {
    print("payment api called");
    var url =
        'http://www.bebuzee.com/api/merchantSubscribe?user_id=${CurrentUser().currentUser.memberID!}&amount=${amount}&type=$type';
    print('payment url=${url}');
    var response =
        await ApiProvider().fireApiWithParamsGet(url).then((value) => value);
    print("payment url=${response.data['url']}");
    return response.data['url'];
  }

  Future<List<ShopBuzProductDatum>> getSimilarProduct(productId) async {
    var url = baseUrl + '/productRelatedData';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "product_id": '${productId}'
    }).then((value) => value);
    return ShopBuzProductList.fromJson(response.data).data!;
  }

  Future deleteCollection(collectionId) async {
    var url = baseUrl + '/collectionDelete';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "collection_id": collectionId
    });
  }

  Future<ShopbuzCollectionDetailModel> getCollectionDetailApi(
      collectionId) async {
    var url = baseUrl + '/collectionDetail';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "member_id": CurrentUser().currentUser.memberID!,
      "collection_id": collectionId,
    }).then((value) => value);
    return ShopbuzCollectionDetailModel.fromJson(response.data);
  }

  Future addToCollection(String listofproductids, String collectionName) async {
    var url = baseUrl + '/collectionAdd';
    var response = await ApiProvider().fireApiWithParams(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "wishlist_ids": listofproductids,
      "collection_name": collectionName
    }).then((value) => value);
    print('collection add ${response.data['message']}');
  }

  Future addOrRemoveFromWishlist(productId) async {
    var url = baseUrl + '/wishlistAddRemove';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "product_id": productId
    });
    print("wishlist operation ${response.data}");
  }

  Future<List<ShopbuzWishlistListDatum>> getWishlistData() async {
    var url = baseUrl + '/wishlistData';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!
    }).then((value) => value);

    return ShopbuzWishlistListModel.fromJson(response.data).data!;
  }

  Future<List<SearchByStoreDatum>?> getSearchByStoreDetailModel(storeId) async {
    var url = baseUrl + '/storeProductData';
    var response = await ApiProvider().fireApiWithParamsGet(url,
        params: {"store_id": storeId}).then((value) => value);
    if (response.data['status'] == 0 || response.data['data'] == null)
      return null;
    return ShopbuzSearchByStoreDetails.fromJson(response.data).data!.storeData;
  }

  Future<List<ShopBuzProductDatum>> getProductList({data: ''}) async {
    var url = baseUrl + '/productData';
    print("productlist url=${url}");
    var response = await ApiProvider()
        .fireApiWithParamsGet(url, params: data)
        .then((value) => value);
    print("got product list=${response.data} ${data}");
    return ShopBuzProductList.fromJson(response.data).data!;
  }

  Future setPremiumAccount({premiumType: 'basic'}) async {
    var url = baseUrl + '/merchantAccountSet';
    var response = ApiProvider().fireApiWithParams(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "premium": premiumType,
    }).then((value) {
      return value.data;
    });
    return response;
  }

  Future getDetailsMerchant() async {
    var url = baseUrl + '/getMerchantDetails';
    var response =
        ApiProvider().fireApiWithParamsGet(url).then((value) => value.data);

    var data = response;
    print("dta of merchant id-${response}");
  }

  Future<List<ShopSettingsModelCountry>> getShopCountryList() async {
    var url = baseUrl + '/countryList';
    List<ShopSettingsModelCountry> list = [];
    print("get ship country called ${url}");
    var response = await ApiProvider().fireApiWithParamsGet(url).then((value) {
      return value.data['data'];
    });
    response.forEach((e) {
      list.add(ShopSettingsModelCountry.fromJson(e));
    });
    return list;
  }

  Future<List<MerchantStoreListDatum>> getStoreData() async {
    var url = baseUrl + '/userStoreData';
    var response = await ApiProvider().fireApiWithParamsGet(url,
        params: {"user_id": CurrentUser().currentUser.memberID!}).then((value) {
      print("store details=${value.data}");
      return value.data;
    });
    if (response['status'] != 0)
      return MerchantStoreList.fromJson(response).data!;
    else {
      print("no merchant data");
      return <MerchantStoreListDatum>[];
    }
  }

  Future<List<MerchantStoreCurrencyDatum>> getCurrencyList() async {
    var url = baseUrl + '/currencyList';
    var data = await ApiProvider().fireApiWithParamsGet(url).then((value) {
      print("currency list=${value.data}");
      return value.data;
    });
    return MerchantStoreCurrency.fromJson(data).data!;
  }

  Future<List<MerchantStoreProductCategoryDatum>>
      getProductCategoryList() async {
    var url = baseUrl + '/categoryList';
    var data = await ApiProvider().fireApiWithParamsGet(url).then((value) {
      print("categoty list=${value.data}");
      return value.data;
    });
    return MerchantStoreProductCategory.fromJson(data).data!;
  }

  Future<List<MerchantStoreProductListDatum>> fetchProducts(storeId) async {
    var url = baseUrl + '/userProductData';
    print("url of fetch product=$url");
    var data = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "store_id": storeId
    }).then((value) {
      print("product fetched ${value.data['data']}");
      return value.data;
    });
    return MerchantStoreProductList.fromJson(data).data!;
  }

  Future<List<WishlistCollectionDatum>> fetchCollectionDetail(id) async {
    var url = baseUrl + '/collectionDetails';
    var response = await ApiProvider().fireApiWithParamsGet(url,
        params: {"collection_id": id}).then((val) => val);
    if (response.data['status'] == 1) {
      return CollectionDetailListModel.fromJson(response.data)
          .data!
          .wishlistCollectionDatumData!;
    }
    return <WishlistCollectionDatum>[];
  }

  Future<List<ShopbuzCollectionListDatum>> fetchUserCollectionData() async {
    var url = baseUrl + '/collectionData';

    var data;
    try {
      print("fetch user collection=${CurrentUser().currentUser.memberID!}");
      data = await ApiProvider().fireApiWithParamsGet(url, params: {
        "user_id": CurrentUser().currentUser.memberID!
      }).then((value) => value);
    } catch (e) {
      print("fetch user collection error aaa=$e");
    }

    print("fetch user collection aaa=${data.data}");
    return ShopbuzCollectionListModel.fromJson(data.data).data!;
  }

  Future addProduct(data, List<File?> photos) async {
    var url = baseUrl + '/productAdd';
    var formData = FormData();

    for (var photo in photos)
      formData.files.addAll([
        MapEntry("product_images[]", await MultipartFile.fromFile(photo!.path))
      ]);
    try {
      await ApiProvider()
          .fireApiWithParamsData(url, data: formData, params: data)
          .then((value) {
        print("produc success ${value.data}");
      });
    } catch (e) {
      print("product upload error $e");
    }
  }

  Future updateProduct(data) async {
    var url = baseUrl + '/productEdit';
    var formData = FormData();

    // for (var photo in photos)
    //   formData.files.addAll([
    //     MapEntry("product_images[]", await MultipartFile.fromFile(photo.path))
    //   ]);

    await ApiProvider()
        .fireApiWithParamsData(url, data: formData, params: data)
        .then((value) {
      print("produc success ${value.data}");
    });
  }

  Future<List<MerchantStoreProductSubCategoryDatum>> getProductSubCategoryList(
      categoryId) async {
    var url = baseUrl + '/subCategoryList';
    var data = await ApiProvider().fireApiWithParamsGet(url,
        params: {"category_id": categoryId}).then((value) {
      print("sub category list=${value.data}");
      return value.data;
    });
    return MerchantStoreProductSubCategory.fromJson(data).data!;
  }

  Future<MerchantStoreProductDetailDatum?> getProductDetail(productId) async {
    var url = baseUrl + '/productDetails';

    var data = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "product_id": productId,
    }).then((value) {
      return value.data;
    });
    print("product detail=${data}");
    if (data['status'] == 0) {
      print("product detail=${data}");
      return null;
    }
    ;
    return MerchantProductDetail.fromJson(data).data;
  }

  Future deleteProductImage(productId, productImage) async {
    var url = baseUrl + '/productImageDelete';

    var data = await ApiProvider().fireApiWithParams(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "product_id": productId,
      "product_images": productImage
    });
    print("product image delete ${data.data}");
  }

  Future deleteAndUpdateProductImage(productId, productImage, File file) async {
    var url = baseUrl + '/productImageDelete';
    print("product image delete url=$url");
    var formdata = FormData();
    formdata.files.add(MapEntry(
        "product_image_file", await MultipartFile.fromFile(file.path)));
    print({
      "user_id": CurrentUser().currentUser.memberID!,
      "product_id": productId,
      "product_images": productImage
    });
    print("product image delete path=${file.path}");
    var data = await ApiProvider().fireApiWithParamsData(url,
        params: {
          "user_id": CurrentUser().currentUser.memberID!,
          "product_id": productId,
          "product_images": productImage
        },
        data: formdata);
    print("product image delete ${data.data}");
    return data.data['status'].toString() == '1'
        ? data.data['data']['product_images']
        : '';
  }

  Future deleteStore(storeid) async {
    var url = baseUrl + '/storeDelete';
    await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "store_id": storeid,
    }).then((value) {
      print("delete store=${value.data}");
    });
  }

  Future<List<ColorDatum>> getColorList() async {
    var url = baseUrl + '/colorList';
    var response =
        await ApiProvider().fireApiWithParamsGet(url).then((value) => value);
    return ColorListModel.fromJson(response.data).data!;
  }

  Future<List<ShopbuzStoreDetailsData>> getMerchantStoreDetaild(storeId) async {
    var url = baseUrl + '/storeDetails';
    var data = await ApiProvider().fireApiWithParamsGet(url, params: {
      "store_id": storeId,
      "user_id": CurrentUser().currentUser.memberID!
    }).then((value) => value);
    print(
        "merchant store detail=${data} storeId=$storeId ${CurrentUser().currentUser.memberID!}");
    return [ShopbuzStoreDetails.fromJson(data.data).data!];
  }

  Future updateMerchantStore(Map<String, dynamic> dataSend, File? photo) async {
    var url = baseUrl + '/storeEdit';
    var formData = FormData();
    if (photo != null) {
      formData.files.add(
          MapEntry("store_icon", await MultipartFile.fromFile(photo.path)));
    }
    await ApiProvider()
        .fireApiWithParamsData(url, params: dataSend, data: formData)
        .then((value) {
      print("store update=${value.data}");
    });
  }

  Future createMerchantStore(File? logo,
      {String storeCountry: '',
      String storeName: '',
      String storeDetails: '',
      String storeUrl: '',
      String storeAddress: '',
      String storeCountryId: '',
      String logopath: ''}) async {
    var url = baseUrl + '/storeCreate';
    var dio = new Dio();
    var formdata = FormData();
    print("response of upload");
    if (logo != null)
      formdata.files.addAll(
          [MapEntry("store_icon", await MultipartFile.fromFile(logo.path))]);

    print("url of publish=${url}");
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var data = {
      "user_id": "${CurrentUser().currentUser.memberID!}",
      "store_name": "$storeName",
      "store_details": "$storeDetails",
      "website_link": "$storeUrl",
      "store_address": "$storeAddress",
      "country_id": "$storeCountryId",
    };
    print("store data=$data");
    var client = dio.post(url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: formdata,
        queryParameters: {
          "user_id": "${CurrentUser().currentUser.memberID!}",
          "store_name": "${storeName}",
          "store_details": "$storeDetails",
          "website_link": "$storeUrl",
          "store_address": "$storeAddress",
          "country_id": "$storeCountryId",
        });

    return client;
  }
}
