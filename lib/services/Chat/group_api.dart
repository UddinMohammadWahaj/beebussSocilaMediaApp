import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class GroupApiCalls {
  static ChatsRefresh refresh = ChatsRefresh();
  static DetailedChatRefresh _detailedChatRefresh = DetailedChatRefresh();

  static final String _baseUrl =
      "https://www.bebuzee.com/api/chat_contact_list.php";
  static final String _baseUrl2 =
      "https://www.bebuzee.com/app_develope_contact_chat_1.php";

//TODO:: inSheet 510
  Future<String?> _setTopicGroup(String topic, String groupID) async {
    // var url = Uri.parse("$_baseUrl?action=group_topic_data_update&user_id=${CurrentUser().currentUser.memberID}&topic=$topic&group_id=$groupID");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/update_group_topic.php", {
      "action": "group_topic_data_update",
      "topic": topic,
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
    });

    print("before success response");

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 511
  static Future<DirectUsers?> getAdminList(String groupID) async {
    // var url = Uri.parse(
    //     "$_baseUrl2?action=get_all_admins_from_group&group_id=$groupID&user_id=${CurrentUser().currentUser.memberID}&timezone=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/all_admins_from_group.php", {
      "action": "get_all_admins_from_group",
      "group_id": groupID,
      "user_id": CurrentUser().currentUser.memberID,
      "timezone": CurrentUser().currentUser.timeZone,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      DirectUsers directUserData = DirectUsers.fromJson(response!.data['data']);
      print("got admins");
      return directUserData;
    } else {
      return null;
    }
  }

//TODO:: inSheet 512
  Future<int?> getGroupStatus(String memberID, String groupID) async {
    // var url = Uri.parse("$_baseUrl2?action=get_exit_status_from_group&user_id=$memberID&group_id=$groupID");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/exit_status_from_group.php", {
      "action": "get_exit_status_from_group",
      "user_id": memberID,
      "group_id": groupID,
    });

    if (response!.success == 1) {
      print(response!.data['data']);
      print("group statuss");
      int status;
      status = response!.data['data']['group_status'];
      print(status.toString());
      return status;
    } else {
      return null;
    }
  }

  void subscribeToTopicGroup(String groupID) {
    FirebaseMessaging firebaseMessaging;
    FirebaseMessaging.instance.subscribeToTopic("group_$groupID").then((value) {
      _setTopicGroup("group_$groupID", groupID);
    });
  }

  void subscribeToTopicBroadcast(String broadcastID) {
    FirebaseMessaging firebaseMessaging;
    FirebaseMessaging.instance
        .subscribeToTopic("broad_$broadcastID")
        .then((value) {
      _setTopicGroup("broad_$broadcastID", broadcastID);
    });
  }

//TODO:: inSheet 513
  Future<String?> createGroupWithoutIcon(String memberIDs, String name) async {
    // var url = Uri.parse("$_baseUrl?action=create_a_new_group&user_id=${CurrentUser().currentUser.memberID}&memberids=$memberIDs&name=$name");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/create_a_new_group.php", {
      "action": "create_a_new_group",
      "user_id": CurrentUser().currentUser.memberID,
      "memberids": memberIDs,
      "name": name,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      String groupID = "";
      groupID = (response!.data['data'])['group_id'];
      print("group without icon");
      print(groupID);
      subscribeToTopicGroup(groupID);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 514
  Future<String?> createBroadcast(String memberIDs, String name) async {
    // var url = Uri.parse("$_baseUrl?action=create_a_broadcast&user_id=${CurrentUser().currentUser.memberID}&memberids=$memberIDs&broadcast_name=$name");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/create_a_broadcast.php", {
      "action": "create_a_broadcast",
      "user_id": CurrentUser().currentUser.memberID,
      "memberids": memberIDs,
      "broadcast_name": name,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      print("broadcast created");
      String broadcastID = "";
      broadcastID = (response!.data['data'])['broadcast_id'];
      print(broadcastID);
      subscribeToTopicBroadcast(broadcastID);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 515
  Future<String?> changeGroupSubject(String groupName, String groupID) async {
    // var url = Uri.parse("$_baseUrl2?action=update_group_name&group_id=$groupID&name=$groupName&user_id=${CurrentUser().currentUser.memberID}");
    // print(url);
    // var response = await http.get(url);
    //

    var response = await ApiRepo.postWithToken("api/update_group_name.php", {
      "action": "update_group_name",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "name": groupName,
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
      print("name changed");
      return "Success";
    } else {
      print("failedddd");
      return null;
    }
  }

//TODO:: inSheet 516
  Future<String?> addOrEditGroupDescription(
      String groupDesc, String groupID) async {
    // var url = Uri.parse("$_baseUrl2?action=update_group_description&group_id=$groupID&description=$groupDesc&user_id=${CurrentUser().currentUser.memberID}");
    // print(url);
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/update_group_description.php", {
      "action": "update_group_description",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "description": groupDesc,
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
      print("group description changed");
      return "Success";
    } else {
      print("failedddd");
      return null;
    }
  }

//TODO:: inSheet 517
  Future<String?> updateEditGroupInfo(
      int val, String groupID, String topic) async {
    // var url = Uri.parse("$_baseUrl?action=update_edit_group_info&group_id=$groupID&data_edit=$val&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/update_edit_group_info.php", {
      "action": "update_edit_group_info",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "data_edit": val,
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      fcmGroupActions(topic, groupID);
      print("edit group info changed");
      return "Success";
    } else {
      print("wronggggggggg");
      return null;
    }
  }

//TODO:: inSheet 518
  Future<String?> updateSendMessageInfo(
      int val, String groupID, String topic) async {
    print(val);
    print(groupID);
    print(topic);

    // var url = Uri.parse("$_baseUrl2?action=update_send_message&group_id=$groupID&data_edit=$val&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/update_send_message.php", {
      "action": "update_send_message",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "data_edit": val,
    });

    if (response!.success == 1) {
      print(response!.data);
      refresh.updateRefresh(true);
      fcmGroupActions(topic, groupID);
      print("edit group info changed");
      return "Success";
    } else {
      print("wronggggggggg");
      return null;
    }
  }

//TODO:: inSheet 519
  Future<String?> addMembersToGroup(
      String memberIDs, String groupID, String topic) async {
    // var url = Uri.parse("$_baseUrl?action=add_member_to_group&group_id=$groupID&all_members=$memberIDs&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/add_member_to_group.php", {
      "action": "add_member_to_group",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "all_members": memberIDs,
    });

    if (response!.success == 1) {
      print(response!.data);
      fcmGroupActions(topic, groupID);
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
      print("added to group");
      return "Success";
    } else {
      print("nulll");
      return null;
    }
  }

//TODO:: inSheet 520
  Future<String?> removeMembersFromGroup(
      String memberIDs, String groupID, String topic) async {
    print(memberIDs);
    print(groupID);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_contact_chat_1.php?action=remove_user_from_group&remove_user_id=$memberIDs&group_id=$groupID&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/add_member_to_group.php", {
      "action": "remove_user_from_group",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "remove_user_id": memberIDs,
    });

    if (response!.success == 1) {
      print(response!.data);
      fcmGroupActions(topic, groupID);
      print("removed from group");
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 521
  Future<String?> makeGroupAdmin(
      String memberID, String groupID, String topic) async {
    // var url = Uri.parse("$_baseUrl?action=add_admin_to_group&user_id=$memberID&group_id=$groupID&by_user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/add_admin_to_group.php", {
      "action": "add_admin_to_group",
      "by_user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "user_id": memberID,
    });

    if (response!.success == 1) {
      print(response!.data);
      fcmGroupActions(topic, groupID);
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
      print("made admin");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 522
  Future<String?> removeGroupAdmin(
      String memberID, String groupID, String topic) async {
    // var url = Uri.parse(
    //     "$_baseUrl2?action=remove_admin_authority_group_user&user_id=$memberID&group_id=$groupID&by_user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/remove_admin_authority.php", {
      "action": "remove_admin_authority_group_user",
      "by_user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
      "user_id": memberID,
    });

    if (response!.success == 1) {
      print(response!.data);
      fcmGroupActions(topic, groupID);
      print("removed admin");
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);

      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 523
  Future<String?> exitGroup(String groupID, String topic) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_contact_chat_1.php?action=exit_group_user&user_id=${CurrentUser().currentUser.memberID}&group_id=$groupID");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/exit_group_user.php", {
      "action": "exit_group_user",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
    });

    if (response!.success == 1) {
      print(response!.data);
      fcmGroupActions(topic, groupID);
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
      print("EXITED GROUP");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 524
  Future<String?> deleteMessagesEveryone(
      String messages, String groupID, String topic) async {
    // var url = Uri.parse("$_baseUrl2?action=delete_for_all_group&user_id=${CurrentUser().currentUser.memberID}&all_ids=$messages");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/delete_for_all_group.php", {
      "action": "delete_for_all_group",
      "user_id": CurrentUser().currentUser.memberID,
      "all_ids": messages,
    });

    if (response!.success == 1) {
      print(response!.data);
      fcmGroupActions(topic, groupID);
      print("deleted for everyone");
      refresh.updateRefresh(true);
      _detailedChatRefresh.updateRefresh(true);
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 525
  static Future<String?> reportGroup(String groupID) async {
    // var url = Uri.parse("$_baseUrl?action=report_group&group_id=$groupID&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/report_group.php", {
      "action": "report_group",
      "user_id": CurrentUser().currentUser.memberID,
      "group_id": groupID,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("reported GROUP");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 526
  static Future<String?> reportMember(String memberID) async {
    // var url = Uri.parse("$_baseUrl?action=report_chat_data&user_id=${CurrentUser().currentUser.memberID}&to_user_id=$memberID");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/report_chat_data.php", {
      "action": "report_chat_data",
      "user_id": CurrentUser().currentUser.memberID,
      "to_user_id": memberID,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("reported GROUP");
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 527
  static Future<List<int>?> getGroupPermissions(String groupID) async {
    // var url = Uri.parse("$_baseUrl2?action=get_authority_in_group&group_id=$groupID&user_id=${CurrentUser().currentUser.memberID}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/authority_in_group.php", {
      "action": "get_authority_in_group",
      "group_id": groupID,
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      int editInfo = (response!.data['data'])['edit_info'];
      int sendMessage = (response!.data['data'])['send_message'];

      print("got group permissions");
      return [editInfo, sendMessage];
    } else {
      return null;
    }
  }

//TODO:: inSheet 528
  static Future<mp.MultipartRequest> createGroupWithIcon(
      String memberIDs, String name, String path) async {
    mp.MultipartRequest request = mp.MultipartRequest();
    request.setUrl(ApiRepo.baseUrl + "api/create_a_new_group.php");
    request.addFile("file", path);
    request.addField("action", "create_a_new_group");
    request.addField("user_id", CurrentUser().currentUser.memberID);
    request.addField("memberids", memberIDs);
    request.addField("name", name);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    request.addHeader("Authorization", "Bearer $token");
    return request;
  }

//TODO:: inSheet 529
  Future<String?> sendContacts(
      String otherMemberID, String contacts, String topic, int muted) async {
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

    var response =
        await ApiRepo.postWithToken("api/send_text_message_contact_data.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "action": "send_text_message_contact_data",
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
      "contact_data": contacts,
    });

    if (response!.success == 1) {
      print(response!.data);

      sendFcmRequest(
              "Notification", contacts, "contact", otherMemberID, topic, muted)
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

//TODO:: inSheet 530
  Future<void> sendLocation(
      String otherMemberID,
      String latitude,
      String longitude,
      String locationTitle,
      String locationSubtitle,
      String path,
      String token) async {
    var client = new Dio();
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
      "path": path
    });

    var res = await ApiRepo.postWithTokenAndFormData(
      "api/send_text_message_location.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('location progress: $progress');
      },
    );
  }

//TODO:: inSheet 531
  Future<String?> sendTextMessage(
      String otherMemberID, String message, String topic, int mute) async {
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

    var response = await ApiRepo.postWithToken("api/send_text_message.php", {
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
      sendFcmRequest(
              "Notification", message, "text", otherMemberID, topic, mute)
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

//TODO:: inSheet 532
  static Future<String?> sendGif(String name, String otherMemberID,
      String message, String topic, int mute, String link) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_gif_sent.php?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.timeZone}&image_data=$lin
    //     k&recipient_id=$otherMemberID&timezone=${CurrentUser().currentUser.timeZone}");
    // final response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/send_gif_message.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.timeZone,
      "image_data": link,
      "recipient_id": otherMemberID,
      "timezone": CurrentUser().currentUser.timeZone,
    });

    if (response!.success == 1) {
      print(response!.data);
      print("gif message");
      sendFcmRequest(name, "GIF", "gif", otherMemberID, topic, mute)
          .then((value) {
        refresh.updateRefresh(true);
        _detailedChatRefresh.updateRefresh(true);
      });
      return "Success";
    } else {
      return null;
    }
  }

//TODO:: inSheet 533
  Future<String?> sendReplyMessage(
      String otherMemberID,
      String message,
      String topic,
      String name,
      String type,
      String imageURL,
      String originalMessage,
      String replyID,
      int mute) async {
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
    //

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
      sendFcmRequest(
              "Notification", message, "text", otherMemberID, topic, mute)
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

//TODO:: inSheet 534
  Future<String?> sendLink(String otherMemberID, String topic, String title,
      String desc, String url, String image, String domain, int mute) async {
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

    var response = await ApiRepo.postWithToken("api/send_link_message.php", {
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
      sendFcmRequest(
              "Notification", _baseUrl, "text", otherMemberID, topic, mute)
          .then((value) {
        refresh.updateRefresh(true);
        _detailedChatRefresh.updateRefresh(true);
      });
      // getAllChats(otherMemberID, "");
      return "Success";
    } else {
      print(response!.data);
      print("link failed");
      return null;
    }
  }

//TODO:: inSheet 535
  static Future<mp.MultipartRequest> uploadMultipleFiles(
      String data,
      String path,
      List<File> finalFiles,
      String memberID,
      String otherMemberID) async {
    mp.MultipartRequest request = mp.MultipartRequest();
    request.setUrl(ApiRepo.baseUrl + "api/send_multiple_file_data.php");
    finalFiles.forEach((element) {
      request.addFile("files[]", element.path);
      request.addField("action", "upload_file_multiple_file_data");
      request.addField("all_messages", data);
      request.addField("user_id", memberID);
      request.addField("recipient_id", otherMemberID);
    });
    return request;
  }

//TODO:: inSheet 536
  static Future<void> uploadFiles(
      String data, List<File> finalFiles, String groupID) async {
    var client = new Dio();
    var formData = FormData.fromMap({
      "action": "upload_file_multiple_file_data",
      "user_id": CurrentUser().currentUser.memberID,
      "recipient_id": groupID,
      "all_messages": data
    });

    for (var file in finalFiles) {
      formData.files.addAll([
        MapEntry("files[]", await MultipartFile.fromFile(file.path)),
      ]);
    }
    await ApiRepo.postWithTokenAndFormData(
      "api/send_multiple_file_data.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('multiple files progress: $progress');
      },
    );
  }

  static Future<void> fcmTypingStatus(
      String name, String status, String topic, String groupID) async {
    var headersData = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
    };
    var bodyData = {
      // "notification": {"title": "", "body": ""},
      "data": {
        "user_id": CurrentUser().currentUser.memberID,
        "group_id": groupID,
        "type": "group_typing",
        "body": "",
        "status": status,
        "name": name
        //"click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "priority": "high",
      "to": "/topics/$topic"
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final res =
        await http.post(url, body: jsonEncode(bodyData), headers: headersData);
  }

  static Future<void> fcmGroupActions(String topic, String groupID) async {
    var headersData = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
    };
    var bodyData = {
      // "notification": {"title": "", "body": ""},
      "data": {
        "user_id": CurrentUser().currentUser.memberID,
        "group_id": groupID,
        "category": "actions",
        "body": "",
        "status": "",
        //"click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "priority": "high",
      "to": "/topics/$topic"
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final res =
        await http.post(url, body: jsonEncode(bodyData), headers: headersData);
  }

  static Future<void> sendFcmRequest(String _title, String _message,
      String type, String otherMemberID, String topic, int muted) async {
    if (muted == 0) {
      print(topic);
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
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "category": "group"
        },
        "priority": "high",
        "to": "/topics/$topic"
      };

      var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

      final res = await http.post(url,
          body: jsonEncode(bodyData), headers: headersData);
    } else {
      var headersData = {
        'content-type': 'application/json',
        'Authorization':
            'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
      };
      var bodyData = {
        "data": {
          "user_id": CurrentUser().currentUser.memberID,
          "other_user_id": CurrentUser().currentUser.memberID,
          "type": type,
          "body": _message,
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "category": "group"
        },
        "priority": "high",
        "to": "/topics/$topic"
      };

      var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

      final res = await http.post(url,
          body: jsonEncode(bodyData), headers: headersData);
    }
  }

//TODO:: inSheet 537
  static Future<DirectUsers?> getCommonGroupsList(String otherMemberID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_contact_chat_1.php?action=groups_in_common&user_id=${CurrentUser().currentUser.memberID}&recipient_id=$otherMemberID");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/groups_in_common.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "action": "groups_in_common",
      "recipient_id": otherMemberID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      DirectUsers directUserData = DirectUsers.fromJson(response!.data['data']);
      print("found groupsss");
      return directUserData;
    } else {
      return null;
    }
  }
}
