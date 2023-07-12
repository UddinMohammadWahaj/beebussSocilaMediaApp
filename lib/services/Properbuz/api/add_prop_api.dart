import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/add_feature_list_model.dart';
import 'package:bizbultest/models/Properbuz/add_fixture_list_model.dart';
import 'package:bizbultest/models/Properbuz/add_property_list_model.dart';
import 'package:bizbultest/models/Properbuz/edit_property_model.dart';
import 'package:bizbultest/models/Properbuz/listing_type_model.dart';
import 'package:bizbultest/services/Properbuz/api/add_facilities_model.dart';
import 'package:bizbultest/services/Properbuz/api/add_outin_space_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/multipart_file.dart' as diomulti;
import 'package:bizbultest/api/ApiRepo.dart' as ApiRepo;
import 'package:dio/dio.dart' as dio;

class AddPropertyAPI {
  static Future getEditPropertyDetail(String propId) async {
    var client = Dio();
    var url =
        'https://www.bebuzee.com/api/properties_view.php?user_id=${CurrentUser().currentUser.memberID}&property_id=$propId';
    print("prop edit ur;=$url");

    var formdata = FormData();
    var response = await ApiProvider().fireApi(url);
    print("prop edit response=${response!.data}");
    try {
      print("prop edit response inside=${response!.data}");

      return EditPropertModel.fromJson(response!.data['data'][0]);

      // return EditPropertModel.fromJson(response!.data['data']);
    } catch (e) {
      print("prop edit error=$e");
      // return EditPropertModel.fromJson(response!.data['data']);
    }
    // return await client
    //     .get(url)
    //     .then((value) => EditPropertModel.fromJson(value.data));
  }

  static Future dataTransmissionApi() async {
    var url = 'https://www.bebuzee.com';
    var data = await ApiProvider().fireApi;
  }

  static Future updateProperty(
    propId,
    Map<String, dynamic> dataMap,
    List<File> photos,
    imagPicked,
  ) async {
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var url = 'https://www.bebuzee.com/api/properties_edit.php';
    print("---- update Url=${url}");

    print("----- data=$dataMap  ");
    var formdata = FormData();

    if (imagPicked == true) {
      for (var file in photos) {
        formdata.files.addAll([
          MapEntry("image[]", await diomulti.MultipartFile.fromFile(file.path))
        ]);

        print("==== ${formdata.files}");
      }
    }

    String resturl = '';
    dataMap.forEach((key, value) {
      resturl += '&$key=$value';
    });
    resturl = resturl.replaceFirst('&', '?');
    print('inside 1=$url$resturl');
    return await client
        .post(url + resturl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }),
            // queryParameters: dataMap,
            data: formdata)
        .then((value) {
      print("inside");
      print("----- the response =${value.data}");
      return value.data;
    });
  }

  static Future postAddProperty(
      Map<String, dynamic> dataMap, FormData formData) async {
    var client = Dio();

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var url = 'https://www.bebuzee.com/api/property/addProperty';

    // var formdata = FormData();
    // for (var file in photos) {
    //   formdata.files.addAll([
    //     MapEntry("property_media[]",
    //         await diomulti.MultipartFile.fromFile(file.path))
    //   ]);
    // }
    // for (var file in photos2) {
    //   formdata.files.addAll([
    //     MapEntry(
    //         "floorplan[]", await diomulti.MultipartFile.fromFile(file.path))
    //   ]);
    // }

    // print("data=$dataMap photos${photos.length} floor${photos2.length}");

    // var resturl = [];

    // dataMap.forEach((key, value) {
    //   var val = '&$key=$value';
    //   resturl += val;
    // });
    // resturl = resturl.replaceFirst('&', '?');
    // print("resturl= ${resturl}");
    // print("data=$dataMap ${photos.length}");
    // String? token =
    //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID);
    // print("${url + resturl}");
    // var response = await client
    //     .post(url + resturl,

    //         data: formdata)
    //     .then((value) => value);
    // print("add response=${response!.data}");
    // return response!.data;
    dataMap.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });
    // String resturl = '';
    // dataMap.forEach((key, value) {
    //   resturl += '&$key=$value';
    // });
    // resturl = resturl.replaceFirst('&', '?');
    // print('inside 1=$url$resturl');
    return await client
        .post(url,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }),
            // queryParameters: dataMap,
            data: formData)
        .then((value) {
      print("inside");
      print("the response =${value.data}");
      return value.data;
    });
  }

  static Future<List<dynamic>> fetchLocations(
      String keyword, String country) async {
    var response = await ApiRepo.postWithToken("api/location_search.php", {
      "country": country,
      "keyword": keyword,
    });
    print(
        "message response=${response!.data} url='api/location_search.php?country=${country}&keyword=${keyword}'");
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      List<dynamic> locations = response!.data['data'];
      return locations;
    } else {
      return [];
    }
  }

  static Future<List<ListingTypeModel>> getListingType() async {
    var client = Dio();
    var url = Uri.parse('https://www.bebuzee.com/api/propertyListingType');
    var response = await client.getUri(url);
    print("Listing type response=$response");
    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);
      ListingType listinglist = ListingType.fromJson(response!.data['data']);

      print('Upload Success');
      return listinglist.listingtypelist;
    } else {
      return [];
    }
  }

  static Future<List<AddPropertyListModel>> getaddPropertyList() async {
    var url = Uri.parse('https://www.bebuzee.com/api/propertyTypeList');
    var client = Dio();

    var response = await client.getUri(url);
    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);

      AddPropertyList addPropertyList =
          AddPropertyList.fromJson(response!.data['data']);
      return addPropertyList.addpropertyList;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getCurrencyList() async {
    var client = Dio();
    var url = 'https://www.bebuzee.com/api/currencyList';
    print("currency response=");
    var resp = await client.get(url).then((value) => value.data['data']);
    print("currency response=$resp");

    return resp.map((e) => e['code']).toList();
  }

  static Future<List<dynamic>> getBedroomList() async {
    var client = Dio();

    var url = 'https://www.bebuzee.com/api/bedroomList';
    // var url = 'https://www.bebuzee.com/webservices/bedroom_list.php';
    print("bedroom api ");
    var resp = await client.get(url).then((value) => value.data['data']);
    print("bedroom response=${resp}");
    //  print("")
    var bedlist = resp.map((e) => e['bedroom']).toList();
    return bedlist;
    // return await client.get(url).then((value) => value.data['message']);
  }

  static Future<List<dynamic>> getMeasurementList() async {
    var client = Dio();
    var url = 'https://www.bebuzee.com/api/measureList';
    var resp = await client.get(url).then((value) => value.data['data']);
    return resp.map((e) => e['measurement']).toList();
  }

  static Future<List<dynamic>> getFloorNameList() async {
    var client = Dio();
    var url = 'https://www.bebuzee.com/api/floorList';

    var resp = await client.get(url).then((value) => value.data['data']);
    return resp.map((e) => e['floor_name']).toList();
  }

  static Future<List<dynamic>> getBathroomList() async {
    var client = Dio();
    var url = 'https://www.bebuzee.com/api/bathroomList';
    var resp = await client.get(url).then((value) => value.data['data']);
    print("bathroom response=${resp}");
    //  print("")
    var bathroomlist = resp.map((e) => e['bathroom']).toList();
    return bathroomlist;
    return await client.get(url).then((value) => value.data['bathroom']);
  }

  static Future<List<AddFeatureListModel>> getFeatureList() async {
    var url = Uri.parse('https://www.bebuzee.com/api/specialFeatureList');
    var response = await Dio().getUri(url);
    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      print('special feature response=${response!.data}');
      AddFeatureList addFeatureListModel =
          AddFeatureList.fromJson(response!.data['data']);
      return addFeatureListModel.addFeatureList;
    } else {
      return [];
    }
  }

  static Future<List<AddFixtureListModel?>?>? getFixtureList() async {
    var url = Uri.parse('https://www.bebuzee.com/api/fixtureList');
    print("fixtrelis=$url");
    var response = await Dio().getUri(url);
    print("fixtrelis=$url $response");

    try {
      if (response!.data['success'] == 1) {
        print('fixtrelis=' + response!.data.toString());
        AddFixtureList addFixtureListModel =
            AddFixtureList.fromJson(response!.data['data']);
        return addFixtureListModel.addfixtureList;
      } else {
        return [];
      }
    } catch (e) {
      print("fixtrelis=$e");
    }
  }

  static Future<List<dynamic>> getPreferencesList() async {
    var client = Dio();
    print('called preference');
    var url = 'https://www.bebuzee.com/api/preferenceList';
    var plist = await client.get(url).then((value) => value.data['data']);
    var resp = plist.map((e) => e['preference']).toList();
    return resp;
  }

  static Future<List<AddOutinSpaceListModel?>?>? getOutinSpaceList() async {
    var url = Uri.parse('https://www.bebuzee.com/api/outin_space_list.php');

    var response = await Dio().getUri(url);
    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);
      AddOutinSpaceList addOutinSpaceList =
          AddOutinSpaceList.fromJson(response!.data['data']);
      return addOutinSpaceList.addoutinspaceList;
      // } else {
      return [];
    }
  }

  static Future deleteImage(String imglink, String propid) async {
    var url =
        'https://www.bebuzee.com/api/properties_image_delete.php?property_id=$propid&url=$imglink';
    var response = await ApiProvider().fireApi(url);

    print("deleted success");
  }

  static Future<List<AddFacilitiesModel>> getFacilitiesList() async {
    // var url = Uri.parse(
    //     'https://www.bebuzee.com/webservices/properties_facility.php');
    var url = 'https://www.bebuzee.com/api/facility_list.php';
    var client = Dio();

    var response = await client.get(url);
    print("faciloities response=$response");
    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.data);
      AddFacilities addFacilitieslist =
          AddFacilities.fromJson(response!.data['data']);
      return addFacilitieslist.addfacilitiesList;
    } else {
      return [];
    }
  }
}
