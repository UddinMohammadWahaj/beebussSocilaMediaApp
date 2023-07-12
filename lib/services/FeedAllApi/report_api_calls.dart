import 'package:bizbultest/api/api.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiRepo.dart' as ApiRepo;

import '../current_user.dart';

class ReportApiCalls {
  void _checkRes(http.Response response) {
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body != "") {
      print(response.body);
      print("reported successfully");
    }
  }

  Future<void> reportPostNudity(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_nudity&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> reportPostHateSpeech(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_hate_speech&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> reportPostAsSale(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_sale&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> reportPostViolence(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_volence& post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> reportPostHarassment(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_hate_speech&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> reportPostIntellectual(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_intellectual&post_type=$postType&post_id=$postID}&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> reportPostInjury(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_intellectual&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> reportPostSpam(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_report_as_nudity&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    _checkRes(response);
  }

  Future<void> postRebuzz(String postType, String postID) async {
    // var newurl =
    //     'https://www.bebuzee.com/api/post_rebuzz.php?post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}';

    // print('url rebuz= ${newurl}');
    // var response = await ApiProvider().fireApi(newurl);

    var response = await ApiRepo.postWithToken("api/post_rebuzz.php", {
      "post_type": postType,
      "post_id": postID,
      "user_id": CurrentUser().currentUser.memberID
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=share_post_data&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);
    if (response!.success == 1 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      print("rebuzzed success");
    }
  }
}
