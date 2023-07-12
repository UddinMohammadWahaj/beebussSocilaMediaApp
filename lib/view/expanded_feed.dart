import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';

import 'package:bizbultest/models/expanded_user_tags_model.dart';
import 'package:bizbultest/models/tags_search_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_body.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_body_footer.dart';
import 'package:bizbultest/widgets/Newsfeeds/user_tags_bottom_tile.dart';
import 'package:bizbultest/widgets/feed_single_video_player.dart';
import 'package:dio/dio.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/comment_menu.dart';
import 'package:bizbultest/widgets/expanded_feed_header.dart';
import 'package:bizbultest/models/comments_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/sub_comment_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/view/profile_page_main.dart';
import 'discover_people_from_tags.dart';
import 'hashtag_page.dart';

class ExpandedFeed extends StatefulWidget {
  final NewsFeedModel? feed;
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
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  Function? updateblogbuz;
  ExpandedFeed(
      {Key? key,
      this.feed,
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
      this.changeColor,
      this.isChannelOpen,
      this.updateblogbuz,
      this.setNavBar})
      : super(key: key);

  @override
  _ExpandedFeedState createState() => _ExpandedFeedState();
}

class _ExpandedFeedState extends State<ExpandedFeed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pageIndex = 0;
  int commentLength = 4;
  bool isReply = false;
  late String commentID;
  late UserTags tagList;
  late TagPlaces hashtags;
  bool areTagsLoaded = false;
  bool arehashTagsLoaded = false;
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

  late NewsFeedModel feed;

  void getData() {
    if (widget.from == "Location") {
      setState(() {
        feed = new NewsFeedModel();
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
          feed.postHeaderLocation = widget.postHeaderLocation;
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
        if (feed.postType == "Video") feed.postType = "Image";
      });
    }
    print("blog getData()");
  }

  Future<void> getCommentsLoad() async {
    print(
        "getting comments...... ${widget.feed!.postType} ${widget.feed!.postId}");
    var url = Uri.parse(
        'https://www.bebuzee.com/api/newsfeed/postCommentData?post_id=${feed.postId}&post_type=${feed.postType}&user_id=${feed.postUserId}&page=1');

    String newToken = await ApiProvider().newRefreshToken();

    // String token =
    //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID);
    // var newurl = Uri.parse(
    //     'https://www.bebuzee.com/api/post_comment_data?action=post_comment_data&post_id=${feed.postId}&post_type=${feed.postType}&user_id=${feed.postUserId}');

    print("get comment ka url =${url}");
    var client = Dio();

    await client
        .postUri(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $newToken',
      }),
    )
        .then((value) {
      if (value.statusCode == 200) {
        print("comment url=$url");
        print("comment data=${value.data}");
        Comments commentsData = Comments.fromJson(value.data['data']);
        commentsData.comments.forEach((element) {
          if (element.likeLogo !=
              "https://www.bebuzee.com/new_files/transparent_new_unlike_logo.png") {
            if (mounted) {
              setState(() {
                element.isLiked = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                element.isLiked = false;
              });
            }
          }
        });

        if (mounted) {
          setState(() {
            commentsList.comments.addAll(commentsData.comments);
            areCommentsLoaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            areCommentsLoaded = false;
          });
        }
      }
    });
  }

  Future<void> getComments() async {
    print(
        "getting comments...... ${widget.feed!.postType} ${widget.feed!.postId}");
    var url = Uri.parse(
        'https://www.bebuzee.com/api/newsfeed/postCommentData?post_id=${feed.postId}&post_type=${feed.postType}&user_id=${CurrentUser().currentUser.memberID}&page=1');

    String newToken = await ApiProvider().newRefreshToken();

    // String token =
    //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID);
    // var newurl = Uri.parse(
    //     'https://www.bebuzee.com/api/post_comment_data?action=post_comment_data&post_id=${feed.postId}&post_type=${feed.postType}&user_id=${feed.postUserId}');

    print("get comment ka url =${url}");
    var client = Dio();

    await client
        .postUri(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $newToken',
      }),
    )
        .then((value) {
      if (value.statusCode == 200) {
        print("comment url=$url");
        print("comment data=${value.data}");
        Comments commentsData = Comments.fromJson(value.data['data']);
        commentsData.comments.forEach((element) {
          print("like logo=${element.likeLogo}");
          if (element.likeLogo !=
              "https://www.bebuzee.com/new_files/transparent_new_unlike_logo.png") {
            if (mounted) {
              setState(() {
                print("like logo=${element.likeLogo} true");
                element.isLiked = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                print("like logo=${element.likeLogo} false");
                element.isLiked = false;
              });
            }
          }
        });

        if (mounted) {
          setState(() {
            commentsList = commentsData;
            areCommentsLoaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            areCommentsLoaded = false;
          });
        }
      }
    });
  }

  Future<void> getHashtags(text) async {
    print("text is:" + text);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_hashtags_tags_data&user_id=${widget.memberID}&keyword=$text");
    // var response = await http.get(url);

    var url = 'https://www.bebuzee.com/api/search_hastag_list.php';

    var client = Dio();
    var token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    await client.post(url,
        queryParameters: {"user_id": widget.memberID, "keyword": text},
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }));
    var response = await ApiProvider()
        .fireApi("https://www.bebuzee.com/api/search_hastag_list.php");

    //print(response.body);
    if (response.statusCode == 200) {
      TagPlaces tagData = TagPlaces.fromJson(response.data['data']);
      //print(peopleData.people[0].name);
      setState(() {
        hashtags = tagData;
        arehashTagsLoaded = true;
      });

      if (response.data == null ||
          response.data['data'] == null ||
          response.data['data'] == []) {
        setState(() {
          arehashTagsLoaded = false;
        });
      }
    }
  }

  Future<void> getUserTags(String searchedTag) async {
    var url =
        "https://www.bebuzee.com/api/user/userSearchFollowers?user_id=${widget.memberID}&searchword=$searchedTag";

    var response = await ApiProvider().fireApi(url);

    print(response.data);
    if (response.statusCode == 200) {
      UserTags tagsData = UserTags.fromJson(response.data['data']);

      if (mounted) {
        setState(() {
          tagList = tagsData;
          areTagsLoaded = true;
        });
      }

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          areTagsLoaded = false;
        });
      }
    }
  }

  Future<SubComments?> getSubComments(String commentID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postSubCommentData?action=view_all_sub_comment&post_type=${feed.postType}&comment_id=$commentID&post_id=${feed.postId}&user_id=${widget.memberID}";

    // var response = await http.get(url);
    var response = await ApiProvider().fireApi(url);
    print("getsubcomment url=${url}");
    print("get subcomment called ${response.data}");
    try {
      if (response.statusCode == 200) {
        SubComments subCommentsData =
            SubComments.fromJson(response.data['data']);

        subCommentsData.subComments.forEach((element) {
          if (element.likeLogo !=
              "https://www.bebuzee.com/new_files/transparent_new_unlike_logo.png") {
            if (mounted) {
              element.isLiked = true;
            }
          } else {
            if (mounted) {
              element.isLiked = false;
            }
          }
        });
        return subCommentsData;
      }
    } catch (e) {
      print("error is $e");
    }
    return null;
  }

  Future<void> likeUnlikeComment(String commentID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/newsfeed/postCommentLikeUnlike?action=post_comment_like&post_type=${feed.postType}&comment_id=$commentID&post_id=${feed.postId}&user_id=${widget.memberID}");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/newsfeed/postCommentLikeUnlike?action=post_comment_like&post_type=${feed.postType}&comment_id=$commentID&post_id=${feed.postId}&user_id=${widget.memberID}');
    print("like unlike comment ${newurl}");
    var newToken = await ApiProvider().newRefreshToken();
    // var token =
    //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID);

    var client = Dio();
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $newToken',
      }),
    )
        .then((value) {
      print("like unlike calue=${value.data}");
      if (value.statusCode == 200) {
        print(value.data);
        getComments();
      }
    });
    // var response = await http.get(url);

    // print(response.body);
    // if (response.statusCode == 200) {
    //   print(jsonDecode(response.body)['response_data']);
    // }
  }

  Future<void> likeUnlikeSubcomment(String subcommentID) async {
    var url =
        "https://www.bebuzee.com/api/post_sub_comment_like_unlike.php?post_type=${feed.postType}&post_id=${feed.postId}&user_id=${widget.memberID}&sub_comment_id=$subcommentID";

    var response = await ApiProvider().fireApi(url);
    // var response = await http.get(url);
    print("like unlike subbcomment caled ${url} ${response.data}");
    print(response.data);
    if (response.statusCode == 200) {
      var convertedJson = response.data;
      getSubComments(commentID);
      setState(() {});
    }
  }

  Future<void> likeUnlikePost() async {
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
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentDelete?action=delete_main_comment_data&user_id=${widget.memberID}&comment_id=$commentID&post_id=${feed.postId}&post_type=${feed.postType}";

    var response = await ApiProvider().fireApi(url);

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
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=delete_sub_comment_data&sub_comment_id=$subcommentID&user_id=${widget.memberID}");
    var url =
        'https://www.bebuzee.com/api/delete_sub_comment_data.php?sub_comment_id=$subcommentID&user_id=${widget.memberID}&post_id=${widget.feed!.postId}&post_type=${widget.feed!.postType}';
    print('delete subcomment from news feed url =${url}');
    var response = await ApiProvider().fireApi(url);

    print('delete subcomment from news feed response=${response.data}');
    if (response.statusCode == 200) {
      print("commentDeleted");
      setState(() {});
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

    // var response = await http.get(url);
    // print(response.body);
    // if (response.statusCode == 200) {
    //   print(response.body);
    //   print("comment successful");
    // }
    // var token =
    //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID);
    // var newurl = 'https://www.bebuzee.com/api/newsfeed/postCommentAdd';
    // print("posted comment ${newurl}");
    var newurl = 'https://www.bebuzee.com/api/newsfeed/postCommentAdd';
    var client = Dio();
    var newToken = await ApiProvider().newRefreshToken();
    await client
        .post(
      newurl,
      queryParameters: {
        "user_id": CurrentUser().currentUser.memberID,
        "post_type": feed.postType,
        "post_id": feed.postId,
        "comments": comment
      },
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $newToken',
      }),
    )
        .then((value) async {
      print("posted comment");

      if (value.statusCode == 200) {
        print("commented success");
        print("posted comment succ");
        getComments();
      }
    });

    // var response = await http.get(url);

    // if (response.statusCode == 200) {}
  }

  Future<void> postReply(String commentID, String reply) async {
    print("Post reply called");
    var url =
        "https://www.bebuzee.com/api/post_sub_comment.php?post_type=${feed.postType}&post_id=${feed.postId}&user_id=${widget.memberID}&comment_id=$commentID&comments=$reply";
    print("get comment post reply ka url=${url}");
    var response = await ApiProvider().fireApi(url);

    print(response.data);

    if (response.statusCode == 200) {
      print(response.data);
      print("reply successful");
    }
  }

  late TaggedUsers usersList;
  bool areUsersLoaded = false;
  late TaggedUsers videoTagsList;
  bool videoTagsLoaded = false;
  var followStatus;

  Future<String> followUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        followStatus = jsonDecode(response.body)['return_val'];
      });
    }

    return "success";
  }

  Future<String> unfollowUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      print("unfollowed");
      setState(() {
        followStatus = jsonDecode(response.body)['return_val'];
      });
    }

    return "success";
  }

  Future<void> getTaggedUsersImage() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=get_all_tagged_user&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.feed!.postId}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      TaggedUsers tagsData = TaggedUsers.fromJson(jsonDecode(response.body));
      if (this.mounted) {
        setState(() {
          usersList = tagsData;
          areUsersLoaded = true;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      setState(() {
        areUsersLoaded = false;
      });
    }
  }

  Future<void> getTaggedUsersVideo() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=get_all_tagged_user&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.feed!.postId}&tag_type=video");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      TaggedUsers tagsData = TaggedUsers.fromJson(jsonDecode(response.body));

      if (this.mounted) {
        setState(() {
          videoTagsList = tagsData;
          videoTagsLoaded = true;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      setState(() {
        videoTagsLoaded = false;
      });
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
      });
    }
  }

  List<Widget> getTaggedUsersIndex() {
    List<Widget> tags = [];

    tags.add(AspectRatio(
      aspectRatio: widget.feed!.postImageWidth! / widget.feed!.postImageHeight!,
      child: ImageCard(
        image: widget.feed!.postImgData,
      ),
    ));
    tags.add(widget.feed!.whiteHeartLogo == true
        ? Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/white_heart.png",
                  height: 100,
                )),
          )
        : Container());
    if (widget.feed!.postTaggedDataDetails != null &&
        widget.feed!.postTaggedDataDetails != "" &&
        widget.feed!.showUserTags == true) {
      widget.feed!.postTaggedDataDetails!.split("~~~").forEach((e) {
        tags.add(Positioned.fill(
          child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.feed!.singlePost == 0
                          ? (double.parse(e.split("^^")[2]) / 100) *
                              (MediaQuery.of(context).size.width /
                                  widget.feed!.postImageWidth!) *
                              widget.feed!.postImageHeight!
                          : double.parse(e.split("^^")[2]),
                      left: widget.feed!.singlePost == 0
                          ? (double.parse(e.split("^^")[1]) / 100) *
                              (MediaQuery.of(context).size.width)
                          : double.parse(e.split("^^")[1])),
                  child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(1.0.w),
                        child: Text(e.split("^^")[3],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.0.sp,
                            )),
                      )))),
        ));
      });
    }

    tags.add(widget.feed!.postTaggedDataDetails != null &&
            widget.feed!.postTaggedDataDetails != ""
        ? Positioned.fill(
            bottom: 7,
            left: 10,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () {
                    print(widget.feed!.postId);
                    showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        //isScrollControlled:true,
                        context: context,
                        builder: (BuildContext bc) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter stateSetter) {
                            return Container(
                              child: areUsersLoaded
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: usersList.users.length,
                                      itemBuilder: (context, index) {
                                        var user = usersList.users[index];

                                        return TaggedUsersBottomTile(
                                          index: index,
                                          user: user,
                                          goToProfile: () {
                                            setState(() {
                                              OtherUser().otherUser.memberID =
                                                  user.memberId;
                                              OtherUser().otherUser.shortcode =
                                                  user.shortcode;
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfilePageMain(
                                                          setNavBar:
                                                              widget.setNavBar,
                                                          isChannelOpen: widget
                                                              .isChannelOpen,
                                                          changeColor: widget
                                                              .changeColor,
                                                          otherMemberID:
                                                              user.memberId,
                                                        )));
                                          },
                                          onTap: () {
                                            if (user.followData == "Follow") {
                                              followUser(user.memberId!);
                                              Timer(Duration(seconds: 3), () {
                                                stateSetter(() {
                                                  user.followData =
                                                      followStatus;
                                                });
                                              });
                                            } else {
                                              unfollowUser(user.memberId!);
                                              Timer(Duration(seconds: 3), () {
                                                stateSetter(() {
                                                  user.followData =
                                                      followStatus;
                                                });
                                              });
                                            }
                                          },
                                        );
                                      })
                                  : Container(),
                            );
                          });
                        });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: new Border.all(
                          width: 0.1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/tag.png",
                          height: 2.0.h,
                        ),
                      )),
                )),
          )
        : Container());
    tags.add(
        widget.feed!.postDomainName != "" && widget.feed!.postDomainName != null
            ? Positioned.fill(
                bottom: 5,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebsiteView(
                                        url: widget.feed!.postUrlNam,
                                        heading: "",
                                      )));
                        },
                        child: Container(
                          color: Colors.grey[800],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  widget.feed!.postDomainName!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container());

    return tags;
  }

  Map<String, List<Widget>> getMultipleTags() {
    Map<String, List<Widget>> tagsWidgets = new Map<String, List<Widget>>();
    if (widget.feed!.postTaggedDataDetails != "") {
      List<String> tmp = widget.feed!.postTaggedDataDetails!.split('~~~');
      tmp.forEach((element) {
        List<String> tmp1 = element.split("^^");
        if (tagsWidgets.containsKey(tmp1[0].split("_")[2]) &&
            widget.feed!.showUserTags!) {
          tagsWidgets[tmp1[0].split("_")[2]]!.add(Positioned.fill(
            top: double.parse(element.split("^^")[2]),
            left: double.parse(element.split("^^")[1]),
            child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 0.5.h, horizontal: 1.0.w),
                    child: Text(
                      element.split("^^")[3],
                      style: TextStyle(fontSize: 9.0.sp, color: Colors.white),
                    ),
                  ),
                )),
          ));
        } else {
          tagsWidgets[tmp1[0].split("_")[2]] = [
            GestureDetector(
              onTap: () {
                if (widget.feed!.postTaggedDataDetails != "") {
                  setState(() {
                    widget.feed!.showUserTags = true;
                  });
                  Timer(Duration(seconds: 2), () {
                    setState(() {
                      widget.feed!.showUserTags = false;
                    });
                  });
                }
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
            widget.feed!.showUserTags == true
                ? Positioned.fill(
                    top: double.parse(element.split("^^")[2]),
                    left: double.parse(element.split("^^")[1]),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.5.h, horizontal: 1.0.w),
                            child: Text(
                              element.split("^^")[3],
                              style: TextStyle(
                                  fontSize: 9.0.sp, color: Colors.white),
                            ),
                          ),
                        )),
                  )
                : Container()
          ];
        }
      });
    }

    return tagsWidgets;
  }

  @override
  void initState() {
    print("blog getData()0");

    // if (widget.feed.postTaggedDataDetails != "") {
    //    getTaggedUsersImage();
    // }
    print("blog getData()1");
    // if (widget.feed.videoTag == 1) {
    //    getTaggedUsersVideo();
    // }
    print("blog getData()2");
    getData();

    if (widget.feed!.postLikeIcon ==
        "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
      setState(() {
        widget.feed!.isLiked = true;
      });
    } else {
      setState(() {
        widget.feed!.isLiked = false;
      });
    }

    if (areCommentsLoaded) {}

    getComments();
    checkLikeStatus();
    getCurrentMember();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.from == 'blogbuzz') {
      widget.updateblogbuz!(commentsList.comments.length);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of("Comments"),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 1.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpandedFeedHeader(
                    test: "",
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
                            builder: (context) => DiscoverFromTagsView(
                              tag: value.toString().substring(1),
                            ),
                          ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => HashtagPage(
                      //               hashtag: value.toString().substring(1),
                      //               memberID: widget.memberID,
                      //               country: widget.country,
                      //               logo: widget.logo,
                      //             )));
                    },
                  ),
                  widget.from == "Location"
                      ? Padding(
                          padding: EdgeInsets.only(top: 2.0.h),
                          child: Column(
                            children: [
                              widget.feed!.postMultiImage == 1
                                  ? GestureDetector(
                                      onDoubleTap: () {},
                                      child: Container(
                                        height: 50.0.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: PreloadPageView.builder(
                                          preloadPagesCount: 5,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (val) {
                                            setState(() {
                                              widget.feed!.pageIndex = val;
                                            });
                                          },
                                          itemCount: widget.feed!.postImgData!
                                              .split("~~")
                                              .length,
                                          itemBuilder: (context, indexImage) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: widget.feed!
                                                              .postImgData!
                                                              .split('~~')[
                                                                  indexImage]
                                                              .endsWith(
                                                                  ".mp4") ||
                                                          widget.feed!
                                                              .postImgData!
                                                              .split('~~')[
                                                                  indexImage]
                                                              .endsWith(".m3u8")
                                                      ? FeedsSingleVideoPlayer(
                                                          image: widget.feed!
                                                              .postImgData!
                                                              .split('~~')[
                                                                  indexImage]
                                                              .replaceAll(
                                                                  ".mp4",
                                                                  ".jpg")
                                                              .replaceAll(
                                                                  "/compressed",
                                                                  ""),
                                                          url: widget.feed!
                                                                  .postImgData!
                                                                  .split('~~')[
                                                              indexImage],
                                                        )
                                                      : Container(
                                                          height: 50.0.h,
                                                          child: widget.feed!
                                                                      .cropped ==
                                                                  1
                                                              ? Image.network(
                                                                  widget.feed!
                                                                          .postImgData!
                                                                          .split(
                                                                              "~~")[
                                                                      indexImage],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.network(
                                                                  widget.feed!
                                                                          .postImgData!
                                                                          .split(
                                                                              "~~")[
                                                                      indexImage],
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                        ),
                                                ),
                                                Positioned.fill(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 1.0.h,
                                                                  right: 1.5.w),
                                                          child: Container(
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            2.0
                                                                                .w,
                                                                        vertical:
                                                                            1.0.w),
                                                                child: Text(
                                                                  (widget.feed!.pageIndex! +
                                                                              1)
                                                                          .toString() +
                                                                      "/" +
                                                                      widget
                                                                          .feed!
                                                                          .postImgData!
                                                                          .split(
                                                                              "~~")
                                                                          .length
                                                                          .toString(),
                                                                  style: whiteNormal
                                                                      .copyWith(
                                                                          fontSize:
                                                                              10.0.sp),
                                                                ),
                                                              )))),
                                                ),
                                                widget.feed!.postTaggedDataDetails !=
                                                            null &&
                                                        widget.feed!
                                                                .postTaggedDataDetails !=
                                                            "" &&
                                                        (!widget.feed!
                                                                .postImgData!
                                                                .split('~~')[
                                                                    indexImage]
                                                                .endsWith(
                                                                    ".mp4") ||
                                                            !widget.feed!
                                                                .postImgData!
                                                                .split('~~')[
                                                                    indexImage]
                                                                .endsWith(
                                                                    ".m3u8"))
                                                    ? Stack(
                                                        children:

                                                            // getMultipleTags()[
                                                            //             (indexImage +
                                                            //                     1)
                                                            //                 .toString()] !=
                                                            //         null
                                                            //     ?

                                                            getMultipleTags()[
                                                                    (indexImage +
                                                                            1)
                                                                        .toString()] ??
                                                                [Container()],
                                                      )
                                                    : Container(),
                                                widget.feed!.postTaggedDataDetails !=
                                                            null &&
                                                        widget.feed!
                                                                .postTaggedDataDetails !=
                                                            "" &&
                                                        (!widget.feed!
                                                                .postImgData!
                                                                .split('~~')[
                                                                    indexImage]
                                                                .endsWith(
                                                                    ".mp4") ||
                                                            !widget.feed!
                                                                .postImgData!
                                                                .split('~~')[
                                                                    indexImage]
                                                                .endsWith(
                                                                    ".m3u8"))
                                                    ? Positioned.fill(
                                                        bottom: 1.5.w,
                                                        left: 1.5.w,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: InkWell(
                                                              onTap: () {
                                                                print(widget
                                                                    .feed!
                                                                    .postId);
                                                                showModalBottomSheet(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
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
                                                                      return StatefulBuilder(builder: (BuildContext
                                                                              context,
                                                                          StateSetter
                                                                              stateSetter) {
                                                                        return Container(
                                                                          child: areUsersLoaded
                                                                              ? ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: usersList.users.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    var user = usersList.users[index];
                                                                                    return TaggedUsersBottomTile(
                                                                                      index: index,
                                                                                      user: user,
                                                                                      goToProfile: () {
                                                                                        setState(() {
                                                                                          OtherUser().otherUser.memberID = user.memberId;
                                                                                          OtherUser().otherUser.shortcode = user.shortcode;
                                                                                        });
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (context) => ProfilePageMain(
                                                                                                      setNavBar: widget.setNavBar,
                                                                                                      isChannelOpen: widget.isChannelOpen,
                                                                                                      changeColor: widget.changeColor,
                                                                                                      otherMemberID: user.memberId,
                                                                                                    )));
                                                                                      },
                                                                                      onTap: () {},
                                                                                    );
                                                                                  })
                                                                              : Container(),
                                                                        );
                                                                      });
                                                                    });
                                                              },
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      right:
                                                                          3.0.h,
                                                                      top: 3.0
                                                                          .h),
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.black,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border:
                                                                                new Border.all(
                                                                              width: 0.1,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/tag.png",
                                                                              height: 1.8.h,
                                                                            ),
                                                                          )),
                                                                ),
                                                              ),
                                                            )),
                                                      )
                                                    : Container(),
                                                widget.feed!.videoTag == 1 &&
                                                        (widget.feed!
                                                                .postImgData!
                                                                .split('~~')[
                                                                    indexImage]
                                                                .endsWith(
                                                                    ".mp4") ||
                                                            widget.feed!
                                                                .postImgData!
                                                                .split('~~')[
                                                                    indexImage]
                                                                .endsWith(
                                                                    ".m3u8"))
                                                    ? Positioned.fill(
                                                        bottom: 1.5.w,
                                                        left: 1.5.w,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: InkWell(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
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
                                                                      return StatefulBuilder(builder: (BuildContext
                                                                              context,
                                                                          StateSetter
                                                                              stateSetter) {
                                                                        return Container(
                                                                          child: videoTagsLoaded
                                                                              ? ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: videoTagsList.users.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    var user = videoTagsList.users[index];

                                                                                    return TaggedUsersBottomTile(
                                                                                      index: index,
                                                                                      user: user,
                                                                                      goToProfile: () {
                                                                                        setState(() {
                                                                                          OtherUser().otherUser.memberID = user.memberId;
                                                                                          OtherUser().otherUser.shortcode = user.shortcode;
                                                                                        });
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (context) => ProfilePageMain(
                                                                                                      setNavBar: widget.setNavBar,
                                                                                                      isChannelOpen: widget.isChannelOpen,
                                                                                                      changeColor: widget.changeColor,
                                                                                                      otherMemberID: user.memberId,
                                                                                                    )));
                                                                                      },
                                                                                      onTap: () {
                                                                                        if (user.followData == "Follow") {
                                                                                          followUser(user.memberId!);
                                                                                          Timer(Duration(seconds: 3), () {
                                                                                            stateSetter(() {
                                                                                              user.followData = followStatus;
                                                                                            });
                                                                                          });
                                                                                        } else {
                                                                                          unfollowUser(user.memberId!);
                                                                                          Timer(Duration(seconds: 3), () {
                                                                                            stateSetter(() {
                                                                                              user.followData = followStatus;
                                                                                            });
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                    );
                                                                                  })
                                                                              : Container(),
                                                                        );
                                                                      });
                                                                    });
                                                              },
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      right:
                                                                          3.0.h,
                                                                      top: 3.0
                                                                          .h),
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.black,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border:
                                                                                new Border.all(
                                                                              width: 0.1,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/tag.png",
                                                                              height: 1.8.h,
                                                                            ),
                                                                          )),
                                                                ),
                                                              ),
                                                            )),
                                                      )
                                                    : Container(),
                                                widget.feed!.postDomainName !=
                                                            "" &&
                                                        widget!.feed!
                                                                .postDomainName !=
                                                            null
                                                    ? Positioned.fill(
                                                        bottom:
                                                            _currentScreenSize
                                                                    .height *
                                                                0.065,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .contain,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => WebsiteView(
                                                                              url: widget.feed!.postUrlNam,
                                                                              heading: "")));
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .arrow_forward_outlined,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                          widget
                                                                              .feed!
                                                                              .postDomainName!,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                widget.feed!.whiteHeartLogo ==
                                                        true
                                                    ? Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Image.asset(
                                                              "assets/images/white_heart.png",
                                                              height: 100,
                                                            )),
                                                      )
                                                    : Container(),
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: widget
                                                            .feed!.postImgData!
                                                            .split("~~")
                                                            .map((e) {
                                                          var ind = widget.feed!
                                                              .postImgData!
                                                              .split("~~")
                                                              .indexOf(e);
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: CircleAvatar(
                                                              radius: 4,
                                                              backgroundColor: widget
                                                                          .feed!
                                                                          .pageIndex ==
                                                                      ind
                                                                  ? Colors.white
                                                                  : Colors.grey
                                                                      .withOpacity(
                                                                          0.6),
                                                            ),
                                                          );
                                                        }).toList()),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : widget.feed!.postType == "Video" ||
                                          widget.feed!.postType == "svideo"
                                      ? FeedBodyVideo(
                                          feed: widget.feed,
                                          tagTap: () {
                                            showModalBottomSheet(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: const Radius
                                                                .circular(20.0),
                                                            topRight: const Radius
                                                                    .circular(
                                                                20.0))),
                                                //isScrollControlled:true,
                                                context: context,
                                                builder: (BuildContext bc) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  stateSetter) {
                                                    return Container(
                                                      child: videoTagsLoaded
                                                          ? ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  videoTagsList
                                                                      .users
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                var user =
                                                                    videoTagsList
                                                                            .users[
                                                                        index];
                                                                return TaggedUsersBottomTile(
                                                                  index: index,
                                                                  user: user,
                                                                  goToProfile:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      OtherUser()
                                                                          .otherUser
                                                                          .memberID = user.memberId;
                                                                      OtherUser()
                                                                          .otherUser
                                                                          .shortcode = user.shortcode;
                                                                    });
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => ProfilePageMain(
                                                                                  setNavBar: widget.setNavBar,
                                                                                  isChannelOpen: widget.isChannelOpen,
                                                                                  changeColor: widget.changeColor,
                                                                                  otherMemberID: user.memberId,
                                                                                )));
                                                                  },
                                                                  onTap: () {
                                                                    if (user.followData ==
                                                                        "Follow") {
                                                                      followUser(
                                                                          user.memberId!);
                                                                      Timer(
                                                                          Duration(
                                                                              seconds: 3),
                                                                          () {
                                                                        stateSetter(
                                                                            () {
                                                                          user.followData =
                                                                              followStatus;
                                                                        });
                                                                      });
                                                                    } else {
                                                                      unfollowUser(
                                                                          user.memberId!);
                                                                      Timer(
                                                                          Duration(
                                                                              seconds: 3),
                                                                          () {
                                                                        stateSetter(
                                                                            () {
                                                                          user.followData =
                                                                              followStatus;
                                                                        });
                                                                      });
                                                                    }
                                                                  },
                                                                );
                                                              })
                                                          : Container(),
                                                    );
                                                  });
                                                });
                                          },
                                        )
                                      : widget.feed!.postType == "blog"
                                          ? BlogFooter(
                                              feed: widget.feed,
                                              setNavBar: widget.setNavBar,
                                              isChannelOpen:
                                                  widget.isChannelOpen,
                                              changeColor: widget.changeColor,
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  widget.feed!.showUserTags =
                                                      true;
                                                });

                                                Timer(Duration(seconds: 2), () {
                                                  setState(() {
                                                    widget.feed!.showUserTags =
                                                        false;
                                                  });
                                                });
                                              },
                                              child: Stack(
                                                  children:
                                                      getTaggedUsersIndex()),
                                            ),
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
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                OtherUser().otherUser.memberID =
                                                    commentsList.comments[index]
                                                        .memberId;
                                                OtherUser()
                                                        .otherUser
                                                        .shortcode =
                                                    commentsList.comments[index]
                                                        .shortcode;
                                              });
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             ProfilePageMain(
                                              //               setNavBar: widget
                                              //                   .setNavBar,
                                              //               isChannelOpen: widget
                                              //                   .isChannelOpen,
                                              //               changeColor: widget
                                              //                   .changeColor,
                                              //               otherMemberID:
                                              //                   commentsList
                                              //                       .comments[
                                              //                           index]
                                              //                       .memberId,
                                              //             )));
                                            },
                                            child: Container(
                                              color: Colors.transparent,
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
                                                      radius: 17,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              commentsList
                                                                  .comments[
                                                                      index]
                                                                  .image!),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: _currentScreenSize
                                                            .width *
                                                        0.05,
                                                  ),
                                                  Container(
                                                    child: Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
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
                                                                      .comments[
                                                                          index]
                                                                      .shortcode!,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              IconButton(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  constraints:
                                                                      BoxConstraints(),
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onPressed:
                                                                      () {
                                                                    if (commentsList
                                                                            .comments[
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
                                                                              deleteComment(commentsList.comments[index].commentId!);
                                                                              setState(() {
                                                                                commentsList.comments.removeAt(index);
                                                                              });
                                                                              Timer(Duration(seconds: 3), () {
                                                                                getComments();
                                                                              });

                                                                              Navigator.pop(context);
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
                                                                              reportCommentAbusive(commentsList.comments[index].commentId!);

                                                                              showDialog(
                                                                                  context: _scaffoldKey.currentContext!,
                                                                                  builder: (BuildContext context) {
                                                                                    // return object of type Dialog

                                                                                    return ReportSuccessPopup();
                                                                                  });
                                                                            },
                                                                            onReportSpam:
                                                                                () {
                                                                              reportCommentSpam(commentsList.comments[index].commentId!);

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
                                                                  icon: Icon(Icons
                                                                      .more_horiz_outlined))
                                                            ],
                                                          ),
                                                          ParsedText(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    10.0.sp),
                                                            text: commentsList
                                                                .comments[index]
                                                                .message!,
                                                            parse: <MatchText>[
                                                              MatchText(
                                                                  onTap:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      OtherUser().otherUser.memberID = value
                                                                          .toString()
                                                                          .replaceAll(
                                                                              "@",
                                                                              "");
                                                                      OtherUser().otherUser.shortcode = value
                                                                          .toString()
                                                                          .replaceAll(
                                                                              "@",
                                                                              "");
                                                                    });
                                                                    print(
                                                                        "value=${value.toString().replaceAll("@", "")}");
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => ProfilePageMain(
                                                                                  from: "tags",
                                                                                  setNavBar: widget.setNavBar,
                                                                                  isChannelOpen: widget.isChannelOpen,
                                                                                  changeColor: widget.changeColor,
                                                                                  otherMemberID: value.toString().replaceAll("@", ""),
                                                                                )));
                                                                  },
                                                                  pattern:
                                                                      "(@+[a-zA-Z0-9(_)]{1,})",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              MatchText(
                                                                  onTap:
                                                                      (value) {
                                                                    print(
                                                                        value);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              DiscoverFromTagsView(
                                                                            tag:
                                                                                value.toString().substring(1),
                                                                          ),
                                                                        ));
                                                                    // Navigator.push(
                                                                    //     context,
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (context) => HashtagPage(
                                                                    //               hashtag: value.toString().substring(1),
                                                                    //               memberID: widget.memberID,
                                                                    //               country: widget.country,
                                                                    //               logo: widget.logo,
                                                                    //             )));
                                                                  },
                                                                  pattern:
                                                                      "(#+[a-zA-Z0-9(_)]{1,})",
                                                                  style: TextStyle(
                                                                      color:
                                                                          primaryBlueColor))
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 1.0.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
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
                                                                            9.0.sp),
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
                                                                            .grey,
                                                                        fontSize:
                                                                            9.0.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    width: _currentScreenSize
                                                                            .width *
                                                                        0.07,
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          print(
                                                                              "clicked on reply");
                                                                          isReply =
                                                                              true;
                                                                          commentID = commentsList
                                                                              .comments[index]
                                                                              .commentId!;

                                                                          _commentController.text = areCommentsLoaded
                                                                              ? "@" + commentsList.comments[index].shortcode! + " "
                                                                              : "";
                                                                          _commentController.selection =
                                                                              TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                                                                        });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        AppLocalizations.of(
                                                                            "Reply"),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: 9.0.sp),
                                                                      )),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                      constraints:
                                                                          BoxConstraints(),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          commentsList
                                                                              .comments[index]
                                                                              .isLiked = !commentsList.comments[index].isLiked!;
                                                                        });
                                                                        likeUnlikeComment(commentsList
                                                                            .comments[index]
                                                                            .commentId!);
                                                                      },
                                                                      icon: !commentsList
                                                                              .comments[index]
                                                                              .isLiked!
                                                                          ? Padding(
                                                                              padding: EdgeInsets.all(0),
                                                                              child: Icon(
                                                                                CustomIcons.heart,
                                                                                size: 12,
                                                                              ),
                                                                            )
                                                                          : Padding(
                                                                              padding: EdgeInsets.all(0),
                                                                              child: Icon(
                                                                                CustomIcons.like,
                                                                                color: Colors.red,
                                                                                size: 12,
                                                                              ),
                                                                            )),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          commentsList
                                                                      .comments[
                                                                          index]
                                                                      .subComment !=
                                                                  ""
                                                              ? Container(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "comment box open=${commentsList.comments[index].isSubCommentOpen}");
                                                                      setState(
                                                                          () {
                                                                        commentsList
                                                                            .comments[index]
                                                                            .isSubCommentOpen = !commentsList.comments[index].isSubCommentOpen!;
                                                                      });
                                                                      print(
                                                                          "comment box open after ${commentsList.comments[index].isSubCommentOpen}");
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          color:
                                                                              Colors.grey,
                                                                          height:
                                                                              _currentScreenSize.height * 0.002,
                                                                          width:
                                                                              _currentScreenSize.width * 0.08,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              _currentScreenSize.width * 0.04,
                                                                        ),
                                                                        Text(
                                                                          commentsList.comments[index].isSubCommentOpen == true
                                                                              ? AppLocalizations.of("Hide Replies")
                                                                              : "${AppLocalizations.of("View Replies")} (${commentsList.comments[index].subComment.toString()})",
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 13),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          commentsList
                                                                      .comments[
                                                                          index]
                                                                      .isSubCommentOpen ==
                                                                  true
                                                              ? FutureBuilder<
                                                                      dynamic>(
                                                                  future: getSubComments(commentsList
                                                                      .comments[
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
                                                                          snapshot
                                                                              .data;
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
                                                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 0.5.h,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    width: 50.0.w,
                                                                                                    child: ParsedText(
                                                                                                      style: TextStyle(color: Colors.black),
                                                                                                      text: e.comment!,
                                                                                                      parse: <MatchText>[
                                                                                                        MatchText(
                                                                                                            onTap: (value) {
                                                                                                              setState(() {
                                                                                                                OtherUser().otherUser.memberID = value.toString().replaceAll("@", "");
                                                                                                                OtherUser().otherUser.shortcode = value.toString().replaceAll("@", "");
                                                                                                              });
                                                                                                              Navigator.push(
                                                                                                                  context,
                                                                                                                  MaterialPageRoute(
                                                                                                                      builder: (context) => ProfilePageMain(
                                                                                                                            from: "tags",
                                                                                                                            setNavBar: widget.setNavBar,
                                                                                                                            isChannelOpen: widget.isChannelOpen,
                                                                                                                            changeColor: widget.changeColor,
                                                                                                                            otherMemberID: value.toString().replaceAll("@", ""),
                                                                                                                          )));
                                                                                                            },
                                                                                                            pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.blue,
                                                                                                            )),
                                                                                                        MatchText(
                                                                                                            onTap: (value) {
                                                                                                              print(value);
                                                                                                              Navigator.push(
                                                                                                                  context,
                                                                                                                  MaterialPageRoute(
                                                                                                                    builder: (context) => DiscoverFromTagsView(
                                                                                                                      tag: value.toString().substring(1),
                                                                                                                    ),
                                                                                                                  ));
                                                                                                              // Navigator.push(
                                                                                                              //     context,
                                                                                                              //     MaterialPageRoute(
                                                                                                              //         builder: (context) => HashtagPage(
                                                                                                              //               hashtag: value.toString().substring(1),
                                                                                                              //               memberID: widget.memberID,
                                                                                                              //               country: widget.country,
                                                                                                              //               logo: widget.logo,
                                                                                                              //             )));
                                                                                                            },
                                                                                                            pattern: "(#+[a-zA-Z0-9(_)]{1,})",
                                                                                                            style: TextStyle(color: Colors.blue))
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 1.5.h,
                                                                                                  ),
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        e.timeStamp!,
                                                                                                        style: TextStyle(color: Colors.grey, fontSize: 8.0.sp),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: 15,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        e.totalLikes!,
                                                                                                        style: TextStyle(color: Colors.grey, fontSize: 8.0.sp),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: 3.0.w,
                                                                                                      ),
                                                                                                      GestureDetector(
                                                                                                          onTap: () {
                                                                                                            setState(() {
                                                                                                              print("clicked on reply commentid=${e.subCommentId}");
                                                                                                              isReply = true;
                                                                                                              commentID = commentsList.comments[index].commentId!;

                                                                                                              _commentController.text = areCommentsLoaded ? "@" + commentsList.comments[index].shortcode! + " " : "";
                                                                                                              _commentController.selection = TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                                                                                                            });

                                                                                                            print("tappa tap");
                                                                                                            // setState(() {
                                                                                                            //   isReply = true;
                                                                                                            //   // subCommentID = e.subCommentId;

                                                                                                            //   _commentController.text = areSubCommentsLoaded ? "@" + e.shortcode + " " : "";
                                                                                                            //   _commentController.selection = TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                                                                                                            // });
                                                                                                          },
                                                                                                          child: Text(
                                                                                                            AppLocalizations.of(
                                                                                                              "Reply",
                                                                                                            ),
                                                                                                            style: TextStyle(color: Colors.grey, fontSize: 8.0.sp),
                                                                                                          )),
                                                                                                      SizedBox(
                                                                                                        width: 5.0.w,
                                                                                                      ),
                                                                                                      IconButton(
                                                                                                          padding: EdgeInsets.all(0),
                                                                                                          constraints: BoxConstraints(),
                                                                                                          onPressed: () async {
                                                                                                            setState(() {
                                                                                                              print("like status of ${e.isLiked} tot likes=${e.totalLikes}");
                                                                                                              e.isLiked = !e.isLiked!;
                                                                                                              print("like status of after =${e.isLiked} tot likes=${e.totalLikes}");
                                                                                                            });

                                                                                                            print("after api call like stat=${e.isLiked}");
                                                                                                            setState(() {
                                                                                                              commentsList.comments[index].isSubCommentOpen = true;
                                                                                                            });
                                                                                                            likeUnlikeSubcomment(e.subCommentId!);
                                                                                                          },
                                                                                                          icon: !e.isLiked!
                                                                                                              ? Padding(
                                                                                                                  padding: EdgeInsets.all(0),
                                                                                                                  child: Icon(
                                                                                                                    CustomIcons.heart,
                                                                                                                    size: 12,
                                                                                                                  ),
                                                                                                                )
                                                                                                              : Padding(
                                                                                                                  padding: EdgeInsets.all(0),
                                                                                                                  child: Icon(
                                                                                                                    CustomIcons.like,
                                                                                                                    color: Colors.red,
                                                                                                                    size: 12,
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
                                                                                                print("userid=${commentsList.comments[index].memberId} ${widget.memberID} ${widget.postID}");
                                                                                                if (commentsList.comments[index].memberId == CurrentUser().currentUser.memberID) {
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
                                                                                              child: Icon(
                                                                                                Icons.more_horiz_outlined,
                                                                                              ))
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
                  Divider(
                    thickness: 1,
                  ),
                  tagList != null && tagList.userTags.length > 0
                      ? Container(
                          height: 50.0.h,
                          child: SingleChildScrollView(
                            child: Column(
                                children: tagList.userTags.map((s) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 0.8.h),
                                child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  onTap: () {
                                    String? str;
                                    _commentController.text
                                        .split(" ")
                                        .forEach((element) {
                                      if (element.startsWith("@")) {
                                        str = element;
                                      }
                                    });
                                    String? data = _commentController.text;
                                    data = _commentController.text.substring(
                                        0, data.length - str!.length + 1);
                                    data += s.shortcode!;
                                    data += " ";
                                    setState(() {
                                      _commentController.text = data!;
                                      tagList.userTags = [];
                                    });
                                    _commentController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _commentController
                                                .text.length));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
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
                                            radius: 2.3.h,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage:
                                                NetworkImage(s.image!),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.0.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 70.0.w,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            s.name!,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    10.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(
                                                            width: 1.0.w,
                                                          ),
                                                          s.varifiedStatus == 1
                                                              ? Image.network(
                                                                  s.varifiedImage!,
                                                                  height: 13,
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 0.2.h,
                                            ),
                                            Container(
                                              width: 70.0.w,
                                              child: Text(
                                                s.shortcode!,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10.0.sp),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList()),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        showEmoji == true
                            ? Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 0.5.h),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji1,
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji2,
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji3,
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji4,
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji5,
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji6,
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji7,
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                        offset:
                                                            _commentController
                                                                .text.length));
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1.2.h),
                                                child: Text(
                                                  emoji8,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ))),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        // commentsList.comments.length != 0
                        //     ? Container(
                        //         child: Center(
                        //             child: GestureDetector(
                        //                 onTap: () {
                        //                   getCommentsLoad();
                        //                 },
                        //                 child: Text('View more'))),
                        //       )
                        //     : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
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
                                          radius: 2.0.h,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              CurrentUser().currentUser.image!),
                                        )),
                                  ),
                                ),
                                Container(
                                  width: 75.0.w,
                                  child: TextFormField(
                                    onTap: () {
                                      setState(() {
                                        showEmoji = true;
                                      });
                                    },
                                    maxLines: null,
                                    controller: _commentController,
                                    keyboardType: TextInputType.text,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    onChanged: (val) {
                                      Timer? timeHandle;
                                      if (timeHandle != null) {
                                        timeHandle.cancel();
                                      }
                                      timeHandle = Timer(
                                          Duration(microseconds: 500), () {
                                        print(val);

                                        List<String> words = val.split(" ");
                                        if (words[words.length - 1]
                                            .startsWith("@")) {
                                          getUserTags(words[words.length - 1]
                                              .replaceAll("@", ""));
                                        } else {
                                          setState(() {
                                            tagList.userTags = [];
                                          });
                                        }
                                        List<String> hashlist = val.split(" ");
                                        if (hashlist[hashlist.length - 1]
                                            .startsWith('#')) {
                                          // getUserHash(
                                          //     hashlist[hashlist.length - 1]);
                                        } else {
                                          // setState((){

                                          // })
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
                                          ' ${AppLocalizations.of("Comment as ")}${CurrentUser().currentUser.shortcode.toString()}',
                                      // 48 -> icon width
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: _currentScreenSize.width * 0.1,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (isReply == false) {
                                        postComment(_commentController.text);
                                        _commentController.clear();

                                        Timer(Duration(seconds: 2), () {
                                          getComments();
                                        });
                                      } else {
                                        postReply(
                                            commentID, _commentController.text);
                                        _commentController.clear();
                                        Timer(Duration(seconds: 1), () {
                                          getComments();
                                          // getSubComments(commentID);
                                        });
                                      }

                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: Text(
                                      AppLocalizations.of("Post"),
                                      style: TextStyle(color: primaryBlueColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
