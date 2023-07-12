import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/Chat/direct_user_model.dart';
import 'package:bizbultest/models/Chat/nearby_places_chat_model.dart';
import 'package:bizbultest/models/Chat/status_model.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/ApiRepo.dart' as ApiRepo;
import '../../models/Tradesmen/tradesmens_work_category_model.dart';

class DirectApiCalls {
  static DirectRefresh refresh = DirectRefresh();
  static AboutRefresh _refreshAbout = AboutRefresh();
  static DetailedDirectRefresh _detailedRefresh = DetailedDirectRefresh();

  static final String _baseUrl =
      "https://www.bebuzee.com/app_devlope_message_data.php";
//TODO:: inSheet 414
  static Future<DirectUsersSearch?> getDirectUserSearchList(
      String search) async {
    // var url = Uri.parse("$_baseUrl?action=get_user_list&keywords=$search&user_id=${CurrentUser().currentUser.memberID}");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/get_user_list.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "keywords": search,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print("getDirectUserSearchList --> ${response!.data}");
      DirectUsersSearch directUserData =
          DirectUsersSearch.fromJson(response!.data['data']);
      return directUserData;
    } else {
      return null;
    }
  }

//TODO:: inSheet 415
  static Future<DirectUsers> getDirectUserList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("direct");
    try {
      // var url = Uri.parse(_baseUrl);
      // final response = await http.post(url, body: {
      //   "user_id": CurrentUser().currentUser.memberID,
      //   "country": CurrentUser().currentUser.country,
      //   "action": "get_all_chat_list",
      //   "timezone": CurrentUser().currentUser.timeZone,
      // });

      var response = await ApiRepo.postWithToken("api/chat_list_direct.php", {
        "user_id": CurrentUser().currentUser.memberID,
        "country": CurrentUser().currentUser.country,
        "timezone": CurrentUser().currentUser.timeZone,
      });
      if (response!.success == 1 &&
          response.data['data'] != null &&
          response.data['data'] != "") {
        print("getDirectUserList  chat_list_direct--> ${response.data}");
        DirectUsers directUserData =
            DirectUsers.fromJson(response.data['data']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("direct", jsonEncode(response.data));
        return directUserData;
      } else {
        if (chatData != null) {
          print("getDirectUserList  chatData--> $chatData");
          DirectUsers directUserData =
              DirectUsers.fromJson(jsonDecode(chatData));
          return directUserData;
        } else {
          return DirectUsers([]);
        }
      }
    } on SocketException {
      if (chatData != null) {
        print("getDirectUserList  chatData--> $chatData");
        DirectUsers directUserData = DirectUsers.fromJson(jsonDecode(chatData));
        return directUserData;
      } else {
        return DirectUsers([]);
      }
    }
  }
  // void getMusicData(){
  //   var music=MusicD
  // }

  static Future<DirectUsers> getDirectUserListLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("direct");
    if (chatData != null) {
      DirectUsers directUserData = DirectUsers.fromJson(jsonDecode(chatData));
      return directUserData;
    } else {
      return new DirectUsers([]);
    }
  }

//TODO:: inSheet 416
  static Future<ChatMessages> getAllChats(
      String otherMemberID, String messages) async {
    // var url = Uri.parse(_baseUrl);
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.country,
    //   "action": "get_chat_data",
    //   "fromuserid": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message_id": messages
    // });

    var response = await ApiRepo.postWithToken("api/chat_data_direct.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "fromuserid": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message_id": messages
    });
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      ChatMessages chatData = ChatMessages.fromJson(response!.data['data']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          "chats$otherMemberID", jsonEncode(response!.data['data']));
      return chatData;
    } else {
      return new ChatMessages([]);
    }
  }

//TODO:: inSheet 417
  static Future<void> sendFeedPost(
      String postID, String members, String message) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_share_on_chat.php?user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&share_user_ids=$members&message=$message");
    // final response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/post_share_on_chat.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "post_id": postID,
      "share_user_ids": "$members",
      "message": message
    });
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      refresh.updateRefresh(true);
      print("sent post");
    } else {
      print("not sent");
    }
  }

//TODO:: inSheet 418
  static Future<NearbyPlaces> getNearbyPlaces(String lat, String long) async {
    var url = Uri.parse(_baseUrl);

    // final response = await http.post(url, body: {
    //   "action": "near_by_location",
    //   "lat": lat,
    //   "long": long,
    // });
    var response = await ApiRepo.postWithToken("api/near_by_location.php", {
      "action": "near_by_location",
      "lat": lat,
      "long": long,
    });
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print("found location");
      NearbyPlaces placeData = NearbyPlaces.fromJson(response!.data['data']);
      return placeData;
    } else {
      return new NearbyPlaces([]);
    }
  }

//TODO:: inSheet 419
  static Future<ChatStatus> getAllStatus() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_message_data.php?action=get_all_status&user_id=${CurrentUser().currentUser.memberID}");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_all_status.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      ChatStatus statusData = ChatStatus.fromJson(response!.data['data']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("status", jsonEncode(response!.data['data']));
      return statusData;
    } else {
      return new ChatStatus([]);
    }
  }

//TODO:: inSheet 420
  Future<String?> forwardMessages(String messages, String memberIDs) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data.php?action=forward_selected_messages&all_messages=$messages&to_user_ids=$memberIDs&user_id=${CurrentUser().currentUser.memberID}");
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/chat_forward_selected_messages.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "all_messages": messages,
      "to_user_ids": memberIDs,
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      /*sendFcmRequest("Notification", "", "text", otherMemberID, token).then((value) {
      });*/
      refresh.updateRefresh(true);
      return "success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 421
  static Future<String> getUserSelectedStatus() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_message_data.php?action=get_user_status&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_status.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      String status = "";
      status = (response!.data['data'])['user_status'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("selectedStatus", jsonEncode(status));
      return status;
    } else {
      return "Available";
    }
  }

//TODO:: inSheet 421
  static Future<String> getStatusAndNumber(String memberID) async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_message_data.php?action=get_user_status&user_id=$memberID");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_status.php", {
      "user_id": memberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      List<String> info = [];
      String status = "";
      String date = "";
      String number = "";
      status = (response!.data['data'])['user_status'];
      date = (response!.data['data'])['data_created'];
      number = (response!.data['data'])['contact'];
      info.add(status);
      info.add(date);
      info.add(number);
      print(info.join(","));
      /*SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("contact_and_number", info.join(","));*/
      return info.join(",");
    } else {
      return "";
    }
  }

  static Future<String> getUserSelectedStatusLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? statusData = prefs.getString("selectedStatus");
    if (statusData != null) {
      return statusData;
    } else {
      return "Available";
    }
  }

  static Future<ChatStatus?> getAllStatusLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? statusData = prefs.getString("status");
    if (statusData != null) {
      print("yesssssssss");
      ChatStatus status = ChatStatus.fromJson(jsonDecode(statusData));
      return status;
    } else {
      return null;
    }
  }

  static Future<ChatMessages?> getAllChatsLocal(String otherMemberID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("chats$otherMemberID");
    if (chatData != null) {
      ChatMessages chats = ChatMessages.fromJson(jsonDecode(chatData));
      return chats;
    } else {
      return null;
    }
  }

//TODO:: inSheet 422
  static Future<ChatMessages?> onLoading(
      ChatMessages messages,
      BuildContext context,
      RefreshController _refreshController,
      String otherMemberID) async {
    print("on loading");
    int len = messages.messages.length;
    String urlStr = "";
    int itr = 0;
    for (int i = 0; i < len; i++) {
      itr++;

      if (messages.messages[i].messageId != null) {
        urlStr += messages.messages[i].messageId!;
      }
      if (messages.messages[i].messageId != null) {
        if (i != len - 1) {
          urlStr += ",";
        }
      }
    }
    print(itr.toString() + " itrrrrrrrr");
    //print(urlStr);

    // print(urlStr.length);
    //print( messages.messages[messages.messages.length - 1].dateData);
    try {
      // var url = Uri.parse(_baseUrl);
      //
      // final response = await http.post(url, body: {
      //   "user_id": CurrentUser().currentUser.memberID,
      //   "country": CurrentUser().currentUser.country,
      //   "action": "get_chat_data",
      //   "fromuserid": otherMemberID,
      //   "timezone": CurrentUser().currentUser.timeZone,
      //   "message_id": urlStr.substring(0, urlStr.length - 1),
      //   "date_data": messages.messages[messages.messages.length - 1].dateData,
      // });

      var response = await ApiRepo.postWithToken("api/chat_data_direct.php", {
        "user_id": CurrentUser().currentUser.memberID,
        "country": CurrentUser().currentUser.country,
        "action": "get_chat_data",
        "fromuserid": otherMemberID,
        "timezone": CurrentUser().currentUser.timeZone,
        "message_id": urlStr.substring(0, urlStr.length - 1),
        "date_data": messages.messages[messages.messages.length - 1].dateData,
      });

      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "") {
        //print(response!.body);
        print("bodyyyy");
        ChatMessages chatData = ChatMessages.fromJson(response!.data['data']);
        _refreshController.loadComplete();
        return chatData;
      } else {
        _refreshController.loadComplete();
        return null;
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _refreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _refreshController.loadComplete();
    return null;
  }

  static Future<void> sendFcmRequest(String _title, String _message,
      String type, String otherMemberID, String token) async {
    var headersData = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
    };
    var bodyData = {
      "notification": {"title": _title, "body": _message},
      "data": {
        "user_id": CurrentUser().currentUser.memberID,
        "other_user_id": CurrentUser().currentUser.memberID,
        "type": type,
        "body": _message,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "priority": "high",
      "to": token
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final res = await http
        .post(url, body: jsonEncode(bodyData), headers: headersData)
        .then((value) {
      print(value.body.toString());
    });
  }

  static Future<void> sendFcmRequest1(String _title, String _message,
      String type, String otherMemberID, String token) async {
    List<String> tokens = [];
    tokens = token.split(",");

    for (int i = 0; i < tokens.length; i++) {
      var headersData = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
      };

      // String _calling = "";
      // if(_message.contains("cut")){
      //   _calling = "Hangup";
      // }else{
      //   _calling = "Calling...";
      // }
      var bodyData = {
        "to": tokens[i],
        "notification": {
          "title": _title,
          "payLoad": {"is_new_version_available": 1},
          "sound": "chime.mp3",
          "body": _message,
          "type": 17,
          "click_action": "FLUTTER_CLICK_ACTION"
        },
        "data": {"type": 17}
      };

      var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
      final res = await http
          .post(url, body: jsonEncode(bodyData), headers: headersData)
          .then((value) {
        print("sendFcmRequest==> ${value.body.toString()}");
        print("sent");
      });
    }
  }

  static Future<void> fcmOnlineStatus(String status) async {
    var headersData = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
    };
    var bodyData = {
      // "notification": {"title": "", "body": ""},
      "data": {
        "user_id": CurrentUser().currentUser.memberID,
        "other_user_id": CurrentUser().currentUser.memberID,
        "type": "online",
        "body": "",
        "status": status,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "priority": "high",
      "to": "/topics/Online"
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final res = await http
        .post(url, body: jsonEncode(bodyData), headers: headersData)
        .then((value) {
      print(value.body.toString());
    });
  }

  static Future<void> updateDeleteStatus(String token) async {
    var headersData = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
    };
    var bodyData = {
      // "notification": {"title": _title, "body": _message},
      "data": {
        "user_id": CurrentUser().currentUser.memberID,
        "other_user_id": CurrentUser().currentUser.memberID,
        "type": "delete",
        "body": "",
        "category": "deleteDirect",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "priority": "high",
      "to": token
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final res =
        await http.post(url, body: jsonEncode(bodyData), headers: headersData);
  }

//TODO:: inSheet 423
  Future<String?> sendTextMessage(
      String otherMemberID, String message, String token) async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.timeZone,
    //   "action": "send_text_message",
    //   "recipient_id": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message": message,
    //   "type_reply": "",
    //   "type_file_name_reply": "",
    //   "image_reply": "",
    //   "message_reply": "",
    //   "reply_id": "",
    // });

    var response =
        await ApiRepo.postWithToken("api/send_text_message_direct.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "action": "send_text_message",
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message": message,
      "type_reply": "",
      "type_file_name_reply": "",
      "image_reply": "",
      "message_reply": "",
      "reply_id": "",
    });

    if (response!.success == 1) {
      print(response!.data);
      print("sent message");
      sendFcmRequest1("Notification", message, "text", otherMemberID, token)
          .then((value) {
        refresh.updateRefresh(true);
        _detailedRefresh.updateRefresh(true);
        print(refresh.currentSelect.toString());
      });

      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 424
  static Future<String?> sendGif(
      String otherMemberID, String link, String token, String name) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_gif_sent_message.php?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.timeZone}&image_data=$link&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}");
    // final response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/send_gif_message_direct.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "image_data": link,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("gif message");
      sendFcmRequest1(name, "GIF", "gif", otherMemberID, token).then((value) {
        refresh.updateRefresh(true);
        _detailedRefresh.updateRefresh(true);
      });
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 467
  Future<String?> sendReplyMessage(
      String otherMemberID,
      String message,
      String token,
      String name,
      String type,
      String imageURL,
      String originalMessage,
      String replyID) async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.timeZone,
    //   "action": "send_text_message",
    //   "recipient_id": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message": message,
    //   "type_reply": type,
    //   "type_file_name_reply": "",
    //   "image_reply": imageURL,
    //   "message_reply": originalMessage,
    //   "reply_id": replyID,
    // });

    var response = await ApiRepo.postWithToken("api/send_text_message.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "action": "send_text_message",
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message": message,
      "type_reply": type,
      "type_file_name_reply": "",
      "image_reply": imageURL,
      "message_reply": originalMessage,
      "reply_id": replyID,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("text message");
      sendFcmRequest1(name, message, "text", otherMemberID, token)
          .then((value) {
        refresh.updateRefresh(true);
        _detailedRefresh.updateRefresh(true);
      });
      // getAllChats(otherMemberID, "");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 468
  Future<String?> sendLink(String otherMemberID, String token, String title,
      String desc, String url, String image, String domain, String name) async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.timeZone,
    //   "action": "send_link_message",
    //   "recipient_id": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message": url,
    //   "link_title": title,
    //   "link_desc": desc,
    //   "link_url": url,
    //   "link_image": image,
    //   "link_domain": domain,
    // });

    var response =
        await ApiRepo.postWithToken("api/send_link_message_direct.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "action": "send_link_message",
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message": url,
      "link_title": title,
      "link_desc": desc,
      "link_url": url,
      "link_image": image,
      "link_domain": domain,
    });

    print(title);
    print("titleeeeeeeeee");
    if (response!.success == 1) {
      print(response!.data);
      print("link message");
      sendFcmRequest1(name, _baseUrl, "text", otherMemberID, token)
          .then((value) {
        refresh.updateRefresh(true);
        _detailedRefresh.updateRefresh(true);
      });
      // getAllChats(otherMemberID, "");
      return "Success";
    } else {
      print(response!.data);
      print("link failed");
      return null;
    }
  }

// TODO:: inSheet 469
  Future<String?> sendContacts(
      String otherMemberID, String contacts, String token) async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.timeZone,
    //   "action": "send_text_message_contact_data",
    //   "recipient_id": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "contact_data": contacts,
    // });

    var response = await ApiRepo.postWithToken(
        "api/send_text_message_contact_data_direct.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "action": "send_text_message_contact_data",
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "contact_data": contacts,
    });

    if (response!.success == 1) {
      print(response!.data);

      sendFcmRequest1("Notification", contacts, "contact", otherMemberID, token)
          .then((value) {
        _detailedRefresh.updateRefresh(true);
        refresh.updateRefresh(true);
      });
      //getAllChatsLocal(otherMemberID);
      getAllChats(otherMemberID, "");

      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 470
  static Future<String?> syncContacts(List contacts) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data_contact.php?action=save_contact_list_of_the_user&user_id=${CurrentUser().currentUser.memberID}&timezone=${CurrentUser().currentUser.timeZone}&country=${CurrentUser().currentUser.country}");
    // final response = await http.post(url, body: contacts);
    print(contacts);

    var contact1 = jsonEncode(contacts);
    var sendData = {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "timezone": CurrentUser().currentUser.timeZone,
      "contacts": contacts
    };
    var response = await ApiRepo.postWithTokenNoFD(
        "api/member_contact_list_save.php", sendData);
    //print("===>${response!.status}");

    if (response!.data != null && response!.success == 1) {
      print(response!.data);

      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 471
  static Future<int> getUnreadMessagesCount() async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "action": "get_all_unread_count",
    // });

    var response =
        await ApiRepo.postWithToken("api/chat_unread_count_direct.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "action": "get_all_unread_count",
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      int count = response!.data['data']['total_unread_count'];
      return count;
    } else {
      return 0;
    }
  }

  List<TradesMan> lstTradesManModel = [];

  static Future<List<Data1>?>? managerTradeManList() async {
    var response = await ApiRepo.postWithToken("api/tradesmen_manage.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
    });
    if (response!.success == 1) {
      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "") {
        return TradesMan.fromJson(response!.data).data1;
      } else
        print('e1111-------');
    }
  }

  // static Future<List<ReviewData>> reviewDataList(tradesmanId) async {
  //   var companyId;
  //   var response =
  //       await ApiRepo.postWithToken('api/tradesmen_review_list.php', {
  //     // "user_id": CurrentUser().currentUser.memberID,
  //     "tradesman_id": tradesmanId,
  //     "company_id": companyId,
  //   });
  //   if (response!.success == 1) {
  //     if (response!.success == 1 &&
  //         response!.data['data'] != null &&
  //         response!.data['data'] != "") {
  //       print("responsssssss == ${response!.data['data']}");
  //       return ReviewDataListModel.fromJson(response!.data).data;
  //     } else
  //       print('e1111-------');
  //     return [];
  //   } else if (response!.success == 0) {
  //     print("==== #### 3");
  //     return ReviewDataListModel.fromJson(response!.data).data = [];
  //   } else if (response!.data == null) {
  //     print("==== #### 4");
  //     return [];
  //   }
  // }

  static Future<List<DataCompany>?>? existingCompanyList() async {
    var response =
        await ApiRepo.postWithToken('api/tradesmen_company_manage.php', {
      "user_id": CurrentUser().currentUser.memberID,
    });
    if (response!.success == 1) {
      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "") {
        print("responsssssss == ${response!.data['data']}");
        return ExistingCompany.fromJson(response!.data).data;
      } else
        print('e1111-------');
      return [];
    } else if (response!.success == 0) {
      print("==== #### 3");
      return ExistingCompany.fromJson(response!.data).data = [];
    } else if (response!.data == null) {
      print("==== #### 4");
      return [];
    }
  }

  static Future<List<ManageData>?> newManageTradesmenList(companyId) async {
    var response = await ApiRepo.postWithToken("api/tradesmen_manage.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "company_id": companyId,
    });
    print("==== #### 11 ${response!.success}");
    if (response!.success == 1) {
      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "") {
        print("==== #### 1 ${response!.data['data']}");
        return ManageTradesmen.fromJson(response!.data).data;
      } else
        print('==== #### 2');
      return [];
    } else if (response!.success == 0) {
      print("==== #### 3");
      return ManageTradesmen.fromJson(response!.data).data = [];
    } else if (response!.data == null) {
      print("==== #### 4");
      return [];
    }
  }

//TODO:: inSheet 329
  static Future<int?>? disableDirectChat(int val) async {
    print("responsee $val");
    var response = await ApiRepo.postWithToken("api/direct_chat_disable.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "val": val,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      return val;
    } else {
      return null;
    }
  }

//TODO:: inSheet 472
  static Future<bool> updateOnlineStatus(String status) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data.php?action=update_live_status&user_id=${CurrentUser().currentUser.memberID}&status=$status");
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/live_status_update_direct.php", {
      "action": "update_live_status",
      "user_id": CurrentUser().currentUser.memberID,
      "status": status,
    });

    if (response!.success == 1) {
      print(response!.data);
      return true;
    } else {
      return false;
    }
  }

//TODO:: inSheet 473
  Future<bool> updateAboutStatus(String status) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data.php?action=update_user_status&user_id=${CurrentUser().currentUser.memberID}&status_data=$status");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_status_update.php", {
      "action": "update_user_status",
      "user_id": CurrentUser().currentUser.memberID,
      "status_data": status,
    });

    if (response!.success == 1) {
      print(response!.data);

      getUserSelectedStatus().then((value) {
        _refreshAbout.updateRefresh(true);
      });
      getAllStatus();

      print("successsssssss");
      return true;
    } else {
      return false;
    }
  }

//TODO:: inSheet 474
  Future<String?> deleteMessages(String messages, String otherMemberID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data.php?action=delete_for_self&all_ids=$messages&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/chat_delete_for_self_direct.php", {
      "action": "delete_for_self",
      "user_id": CurrentUser().currentUser.memberID,
      "all_ids": messages,
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      _detailedRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 475
  Future<String?> deleteMessagesEveryone(
      String messages, String otherMemberID, String token) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data.php?action=delete_for_all&all_ids=$messages&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/chat_delete_for_all_direct.php", {
      "action": "delete_for_all",
      "user_id": CurrentUser().currentUser.memberID,
      "all_ids": messages,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("delete response");
      refresh.updateRefresh(true);
      _detailedRefresh.updateRefresh(true);
      updateDeleteStatus(token);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 476
  Future<String?> messageFromStory(
      String otherMemberID, String type, String urls, String message) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data.php?action=send_story_as_message&file_url=$urls&text=$message&user_id=${CurrentUser().currentUser.memberID}&recipient_id=$otherMemberID&type=$type");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/send_story_as_message_direct.php", {
      "action": "send_story_as_message",
      "user_id": CurrentUser().currentUser.memberID,
      "file_url": urls,
      "text": message,
      "recipient_id": otherMemberID,
      "type": type
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      _detailedRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 477
  Future<String?> questionReplyFromStory(String otherMemberID, String message,
      String postId, String storyId) async {
    var url = "https://www.bebuzee.com/api/storyPostResponse";
    var response = await ApiProvider().fireApiWithParamsPost(url, params: {
      "response_text": "$message",
      "user_id": "${CurrentUser().currentUser.memberID}",
      "post_id": "$postId",
      "position": "$storyId",
    }).then((value) => value);
// var url=''

    // var response = await http.get(url);

    if (response!.statusCode == 200 &&
        response!.data != null &&
        response!.data != "") {
      print('responsne of question reply ${response!.data}');
      refresh.updateRefresh(true);
      _detailedRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 478
  static Future<void> sendStoryToDirect(String path, String recipientID,
      String devicePath, String thumbnail, String type) async {
    var client = new Dio();
    FormData formData = new FormData.fromMap({
      "files": await MultipartFile.fromFile(path),
      "user_id": CurrentUser().currentUser.memberID,
      "recipient_id": recipientID,
      "thumbnail_path": thumbnail,
      "device_path": devicePath,
      "type": type
    });
    print({
      "user_id": CurrentUser().currentUser.memberID,
      "recipient_id": recipientID,
      "thumbnail_path": thumbnail,
      "device_path": devicePath,
      "type": type
    });
    var res = await ApiRepo.postWithTokenAndFormData(
      "api/send_file_direct.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('location progress: $progress');
      },
    );

    print(res.toString() + " upload");
    refresh.updateRefresh(true);
    _detailedRefresh.updateRefresh(true);
  }

//TODO:: inSheet 479
  static Future<String?> removeUser(String otherMemberIDs) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_message_data.php?action=delete_user_for_self&user_id=${CurrentUser().currentUser.memberID}&from_user=$otherMemberIDs");
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/delete_user_for_self_direct.php", {
      "action": "delete_user_for_self",
      "user_id": CurrentUser().currentUser.memberID,
      "from_user": otherMemberIDs,
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 480
  static Future<String?> setToken(String token) async {
    // var url = Uri.parse(_baseUrl);
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "token": token,
    //   "action": "save_user_token",
    // });

    var response =
        await ApiRepo.postWithToken("api/save_user_token_direct.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "token": token,
      "action": "save_user_token",
    });

    if (response!.success == 1) {
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet no need (no implementations)
  Future<mp.MultipartRequest> uploadSingleFile(String path, String type) async {
    mp.MultipartRequest request = mp.MultipartRequest();
    request.setUrl(
        "https://www.bebuzee.com/app_devlope_message_data.php?action=upload_file&type=$type&file1=");

    request.setUrl(ApiRepo.baseUrl + "api/send_multiple_file_data.php");
    request.addFields({
      "type": type,
    });
    request.addFile("file1", path);
    return request;
  }

//TODO:: inSheet 502
  Future<void> sendLocation(
      String otherMemberID,
      String latitude,
      String longitude,
      String locationTitle,
      String locationSubtitle,
      String path,
      String token) async {
    // var client = new Dio();

    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(path),
      "action": "send_text_message_location",
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "latitude": latitude,
      "longitude": longitude,
      "location_title": locationTitle,
      "location_subtitle": locationSubtitle,
      "path": path,
    });

    var res = await ApiRepo.postWithTokenAndFormData(
      "api/send_text_message_location_direct.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('location progress: $progress');
      },
    );
  }

//TODO:: inSheet no need (no implementations)
  Future<mp.MultipartRequest> uploadMultipleFiles(String data, String path,
      List<File> finalFiles, String memberID, String otherMemberID) async {
    print("upload start");
    mp.MultipartRequest request = mp.MultipartRequest();
    request.setUrl(
        "https://www.bebuzee.com/app_devlope_message_data.php?action=upload_file_multiple_file_data&all_messages=$data&user_id=$memberID&recipient_id=$otherMemberID");
    finalFiles.forEach((element) {
      request.addFile("files[]", element.path);
    });
    return request;
  }

//TODO:: inSheet 503
  static Future<void> uploadFiles(
      String data, List<File> finalFiles, String otherMemberID) async {
    // var client = new Dio();

    var formData = FormData.fromMap({
      "all_messages": data,
      "user_id": CurrentUser().currentUser.memberID,
      "recipient_id": otherMemberID,
    });

    for (var file in finalFiles) {
      formData.files.addAll([
        MapEntry("files[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    var response = await ApiRepo.postWithTokenAndFormData(
      "api/send_multiple_file_data_direct.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('multiple files progress: $progress');
      },
    );
    print(response);
  }

//TODO:: inSheet 504
  Future<void> uploadAudioFiles(List<File> audioFiles, String otherMemberID,
      String paths, String durations) async {
    // var client = new Dio();

    var formData = FormData.fromMap({
      "action": "save_audio_file",
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "device_path": paths,
      "duration": durations,
    });
    for (var file in audioFiles) {
      formData.files.addAll([
        MapEntry("files[]", await MultipartFile.fromFile(file.path)),
      ]);
    }
    await ApiRepo.postWithTokenAndFormData(
      "api/send_audio_file_direct.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('audio files progress: $progress');
      },
    );
  }

//TODO:: inSheet 505
  Future<void> uploadVoiceRecording(String audioPath, String otherMemberID,
      String path, String duration) async {
    // var client = new Dio();

    FormData formData = new FormData.fromMap({
      "files[]": await MultipartFile.fromFile(audioPath),
      "action": "save_audio_file_voice",
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "device_path": path,
      "duration": duration
    });

    var res = await ApiRepo.postWithTokenAndFormData(
      "api/send_audio_voice_file_direct.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('voice progress: $progress');
      },
    );
  }

//TODO:: inSheet 506
  Future<String?> downloadFile(
      String messageID, String path, String thumb, String otherMemberID) async {
    // var url = Uri.parse(_baseUrl);

    // final response =
    //     await http.post(url, body: {"message_id": messageID, "action": "change_download_status", "receiver_device_path": path, "receiver_thumbnail": thumb});

    var response = await ApiRepo.postWithToken(
        "api/chat_change_download_status_direct.php", {
      "message_id": messageID,
      "action": "change_download_status",
      "receiver_device_path": path,
      "receiver_thumbnail": thumb
    });

    if (response!.success == 1) {
      _detailedRefresh.updateRefresh(true);
      print(response!.data);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 507
  static Future<String?> sendBoard(String recipientID, String boardID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_board_sent_message.php?user_id=${CurrentUser().currentUser.memberID}&recipient_id=$recipientID&board_id=$boardID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/send_board_message.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "recipient_id": recipientID,
      "board_id": boardID
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      _detailedRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }
}
