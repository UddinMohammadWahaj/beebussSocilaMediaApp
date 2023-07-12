import 'package:bizbultest/models/Buzzerfeed/buzzrefeed_commentlist_model.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BuzzerfeedExpandedProfileController extends GetxController {
  var buzzerfeedId;
  var commentList = <BuzzerfeedCommentDatum>[].obs;
  BuzzerfeedExpandedProfileController({this.buzzerfeedId});
  TextEditingController reply = TextEditingController();
  var commentUpload = false.obs;
  void getComments() async {
    var data = await BuzzerFeedAPI.getComments(this.buzzerfeedId);
    commentList.value = data;
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
