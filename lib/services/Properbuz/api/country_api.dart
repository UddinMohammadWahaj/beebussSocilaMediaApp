import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/city_list_model.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../api/ApiRepo.dart' as ApiRepo;

class CountryAPI {
  static Future<List<CountryListModel>> fetchCountries() async {
    // var url = Uri.parse(
    //     'https://www.bebuzee.com/webservices/tradesmen_country_list.php');
    // var response = await http.get(url);
    var response = await ApiRepo.getWithToken("api/country_list.php");
    if (response.success == 1 && response.data != null && response.data != "") {
      print(response.data);
      CountryList countryList = CountryList.fromJson(response.data);
      return countryList.countrylist;
    } else {
      return [];
    }
  }

  static Future<List<CityListModel>> fetchCities(String country) async {
    var url = Uri.parse(
        //    'https://www.bebuzee.com/webservices/city_by_country.php?country=$country'

        'https://www.bebuzee.com/webservices//city_by_country_location_review.php?country=$country ');
    var newurl =
        'https://www.bebuzee.com/api/city_by_country_location_review.php?country=$country';
    var response = await ApiProvider().fireApi(newurl);
    print("fetch cities resp=$response");
    // var response = await http.get(url);
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      CityList cityList = CityList.fromJson(response.data['data']);
      return cityList.citylist;
    } else {
      return [];
    }
  }

  //! api need to updated
  static Future<List<dynamic>> fetchLocations(
      String keyword, String country) async {
    var url =
        "https://www.bebuzee.com/api/location_search.php?country=$country&keyword=$keyword";
    print("fetch location url=$url");
    var response = await ApiProvider().fireApi(url);
    print("fetch location response=${response.data}");
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      CityList cityList = CityList.fromJson(response.data['data']);
      //  locations = response.data['data'];
      return cityList.citylist;
    } else {
      return [];
    }
  }
}
