import 'package:bizbultest/services/current_user.dart';

import 'package:dio/src/form_data.dart' as dioform;
import 'package:dio/src/multipart_file.dart' as diomulti;
import 'package:extended_image/extended_image.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import '../../../api/api.dart';

class UploadXmlAPI {
  Future<String?> getToken() async {
    return await ApiProvider()
        .refreshToken(CurrentUser().currentUser.memberID!);
  }

  static Future<int> uploadXMLfile(String url, File file) async {
    var client = dio.Dio();
    var token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    dioform.FormData data = new dioform.FormData.fromMap({
      "agent_id": CurrentUser().currentUser.memberID,
      "uploadxml": await diomulti.MultipartFile.fromFile(file.path)
    });
    return await client
        .post(
      url,
      data: data,
      options: dio.Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    )
        .then((value) {
      print(
          'file upload ${value.data['success']} ${value.statusCode} ${value.data}');
      return value.data['success'];
    });
  }
}
