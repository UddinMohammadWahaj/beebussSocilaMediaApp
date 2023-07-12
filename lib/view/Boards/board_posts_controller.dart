import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Bookmarks/board_posts_model.dart';
import 'package:bizbultest/services/Bookmarks/bookmark_api_calls.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BoardPostsController extends GetxController {
  var postsList = <BoardPostsModel>[].obs;
  var boardID = "".obs;
  var selectedViewIndex = 1.obs;
  List<double> aspectRatio = [1, 9 / 16, 9 / 16];
  List<int> crossAxisCount = [1, 2, 3];
  List<String> views = [
    AppLocalizations.of(
      "Wide",
    ),
    AppLocalizations.of(
      "Default",
    ),
    AppLocalizations.of(
      "Compact",
    ),
  ].obs;

  var isEdit = false.obs;
  var boardName = "".obs;
  var boardDescription = "".obs;
  TextEditingController boardNameController = TextEditingController();
  TextEditingController boardDescriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getPosts(String boardID) async {
    print(boardID);
    postsList.clear();
    List<BoardPostsModel> posts = await BookMarkApiCalls.fetchPosts(boardID);
    if (posts != null) {
      postsList.assignAll(posts);
      postsList.forEach((element) {
        element.starred!.value = element.isStarred!;
      });
      print(postsList.length);
    } else {}
  }

  void toggleEdit() {
    isEdit.value = !isEdit.value;
  }

  void setSelectedView(int index) {
    Get.back();
    selectedViewIndex.value = index;
  }

  void removePost(
      int index, BuildContext context, String postID, String boardID) {
    if (postsList.length == 1) {
      Navigator.pop(context);
      isEdit.value = false;
    }
    postsList.removeAt(index);
    BookMarkApiCalls.deletePost(postID, boardID);
  }

  void starPost(int index, String postID, String boardID) {
    postsList[index].starred!.value = !postsList[index].starred!.value;
    BookMarkApiCalls.starPost(postID, boardID);
  }

  void deleteBoard(BuildContext context, String boardID) {
    customToastWhite("Board Deleted", 15, ToastGravity.BOTTOM);
    Get.back();
    Navigator.pop(context);
    Navigator.pop(context);
    BookMarkApiCalls.deleteBoard(boardID);
  }

  void editBoard(BuildContext context, String boardID, bool secrete) {
    customToastWhite("Board Updated", 15, ToastGravity.BOTTOM);
    Navigator.pop(context);
    BookMarkApiCalls.editBoard(boardID, boardNameController.text,
        boardDescriptionController.text, secrete);
    boardName.value = boardNameController.text;
    boardDescription.value = boardDescriptionController.text;
  }
}
