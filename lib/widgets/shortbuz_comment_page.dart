import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/properbuz_comments_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_comment_like_unlike_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_comment_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_like_unline_post_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_post_like_status_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_video_list_model.dart';
import 'package:bizbultest/models/shortbuz_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Discover/discover_people_from_tags.dart';
import 'package:bizbultest/view/discover_people_from_tags.dart';
import 'package:bizbultest/view/hashtag_page.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/comment_menu.dart';
import 'package:bizbultest/models/comments_model.dart';
import 'package:bizbultest/models/sub_comment_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'package:dio/dio.dart' as dio;

class ShortbuzCommentPage extends StatefulWidget {
  final Data feed;
  final String? memberID;
  final String? logo;
  final String? country;
  final String? postID;
  final int? postMultiImage;
  final String? postType;
  final String? postUserId;
  final String? from;
  final String? postImgData;
  final String? postHeaderLocation;
  final String? postUserPicture;
  final String? postRebuzData;
  final String? postShortcode;
  final String? postContent;
  final String? timeStamp;
  final String? currentMemberImage;
  final String? currentMemberShortcode;
  final Function? refresh;

  ShortbuzCommentPage(
      {Key? key,
      required this.feed,
      this.memberID,
      this.logo,
      this.country,
      this.postID,
      this.postType,
      this.postUserId,
      this.from,
      this.postHeaderLocation,
      this.postUserPicture,
      this.postRebuzData,
      this.postShortcode,
      this.postContent,
      this.timeStamp,
      this.postImgData,
      this.postMultiImage,
      this.currentMemberImage,
      this.currentMemberShortcode,
      this.refresh})
      : super(key: key);

  @override
  _ShortbuzCommentPageState createState() => _ShortbuzCommentPageState();
}

class _ShortbuzCommentPageState extends State<ShortbuzCommentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pageIndex = 0;
  int commentLength = 4;
  bool isReply = false;
  late String commentID;
  late UserTags tagList;
  bool areTagsLoaded = false;

  bool showEmoji = false;

  String emoji1 = "😥";
  String emoji2 = "😂";
  String emoji3 = "🔥";
  String emoji4 = "❤";
  String emoji5 = "🙌";
  String emoji6 = "👏";
  String emoji7 = "😍";
  String emoji8 = "😮";

  late ShortbuzCommentModel commentsList;
  late SubComments subCommentsList;
  bool areSubCommentsLoaded = false;
  bool areCommentsLoaded = false;
  var currentMemberName;
  var currentMemberShortcode;
  var currentMemberImage;
  bool isMemberLoaded = false;
  TextEditingController _commentController = TextEditingController();
  var likeIcon;
  bool isLikeIconLoaded = false;

  late Data feed;

  void getData() {
    if (widget.from == "Location") {
      setState(() {
        feed = new Data();
      });
      if (widget.postType != null && widget.postType != "") {
        setState(() {
          feed.postType = "Image";
        });
      }
      if (widget.postID != null && widget.postID != "") {
        setState(() {
          feed.postId = widget.postID!;
        });
      }
      if (widget.postUserId != null && widget.postUserId != "") {
        setState(() {
          feed.postUserId = widget.postUserId!;
        });

        setState(() {
          feed.postMultiImage = widget.postMultiImage!;
          feed.postHeaderLocation = widget.postHeaderLocation!;
          feed.postUserPicture = widget.postUserPicture!;
          feed.postRebuzData = widget.postRebuzData!;
          feed.postShortcode = widget.postShortcode!;
          feed.postContent = widget.postContent!;
          feed.timeStamp = widget.timeStamp!;
          feed.postImgData = widget.postImgData!;
        });
      }
    } else {
      setState(() {
        feed = widget.feed;
      });
    }
  }

  Future<void> getComments() async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentData?action=post_comment_data&post_id=${feed.postId}&post_type=${feed.postType}&user_id=${feed.postUserId}&page=1";
    print('comment url=' + url);

    var client = new dio.Dio();
    print("token called");

    String? token = await ApiProvider().getTheToken();
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    widget.refresh!('${response.data['data'].length}');
    print("comment of the video=${response.data}");
    print("comment of the video url=${url}");

    print(response.data);
    if (response.statusCode == 200 && response.data['success'] == 1) {
      //  Logger().e("comment response data: ${response.data}");

      ShortbuzCommentModel commentsData =
          ShortbuzCommentModel.fromJson(response.data);

      if (this.mounted) {
        setState(() {
          commentsList = commentsData;
          areCommentsLoaded = true;
        });
      }
    }
    if (response.data == null ||
        response.statusCode != 200 ||
        response.data['success'] != 1) {
      setState(() {
        areCommentsLoaded = false;
      });
    }
  }

  Future<void> getUserTags(String searchedTag) async {
    var url =
        "https://www.bebuzee.com/api/user/userSearchFollowers?user_id=${widget.memberID}&searchword=$searchedTag";

    var response = await ApiProvider().fireApi(url);

    print(response.data);
    if (response.statusCode == 200) {
      UserTags tagsData = UserTags.fromJson(response.data['data']);
      print(tagsData.userTags[0].shortcode);
      setState(() {
        tagList = tagsData;
        areTagsLoaded = true;
        // print(commentsList.data.length.toString() + " is lenght");
      });

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          areTagsLoaded = false;
        });
      }
    }
  }

  Future<SubComments> getSubComments(String commentID) async {
    print("subComments called");
    var url =
        "https://www.bebuzee.com/api/newsfeed/postSubCommentData?action=post_comment_data&post_id=${feed.postId}&post_type=${feed.postType}&comment_id=$commentID";
    print('subcomment $url');

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
    print('sub comments= ${response.data}');
    print(response.data);
    if (response.statusCode == 200) {
      try {
        SubComments subCommentsData =
            SubComments.fromJson(response.data['data']);
        print("subcomment success");
        // SubComment d;
        // print(subCommentsData.data[0].shortcode);
        return subCommentsData;
      } catch (e) {
        print("sub comment error $e");
        return SubComments([]);
      }
    }
    return SubComments([]);
  }

  //! api updated
  Future<void> likeUnlikeComment(String commentID, int index) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentLikeUnlike?action=post_comment_like&post_type=${feed.postType}&comment_id=$commentID}&post_id=${feed.postId}&user_id=${CurrentUser().currentUser.memberID}";
    print('like comment url=${url}');

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
      ShortbuzCommentLikeUnlikeModel _likeUnlikeModel =
          ShortbuzCommentLikeUnlikeModel.fromJson(response.data);
      setState(() {
        commentsList.data![index].likeLogo = _likeUnlikeModel.imageData;
        commentsList.data![index].totalLikes =
            _likeUnlikeModel.totalLike.toString();
        getComments();
      });
    }
  }

  //! api updated
  Future<void> likeUnlikeSubcomment(String subcommentID) async {
    var url =
        "https://www.bebuzee.com/api/post_sub_comment_like_unlike.php?action=sub_comment_like_data&post_type=${feed.postType}&post_id=${feed.postId}&user_id=${CurrentUser().currentUser.memberID}&sub_comment_id=$subcommentID";
    print(url);

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
    if (response.statusCode == 200) {}
  }

  //! api updated
  Future<void> likeUnlikePost() async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postLikeUnlike?action=post_like_data&user_id=${CurrentUser().currentUser.memberID}&post_type=${widget.feed.postType}&post_id=${widget.feed.postId}";
    print(url);

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
    if (response.statusCode == 200) {
      ShortbuzLikeUnlikePostModel _likeUnlikePost =
          ShortbuzLikeUnlikePostModel.fromJson(response.data);
      print("likeUnlikePost");
      setState(() {
        feed.postTotalLikes = _likeUnlikePost.totalLike.toString();
        feed.postLikeIcon = _likeUnlikePost.imageData;
      });
    }
  }

  //! api updated
  Future<void> deleteComment(String commentID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentDelete?action=delete_main_comment_data&user_id=${CurrentUser().currentUser.memberID}&comment_id=$commentID&post_type=svideo&post_id=${feed.postId}";

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
      print("commentDeleted");
      print("delete comment response ${response.data}");

      widget.refresh!('${response.data['total_comment']}');
    }
  }

  //! api updated
  Future<void> reportCommentSpam(String commentID) async {
    var url =
        "https://www.bebuzee.com/api/report/commentReport?action=report_as_spam_or_scam_main_comment&user_id=${CurrentUser().currentUser.memberID}&comment_id=$commentID";
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
    // print(response.data);
    if (response.statusCode == 200) {
      print("spam reported");
    }
  }

  //! api updated
  Future<void> reportCommentAbusive(String commentID) async {
    var url =
        "https://www.bebuzee.com/api/report_comment_abusive.php?action= report_as_abusive_main_comment&user_id=${CurrentUser().currentUser.memberID}&comment_id=$commentID";

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

    if (response.statusCode == 200) {
      print("spam reported");
    }
  }

  //! api updated
  Future<void> deleteSubcomment(String subcommentID) async {
    var url =
        "https://www.bebuzee.com/api/delete_sub_comment_data.php?action=delete_sub_comment_data&sub_comment_id=$subcommentID&user_id=${CurrentUser().currentUser.memberID}";

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

    if (response.statusCode == 200) {
      print("spam reported");
    }
  }

  //! api updated
  Future<void> reportSubcommentSpam(String subcommentID) async {
    var url =
        "https://www.bebuzee.com/api/report_sub_comment_spam.php?action=report_spam_or_scam_sub_comment&post_id=${feed.postId}&sub_comment_id=$subcommentID&user_id=${CurrentUser().currentUser.memberID}";

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
      print("spam reported");
    }
  }

  //! api updated
  Future<void> reportSubcommentAbusive(String subcommentID) async {
    var url =
        "https://www.bebuzee.com/api/report_sub_comment_abusive.php?action=report_abusive_content_sub_comment&post_id=${feed.postId}&sub_comment_id=$subcommentID&user_id=${CurrentUser().currentUser.memberID}";

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
      print("spam reported");
    }
  }

  //! api updated
  Future<String> getCurrentMember() async {
    dev.log("get current member");
    var url =
        "https://www.bebuzee.com/app_devlope.php?action=member_details_data&user_id=${CurrentUser().currentUser.memberID}";
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
        isMemberLoaded = true;
      });
    }
    setState(() {
      var convertJson = json.decode(response.data);
      print(convertJson);
      currentMemberName = convertJson['member_name'];
      currentMemberShortcode = convertJson['shortcode'];
      currentMemberImage = convertJson['image'];
      print(currentMemberName + currentMemberImage);
    });

    return "success";
  }

  //! api updated
  Future<void> postComment(String comment) async {
    var url = "https://www.bebuzee.com/api/newsfeed/postCommentAdd";

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await client
        .post(url, options: dio.Options(headers: head), queryParameters: {
      "user_id": CurrentUser().currentUser.memberID,
      "post_type": feed.postType,
      "post_id": feed.postId,
      "comments": comment
    });

    print(response.data);

    if (response.statusCode == 200) {
      print(response.data);
      getComments();

      //  widget.refresh(jsonDecode(response.body)['total_comments']);
    }
  }

  //! api updated
  Future<void> postReply(String commentID, String reply) async {
    print("post reply called ");
    var url =
        "https://www.bebuzee.com/api/post_sub_comment.php?action=post_comment_reply&post_type=${feed.postType}&post_id=${feed.postId}&user_id=${CurrentUser().currentUser.memberID}&comment_id=$commentID&comments=$reply";

    print("post reply url =$url");

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

    print('post reply response =${response.data}');

    if (response.statusCode == 200) {
      print(response.data);
      getComments();
    }
  }

  //! api updated
  Future<void> checkLikeStatus() async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/CheckLikeUnlike?action=check_post_liked&user_id=${CurrentUser().currentUser.memberID}&post_type=${feed.postType}&post_id=${feed.postId}";

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

    if (response.statusCode == 200) {
      ShortbuzPostLikeStatusModel _status =
          ShortbuzPostLikeStatusModel.fromJson(response.data);
      setState(() {
        isLikeIconLoaded = true;
        likeIcon = _status.imageData;
      });
    }
  }

  @override
  void initState() {
    getData();

    setState(() {});
    if (areCommentsLoaded) {
      print(commentsList.data!.length.toString() + " length is");
    }

    getComments();
    checkLikeStatus();
    getCurrentMember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 2.0.h, bottom: 3.0.h),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            areCommentsLoaded == true
                                ? commentsList.data!.length.toString() +
                                    " Comments"
                                : "Comments",
                            style: TextStyle(
                                fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
                Container(
                  child: Column(
                    children: [
                      areCommentsLoaded
                          ? Container(
                              // height: _currentScreenSize.height * 0.2,
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: commentLength <=
                                            commentsList.data!.length
                                        ? commentLength
                                        : commentsList.data!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10,
                                            top: 3,
                                            bottom: 3),
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                  radius: 17,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: NetworkImage(
                                                      commentsList
                                                          .data![index].image!),
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    _currentScreenSize.width *
                                                        0.05,
                                              ),
                                              Container(
                                                child: Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              commentsList
                                                                  .data![index]
                                                                  .shortcode!,
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryBlueColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          GestureDetector(
                                                              onTap: () {
                                                                if (commentsList
                                                                        .data![
                                                                            index]
                                                                        .memberId ==
                                                                    CurrentUser()
                                                                        .currentUser
                                                                        .memberID) {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      // return object of type Dialog

                                                                      return CommentMenuCurrentMember(
                                                                        onPressDelete:
                                                                            () {
                                                                          deleteComment(commentsList
                                                                              .data![index]
                                                                              .commentId!);
                                                                          Timer(
                                                                              Duration(seconds: 2),
                                                                              () {
                                                                            getComments();
                                                                          });

                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                } else {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      // return object of type Dialog

                                                                      return CommentMenuOtherUser(
                                                                        onReportAbusive:
                                                                            () {
                                                                          reportCommentAbusive(commentsList
                                                                              .data![index]
                                                                              .commentId!);

                                                                          showDialog(
                                                                              context: _scaffoldKey.currentContext!,
                                                                              builder: (BuildContext context) {
                                                                                // return object of type Dialog

                                                                                return ReportSuccessPopup();
                                                                              });
                                                                        },
                                                                        onReportSpam:
                                                                            () {
                                                                          reportCommentSpam(commentsList
                                                                              .data![index]
                                                                              .commentId!);

                                                                          showDialog(
                                                                              context: _scaffoldKey.currentContext!,
                                                                              builder: (BuildContext context) {
                                                                                // return object of type Dialog

                                                                                return ReportSuccessPopup();
                                                                              });
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              child: Icon(Icons
                                                                  .more_horiz_outlined))
                                                        ],
                                                      ),
                                                      ParsedText(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        text: commentsList
                                                            .data![index]
                                                            .message!,
                                                        parse: <MatchText>[
                                                          MatchText(
                                                              onTap: (value) {
                                                                print(
                                                                    'clicked on tag ${value} ${widget.logo} ');
                                                                setState(() {
                                                                  OtherUser()
                                                                          .otherUser
                                                                          .memberID =
                                                                      value
                                                                          .toString()
                                                                          .replaceAll(
                                                                              "@",
                                                                              "");
                                                                  OtherUser()
                                                                          .otherUser
                                                                          .shortcode =
                                                                      value
                                                                          .toString()
                                                                          .replaceAll(
                                                                              "@",
                                                                              "");
                                                                });
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ProfilePageMain(
                                                                              from: "tags",
                                                                              otherMemberID: value.toString().replaceAll("@", ""),
                                                                            )));

                                                                // Navigator.push(
                                                                //     context,
                                                                //     MaterialPageRoute(
                                                                //         builder: (context) =>
                                                                //             DiscoverPageFromTags(
                                                                //               tag: value.toString().substring(1),
                                                                //               memberID: CurrentUser().currentUser.memberID,
                                                                //               country: widget.country,
                                                                //               logo: widget.logo,
                                                                //             )));
                                                              },
                                                              pattern:
                                                                  "(@+[a-zA-Z0-9(_)]{1,})",
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryBlueColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          MatchText(
                                                              onTap: (value) {
                                                                print(value);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              DiscoverFromTagsView(
                                                                        tag: value
                                                                            .toString()
                                                                            .substring(1),
                                                                      ),
                                                                    ));
                                                              },
                                                              pattern:
                                                                  "(#+[a-zA-Z0-9(_)]{1,})",
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryBlueColor))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            _currentScreenSize
                                                                    .width *
                                                                0.025,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Flexible(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    commentsList
                                                                        .data![
                                                                            index]
                                                                        .timeData!,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  SizedBox(
                                                                    width: _currentScreenSize
                                                                            .width *
                                                                        0.07,
                                                                  ),
                                                                  Text(
                                                                    commentsList
                                                                        .data![
                                                                            index]
                                                                        .totalLikes!,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  SizedBox(
                                                                    width: _currentScreenSize
                                                                            .width *
                                                                        0.07,
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            "this reply 2");
                                                                        setState(
                                                                            () {
                                                                          isReply =
                                                                              true;
                                                                          commentID = commentsList
                                                                              .data![index]
                                                                              .commentId!;

                                                                          _commentController.text = areCommentsLoaded
                                                                              ? "@" + commentsList.data![index].shortcode! + " "
                                                                              : "";
                                                                          _commentController.selection =
                                                                              TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                                                                        });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        AppLocalizations
                                                                            .of(
                                                                          "Reply",
                                                                        ),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                print(commentsList
                                                                    .data![
                                                                        index]
                                                                    .totalLikes);

                                                                likeUnlikeComment(
                                                                    commentsList
                                                                        .data![
                                                                            index]
                                                                        .commentId!,
                                                                    index);
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            2.0),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20,
                                                                          top:
                                                                              7,
                                                                          bottom:
                                                                              7),
                                                                  child: Center(
                                                                    child: Image
                                                                        .network(
                                                                      commentsList
                                                                          .data![
                                                                              index]
                                                                          .likeLogo!,
                                                                      height:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      commentsList.data![index]
                                                                  .subComment !=
                                                              ""
                                                          ? Container(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    commentsList
                                                                            .data![
                                                                                index]
                                                                            .isSubCommentOpen =
                                                                        !commentsList
                                                                            .data![index]
                                                                            .isSubCommentOpen!;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      color: Colors
                                                                          .grey,
                                                                      height: _currentScreenSize
                                                                              .height *
                                                                          0.002,
                                                                      width: _currentScreenSize
                                                                              .width *
                                                                          0.08,
                                                                    ),
                                                                    SizedBox(
                                                                      width: _currentScreenSize
                                                                              .width *
                                                                          0.04,
                                                                    ),
                                                                    Text(
                                                                      commentsList.data![index].isSubCommentOpen ==
                                                                              true
                                                                          ? AppLocalizations.of(
                                                                              "Hide Replies")
                                                                          : AppLocalizations.of(
                                                                                "View Replie",
                                                                              ) +
                                                                              " (${commentsList.data![index].subComment.toString()})",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      commentsList.data![index]
                                                                  .isSubCommentOpen ==
                                                              true
                                                          ? FutureBuilder(
                                                              future: getSubComments(
                                                                  commentsList
                                                                      .data![
                                                                          index]
                                                                      .commentId!),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  print(
                                                                      "subcomment has data");
                                                                  SubComments
                                                                      sub =
                                                                      snapshot.data
                                                                          as SubComments;
                                                                  return Container(
                                                                    child: Column(
                                                                        children: sub.subComments
                                                                            .map((e) => Container(
                                                                                  width: _currentScreenSize.width * 0.9,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(left: 3, top: 5, bottom: 5),
                                                                                            child: Container(
                                                                                              decoration: new BoxDecoration(
                                                                                                shape: BoxShape.circle,
                                                                                                border: new Border.all(
                                                                                                  color: Colors.grey,
                                                                                                  width: 0.5,
                                                                                                ),
                                                                                              ),
                                                                                              child: isMemberLoaded
                                                                                                  ? CircleAvatar(
                                                                                                      radius: 17,
                                                                                                      backgroundColor: Colors.transparent,
                                                                                                      backgroundImage: NetworkImage(e.userImage!),
                                                                                                    )
                                                                                                  : Container(),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: _currentScreenSize.width * 0.04,
                                                                                          ),
                                                                                          Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                e.shortcode!,
                                                                                                style: TextStyle(color: primaryBlueColor, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              ParsedText(
                                                                                                style: TextStyle(color: Colors.black),
                                                                                                text: e.comment!,
                                                                                                parse: <MatchText>[
                                                                                                  MatchText(
                                                                                                      onTap: (value) {
                                                                                                        print(value);
                                                                                                        Navigator.push(
                                                                                                            context,
                                                                                                            MaterialPageRoute(
                                                                                                                builder: (context) => HashtagPage(
                                                                                                                      hashtag: value.toString().substring(1),
                                                                                                                      memberID: CurrentUser().currentUser.memberID,
                                                                                                                      country: widget.country!,
                                                                                                                      logo: widget.logo!,
                                                                                                                    )));
                                                                                                      },
                                                                                                      pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                                                                                                      style: TextStyle(
                                                                                                        color: primaryBlueColor,
                                                                                                      )),
                                                                                                  MatchText(
                                                                                                      onTap: (value) {
                                                                                                        print(value);
                                                                                                        Navigator.push(
                                                                                                            context,
                                                                                                            MaterialPageRoute(
                                                                                                                builder: (context) => HashtagPage(
                                                                                                                      hashtag: value.toString().substring(1),
                                                                                                                      memberID: CurrentUser().currentUser.memberID,
                                                                                                                      country: widget.country!,
                                                                                                                      logo: widget.logo!,
                                                                                                                    )));
                                                                                                      },
                                                                                                      pattern: "(#+[a-zA-Z0-9(_)]{1,})",
                                                                                                      style: TextStyle(color: primaryBlueColor))
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    e.timeStamp!,
                                                                                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    width: 15,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    e.totalLikes!,
                                                                                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    width: 15,
                                                                                                  ),
                                                                                                  GestureDetector(
                                                                                                      onTap: () {
                                                                                                        print("this reply");

                                                                                                        setState(() {
                                                                                                          /*  isReply = true;
                                                                                                          subCommentID = e.subCommentId;

                                                                                                          _commentController.text = areSubCommentsLoaded
                                                                                                              ? "@" + e.shortcode + " "
                                                                                                              : "";
                                                                                                          _commentController.selection = TextSelection.fromPosition(
                                                                                                              TextPosition(offset: _commentController.text.length));*/
                                                                                                        });
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        AppLocalizations.of(
                                                                                                          "Reply",
                                                                                                        ),
                                                                                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                      )),
                                                                                                  SizedBox(
                                                                                                    width: 50,
                                                                                                  ),
                                                                                                  GestureDetector(
                                                                                                      onTap: () async {
                                                                                                        likeUnlikeSubcomment(e.subCommentId!);
                                                                                                        setState(() {
                                                                                                          commentsList.data![index].isSubCommentOpen = true;
                                                                                                        });
                                                                                                      },
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsets.only(right: 2.0),
                                                                                                        child: Container(
                                                                                                          color: Colors.transparent,
                                                                                                          padding: EdgeInsets.only(left: 20, right: 20, top: 7),
                                                                                                          child: Center(
                                                                                                            child: Image.network(
                                                                                                              e.likeLogo!,
                                                                                                              height: 13,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      GestureDetector(
                                                                                          onTap: () {
                                                                                            if (commentsList.data![index].memberId == CurrentUser().currentUser.memberID) {
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  // return object of type Dialog

                                                                                                  return CommentMenuCurrentMember(
                                                                                                    onPressDelete: () {
                                                                                                      deleteSubcomment(e.subCommentId!);
                                                                                                      Timer(Duration(seconds: 2), () {
                                                                                                        getSubComments(commentsList.data![index].commentId!);
                                                                                                      });

                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            } else {
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  // return object of type Dialog

                                                                                                  return CommentMenuOtherUser(
                                                                                                    onReportAbusive: () {
                                                                                                      reportSubcommentAbusive(e.subCommentId!);

                                                                                                      showDialog(
                                                                                                          context: _scaffoldKey.currentContext!,
                                                                                                          builder: (BuildContext context) {
                                                                                                            // return object of type Dialog

                                                                                                            return ReportSuccessPopup();
                                                                                                          });
                                                                                                    },
                                                                                                    onReportSpam: () {
                                                                                                      reportSubcommentSpam(e.subCommentId!);

                                                                                                      showDialog(
                                                                                                          context: _scaffoldKey.currentContext!,
                                                                                                          builder: (BuildContext context) {
                                                                                                            // return object of type Dialog

                                                                                                            return ReportSuccessPopup();
                                                                                                          });
                                                                                                    },
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                          child: Icon(Icons.more_horiz_outlined))
                                                                                    ],
                                                                                  ),
                                                                                ))
                                                                            .toList()),
                                                                  );
                                                                } else {
                                                                  return Center(
                                                                      child:
                                                                          loadingAnimation());
                                                                }
                                                              })
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  commentLength <= commentsList.data!.length - 1
                                      ? Center(
                                          child: Container(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      commentLength =
                                                          commentLength + 4;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.grey[500],
                                                    size: 40,
                                                  ))))
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      showEmoji == true
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.5.h),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji1 +
                                                  " ";

                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji1,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji2 +
                                                  " ";
                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji2,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji3 +
                                                  " ";
                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji3,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji4 +
                                                  " ";
                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji4,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji5 +
                                                  " ";
                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji5,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji6 +
                                                  " ";
                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji6,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji7 +
                                                  " ";
                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji7,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          _commentController.text =
                                              _commentController.text +
                                                  emoji8 +
                                                  " ";
                                          _commentController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _commentController
                                                          .text.length));
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.all(1.2.h),
                                              child: Text(
                                                emoji8,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ))),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        CurrentUser().currentUser.image!),
                                  )),
                            ),
                          ),
                          Container(
                            width: _currentScreenSize.width * 0.80 - 20,
                            child: TextFormField(
                              onTap: () {
                                setState(() {
                                  showEmoji = true;
                                });
                              },
                              maxLines: 8,
                              controller: _commentController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              onChanged: (val) {
                                Timer? timeHandle;
                                // ignore: unnecessary_null_comparison
                                if (timeHandle != null) {
                                  timeHandle.cancel();
                                }
                                timeHandle =
                                    Timer(Duration(microseconds: 500), () {
                                  print(val);
                                  String str = "";
                                  List<String> words = val.split(" ");
                                  if (words[words.length - 1].startsWith("@")) {
                                    getUserTags(words[words.length - 1]
                                        .replaceAll("@", ""));
                                  } else {
                                    setState(() {
                                      tagList.userTags = [];
                                    });
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,

                                //hintText: ' Comment as ${widget.currentMemberShortcode.toString()}',
                                hintText:
                                    ' Comment as ${CurrentUser().currentUser.shortcode.toString()}',
                                // 48 -> icon width
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            width: _currentScreenSize.width * 0.1,
                            child: GestureDetector(
                              onTap: () {
                                print(widget.feed.postId);
                                print(widget.feed.postType);
                                if (isReply == false) {
                                  postComment(_commentController.text);
                                  _commentController.clear();

                                  Timer(Duration(seconds: 1), () {
                                    getComments();
                                  });
                                } else {
                                  print("insied post reply");
                                  postReply(commentID, _commentController.text);
                                  _commentController.clear();
                                  Timer(Duration(seconds: 1), () {
                                    getComments();
                                  });
                                }

                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: Text(
                                AppLocalizations.of(
                                  "Post",
                                ),
                                style: TextStyle(color: primaryBlueColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tagList != null && tagList.userTags.length > 0
                          ? Container(
                              height: 200,
                              child: ListView(
                                  children: tagList.userTags.map((s) {
                                return ListTile(
                                    leading: Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: new Border.all(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 2.3.h,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(s.image!),
                                      ),
                                    ),
                                    title: Text(
                                      s.shortcode!,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onTap: () {
                                      String? str;
                                      _commentController.text
                                          .split(" ")
                                          .forEach((element) {
                                        if (element.startsWith("@")) {
                                          str = element;
                                        }
                                      });
                                      String data = _commentController.text;
                                      data = _commentController.text.substring(
                                          0, data.length - str!.length + 1);
                                      data += s.shortcode!;
                                      data += " ";
                                      setState(() {
                                        _commentController.text = data;
                                        tagList.userTags = [];
                                      });
                                      _commentController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: _commentController
                                                      .text.length));
                                    });
                              }).toList()),
                            )
                          : SizedBox(),
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
