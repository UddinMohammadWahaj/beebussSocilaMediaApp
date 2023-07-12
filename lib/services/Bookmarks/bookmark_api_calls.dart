import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Bookmarks/board_filter_model.dart';
import 'package:bizbultest/models/Bookmarks/board_posts_model.dart';
import 'package:bizbultest/models/Bookmarks/boards_list_model.dart';
import 'package:bizbultest/models/Bookmarks/boards_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/FeedAllApi/tokenutil.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/Boards/board_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiRepo.dart' as ApiRepo;

class BookMarkApiCalls {
  static final String memberID = CurrentUser().currentUser.memberID!;
  static final BoardController boardController = Get.put(BoardController());
  static final FeedController feedController = Get.put(FeedController());
//TODO :: inSheet 246
  static Future<String?> createNewBoard(
      String postID, String name, bool secrete) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_save_post_to_board.php?user_id=$memberID&post_id=$postID&name=$name&secrate=$secrete");
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/save_post_to_board.php", {
      "user_id": memberID,
      "name": name,
      "post_id": postID,
      "secrate": secrete,
    });
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      boardController.getSavedBoards("", "");
      feedController.getBoardsList();
      print(response!.data['data']);
      return "Success";
    } else {
      return null;
    }
  }

//TODO :: inSheet 247
  static Future<String?> saveToBoard(String postID, String boardID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_api/board/boardAdd?user_id=$memberID&board_id=$boardID&post_id=$postID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/post_add_to_board.php", {
      "user_id": memberID,
      "board_id": boardID,
      "post_id": postID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      boardController.getSavedBoards("", "");
      //feedController.getBoardsList();
      print(response!.data['data']);
      return "Success";
    } else {
      return null;
    }
  }

//TODO :: inSheet 248
  static Future<SavedBoards> fetchSavedBoards(
      String sort, String keyword) async {
    try {
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/app_devlope_post_board_list.php?user_id=${OtherUser().otherUser.memberID}&shorting=$sort&search=$keyword");
      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/board/boardList", {
        "user_id": OtherUser().otherUser.memberID,
        "shorting": sort,
        "search": keyword,
      });

      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "" &&
          response!.data['data'] != "null") {
        SavedBoards boards = SavedBoards.fromJson(response!.data['data']);
        return boards;
      } else {
        return SavedBoards([]);
      }
    } on SocketException {
      print("no internet");
      return SavedBoards([]);
    }
  }

//TODO :: inSheet 249
  static Future<SavedBoards> fetchOtherUserBoards(
      String sort, String keyword, String memberID) async {
    try {


      var response = await ApiRepo.postWithToken("api/board/secureBoardList", {
        "user_id": memberID,
        "shorting": sort,
        "search": keyword,
      });

      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "" &&
          response!.data['data'] != "null") {
        SavedBoards boards = SavedBoards.fromJson(response!.data['data']);
        return boards;
      } else {
        return SavedBoards([]);
      }
    } on SocketException {
      print("no internet");
      return SavedBoards([]);
    }
  }

//TODO :: inSheet 250
  static Future<BoardsList> fetchBoardsList() async {
    print(CurrentUser().currentUser.memberID!.toString() + " MEMBER");
    try {
      // var newurl = Uri.parse(
      //     'https://www.bebuzee.com/api/board/boardList?user_id=${CurrentUser().currentUser.memberID!}');

      // var client = Dio();
      // String token =
      //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
      // var resp = await client
      //     .postUri(
      //       newurl,
      //       options: Options(headers: {
      //         'Content-Type': 'application/json',
      //         'Accept': 'application/json',
      //         'Authorization': 'Bearer $token',
      //       }),
      //     )
      //     .then((value) => value.data);

      var response = await ApiRepo.postWithToken("api/board/boardList", {
        "user_id": memberID,
      });

      if (response!.success == 1) {
        BoardsList boards = BoardsList.fromJson(response!.data['data']);
        print("boards here $boards");
        return boards;
      } else {
        return BoardsList([]);
      }

      // var url = Uri.parse(
      //     "https://www.bebuzee.com/app_devlope_post_board_list_simple.php?user_id=${CurrentUser().currentUser.memberID!}");
      // var response = await http.get(url);
      // print(url);
      // if (response!.statusCode == 200 &&
      //     response!.body != null &&
      //     response!.body != "" &&
      //     response!.body != "null") {
      //   print(response!.body);
      //   BoardsList boards = BoardsList.fromJson(jsonDecode(response!.body));

      //   return boards;
      // } else {
      //   return BoardsList([]);
      // }
    } on SocketException {
      print("no internet");
      return BoardsList([]);
    }
  }

//TODO :: inSheet 251
  static Future<BoardFilter> fetchFilterList() async {
    try {
      // var url = Uri.parse(
      // "https://www.bebuzee.com/app_devlope_member_settings.php?user_id=${OtherUser().otherUser.memberID}&type=board_filter");
      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/board/boardSettings", {
        "user_id": OtherUser().otherUser.memberID,
        "type": "board_filter",
      });

      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "" &&
          response!.data['data'] != "null") {
        BoardFilter filters = BoardFilter.fromJson(response!.data['data']);
        return filters;
      } else {
        return BoardFilter([]);
      }
    } on SocketException {
      print("no internet");
      return BoardFilter([]);
    }
  }

//TODO :: inSheet 252
  static Future<List<BoardPostsModel>> fetchPosts(String boardID) async {
    print(OtherUser().otherUser.memberID);
    print("other");
    try {
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/app_devlope_post_board_post_list.php?user_id=${OtherUser().otherUser.memberID}&board_id=$boardID");
      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/board/postBoardList", {
        "user_id": OtherUser().otherUser.memberID,
        "board_id": boardID,
      });

      if (response!.success == 1 &&
          response!.data['data'] != null &&
          response!.data['data'] != "" &&
          response!.data['data'] != "null") {
        BoardPosts posts = BoardPosts.fromJson(response!.data['data']);
        return posts.posts;
      } else {
        return <BoardPostsModel>[];
      }
    } on SocketException {
      print("no internet");
      return <BoardPostsModel>[];
    }
  }

//TODO :: inSheet 257
  static Future<String?> deletePost(String postID, String boardID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_board_post_delete.php?post_id=$postID&board_id=$boardID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/board/postBoardDelete", {
      "post_id": postID,
      "board_id": boardID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      boardController.getSavedBoards("", "");
      feedController.getBoardsList();
      print(response!.data['data']);
      return "Success";
    } else {
      return null;
    }
  }

//TODO :: inSheet 258
  static Future<String?> starPost(String postID, String boardID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_board_post_starred.php?post_id=$postID&board_id=$boardID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/board/postStarred", {
      "post_id": postID,
      "board_id": boardID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      return "Success";
    } else {
      return null;
    }
  }

//TODO :: inSheet 259
  static Future<String?> editBoard(
      String boardID, String name, String description, bool secrete) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_board_details_edit.php?user_id=$memberID&board_id=$boardID&name=$name&description=$description&secrate=$secrete");
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/post_board_details_editphp.", {
      "user_id": memberID,
      "board_id": boardID,
      "name": name,
      "description": description,
      "secrate": secrete,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      boardController.getSavedBoards("", "");
      feedController.getBoardsList();
      return "Success";
    } else {
      return null;
    }
  }

//TODO :: inSheet 260
  static Future<String?> deleteBoard(String boardID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_board_delete.php?user_id=$memberID&board_id=$boardID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/board/boardDelete", {
      "user_id": memberID,
      "board_id": boardID,
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      boardController.getSavedBoards("", "");
      feedController.getBoardsList();
      return "Success";
    } else {
      return null;
    }
  }

  static Future<String?> mergeBoards(String board1, String board2) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_post_board_merge.php?user_id=$memberID&board_id_1=$board1&board_id_2=$board2");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/board/boardMerge",
        {"user_id": memberID, "board_id_1": board1, "board_id_2": board2});
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      print(response!.data['data']);
      boardController.getSavedBoards("", "");
      feedController.getBoardsList();
      return "Success";
    } else {
      return null;
    }
  }
}
