import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Bookmarks/boards_list_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Bookmarks/bookmark_api_calls.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Story/get_story_api_calls.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

import '../country_name.dart';
import '../current_user.dart';

class FeedController extends GetxController {
  var file = new File("path").obs;
  var isUploading = false.obs;
  HomepageRefreshState refreshFeeds = new HomepageRefreshState();

  RefreshProfile refreshProfile = new RefreshProfile();
  RefreshShortbuz refreshShortbuz = new RefreshShortbuz();
  var uploadProgress = 0.0.obs;
  var directUsersList = <DirectMessageUserListModel>[].obs;
  var boardsList = <BoardsListModel>[].obs;
  var mainDirectUsersList = <DirectMessageUserListModel>[].obs;
  late TextEditingController searchController;
  TextEditingController messageController = TextEditingController();
  var hideNavBar = false.obs;

  @override
  void onInit() {
    searchController = TextEditingController()
      ..addListener(() {
        searchUsers(searchController.text);
      });
    getTimezone();
    getBoardsList();
    print("on init");
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getBoardsList() async {
    var boards = await BookMarkApiCalls.fetchBoardsList();
    if (boards != null) {
      boardsList.assignAll(boards.boards);
    }
  }

  List<BoardsListModel> boardsMergedList(String boardID) {
    List<BoardsListModel> boards = <BoardsListModel>[];
    boards.assignAll(boardsList);
    BoardsListModel board = new BoardsListModel();
    boards.forEach((element) {
      if (element.boardId == boardID) {
        board = element;
      }
    });
    boards.remove(board);
    return boards;
  }

  void mergeBoards(String board1, String board2, BuildContext context) {
    BookMarkApiCalls.mergeBoards(board1, board2);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void sendBoardDirect(index, String boardID) {
    directUsersList[index].selected!.value = true;
    DirectApiCalls.sendBoard(directUsersList[index].fromuserid!, boardID);
  }

  void sendStoryDirect(int index, String path, String recipientID,
      String devicePath, String thumbnail, String type) {
    directUsersList[index].selected!.value = true;
    DirectApiCalls.sendStoryToDirect(
        path, recipientID, devicePath, thumbnail, type);
  }

  void resetDirectList() {
    directUsersList.forEach((element) {
      if (element.selected!.value) {
        element.selected!.value = false;
      }
    });
  }

  void postToStory(String postID) {
    Get.back();
    GetStoryApi.sharePostToStory(postID);
  }

  Future<String> getTimezone() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    CurrentUser().currentUser.timeZone = locationX["timezone"];
    getUserDirectList();
    return "Success";
  }

  void getUserDirectList() {
    DirectApiCalls.getDirectUserList().then((users) {
      directUsersList.assignAll(users.users);
      mainDirectUsersList.assignAll(users.users);
    });
  }

  void searchUsers(String name) {
    directUsersList.value = mainDirectUsersList
        .where((element) =>
            element.name.toString().toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  Future<String> saveRatio(String video, String h, String w) async {
    var response = await http.get(Uri.parse(
        "https://www.upload.bebuzee.com/video_upload_api.php?action=save_videos_to_other_ratio&video_url=$video&video_height=$h&video_width=$w"));
    if (response.statusCode == 200) {
      print(response.body);
    }
    return "success";
  }

  Future<String> generateThumbnail(String fn, String video) async {
    var response = await http.get(Uri.parse(
        "https://www.upload.bebuzee.com/short_video.php?action=upload_short_video_thumb_generate&data_video_url=$video&fn_image=$fn"));
    if (response.statusCode == 200) {
      print(response.body);
      print("thumbnaillllll");
      refreshFeeds.updateRefresh(true);
      refreshProfile.updateRefresh(true);
    }
    return "success";
  }

  Future<String> videoCompression(int postID) async {
    var url = Uri.parse(
        "https://www.upload.bebuzee.com/video_upload_api.php?action=compress_video_data&post_id=$postID");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      print("compression successful");
    }
    return "success";
  }

  Future<void> uploadFeedPost(
      List<File?> allFiles, String url, Map<String, dynamic> mapData) async {
    var client = new dio.Dio();
    var formData = dio.FormData.fromMap(mapData);
    // var formData = dio.FormData();
    hideNavBar.value = false;
    isUploading.value = true;
    if (allFiles != null && allFiles.isNotEmpty) {
      // file.value = allFiles[0];

      allFiles.forEach((element) {
        print(element!.path.toString() + " thispathtoservertest");
      });

      for (var file in allFiles) {
        formData.files.addAll([
          MapEntry("files[]", await dio.MultipartFile.fromFile(file!.path)),
        ]);
      }
    }

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    var res;
    var extradat = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print("extradat=${extradat}");
    try {
      print("response of upload =${formData.fields} \n extradat=${extradat} ");
      print("response of upload =${formData.files} \n extradat=${extradat} ");
      print("response of upload =${formData.camelCaseContentDisposition} \n extradat=${extradat} ");
      res = await client.post(url,
          data: formData,
 
          // queryParameters: mapData,
          options: dio.Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }), onSendProgress: (int sent, int total) {
        final progress = (sent / total) * 100;
        uploadProgress.value = (sent / total);
        print('feed post progress: $progress');
      }, onReceiveProgress: (int sent, int total) {
        final progress = (sent / total) * 100;
        uploadProgress.value = (sent / total);
        print('feed post recieve progress: $progress');
      });
    } catch (e) {
      print("error upload=$e");
    }
    print('response of upload =${res}');
    print("upload success of feed post data ${res}");
    if (res.toString() != "") {
      print("upload success of feed post data");
      print("response is ${res}");
      // int postID = jsonDecode(res.toString())['post_id'];
      // videoCompression(postID);
    }
    isUploading.value = false;
    file.value = File("file");
    uploadProgress.value = 0.0;
    refreshFeeds.updateRefresh(true);
    refreshProfile.updateRefresh(true);
  }

  Future<void> uploadShortVideo(
      File videoFile, String url, bool fromShortbuz) async {
    hideNavBar.value = false;
    isUploading.value = true;
    file.value = videoFile;
    var client = new dio.Dio();
    print("url=${url}");
    dio.FormData formData = new dio.FormData.fromMap({
      "file1": await dio.MultipartFile.fromFile(videoFile.path),
    });
    if (fromShortbuz) {
      Get.dialog(ProcessingDialog(
        title: "Uploading your short video...",
        heading: "",
      ));
    }

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var res = await client.post(
      url,
      data: formData,
      options: dio.Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
      onSendProgress: (int sent, int total) {
        final progress = (sent / total) * 100;
        uploadProgress.value = (sent / total);
        print('shortbuz progress: $progress');
      },
      // ignore: missing_return
    ).onError((error, stackTrace) async {
      print("short error=$error");
      throw 0;
    });

    if (fromShortbuz) {
      Get.back();
      customToastWhite("Uploaded successfully", 15, ToastGravity.BOTTOM);
    }
    print(res.toString() + " shortbuz");
    isUploading.value = false;
    file.value = File("file");
    uploadProgress.value = 0.0;
    refreshShortbuz.updateRefresh(true);
    refreshFeeds.updateRefresh(true);
    refreshProfile.updateRefresh(true);
    var videoUrl = jsonDecode(res.toString())['video'];
    var h = jsonDecode(res.toString())['video_height'];
    var w = jsonDecode(res.toString())['video_width'];
    var fnImage = jsonDecode(res.toString())['fn_image'];
    var dataVideoUrl = jsonDecode(res.toString())['data_video_url'];
    saveRatio(videoUrl, h, w);
    generateThumbnail(fnImage, dataVideoUrl);
  }

  Future<void> uploadStory(List<File> allFiles, String url) async {
    hideNavBar.value = false;
    isUploading.value = true;
    file.value = allFiles[0];
    var client = new dio.Dio();
    var formData = dio.FormData();
    for (var file in allFiles) {
      formData.files.addAll([
        MapEntry("files[]", await dio.MultipartFile.fromFile(file.path)),
      ]);
    }
    var res = await client.post(
      url,
      data: formData,
      onSendProgress: (int sent, int total) {
        final progress = (sent / total) * 100;
        uploadProgress.value = (sent / total);
        print('story post progress: $progress');
      },
    );
    isUploading.value = false;
    file.value = File("file");
    uploadProgress.value = 0.0;
    refreshFeeds.updateRefresh(true);
    refreshProfile.updateRefresh(true);
  }

  Future<String> postUpdate(String postID, String content) async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=update_post_data_text&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&content=$content");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/post_content_update.php?action=update_post_data_text&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&content=$content');
    var client = Dio();

    var response = await client
        .postUri(newurl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }))
        .then((value) => value);
    // var response = await http.get(url);
    print("update data response=${response.data}");
    String updatedContent = "";
    if (response.statusCode == 200) {
      updatedContent = response.data['updated_data'];
      return updatedContent;
    } else {
      return "";
    }
  }
}
