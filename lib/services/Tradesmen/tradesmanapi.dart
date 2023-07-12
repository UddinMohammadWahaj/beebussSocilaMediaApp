import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Tradesmen/CompanyTradesmenList.dart';
import 'package:bizbultest/models/Tradesmen/requested_tradesmen_enqury_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmens_work_category_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmenundercompanylistmodel.dart';
import 'package:dio/dio.dart';

import '../../models/Tradesmen/find_tradesmen_company_detail_mode.dart';
import '../../models/Tradesmen/findtrademendetailmodel.dart';
import '../../models/Tradesmen/findtradesmensolodetailmodel.dart';
import '../../models/Tradesmen/newfifndtradesmenlistmodel.dart';
import '../../models/Tradesmen/newtradesmendetailmodel.dart';
import '../../models/Tradesmen/tradesmenofcompanieslist.dart';
import '../current_user.dart';

class TradesmanApi {
  static var baseUrl = 'http://www.bebuzee.com/api/tradesmen';
  static var baseFindUrl = 'http://www.bebuzee.com/api';
  static Future<List<WorkCategory>?> getTradesmenCategory() async {
    var url = baseUrl + '/getTradeCategory';
    var response =
        await ApiProvider().fireApiWithParamsGet(url).then((value) => value);
    return TradesmensWorkCategoryModel.fromJson(response.data).workCategory;
  }

  static Future<String> subscribeTradesmen({amount: '', type: ''}) async {
    var url = baseUrl + '/tradesmenSubscribe';

    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "amount": amount,
      "type": type,
      "user_id": CurrentUser().currentUser.memberID
    }).then((value) => value);
    print("response pay=${response.data} url${url}");
    if (response.data['status'] == 1) {
      print("response pay=${response.data}");
      return response.data['url'];
    }
    return '';
  }

  static Future<FindTradesmenDetatilModel> getFindTradesmenDetail(id) async {
    var url = 'http://www.bebuzee.com/api/tradesmen/getTradesmenDetail';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      'tradesmen_id': id,
    });
    return FindTradesmenDetatilModel.fromJson(response.data);
  }

  static Future<FindTradesmenCompanyDetailModel> getFindTradesmenCompanyDetail(
      id) async {
    var url = 'http://www.bebuzee.com/api/tradesmen/getCompanyDetail';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      'company_id': id,
    });
    print('called fetch review ${response.data}');
    return FindTradesmenCompanyDetailModel.fromJson(response.data);
  }

  static Future<FindTradesmenSoloDetailModel> getFindTradesmenSoloDetail(
      id) async {
    var url = 'http://www.bebuzee.com/api/tradesmen/getTradesmenDetail';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      'tradesmen_id': id,
    });
    print('called fetch review ${response.data}');
    return FindTradesmenSoloDetailModel.fromJson(response.data);
  }

  static Future<List<RequestedTradesmenRecord>?> fetchTradesmenEnquiry() async {
    var url = 'http://www.bebuzee.com/api/tradesmen/companyEnquiryList';
    var response =
        await ApiProvider().fireApiWithParamsGet(url, params: {"user_id": 20});
    return RequestedTradesmenModelList.fromJson(response.data).record;
  }

  static Future<List<FindTradesmenRecord>?> fetchSearchTradesmen(data) async {
    var url = baseFindUrl + '/find-tradesmen';
    print('error=url=${url}');
    var response;
    try {
      response = await ApiProvider()
          .fireApiWithParamsGet(url, params: data)
          .then((value) => value);
      print("find response=${response.data}");
    } catch (e) {
      print("error=$e");
    }

    return FindTradesmeenListModel.fromJson(response.data).record;
  }

  static Future deleteCompanyTradesmen(tradesmenId) async {
    var url = baseUrl + '/removeCompanyTradesmen';
    var response = await ApiProvider().fireApiWithParamsGet(url,
        params: {"tradesmen_id": "${tradesmenId}"}).then((value) => value);
  }

  static Future<List<Tradesman>?> getTradesmenUnderCompanyList(companyId,
      {page: 0}) async {
    var url = baseUrl + '/getCompanyAllTradesmen';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "company_id": companyId,
      "page": page,
    }).then((value) => value);
    return TrandemenUnderCompanyModelList.fromJson(response.data)
        .data!
        .tradesmen;
  }

  static Future deleteTradesmenAlbum(id) async {
    var url = baseUrl + '/deleteAlbum';
    var response =
        await ApiProvider().fireApiWithParamsGet(url, params: {"album_id": id});
    print('deleted=${response.data}');
  }

  static Future deleteTradesmenCompany(companyId) async {
    var url = baseUrl + '/removeCompany';
    var response = await ApiProvider()
        .fireApiWithParamsGet(url, params: {"company_id": companyId});
    print("company delete response=${response.data}");
  }

  static Future<List<CompanyTradesmenListRecord>?> getTraddesmenCompanyList(
      {page: 1}) async {
    var url = baseUrl + '/getUserAllCompany';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      'user_id': CurrentUser().currentUser.memberID,
      'page': page
    }).then((value) => value);
    if (response.data['status'] == 1) {
      return CompanyTradesmenListModel.fromJson(response.data).record;
    } else {
      return [];
    }
  }

  static Future updateCompanyTradesmenDetail(data) async {
    var url = baseUrl + '/updateCompanyTradesmen';
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, formdata: data)
        .then((value) => value);
    print("update tadesmen response=${response.data}");
  }

  static Future<Record?> getCompanyTradesmenDetail(tradesmenId) async {
    var url = baseUrl + '/editCompanyTradesmen';
    var response = await ApiProvider().fireApiWithParamsGet(url,
        params: {"tradesmen_id": tradesmenId}).then((value) => value);
    if (response.data['status'] == 1) {
      return NewTradesmenDetailModel.fromJson(response.data).record;
    } else
      return null;
  }

  static Future<Record?> getTradesmenDetail() async {
    var url = baseUrl + '/getSoloTradesmenDetail';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID
    }).then((value) => value);
    if (response.data['status'] == 1) {
      return NewTradesmenDetailModel.fromJson(response.data).record;
    } else
      return null;
  }

  static Future<bool> fetchSubscriptionStatus() async {
    var url = baseUrl + '/tradesmenSubscribeStatus';
    var response = await ApiProvider().fireApiWithParamsGet(url, params: {
      "user_id": CurrentUser().currentUser.memberID
    }).then((value) => value);
    if (response.data['status'] == 1) {
      if (response.data['data']['is_subscribe'] == 1) {
        return true;
      } else
        return false;
    } else
      return false;
  }

  static Future bulkUploadTradesmen(data) async {
    var url = baseUrl + '/tradesmenBulkUpload';
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, formdata: data)
        .then((value) => value);
    print("bulk upload tradedsmen response=${response.data}");
  }

  static Future getMultipleImagesLink(List<File> albumFiles) async {
    var url = baseUrl + '/uploadMultipleAlbumImages';
    var formData = FormData();
    for (var file in albumFiles) {
      formData.files.addAll([
        MapEntry("images[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    print("url respons=${albumFiles.length}");
    // formData.files.addAll(
    //     [MapEntry("images[]", await MultipartFile.fromFile(albumFiles.path))]);
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, formdata: formData)
        .then((value) => value.data);
    print("url respons=${response}");
    if (response['status'] == 1) {
      return response['images'];
    }
    return '';
  }

  static Future requestCallback(data) async {
    var url = 'http://www.bebuzee.com/api/tradesmen/sendEnquiry';

    var response = await ApiProvider()
        .fireApiWithParamsPost(url, formdata: data)
        .then((value) => value);
    return response;
  }

  static Future getAlbumLink(File albumFile) async {
    var url = baseUrl + '/uploadAlbumImages';
    var formData = FormData();
    formData.files.addAll(
        [MapEntry("image", await MultipartFile.fromFile(albumFile.path))]);
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, formdata: formData)
        .then((value) => value.data);
    print("url respons=${response}");
    if (response['status'] == 1) {
      return response['url'];
    }
    return '';
  }
}
