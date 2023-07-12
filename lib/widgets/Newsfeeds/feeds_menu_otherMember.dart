import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'direct_share_bottom_sheet.dart';

class FeedHeaderMenu extends StatefulWidget {
  final NewsFeedModel? feed;
  final VoidCallback? goToPost;
  final VoidCallback? deletePost;
  final VoidCallback? editPost;
  final VoidCallback? report;
  final VoidCallback? share;
  final VoidCallback? copy;
  final VoidCallback? embed;
  final VoidCallback? commentOnOff;
  final String? commentingStatus;
  final String? memberID;
  final String? postUserId;
  final Function? setFeed;
  final GlobalKey<ScaffoldState>? skey;

  final String? shortcode;

  FeedHeaderMenu(
      {Key? key,
      this.goToPost,
      this.report,
      this.shortcode,
      this.share,
      this.memberID,
      this.postUserId,
      this.deletePost,
      this.editPost,
      this.copy,
      this.embed,
      this.commentOnOff,
      this.commentingStatus,
      this.feed,
      this.setFeed,
      this.skey})
      : super(key: key);

  @override
  _FeedHeaderMenuState createState() => _FeedHeaderMenuState();
}

class _FeedHeaderMenuState extends State<FeedHeaderMenu> {
  Future<void> commentOnOff(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=turn_off_on_comment_result&post_type=$postType&post_id=$postID&user_id=${widget.memberID}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      NewsFeedModel? feedTemp = widget.feed!;
      feedTemp.postCommentResult = jsonDecode(response.body)['result_text'];
      //setState(() {
      //widget.feed.postCommentResult = jsonDecode(response.body)['result_text'];
      // });
      widget.setFeed!(feedTemp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 5,
              width: 10.0.w,
            ),
          )),
          widget.postUserId != widget.memberID
              ? ListTile(
                  title: Text(
                    AppLocalizations.of("Report Inappropriate"),
                  ),
                  onTap: widget.report ?? () async {},
                )
              : Container(),
          ListTile(
            title: Text(
              AppLocalizations.of('Go to post'),
            ),
            onTap: widget.goToPost ?? () async {},
          ),
          widget.postUserId == widget.memberID && widget.feed!.postRebuz == 0
              ? ListTile(
                  title: Text(
                    AppLocalizations.of('Edit'),
                  ),
                  onTap: widget.editPost ?? () async {},
                )
              : Container(),
          widget.postUserId == widget.memberID
              ? ListTile(
                  title: Text(
                    AppLocalizations.of('Delete'),
                  ),
                  onTap: widget.deletePost ?? () async {},
                )
              : Container(),
          ListTile(
            title: Text(
              AppLocalizations.of('Embed'),
            ),
            onTap: widget.embed ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of('Share'),
            ),
            onTap: widget.share ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of('Copy Link'),
            ),
            onTap: widget.copy ?? () async {},
          ),
          widget.postUserId == widget.memberID
              ? ListTile(
                  title: Text(
                      widget.feed!.postCommentResult == "Turn On Commenting"
                          ? AppLocalizations.of('Commenting turned off')
                          : AppLocalizations.of('Commenting turned on')
                      // AppLocalizations.of(widget.feed.postCommentResult),
                      ),
                  onTap: widget.commentOnOff ?? () {},
                )
              : Container(),
        ],
      ),
    );
  }
}

class ReportPostSpam extends StatefulWidget {
  @override
  _ReportPostSpamState createState() => _ReportPostSpamState();
}

class _ReportPostSpamState extends State<ReportPostSpam> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Thanks for reporting this person",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
              child: Center(
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(
                                "We use spam reports as a signal to understand problems we're having with spam on Bebuzee. If you think this post violates our Community Guidelines or") +
                            " ",
                      ),
                      TextSpan(
                          text: AppLocalizations.of(
                            "Terms of Use",
                          ),
                          style: TextStyle(
                              color: feedColor, fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: " " +
                            AppLocalizations.of(
                              "and should be removed, mark it as inappropriate.",
                            ),
                      )
                    ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void ReportTestLravel() {}

class ReportPostNudity extends StatefulWidget {
  final VoidCallback? reportNudity;

  ReportPostNudity({Key? key, this.reportNudity}) : super(key: key);

  @override
  _ReportPostNudityState createState() => _ReportPostNudityState();
}

class _ReportPostNudityState extends State<ReportPostNudity> {
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Report as nudity or pornography ?",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of("We remove:") + " ",
                        style: greyNormal,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            bullet,
                            style: greyNormal.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(
                              "Photos or videos of sexual intercourse",
                            ),
                            style: greyNormal,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            bullet,
                            style: greyNormal.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 260,
                            child: Text(
                              AppLocalizations.of(
                                "Posts showing sexual intercourse, genitals or close-ups of fully-nude buttocks",
                              ),
                              style: greyNormal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            bullet,
                            style: greyNormal.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 260,
                            child: Text(
                              AppLocalizations.of(
                                "Posts of nude or partially nude children",
                              ),
                              style: greyNormal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "If you report someone's post, Bebuzeee doesn't tell them who reported it.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "If someone is in immediate danger, call local emergency services. Don't wait.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 1.5.h),
                          width: 175,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      primaryBlueColor),
                                  // disabledColor: primaryBlueColor,
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)))),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(5)),
                              onPressed: widget.reportNudity ?? () {},
                              // color: primaryBlueColor,
                              // disabledColor: primaryBlueColor,
                              child: Text(
                                AppLocalizations.of(
                                  "Submit",
                                ),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostShare extends StatefulWidget {
  final VoidCallback? rebuzz;
  final VoidCallback? shareUrl;
  final VoidCallback? direct;
  final String? postID;
  final String? image;
  final String? hasRebuzz;
  final String? shortcode;

  PostShare(
      {Key? key,
      this.rebuzz,
      this.shareUrl,
      this.hasRebuzz,
      this.direct,
      this.postID,
      this.image,
      this.shortcode})
      : super(key: key);

  @override
  _PostShareState createState() => _PostShareState();
}

class _PostShareState extends State<PostShare> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 5,
              width: 10.0.w,
            ),
          )),
          ListTile(
            leading: Icon(
              CustomIcons.rebuzz,
              color: Colors.black,
            ),
            title: Text(
              'Rebuz',
            ),
            onTap: widget.rebuzz ?? () async {},
          ),
          ListTile(
            leading: Icon(
              CustomIcons.share_post,
              color: Colors.black,
            ),
            title: Text(
              AppLocalizations.of(
                'Share',
              ),
            ),
            onTap: widget.shareUrl ?? () async {},
          ),
          ListTile(
            leading: Icon(
              CustomIcons.chat_icon,
              color: Colors.black,
            ),
            title: Text(
              AppLocalizations.of('DIRECT'),
            ),
            onTap: () {
              Get.bottomSheet(
                DirectShareBottomSheet(
                  postID: widget.postID,
                  image: widget.image,
                  shortcode: widget.shortcode,
                ),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditPost extends StatefulWidget {
  final TextEditingController? editingController;
  final VoidCallback? updatePost;
  final String? content;

  EditPost({Key? key, this.editingController, this.updatePost, this.content})
      : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  void initState() {
    widget.editingController!.text = widget.content!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.5.h),
      child: Container(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.center,
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 0.0, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Text(
              AppLocalizations.of(
                "Edit",
              ),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Container(
              margin: EdgeInsets.only(top: 2.0.h),
              child: TextFormField(
                maxLines: null,
                controller: widget.editingController,
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,

                  // 48 -> icon width
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: TextButton(
                  onPressed: widget.updatePost ?? () {},
                  child: Text("Update Post")),
            )
          ],
        ),
      ),
    );
  }
}

class DontLikeReport extends StatefulWidget {
  final VoidCallback? unfollow;
  final String? followStatus;
  final String? shortcode;

  DontLikeReport({Key? key, this.unfollow, this.followStatus, this.shortcode})
      : super(key: key);

  @override
  _DontLikeReportState createState() => _DontLikeReportState();
}

class _DontLikeReportState extends State<DontLikeReport> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(
                    "Don't like this profile ?",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.0.h),
              child: Text(
                  "Unfollow ${widget.shortcode} " +
                      AppLocalizations.of(
                        "so you won't see any of their photos, videos or story in your feed.",
                      ),
                  style: greyNormal),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 2.5.h),
                width: 175,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryBlueColor),
                        // disabledColor: primaryBlueColor,
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5)),
                    onPressed: widget.unfollow ?? () {},
                    // color: primaryBlueColor,
                    // disabledColor: primaryBlueColor,
                    child: Text(
                      widget.followStatus!,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportHateSpeech extends StatefulWidget {
  final VoidCallback? reportHateSpeech;

  ReportHateSpeech({Key? key, this.reportHateSpeech}) : super(key: key);

  @override
  _ReportHateSpeechState createState() => _ReportHateSpeechState();
}

class _ReportHateSpeechState extends State<ReportHateSpeech> {
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Report as hate speech or symbols ?",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of("We remove:") + " ",
                        style: greyNormal,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            bullet,
                            style: greyNormal.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 260,
                            child: Text(
                              AppLocalizations.of(
                                "Photos of hate speech or symbols, like swastikas or white power hand signs",
                              ),
                              style: greyNormal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            bullet,
                            style: greyNormal.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 260,
                            child: Text(
                              AppLocalizations.of(
                                "Specific threats of physical harm, theft or vandalism",
                              ),
                              style: greyNormal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            bullet,
                            style: greyNormal.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 260,
                            child: Text(
                              AppLocalizations.of(
                                "Posts of nude or partially nude children",
                              ),
                              style: greyNormal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "If you report someone's post, Bebuzeee doesn't tell them who reported it.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "If someone is in immediate danger, call local emergency services. Don't wait.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.5.h),
                        child: Center(
                          child: Container(
                            width: 175,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryBlueColor),
                                    // disabledColor: primaryBlueColor,
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(5)),
                                onPressed: widget.reportHateSpeech ?? () {},
                                // color: primaryBlueColor,
                                // disabledColor: primaryBlueColor,
                                child: Text(
                                  AppLocalizations.of(
                                    "Submit",
                                  ),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmbedPost extends StatefulWidget {
  final TextEditingController? textEditingController;
  final VoidCallback? copyEmbed;
  final String? embedData;

  EmbedPost(
      {Key? key, this.textEditingController, this.copyEmbed, this.embedData})
      : super(key: key);

  @override
  _EmbedPostState createState() => _EmbedPostState();
}

class _EmbedPostState extends State<EmbedPost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
      child: Container(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.center,
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Text(
              AppLocalizations.of(
                "Embed Post",
              ),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 3.0.w),
                  child: Text(
                      '<iframe src="${widget.embedData}" height="500" width="600"></iframe>'),
                ),
              ),
            ),
            TextButton(
                onPressed: widget.copyEmbed ?? () {},
                child: Text(
                  AppLocalizations.of(
                    "Copy URL",
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ReportPostViolence extends StatefulWidget {
  final VoidCallback? reportViolence;

  ReportPostViolence({Key? key, this.reportViolence}) : super(key: key);

  @override
  _ReportPostViolenceState createState() => _ReportPostViolenceState();
}

class _ReportPostViolenceState extends State<ReportPostViolence> {
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Report as violence or threat of violence?",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 3.0.h, vertical: 2.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of("We remove:") + " ",
                      style: greyNormal,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bullet,
                          style: greyNormal.copyWith(fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 260,
                          child: Text(
                            AppLocalizations.of(
                              "Photos or videos of extreme graphic violence",
                            ),
                            style: greyNormal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bullet,
                          style: greyNormal.copyWith(fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 260,
                          child: Text(
                            AppLocalizations.of(
                              "Posts that encourage violence or attacks anyone based on their religious, ethnic or sexual background",
                            ),
                            style: greyNormal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bullet,
                          style: greyNormal.copyWith(fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 260,
                          child: Text(
                            AppLocalizations.of(
                              "Specific threats of physical harm, theft, vandalism or financial harm",
                            ),
                            style: greyNormal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 260,
                      child: Text(
                        AppLocalizations.of(
                          "If you report someone's post, Bebuzeee doesn't tell them who reported it.",
                        ),
                        style: greyNormal,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 260,
                      child: Text(
                        AppLocalizations.of(
                          "If someone is in immediate danger, call local emergency services. Don't wait.",
                        ),
                        style: greyNormal,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 1.5.h),
                        width: 175,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryBlueColor),
                                // disabledColor: primaryBlueColor,
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(5)),
                            onPressed: widget.reportViolence ?? () {},
                            // color: primaryBlueColor,
                            // disabledColor: primaryBlueColor,
                            child: Text(
                              AppLocalizations.of(
                                "Submit",
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportPostSale extends StatefulWidget {
  final VoidCallback? reportSale;

  ReportPostSale({Key? key, this.reportSale}) : super(key: key);

  @override
  _ReportPostSaleState createState() => _ReportPostSaleState();
}

class _ReportPostSaleState extends State<ReportPostSale> {
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Report as sale or promotion of drugs ?",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.0.h, vertical: 2.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of("We remove:") + " ",
                    style: greyNormal,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        bullet,
                        style: greyNormal.copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "Posts promoting the use of hard drugs",
                          ),
                          style: greyNormal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        bullet,
                        style: greyNormal.copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "Posts intended to sell or distribute drugs",
                          ),
                          style: greyNormal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 260,
                    child: Text(
                      AppLocalizations.of(
                        "If you report someone's post, Bebuzeee doesn't tell them who reported it.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 260,
                    child: Text(
                      AppLocalizations.of(
                        "If someone is in immediate danger, call local emergency services. Don't wait.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 1.5.h),
                      width: 175,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryBlueColor),
                              // disabledColor: primaryBlueColor,
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(5)),
                          onPressed: widget.reportSale ?? () {},
                          // color: primaryBlueColor,
                          // disabledColor: primaryBlueColor,
                          child: Text(
                            AppLocalizations.of(
                              "Submit",
                            ),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportPostHarassment extends StatefulWidget {
  final VoidCallback? reportHarassment;

  ReportPostHarassment({Key? key, this.reportHarassment}) : super(key: key);

  @override
  _ReportPostHarassmentState createState() => _ReportPostHarassmentState();
}

class _ReportPostHarassmentState extends State<ReportPostHarassment> {
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Report as harassment or bullying ?",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.0.h, vertical: 2.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of("We remove:") + " ",
                    style: greyNormal,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        bullet,
                        style: greyNormal.copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "Posts that contain credible threats",
                          ),
                          style: greyNormal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        bullet,
                        style: greyNormal.copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "Content that targets people to degrade or shame them",
                          ),
                          style: greyNormal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        bullet,
                        style: greyNormal.copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "Personal information shared to blackmail or harass",
                          ),
                          style: greyNormal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 260,
                    child: Text(
                      AppLocalizations.of(
                        "If you report someone's post, Bebuzeee doesn't tell them who reported it.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 260,
                    child: Text(
                      AppLocalizations.of(
                        "If someone is in immediate danger, call local emergency services. Don't wait.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 1.5.h),
                      width: 175,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryBlueColor),
                              // disabledColor: primaryBlueColor,
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(5)),
                          onPressed: widget.reportHarassment ?? () {},
                          // color: primaryBlueColor,
                          // disabledColor: primaryBlueColor,
                          child: Text(
                            AppLocalizations.of(
                              "Submit",
                            ),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportPostIntellectual extends StatefulWidget {
  final VoidCallback? reportIntellectual;

  ReportPostIntellectual({Key? key, this.reportIntellectual}) : super(key: key);

  @override
  _ReportPostIntellectualState createState() => _ReportPostIntellectualState();
}

class _ReportPostIntellectualState extends State<ReportPostIntellectual> {
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Report as intellectual property violation ?",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.0.h, vertical: 2.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 280,
                    child: Text(
                      AppLocalizations.of(
                        "We remove posts that include copyright or trademark infringement. If someone is using your photos without your permission or impersonating you, we may also remove the content and disable the account. To learn more about reporting an intellectual property violation, visit our Help Center.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 1.5.h),
                      width: 175,
                      child: ElevatedButton(
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(5)),
                          onPressed: widget.reportIntellectual ?? () {},
                          // color: primaryBlueColor,
                          // disabledColor: primaryBlueColor,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryBlueColor),
                              // disabledColor: primaryBlueColor,
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          child: Text(
                            AppLocalizations.of(
                              "Submit",
                            ),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportPostInjury extends StatefulWidget {
  final VoidCallback? reportInjury;

  ReportPostInjury({Key? key, this.reportInjury}) : super(key: key);

  @override
  _ReportPostInjuryState createState() => _ReportPostInjuryState();
}

class _ReportPostInjuryState extends State<ReportPostInjury> {
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: Text(
                  AppLocalizations.of(
                    "Report as self injury ?",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.0.h, vertical: 2.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 260,
                    child: Text(
                      AppLocalizations.of(
                        "We remove posts encouraging or promoting self injury, which includes suicide, cutting and eating disorders. We may also remove posts identifying victims of self injury if the post attacks or makes fun of them.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 260,
                    child: Text(
                      AppLocalizations.of(
                        "If you report someone's post, Bebuzeee doesn't tell them who reported it.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 260,
                    child: Text(
                      AppLocalizations.of(
                        "If someone is in immediate danger, call local emergency services. Don't wait.",
                      ),
                      style: greyNormal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 1.5.h),
                      width: 175,
                      child: ElevatedButton(
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(5)),
                          onPressed: widget.reportInjury ?? () {},
                          // color: primaryBlueColor,
                          // disabledColor: primaryBlueColor,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryBlueColor),
                              // disabledColor: primaryBlueColor,
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          child: Text(
                            AppLocalizations.of(
                              "Submit",
                            ),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InsightsInteraction extends StatefulWidget {
  @override
  _InsightsInteractionState createState() => _InsightsInteractionState();
}

class _InsightsInteractionState extends State<InsightsInteraction> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(
                    "What is interactions ?",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "The set of insights measures the actions people take when they engage with your post.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(
                              "Profile Visits",
                            ) +
                            " ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "The number of times your profile was viewed",
                          ),
                          style: greyNormal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InsightsDiscovery extends StatefulWidget {
  @override
  _InsightsDiscoveryState createState() => _InsightsDiscoveryState();
}

class _InsightsDiscoveryState extends State<InsightsDiscovery> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(
                    "What is discovery ?",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "The set of insights measures how many people see your content and where they find it.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Impressions",
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "The total number of times your post has been seen.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Reach",
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "The number of unique accounts that have seen your post. The reach metric is an estimate and may not be exact.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Follows",
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 260,
                        child: Text(
                          AppLocalizations.of(
                            "The number of accounts that started following you.",
                          ),
                          style: greyNormal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
