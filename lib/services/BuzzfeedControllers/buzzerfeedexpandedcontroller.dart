import 'package:bizbultest/models/Buzzerfeed/buzzrefeed_commentlist_model.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BuzzerfeedExpandedController extends GetxController {
  var buzzerfeedId;
  var commentList = <BuzzerfeedCommentDatum>[].obs;
  var replylist = {}.obs;
  BuzzerfeedExpandedController({this.buzzerfeedId});
  TextEditingController reply = TextEditingController();
  var commentUpload = false.obs;
  void getComments() async {
    var data = await BuzzerFeedAPI.getComments(this.buzzerfeedId);
    commentList.value = data;
  }

  void likeComment(commentId) async {
    await BuzzerFeedAPI.commentLike(commentId);
  }

  void deletecomment(commentId, maincommentindex, commentindex) async {
    commentList[maincommentindex].listofreply!.removeAt(commentindex);
    commentList.refresh();
    GetSnackBar(
      title: 'Success',
      icon: Icon(Icons.delete),
      snackStyle: SnackStyle.FLOATING,
      message: "Comment deleted successfully",
    );
    await BuzzerFeedAPI.deleteComment(commentId);
  }

  void getReplyComments(commentId, mainCommentIndex) async {
    var data = await BuzzerFeedAPI.getReplyComments(commentId);
    commentList[mainCommentIndex].listofreply!.value = data;
    commentList[mainCommentIndex].listofreply!.refresh();
  }

  void getRecentComment(recentCommentId) async {
    List<BuzzerfeedCommentDatum> data =
        await BuzzerFeedAPI.getRecentComment(recentCommentId);
    print("recent comment=$data");
    commentList.insert(0, data[0]);
    commentList.refresh();
  }

  Future<void> postComment(buzzerfeedId) async {
    var postComment = {
      "buzzerfeed_id": buzzerfeedId,
      "user_id": "${CurrentUser().currentUser.memberID}",
      "comments": reply.text,
      "comment_type": "text",
      "comment_location": "",
      "gif_id": "",
      "comment_poll_question": "",
      "comment_poll_choice": "",
      "comment_poll_length": "",
    };
    print("buzzerfeedId=${buzzerfeedId} $postComment");
    print("test reply =${postComment}");
    commentUpload.value = true;
    var recentCommentId =
        await BuzzerFeedAPI.postComment(postComment, files: []);
    getRecentComment(recentCommentId);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getComments();
    super.onInit();
  }
}
