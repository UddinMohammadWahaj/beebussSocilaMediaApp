import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/featured_properties_analytics_model.dart';
import 'package:bizbultest/models/Properbuz/hot_properties_model.dart';
import 'package:bizbultest/models/Properbuz/property_country_filter_model.dart';
import 'package:bizbultest/models/Properbuz/property_type_filter_model.dart';
import 'package:http/http.dart' as http;
import '../../../api/ApiRepo.dart' as ApiRepo;

import '../../current_user.dart';

class PropertyAPI {
  static final String memberID = CurrentUser().currentUser.memberID!;
  static final String country = "India";

  static Future<List<FeaturedPropertiesAnalyticsModel>>
      fetchFeaturedProperties() async {
    // var url = Uri.parse( 'https://www.bebuzee.com/webservices/get_manage_analytics_list.php?agent_id=1796768');

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properties_analytics_list.php", {"agent_id": "1796768"});

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      FeaturedPropertiesAnalytics properties =
          FeaturedPropertiesAnalytics.fromJson((response!.data['data']));
      return properties.properties;
    } else
      return [];
  }

  static Future<List<HotPropertiesModel>> fetchHotProperties(
      int page,
      String sort,
      int listingType,
      String countryID,
      String location,
      String minPrice,
      String maxPrice,
      String bedrooms,
      String propertyType) async {
    //var url = Uri.parse("https://www.bebuzee.com/webservices/hot_properties_list.php?page=$page&user_id=$memberID&sort=$sort&listing_type=${(listingType + 1)}&country_id=$countryID&location=$location&min_price=$minPrice&max_price=$maxPrice&bedrooms=$bedrooms&property_type=$propertyType");
    //print(url);
    // var response = await http.get(url);

    var newurl = 'https://www.bebuzee.com/api/property/filterPropertyList';

// /
    var params = {
      "page": page,

      "user_id": memberID,
      "sort_by": sort,
      // "user_id": memberID,
      // "sort": sort,
      'keyword': '',
      "location": location,
      "listing_type": listingType,
      "country_id": 101,
      "bedrooms": bedrooms,
      'bathrooms': '',
      "from_price": minPrice,
      "to_price": maxPrice,
      'min_area': '',
      'max_area': '',
      "property_type": propertyType,
    };
    print("filter property=${params} url=${newurl}");
    var response =
        await ApiProvider().fireApiWithParamsGet(newurl, params: params);

    // var response = await ApiRepo.postWithToken("api/hot_properties_list.php", {
    //   "page": page,
    //   //     "user_id":memberID,
    //   //      "sort_by":sort,
    //   "user_id": memberID,
    //   //     // "sort": sort,
    //   //     'keyword':'',
    //   //        "location": location,
    //   //     "listing_type": listingType,
    //   //     "country_id": countryID,
    //   //        "bedrooms": bedrooms,
    //   //        'bathrooms':'',
    //   //     "from_price": minPrice,
    //   //     "to_price": maxPrice,
    //   //  'min_area':'',
    //   //  'max_area':'',
    //   //     "property_type": propertyType,
    // });

    if (response!.data['data'] != null && response!.data['data'] != "") {
      // print('filter prop' + response!.data);
      HotProperties properties = HotProperties.fromJson(response!.data['data']);
      return properties.properties;
    } else {
      return [];
    }
  }

  static Future<List<HotPropertiesModel>> fetchManageProperties1(
      int page) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/saved_properties_list.php?page=$page&user_id=$memberID");
    // print(url);
    // var response = await http.get(url);
    var url =
        'https://www.bebuzee.com/api/get_my_reviews_list.php?user_id=${CurrentUser().currentUser.memberID}';
    print(
        "save property url= https://www.bebuzee.com/api/get_my_reviews_list.php?user_id=${CurrentUser().currentUser.memberID}");
    var response = await ApiProvider().fireApi(url);
    // var response = await ApiRepo.postWithToken(
    //     "api/saved_properties_list.php", {"page": page, "user_id": memberID});
    print("got saved ${response!.data}");

    if (response!.statusCode == 200 && response!.data['data'] != null) {
      print(response!.data['data']);
      print("got saved ${response!.data}");
      HotProperties properties = HotProperties.fromJson(response!.data['data']);
      return properties.properties;
    } else {
      return [];
    }
  }

  static Future<List<HotPropertiesModel>> fetchSavedProperties(int page) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/saved_properties_list.php?page=$page&user_id=$memberID");
    // print(url);
    // var response = await http.get(url);
    var url =
        'https://www.bebuzee.com/api/saved_properties_list.php?page=$page&user_id=${CurrentUser().currentUser.memberID}';

    var newurl =
        'https://www.bebuzee.com/api/property/savedProperty?user_id=${CurrentUser().currentUser.memberID}&page=$page';
    print("save property url= $newurl");
    var response = await ApiProvider().fireApiWithParamsGet(newurl);
    // var response = await ApiRepo.postWithToken(
    //     "api/saved_properties_list.php", {"page": page, "user_id": memberID});
    print("got saved ${response!.data}");

    if (response!.statusCode == 200 && response!.data['data'] != null) {
      print(response!.data['data']);
      print("got saved ${response!.data}");
      HotProperties properties = HotProperties.fromJson(response!.data['data']);
      return properties.properties;
    } else {
      return [];
    }
  }

// ====================================================================================================
  static Future<List<HotPropertiesModel>> fetchAlertpropperties(
      int page) async {
    var url =
        'https://www.bebuzee.com/api/alert_properties_list.php?page=$page&user_id=$memberID';
    var newurl =
        'https://www.bebuzee.com/api/property/alertProperty?user_id=16&page=1';

    print(
        "alert property url= https://www.bebuzee.com/api/alert_properties_list.php?page=$page&user_id=$memberID");
    var response = await ApiProvider()
        .fireApiWithParamsGet(newurl, params: {"page": page, "user_id": 16});

    // var response = await ApiRepo.postWithToken(
    //     "api/saved_properties_list.php", {"page": page, "user_id": memberID});
    print("got alert ${response!.data}");

    if (response!.statusCode == 200 && response!.data['data'] != null) {
      print(response!.data['data']);
      print("got alert ${response!.data}");
      HotProperties properties = HotProperties.fromJson(response!.data['data']);
      return properties.properties;
    } else {
      return [];
    }
  }

// ===================================================================================================
  static Future<List<HotPropertiesModel>> fetchSearchedProperties(
    int page,
    String minPrice,
    String maxPrice,
    int type,
    String bedrooms,
    String location,
    String countryID,
    String propertyType,
    String coltype,
    String order, {
    String sort: '',
    String listingType: '',
    String bathroom: '',
    String areaId: '',
  }) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properties_filter.php?page=$page&user_id=$memberID&location=$location&type=$type&min_price=$minPrice&max_price=$maxPrice&bedrooms=$bedrooms&country_id=$countryID&property_type=$propertyType");
    // print(url);
    // var response = await http.get(url);
    var url = 'https://www.bebuzee.com/api/property/filterPropertyList';
    var params = {
      "page": page,

      "user_id": memberID,

      "sort_by": sort,
      // "user_id": memberID,
      // "sort": sort,
      'keyword': '',
      "location": location,
      "listing_type": listingType,
      "country_id": 101,
      "bedrooms": bedrooms,
      'bathrooms': '',
      "from_price": minPrice,
      "to_price": maxPrice,
      'min_area': '',
      'max_area': '',
      'area_id': '',
      "property_type": propertyType,
    };
    print("filter property=${params} url=${url}");
    var response = await ApiProvider()
        .fireApiWithParamsGet(url, params: params)
        .then((value) => value);

    // var response = await ApiRepo.postWithToken("api/properties_filter.php", {
    //   "page": page,
    //   "user_id": memberID,
    //   "search_inp1": location,
    //   "type": type,
    //   "min_price": minPrice,
    //   "max_price": maxPrice,
    //   "bedrooms": bedrooms,
    //   "cntry1": country,
    //   "property_type": propertyType,
    //   // "listing_type": 2,
    //   "col_name": coltype,
    //   "order": order
    // });

    if (response!.data['status'] == 201 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print('search prop' + response!.data['data'].toString());
      print("got properties");
      HotProperties properties = HotProperties.fromJson(response!.data['data']);
      return properties.properties;
    } else {
      return [];
    }
  }

  static Future<void> savUnsaveProperty(String propID) async {
    var url =
        ' https://www.bebuzee.com/api/property/saveUnsaveProperty?user_id=$memberID&property_id=$propID';
    print("success fully saved url=$url");
    var response = await ApiProvider().fireApi(url);
    if (response!.statusCode == 200) {
      print("success fully saved the property");
    }
  }

// =====================================================================================
  static Future<void> addToalertsection(String propID) async {
    var url =
        'https://www.bebuzee.com/api/properties_alert_unalert.php?user_id=$memberID&property_id=$propID';
    print("success fully alert url=$url");
    var response = await ApiProvider().fireApi(url);
    if (response!.statusCode == 200) {
      print("success fully alert the property");
    }
  }

// ======================================================================

  static Future<bool> saveUnsave(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/news_feed_save_unsave.php?user_id=$memberID&post_id=$postID");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/news_feed_save_unsave.php",
        {"user_id": memberID, "post_id": postID});
    if (response!.success == 1) {
      print("save unsave=${response!.data}");
      bool savedStatus = response!.data['saved_status'];
      print(response!.data);
      return savedStatus;
    } else {
      return false;
    }
  }

  static Future<void> deleteProperty(String propertyID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/webservices/properties_delete.php?user_id=$memberID&property_id=$propertyID");
    // var response = await http.get(url);
    print(propertyID);
    var response = await ApiRepo.postWithToken("api/properties_delete.php",
        {"user_id": memberID, "property_id": propertyID});
    if (response!.success == 1) {
      print(response!.data);
    } else {}
  }

  static Future<List<PropertyCountryFilterModel>> fetchFilterCountries() async {
    //var url = Uri.parse( "https://www.bebuzee.com/webservices/tradesmen_country_list.php");
    //print(url);
    //var response = await http.get(url);

    var response = await ApiRepo.getWithToken("api/country_list.php");

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);
      PropertyCountries countries = PropertyCountries.fromJson(response!.data);
      return countries.countries;
    } else {
      return <PropertyCountryFilterModel>[];
    }
  }

  static Future<List<PropertyTypeFilterModel>>
      fetchFilterPropertyTypes() async {
    //var url =Uri.parse("https://www.bebuzee.com/webservices/properties_type.php");
    //print(url);
    //var response = await http.get(url);

    var response = await ApiRepo.getWithToken("api/properties_type_list.php");

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);
      PropertyTypes types = PropertyTypes.fromJson(response!.data);
      return types.types;
    } else {
      return <PropertyTypeFilterModel>[];
    }
  }
}
