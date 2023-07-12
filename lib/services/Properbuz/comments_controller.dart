import 'package:bizbultest/models/Properbuz/post_liked_users_model.dart';
import 'package:bizbultest/models/Properbuz/properbuz_comments_model.dart';
import 'package:bizbultest/services/Properbuz/api/properbuz_comments_api.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentsController extends GetxController {
  var usersList = <PostLikedUsersModel>[].obs;
  var areCommentsLoading = false.obs;
  var selectedCommentID = "".obs;
  var selectedPostID = "".obs;
  var selectedSubCommentID = "".obs;
  var selectedCommentIndex = 0.obs;
  var selectedSubCommentIndex = 0.obs;
  var isSubComment = false.obs;

  var commentsList = <ProperbuzCommentsModel>[].obs;
  ScrollController scrollController = ScrollController();

  void scrollToTop() async {
    await Future.delayed(const Duration(milliseconds: 800));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
    });
  }

  void getUsers(String postID) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usersList.clear();
    });
    var users = await ProperbuzCommentsAPI.fetchUsers(postID);
    usersList.assignAll(users);
  }

  void getComments(String postID) async {
    areCommentsLoading.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentsList.clear();
    });
    var comments = await ProperbuzCommentsAPI.fetchComments(postID);
    commentsList.assignAll(comments);
    areCommentsLoading.value = false;
  }

  void deleteComment(int index, int feedIndex, int val) async {
    String commentID = commentsList[index].commentID!;
    Get.back();
    commentsList.removeAt(index);
    Get.showSnackbar(properbuzSnackBar("Comment deleted"));
    int comments = await ProperbuzCommentsAPI.deleteComment(commentID);
    ProperbuzFeedController controller = Get.put(ProperbuzFeedController());
    controller.getFeedsList(val)[index].totalComment!.value = comments;
  }

  void deleteSubComment(
      int index, int feedIndex, int val, int subCommentIndex) async {
    String subCommentId =
        commentsList[index].subComments![subCommentIndex].subCommentId!;
    Get.back();
    commentsList[index].subComments!.removeAt(subCommentIndex);
    commentsList[index].replies!.value--;
    Get.showSnackbar(properbuzSnackBar("Comment deleted"));
    ProperbuzCommentsAPI.deleteSubComment(subCommentId);
  }

  void editComment(int index, BuildContext context) async {
    Get.back();
    isSubComment.value = false;
    ProperbuzFeedController controller = Get.put(ProperbuzFeedController());
    controller.commentController.text = commentsList[index].comment!.value;
    controller.isCommentEdit.value = true;
    selectedCommentID.value = commentsList[index].commentID!;
    selectedCommentIndex.value = index;
    await SystemChannels.textInput.invokeMethod('TextInput.show');
    controller.focusNode.requestFocus();
  }

  void editSubComment(
      int index, int subCommentIndex, BuildContext context) async {
    Get.back();
    isSubComment.value = true;
    ProperbuzFeedController controller = Get.put(ProperbuzFeedController());
    controller.commentController.text =
        commentsList[index].subComments![subCommentIndex].comment!.value;
    controller.isCommentEdit.value = true;
    selectedSubCommentID.value =
        commentsList[index].subComments![subCommentIndex].subCommentId!;
    selectedSubCommentIndex.value = index;
    await SystemChannels.textInput.invokeMethod('TextInput.show');
    controller.focusNode.requestFocus();
  }

  void likeComment(int index, String postID) {
    commentsList[index].likeStatus!.value =
        !commentsList[index].likeStatus!.value;
    if (commentsList[index].likeStatus!.value) {
      commentsList[index].likes!.value++;
    } else {
      commentsList[index].likes!.value--;
    }
    ProperbuzCommentsAPI.likeUnlikeComment(
        postID, commentsList[index].commentID!);
  }

  void likeSubComment(int commentIndex, int subCommentIndex, String postID) {
    commentsList[commentIndex].subComments![subCommentIndex].likeStatus!.value =
        !commentsList[commentIndex]
            .subComments![subCommentIndex]
            .likeStatus!
            .value;
    if (commentsList[commentIndex]
        .subComments![subCommentIndex]
        .likeStatus!
        .value) {
      commentsList[commentIndex].subComments![subCommentIndex].likes!.value++;
    } else {
      commentsList[commentIndex].subComments![subCommentIndex].likes!.value--;
    }
    ProperbuzCommentsAPI.likeUnlikeSubComment(
        commentsList[commentIndex].subComments![subCommentIndex].subCommentId!);
  }

  Color getLikeColorComment(int index) {
    if (commentsList[index].likeStatus!.value) {
      return appBarColor;
    } else {
      return Colors.grey.shade800;
    }
  }

  Color getLikeColorSubComment(
    int commentIndex,
    int subCommentIndex,
  ) {
    if (commentsList[commentIndex]
            .subComments![subCommentIndex]
            .likeStatus!
            .value ??
        false) {
      return appBarColor;
    } else {
      return Colors.grey.shade800;
    }
  }

  String replyStringComment(int index) {
    switch (commentsList[index].replies!.value) {
      case 1:
        return "reply";
        break;

      default:
        return "replies";
        break;
    }
  }

  String likesStringComment(int index) {
    switch (commentsList[index].likes!.value) {
      case 1:
        return "like";
        break;

      default:
        return "likes";
        break;
    }
  }

  String likesStringSubComment(
    int commentIndex,
    int subCommentIndex,
  ) {
    switch (
        commentsList[commentIndex].subComments![subCommentIndex].likes!.value) {
      case 1:
        return "like";
        break;

      default:
        return "likes";
        break;
    }
  }

  onTapCommentReply(
      BuildContext context, String postID, String commentID, int index) async {
    ProperbuzFeedController controller = Get.put(ProperbuzFeedController());
    controller.isReply.value = true;
    selectedCommentID.value = commentID;
    selectedCommentIndex.value = index;
    selectedPostID.value = postID;
    controller.commentController.clear();
    await SystemChannels.textInput.invokeMethod('TextInput.show');
    controller.focusNode.requestFocus();
  }

  onTapSubCommentReply(BuildContext context, String postID, String commentID,
      int index, String userName) async {
    ProperbuzFeedController controller = Get.put(ProperbuzFeedController());
    controller.isReply.value = true;
    selectedCommentID.value = commentID;
    selectedCommentIndex.value = index;
    selectedPostID.value = postID;
    controller.commentController.clear();
    controller.commentController.text = "@$userName";
    controller.commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.commentController.text.length));
    controller.comment.value = "@$userName ";
    await SystemChannels.textInput.invokeMethod('TextInput.show');
    controller.focusNode.requestFocus();
  }

  void openEmail(String email) async {
    final url = Uri.encodeFull('mailto:$email?subject=&body=');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
