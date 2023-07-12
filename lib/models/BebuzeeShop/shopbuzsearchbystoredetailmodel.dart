// To parse this JSON data, do
//
//     final shopbuzSearchByStoreDetails = shopbuzSearchByStoreDetailsFromJson(jsonString);

import 'dart:convert';

ShopbuzSearchByStoreDetails shopbuzSearchByStoreDetailsFromJson(String str) =>
    ShopbuzSearchByStoreDetails.fromJson(json.decode(str));

String shopbuzSearchByStoreDetailsToJson(ShopbuzSearchByStoreDetails data) =>
    json.encode(data.toJson());

class ShopbuzSearchByStoreDetails {
  ShopbuzSearchByStoreDetails({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory ShopbuzSearchByStoreDetails.fromJson(Map<String, dynamic> json) =>
      ShopbuzSearchByStoreDetails(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.storeId,
    this.userId,
    this.userName,
    this.userProfile,
    this.storeName,
    this.storeDetails,
    this.websiteLink,
    this.storeAddress,
    this.countryId,
    this.storeIcon,
    this.storeData,
  });

  int? storeId;
  int? userId;
  String? userName;
  String? userProfile;
  String? storeName;
  String? storeDetails;
  String? websiteLink;
  String? storeAddress;
  String? countryId;
  String? storeIcon;
  List<SearchByStoreDatum>? storeData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeId: json["store_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        userProfile: json["user_profile"],
        storeName: json["store_name"],
        storeDetails: json["store_details"],
        websiteLink: json["website_link"],
        storeAddress: json["store_address"],
        countryId: json["country_id"],
        storeIcon: json["store_icon"],
        storeData: List<SearchByStoreDatum>.from(
            json["store_data"].map((x) => SearchByStoreDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "user_id": userId,
        "user_name": userName,
        "user_profile": userProfile,
        "store_name": storeName,
        "store_details": storeDetails,
        "website_link": websiteLink,
        "store_address": storeAddress,
        "country_id": countryId,
        "store_icon": storeIcon,
        "store_data": List<dynamic>.from(storeData!.map((x) => x.toJson())),
      };
}

class SearchByStoreDatum {
  SearchByStoreDatum({
    this.subcategoryId,
    this.subcategoryName,
    this.productData,
  });

  int? subcategoryId;
  String? subcategoryName;
  List<ProductDatum>? productData;

  factory SearchByStoreDatum.fromJson(Map<String, dynamic> json) =>
      SearchByStoreDatum(
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
        productData: List<ProductDatum>.from(
            json["product_data"].map((x) => ProductDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subcategory_id": subcategoryId,
        "subcategory_name": subcategoryName,
        "product_data": List<dynamic>.from(productData!.map((x) => x.toJson())),
      };
}

class ProductDatum {
  ProductDatum({
    this.productId,
    this.productName,
    this.productDetails,
    this.productBrand,
    this.productColor,
    this.productPrise,
    this.sellingPrise,
    this.priseCurrency,
    this.buyLink,
    this.productImages,
    this.productWishlist,
    this.productReview,
    this.createdAt,
  });

  int? productId;
  String? productName;
  String? productDetails;
  String? productBrand;
  String? productColor;
  int? productPrise;
  int? sellingPrise;
  String? priseCurrency;
  String? buyLink;
  List<String>? productImages;
  bool? productWishlist;
  int? productReview;
  String? createdAt;

  factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
        productId: json["product_id"],
        productName: json["product_name"],
        productDetails: json["product_details"],
        productBrand: json["product_brand"],
        productColor: json["product_color"],
        productPrise: json["product_prise"],
        sellingPrise: json["selling_prise"],
        priseCurrency: json["prise_currency"],
        buyLink: json["buy_link"],
        productImages: List<String>.from(json["product_images"].map((x) => x)),
        productWishlist: json["product_wishlist"],
        productReview: json["product_review"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_details": productDetails,
        "product_brand": productBrand,
        "product_color": productColor,
        "product_prise": productPrise,
        "selling_prise": sellingPrise,
        "prise_currency": priseCurrency,
        "buy_link": buyLink,
        "product_images": List<dynamic>.from(productImages!.map((x) => x)),
        "product_wishlist": productWishlist,
        "product_review": productReview,
        "created_at": createdAt,
      };
}
