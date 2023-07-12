import 'dart:typed_data';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/location_reviews_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/multipart_file.dart' as diomulti;
import 'package:extended_image/extended_image.dart';

import '../../current_user.dart';
import 'dart:convert';
import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class LocationReviewsAPI {
  static final String memberID = CurrentUser().currentUser.memberID!;
  static final String country = "India";

  static Future<int> postLocationReview(Map<String, dynamic> query,
      File? thumbnailImage, List<File?> photos) async {
    var url = 'https://www.bebuzee.com/api/write_review_add.php';

    var client = Dio();
    List<dynamic> imgPath = [];
    photos.forEach((element) async {
      imgPath.add(await diomulti.MultipartFile.fromFile(element!.path));
    });

    var formdata = FormData();
    for (var file in photos) {
      formdata.files.addAll([
        MapEntry(
            "filephotos[]", await diomulti.MultipartFile.fromFile(file!.path))
      ]);
    }
    if (thumbnailImage != null) {
      formdata.files.addAll([
        MapEntry("filevideothumn",
            await diomulti.MultipartFile.fromFile(thumbnailImage.path))
      ]);
    }
    Int32List.fromList(photos!.cast<int>()).lastIndexWhere((element) => false);
    int.fromEnvironment('Data');
    // if (thumbnailImage == null) print("thumbnail is empty");
    // var data = (thumbnailImage != null)
    //     ? FormData.fromMap({
    //         "filevideothumb": (thumbnailImage != null)
    //             ? await diomulti.MultipartFile.fromFile(thumbnailImage.path)
    //             : [],
    //         "filephotos[]": imgPath
    //       })
    //     : FormData.fromMap({"filephotos[]": imgPath});
    // print("the data=${data.files.length}");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    var resturl = '';
    query.forEach((key, value) {
      resturl += '&${key}=$value';
    });
    resturl = resturl.replaceFirst('&', '?');
    print("location url=${url}${resturl}");
    return await client
        .post(url + resturl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }),
            data: formdata)
        .then((value) {
      print("write location review success ${value.data}");
      return value.data['success'];
    });
  }

  static Future<List<LocationReviewsModel>> fetchLocationReviews(
      String country, String city) async {
    var url =
        "https://www.bebuzee.com/api/reviews_list_by_country_city.php?country=$country&city=$city";
    print(url);
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await Dio()
        .post(
          url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);
    print("object.. 11 respons.. ${response.data}");
    if (response.data['success'] == 1 && response.data != null) {
      print('Location reviews resp=${response.data}');
      LocationReviews reviewData =
          LocationReviews.fromJson(response.data['data']);
      return reviewData.reviews;
    } else {
      return [];
    }
  }
}
