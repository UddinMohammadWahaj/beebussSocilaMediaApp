import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:bizbultest/widgets/Stories/share_story.dart';
import 'package:bizbultest/widgets/Stories/user_views_card.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/models/story_user_views_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import '../../utilities/deep_links.dart';

class StoriesViewsCard extends StatefulWidget {
  final FileElement? allFiles;
  final Function? onTap;
  final VoidCallback? delete;
  final Function? setNavbar;
  StoriesViewsCard(
      {Key? key, this.allFiles, this.onTap, this.delete, this.setNavbar})
      : super(key: key);

  @override
  _StoriesViewsCardState createState() => _StoriesViewsCardState();
}

class _StoriesViewsCardState extends State<StoriesViewsCard> {
  StoryUserViews? userViewsList;
  bool areUsersLoaded = false;
  late ResponsesData? resData;

  Future<void> getUsers() async {
    print("get user story called");
    var url =
        "https://www.bebuzee.com/api/storyViewUserList?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=${widget.allFiles!.id}&story_id=${widget.allFiles!.storyId}&story_user_id=${CurrentUser().currentUser.memberID}";
    print('get users story=${url}');
    var response = await ApiProvider().fireApi(url);
    print('get users story=${url}');
    if (response.statusCode == 200) {
      StoryUserViews userData = StoryUserViews.fromJson(response.data['data']);

      if (mounted) {
        setState(() {
          userViewsList = userData;
          areUsersLoaded = true;
        });
      }
    }

    if (response.data == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areUsersLoaded = false;
        });
      }
    }
  }

  Future<void> getAllResponse() async {
    // var url=''
    var url =
        "https://www.bebuzee.com/api/storyUserResponseList?action=get_all_user_response&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&story_id=${widget.allFiles!.id}&position=${widget.allFiles!.storyId}";
    print("get all response url=${url}");
    var response = await ApiProvider().fireApi(url).then((v) => v);
    ResponsesData? resdata;
    if (response.statusCode == 200) {
      print("response got=${response.data}");
      try {
        resdata = ResponsesData.fromJson(response.data);
      } catch (e) {
        print("get all responses error $e");
      }
      if (mounted) {
        setState(() {
          this.resData = resdata;
          // userViewsList = userData;
          // areUsersLoaded = true;
        });
      }
    }
    if (response.data == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          // areUsersLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    getUsers();
    getAllResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 0.8,
          width: 100.0.w,
          color: Colors.grey.withOpacity(0.2),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 2.0.h,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 0.5.w,
                        ),
                        Text(
                          widget.allFiles!.count.toString(),
                          style: blackBold.copyWith(fontSize: 10.0.sp),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        if (widget.allFiles!.video == 0) {
                          GallerySaver.saveImage(widget.allFiles!.image!);
                        } else {
                          GallerySaver.saveVideo(widget.allFiles!.image!);
                        }
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(
                            "Saved to gallery",
                          ),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.black,
                        size: 3.5.h,
                      )),
                  IconButton(
                      onPressed: () async {
                        Uri uri = await DeepLinks.createStoryDeepLink(
                          CurrentUser().currentUser.memberID!,
                          "story",
                          this.resData!.storyData!.image!,
                          "Check this story out by ${CurrentUser().currentUser.fullName}",
                          "${CurrentUser().currentUser.shortcode}",
                        );
                        Share.share(
                          '${uri.toString()}',
                        );
                      },
                      icon: Icon(
                        Icons.ios_share,
                        color: Colors.black,
                        size: 3.5.h,
                      )),
                  IconButton(
                      onPressed: widget.delete! ?? () {},
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.black,
                        size: 3.5.h,
                      )),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 0.8,
          width: 100.0.w,
          color: Colors.grey.withOpacity(0.2),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Responses",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print("see all");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ResponsesAnswers(
                            res: this.resData!.responseList,
                          )));
                },
                child: Container(
                  child: Row(
                    children: [
                      Text(
                        "See all",
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (resData != null &&
            resData!.responseList != null &&
            resData!.responseList!.isNotEmpty)
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...resData!.responseList!.map((e) => QuestionAnswerBox(
                        res: e,
                        setNavbar: widget.setNavbar!,
                        questionsText: resData!.storyData!.questions,
                      )),
                ],
              ),
            ),
          ),
        Container(
          height: 0.8,
          width: 100.0.w,
          color: Colors.grey.withOpacity(0.2),
        ),
        areUsersLoaded
            ? Expanded(
                child: ListView.builder(
                    itemCount: userViewsList!.users.length,
                    itemBuilder: (context, index) {
                      var user = userViewsList!.users[index];
                      return UserViewsCard(
                        onTap: widget.onTap!,
                        user: user,
                      );
                    }),
              )
            : Container()
      ],
    );
  }
}

class QuestionAnswerBox extends StatelessWidget {
  final ResponseList res;
  final Function? setNavbar;
  final String? questionsText;
  QuestionAnswerBox(
      {Key? key, required this.res, this.setNavbar, this.questionsText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: EdgeInsets.all(5),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      child:
                          Text(res.memberName!.substring(0, 1).toUpperCase()),
                      foregroundImage: NetworkImage(res.imageLink!),
                      radius: 15,
                    ),
                    SizedBox(width: 6),
                    Expanded(child: Text("${res.memberName}")),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        res.responseText!,
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setNavbar!(true);

                  var questionsTextScale,
                      questionsTextRotation,
                      questionsTextPosX,
                      questionsTextPosY,
                      questionsTextData = "";
                  bool isquestionsTextViewOn = false;
                  if (questionsText != null && questionsText != "") {
                    var slitedData = questionsText!.split("^^");
                    if (slitedData.length == 5) {
                      questionsTextData =
                          questionsText!.split("^^")[0].replaceAll("@@@", "");
                    }
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateStory(
                                setNavbar: setNavbar!,
                                questionsTextData:
                                    "$questionsTextData~~${res.responseText}",
                                whereFrom: "StoryReply",
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.black,
                  child: Row(
                    children: [
                      Text(
                        "Reply",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResponsesAnswers extends StatefulWidget {
  List<ResponseList>? res;
  ResponsesAnswers({Key? key, this.res}) : super(key: key);

  @override
  _ResponsesAnswersState createState() => _ResponsesAnswersState();
}

class _ResponsesAnswersState extends State<ResponsesAnswers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Responses"),
        backgroundColor: Colors.black,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
            widget.res!.length,
            (index) => QuestionAnswerBox(
                  res: widget.res![index],
                )),
      ),
    );
  }
}

class ResponsesData {
  String? storyId;
  StoryData? storyData;
  List<ResponseList>? responseList;

  ResponsesData({this.storyId, this.storyData, this.responseList});

  ResponsesData.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'];
    storyData = json['story_data'] != null
        ? new StoryData.fromJson(json['story_data'][0])
        : null;
    responseList = <ResponseList>[];
    json['data'].forEach((v) {
      print('get all responsedaata=$v');
      responseList!.add(new ResponseList.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['story_id'] = this.storyId;
    if (this.storyData != null) {
      data['story_data'] = this.storyData!.toJson();
    }
    if (this.responseList != null) {
      data['response_list'] =
          this.responseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoryData {
  String? image;
  int? video;
  String? link;
  int? videoPlay;
  int? viewStatus;
  int? count;
  int? storyId;
  String? watchedUserImage;
  String? id;
  String? timeStamp;
  bool? fromFeed;
  List<PostParameters>? postParameters;
  String? assetImageData;
  String? timeView;
  String? hashtag;
  String? mantion;
  String? locationtext;
  String? questions;
  String? responseText;
  String? storytype;
  String? backgroundColors;
  String? taggedPerson;
  List<String>? position;
  List<String>? stickers;

  StoryData(
      {this.image,
      this.video,
      this.link,
      this.videoPlay,
      this.viewStatus,
      this.count,
      this.storyId,
      this.watchedUserImage,
      this.id,
      this.timeStamp,
      this.fromFeed,
      this.postParameters,
      this.assetImageData,
      this.timeView,
      this.hashtag,
      this.mantion,
      this.locationtext,
      this.questions,
      this.responseText,
      this.storytype,
      this.backgroundColors,
      this.taggedPerson,
      this.position,
      this.stickers});

  StoryData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    video = json['video'];
    link = json['link'];
    videoPlay = json['video_play'];
    viewStatus = json['view_status'];
    count = json['count'];
    storyId = json['story_id'];
    watchedUserImage = json['watched_user_image'];
    id = json['id'];
    timeStamp = json['time_stamp'];
    fromFeed = json['from_feed'];
    if (json['post_parameters'] != null) {
      postParameters = <PostParameters>[];
      json['post_parameters'].forEach((v) {
        postParameters!.add(new PostParameters.fromJson(v));
      });
    }
    assetImageData = json['assetImageData'];
    timeView = json['timeView'];
    hashtag = json['hashtag'];
    mantion = json['mantion'];
    locationtext = json['locationtext'];
    questions = json['questions'];
    responseText = json['response_text'];
    storytype = json['storytype'];
    backgroundColors = json['background_colors'];
    taggedPerson = json['tagged_person'];
    position = json['position'].cast<String>();
    stickers = json['stickers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['video'] = this.video;
    data['link'] = this.link;
    data['video_play'] = this.videoPlay;
    data['view_status'] = this.viewStatus;
    data['count'] = this.count;
    data['story_id'] = this.storyId;
    data['watched_user_image'] = this.watchedUserImage;
    data['id'] = this.id;
    data['time_stamp'] = this.timeStamp;
    data['from_feed'] = this.fromFeed;
    if (this.postParameters != null) {
      data['post_parameters'] =
          this.postParameters!.map((v) => v.toJson()).toList();
    }
    data['assetImageData'] = this.assetImageData;
    data['timeView'] = this.timeView;
    data['hashtag'] = this.hashtag;
    data['mantion'] = this.mantion;
    data['locationtext'] = this.locationtext;
    data['questions'] = this.questions;
    data['response_text'] = this.responseText;
    data['storytype'] = this.storytype;
    data['background_colors'] = this.backgroundColors;
    data['tagged_person'] = this.taggedPerson;
    data['position'] = this.position;
    data['stickers'] = this.stickers;
    return data;
  }
}

class PostParameters {
  String? postId;
  String? memberId;
  String? thumbnailUrl;
  String? userImage;
  String? userName;
  String? shortcode;
  String? description;
  String? blogTitle;
  String? message;
  bool? isMultiple;
  String? color;

  PostParameters(
      {this.postId,
      this.memberId,
      this.thumbnailUrl,
      this.userImage,
      this.userName,
      this.shortcode,
      this.description,
      this.blogTitle,
      this.message,
      this.isMultiple,
      this.color});

  PostParameters.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    memberId = json['user_id'];
    thumbnailUrl = json['thumbnail_url'];
    userImage = json['user_image'];
    userName = json['user_name'];
    shortcode = json['shortcode'];
    description = json['description'];
    blogTitle = json['blog_title'];
    message = json['message'];
    isMultiple = json['isMultiple'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.memberId;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['user_image'] = this.userImage;
    data['user_name'] = this.userName;
    data['shortcode'] = this.shortcode;
    data['description'] = this.description;
    data['blog_title'] = this.blogTitle;
    data['message'] = this.message;
    data['isMultiple'] = this.isMultiple;
    data['color'] = this.color;
    return data;
  }
}

class ResponseList {
  String? memberId;
  String? memberName;
  String? memberEmail;
  String? shortcode;
  String? imageLink;
  String? responseText;
  String? createdAt;
  String? responseId;

  ResponseList(
      {this.memberId,
      this.memberName,
      this.responseId,
      this.memberEmail,
      this.shortcode,
      this.imageLink,
      this.responseText,
      this.createdAt});

  ResponseList.fromJson(Map<String, dynamic> json) {
    memberId = json['user_id'];
    responseId = json['response_id'];
    memberName = json['user_name'];
    memberEmail = json['member_email'];
    shortcode = json['shortcode'];
    imageLink = json['image'];
    responseText = json['response'];
    createdAt = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.memberId;
    data['response_id'] = this.responseId;
    data['user_name'] = this.memberName;
    data['member_email'] = this.memberEmail;
    data['shortcode'] = this.shortcode;
    data['image'] = this.imageLink;
    data['response'] = this.responseText;
    data['created'] = this.createdAt;
    return data;
  }
}
