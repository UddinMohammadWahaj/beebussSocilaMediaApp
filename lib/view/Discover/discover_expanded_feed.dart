import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/discover_feed_model.dart';
import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/comment_menu.dart';
import 'package:bizbultest/widgets/expanded_feed_header.dart';
import 'package:bizbultest/models/comments_model.dart';
import 'package:bizbultest/models/sub_comment_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:http/http.dart' as http;

import '../hashtag_page.dart';

class DiscoverExpandedFeed extends StatefulWidget {
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
  final DiscoverFeedModel? feed;

  DiscoverExpandedFeed(
      {Key? key,
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
      this.feed})
      : super(key: key);

  @override
  _DiscoverExpandedFeedState createState() => _DiscoverExpandedFeedState();
}

class _DiscoverExpandedFeedState extends State<DiscoverExpandedFeed> {
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

  late Comments commentsList;
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

  late DiscoverFeedModel feed;

  void getData() {
    if (widget.from == "Location") {
      setState(() {
        feed = new DiscoverFeedModel();
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
        feed = widget.feed!;
      });
    }
  }

  Future<void> getComments() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=post_comment_data&post_id=${feed.postId}&post_type=${feed.postType}&user_id=${feed.postUserId}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      Comments commentsData = Comments.fromJson(jsonDecode(response.body));
      print(commentsData.comments[0].message);
      setState(() {
        commentsList = commentsData;
        areCommentsLoaded = true;
        print(commentsList.comments.length.toString() + " is length");
      });

      if (response.body == null || response.statusCode != 200) {
        setState(() {
          areCommentsLoaded = false;
        });
      }
    }
  }

  Future<void> getUserTags(String searchedTag) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${widget.memberID}&searchword=$searchedTag");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      UserTags tagsData = UserTags.fromJson(jsonDecode(response.body));
      print(tagsData.userTags[0].shortcode);
      setState(() {
        tagList = tagsData;
        areTagsLoaded = true;
        print(commentsList.comments.length.toString() + " is lenght");
      });

      if (response.body == null || response.statusCode != 200) {
        setState(() {
          areTagsLoaded = false;
        });
      }
    }
  }

  Future<SubComments?>? getSubComments(String commentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=view_all_sub_comment&post_type=${feed.postType}&comment_id=$commentID&post_id=${feed.postId}&user_id=${widget.memberID}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      SubComments subCommentsData =
          SubComments.fromJson(jsonDecode(response.body));
      print(subCommentsData.subComments[0].shortcode);
      return subCommentsData;
    }
    return null;
  }

  Future<void> likeUnlikeComment(String commentID, int index) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=post_comment_like&post_type=${feed.postType}&comment_id=$commentID}&post_id=${feed.postId}&user_id=${widget.memberID}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      print("likeUnlikeComment");
      print(jsonDecode(response.body)['response_data']);
      setState(() {
        commentsList.comments[index].likeLogo =
            jsonDecode(response.body)['image_data'];
        commentsList.comments[index].totalLikes =
            jsonDecode(response.body)['total_like'];
      });
    }
  }

  Future<void> likeUnlikeSubcomment(String subcommentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=sub_comment_like_data&post_type=${feed.postType}&post_id=${feed.postId}&user_id=${widget.memberID}&sub_comment_id=$subcommentID");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      var convertedJson = jsonDecode(response.body);
      print(convertedJson['image_data']);
      print(convertedJson['response_data']);
      print(feed.postType);
      print(feed.postId);
      print(widget.memberID);
      print(subcommentID);
    }
  }

  Future<void> likeUnlikePost() async {
    print("clicked like unline");
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=post_like_data&user_id=${widget.memberID}&post_type=${feed.postType}&post_id=${feed.postId}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      print("likeUnlikePost");
      setState(() {
        feed.postTotalLikes = jsonDecode(response.body)['total_likes'];
        feed.postLikeIcon = jsonDecode(response.body)['image_data'];
      });
    }
  }

  Future<void> deleteComment(String commentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=delete_main_comment_data&user_id=${widget.memberID}&comment_id=$commentID");

    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      print("commentDeleted");
    }
  }

  Future<void> reportCommentSpam(String commentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=report_as_spam_or_scam_main_comment&user_id=${widget.memberID}&comment_id=$commentID");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      print("spam reported");
    }
  }

  Future<void> reportCommentAbusive(String commentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action= report_as_abusive_main_comment&user_id=${widget.memberID}&comment_id=$commentID");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      print("spam reported");
    }
  }

  Future<void> deleteSubcomment(String subcommentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=delete_sub_comment_data&sub_comment_id=$subcommentID&user_id=${widget.memberID}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      print("commentDeleted");
    }
  }

  Future<void> reportSubcommentSpam(String subcommentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=report_spam_or_scam_sub_comment&post_id=${feed.postId}&sub_comment_id=$subcommentID&user_id=${widget.memberID}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      print("spam reported");
    }
  }

  Future<void> reportSubcommentAbusive(String subcommentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=report_abusive_content_sub_comment&post_id=${feed.postId}&sub_comment_id=$subcommentID&user_id=${widget.memberID}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      print("spam reported");
    }
  }

  Future<String> getCurrentMember() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=member_details_data&user_id=${widget.memberID}");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isMemberLoaded = true;
      });
    }

    setState(() {
      var convertJson = json.decode(response.body);

      print(convertJson);
      currentMemberName = convertJson['member_name'];
      currentMemberShortcode = convertJson['shortcode'];

      currentMemberImage = convertJson['image'];

      print(currentMemberName + currentMemberImage);
    });

    return "success";
  }

  Future<void> postComment(String comment) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=post_comment_main&user_id=${widget.memberID}&post_type=${feed.postType}=&post_id=${feed.postId}&comments=$comment");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      print("comment successful");
    }
  }

  Future<void> postReply(String commentID, String reply) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=post_comment_reply&post_type=${feed.postType}&post_id=${feed.postId}&user_id=${widget.memberID}&comment_id=$commentID&comments=$reply");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      print("reply successful");
    }
  }

  Future<void> checkLikeStatus() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=check_post_liked&user_id=${widget.memberID}&post_type=${feed.postType}&post_id=${feed.postId}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        var convertJson = json.decode(response.body);
        isLikeIconLoaded = true;
        likeIcon = convertJson['image_data'];

        print("icon " + convertJson['image_data']);
        print("icon " + convertJson['response_data']);
      });
    }
  }

  @override
  void initState() {
    getData();

    setState(() {});
    if (areCommentsLoaded) {
      print(commentsList.comments.length.toString() + " length is");
    }

    getComments();
    checkLikeStatus();
    getCurrentMember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 5.0.h, bottom: 2.0.h),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.keyboard_backspace,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: _currentScreenSize.width * 0.03,
                          ),
                          Text(
                            AppLocalizations.of(
                              "Comments",
                            ),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
              ),
              ExpandedFeedHeader(
                postHeaderLocation: feed.postHeaderLocation,
                postUserPicture: feed.postUserPicture,
                postRebuzData: feed.postRebuzData,
                postShortcode: feed.postShortcode,
                postContent: feed.postContent,
                timeStamp: feed.timeStamp,
                onPressMatchText: (value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HashtagPage(
                                hashtag: value.toString().substring(1),
                                memberID: widget.memberID!,
                                country: widget.country!,
                                logo: widget.logo!,
                              )));
                },
              ),
              widget.from == "Location"
                  ? Padding(
                      padding: EdgeInsets.only(top: 2.0.h),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: _currentScreenSize.height * 0.6),
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (val) {
                                  setState(() {
                                    feed.pageIndex = val;
                                  });
                                },
                                itemCount: feed.postImgData!.split("~~").length,
                                itemBuilder: (context, indexImage) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      feed.postImgData!.split("~~")[indexImage],
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          feed.postMultiImage == 1
                              ? Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: feed.postImgData!
                                            .split("~~")
                                            .map((e) {
                                          var ind = feed.postImgData!
                                              .split("~~")
                                              .indexOf(e);
                                          return Container(
                                            margin: EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              radius: 4,
                                              backgroundColor:
                                                  feed.pageIndex == ind
                                                      ? Colors.white
                                                      : Colors.grey
                                                          .withOpacity(0.6),
                                            ),
                                          );
                                        }).toList()),
                                  ),
                                )
                              : Container(),
                          feed.postMultiImage == 1
                              ? Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Image.asset(
                                          "assets/images/multiple.png",
                                          height:
                                              _currentScreenSize.height * 0.025,
                                        ),
                                      )),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(),
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
                                          commentsList.comments.length
                                      ? commentLength
                                      : commentsList.comments.length,
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
                                                    commentsList.comments[index]
                                                        .image!),
                                              ),
                                            ),
                                            SizedBox(
                                              width: _currentScreenSize.width *
                                                  0.05,
                                            ),
                                            Container(
                                              child: Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            commentsList
                                                                .comments[index]
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
                                                                      .comments[
                                                                          index]
                                                                      .memberId ==
                                                                  widget
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
                                                                            .comments[index]
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
                                                                            .comments[index]
                                                                            .commentId!);

                                                                        showDialog(
                                                                            context:
                                                                                _scaffoldKey.currentContext!,
                                                                            builder: (BuildContext context) {
                                                                              // return object of type Dialog

                                                                              return ReportSuccessPopup();
                                                                            });
                                                                      },
                                                                      onReportSpam:
                                                                          () {
                                                                        reportCommentSpam(commentsList
                                                                            .comments[index]
                                                                            .commentId!);

                                                                        showDialog(
                                                                            context:
                                                                                _scaffoldKey.currentContext!,
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
                                                          color: Colors.black),
                                                      text: commentsList
                                                          .comments[index]
                                                          .message!,
                                                      parse: <MatchText>[
                                                        MatchText(
                                                            onTap: (value) {
                                                              print(value);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          HashtagPage(
                                                                            hashtag:
                                                                                value.toString().substring(1),
                                                                            memberID:
                                                                                widget.memberID!,
                                                                            country:
                                                                                widget.country!,
                                                                            logo:
                                                                                widget.logo!,
                                                                          )));
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
                                                                      builder: (context) =>
                                                                          HashtagPage(
                                                                            hashtag:
                                                                                value.toString().substring(1),
                                                                            memberID:
                                                                                widget.memberID!,
                                                                            country:
                                                                                widget.country!,
                                                                            logo:
                                                                                widget.logo!,
                                                                          )));
                                                            },
                                                            pattern:
                                                                "(#+[a-zA-Z0-9(_)]{1,})",
                                                            style: TextStyle(
                                                                color:
                                                                    primaryBlueColor))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: _currentScreenSize
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
                                                                      .comments[
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
                                                                      .comments[
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
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        isReply =
                                                                            true;
                                                                        commentID = commentsList
                                                                            .comments[index]
                                                                            .commentId!;

                                                                        _commentController.text = areCommentsLoaded
                                                                            ? "@" +
                                                                                commentsList.comments[index].shortcode! +
                                                                                " "
                                                                            : "";
                                                                        _commentController.selection =
                                                                            TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                                                                      });
                                                                    },
                                                                    child: Text(
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
                                                                  .comments[
                                                                      index]
                                                                  .totalLikes);

                                                              likeUnlikeComment(
                                                                  commentsList
                                                                      .comments[
                                                                          index]
                                                                      .commentId!,
                                                                  index);
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          2.0),
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        top: 7,
                                                                        bottom:
                                                                            7),
                                                                child: Center(
                                                                  child: Image
                                                                      .network(
                                                                    commentsList
                                                                        .comments[
                                                                            index]
                                                                        .likeLogo!,
                                                                    height: 13,
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    commentsList.comments[index]
                                                                .subComment !=
                                                            ""
                                                        ? Container(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  commentsList
                                                                          .comments[
                                                                              index]
                                                                          .isSubCommentOpen =
                                                                      !commentsList
                                                                          .comments[
                                                                              index]
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
                                                                    commentsList.comments[index].isSubCommentOpen ==
                                                                            true
                                                                        ? AppLocalizations.of(
                                                                            "Hide Replies")
                                                                        : AppLocalizations.of("View Replies") +
                                                                            " (${commentsList.comments[index].subComment.toString()})",
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
                                                    commentsList.comments[index]
                                                                .isSubCommentOpen ==
                                                            true
                                                        ? FutureBuilder(
                                                            future: getSubComments(
                                                                commentsList
                                                                    .comments[
                                                                        index]
                                                                    .commentId!),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                SubComments?
                                                                    sub =
                                                                    SubComments.fromJson(
                                                                        snapshot.data
                                                                            as List);
                                                                ;
                                                                return Container(
                                                                  child: Column(
                                                                      children: sub
                                                                          .subComments
                                                                          .map((e) =>
                                                                              Container(
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
                                                                                                                    memberID: widget.memberID!,
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
                                                                                                                    memberID: widget.memberID!,
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
                                                                                                        commentsList.comments[index].isSubCommentOpen = true;
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
                                                                                          if (commentsList.comments[index].memberId == widget.memberID) {
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (BuildContext context) {
                                                                                                // return object of type Dialog

                                                                                                return CommentMenuCurrentMember(
                                                                                                  onPressDelete: () {
                                                                                                    deleteSubcomment(e.subCommentId!);
                                                                                                    Timer(Duration(seconds: 2), () {
                                                                                                      getSubComments(commentsList.comments[index].commentId!);
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
                                commentLength <=
                                        commentsList.comments.length - 1
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
              /*   Divider(
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, ),
                child: Row(
                  children: [
                    isLikeIconLoaded
                        ? GestureDetector(
                            onTap: () {
                              likeUnlikePost();
                              Timer(Duration(seconds: 1), () {
                                checkLikeStatus();
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  feed.postLikeIcon,
                                  height: 30,
                                ),
                              ),
                            ))
                        : Container(),
                    SizedBox(
                      width: 7,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        "assets/images/comment.png",
                        height: 30,
                      ),
                    ),
                    SizedBox(
                      width: 19,
                    ),
                    GestureDetector(
                      child: Image.asset(
                        "assets/images/share.png",
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Container(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    feed.postTotalLikes.toString() + " likes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 4),
                child: Container(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    feed.timeStamp,
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                )),
              ),
              */ /*          Text(feed.postId),
              Text(feed.postUserId)*/ /*
*/
              Divider(
                thickness: 1,
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
                              child: isMemberLoaded
                                  ? CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          CurrentUser().currentUser.image!),
                                    )
                                  : Container(),
                            ),
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
                              if (isReply == false) {
                                postComment(_commentController.text);
                                _commentController.clear();

                                Timer(Duration(seconds: 1), () {
                                  getComments();
                                });
                              } else {
                                postReply(commentID, _commentController.text);
                                _commentController.clear();
                                Timer(Duration(seconds: 1), () {
                                  getComments();
                                });
                              }

                              FocusScope.of(context).requestFocus(FocusNode());
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
                                        TextSelection.fromPosition(TextPosition(
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
    );
  }
}
