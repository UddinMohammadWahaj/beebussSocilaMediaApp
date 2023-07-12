import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class ChatApiCalls {
  static ChatsRefresh refresh = ChatsRefresh();
  static DetailedChatRefresh detailedChatRefresh = DetailedChatRefresh();
  late AudioPlayer player;

  static final String _baseUrl =
      "https://www.bebuzee.com/api/chat_contact_list.php";
  static final String _baseUrl2 =
      "https://www.bebuzee.com/app_develope_contact_chat_1.php";

  static String? path2;

//TODO:: inSheet 353
  static Future<DirectUsers> getChatsList(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("chat_contacts");
    try {
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/app_develope_contact_chat.php?action=get_all_chat_contact_list&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&timezone=Asia/Kolkata");
      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/chat_contact_list.php", {
        "user_id": CurrentUser().currentUser.memberID!,
        "country": CurrentUser().currentUser.country,
        "timezone": CurrentUser().currentUser.timeZone
      });

      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "") {
        DirectUsers directUserData =
            DirectUsers.fromJson(response!.data['data']);
        //print("response success " + directUserData.users[0].fromuserid);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("chat_contacts", jsonEncode(response!.data['data']));
        return directUserData;
      } else {
        if (chatData != null) {
          DirectUsers directUserData =
              DirectUsers.fromJson(jsonDecode(chatData));
          return directUserData;
        } else {
          return DirectUsers([]);
        }
      }
    } on SocketException {
      if (chatData != null) {
        DirectUsers directUserData = DirectUsers.fromJson(jsonDecode(chatData));
        return directUserData;
      } else {
        return DirectUsers([]);
      }
    }
  }

//TODO:: inSheet 354
  static Future<DirectUsers> getArchivedList() async {
    // var url = Uri.parse(
    //     "$_baseUrl2?action=get_all_chat_archive_list&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&timezone=${CurrentUser().currentUser.timeZone}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/chat_archive_list.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "timezone": "Asia/Kolkata"
    });

    if (response != null &&
        response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      DirectUsers directUserData = DirectUsers.fromJson(response!.data['data']);
      return directUserData;
    } else {
      return DirectUsers([]);
    }
  }

//TODO:: inSheet 355
  static Future<DirectUsers?> getSelectedGroupUserList(String groupID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_contact_chat_1.php?action=all_members_in_group&user_id=${CurrentUser().currentUser.memberID!}&group_id=$groupID&timezone=${CurrentUser().currentUser.timeZone}");
    // print(url);
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/members_in_group_list.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "timezone": CurrentUser().currentUser.timeZone,
      "group_id": groupID
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      DirectUsers directUserData = DirectUsers.fromJson(response!.data['data']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          "participants$groupID", jsonEncode(response!.data['data']));
      return directUserData;
    } else {
      return null;
    }
  }

  static Future<DirectUsers> getSelectedGroupUserListLocal(
      String groupID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("participants$groupID");
    if (userData != null) {
      DirectUsers directUserData = DirectUsers.fromJson(jsonDecode(userData));
      return directUserData;
    } else {
      return new DirectUsers([]);
    }
  }

  static Future<DirectUsers> getChatsListLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("chat_contacts");
    if (chatData != null) {
      DirectUsers directUserData = DirectUsers.fromJson(jsonDecode(chatData));
      return directUserData;
    } else {
      return new DirectUsers([]);
    }
  }

//TODO:: inSheet 356
  static Future<DirectUsers?> getChatContactsList(String search) async {
    // var url = Uri.parse("$_baseUrl?action=get_search_user&user_id=${CurrentUser().currentUser.memberID!}&keywords=");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/chat_search_user.php",
        {"user_id": CurrentUser().currentUser.memberID!, "keywords": search});

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      DirectUsers directUserData = DirectUsers.fromJson(response!.data['data']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("contacts", jsonEncode(response!.data['data']));
      return directUserData;
    } else {
      return null;
    }
  }

  static Future<DirectUsers> getChatContactsListLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("contacts");
    if (chatData != null) {
      DirectUsers directUserData = DirectUsers.fromJson(jsonDecode(chatData));
      return directUserData;
    } else {
      return new DirectUsers([]);
    }
  }

  static Future<void> sendFcmRequest(String _title, String _message,
      String type, String otherMemberID, String token, int blocked, int muted,
      {bool isVideo = false}) async {
    print(blocked);
    print(muted.toString() + "muted");
    if (blocked == 0) {
      var headersData = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
      };

      String _calling = "";
      if (_message.contains("cut")) {
        _calling = "Hangup";
      } else {
        _calling = "Calling...";
      }
      var bodyData = {
        "notification": {},
        "data": {
          "user_id": CurrentUser().currentUser.memberID!,
          "other_user_id": CurrentUser().currentUser.memberID!,
          "type": type,
          "body": _message,
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "category": "chat",
          "title": _title,
          "showWhen": true,
          "autoCancel": true,
          "privacy": "Private",
        },
        "to": token,
        "priority": "high",
        // "to": "fDkyPtYDQeOxkDtgdbTTGn:APA91bFgyHX9NP2MW3Qk0bOht69K334G9B8eLquYwfSxNNctSjFEBjuLtg4EzvNLQYkuU8bDdQ6y5BbDXXW1EsIv7gx_1tjkVxMwQhWC6-59V8JMwcvKKtTeJxHQk4tRw_pIHdDL0Rmd",
        'android': {
          'notification': {
            'channel_id': ' your_channel_id',
          },
        }
      };
      var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
      final res = await http
          .post(url, body: jsonEncode(bodyData), headers: headersData)
          .then((value) {
        print("sendFcmRequest==> ${value.body.toString()}");
        print("sent");
      });
    } else {
      print("blocked");
    }
  }

  static Future<void> sendFcmRequest1(String _title, String _message,
      String type, String otherMemberID, String token, int blocked, int muted,
      {bool isVideo = false}) async {
    List<String> tokens = [];
    tokens = token.split(",");
    print(blocked);
    print(muted.toString() + "muted");
    for (int i = 0; i < tokens.length; i++) {
      if (blocked == 0) {
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
      } else {
        print("blocked");
      }
    }
  }

//TODO:: inSheet 357
  Future<String?> removeUser(String otherMemberIDs) async {
    // var url = Uri.parse("$_baseUrl?action=delete_user_for_self&user_id=${CrurentUser().currentUser.memberID}&from_user=$otherMemberIDs");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/delete_user_for_self.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "from_user": otherMemberIDs,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      refresh.updateRefresh(true);
      print("removedddd chat");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 358
  Future<String?> addToArchive(String otherMemberIDs) async {
    // var url = Uri.parse(
    // "$_baseUrl2?action=enable_archive&user_id=${CurrentUser().currentUser.memberID!}&other_user_ids=$otherMemberIDs");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/chat_enable_archive.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "other_user_ids": otherMemberIDs,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      refresh.updateRefresh(true);
      print("archived chat");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 359
  Future<String?> removeFromArchive(String otherMemberIDs) async {
    // var url = Uri.parse(
    //     "$_baseUrl2?action=disable_archive&user_id=${CurrentUser().currentUser.memberID!}&other_user_ids=$otherMemberIDs");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/chat_disable_archive.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "other_user_ids": otherMemberIDs,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      refresh.updateRefresh(true);
      print("removed archived chat");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 360
  Future<String?> blockUser(String otherMemberID) async {
    // var url = Uri.parse(
    // "$_baseUrl?action=blocked_user&user_id=${CurrentUser().currentUser.memberID!}&to_user_id=$otherMemberID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/chat_blocked_user.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "to_user_id": otherMemberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      detailedChatRefresh.updateRefresh(true);
      refresh.updateRefresh(true);
      print("blocked user");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 361
  Future<String?> unblockUser(String otherMemberID) async {
    // var url = Uri.parse(
    //     "$_baseUrl?action=unblocked_user&user_id=${CurrentUser().currentUser.memberID!}&to_user_id=$otherMemberID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/chat_unblocked_user.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "to_user_id": otherMemberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      detailedChatRefresh.updateRefresh(true);
      refresh.updateRefresh(true);
      print("unblocked user");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 362
  Future<String?> clearChat(
      String otherMemberID, int deleteStarred, BuildContext context) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_contact_chat_1.php?action=clear_chat_data_from_user&user_id=${CurrentUser().currentUser.memberID!}&recipient_id=$otherMemberID&delete_star=$deleteStarred");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/chat_clear_data_from_user.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "recipient_id": otherMemberID,
      "delete_star": deleteStarred
    });
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      //Navigator.pop(context);
      print("chat clearrredddd");
      detailedChatRefresh.updateRefresh(true);
      refresh.updateRefresh(true);

      return "Success";
    } else {
      print("failed");
      return null;
    }
  }

//TODO:: inSheet 363
  Future<String?> sendTextMessage(String otherMemberID, String message,
      String token, int blocked, String name, int muted) async {
    // var url = Uri.parse(_baseUrl);

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
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

    var response = await ApiRepo.postWithToken("api/send_text_message.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message": message,
      "type_reply": "",
      "type_file_name_reply": "",
      "image_reply": "",
      "message_reply": "",
      "reply_id": "",
    });
    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print("text message");
      sendFcmRequest1(
              name, message, "text", otherMemberID, token, blocked, muted ?? 0)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      // getAllChats(otherMemberID, "");
      return "Success";
    } else {
      print("no message");
      return null;
    }
  }

//TODO:: inSheet 364
  static Future<String?> sendGif(String otherMemberID, String link,
      String token, int blocked, String name, int muted) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_gif_sent.php?user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.timeZone}&image_data=$link&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}");
    // final response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/send_gif_message.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.timeZone,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "image_data": link,
    });
    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print("gif message");
      sendFcmRequest1(name, "Sent a Gif", "gif", otherMemberID, token, blocked,
              muted ?? 0)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 365
  Future<String?> sendReplyMessage(
      String otherMemberID,
      String message,
      String token,
      int blocked,
      String name,
      String type,
      String imageURL,
      String originalMessage,
      String replyID,
      int muted) async {
    // var url = Uri.parse(_baseUrl);

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
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
      "user_id": CurrentUser().currentUser.memberID!,
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
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print("text message");
      sendFcmRequest1(
              name, message, "text", otherMemberID, token, blocked, muted)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      // getAllChats(otherMemberID, "");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 366
  Future<String?> sendLink(
      String otherMemberID,
      String token,
      int blocked,
      String title,
      String desc,
      String url,
      String image,
      String domain,
      String name,
      int muted) async {
    // var url = Uri.parse(_baseUrl);

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
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

    var response = await ApiRepo.postWithToken("api/send_link_message.php", {
      "user_id": CurrentUser().currentUser.memberID!,
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
    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print("link message");
      sendFcmRequest1(name, url, "text", otherMemberID, token, blocked, muted)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      // getAllChats(otherMemberID, "");
      return "Success";
    } else {
      print("link failed");
      return null;
    }
  }

  void openLink(String link) async {
    String url = link;
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }

//TODO:: inSheet baki
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
    print(urlStr);
    try {
      var url = Uri.parse(_baseUrl);

      final response = await http.post(url, body: {
        "user_id": CurrentUser().currentUser.memberID!,
        "country": CurrentUser().currentUser.country,
        "action": "get_chat_data",
        "fromuserid": otherMemberID,
        "timezone": CurrentUser().currentUser.timeZone,
        "message_id": urlStr.substring(0, urlStr.length - 1),
        "date_data": messages.messages[messages.messages.length - 1].dateData,
      });
      if (response!.statusCode == 200 &&
          response!.body != null &&
          response!.body != "" &&
          response!.body != "null") {
        ChatMessages chatData =
            ChatMessages.fromJson(jsonDecode(response!.body));
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

//TODO:: inSheet 367
  Future<String?> sendContacts(String otherMemberID, String contacts,
      String token, int blocked, String name, int muted) async {
    // var url = Uri.parse(_baseUrl);
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "country": CurrentUser().currentUser.timeZone,
    //   "action": "send_text_message_contact_data",
    //   "recipient_id": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "contact_data": contacts,
    // });

    var response =
        await ApiRepo.postWithToken("api/send_text_message_contact_data.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.timeZone,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "contact_data": contacts,
    });
    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      sendFcmRequest1(
              name, contacts, "contact", otherMemberID, token, blocked, muted)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      //getAllChatsLocal(otherMemberID);

      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 368
  Future<void> sendLocation(
      String name,
      String otherMemberID,
      String latitude,
      String longitude,
      String locationTitle,
      String locationSubtitle,
      String path,
      String token) async {
    // var client = new Dio();
    // FormData formData = new FormData.fromMap({
    //   "file": await MultipartFile.fromFile(path),
    // });
    // var res = await client.post(
    //   "$_baseUrl?action=send_text_message_location&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}&latitude=$latitude&longitude=$longitude&location_title=$locationTitle&location_subtitle=$locationSubtitle&path=$path",
    //   data: formData,
    //   onSendProgress: (int sent, int total) {
    //     final progress = (sent / total) * 100;
    //     print('location progress: $progress');
    //   },
    // );
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(path),
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.timeZone,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "latitude": latitude,
      "longitude": longitude,
      "location_title": locationTitle,
      "location_subtitle": locationSubtitle,
      "path": path
    });

    var response = await ApiRepo.postWithTokenAndFormData(
        "api/send_text_message_location.php", formData, (int sent, int total) {
      final progress = (sent / total) * 100;
      print('location progress: $progress');
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      sendFcmRequest1(
              name, "Sent a Location", "location", otherMemberID, token, 0, 0)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      //getAllChatsLocal(otherMemberID);
    }
  }

//TODO:: inSheet 369
  Future<void> uploadAudioFiles(
      String token,
      String name,
      List<File> audioFiles,
      String otherMemberID,
      String paths,
      String durations) async {
    // var client = new Dio();
    // var formData = FormData();
    // for (var file in audioFiles) {
    //   formData.files.addAll([
    //     MapEntry("files[]", await MultipartFile.fromFile(file.path)),
    //   ]);
    // }
    // await client.post(
    //   "$_baseUrl?action=save_audio_file&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}&device_path=$paths&duration=$durations&files=",
    //   data: formData,
    //   onSendProgress: (int sent, int total) {
    //     final progress = (sent / total) * 100;
    //     print('audio files progress: $progress');
    //   },
    // );

    FormData formData = new FormData.fromMap({
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.timeZone,
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

    var response = await ApiRepo.postWithTokenAndFormData(
        "api/send_audio_file.php", formData, (int sent, int total) {
      final progress = (sent / total) * 100;
      print('location progress: $progress');
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      sendFcmRequest1(name, "Sent a Audio", "audio", otherMemberID, token, 0, 0)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      //getAllChatsLocal(otherMemberID);
    }
  }

//TODO:: inSheet 370
  Future<void> uploadVoiceRecording(String token, String name, String audioPath,
      String otherMemberID, String path, String duration) async {
    // var client = new Dio();
    // FormData formData = new FormData.fromMap({
    //   "files[]": await MultipartFile.fromFile(audioPath),
    // });
    // var res = await client.post(
    //   "$_baseUrl?action=save_audio_file_voice&user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}&device_path=$path&duration=$duration&files=",
    //   data: formData,
    //   onSendProgress: (int sent, int total) {
    //     final progress = (sent / total) * 100;
    //     print('voice progress: $progress');
    //   },
    // );
    FormData formData = new FormData.fromMap({
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.timeZone,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "device_path": path,
      "duration": duration,
    });

    formData.files.addAll([
      MapEntry("files[]", await MultipartFile.fromFile(audioPath)),
    ]);

    var response = await ApiRepo.postWithTokenAndFormData(
        "api/send_audio_voice_file.php", formData, (int sent, int total) {
      final progress = (sent / total) * 100;
      print('location progress: $progress');
    });
    print(response);
    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      sendFcmRequest1(name, "Sent a Voice recording", "audio", otherMemberID,
              token, 0, 0)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
      //getAllChatsLocal(otherMemberID);
    }
  }

//TODO:: inSheet 371
  Future<String?> deleteMessages(String messages, String otherMemberID) async {
    // var url = Uri.parse("$_baseUrl?action=delete_for_self&all_ids=$messages&user_id=${CurrentUser().currentUser.memberID!}");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/chat_delete_for_self.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "all_ids": messages,
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      refresh.updateRefresh(true);
      detailedChatRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 372
  Future<String?> starMessage(String messages) async {
    // var url = Uri.parse("$_baseUrl?action=star_message_update&all_ids=$messages&user_id=${CurrentUser().currentUser.memberID!}");
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/chat_star_message_update.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "all_ids": messages,
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      detailedChatRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 373
  Future<String?> unstarMessage(String messages) async {
    // var url = Uri.parse( "$_baseUrl?action=unstar_star_message_update&all_ids=$messages&user_id=${CurrentUser().currentUser.memberID!}");

    // var response = await http.get(url);
    var response =
        await ApiRepo.postWithToken("api/chat_unstar_message_update.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "all_ids": messages,
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print("group created");
      detailedChatRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 374
  Future<String?> deleteMessagesEveryone(
      String messages, String otherMemberID, String token) async {
    // var url =  Uri.parse("$_baseUrl?action=delete_for_all&all_ids=$messages&user_id=${CurrentUser().currentUser.memberID!}");

    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/chat_delete_for_all.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "all_ids": messages,
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print("delete response");
      refresh.updateRefresh(true);
      detailedChatRefresh.updateRefresh(true);
      updateDeleteStatus(token);
      return "Success";
    } else {
      return null;
    }
  }

  Future<mp.MultipartRequest> uploadMultipleFiles(
      String data,
      String path,
      List<File> finalFiles,
      String memberID,
      String otherMemberID,
      String popPath) async {
    mp.MultipartRequest request = mp.MultipartRequest();
    // request.setUrl(
    //     "https://www.bebuzee.com/app_develope_contact_chat.php?action=upload_file_multiple_file_data&all_messages=$data&user_id=$memberID&recipient_id=$otherMemberID");

    request.setUrl(ApiRepo.baseUrl + "api/send_multiple_file_data.php");
    request.addFields({
      "all_messages": data,
      "user_id": memberID,
      "recipient_id": otherMemberID
    });
    finalFiles.forEach((element) {
      request.addFile("files[]", element.path);
    });
    return request;
  }

  static Future<void> uploadFiles(String data, String token, String name,
      List<File> finalFiles, String otherMemberID) async {
    print(data);
    String? path2;
    print("all messages");
    // var client = new Dio();
    // var formData = FormData();
    // for (var file in finalFiles) {
    //   formData.files.addAll([
    //     MapEntry("files[]", await MultipartFile.fromFile(file.path)),
    //   ]);
    // }
    // await client.post(
    //   "https://www.bebuzee.com/app_develope_contact_chat.php?action=upload_file_multiple_file_data&all_messages=$data&user_id=${CurrentUser().currentUser.memberID!}&recipient_id=$otherMemberID",
    //   data: formData,
    //   onSendProgress: (int sent, int total) {
    //     final progress = (sent / total) * 100;
    //     print('multiple files progress: $progress');
    //   },
    // );

    FormData formData = new FormData.fromMap({
      "user_id": CurrentUser().currentUser.memberID!,
      "recipient_id": otherMemberID,
      "all_messages": data,
    });
    for (var file in finalFiles) {
      formData.files.addAll([
        MapEntry("files[]", await MultipartFile.fromFile(file.path)),
      ]);
      path2 = file.path;
    }

    var response = await ApiRepo.postWithTokenAndFormData(
        "api/send_multiple_file_data.php", formData, (int sent, int total) {
      final progress = (sent / total) * 100;
      print('location progress: $progress');
    });
    print(response);

    if (response!.success == 1) {
      sendFcmRequest1(
              name,
              path2!.contains(".jpeg") ||
                      path2.contains(".png") ||
                      path2.contains(".svg") ||
                      path2.contains(".jpg")
                  ? "Sent a Image"
                  : "Sent a Document",
              "text",
              otherMemberID,
              token,
              0,
              0)
          .then((value) {
        refresh.updateRefresh(true);
        detailedChatRefresh.updateRefresh(true);
      });
    }

    //  if(response!.success==1){
    //     var res = await Dio().download(
    //           "https://www.bebuzee.com/new_files/chat_message_image_videos/"+"${path2.split("/").last}", "/storage/emulated/0/Bebuzee/Bebuzee Images"+"${path2.split("/").last}",
    //           onReceiveProgress: (int sent, int total) {
    //         final progress = (sent / total) * 100;
    //         print('image download progress: $progress');

    //       });
    //  }
  }

  static Future<ChatMessages> getAllChats(
      String otherMemberID, String messages) async {
    // var url = Uri.parse(_baseUrl);
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "country": CurrentUser().currentUser.country,
    //   "action": "get_chat_data",
    //   "fromuserid": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message_id": messages
    // });

    final response = await ApiRepo.postWithToken("api/chat_data.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "fromuserid": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message_id": messages
    });

    print(response!.data);
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      ChatMessages chatData = ChatMessages.fromJson(response!.data['data']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          "main_chats$otherMemberID", jsonEncode(response!.data['data']));
      return chatData;
    } else {
      return new ChatMessages([]);
    }
  }

  static Future<ChatMessages> getAllMedia(
      String otherMemberID, String messages) async {
    // var url = Uri.parse(_baseUrl2);

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "country": CurrentUser().currentUser.country,
    //   "action": "get_all_image_videos_data",
    //   "fromuserid": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message_id": messages
    // });

    final response =
        await ApiRepo.postWithToken("api/chat_all_image_videos_data.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "action": "get_all_image_videos_data",
      "fromuserid": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message_id": messages
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      ChatMessages chatData = ChatMessages.fromJson(response!.data['data']);
      return chatData;
    } else {
      return new ChatMessages([]);
    }
  }

  static Future<ChatMessages> getAllLinks(String otherMemberID) async {
    // var url = Uri.parse(_baseUrl2);

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "country": CurrentUser().currentUser.country,
    //   "action": "get_all_links_data",
    //   "fromuserid": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    // });

    final response =
        await ApiRepo.postWithToken("api/chat_all_links_data.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "action": "get_all_links_data",
      "fromuserid": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      ChatMessages chatData = ChatMessages.fromJson(response!.data['data']);
      return chatData;
    } else {
      return new ChatMessages([]);
    }
  }

  static Future<ChatMessages> getAllDocs(
      String otherMemberID, String messages) async {
    // var url = Uri.parse(_baseUrl2);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "country": CurrentUser().currentUser.country,
    //   "action": "get_all_docs_data",
    //   "fromuserid": otherMemberID,
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "message_id": messages
    // });

    final response = await ApiRepo.postWithToken("api/chat_all_docs_data.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "action": "get_all_docs_data",
      "fromuserid": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "message_id": messages
    });

    print(response!.data);
    print("All docs");
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      ChatMessages chatData = ChatMessages.fromJson((response!.data['data']));
      return chatData;
    } else {
      return new ChatMessages([]);
    }
  }

  static Future<ChatMessages> getStarredMessages(String keywords) async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "action": "get_all_starred_messages_contact",
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "keywords": keywords
    // });

    final response = await ApiRepo.postWithToken(
        "api/chat_all_starred_messages_contact.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "action": "get_all_starred_messages_contact",
      "timezone": CurrentUser().currentUser.timeZone,
      "keywords": keywords,
      "fromuserid": ""
    });

    print(response!.data['data']);
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      ChatMessages chatData = ChatMessages.fromJson((response!.data['data']));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("starred", jsonEncode(response!.data['data']));
      return chatData;
    } else {
      return new ChatMessages([]);
    }
  }

  static Future<ChatMessages> getStarredMessagesSingleUser(
      String otherMemberID) async {
    // var url = Uri.parse(_baseUrl);
    //
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "action": "get_all_starred_memssage_single_chat",
    //   "timezone": CurrentUser().currentUser.timeZone,
    //   "fromuserid": otherMemberID
    // });

    final response = await ApiRepo.postWithToken(
        "api/chat_all_starred_memssage_single_chat.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "action": "get_all_starred_memssage_single_chat",
      "timezone": CurrentUser().currentUser.timeZone,
      "fromuserid": otherMemberID
    });

    print(response!.data['data']);
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      print(response!.data['data']);
      ChatMessages chatData = ChatMessages.fromJson(response!.data['data']);
      return chatData;
    } else {
      return new ChatMessages([]);
    }
  }

  static Future<ChatMessages> getStarredMessagesLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("starred");
    if (chatData != null) {
      ChatMessages chats = ChatMessages.fromJson(jsonDecode(chatData));
      return chats;
    } else {
      return new ChatMessages([]);
    }
  }

  static Future<ChatMessages?> getAllChatsLocal(String otherMemberID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString("main_chats$otherMemberID");
    if (chatData != null) {
      ChatMessages chats = ChatMessages.fromJson(jsonDecode(chatData));
      return chats;
    } else {
      return null;
    }
  }

  Future<String?> downloadFile(
      String messageID, String path, String thumb, String otherMemberID) async {
    // var url = Uri.parse(_baseUrl);

    // final response = await http.post(url, body: {
    //   "message_id": messageID,
    //   "action": "change_download_status",
    //   "receiver_device_path": path,
    //   "receiver_thumbnail": thumb
    // });

    final response =
        await ApiRepo.postWithToken("api/chat_change_download_status.php", {
      "message_id": messageID,
      "action": "change_download_status",
      "receiver_device_path": path,
      "receiver_thumbnail": thumb
    });

    if (response!.success == 1 &&
        response!.data != null &&
        response!.data != "") {
      print(response!.success);
      // _detailedChatRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

  Future<List<String>?> getLinkPreview(String urls) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/ajax_call_content_contact.php?action=getmeta_details&url=$urls");

    // var response = await http.get(url);

    final response = await ApiRepo.postWithToken("api/link_to_meta_details.php",
        {"action": "getmeta_details", "url": "$urls"});

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      String desc = (response!.data)['data']['desc'];
      String description = (response!.data)['data']['descript_real'];
      String image = (response!.data)['data']['image'];
      String domain = (response!.data)['data']['domain'];
      List<String> info = [];
      info.add(desc);
      info.add(description);
      info.add(image);
      info.add(domain);
      return info;
    } else {
      return null;
    }
  }

  Future<String?> forwardMessages(String messages, String memberIDs) async {
    var url = Uri.parse(
        "$_baseUrl?action=forward_selected_messages&all_messages=$messages&to_user_ids=$memberIDs&user_id=${CurrentUser().currentUser.memberID!}");

    // var response = await http.get(url);

    final response =
        await ApiRepo.postWithToken("api/chat_forward_selected_messages.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "all_messages": messages,
      "to_user_ids": "$memberIDs"
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      /*sendFcmRequest("Notification", "", "text", otherMemberID, token).then((value) {

      });*/
      refresh.updateRefresh(true);

      return "success";
    } else {
      return null;
    }
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
        "user_id": CurrentUser().currentUser.memberID!,
        "other_user_id": CurrentUser().currentUser.memberID!,
        "type": "delete",
        "body": "",
        "category": "deleteChat",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "priority": "high",
      "to": token
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final res =
        await http.post(url, body: jsonEncode(bodyData), headers: headersData);
  }

  static Future<bool> updateOnlineStatus(String status) async {
    var url = Uri.parse(
        "$_baseUrl?action=update_live_status&user_id=${CurrentUser().currentUser.memberID!}&status=$status");
    var response = await http.get(url);

    if (response!.statusCode == 200 &&
        response!.body != null &&
        response!.body != "") {
      print(response!.body);
      print("successsssssss");
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getCurrentUserNumber() async {
    // var url = Uri.parse(
    //     "$_baseUrl?action=get_user_contact&user_id=${CurrentUser().currentUser.memberID!}");
    // var response = await http.get(url);

    final response = await ApiRepo.postWithToken("api/chat_user_contact.php",
        {"user_id": CurrentUser().currentUser.memberID!});

    if (response != null &&
        response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      print(response!.data['data']);
      String number = "";
      number = response!.data['data']['contact_number'];
      // print("got number");
      print(number);
      return number;
    } else {
      return "";
    }
  }

  Future<String?> muteUser(String otherMemberID, String muteDuration) async {
    print("called");

    // var url = Uri.parse(
    //     "$_baseUrl?action=mute_notification&user_id=${CurrentUser().currentUser.memberID!}&to_member=$otherMemberID&mute_duration=$muteDuration&timezone=${CurrentUser().currentUser.timeZone}");
    //
    // var response = await http.get(url);

    final response = await ApiRepo.postWithToken("api/mute_notification.php", {
      "user_id": CurrentUser().currentUser.memberID!,
      "to_member": "$otherMemberID",
      "mute_duration": "$muteDuration",
      "timezone": CurrentUser().currentUser.timeZone
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      print("muteddddd");
      refresh.updateRefresh(true);
      return "Success";
    } else {
      print("bad responseee");
      return null;
    }
  }
}
