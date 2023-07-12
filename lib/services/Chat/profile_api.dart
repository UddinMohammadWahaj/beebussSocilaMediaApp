import 'dart:convert';

import 'package:bizbultest/models/Chat/blocked_users_chat_model.dart';
import 'package:bizbultest/services/current_user.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class ProfileApiCallsChat {
  static final String _baseUrl2 =
      "https://www.bebuzee.com/app_develope_contact_chat_1.php";

  //TODO 542
  static Future<String?> aboutStatusPrivacy(int val) async {
    // var url = Uri.parse("$_baseUrl2?action=update_about_status_visiblity&user_id=${CurrentUser().currentUser.memberID}&value=$val");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/update_status_visiblity.php", {
      "action": "update_about_status_visiblity",
      "user_id": CurrentUser().currentUser.memberID,
      "value": val,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("about privacy changed chat");
      return "Success";
    } else {
      return null;
    }
  }

  //TODO 543
  static Future<String?> profilePicturePrivacy(int val) async {
    // var url = Uri.parse("$_baseUrl2?action=update_profile_picture_visiblity&user_id=${CurrentUser().currentUser.memberID}&value=$val");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/update_profile_visiblity.php", {
      "action": "update_profile_picture_visiblity",
      "user_id": CurrentUser().currentUser.memberID,
      "value": val,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("profile picture privacy changed chat");
      return "Success";
    } else {
      return null;
    }
  }

  //TODO 544

  static Future<List> userPrivacyDetails() async {
    // var url = Uri.parse("$_baseUrl2?action=get_user_privacy_status&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_privacy_status_data.php", {
      "action": "get_user_privacy_status",
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      int aboutStatus = jsonDecode(response!.data['data'])['about_status'];
      int pictureStatus = jsonDecode(response!.data['data'])['picture_status'];
      return [aboutStatus, pictureStatus];
    } else {
      return [];
    }
  }

  //TODO 545
  static Future<BlockedUsers?> getBlockedUsers() async {
    // var url = Uri.parse("$_baseUrl2?action=get_blocked_user&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/blocked_member_list.php", {
      "action": "get_blocked_user",
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      BlockedUsers userData = BlockedUsers.fromJson(response!.data['data']);
      return userData;
    } else {
      return null;
    }
  }
}
