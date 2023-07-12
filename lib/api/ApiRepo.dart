import 'dart:collection';
import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/AgoraCallDetailModel.dart';
import 'package:bizbultest/models/Analytics/Revenue.dart';
import 'package:bizbultest/models/Tradesmen/findtradesmensolodetailmodel.dart';
import 'package:bizbultest/models/Tradesmen/tradesmens_work_category_model.dart';
import 'package:bizbultest/models/banner_ads_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const String baseUrl = "https://www.bebuzee.com/";
Future<HttpResponse> get(String endpoint) async {
  final url = "$baseUrl$endpoint";
  print("call Url -> :: " + url);
  try {
    Response response = await Dio().get(url);
    print("response -> :: ");
    print(response);
    print("response end ->|<- ");
    if (response.statusCode == 200) {
      if (response.data['success'] == 0) {
        throw HttpException(
            response.data['message'], response.data['status'].toString());
      } else {
        return HttpResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  } on HttpException catch (error) {
    Logger().e(error.toString());
    return HttpResponse(status: 0, message: error.message);
  } catch (e) {
    Logger().e(e.toString());
    return HttpResponse(
        status: 0, message: "Something went wrong. Please try again.");
  }
}

Future<HttpResponse> post(String endpoint, dynamic sendData) async {

  final url = "$baseUrl$endpoint";
  print("call Url -> :: " + url);

  print("Send Dataa -> :: ");
  print(sendData);
  try {
    FormData fd = new FormData.fromMap(sendData);
    Response response = await Dio().post(url, data: fd);
    if (response.statusCode == 200) {
      if (response.data['status'] != 1) {
        throw HttpException(
            response.data['message'], response.data['status'].toString());
      } else {
        return HttpResponse.fromJson(response.data)/*..data = response.data*/;
      }
    } else {
      throw Exception(response.data);
    }
  }
  on HttpException catch (error) {
    Logger().e(error.toString());
    return HttpResponse(status: 0, message: error.message);
  } catch (e) {
    print(e.toString());
    Logger().e(e.toString());
    return HttpResponse(
        status: 0, message: "Something went wrong. Please try again.");
  }

}

Future<HttpResponse> getWithToken(String endpoint) async {
  final url = "$baseUrl$endpoint";
  print("call Url -> :: " + url);
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Response response = await Dio().get(
      url,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    print("response -> :: ");
    print(response);
    print("response end ->|<- ");
    if (response.statusCode == 200) {
      if (response.data['success'] == 0) {
        throw HttpException(
            response.data['message'], response.data['status'].toString());
      } else {
        return HttpResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  } on HttpException catch (error) {
    print("error code=${error}");
    if (error.code == "401") {
      print("error code=401 ${error.code}");
      var response_token = await post("api/authorization_token.php",
          {"user_id": "${CurrentUser().currentUser.memberID}"});
      if (response_token.success == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (await prefs.getString('token') != response_token.data['token']) {
          await prefs.setString('token', response_token.data['token']);
          return getWithToken(endpoint);
        }
        ;
      } else
        return HttpResponse(status: -1, message: error.message);
    }
    Logger().e(error.toString());
    return HttpResponse(status: 0, message: error.message);
  } catch (e) {
    Logger().e(e.toString());
    return HttpResponse(
        status: 0, message: "Something went wrong. Please try again.");
  }
}

Future testnewpostWithToken(String endpoint, dynamic sendData) async {
  final url = "$baseUrl$endpoint";
  var dio = Dio();
  //check for token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  FormData fd = new FormData.fromMap(sendData);

  try {} catch (e) {}
}

Future<String> getTheToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var token = prefs.getString('token');
  print("error current $token  url=${baseUrl}api/auth/refresh");
  var response_token = await Dio().post(baseUrl + 'api/auth/refresh',
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
      data: {
        "user_id": "${CurrentUser().currentUser.memberID}"
      }).then((value) => value);
  await prefs.setString('token', response_token.data['user']['access_token']);
  return '${response_token.data['user']['access_token']}';
}

Future<HttpResponse?> newpostWithToken(
    String endpoint, dynamic sendData) async {
  final url = "$baseUrl$endpoint";
  print("call Url1111 -> :: " + url);

  print("Send Dataa 11111 -> :: ");
  print(sendData);
  print("Send Data 1111 ->|<- ");
  try {
    var token = await ApiProvider().getTheToken(from: 'currentmember');
    print('got the member token=${token}');
    //  prefs.getString('token');
    print("===== 1111 $token");
    Logger().w(token);
    FormData fd = new FormData.fromMap(sendData);
    Response response = await Dio().post(
      url,
      data: fd,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    print("response 11111 -> :: $response");
    print('responseee 1111111 currentmember =${response.data}');
    print("response end 1111 ->|<- ${response.statusCode}");
    if (response.statusCode == 200) {
      print("response end 1111erqwerqwr ->|<- ${response.data['status']}");
      if (response.data['status'] == 0) {
        // return HttpResponse.fromJson(response.data)
        //   ..data = response.data
        //   ..status = 0;
        throw HttpException(
            response.data['message'], response.data['status'].toString());
      } else {
        print("reached here elseeaa ${response.data['status'] + 2}");
        return HttpResponse.fromJson(response.data)
          ..data = response.data
          ..status = 1;
      }
    } else {
      // throw Exception("11111  error" + response.data['message']);
    }
  } catch (e) {
    // SharedPreferences.setMockInitialValues({});
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // print("error current $e ");
    // var token = prefs.getString('token');
    // print("error current $token  url=${baseUrl}api/auth/refresh");

    // var response_token = await Dio().post(baseUrl + 'api/auth/refresh',
    //     options: Options(
    //       headers: {
    //         "Accept": "application/json",
    //         "Authorization": "Bearer $token",
    //       },
    //     ),
    //     data: {
    //       "user_id": "${CurrentUser().currentUser.memberID}"
    //     }).then((value) => value);
    // await prefs.setString('token', response_token.data['user']['access_token']);
    // return postWithToken(endpoint, sendData);
    // print("new tokengot=${response_token}");
  }
}

Future<HttpResponse?> postWithToken(String endpoint, dynamic sendData) async {
  final url = "$baseUrl$endpoint";

  try {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token') ??"";


    FormData fd = new FormData.fromMap(sendData);

    print("base url------------------>  " + url);
    print("sent data------------------>  " + sendData.toString());
    print("sent data------------------>  " + token.toString());
    Response response = await Dio().post(
      url,
      data: fd,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    print("response 11111 -> :: $response");
    print('responseee 1111111 =${response.data}');
    print("response end 1111 ->|<- ${response.statusCode}");
    if (response.statusCode == 200) {
      print("response end 1111erqwerqwr ->|<- ${response.data['success']}");
      if (response.data['status'] != 1) {

        throw HttpException(
            response.data['message'], response.data['status'].toString());
      } else {
        print("HttpResponse.fromJson(response.data)");
        print(response.data);
        print("HttpResponse.fromJson(response.data) 123");
        return HttpResponse.fromJson(response.data)
          ..data = response.data
          ..status = 1;

      }
    } else {
      throw Exception("11111  error" + response.data['message']);
    }
  } on HttpException catch (error) {
    print("token expired");
    Logger().wtf(url.toString());
    Logger().e(error.toString());
    if (error.code == "401") {
      var response_token = await post("api/authorization_token.php",
          {"user_id": "${CurrentUser().currentUser.memberID}"});
      if (response_token.success == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response_token.data['token']);
        return postWithToken(endpoint, sendData);
      } else
        return HttpResponse(status: -1, message: error.message);
    }
    return HttpResponse(status: 0, message: error.message);
  } on DioError catch (e) {
    print(" 11111  error dio ${e.response}");
    Logger().e(e.toString());
  } catch (e) {
    print("11111  error catch " + e.toString());
    Logger().e(e.toString());
    return HttpResponse(
        status: 0, message: "Something went wrong. Please try again.");
  }
}

Future<HttpResponse?> postWithTokenNoFD(
    String endpoint, dynamic sendData) async {
  final url = "$baseUrl$endpoint";
  print("call Url -> :: " + url);

  print("Send Dataa -> :: ");
  print(sendData);
  print("Send Data ->|<- ");
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Logger().w(token);

    Response response = await Dio().post(
      url,
      data: sendData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    print("response -> :: ");
    print(response);
    print("response end ->|<- ");
    if (response.statusCode == 200) {
      if (response.data['success'] == 0) {
        throw HttpException(
            response.data['message'], response.data['status'].toString());
      } else {
        return HttpResponse.fromJson(response.data)
          ..data = response.data
          ..status = 1;
      }
    } else {
      throw Exception(response.data);
    }
  } on HttpException catch (error) {
    Logger().wtf(url.toString());
    Logger().e(error.toString());
    if (error.code == "401") {
      var response_token = await post("api/authorization_token.php",
          {"user_id": "${CurrentUser().currentUser.memberID}"});
      if (response_token.success == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response_token.data['token']);
        return postWithToken(endpoint, sendData);
      } else
        return HttpResponse(status: -1, message: error.message);
    }
    return HttpResponse(status: 0, message: error.message);
  } on DioError catch (e) {
    print(e.response);
    Logger().e(e.toString());
  } catch (e) {
    print(e.toString());
    Logger().e(e.toString());
    return HttpResponse(
        status: 0, message: "Something went wrong. Please try again.");
  }
}

Future<HttpResponse?> TestpostWithTokenAndFormData(
  String endpoint,
  FormData fd,
  dynamic Function(int, int)? onSendProgress,
) async {
  final url = "https://www.bebuzee.com/$endpoint";
  print("call Url -> :: " + url);

  print("Send Dataa -> ::${fd.files.length.toString()} ");
  print(fd.toString());
  print("Send Data ->|<- ");

  Response response = await Dio().post(
    url,
    data: fd,
    options: Options(
      headers: {
        "Accept": "application/json",
        "Content-Type": "multipart/form-data",
      },
    ),
    onSendProgress: onSendProgress,
  );
  print("response testttttttt-> ::${response} ");
  print(response);
  print("response end ->|<- ");
  return HttpResponse.fromJson(response.data)
    ..data = response.data
    ..status = 1;
}

Future<HttpResponse> postWithTokenAndFormData(
  String endpoint,
  FormData fd,
  dynamic Function(int, int)? onSendProgress,
) async {
  final url = "$baseUrl$endpoint";
  print("call Url -> :: " + url);

  print("Send Dataa -> :: ");
  print(fd.toString());
  print("Send Data ->|<- ");
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Response response = await Dio().post(
      url,
      data: fd,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $token",
        },
      ),
      onSendProgress: onSendProgress,
    );
    print("response -> :: ");
    print(response);
    print("response end ->|<- ");
    if (response.statusCode == 200) {
      if (response.data['success'] == 0) {
        throw HttpException(
            response.data['message'], response.data['status'].toString());
      } else {
        return HttpResponse.fromJson(response.data)
          ..data = response.data
          ..status = 1;
      }
    } else {
      throw Exception(response.data);
    }
  } on HttpException catch (error) {
    Logger().e(error.toString());
    if (error.code == "401") {
      var response_token = await post("api/authorization_token.php",
          {"user_id": "${CurrentUser().currentUser.memberID}"});
      if (response_token.success == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response_token.data['token']);
        return postWithTokenAndFormData(endpoint, fd, onSendProgress);
      } else
        return HttpResponse(status: -1, message: error.message);
    }
    return HttpResponse(status: 0, message: error.message);
  } catch (e) {
    print(e.toString());
    Logger().e(e.toString());
    return HttpResponse(
        status: 0, message: "Something went wrong. Please try again.");
  }
}

class HttpException implements Exception {
  final String message;
  final String code;
  HttpException(this.message, this.code);

  @override
  String toString() {
    return "Error code : $code => $message";
  }
}

class HttpResponse {
  int? success;
  int? status;
  String? message;
  dynamic? data;

  HttpResponse({this.success, this.status, this.message, this.data});

  HttpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;

    status = json['status'];
    // message = json['msg'] ?? '';
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['msg'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
