import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_comments_model.dart';
import 'package:bizbultest/models/video_section/post_like_dislike_video_section_model.dart';
import 'package:bizbultest/models/video_subcomment_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'comment_menu_bottom_tile.dart';

class VideoCommentCard extends StatefulWidget {
  final int? index;
  final VideoCommentModel? comment;
  final String? postID;
  TextEditingController? editingController;
  final VoidCallback? showSubComments;
  final Function? isReply;
  final Function? refreshComments;
  final Function? reportConfirmation;

  VideoCommentCard(
      {Key? key,
      this.comment,
      this.postID,
      this.editingController,
      this.index,
      this.showSubComments,
      this.isReply,
      this.refreshComments,
      this.reportConfirmation})
      : super(key: key);

  @override
  _VideoCommentCardState createState() => _VideoCommentCardState();
}

class _VideoCommentCardState extends State<VideoCommentCard> {
  bool? areSubcommentsLoaded = false;
  VideoSubcomments? subcommentsList;

  int? isLiked;

  bool? isReply = false;

  //! api updated
  Future<void> deleteMainComment(String commentID, String postID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentDelete?action=delete_main_comment&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID&post_type=Video";

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    print(response.data);

    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  //! api updated
  Future<void> reportSpamMainComment(String commentID, String postID) async {
    var url =
        "https://www.bebuzee.com/api/report/commentReport?action=report_as_span_scam_comment_main&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID&post_type=Video";

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    print(response.data);

    widget.reportConfirmation!();
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  //! api updated
  Future<void> reportAbusiveMainComment(String commentID, String postID) async {
    var url =
        "https://www.bebuzee.com/api/report_comment_abusive.php?action=report_as_abusive_comment_main&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID";

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    print(response.data);

    widget.reportConfirmation!();
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  //! api updated
  Future<void> deleteSubComment(
      String commentID, String postID, String subcommentID) async {
    var url =
        "https://www.bebuzee.com/api/delete_sub_comment_data.php?action=delete_sub_comment_data&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID&sub_comment_id=$subcommentID&post_type=Video";

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    print(response.data);

    if (response.statusCode == 200) {
      setState(() {
        // ignore: unnecessary_statements
        if (widget.comment!.noOfChildCom! > 0)
          (widget.comment!.noOfChildCom) != widget.comment!.noOfChildCom! - 1;
      });
      if (widget.comment!.noOfChildCom == 0)
        widget.comment!.showSubcomments = false;
    }
  }

  //! api updated
  Future<void> reportSpamSubComment(
      String commentID, String postID, String subcommentID) async {
    var url =
        "https://www.bebuzee.com/api/report/commentReport?action=report_as_span_scam_comment_sub&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID&sub_comment_id=$subcommentID&post_type=Video";

    var client = new dio.Dio();

    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    print("token: $token");

    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );

    widget.reportConfirmation!();

    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<void> reportAbusiveSubComment(
      String commentID, String postID, String subcommentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=report_abusive_comment_sub&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID&sub_comment_id=subcommentID");

    var response = await http.get(url);

    print(response.body);

    widget.reportConfirmation!();

    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<void> getSubComments(String commentID, String postID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postSubCommentData?action=get_subcomment_data&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID=&comment_id=$commentID&post_type=Video";
    print("getsubcim url $url");
    var response = await ApiProvider().fireApi(url);
    print("getsubcimments bigvideo=${response.data}");
    try {
      if (response.statusCode == 200) {
        VideoSubcomments commentData =
            VideoSubcomments.fromJson(response.data['data']);
        setState(() {
          subcommentsList = commentData;
          areSubcommentsLoaded = true;
        });
      }
      if (response.data == null || response.statusCode != 200) {
        setState(() {
          subcommentsList = VideoSubcomments([]);
          areSubcommentsLoaded = false;
        });
      }
    } catch (e) {
      setState(() {
        subcommentsList = VideoSubcomments([]);
        areSubcommentsLoaded = false;
      });
    }
  }

  //! api updated
  Future<void> likeMainComment(String commentID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentLikeUnlike?action=like_video_main_comment&user_id=${CurrentUser().currentUser.memberID!}&post_id=${widget.postID}&comment_id=$commentID&post_type=Video";

    var client = new dio.Dio();

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    if (response.statusCode == 200) {
      print("comment like url=${url}");
      print("comment like= ${response.data}");
      PostLikeDislikeVideoSection _likeDislike =
          PostLikeDislikeVideoSection.fromJson(response.data);
      setState(() {
        print("like status=${response.data['like_status']}");
        widget.comment!.likeStatus = _likeDislike.likeStatus;
        widget.comment!.dislikeStatus = _likeDislike.dislikeStatus;
        widget.comment!.numberOfLike = _likeDislike.totalLikes;
        widget.comment!.noOfDislikes = _likeDislike.totalDislikes;
      });
    }
  }

  //! api updated
  Future<void> dislikeMainComment(String commentID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentLikeUnlike?type=dislike&user_id=${CurrentUser().currentUser.memberID!}&post_id=${widget.postID}&comment_id=$commentID&post_type=Video";
    var client = new dio.Dio();

    print("token called ${url}");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    if (response.statusCode == 200) {
      PostLikeDislikeVideoSection _likeDislike =
          PostLikeDislikeVideoSection.fromJson(response.data);
      print("response of dislike =${response.data}");
      setState(() {
        widget.comment!.likeStatus = _likeDislike.likeStatus;
        widget.comment!.dislikeStatus = _likeDislike.dislikeStatus;
        widget.comment!.numberOfLike = _likeDislike.totalLikes;
        widget.comment!.noOfDislikes = _likeDislike.totalDislikes;
      });
    }
  }

  Future<void> likeSubComment(
      String commentID, String postID, String? subCommentID, int index) async {
    var url =
        "https://www.bebuzee.com/api/post_sub_comment_like_unlike.php?action=like_video_main_sub_comment&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID&sub_comment_id=$subCommentID&post_type=Video";

    var response = await ApiProvider().fireApi(url);

    print('like subcomment response=${response.data}');
    if (response.statusCode == 200) {
      setState(() {
        subcommentsList!.subcomments[index].likeStatus =
            (response.data)['like_status'] ? 1 : 0;
        print('like subcomment response=${response.data} work');
        subcommentsList!.subcomments[index].dislikeStatus =
            (response.data)['dislike_status'] ? 1 : 0;
        subcommentsList!.subcomments[index].noOfLikes =
            response.data['no_of_likes'];
        subcommentsList!.subcomments[index].noOfDislikes =
            response.data['number_of_dislike'];
      });
    }
  }

  Future<void> dislikeSubComment(
      String commentID, String postID, String subCommentID, int index) async {
    var url =
        "https://www.bebuzee.com/api/post_sub_comment_dislike_disunlike.php?action=dislike_video_main_sub_comment&user_id=${CurrentUser().currentUser.memberID!}&post_id=$postID&comment_id=$commentID&sub_comment_id=$subCommentID";

    var response = await ApiProvider().fireApi(url);

    print('dislike sub comment respons=${response.data}');
    if (response.statusCode == 200) {
      setState(() {
        subcommentsList!.subcomments[index].likeStatus =
            response.data['like_status'] ? 1 : 0;
        subcommentsList!.subcomments[index].dislikeStatus =
            response.data['dislike_status'] ? 1 : 0;
        subcommentsList!.subcomments[index].noOfLikes =
            response.data['no_of_likes'];
        subcommentsList!.subcomments[index].noOfDislikes =
            response.data['number_of_dislike'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 0.2,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 2.5.h,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(widget.comment!.upicture!),
                    )),
                Container(
                  padding: EdgeInsets.only(left: 3.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.comment!.name ?? " ",
                            style: whiteBold.copyWith(fontSize: 9.0.sp),
                          ),
                          SizedBox(
                            width: 1.0.w,
                          ),
                          Text(
                            widget.comment!.timeStamp ?? "timestamp",
                            style: whiteBold.copyWith(fontSize: 9.0.sp),
                          )
                        ],
                      ),
                      Container(
                        width: 80.0.w,
                        child: Text(
                          parse(widget.comment!.comment).documentElement!.text,
                          style: whiteNormal.copyWith(fontSize: 11.0.sp),
                        ),
                      ),
                      Wrap(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FloatingActionButton(
                            elevation: 0,
                            splashColor: Colors.grey.withOpacity(0.3),
                            foregroundColor: Colors.grey[900],
                            backgroundColor: Colors.grey[900],
                            onPressed: () {
                              setState(() {
                                isReply = true;
                                widget.isReply!(isReply);

                                widget.editingController!.text =
                                    widget.editingController!.text +
                                        "@" +
                                        widget.comment!.shortcode! +
                                        " ";
                                widget.editingController!.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: widget
                                            .editingController!.text.length));
                              });
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                              child: Text(
                                AppLocalizations.of(
                                  "Reply",
                                ),
                                style: whiteNormal.copyWith(fontSize: 10.0.sp),
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            elevation: 0,
                            splashColor: Colors.grey.withOpacity(0.3),
                            foregroundColor: Colors.grey[900],
                            backgroundColor: Colors.grey[900],
                            onPressed: () {
                              likeMainComment(widget.comment!.commentId!);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                              child: widget.comment!.likeStatus == true &&
                                      widget.comment!.dislikeStatus == false
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          CustomIcons.videolike2,
                                          color: Colors.white,
                                          size: 2.0.h,
                                        ),
                                        Text(
                                          widget.comment!.numberOfLike
                                              .toString(),
                                          style: whiteNormal.copyWith(
                                              fontSize: 8.0.sp),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          CustomIcons.videolike1,
                                          color: Colors.white,
                                          size: 2.0.h,
                                        ),
                                        Text(
                                          widget.comment!.numberOfLike
                                              .toString(),
                                          style: whiteNormal.copyWith(
                                              fontSize: 8.0.sp),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                          FloatingActionButton(
                            elevation: 0,
                            splashColor: Colors.grey.withOpacity(0.3),
                            foregroundColor: Colors.grey[900],
                            backgroundColor: Colors.grey[900],
                            onPressed: () {
                              dislikeMainComment(widget.comment!.commentId!);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RotatedBox(
                                    quarterTurns: 2,
                                    child:
                                        widget.comment!.likeStatus == false &&
                                                widget.comment!.dislikeStatus ==
                                                    true
                                            ? Icon(
                                                CustomIcons.videolike2,
                                                color: Colors.white,
                                                size: 2.0.h,
                                              )
                                            : Icon(
                                                CustomIcons.videolike1,
                                                size: 2.0.h,
                                                color: Colors.white,
                                              ),
                                  ),
                                  Text(
                                    widget.comment!.noOfDislikes.toString(),
                                    style:
                                        whiteNormal.copyWith(fontSize: 8.0.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            elevation: 0,
                            splashColor: Colors.grey.withOpacity(0.3),
                            foregroundColor: Colors.grey[900],
                            backgroundColor: Colors.grey[900],
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20.0),
                                          topRight:
                                              const Radius.circular(20.0))),
                                  //isScrollControlled:true,
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return VideoCommentMenu(
                                      reportSpam: () {
                                        reportSpamMainComment(
                                            widget.comment!.commentId!,
                                            widget.postID!);
                                        Navigator.pop(context);
                                      },
                                      reportAbusive: () {
                                        reportAbusiveMainComment(
                                            widget.comment!.commentId!,
                                            widget.postID!);
                                        Navigator.pop(context);
                                      },
                                      delete: () {
                                        widget.refreshComments!(widget.index);
                                        deleteMainComment(
                                            widget.comment!.commentId!,
                                            widget.postID!);
                                        Navigator.pop(context);
                                      },
                                      userID: widget.comment!.userID,
                                    );
                                  });
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                              child: Container(
                                child: Icon(
                                  Icons.more_horiz,
                                  size: 2.0.h,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      widget.comment!.noOfChildCom! > 0
                          ? InkWell(
                              splashColor: Colors.grey.withOpacity(0.3),
                              onTap: () {
                                print("vclicked");
                                print(widget.comment!.commentId! +
                                    "        " +
                                    widget.postID!);
                                getSubComments(
                                    widget.comment!.commentId!, widget.postID!);
                                setState(() {
                                  widget.comment!.showSubcomments =
                                      !widget.comment!.showSubcomments!;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.0.h),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.comment!.showSubcomments ==
                                                  false
                                              ? AppLocalizations.of(
                                                    "View",
                                                  ) +
                                                  " " +
                                                  widget.comment!.noOfChildCom
                                                      .toString() +
                                                  " " +
                                                  AppLocalizations.of(
                                                    "Replies",
                                                  )
                                              : AppLocalizations.of(
                                                    "Hide",
                                                  ) +
                                                  " " +
                                                  widget.comment!.noOfChildCom
                                                      .toString() +
                                                  " " +
                                                  AppLocalizations.of(
                                                    "Replies",
                                                  ),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        widget.comment!.showSubcomments == false
                                            ? Icon(
                                                Icons.arrow_drop_down_outlined,
                                                color: Colors.white,
                                                size: 2.5.h,
                                              )
                                            : Icon(
                                                Icons.arrow_drop_up_outlined,
                                                color: Colors.white,
                                                size: 2.5.h,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      widget.comment!.showSubcomments == true
                          ? areSubcommentsLoaded == true
                              ? SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: subcommentsList!.subcomments
                                        .asMap()
                                        .map((i, value) => MapEntry(
                                            i,
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: new Border.all(
                                                          color: Colors.grey,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 2.0.h,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                value.picture!),
                                                      )),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 3.0.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              value.name!,
                                                              style: whiteBold
                                                                  .copyWith(
                                                                      fontSize:
                                                                          8.0.sp),
                                                            ),
                                                            SizedBox(
                                                              width: 1.0.w,
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                value
                                                                    .timeStamp!,
                                                                style: whiteBold
                                                                    .copyWith(
                                                                        fontSize:
                                                                            8.0.sp),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          width: 70.0.w,
                                                          child: Text(
                                                            parse(value.comment)
                                                                .documentElement!
                                                                .text,
                                                            style: whiteNormal
                                                                .copyWith(
                                                                    fontSize:
                                                                        10.0.sp),
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                        Wrap(
                                                          // mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            FloatingActionButton(
                                                              elevation: 0,
                                                              splashColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              foregroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              onPressed: () {
                                                                setState(() {
                                                                  isReply =
                                                                      true;
                                                                  widget.isReply!(
                                                                      isReply);
                                                                  widget
                                                                      .editingController!
                                                                      .text = widget
                                                                          .editingController!
                                                                          .text +
                                                                      "@" +
                                                                      value
                                                                          .commentShortcode! +
                                                                      " ";
                                                                  widget.editingController!
                                                                          .selection =
                                                                      TextSelection.fromPosition(TextPosition(
                                                                          offset: widget
                                                                              .editingController!
                                                                              .text
                                                                              .length));
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 2.0
                                                                            .h,
                                                                        bottom:
                                                                            2.0.h),
                                                                child: Text(
                                                                  AppLocalizations
                                                                      .of(
                                                                    "Reply",
                                                                  ),
                                                                  style: whiteNormal
                                                                      .copyWith(
                                                                          fontSize:
                                                                              9.0.sp),
                                                                ),
                                                              ),
                                                            ),
                                                            FloatingActionButton(
                                                              elevation: 0,
                                                              splashColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              foregroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              onPressed: () {
                                                                likeSubComment(
                                                                    widget
                                                                        .comment!
                                                                        .commentId!,
                                                                    widget
                                                                        .postID!,
                                                                    value
                                                                        .childCommentId,
                                                                    i);
                                                              },
                                                              child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top:
                                                                          2.0.h,
                                                                      bottom:
                                                                          2.0.h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      value.likeStatus == 1 &&
                                                                              value.dislikeStatus == 0
                                                                          ? Icon(
                                                                              CustomIcons.videolike2,
                                                                              color: Colors.white,
                                                                              size: 2.0.h,
                                                                            )
                                                                          : Icon(
                                                                              CustomIcons.videolike1,
                                                                              color: Colors.white,
                                                                              size: 2.0.h,
                                                                            ),
                                                                      Text(
                                                                        subcommentsList!
                                                                            .subcomments[i]
                                                                            .noOfLikes
                                                                            .toString(),
                                                                        style: whiteNormal.copyWith(
                                                                            fontSize:
                                                                                8.0.sp),
                                                                      )
                                                                    ],
                                                                  )),
                                                            ),
                                                            FloatingActionButton(
                                                              elevation: 0,
                                                              splashColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              foregroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              onPressed: () {
                                                                dislikeSubComment(
                                                                    widget
                                                                        .comment!
                                                                        .commentId!,
                                                                    widget
                                                                        .postID!,
                                                                    value
                                                                        .childCommentId!,
                                                                    i);
                                                              },
                                                              child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top:
                                                                          2.0.h,
                                                                      bottom:
                                                                          2.0.h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      RotatedBox(
                                                                        quarterTurns:
                                                                            2,
                                                                        child: value.likeStatus == 0 &&
                                                                                value.dislikeStatus == 1
                                                                            ? Icon(
                                                                                CustomIcons.videolike2,
                                                                                color: Colors.white,
                                                                                size: 2.0.h,
                                                                              )
                                                                            : Icon(
                                                                                CustomIcons.videolike1,
                                                                                size: 2.0.h,
                                                                                color: Colors.white,
                                                                              ),
                                                                      ),
                                                                      Text(
                                                                        subcommentsList!
                                                                            .subcomments[i]
                                                                            .noOfDislikes
                                                                            .toString(),
                                                                        style: whiteNormal.copyWith(
                                                                            fontSize:
                                                                                8.0.sp),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                            FloatingActionButton(
                                                              elevation: 0,
                                                              splashColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              foregroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      900],
                                                              onPressed: () {
                                                                showModalBottomSheet(
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            900],
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: const Radius.circular(
                                                                                20.0),
                                                                            topRight: const Radius.circular(
                                                                                20.0))),
                                                                    //isScrollControlled:true,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            bc) {
                                                                      print(
                                                                          "user idd=${widget.comment!.userID}");
                                                                      return VideoCommentMenu(
                                                                        reportSpam:
                                                                            () {
                                                                          reportSpamSubComment(
                                                                              widget.comment!.commentId!,
                                                                              widget.postID!,
                                                                              value.childCommentId!);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        reportAbusive:
                                                                            () {
                                                                          reportAbusiveSubComment(
                                                                              widget.comment!.commentId!,
                                                                              widget.postID!,
                                                                              value.childCommentId!);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        delete:
                                                                            () {
                                                                          deleteSubComment(
                                                                              widget.comment!.commentId!,
                                                                              widget.postID!,
                                                                              value.childCommentId!);
                                                                          getSubComments(
                                                                              widget.comment!.commentId!,
                                                                              widget.postID!);

                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        userID: subcommentsList!
                                                                            .subcomments[i]
                                                                            .userID,
                                                                      );
                                                                    });
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 2.0
                                                                            .h,
                                                                        bottom:
                                                                            2.0.h),
                                                                child:
                                                                    Container(
                                                                  child: Icon(
                                                                    Icons
                                                                        .more_horiz,
                                                                    size: 2.0.h,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )))
                                        .values
                                        .toList(),
                                  ),
                                )
                              : areSubcommentsLoaded == false &&
                                      widget.comment!.showSubcomments == true
                                  ? Container(
                                      child: Center(
                                          child:
                                              loadingAnimationBlackBackground()),
                                    )
                                  : Container()
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
