import 'package:bizbultest/models/Bookmarks/board_filter_model.dart';
import 'package:bizbultest/models/Bookmarks/boards_model.dart';
import 'package:bizbultest/services/Bookmarks/bookmark_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/Boards/board_posts_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  var savedBoardsList = <BoardModel>[].obs;
  var otherUserBoardsList = <BoardModel>[].obs;
  var filterList = <BoardFilterModel>[].obs;
  var isLoading = false.obs;
  var searchController = TextEditingController();
  var message = "".obs;

  @override
  void onInit() {
    OtherUser().otherUser.memberID = CurrentUser().currentUser.memberID;
    debounce(message, (_) {
      getSavedBoards("", searchController.text);
    }, time: Duration(milliseconds: 500));

    searchController = TextEditingController()
      ..addListener(() {
        if (searchController.text.isNotEmpty) {
          message.value = searchController.value.text;
        }
      });
    getSavedBoards("", "");
    getFilters();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getSavedBoards(String sort, String keyword) async {
    try {
      isLoading(true);
      var boards = await BookMarkApiCalls.fetchSavedBoards(sort, keyword);
      if (boards != null) {
        savedBoardsList.assignAll(boards.boards);
      }
    } finally {
      isLoading(false);
    }
  }

  void getOtherUserBoards(String memberID) async {
    try {
      /*changesss goes heree*/
      isLoading(true);
      var boards =
          await BookMarkApiCalls.fetchOtherUserBoards("", "", memberID);
      print("==========#######------11-- ${boards.boards.length}.");
      if (boards != null) {
        otherUserBoardsList.assignAll(boards.boards);
      }
      print("==========#######------ ${otherUserBoardsList.length}.");
    } finally {
      isLoading(false);
    }
  }

  void getFilters() async {
    var filters = await BookMarkApiCalls.fetchFilterList();
    if (filters != null) {
      filterList.assignAll(filters.filters);
    }
  }

  void setNameAndDescription(String name, String description) {
    BoardPostsController boardPostsController = Get.put(BoardPostsController());
    boardPostsController.boardName.value = name;
    boardPostsController.boardDescription.value = description;
  }
}
