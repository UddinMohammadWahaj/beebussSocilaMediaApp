import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../utilities/custom_toast_message.dart';

class StoryEmojis extends StatelessWidget {
  final TextEditingController? messageController;
  final String emoji1 = "😂";
  final String emoji2 = "😮";
  final String emoji3 = "😍";
  final String emoji4 = "😢";
  final String emoji5 = "👏";
  final String emoji6 = "🔥";
  final String emoji7 = "🎉";
  final String emoji8 = "💯";
  final VoidCallback? onTap;
  var storyId;
  var othermemberId;

  StoryEmojis(
      {Key? key,
      this.messageController,
      this.onTap,
      this.storyId,
      this.othermemberId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void postReaction(othermemberId, storyId, emoji) async {
      customToastWhite(
          AppLocalizations.of(
            "Reacted $emoji",
          ),
          16.0,
          ToastGravity.CENTER);
      var data = {
        "user_id": othermemberId,
        "story_id": storyId,
        "response": emoji
      };
      var url = 'https://www.bebuzee.com/api/story_post_response.php';
      var response = await ApiProvider().fireApiWithParams(url, params: {
        "user_id": CurrentUser().currentUser.memberID,
        "story_id": storyId,
        "response": emoji
      });

      print("response of Reaction=$response" + " data= $data");
    }

    return Positioned.fill(
      top: 20.0.h,
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async {
                      postReaction(this.othermemberId, this.storyId, emoji1);
                      // messageController.text =
                      //     messageController.text + emoji1 + " ";
                      // messageController.selection = TextSelection.fromPosition(
                      //     TextPosition(offset: messageController.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji1,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      postReaction(this.othermemberId, this.storyId, emoji2);
                      // messageController.text =
                      //     messageController.text + emoji2 + " ";
                      // messageController.selection = TextSelection.fromPosition(
                      //     TextPosition(offset: messageController.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji2,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      postReaction(this.othermemberId, this.storyId, emoji3);
                      messageController!.text =
                          messageController!.text + emoji3 + " ";
                      messageController!.selection = TextSelection.fromPosition(
                          TextPosition(offset: messageController!.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji3,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      postReaction(this.othermemberId, this.storyId, emoji4);
                      // messageController.text =
                      //     messageController.text + emoji4 + " ";
                      // messageController.selection = TextSelection.fromPosition(
                      //     TextPosition(offset: messageController.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji4,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      postReaction(this.othermemberId, this.storyId, emoji5);
                      // messageController.text =
                      //     messageController.text + emoji5 + " ";
                      // messageController.selection = TextSelection.fromPosition(
                      //     TextPosition(offset: messageController.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji5,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      postReaction(this.othermemberId, this.storyId, emoji6);
                      // messageController.text =
                      //     messageController.text + emoji6 + " ";
                      // messageController.selection = TextSelection.fromPosition(
                      //     TextPosition(offset: messageController.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji6,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      postReaction(this.othermemberId, this.storyId, emoji7);
                      // messageController.text =
                      //     messageController.text + emoji7 + " ";
                      // messageController.selection = TextSelection.fromPosition(
                      //     TextPosition(offset: messageController.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji7,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      postReaction(this.othermemberId, this.storyId, emoji8);
                      // messageController.text =
                      //     messageController.text + emoji8 + " ";
                      // messageController.selection = TextSelection.fromPosition(
                      //     TextPosition(offset: messageController.text.length));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.h),
                          child: Text(
                            emoji8,
                            style: TextStyle(fontSize: 30),
                          ),
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
