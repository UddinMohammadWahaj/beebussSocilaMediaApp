import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/location_categories_model.dart'
    as loccat;
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_list_model.dart';
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_overview_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../api/ApiRepo.dart' as ApiRepo;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PopularRealEstateAPI {
  static String getStreetView(String lat, String long) {
    var test1 = 'https://www.bebuzee.com/street-view?lat=$lat&lng=$long';
// https://www.bebuzee.com/street-view?lat=26.8466937&lng=80.946166
// https://properbuz.bebuzee.com/street_view_260419.php
    print("infooooo test $test1");
    return test1;
  }

  static String getNearbyLoc(String lat, String long, String type) {
    // var apiKey = "AIzaSyBP5GiOKxigNkvU6tyUbhX3fZgavwPHbik";
    print("neaarby loc called");
    // var url =
    // https://www.bebuzee.com/nearby?lat=26.8466937&lng=80.946166
    // https://properbuz.bebuzee.com/map_260419/near_by.php
    //     'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat%2C$long%20&radius=1500&type=restaurant&key=$apiKey';
    return 'https://www.bebuzee.com/nearby?lat=$lat&lng=$long&type=$type';
  }

  static Future<int> sharePropertyToFeed(String id, String shareUrl,
      {String msg = ""}) async {
    var client = Dio();

    var url =
        'https://www.bebuzee.com/api/share_property_feed_api.php?country=${CurrentUser().currentUser.country}&user_id=${CurrentUser().currentUser.memberID}&property_id=$id&message=$msg&prop_url=${shareUrl}';

    var response = await ApiProvider().fireApi(url);

    print("final share url =$url");
    print("shared prop response =${response!.data}");
    return response!.data['success'];
    // return await client.post(url).then((value) {
    //   print('shared prop ${value.data['success']}');
    //   return value.data['success'];
    // });
  }

  static Future<List<loccat.LocationCategoriesModel>> getData(
      String country, String city,
      {String page = "1"}) async {
    // print(
    //     "fetching url=  https://www.bebuzee.com/webservices/popular_properties_searched_by_city_list.php?user_id=${CurrentUser().currentUser.memberID}&col_name=latest&country=$country&city=$city&page=$page&page_type=popular");

    var url =
        'https://www.bebuzee.com/api/properties_filter.php?user_id=${CurrentUser().currentUser.memberID}&col_name=latest&cntry1=${country}&search_inp1=${city}&page=$page&page_type=popular&type=';

    print("popular fetch url =$url");
    var response = await ApiProvider().fireApi(url);
    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      print('popular response =${response!.data}');
      print("data from page=$page");
      loccat.LocationCategories locationCategoriesList =
          loccat.LocationCategories.fromJson(response!.data['data']);

      // print(
      //     'Upload Success called latitude=${locationCategoriesList.lstloccatmodel[0].lat} long=${locationCategoriesList.lstloccatmodel[0].long}');
      return locationCategoriesList.lstloccatmodel;
      // return listinglist.listingtypelist;
    } else {
      return [];
    }
  }

  static Future<List<PopularOverviewModel>> getPropertyDetails(
      String id) async {
    // 362261
    var client = Dio();
    // id = "362382";
    var url =
        "https://www.bebuzee.com/api/property_details_by_id.php?property_id=$id";
    var newurl =
        'https://www.bebuzee.com/api/property/propertyDetail?property_id=$id';
    print("here is the $url");
    var response = await ApiProvider().fireApiWithParamsGet(newurl);
    //  await ApiProvider().fireApi(url);
    print("here is response $response");
    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      try {
        print("${response!.data['data']}");

        PopularOverview pov =
            PopularOverview.fromJson([response!.data['data']]);
        return pov.lstpopoverviewmodel;
      } catch (e) {
        print("error occured $e");
        return [];
      }
    } else
      return [];
  }

  static Future unfollowAgent(String agentId) async {
    // var url =
    //     'https://www.bebuzee.com/webservices/unfollow_agent_api.php?user_id=${CurrentUser().currentUser.memberID}&agent_id=$agentId';

    // var client = Dio();
    // await client.post(url).then((value) {
    //   print("unfollowed the agent ${value.data}");
    // });
    var response = await ApiRepo.postWithToken("api/follow_agent_api.php",
        {"user_id": CurrentUser().currentUser.memberID, "agent_id": agentId});
    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);

      // String bedrooms = response!.data;
      // return bedrooms;
    } else {
      return [];
    }
  }

  static Future followAgent(String agentId) async {
    // var url =
    //     "https://www.bebuzee.com/webservices/follow_agent_api.php?user_id=${CurrentUser().currentUser.memberID}&agent_id=$agentId";
    // var client = Dio();
    // await client.post(url).then((value) {
    //   print('response=${value.data}');
    // });
    var response = await ApiRepo.postWithToken("api/follow_agent_api.php",
        {"user_id": CurrentUser().currentUser.memberID, "agent_id": agentId});

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);

      // List<dynamic> bedrooms = response!.data;
      // return bedrooms;
    } else {
      return [];
    }
  }

  static Future<List<loccat.LocationCategoriesModel>> getFilterDataList(
      String country, String city,
      {String searchtype = "",
      String coltype = "",
      String maxprice = "",
      String bedroomcount = "",
      String bathroomcount = "",
      String propertytype = "",
      String order = "",
      String? type,
      String page = "1"}) async {
    var url =
        'https://www.bebuzee.com/api/properties_filter.php?user_id=${CurrentUser().currentUser.memberID}&col_name=$coltype&cntry1=${country}&search_inp1=${city}&max_price=${maxprice}&bedroom=${bedroomcount}&page=${page}&page_type=popular&porderby=${order}&bathrooms=$bathroomcount&prop_type=$propertytype&type=$type';

    print("final filter url $url");

    var response = await ApiProvider().fireApi(url);
    print("load more resp=${response}");
    try {
      if (response!.statusCode == 200 &&
          response!.data != null &&
          response!.data != "") {
        loccat.LocationCategories listoffilter =
            loccat.LocationCategories.fromJson(response!.data['data']);
        print("data got success ${response!.data}");
        return listoffilter.lstloccatmodel;
      } else
        return [];
    } catch (e) {
      print("no load data");
      return [];
    }
  }

  static Future<List<dynamic>> getPriceListSale() async {
    // var client = Dio();
    // var url = 'https://www.bebuzee.com/webservices/price_list.php';

    var response = await ApiRepo.postWithToken("api/price_list.php", null);

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      print("get prices -- ${response!.data['data']}");
      List<dynamic> ranges = response!.data['data'];
      return ranges;
    } else {
      return [];
    }

    // return await client.get(url).then((value) {
    //   print("price list sale ${value}");
    //   return value.data['message'];
    // });
  }

  static Future<List<dynamic>> getPriceListRental() async {
    // var client = Dio();
    // var url = 'https://www.bebuzee.com/webservices/price_list_rental.php';
    var response = await ApiRepo.getWithToken("api/price_list_rental.php");
    // return await client.get(url).then((value) => value.data['message']);
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);

      print("get prices");
      List<dynamic> ranges = response!.data['data'];
      return ranges;
    } else {
      return [];
    }
  }
}
