import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

import '../../api/ApiRepo.dart' as ApiRepo;

class BroadcastApiCalls {
  ChatsRefresh refresh = ChatsRefresh();
  DetailedChatRefresh _detailedChatRefresh = DetailedChatRefresh();

  static final String _baseUrl =
      "https://www.bebuzee.com/app_develope_message_chat_broad.php";

  Future<String?> sendTextMessage(
      String otherMemberID, String message, String token) async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "country": CurrentUser().currentUser.timeZone,
    //   "action": "send_text_message_broadcast",
    //   "recipient_id": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message": message,
    // });

    var response =
        await ApiRepo.postWithToken("api/send_text_message_broadcast.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "action": "send_text_message_broadcast",
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message": message,
    });

    if (response!.success == 1 &&
        response.data != null &&
        response.data != "") {
      sendFcmRequest("Notification", message, "text", otherMemberID, token)
          .then((value) {
        refresh.updateRefresh(true);
        _detailedChatRefresh.updateRefresh(true);
      });
      // getAllChats(otherMemberID, "");
      return "Success";
    } else {
      return null;
    }
  }

  static Future<mp.MultipartRequest> uploadMultipleFiles(
      String data,
      String path,
      List<File> finalFiles,
      String memberID,
      String otherMemberID) async {
    mp.MultipartRequest request = mp.MultipartRequest();
    // request.setUrl(
    //     "$_baseUrl?action=upload_file_multiple_file_data_broadcast&all_messages=$data&user_id=$memberID&recipient_id=$otherMemberID");

    request.setUrl(ApiRepo.baseUrl + "api/upload_file_in_broadcast.php");
    request.addFields({
      "all_messages": "$data",
      "user_id": "$memberID",
      "recipient_id": "$otherMemberID",
    });
    finalFiles.forEach((element) {
      request.addFile("files[]", element.path);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    request.addHeaders({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });
    return request;
  }

  static Future<void> sendFcmRequest(String _title, String _message,
      String type, String otherMemberID, String topic) async {
    print(topic);
    var headersData = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
    };
    var bodyData = {
      "notification": {"title": _title, "body": _message},
      "data": {
        "user_id": CurrentUser().currentUser.memberID!,
        "other_user_id": CurrentUser().currentUser.memberID!,
        "type": type,
        "body": _message,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "category": "group"
      },
      "priority": "high",
      "to": "/topics/$topic"
    };
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final res =
        await http.post(url, body: jsonEncode(bodyData), headers: headersData);
  }

  Future<mp.MultipartRequest> uploadAudioFiles(List<File> audioFiles,
      String otherMemberID, String paths, String durations) async {
    mp.MultipartRequest request = mp.MultipartRequest();

    // request.setUrl(
    //     "$_baseUrl?action=save_audio_file_broad&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}&device_path=$paths&duration=$durations&files=");

    request.setUrl(ApiRepo.baseUrl + "api/upload_audio_in_broadcast.php");
    request.addFields({
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country!,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone!,
      "device_path": paths,
      "duration": durations // String"",
    });

    audioFiles.forEach((element) {
      print(element.path + " sent paths");
      request.addFile("files[]", element.path);
    });
    return request;
  }

  Future<mp.MultipartRequest> uploadVoiceRecording(String audioPath,
      String otherMemberID, String path, String duration) async {
    mp.MultipartRequest request = mp.MultipartRequest();
    // request.setUrl(
    //     "$_baseUrl?action=save_audio_file_voice_broad&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}&device_path=$path&duration=$duration&files=");

    request.setUrl(ApiRepo.baseUrl + "api/send_audio_voice_file.php");
    request.addFields({
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country!,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone!,
      "device_path": path,
      "duration": duration
    });

    request.addFile("files[]", audioPath);

    return request;
  }

  Future<String?> sendContacts(
      String otherMemberID, String contacts, String topic) async {
    var url = Uri.parse(_baseUrl);

    final response = await http.post(url, body: {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.timeZone,
      "action": "send_text_message_contact_data_broad",
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "contact_data": contacts,
    });
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body != "") {
      print(response.body);

      sendFcmRequest("Notification", contacts, "contact", otherMemberID, topic)
          .then((value) {
        refresh.updateRefresh(true);
        _detailedChatRefresh.updateRefresh(true);
      });
      //getAllChatsLocal(otherMemberID);

      return "Success";
    } else {
      return null;
    }
  }

  static Future<DirectUsers> getSelectedBroadcastUserList(
      String broadcastID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_contact_chat_1.php?action=get_all_broadcast_members&broadcast_id=$broadcastID&user_id=${CurrentUser().currentUser.memberID!}&timezone=${CurrentUser().currentUser.timeZone}");
    //
    // var response = await http.get(url);

    final response =
        await ApiRepo.postWithToken("api/all_broadcast_members.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "broadcast_id": broadcastID,
      "timezone": CurrentUser().currentUser.timeZone,
    });

    if (response!.success == 1 &&
        response.data['data'] != null &&
        response.data['data'] != "") {
      DirectUsers directUserData =
          DirectUsers.fromJson((response.data['data']));
      /* SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("participants$groupID", response.body);*/
      return directUserData;
    } else {
      return new DirectUsers([]);
    }
  }

  Future<mp.MultipartRequest> sendLocation(
      String otherMemberID,
      String latitude,
      String longitude,
      String locationTitle,
      String locationSubtitle,
      String path) async {
    mp.MultipartRequest request = mp.MultipartRequest();
    // request.setUrl(
    //     "$_baseUrl?action=send_text_message_location_broad&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}&latitude=$latitude&longitude=$longitude&location_title=$locationTitle&location_subtitle=$locationSubtitle&path=$path");

    request.setUrl(ApiRepo.baseUrl + "api/send_message_location_broadcast.php");
    request.addFields({
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country!,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone!,
      "latitude": latitude,
      "longitude": longitude,
      "location_title": locationTitle,
      "location_subtitle": locationSubtitle,
      "path": path
    });

    request.addFile("file", path);
    return request;
  }
}
