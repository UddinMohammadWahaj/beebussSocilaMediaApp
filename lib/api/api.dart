import 'dart:convert';

import 'package:bizbultest/config/agora.config.dart' as config;
import 'package:bizbultest/models/AgoraCallDetailModel.dart';
import 'package:bizbultest/models/AlertPropertiesListModel.dart';
import 'package:bizbultest/models/CallHistoryModel.dart';
import 'package:bizbultest/models/MostViewdPropertyModel.dart';
import 'package:bizbultest/models/MyContactModel.dart';
import 'package:bizbultest/models/PopularRealEstateMarketModel.dart';
import 'package:bizbultest/models/Properbuz/property_buying_guide_model.dart';
import 'package:bizbultest/models/RecentlyLocationModel.dart';
import 'package:bizbultest/models/SavedPropertiesModel.dart';
import 'package:bizbultest/models/SearchPropertiesListModel.dart';
import 'package:bizbultest/models/TradeDescriptionModel.dart';
import 'package:bizbultest/models/TradesmanSearchModel.dart';
import 'package:bizbultest/models/Tradesmen/tradesmen_country_list_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmen_subcat_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmens_work_category_model.dart';
import 'package:bizbultest/models/TradesmenCountryModel.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/models/agoraRtcTokenModel.dart';
import 'package:bizbultest/models/deleteCallHistory.dart';
import 'package:bizbultest/models/getContactsModel.dart';
import 'package:bizbultest/models/refresh_token_model.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/models/user_subscription.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/services/login_api_calls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/ApiRepo.dart' as ApiRepo;
import '../models/Tradesmen/TradesmenWorkCategoryModel.dart';
import '../widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';

const String baseUrl = "https://www.bebuzee.com/";

class ApiProvider {
  Future<Response> fireApiWithParams(String url, {params}) async {

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var client = Dio();
    var finalurl = url;
    var response = await client.post(
      finalurl,
      queryParameters: params ?? {},
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  Future<String> getTheToken({from = ''}) async {
    String token = '';
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      token = sp.getString('token') ?? "";
      print(sp.getString('token').toString()+"this is main tokenn 456");
      if (token != null) return token;
      var responseToken = await Dio().post(
            baseUrl + 'api/auth/refresh',
            options: Options(
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer $token",
              },
            ),
          ).then((value) => value);

      print("on refresh call end $from=${responseToken.data['access_token']}");

      await sp.setString('token', responseToken.data['access_token']);
      return '${responseToken.data['access_token']}';
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      print(
          'Shared pref is empty $from $e ${prefs.getString('password')} ${prefs.getString('email')}');
      // var url = 'https://www.bebuzee.com/api/auth/login';
      // var response = await ApiProvider().fireApiWithParamsPost(url, params: {
      //   "email": prefs.getString('email'),
      //   "password": prefs.getString('password'),
      //   "firebase_token": ''
      // }).then((value) => value);
      // await prefs.setString('token', response.data['access_token']);
      // // print("Shared pref is empty response login=${response!.data}");
      // return '${response!.data["access_token"]}';
      return '';
    }

    print("error current $token  url=${baseUrl}api/auth/refresh");
  }

  Future<Response> fireApiWithParamsPostToken(String url,
      {params, formdata}) async {
    // String token =
    //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    String token = await ApiProvider().getTheToken();
    var client = Dio();

    var finalurl = url;
    var response = await client.post(finalurl,
        queryParameters: params ?? {},
        data: formdata,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }), onSendProgress: (int sent, int total) {
      final progress = (sent / total) * 100;
      print('upload progress: $progress');
    });
    // print('login response=${}')
    return response;
  }

  Future<Response> fireApiWithParamsPost(String url,
      {params, formdata, from = ''}) async {
    String token = '';
    if (from != 'login') {
      try {
        token = await ApiProvider().getTheToken();
      } catch (e) {
        print('error token $from=$e');
      }
    }
    var client = Dio();

    var finalurl = url;

    var response = await client.post(finalurl,
        queryParameters: params ?? {},
        data: formdata,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }), onSendProgress: (int sent, int total) {
      final progress = (sent / total) * 100;
      print('upload progress: $progress');
    });
    return response;
  }

  Future<Response> fireApiWithParamsGet(String url, {params, formdata}) async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var client = Dio();
    var finalurl = url;
    var response = await client.get(
      finalurl,
      queryParameters: params ?? {},
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  Future<Response> fireMusicApi(String url) async {
    var client = Dio();
    print("music data here response=$url ");
    var response;
    var token =
        'eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlA1NkM0SjZZNEQifQ.eyJpYXQiOjE2NTgxMzQ2NzMsImV4cCI6MTY2ODUwMjY3MywiaXNzIjoiNldRUkoyWFFZOSJ9.9BkiugwJ-PP7DCy8Ij_ZLLJqG_ePPmOj1-ZUxVzMF8GS0d-twHRkPiAd0ecboXgP_D_fRz-qPOQ-j4RE8v9tTA';

    response = await client
        .get(
          url,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);

    print("music data response=$response");
    return response;
  }

  Future<Response> fireApiWithParamsData(String url, {params, data}) async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var client = Dio();
    var finalurl = url;
    var response = await client.post(
      finalurl,
      queryParameters: params ?? {},
      data: data ?? {},
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  Future<Response> fireApi(String url) async {
    String? token = await ApiProvider().getTheToken();
    var client = Dio();
    var finalurl = Uri.parse(url);
    var response = await client.postUri(
      finalurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  Future<bool> appDevelopeAgora(String memberId, String agoraId) async {
    String query =
        "https://www.bebuzee.com/app_develope_agora.php?user_id=$memberId&agora_id=$agoraId";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().post(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<AgoraCallDetail> agoraCallDetail(String callerId, String receiverId,
      String type, String time, String length) async {
    AgoraCallDetail objAgoraCallDetail = new AgoraCallDetail();
    var timeZone = CurrentUser().currentUser.timeZone;

    var response = await ApiRepo.postWithToken("api/agora_add.php", {
      "agora_id": config.appId,
      "caller_id": callerId,
      "receiver_id": receiverId,
      "call_type": type,
      "call_time": time,
      "call_length": length,
      "timezone": timeZone,
    });

    if (response != null && response.success == 1) {
      objAgoraCallDetail = AgoraCallDetail.fromJson(response.data);
      return objAgoraCallDetail;
    } else {
      return objAgoraCallDetail;
    }
  }

  Future<CallHistoryModel> callHistory(String memberId) async {
    CallHistoryModel objCallHistoryModel = new CallHistoryModel();

    var response = await ApiRepo.postWithToken("api/agora_list.php", {
      "user_id": memberId,
    });

    if (response != null && response.success == 1) {
      objCallHistoryModel = CallHistoryModel.fromJson(response.data);
      print("agora_list --> ${response.data}");
      return objCallHistoryModel;
    } else {
      return objCallHistoryModel;
    }
  }

  Future<DeleteCallHistoryModel> deletecallHistory(
      String chatId, String type) async {
    DeleteCallHistoryModel objDeleteCallHistoryModel =
        new DeleteCallHistoryModel();

    var response = await ApiRepo.postWithToken(
        "api/agora_delete.php", {"agora_chat_id": chatId, "delete_type": type});

    if (response != null && response.success == 1) {
      objDeleteCallHistoryModel =
          DeleteCallHistoryModel.fromJson(response.data);
      print("agora_delete --> ${response.data}");
      return objDeleteCallHistoryModel;
    } else {
      return objDeleteCallHistoryModel;
    }
  }

  Future<UserDetailModel> getUserDetail(String userId) async {
    UserDetailModel objUserDetailModel = new UserDetailModel();

    var response = await ApiRepo.postWithToken("api/user/userDetails", {
      "action": "member_details_data",
      "user_id": userId,
    });
    print(response!.success);
    if (response.success == 1) {
      print(response.data);
      return objUserDetailModel = UserDetailModel.fromJson(response.data);
      print(objUserDetailModel);
    } else {
      return objUserDetailModel;
    }
  }

  //! updated api
  Future<bool> isAddToken(String userId, String token) async {
    try {
      var response =
          await ApiRepo.postWithToken("api/firebase_token_update.php", {
        "userId": userId,
        "firebase_token": token,
      });
      print(response!.success);
      if (response.success == 1) {
        print("firebase_token_update --> $response");
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<CallHistoryModel> callDetail(
      String memberId, String receiverId) async {
    CallHistoryModel objCallHistoryModel = new CallHistoryModel();

    var response = await ApiRepo.postWithToken("api/agora_history.php", {
      "user_id": memberId,
      "receiver_id": receiverId,
    });
    print(response!.success);
    if (response.success == 1) {
      print("agora_history --> ${response.data}");
      return objCallHistoryModel = CallHistoryModel.fromJson(response.data);
    } else {
      return objCallHistoryModel;
    }
  }

  Future<List<GetContactModel>> getContactDetail(String memberId) async {
    List<GetContactModel> lstGetContactModel = [];

    String query =
        "https://www.bebuzee.com/api/chat_contact_list.php?action=get_search_user&user_id=$memberId";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var locationX = jsonDecode(response.data);
        print(locationX.length);
        locationX.forEach((element) {
          GetContactModel objGetContactModel = new GetContactModel();
          objGetContactModel = GetContactModel.fromJson(element);
          lstGetContactModel.add(objGetContactModel);
        });
      }
    } catch (e) {
      print(e);
      return lstGetContactModel;
    }
    return lstGetContactModel;
  }

  Future<MyContactModel> myContacts(String userId) async {
    MyContactModel objMyContactModel = new MyContactModel();

    var response = await ApiRepo.postWithToken("api/relative_member_list.php", {
      "user_id": userId,
    });
    print(response!.success);
    if (response.success == 1) {
      print("relative_member_list --> ${response.data}");
      return objMyContactModel = MyContactModel.fromJson(response.data);
    } else {
      return objMyContactModel;
    }
  }

  Future<AgoraRtcTokenModel> agoraToken(
      String memberId, String channelName) async {
    AgoraRtcTokenModel objAgoraRtcTokenModel = new AgoraRtcTokenModel();

    String query =
        "http://www.bebuzee.com/agora/agoraRtcToken.php?user_id=$memberId&appID=${config.appId}&appCertificate=${config.certificate}&channelName=$channelName";
    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return objAgoraRtcTokenModel =
            AgoraRtcTokenModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
      return objAgoraRtcTokenModel;
    }
    return objAgoraRtcTokenModel;
  }

  Future<TwoFactorEnableModel> enableTwoFactor(
      String memberId, String pin, String email) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    // String query = "https://bebuzee.com/webservices/two_step_verification_add.php?user_id=$memberId&pin=$pin&email=$email";
    //
    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.postWithToken(
          "api/two_step_verification_add_update.php",
          {"user_id": memberId, "pin": pin, "email": email});

      print(response!.data);
      if (response.success == 1) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<TwoFactorEnableModel> disableTwoFactor(String memberId) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    // String query =
    //     "https://bebuzee.com/webservices/two_step_verification_remove.php?user_id=$memberId";
    //
    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response =
          await ApiRepo.postWithToken("api/two_step_verification_remove.php", {
        "user_id": memberId,
      });

      print(response!.data);
      if (response.success == 1) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<TwoFactorEnableModel> updatePIN(String pin, String memberId) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    // String query = "https://bebuzee.com/webservices/two_step_verification_update.php?user_id=$memberId&pin=$pin";
    //
    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.postWithToken(
          "api/two_step_verification_add_update.php",
          {"user_id": memberId, "pin": pin});

      print(response!.data);
      if (response.success == 1) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<TwoFactorEnableModel> updateEmail(
      String email, String memberId) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    // String query = "https://bebuzee.com/webservices/two_step_verification_update.php?user_id=$memberId&email=$email";
    //
    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.postWithToken(
          "api/two_step_verification_add_update.php",
          {"user_id": memberId, "email": email});

      print(response!.data);
      if (response.success == 1) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<TwoFactorEnableModel> updateItemsShop() {
    var memberId;
    var productImage;
    var productDescription;
    var productPrice;
    var productStore;
    var productId;
    var storeId;
    throw '';
  }

  Future<TwoFactorEnableModel> updatePhone(
      String countryCode, String memberId, String phoneNumber) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    // String query =
    //     "https://bebuzee.com/webservices/member_mobile_number_change.php?user_id=$memberId&countrycode=$countryCode&member_contact_no=$phoneNumber";
    //
    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };

    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response =
          await ApiRepo.postWithToken("api/member_number_update.php", {
        "user_id": memberId,
        "countrycode": countryCode,
        "member_contact_no": phoneNumber
      });

      print("member_number_update --> ${response!.data}");
      if (response.success == 1) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
      throw '';
    }
    return objTwoFactorEnableModel;
  }

  Future<TwoFactorEnableModel> contactUs(String memberId, String problem,
      {String image1 = "", String image2 = "", String image3 = ""}) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    String query =
        "https://bebuzee.com/webservices/setting_contact_us.php?user_id=$memberId&problem=$problem";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      Map<String, dynamic> data = {
        "image1": image1,
        "image2": image2,
        "image3": image3,
      };

      var response = await Dio().post(
        query,
        data: data,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<bool> chatNotificationSetting(
      String userId, int chatSend, int mediaVisibility, String fontSize) async {
    String query =
        "https://bebuzee.com/webservices/chat_notification_status.php?user_id=$userId&chat_send=$chatSend&meadia_visibility=$mediaVisibility&font_size=$fontSize";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };

    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<TwoFactorEnableModel> archiveAllChat(String memberId) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    String query =
        "https://bebuzee.com/webservices/chat_archive.php?user_id=$memberId";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<TwoFactorEnableModel> clearAllChat(String memberId) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    String query =
        "https://bebuzee.com/webservices/chat_clear.php?user_id=$memberId";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };

    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<TwoFactorEnableModel> deleteAllChat(String memberId) async {
    TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

    String query =
        "https://bebuzee.com/webservices/chat_delete.php?user_id=$memberId";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return objTwoFactorEnableModel =
            TwoFactorEnableModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return objTwoFactorEnableModel;
  }

  Future<List<SearchPropertiesList>> searchpropertiesList(String memberId,
      {page = '0',
      category = 'featured',
      keyword = '',
      listingtype = 'SALE'}) async {
    List<SearchPropertiesList> lstSearchPropertiesList = [];
// 'https://www.bebuzee.com/api/property/searchProperty?user_id=16&listing_type=SALE&keyword=delhi&property_category=featured&page=1'

    var url = 'https://www.bebuzee.com/api/property/searchProperty';
    var params = {
      "user_id": "16",
      "listing_type": listingtype,
      "keyword": keyword,
      'property_category': category,
      "page": page
    };
    print("params=$params");
    try {
      var response = await ApiProvider()
          .fireApiWithParamsGet(url, params: params)
          .then((value) => value);
      // var response =
      //     await ApiRepo.postWithToken("api/properties_search_list.php", {
      //   "user_id": memberId,
      // });
      print("--------------${response.data}----------------");
      if (response.data['status'] == 1) {
        response.data['data'].forEach((element) {
          SearchPropertiesList objSearchPropertiesList =
              new SearchPropertiesList();
          objSearchPropertiesList = SearchPropertiesList.fromJson(element);
          lstSearchPropertiesList.add(objSearchPropertiesList);
        });
      }
    } catch (e) {
      print(e);
    }
    return lstSearchPropertiesList;
  }

  Future<List<AlertProperiesList>> alertpropertiesList(String memberId) async {
    List<AlertProperiesList> lstAlertProperiesList = [];

    try {
      var response =
          await ApiRepo.postWithToken("api/alert_properties_list.php", {
        "user_id": memberId,
      });
      print("--------------${response!.success}----------------");
      if (response.success == 1) {
        response.data['data'].forEach((element) {
          AlertProperiesList objAlertProperiesList = new AlertProperiesList();
          objAlertProperiesList = AlertProperiesList.fromJson(element);
          lstAlertProperiesList.add(objAlertProperiesList);
        });
      }
    } catch (e) {
      print(e);
    }
    return lstAlertProperiesList;
  }

  Future<List<SavedPropertiesList>> savepropertiesList(String memberId) async {
    List<SavedPropertiesList> lstSavedPropertiesList = [];

    String query =
        "https://www.bebuzee.com/webservices/saved_properties_list.php?user_id=$memberId";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        response.data.forEach((element) {
          SavedPropertiesList objSavedPropertiesList =
              new SavedPropertiesList();
          objSavedPropertiesList = SavedPropertiesList.fromJson(element);
          lstSavedPropertiesList.add(objSavedPropertiesList);
        });
      }
    } catch (e) {
      print(e);
    }
    return lstSavedPropertiesList;
  }

  Future<List<PropertyBuyingModel>> proprtyBuying(int page, int limit,
      {type = ''}) async {
    List<PropertyBuyingModel> lstPropertyBuyingModel = [];

    // String query =
    //     "https://www.bebuzee.com/webservices/property_buying_list.php?page=$page&limit=$limit";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      var response = await ApiProvider().fireApiWithParamsGet(
          'https://www.bebuzee.com/api/property/propertyBuyingList?page=$page&type=$type',
          params: {"page": page});

      print(
          "url property=https://www.bebuzee.com/api/property/propertyBuyingList?page=$page&type=$type");
      // await ApiRepo.postWithToken(
      //     "api/property_buying_list.php", {"page": page, "limit": 1});
      print('property guide=${response.data}');
      if (response.data['success'] == 1) {
        response.data['data'].forEach((element) {
          PropertyBuyingModel objPropertyBuyingModel =
              new PropertyBuyingModel();
          objPropertyBuyingModel = PropertyBuyingModel.fromJson(element);
          lstPropertyBuyingModel.add(objPropertyBuyingModel);
        });
      }
    } catch (e) {
      print(e);
    }
    return lstPropertyBuyingModel;
  }

  // Future<List<PopularRealEstateMarketModel>> popularRealEstateMarket() async {
  //   List<PopularRealEstateMarketModel> lstPopularRealEstateModel = [];
  //   String query = 'https://www.bebuzee.com/api/popular_real_estate_market.php';

  //   Map<String, dynamic> head = {
  //     "Content-Type": "application/json",
  //   };
  //   try {
  //     var response = await Dio().get(query, options: Options(headers: head));
  //     if (response!.statusCode == 200) {
  //       print("----- response of ppopular ${response!.data}");
  //       response!.data['data'].forEach((element) {
  //         PopularRealEstateMarketModel objPopularRealEstateMarketModel =
  //             new PopularRealEstateMarketModel();
  //         objPopularRealEstateMarketModel =
  //             PopularRealEstateMarketModel.fromJson(element);
  //         lstPopularRealEstateModel.add(objPopularRealEstateMarketModel);
  //       });
  //     }
  //   } catch (e) {
  //     print("---- error ho gaya $e");
  //   }
  //   return lstPopularRealEstateModel;
  // }

  Future<List<PopularRealEstateMarketModel>> popularRealEstateMarket() async {
    List<PopularRealEstateMarketModel> lstPopularRealEstateModel = [];

    try {
      var response =
          await ApiRepo.getWithToken('api/popular_real_estate_market.php');

      print("country id=${CurrentUser().currentUser.code}");
      print("----- response success ${response.success}");
      if (response.success == 1) {
        print("----- response of ppopular ${response.data}");
        response.data.forEach((element) {
          print("----- response  $element");
          PopularRealEstateMarketModel objRecentlyLocationModel =
              new PopularRealEstateMarketModel();
          objRecentlyLocationModel =
              PopularRealEstateMarketModel.fromJson(element);
          lstPopularRealEstateModel.add(objRecentlyLocationModel);
        });
      }
    } catch (e) {
      print("---- error ho gaya $e");
    }
    return lstPopularRealEstateModel;
  }

  Future<List<RecentlyLocationModel>> recentlyAddedByLocation() async {
    List<RecentlyLocationModel> lstRecentlyLocationModel = [];

    // String query =
    //     "https://www.bebuzee.com/webservices/recently_added_by_location_list_cityname.php";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.getWithToken(
          'api/recently_added_by_location_list_cityname.php');

      print("----- response success ${response.success}");
      if (response.success == 1) {
        print("----- response of ppopular ${response.data}");
        response.data.forEach((element) {
          RecentlyLocationModel objRecentlyLocationModel =
              new RecentlyLocationModel();
          objRecentlyLocationModel = RecentlyLocationModel.fromJson(element);
          lstRecentlyLocationModel.add(objRecentlyLocationModel);
        });
      }
    } catch (e) {
      print("---- error ho gaya $e");
    }
    return lstRecentlyLocationModel;
  }

  Future<List<RecentlyLocationModel>> recentlyPropertiesSearch() async {
    List<RecentlyLocationModel> lstRecentlyLocationModel = [];

    // String query =
    //     "https://www.bebuzee.com/webservices/recent_properties_searched_by_city_list_cityname.php";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );
      var response = await ApiRepo.getWithToken(
          "api/recent_properties_searched_by_city_list_cityname.php");

      print(
          "-------------------------------------${response.success}-----------------------------------------------");
      if (response.success == 1) {
        response.data.forEach((element) {
          print("----- response of ppopular ${response.data}");
          RecentlyLocationModel objRecentlyLocationModel =
              new RecentlyLocationModel();
          objRecentlyLocationModel = RecentlyLocationModel.fromJson(element);
          lstRecentlyLocationModel.add(objRecentlyLocationModel);
        });
      }
    } catch (e) {
      print("---- error ho gaya $e");
    }
    return lstRecentlyLocationModel;
  }

  Future<List<MostViewdPropertyModel>> mostViewedProperty(
      String agentId) async {
    List<MostViewdPropertyModel> lstMostViewdPropertyModel = [];

    // String query =
    //     "https://www.bebuzee.com/webservices/most_viewed_property_list.php?user_id=$agentId";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.postWithToken(
          "api/most_viewed_property_list.php", {"user_id": agentId});

      print(response!.success);
      if (response.success == 1) {
        response.data['data'].forEach((element) {
          MostViewdPropertyModel objMostViewdPropertyModel =
              new MostViewdPropertyModel();
          objMostViewdPropertyModel = MostViewdPropertyModel.fromJson(element);

          lstMostViewdPropertyModel.add(objMostViewdPropertyModel);
        });
      }
    } catch (e) {
      print(e);
    }
    return lstMostViewdPropertyModel;
  }

  //! api update0d
  Future<List<WorkCategory>> tradsmenWorkCategory() async {
    List<WorkCategory> lstTradesmenWorkCategoryModel = [];

    // String query = "https://www.bebuzee.com/api/work_category.php";

    // print("==work category===");

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.getWithToken("api/work_category.php");

      print(response.success);

      if (response.success == 1) {
        TradesmensWorkCategoryModel _tradesmenWorkCategoryModel =
            TradesmensWorkCategoryModel.fromJson(response.toJson());

        lstTradesmenWorkCategoryModel =
            _tradesmenWorkCategoryModel.workCategory!;
      }
    } catch (e) {
      print(e);
    }
    print("======sending response 11111 ===== $lstTradesmenWorkCategoryModel");
    return lstTradesmenWorkCategoryModel;
  }

  //! api updated
  Future<List<TradesmenSubCatModelWorkSubCategory>> tradsmenSubWorkCategory(
      String catId) async {
    List<TradesmenSubCatModelWorkSubCategory> lstTradesmenWorkCategoryModel =
        [];

    // String query =
    //     "https://www.bebuzee.com/api/work_sub_category.php?trade_cat_id=$catId";

    // String token = await refreshToken(CurrentUser().currentUser.memberID!);

    // Map<String, dynamic> head = {
    //   "Accept": "application/json",
    //   "Authorization": "Bearer $token",
    // };
    try {
      // var response = await Dio().post(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );
      var formData = FormData();
      formData.fields.addAll([MapEntry("trade_cat_id", catId)]);
      var response = await ApiProvider().fireApiWithParamsPost(
          'http://www.bebuzee.com/api/tradesmen/getTradeSubCategory',
          formdata: formData,
          params: {"trade_cat_id": catId}).then((value) => value);
      // var response = await ApiRepo.postWithToken(
      //     "api/work_sub_category.php", {"trade_cat_id": catId});

      print('subcatresp-${response.data}');

      TradesmenSubCatModel _sub = TradesmenSubCatModel.fromJson(response.data);

      lstTradesmenWorkCategoryModel = _sub.workSubCategory!;
    } catch (e) {
      print('error=$e');
    }
    return lstTradesmenWorkCategoryModel;
  }

  //! api updated
  Future<List<TradesCountry>> tradesmenCountry() async {
    List<TradesCountry> lstTradesmenCountryModel = [];
    print("==calling country api===");
    // String query = "https://www.bebuzee.com/api/country_list.php";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.getWithToken("api/country_list.php");

      print(response.success);
      // print(response!.data);
      if (response.success == 1) {
        TradesmenCountryListModel _countries =
            TradesmenCountryListModel.fromJson(response.toJson());

        lstTradesmenCountryModel = _countries.country!;
      }
    } catch (e) {
      print(e);
    }
    return lstTradesmenCountryModel;
  }

  Future<List<TradsmenWorkLocationModel>> tradsmenWorkLocation(
      String countryId) async {
    List<TradsmenWorkLocationModel> lstTradsmenWorkLocationModel = [];

    String query =
        "https://bebuzee.com/webservices/tradesmen_work_location.php?country_id=$countryId";
    print("query=$query");
    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().get(
        query,
        options: Options(
          headers: head,
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        response.data.forEach((element) {
          TradsmenWorkLocationModel objlstTradsmenWorkLocationModel =
              new TradsmenWorkLocationModel();
          objlstTradsmenWorkLocationModel =
              TradsmenWorkLocationModel.fromJson(element);
          lstTradsmenWorkLocationModel.add(objlstTradsmenWorkLocationModel);
        });
      }
    } catch (e) {
      print(e);
    }
    return lstTradsmenWorkLocationModel;
  }

  static Future<List<searchTradesmenData>> tradsmenSearch(
    String catId,
    String subCatId,
    String countryId,
    String location,
    String shortBy,
    String keyWords,
    double latitude,
    double longitude,
    int distance,
    String typeofWork,
  ) async {
    List<searchTradesmenData> lstTradesmanSearchModel1 = [];
    print(
        "object.. catId : $catId countryId : $countryId location : $location subCatId : $subCatId latitude: $latitude longitude : $longitude shortby: $shortBy keywords: $keyWords distance : $distance work_type : $typeofWork");
    try {
      var response =
          await ApiRepo.postWithToken("api/tradesman_search_list.php", {
        "category": catId,
        "country": countryId,
        "location": location,
        "subcategory": subCatId,
        "shortby": shortBy,
        "keywords": keyWords,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "work_type": typeofWork,
      });

      // print(" 11  --- ressss -- 11 ${response!.success}");
      if (response!.success == 1) {
        response.data['data'].forEach((element) {
          searchTradesmenData objTradesmanSearchModel =
              new searchTradesmenData();
          objTradesmanSearchModel = searchTradesmenData.fromJson(element);
          lstTradesmanSearchModel1.add(objTradesmanSearchModel);
        });
        print("objevevev$lstTradesmanSearchModel1");
      } else if (response.success == 0 || response.data == null) return [];
    } catch (e) {
      print("EROOROR------------$e");
    }
    return lstTradesmanSearchModel1;
  }

  static Future<ReviewData?> reviewDataList(tradesmanId, companyId) async {
    var response =
        await ApiRepo.postWithToken('api/tradesmen_review_list.php', {
      "tradesman_id": tradesmanId,
      "company_id": companyId,
    });

    print("responsssssss 14 == ${response!.data}");

    if (response.success == 1 &&
        response.data['data'] != null &&
        response.data['data'] != "") {
      print("responsssssss == ${response.data['data']}");

      return ReviewDataListModel.fromJson(response.data).data;
    } else if (response.success == 0) {
      throw '';
    } else if (response.data == null) {
      return null;
    } else if (response.status == 0) {
      print("ERRORORRO------------${response.message}");
      return ReviewDataListModel.fromJson(response.data).data;
    }
    return null;
  }

  static Future<List<RequestedData>?> RequestList() async {
    var apiPart = 'https://www.bebuzee.com/api/user/followUnfollow';
    var Part = '';
    var test = '';
    var api = '';
    print('api=$api');
    var response =
        await ApiRepo.postWithToken('api/tradesmen_enquiry_data.php', {
      "user_id": CurrentUser().currentUser.memberID!,
    });
    if (response!.success == 1) {
      if (response.success == 1 &&
          response.data['data'] != null &&
          response.data['data'] != "") {
        print("responsssssss == ${response.data['data']}");
        return RequestedListModel.fromJson(response.data).data!;
      } else
        print('e1111-------');
      return [];
    } else if (response.success == 0) {
      return RequestedListModel.fromJson(response.data).data = [];
    } else if (response.data == null) {
      return [];
    }
    return null;
  }

  static Future<List<enquiryData>> enquiryList(tradesmenId, companyId) async {
    var response =
        await ApiRepo.postWithToken('api/tradesmen_enquiry_list.php', {
      // "user_id": CurrentUser().currentUser.memberID!,
      "tradesman_id": tradesmenId,
      "company_id": companyId,
    });
    if (response!.success == 1) {
      if (response.success == 1 &&
          response.data['data'] != null &&
          response.data['data'] != "") {
        print("responsssssss == ${response.data['data']}");
        return enquiryListDataModel.fromJson(response.data).data!;
      } else
        print('e1111-------');
      return [];
    } else if (response.success == 0) {
      print("==== #### 3");
      return enquiryListDataModel.fromJson(response.data).data = [];
    } else if (response.data == null) {
      print("==== #### 4");
      return [];
    }
    return [];
  }

  static Future<List<serviceData>?> ServiceDataList(
      tradesmanId, companyId) async {
    var response = await ApiRepo.postWithToken('api/tradesmen_service.php', {
      // "user_id": CurrentUser().currentUser.memberID!,
      "tradesman_id": tradesmanId,
      "company_id": companyId,
    });

    if (response!.success == 1 &&
        response.data['data'] != null &&
        response.data['data'] != "") {
      print("responsssssss == ${response.data['data']}");
      return serviceDataModel.fromJson(response.data).data!;
    } else if (response.success == 0) {
      print("==== #### 3");
      return null;
      // serviceDataModel.fromJson(response!.data).data = [];
    } else if (response.data == null) {
      print("==== #### 4");
      return null;
    }
    return null;
  }

  static Future<List<AlbumData>?> AlbumListData(tradesmanId, companyId) async {
    print("==== #### responss3334 == $companyId $tradesmanId");
    var response = await ApiRepo.postWithToken('api/tradesmen_gallery.php', {
      // "user_id": CurrentUser().currentUser.memberID!,
      "tradesman_id": tradesmanId,
      "company_id": companyId,
    });
    print("==== #### responss3334 == ${response!.success}");

    if (response.success == 1 &&
        response.data['data'] != null &&
        response.data['data'] != "") {
      print("==== #### responsssssss333 == ${response.data['data']}");
      return AlbumListModel.fromJson(response.data).data!;
    } else if (response.success == 0) {
      print("==== #### 333");
      return AlbumListModel.fromJson(response.data).data = [];
    } else if (response.data == null) {
      print("==== #### 4333");
      return [];
    }
    return null;
  }

  Future<TradeDescriptionModel?>? tradDescription(String serviceId) async {
    late TradeDescriptionModel objTradeDescriptionModel;

    // String query =
    //     "https://www.bebuzee.com/webservices/get_trade_description_list.php?key=$serviceId";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response = await ApiRepo.postWithToken(
          "api/trade_description_list.php", {"key": serviceId});
      print(response!.success);
      if (response.success == 1) {
        objTradeDescriptionModel =
            TradeDescriptionModel.fromJson(response.data);
        // response!.data.forEach((element) {
        //   TradeDescriptionModel objTradeDescriptionModel = new TradeDescriptionModel();
        //   lstTradeDescriptionModel.add(objTradeDescriptionModel);
        // });
      }
    } catch (e) {
      print(e);
    }
    return objTradeDescriptionModel;
  }

//TODO:: inSheet 347
  Future<void> updateSubscription(String memberId, String memberType,
      String orderNumber, String amount) async {
    // String query =
    //     "https://www.bebuzee.com/webservices/premimum_successful_subscription.php?user_id=$memberId&member_type=$memberType&transaction_id=$orderNumber&transaction_type=one time&transaction_status=success&amount=$amount";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().post(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );
      var response = await ApiRepo.postWithToken(
          "api/premimum_successful_subscription.php", {
        "user_id": memberId,
        "member_type": memberType,
        "transaction_id": orderNumber,
        "transaction_type": "one time",
        "transaction_status": "success",
        "amount": amount
      });
      print(response!.success);
      print(response.data);
      if (response.success == 1) {
        print("success");
      }
    } catch (e) {}
  }

  Future<UserSubscription> getUserSubscriptionDetail(String memberId) async {
    UserSubscription user = UserSubscription();

    // String query =
    //   "https://www.bebuzee.com/webservices/premimum_member_check.php?user_id=$memberId";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };
    try {
      // var response = await Dio().get(
      //   query,
      //   options: Options(
      //     headers: head,
      //   ),
      // );
      var response = await ApiRepo.postWithToken(
          "api/premimum_member_check.php", {"user_id": memberId});
      print(response!.success);
      if (response.success == 1) {
        print(response.data);
        // var convertJson = json.decode(response!.data);
        // print(convertJson.toString());
        user = UserSubscription.fromJson(response.data);
        print("decoded " + user.toString());
      }
    } catch (e) {
      print(e);
      return user;
    }
    return user;
  }

  Future<bool> feedbackCheck(int tradesmanId, int companyId) async {
    print(
        "responseee 1111111 dAta = $tradesmanId $companyId ${CurrentUser().currentUser.memberID!}");

    try {
      var response =
          await ApiRepo.postWithToken("api/tradesmen_review_check.php", {
        "user_id": int.parse(CurrentUser().currentUser.memberID!),
        "tradesman_id": tradesmanId,
        'company_id': companyId,
      });
      print("object.. respons = ${response!.success}");

      if (response.success == 1) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTradesmen(data) async {
    // String query =
    //     "https://www.bebuzee.com/webservices/tradesmen_signup_now.php";

    // Map<String, dynamic> head = {
    //   "Content-Type": "application/json",
    // };

    try {
      // var response = await Dio().post(
      //   query,
      //   data: data,
      //   options: Options(
      //     headers: head,
      //   ),
      // );

      var response =
          await ApiRepo.postWithToken("api/tradesmen_signup.php", null);

      if (response!.success == 1) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> newRefreshToken({from = ''}) async {
    return await getTheToken();

    var preferences = await SharedPreferences.getInstance();
    var existingToken = preferences.getString('token');
    var url = 'https://www.bebuzee.com/api/auth/refresh';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $existingToken',
    };

    print("headers=$headers");
    var response;
    try {
      response = await Dio().post(
        url,
        queryParameters: {"user_id": CurrentUser().currentUser.memberID!},
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $existingToken',
        }),
      );

      print("response token=${response!.data}");
      await preferences.setString('token', response!.data['access_token']);
      print("from $from success ${response!.data['access_token']}");
      return response!.data['access_token'];
    } catch (e) {
      print("error =$e ");
      return '';
    }
  }

  Future<String?>? refreshToken(String memberId) async {
    //print("Refresh token api call $memberId");
    return '';
    String query =
        "https://www.bebuzee.com/api/authorization_token.php?user_id=$memberId";

    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };

    try {
      var response = await Dio().post(
        query,
        options: Options(
          headers: head,
        ),
      );
      //pri nt("refresh token response : ${response!.data}");
      if (response.statusCode == 200) {
        RefreshTokenModel _refreshToken =
            RefreshTokenModel.fromJson(response.data);

        //  print("new token ==>  ${_refreshToken.token}");
        return _refreshToken.token;
      }
    } catch (e) {
      print("error at refresh token -: $e");
    }
  }
}
