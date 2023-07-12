import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/PopularRealEstateMarketModel.dart';
import 'package:bizbultest/models/Properbuz/SearchTextLocationModel.dart';
import 'package:bizbultest/models/Properbuz/location_categories_model.dart';
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchByMapApi {
  static Future<String> getLocationName(LatLng latLng) async {
    var url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=AIzaSyBP5GiOKxigNkvU6tyUbhX3fZgavwPHbik';

    var client = Dio();
    print("location list called");
    return await client.get(url).then((value) {
      try {
        if (value.data != null) {
          var locname =
              Result.fromJson(value.data['results'][0]).formattedAddress;
          return locname!;
        } else
          return "Location Selected..";
      } catch (e) {
        return "Location Selected";
      }
    });
  }

  static Future<List<LocationCategoriesModel>> getSearchByName(
      double lat, double lng,
      {page}) async {
    var url =
        'https://www.bebuzee.com/api/properties_list_on_map_direction.php?latitude=$lat&longitude=$lng&page=$page';
    print("search by map name $url");
    var client = Dio();

    try {
      var response = await ApiProvider().fireApi(url);
      if (response.statusCode == 200 && response.data != null) {
        return LocationCategories.fromJson(response.data['data'])
            .lstloccatmodel;
      } else
        return <LocationCategoriesModel>[];
    } catch (e) {
      return <LocationCategoriesModel>[];
    }
    // return await client.(url).then((value) {
    //   if (value.statusCode == 200 && value.data != null) {
    //     return LocationCategories.fromJson(value.data).lstloccatmodel;
    //   } else
    //     return [];
    // });
  }

  static Future<List<LocationCategoriesModel?>?>? getMetroProperties(
      List<LatLng> lst,
      {String distance = "",
      page}) async {
    print("baal metro");
    List<String> latlist = [];
    List<String> longlist = [];
    latlist = lst.map((e) => '${e.latitude}').toList();
    longlist = lst.map((e) => '${e.longitude}').toList();
    print('baal $latlist');
    var client = Dio();
    String lststringlst = '', longstringlst = '';
    for (int i = 0; i < latlist.length; i++) {
      if (i == latlist.length - 1)
        lststringlst += latlist[i];
      else
        lststringlst += latlist[i] + ',';
    }
    for (int i = 0; i < longlist.length; i++) {
      if (i == longlist.length - 1)
        longstringlst += longlist[i];
      else
        longstringlst += longlist[i] + ',';
    }
    var url =
        'https://www.bebuzee.com/api/properties_list_on_map_by_metro.php?latitude=$lststringlst&longitude=$longstringlst&distance=$distance&page=$page';
    print("metro prop list url ## =$url");

    var response = await ApiProvider().fireApi(url);
    // print("metro prop list length ## =${response.data['data'].length}");

    try {
      if (response.data['success'] == 1 && response.data != null) {
        print("metro prop list 111");

        return LocationCategories.fromJson(response.data['data'])
            .lstloccatmodel;
      } else if (response.data['success'] == 0 || response.data == null) {
        print("metro prop list 44");
        return [];
      }
    } catch (e) {
      print("metro prop list errorrr  =$e");
      return [];
    }
  }

  static Future<List<Result>> getMetroStation(LatLng loc) async {
    // var url =
    //     'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=22.4793949%2C88.315858&radius=1500&type=subway_station&key=AIzaSyBP5GiOKxigNkvU6tyUbhX3fZgavwPHbik';
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?type=subway_station&key=AIzaSyBP5GiOKxigNkvU6tyUbhX3fZgavwPHbik';

    print("metro url =${url}");
    var client = Dio();
    // ignore: missing_return
    return await client.get(url).then((value) {
      if (value.statusCode == 200 && value.data['results'].length != 0) {
        ;
        try {
          print("data got bia ${value.data['results'][0]['name']}");
          var res = SearchTextLocationModel.fromJson(value.data);
        } catch (e) {
          print("data got error =${e}");
        }
        var res = SearchTextLocationModel.fromJson(value.data).results;
        print("ahh=${res![0].formattedAddress}");

        return SearchTextLocationModel.fromJson(value.data).results!;
      } else {
        return [];
      }
    });
  }

  static Future<List<Result>> getLocDetails(String query) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query%20&key=AIzaSyBP5GiOKxigNkvU6tyUbhX3fZgavwPHbik';

    print("called api yo $url");
    var client = Dio();
    // ignore: missing_return
    return await client.get(url).then((value) {
      if (value.statusCode == 200 && value.data['results'].length != 0) {
        try {
          print("data got bia ${value.data['results'][0]['name']}");
          var res = SearchTextLocationModel.fromJson(value.data);
        } catch (e) {
          print("data got error =${e}");
        }
        var res = SearchTextLocationModel.fromJson(value.data).results;
        print("ahh=${res![0].formattedAddress}");

        return SearchTextLocationModel.fromJson(value.data).results!;
      } else {
        return [];
      }
    });
  }

  static Future<List<LocationCategoriesModel?>?>? getPropertyDeatils(
    List<LatLng> lst, {
    String? searchtype,
    String? coltype,
    String? maxprice,
    String? bedroomcount,
    String? bathroomcount,
    String? propertytype,
    String? order,
    String? distance,
    String? fromPage,
    int? page,
    String type = '0',
  }) async {
    print(
        "final Data --- $page -- $type -- $coltype -- $maxprice -- $bedroomcount -- $bathroomcount -- $propertytype -- $order");

    var newlst = '';
    print("length of lst=${lst.length}");
    if (lst[0].latitude != lst[lst.length - 1].latitude &&
        lst[0].longitude != lst[lst.length - 1].longitude) {
      lst[lst.length - 1] = lst[0];
    }
    print("start latlng=${lst[0]} end latln =${lst[lst.length - 1]}");
    print("latlng list length=${lst.length}");

    for (int i = 0; i < lst.length; i++) {
      var element = lst[i];
      if (i != lst.length - 1) {
        newlst = newlst + '${element.latitude} ${element.longitude}' + ',';
      } else {
        newlst = newlst + '${element.latitude} ${element.longitude}';
      }
    }
    // lst.forEach((element) {
    //   newlst = newlst + '${element.latitude} ${element.longitude}' + ',';
    // });
    // newlst.replaceAll('(', '');
    // newlst.replaceAll(')', '');

    print("path = $newlst");

    var client = Dio();
    var mapUrl =
        'https://www.bebuzee.com/api/properties_list_on_map.php?coordinates=$newlst&type=0&page=$page&max_price=$maxprice&bedroom=$bedroomcount&page_type=popular&porderby=${order}&bathrooms=$bathroomcount&prop_type=$propertytype&col_name=$coltype';
    var travelUrl =
        'https://www.bebuzee.com/api/properties_list_on_map.php?coordinates=$newlst&type=2&page=$page&max_price=$maxprice&bedroom=$bedroomcount&page_type=popular&porderby=${order}&bathrooms=$bathroomcount&prop_type=$propertytype&col_name=$coltype&distance=$distance';
    var path = fromPage == "metro" ? travelUrl : mapUrl;

    print("final pathh = $path");
    print("final distance = $fromPage");

    debugPrint('$path');
    var response = await ApiProvider().fireApi(path);
    print("response =${response.data}");
    if (response.data['success'] == 1 && response.data != null) {
      print("success coordinate");

      return LocationCategories.fromJson(response.data['data']).lstloccatmodel;
    } else if (response.data['success'] == 0 || response.data == null) {
      print("success coordinate eles");

      return [];
    }
    // return await client.postUri(Uri.parse(path)).then((value) {
    //   print("hhh ${value.data}");
    //   if (value.statusCode == 200 && value.data != null) {
    //     print("success coordinate");

    //     return LocationCategories.fromJson(value.data).lstloccatmodel;
    //   } else {
    //     return [];
    //   }
    // });
  }
}
