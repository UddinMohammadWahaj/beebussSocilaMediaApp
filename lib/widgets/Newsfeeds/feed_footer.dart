import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/expanded_feed.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:rich_text_view/rich_text_view.dart' as rt;
import 'package:sizer/sizer.dart';

import 'feed_body.dart';

// ignore: must_be_immutable
class FeedFooter extends StatefulWidget {
  final List<Sticker>? stickerList;
  final List<Position>? positionList;
  final NewsFeedModel? feed;
  final VoidCallback? viewComments;
  final VoidCallback? sharePost;
  final TextEditingController? commentController;
  final VoidCallback? onPressedLikeButton;
  final VoidCallback? onPressedCommentButton;
  final VoidCallback? postComment;
  final VoidCallback? promotePost;
  final ValueChanged<String>? onPressMatchText;
  bool? showEmoji = false;
  final GlobalKey<ScaffoldState>? sKey;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  FeedFooter(
      {Key? key,
      this.onPressedLikeButton,
      this.onPressedCommentButton,
      this.onPressMatchText,
      this.commentController,
      this.postComment,
      this.showEmoji,
      this.sharePost,
      this.viewComments,
      this.promotePost,
      this.feed,
      this.sKey,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.stickerList,
      this.positionList})
      : super(key: key);

  @override
  _FeedFooterState createState() => _FeedFooterState();
}

class _FeedFooterState extends State<FeedFooter> {
  String emoji1 = "😥";
  String emoji2 = "😂";
  String emoji3 = "🔥";
  String emoji4 = "❤";
  String emoji5 = "🙌";
  String emoji6 = "👏";
  String emoji7 = "😍";
  String emoji8 = "😮";

  String hintText = " Add a comment...";
  bool? showMore;
  bool? showMoreRebuz;
  UserTags? tagList;
  bool areTagsLoaded = false;
  Future<void> getUserTags(String searchedTag) async {
    var url =
        "https://www.bebuzee.com/api/user/userSearchFollowers?user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag";

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

  Future<void> postComment(
      String postType, String postID, String comment) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=post_comment_main&user_id=${CurrentUser().currentUser.memberID}&post_type=$postType=&post_id=$postID&comments=$comment");
    var token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    // var newurl = 'https://www.bebuzee.com/api/newsfeed/postCommentAdd';
    var newurl = 'https://www.bebuzee.com/api/newsfeed/postCommentAdd';
    var client = Dio();
    var newToken = await ApiProvider().newRefreshToken();
    await client
        .post(
      newurl,
      queryParameters: {
        "user_id": CurrentUser().currentUser.memberID,
        "post_type": postType,
        "post_id": postID,
        "comments": comment
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $newToken',
        },
      ),
    )
        .then((value) async {
      print("posted comment");

      if (value.statusCode == 200) {
        print(
            "post comment url=${newurl}  response=${value.data} ${postID} ${comment}");
        print("commented success");
        print("posted comment succ");
      }
    });

    // var response = await http.get(url);

    // if (response.statusCode == 200) {}
  }

  Widget _emojiButton(String emoji) {
    return GestureDetector(
        onTap: () {
          widget.feed!.commentController.text =
              widget.feed!.commentController.text + emoji + " ";
          widget.feed!.commentController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.feed!.commentController.text.length));
        },
        child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                emoji,
                style: TextStyle(fontSize: 20),
              ),
            )));
  }

  RefreshPostContent refresh = new RefreshPostContent();

  @override
  void initState() {
    showMore = widget.feed!.postContent!.length > 80 ? false : null;
    showMoreRebuz = widget.feed!.postContent!.length > 80 ? false : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        initialData: refresh.currentSelect,
        stream: refresh.observableCart,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            refresh.updatePost(false);
          }
          

          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FeedBody(
                  stickerList: widget.stickerList,
                  positionList: widget.positionList,
                  sKey: widget.sKey,
                  feed: widget.feed,
                  setNavBar: widget.setNavBar,
                  isChannelOpen: widget.isChannelOpen,
                  changeColor: widget.changeColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.feed!.postRebuzData != ""
                          ? Container(
                              width: _currentScreenSize.width * 0.9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      Text(
                                        widget.feed!.postShortcode! + " ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ParsedText(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        text: widget.feed!.postRebuzData!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        parse: <MatchText>[
                                          MatchText(
                                              onTap: widget.onPressMatchText ??
                                                  (value) {},
                                              pattern: "\w*(?= )",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          MatchText(
                                              onTap: (value) {
                                                print("test click 1");
                                                setState(() {
                                                  OtherUser()
                                                          .otherUser
                                                          .memberID =
                                                      value
                                                          .toString()
                                                          .replaceAll("@", "");
                                                  OtherUser()
                                                          .otherUser
                                                          .shortcode =
                                                      value
                                                          .toString()
                                                          .replaceAll("@", "");
                                                });
                                                print(
                                                    "value=${value.toString().replaceAll("@", "")}");
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePageMain(
                                                              from: "tags",
                                                              setNavBar: widget
                                                                  .setNavBar!,
                                                              isChannelOpen: widget
                                                                  .isChannelOpen!,
                                                              changeColor: widget
                                                                  .changeColor!,
                                                              otherMemberID: value
                                                                  .toString()
                                                                  .replaceAll(
                                                                      "@", ""),
                                                            )));
                                              },
                                              pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                                              style: TextStyle(
                                                  color: feedColor,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          MatchText(
                                              onTap: widget.onPressMatchText ??
                                                  (value) {},
                                              pattern: "(#+[a-zA-Z0-9(_)]{1,})",
                                              style: TextStyle(
                                                  color: feedColor,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: _currentScreenSize.width * 0.9,
                                    // height: _currentScreenSize.height * 0.06,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ParsedText(
                                          style: TextStyle(color: Colors.black),
                                          text: showMoreRebuz == null
                                              ? parse(widget.feed!.postContent)
                                                  .documentElement!
                                                  .text
                                              : showMoreRebuz == true
                                                  ? parse(widget
                                                          .feed!.postContent)
                                                      .documentElement!
                                                      .text
                                                  : parse(widget.feed!
                                                              .postContent)
                                                          .documentElement!
                                                          .text
                                                          .characters
                                                          .skipLast(widget
                                                                  .feed!
                                                                  .postContent!
                                                                  .length -
                                                              80)
                                                          .toString() +
                                                      " ...",
                                          parse: <MatchText>[
                                            MatchText(
                                                onTap: (value) {
                                                  print("test click 2");
                                                  setState(() {
                                                    OtherUser()
                                                            .otherUser
                                                            .memberID =
                                                        value
                                                            .toString()
                                                            .replaceAll(
                                                                "@", "");
                                                    OtherUser()
                                                            .otherUser
                                                            .shortcode =
                                                        value
                                                            .toString()
                                                            .replaceAll(
                                                                "@", "");
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfilePageMain(
                                                                from: "tags",
                                                                setNavBar: widget
                                                                    .setNavBar!,
                                                                isChannelOpen:
                                                                    widget
                                                                        .isChannelOpen!,
                                                                changeColor: widget
                                                                    .changeColor!,
                                                                otherMemberID: value
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "@",
                                                                        ""),
                                                              )));
                                                },
                                                pattern:
                                                    "(@+[a-zA-Z0-9(_)]{1,})",
                                                style: TextStyle(
                                                    color: feedColor,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            MatchText(
                                                onTap:
                                                    widget.onPressMatchText ??
                                                        (value) {},
                                                pattern:
                                                    "(#+[a-zA-Z0-9(_)]{1,})",
                                                style: TextStyle(
                                                    color: feedColor,
                                                    fontWeight:
                                                        FontWeight.normal))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.feed!.postContent!.length > 80
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showMoreRebuz = !showMoreRebuz!;
                                            });
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                showMoreRebuz == null
                                                    ? ""
                                                    : showMoreRebuz == true
                                                        ? AppLocalizations.of(
                                                            "less")
                                                        : AppLocalizations.of(
                                                            "more"),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )
                          : widget.feed!.postType != "blog"
                              ? Container(
                                  color: Colors.transparent,
                                  width: _currentScreenSize.width * 0.9,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(
                                        widget.feed!.postShortcode! + " ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      rt.RichTextView(
                                        selectable: false,
                                        linkStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: feedColor,
                                        ),
                                        boldStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black),
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        text: widget.feed!.postContent,
                                        maxLines: 3,
                                        align: TextAlign.left,
                                        onEmailClicked: (email) =>
                                            print('$email clicked'),
                                        onHashTagClicked:
                                            widget.onPressMatchText ??
                                                (value) {},
                                        onMentionClicked: (value) {
                                          setState(() {
                                            OtherUser().otherUser.memberID =
                                                value
                                                    .toString()
                                                    .replaceAll("@", "");
                                            OtherUser().otherUser.shortcode =
                                                value
                                                    .toString()
                                                    .replaceAll("@", "");
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePageMain(
                                                        from: "tags",
                                                        setNavBar:
                                                            widget.setNavBar!,
                                                        isChannelOpen: widget
                                                            .isChannelOpen!,
                                                        changeColor:
                                                            widget.changeColor!,
                                                        otherMemberID: value
                                                            .toString()
                                                            .replaceAll(
                                                                "@", ""),
                                                      )));
                                        },
                                        onUrlClicked: (url) =>
                                            print('visiting $url?'),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                    ],
                  ),
                ),
                widget.feed!.postTotalComments! > 0
                    ? GestureDetector(
                        onTap: () {
                          print("tapped comm");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExpandedFeed(
                                        setNavBar: widget.setNavBar!,
                                        isChannelOpen: widget.isChannelOpen!,
                                        changeColor: widget.changeColor!,
                                        feed: widget.feed!,
                                        logo: CurrentUser().currentUser.logo,
                                        country:
                                            CurrentUser().currentUser.country,
                                        memberID:
                                            CurrentUser().currentUser.memberID,
                                        currentMemberImage:
                                            CurrentUser().currentUser.image,
                                        currentMemberShortcode:
                                            CurrentUser().currentUser.shortcode,
                                      )));
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 6),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of("View all comments"),
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.start,
                                )),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(widget.feed!.timeStamp!),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                widget.feed!.postCommentResult == "Turn Off Commenting"
                    ? Column(
                        children: [
                          tagList != null && tagList!.userTags.length > 0
                              ? Container(
                                  height: 50.0.h,
                                  child: SingleChildScrollView(
                                    child: Column(
                                        children: tagList!.userTags.map((s) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 0.8.h),
                                        child: InkWell(
                                          splashColor:
                                              Colors.grey.withOpacity(0.3),
                                          onTap: () {
                                            String? str;
                                            widget.feed!.commentController.text
                                                .split(" ")
                                                .forEach((element) {
                                              if (element.startsWith("@")) {
                                                str = element;
                                              }
                                            });
                                            String data = widget
                                                .feed!.commentController.text;
                                            data = widget
                                                .feed!.commentController.text
                                                .substring(
                                                    0,
                                                    data.length -
                                                        str!.length +
                                                        1);
                                            data += s.shortcode!;
                                            data += " ";
                                            setState(() {
                                              widget.feed!.commentController
                                                  .text = data;
                                              tagList!.userTags = [];
                                            });
                                            widget.feed!.commentController
                                                    .selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset: widget
                                                            .feed!
                                                            .commentController
                                                            .text
                                                            .length));
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
                                                    backgroundColor:
                                                        Colors.transparent,
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
                                                                            10.0
                                                                                .sp,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        1.0.w,
                                                                  ),
                                                                  s.varifiedStatus ==
                                                                          1
                                                                      ? Image
                                                                          .network(
                                                                          s.varifiedImage!,
                                                                          height:
                                                                              13,
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
                                                        AppLocalizations.of(
                                                            s.shortcode!),
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 10.0.sp),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                          widget.showEmoji == true
                              ? Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _emojiButton(emoji1),
                                      _emojiButton(emoji2),
                                      _emojiButton(emoji3),
                                      _emojiButton(emoji4),
                                      _emojiButton(emoji5),
                                      _emojiButton(emoji6),
                                      _emojiButton(emoji7),
                                      _emojiButton(emoji8),
                                    ],
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: widget.showEmoji == true ? 0 : 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 5),
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
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  CurrentUser()
                                                      .currentUser
                                                      .image!),
                                        )),
                                  ),
                                ),
                                Container(
                                  // color: Colors.yellow,
                                  width: _currentScreenSize.width * 0.70 - 20,
                                  child: TextFormField(
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
                                            tagList!.userTags = [];
                                          });
                                        }
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        widget.showEmoji = true;

                                        hintText =
                                            AppLocalizations.of("Comment as ") +
                                                CurrentUser()
                                                    .currentUser
                                                    .shortcode!;
                                      });
                                    },
                                    maxLines: 2,
                                    controller: widget.feed!.commentController,
                                    keyboardType: TextInputType.text,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,

                                      hintText: AppLocalizations.of(hintText),
                                      // 48 -> icon width
                                    ),
                                  ),
                                ),
                                Container(
                                  // color: Colors.pink,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(top: 13),
                                  width: _currentScreenSize.width * 0.2,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("tapatap");

                                      print("comment called post new");
                                      postComment(
                                          widget.feed!.postType,
                                          widget.feed!.postId!,
                                          widget.feed!.commentController.text);

                                      widget.feed!.commentController.clear();
                                      setState(() {
                                        tagList!.userTags = [];
                                      });
                                    },
                                    child: Text(
                                      AppLocalizations.of("Comment"),
                                      style: TextStyle(color: primaryBlueColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
        });
  }
}
