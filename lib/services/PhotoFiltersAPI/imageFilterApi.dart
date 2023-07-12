// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/multipart_file.dart' as diomulti;
import 'package:sizer/sizer.dart';

import '../current_user.dart';

class imageFilterApi {
  static Future<List> postImages(List<File> files) async {
    String url = 'https://www.bebuzee.com/api/image_filter.php';
    print("---###url -- ${url}");

    var client = Dio();
    var formdata = FormData();
    for (var file in files) {
      print("---###file -- ${file.path}");

      formdata.files.addAll([
        MapEntry("files[]", await diomulti.MultipartFile.fromFile(file.path))
      ]);
    }

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await client
        .post(url,
            data: formdata,
            queryParameters: {
              "height": 0,
              "width": 50,
            },
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }))
        .then((value) => value.data['data']);
    print("----####image filter response=$response");

    List data = response;
    return data;
  }
}
