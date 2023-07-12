import 'dart:convert';

import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;
import '../../../api/ApiRepo.dart' as ApiRepo;

class ProperbuzHomeApi {
  static Future<List<dynamic>> getBedrooms() async {
    var response = await ApiRepo.getWithToken("api/bedroom_list.php");
    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      List<dynamic> bedrooms = response!.data;
      return bedrooms;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> fetchPriceRanges(int type) async {
    var response =
        await ApiRepo.postWithToken("api/price_list.php", {"type": type});

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      List<dynamic> ranges = response!.data['data'];
      return ranges;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> fetchLocations(
      String country, String keyword) async {
    print('url=api/location_search.php?country=$country&keyword=$keyword');
    var response = await ApiRepo.postWithToken(
        "api/location_search.php", {"country": country, "keyword": keyword});

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      List<dynamic> locations = response!.data['data'];
      return locations;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getPrices() async {
    var url = Uri.parse("https://www.bebuzee.com/webservices/price_list.php");
    var response = await http.get(url);
    if (response!.statusCode == 200 &&
        response!.body != null &&
        response!.body != "") {
      List<dynamic> prices = jsonDecode(response!.body)['message'];
      return prices;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> fetchWebLocations(
      String country, String keyword) async {
    var response = await ApiRepo.postWithToken(
        "api/webservices/location_search.php",
        {"country": country, "keyword": keyword});

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      List<dynamic> locations = response!.data['data'];
      return locations;
    } else {
      return [];
    }
  }
}
