import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/expanded_user_tags_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_body_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/simple_web_view.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/expanded_feed.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/Newsfeeds/user_tags_bottom_tile.dart';
import 'package:bizbultest/widgets/feed_single_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import 'feed_body_footer.dart';
import 'feeds_menu_otherMember.dart';

class FeedBody extends StatefulWidget {
  final NewsFeedModel? feed;
  final GlobalKey<ScaffoldState>? sKey;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final List<Sticker>? stickerList;
  final List<Position>? positionList;

  const FeedBody(
      {Key? key,
      this.feed,
      this.sKey,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.stickerList,
      this.positionList})
      : super(key: key);

  @override
  _FeedBodyState createState() => _FeedBodyState();
}

class _FeedBodyState extends State<FeedBody> {
  var image;
  TaggedUsers? usersList;
  bool? areUsersLoaded = false;
  TaggedUsers? videoTagsList;
  bool videoTagsLoaded = false;
  var followStatus;
  Future<TaggedUsers>? _taggedUsersImage;
  Future<TaggedUsers>? _taggedUsersVideo;

  Future<void>? likeUnlike(String postType, String postID) async {
    print(postType);
    print(postID);
    print("called post like unlike $postID");
    var newUrl = Uri.parse(
        'https://www.bebuzee.com/api/newsfeed/postLikeUnlike?user_id=${CurrentUser().currentUser.memberID}&post_type=$postType&post_id=$postID');

    // String newToken = await ApiProvider().newRefreshToken();

    var url = Uri.parse(
        "https://www.bebuzee.com/api/newsfeed/postLikeUnlike?action=post_like_data&user_id=${CurrentUser().currentUser.memberID}&post_type=$postType&post_id=$postID");
    print("called po ${newUrl}");
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    String newToken = await ApiProvider().newRefreshToken();
    try {
      await client
          .postUri(
        newUrl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $newToken',
        }),
      )
          .then((value) {
        print('like unlike ${value.data}');
        if (value.statusCode == 200) {
          setState(() {
            widget.feed!.postLikeIcon = value.data['data']['image_data'];
            widget.feed!.postTotalLikes =
                value.data['data']['total_likes'].toString() + ' Likes';
          });
          print(value.data['data']['total_likes']);
        } else {}
      });
    } catch (e) {
      print("like unlike error=$e");
    }
    // var response = await http.get(url);

    // if (response.statusCode == 200) {
    //   setState(() {
    //     widget.feed.postLikeIcon = jsonDecode(response.body)['image_data'];
    //     widget.feed.postTotalLikes = jsonDecode(response.body)['total_likes'];
    //   });
    //   print(jsonDecode(response.body)['total_likes']);
    // }
  }

  Future<void> postRebuzz(String postType, String postID) async {
    var newurl =
        'https://www.bebuzee.com/api/post_rebuzz.php?post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}';

    print('aa url rebuz= ${newurl}');
    var response = await ApiProvider().fireApi(newurl);
    print("rebuz response =${response.data}");
    if (response.statusCode == 200) {}
  }

  Future<String> followUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");
    var response = await http.get(url);
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

    if (response.statusCode == 200) {
      setState(() {
        followStatus = jsonDecode(response.body)['return_val'];
      });
    }

    return "success";
  }

  Map<String, List<Widget>> getMultipleTags() {
    Map<String, List<Widget>> tagsWidgets = new Map<String, List<Widget>>();
    print("----------111 ${widget.feed!.postTaggedDataDetails}");
    if (widget.feed!.postTaggedDataDetails != "" &&
        widget.feed!.postTaggedDataDetails != null) {
      print("----------111 ${widget.feed!.postTaggedDataDetails}");
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
                child: InkWell(
                  onTap: () {
                    setState(() {
                      OtherUser().otherUser.memberID = element.split("^^")[3];
                      OtherUser().otherUser.shortcode = element.split("^^")[3];
                    });
                    print("--------element slplit=${element.split("^^")[3]} ");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePageMain(
                                  from: "tags",
                                  setNavBar: widget.setNavBar!,
                                  isChannelOpen: widget.isChannelOpen!,
                                  changeColor: widget.changeColor!,
                                  otherMemberID: element.split("^^")[3],
                                )));
                  },
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
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              OtherUser().otherUser.memberID =
                                  element.split("^^")[3];
                              OtherUser().otherUser.shortcode =
                                  element.split("^^")[3];
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePageMain(
                                          from: "tags",
                                          setNavBar: widget.setNavBar!,
                                          isChannelOpen: widget.isChannelOpen!,
                                          changeColor: widget.changeColor!,
                                          otherMemberID: element.split("^^")[3],
                                        )));
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
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

  List<Widget> getTaggedUsersIndex({index: 0}) {
    List<Widget> tags = [];
    print(
        "domain= ${CurrentUser().currentUser.memberID} ${widget.feed!.postMultiImage}");

    tags.add(Container(
        color: Colors.grey.withOpacity(0.2),
        child: Image(
          image: CachedNetworkImageProvider(
            widget.feed!.postMultiImage == 1
                ? widget.feed!.postImgData!.split("~~")[index]
                : widget.feed!.postImgData!,
          ),
        )));

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
    if (widget.feed!.postTaggedDataDetails != "" &&
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
                  child: InkWell(
                    onTap: () {
                      print("element split  ${e} split=${e.split("^^")[3]}");
                      setState(() {
                        OtherUser().otherUser.memberID = e.split("^^")[3];
                        OtherUser().otherUser.shortcode = e.split("^^")[3];
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePageMain(
                                    from: "tags",
                                    setNavBar: widget.setNavBar!,
                                    isChannelOpen: widget.isChannelOpen!,
                                    changeColor: widget.changeColor!,
                                    otherMemberID: e.split("^^")[3],
                                  )));
                    },
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
                        )),
                  ))),
        ));
      });
    }

    tags.add(widget.feed!.postTaggedDataDetails != ""
        ? Positioned.fill(
            bottom: 7,
            left: 10,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () {
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
                              child: widget.feed!.postTaggedDataDetails != ""
                                  ? _buildTaggedUsersCard(
                                      stateSetter, _taggedUsersImage!)
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
                          height: 1.6.h,
                        ),
                      )),
                )),
          )
        : Container());

    tags.add(widget.feed!.postDomainName != ""
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
                      print("tapped domain");
                      print(widget.feed!.postUrlNam);
                      print(widget.feed!.postId);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SimpleWebView(
                                    url: widget.feed!.postUrlNam!,
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

  Widget _buildTaggedUsersCard(
      StateSetter stateSetter, Future<TaggedUsers> future) {
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot<TaggedUsers> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.users.length,
                itemBuilder: (context, index) {
                  var user = snapshot.data!.users[index]!;

                  return TaggedUsersBottomTile(
                    index: index,
                    user: user,
                    goToProfile: () {
                      setState(() {
                        OtherUser().otherUser.memberID = user.memberId;
                        OtherUser().otherUser.shortcode = user.shortcode;
                      });
                      print("clicked on goto profile");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePageMain(
                                    setNavBar: widget.setNavBar!,
                                    isChannelOpen: widget.isChannelOpen!,
                                    changeColor: widget.changeColor!,
                                    otherMemberID: user.memberId,
                                  )));
                    },
                    onTap: () {
                      if (user.followData == "Follow") {
                        // if (user.toString().isEmpty == "Follow") {}
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
                });
          } else {
            return Container();
          }
        });
  }

  @override
  void initState() {
    if (widget.feed!.postPromotedSlider != null) {}
    if (widget.feed!.postTaggedDataDetails != "") {
      _taggedUsersImage =
          FeedBodyApiCalls.getTaggedUsersImage(widget.feed!.postId!)
              as Future<TaggedUsers>?;
    }

    if (widget.feed!.videoTag == 1) {
      _taggedUsersVideo =
          FeedBodyApiCalls.getTaggedUsersVideo(widget.feed!.postId!)
              as Future<TaggedUsers>?;
    }

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

    super.initState();
  }

  List<String> postviudeo = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  ];
  Widget multiplevideo() {
    print("----imaheurl -- - ${widget.feed!.postsmlImgData}");
    return Container(
        height: 50.h,
        width: MediaQuery.of(context).size.width,
        child: PreloadPageView.builder(
            preloadPagesCount: 1,
            scrollDirection: Axis.horizontal,
            onPageChanged: (val) {
              setState(() {
                // print("--- $val");

                widget.feed!.pageIndex = val;
              });
            },
            itemCount: widget.feed!.postImgData!.split("~~").length,
            itemBuilder: (context, indexVideo) {
              return Stack(alignment: Alignment.bottomRight, children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                      alignment: Alignment.center,
                      child: widget.feed!.postImgData!
                                  .split("~~")[indexVideo]
                                  .endsWith("jpg") ||
                              widget.feed!.postImgData!
                                  .split("~~")[indexVideo]
                                  .endsWith("png")
                          // (widget.feed.postImgData
                          //             .split('~~')[indexVideo]
                          //             .endsWith(".mp4") ||
                          //         widget.feed.postImgData
                          //             .split('~~')[indexImage]
                          //             .endsWith(".m3u8"))
                          //     ? FeedsSingleVideoPlayer(
                          //         image: widget.feed.postImgData

                          //             .split('~~')[indexVideo]
                          //             .replaceAll(".mp4", ".jpg")
                          //             .replaceAll("/compressed", ""),
                          //         url: widget.feed.postImgData
                          //             .split('~~')[indexVideo],
                          //       )
                          // :
                          ? SingleImageCard(
                              feed: widget.feed!,
                              stack: getTaggedUsersIndex(index: indexVideo),
                              onTap: () {
                                print("tapped");
                                setState(() {
                                  widget.feed!.showUserTags = true;
                                });

                                Timer(Duration(seconds: 2), () {
                                  setState(() {
                                    widget.feed!.showUserTags = false;
                                  });
                                });
                              },
                              onDoubleTap: () {
                                print(
                                    "aha ${widget.feed!.postDomainName!.isNotEmpty}");
                                print("aha");
                                if (widget.feed!.postLikeIcon !=
                                    "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                                  likeUnlike(widget.feed!.postType,
                                      widget.feed!.postId!);

                                  setState(() {
                                    widget.feed!.whiteHeartLogo = true;
                                    widget.feed!.isLiked = true;
                                  });
                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      widget.feed!.whiteHeartLogo = false;
                                    });
                                  });
                                }
                              },
                            )

                          // Container(
                          //     height: 55.h,
                          //     width: MediaQuery.of(context).size.width,
                          //     child: Image(
                          //         image: CachedNetworkImageProvider(widget
                          //             .feed.postImgData
                          //             .split("~~")[indexVideo]),
                          //         fit: BoxFit.contain))

                          : FeedBodyVideo(
                              stickerList: widget.stickerList,
                              positionList: widget.positionList,
                              feed: widget.feed,
                              demoList: postviudeo,
                              url: widget.feed!.postImgData!
                                  .split("~~")[indexVideo],
                              feedindex: indexVideo,
                              doubleTap: () {
                                if (widget.feed!.postLikeIcon !=
                                    "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                                  likeUnlike(widget.feed!.postType,
                                      widget.feed!.postId!);
                                  setState(() {
                                    widget.feed!.whiteHeartLogo = true;
                                    widget.feed!.isLiked = true;
                                  });
                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      widget.feed!.whiteHeartLogo = false;
                                    });
                                  });
                                }
                              },
                              tagTap: () {
                                print(
                                    "-------_tagndhgedUsersVideo ${widget.feed!.postTaggedData}");
                                showMaterialModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0))),
                                    //isScrollControlled:true,
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter stateSetter) {
                                        return Container(
                                            height: 50.h,
                                            width: 70.w,
                                            child: _buildTaggedUsersCard(
                                                stateSetter,
                                                _taggedUsersImage!));
                                      });
                                    });
                              },
                            )),
                ),
                widget.feed!.postImgData!.split("~~").length == 1
                    ? Container()
                    : Positioned.fill(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding:
                                    EdgeInsets.only(top: 1.0.h, right: 1.5.w),
                                child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0.w, vertical: 1.0.w),
                                      child: Text(
                                        // "data",
                                        (widget.feed!.pageIndex! + 1)
                                                .toString() +
                                            "/" +
                                            widget.feed!.postImgData!
                                                .split("~~")
                                                .length
                                                .toString(),
                                        // widget.feed.postVideoData
                                        //     .split("~~")
                                        //     .length
                                        //     .toString(),
                                        style: whiteNormal.copyWith(
                                            fontSize: 10.0.sp),
                                      ),
                                    )))),
                      ),
                widget.feed!.postImgData!.split("~~").length == 1
                    ? Container()
                    : Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.feed!.postImgData!
                                  .split("~~")
                                  .map((e) {
                                var ind = widget.feed!.postImgData!
                                    .split("~~")
                                    .indexOf(e);
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor:
                                        widget.feed!.pageIndex == ind
                                            ? Colors.black
                                            : Colors.grey.withOpacity(0.6),
                                  ),
                                );
                              }).toList()),
                        ),
                      ),
              ]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "---------${widget.feed.postContent} ---- " + widget.feed.postImgData);
    print("---------${widget.feed!.postType}");
    final _currentScreenSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.feed!.postMultiImage == 1 &&
                  widget.feed!.postType != "feed_post"
              ? GestureDetector(
            onDoubleTap: () {
              if (widget.feed!.postLikeIcon !=
                  "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                likeUnlike(widget.feed!.postType, widget.feed!.postId!);
                setState(() {
                  widget.feed!.whiteHeartLogo = true;
                  widget.feed!.isLiked = true;
                });
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    widget.feed!.whiteHeartLogo = false;
                  });
                });
              }
            },
            child: Container(
              height: 50.0.h,
              width: MediaQuery.of(context).size.width,
              child: PreloadPageView.builder(
                preloadPagesCount: 2,
                scrollDirection: Axis.horizontal,
                onPageChanged: (val) {
                  setState(() {
                    widget.feed!.pageIndex = val;
                  });
                },
                itemCount: widget.feed!.postImgData!.split("~~").length,
                itemBuilder: (context, indexImage) {
                  return Stack(
                    children: [
                      //  (widget.feed.postImgData
                      //             .split('~~')[indexImage]
                      //             .endsWith(".mp4") ||
                      //         widget.feed.postImgData
                      //             .split('~~')[indexImage]
                      //             .endsWith(".m3u8"))
                      //     ? FeedsSingleVideoPlayer(
                      //         image: widget.feed.postImgData

                      //             .split('~~')[indexImage]
                      //             .replaceAll(".mp4", ".jpg")
                      //             .replaceAll("/compressed", ""),
                      //         url: widget.feed.postImgData
                      //             .split('~~')[indexImage],
                      //       )
                      // :
                      Container(
                          height: 50.0.h,
                          width: MediaQuery.of(context).size.width,
                          child:
                          //  widget.feed.cropped == 1
                          //     ? Image(
                          //         image: CachedNetworkImageProvider(
                          //             widget.feed.postsmlImgData
                          //                 .split("~~")[indexImage]),
                          //         fit: BoxFit.cover)
                          // :
                          // Image(
                          //     image: CachedNetworkImageProvider(widget
                          //         .feed!.postImgData!
                          //         .split("~~")[indexImage]),
                          //     fit: BoxFit.contain),
                        CachedNetworkImage(
                          imageUrl: widget.feed!.postImgData!.split("~~")[indexImage],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter:
                                  ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                            ),
                          ),
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),

                      ),
                      // ),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 1.0.h, right: 1.5.w),
                                child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0.w,
                                          vertical: 1.0.w),
                                      child: Text(
                                        (widget.feed!.pageIndex! + 1)
                                            .toString() +
                                            "/" +
                                            widget.feed!.postImgData!
                                                .split("~~")
                                                .length
                                                .toString(),
                                        style: whiteNormal.copyWith(
                                            fontSize: 10.0.sp),
                                      ),
                                    )))),
                      ),
                      widget.feed!.postTaggedDataDetails != "" &&
                          (!widget.feed!.postImgData!
                              .split('~~')[indexImage]
                              .endsWith(".mp4") ||
                              !widget.feed!.postImgData!
                                  .split('~~')[indexImage]
                                  .endsWith(".m3u8"))
                          ? Stack(
                        children: getMultipleTags()[
                        (indexImage + 1).toString()] !=
                            null
                            ? getMultipleTags()[
                        (indexImage + 1).toString()]!
                            : [Container()],
                      )
                          : Container(),
                      widget.feed!.postTaggedDataDetails != "" &&
                          (!widget.feed!.postImgData!
                              .split('~~')[indexImage]
                              .endsWith(".mp4") ||
                              !widget.feed!.postImgData!
                                  .split('~~')[indexImage]
                                  .endsWith(".m3u8"))
                          ? Positioned.fill(
                        bottom: 1.5.w,
                        left: 1.5.w,
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () {
                                showMaterialModalBottomSheet(
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
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context,
                                              StateSetter
                                              stateSetter) {
                                            return Container(
                                              child: widget.feed!
                                                  .postTaggedDataDetails !=
                                                  ""
                                                  ? _buildTaggedUsersCard(
                                                  stateSetter,
                                                  _taggedUsersImage!)
                                                  : Container(),
                                            );
                                          });
                                    });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 3.0.h, top: 3.0.h),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        border: new Border.all(
                                          width: 0.1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            8.0),
                                        child: Image.asset(
                                          "assets/images/tag.png",
                                          height: 1.6.h,
                                        ),
                                      )),
                                ),
                              ),
                            )),
                      )
                          : Container(),
                      widget.feed!.videoTag == 1 &&
                          (widget.feed!.postImgData!
                              .split('~~')[indexImage]
                              .endsWith(".mp4") ||
                              widget.feed!.postImgData!
                                  .split('~~')[indexImage]
                                  .endsWith(".m3u8"))
                          ? Positioned.fill(
                        bottom: 1.5.w,
                        left: 1.5.w,
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () {
                                showMaterialModalBottomSheet(
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
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context,
                                              StateSetter
                                              stateSetter) {
                                            return Container(
                                                child: _buildTaggedUsersCard(
                                                    stateSetter,
                                                    _taggedUsersVideo!));
                                          });
                                    });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 3.0.h, top: 3.0.h),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        border: new Border.all(
                                          width: 0.1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            8.0),
                                        child: Image.asset(
                                          "assets/images/tag.png",
                                          height: 1.6.h,
                                        ),
                                      )),
                                ),
                              ),
                            )),
                      )
                          : Container(),
                      widget.feed!.postDomainName != "" &&
                          widget.feed!.postDomainName != null
                          ? Positioned.fill(
                        bottom: _currentScreenSize.height * 0.065,
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
                                          builder: (context) =>
                                              WebsiteView(
                                                  url: widget.feed!
                                                      .postUrlNam,
                                                  heading: "")));
                                },
                                child: Container(
                                  color: Colors.grey[800],
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons
                                              .arrow_forward_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        Text(
                                          AppLocalizations.of(widget
                                              .feed!
                                              .postDomainName!),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.bold),
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
                      widget.feed!.whiteHeartLogo == true
                          ? Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/white_heart.png",
                              height: 100,
                            )),
                      )
                          : Container(),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.feed!.postImgData!
                                  .split("~~")
                                  .map((e) {
                                var ind = widget.feed!.postImgData!
                                    .split("~~")
                                    .indexOf(e);
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor:
                                    widget.feed!.pageIndex == ind
                                        ? Colors.black
                                        : Colors.grey
                                        .withOpacity(0.6),
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
                  ? Container(
                      height: 55.h,
                      width: MediaQuery.of(context).size.width,
                      child: FeedBodyVideo(
                        stickerList: widget.stickerList,
                        positionList: widget.positionList,
                        feed: widget.feed,
                        feedindex: 0,
                        url: widget.feed!.postVideoData,
                        doubleTap: () {
                          if (widget.feed!.postLikeIcon !=
                              "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                            likeUnlike(
                                widget.feed!.postType, widget.feed!.postId!);
                            setState(() {
                              widget.feed!.whiteHeartLogo = true;
                              widget.feed!.isLiked = true;
                            });
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                widget.feed!.whiteHeartLogo = false;
                              });
                            });
                          }
                        },
                        tagTap: () {
                          showMaterialModalBottomSheet(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20.0),
                                      topRight: const Radius.circular(20.0))),
                              //isScrollControlled:true,
                              context: context,
                              builder: (BuildContext bc) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter stateSetter) {
                                  return Container(
                                      child: _buildTaggedUsersCard(
                                          stateSetter, _taggedUsersVideo!));
                                });
                              });
                        },
                      ))
                  : widget.feed!.postType == "blog"
                      ? Container(
                          // height: 50.h,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                              onDoubleTap: () {
                                print(
                                    "widget.feed.postLikeIcon= ${widget.feed!.postLikeIcon} widget.feed.whiteHeartlogo=${widget.feed!.whiteHeartLogo} ");
                                if (widget.feed!.postLikeIcon !=
                                    "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                                  likeUnlike(widget.feed!.postType,
                                      widget.feed!.postId!);

                                  setState(() {
                                    widget.feed!.whiteHeartLogo = true;
                                    widget.feed!.isLiked = true;
                                  });
                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      widget.feed!.whiteHeartLogo = false;
                                    });
                                  });
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  BlogFooter(
                                    feed: widget.feed,
                                    setNavBar: widget.setNavBar,
                                    isChannelOpen: widget.isChannelOpen,
                                    changeColor: widget.changeColor,
                                  ),
                                  (widget.feed!.whiteHeartLogo!)
                                      ? Positioned.fill(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                "assets/images/white_heart.png",
                                                height: 100,
                                              )),
                                        )
                                      : Container()
                                ],
                              )))
                      : widget.feed!.postType == "feed_post"
                          ? multiplevideo()
                          :
                          // Container(
                          //     height: 50.h,
                          //     width: MediaQuery.of(context).size.width,
                          // child:
                          // Container(
                          //     height: 30.0.h,
                          //     width: 100.0.w,
                          //     color: Colors.pink,
                          //   ),
                          SingleImageCard(
                              feed: widget.feed!,
                              stack: getTaggedUsersIndex(),
                              onTap: () {
                                print("tapped");
                                setState(() {
                                  widget.feed!.showUserTags = true;
                                });

                                Timer(Duration(seconds: 2), () {
                                  setState(() {
                                    widget.feed!.showUserTags = false;
                                  });
                                });
                              },
                              onDoubleTap: () {
                                print("aha");
                                if (widget.feed!.postLikeIcon !=
                                    "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                                  likeUnlike(widget.feed!.postType,
                                      widget.feed!.postId!);

                                  setState(() {
                                    widget.feed!.whiteHeartLogo = true;
                                    widget.feed!.isLiked = true;
                                  });
                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      widget.feed!.whiteHeartLogo = false;
                                    });
                                  });
                                }
                              },
                            ),
          // ),
          // SizedBox(
          //   height: widget.feed.postUserId == CurrentUser().currentUser.memberID
          //       ? 1.0.h
          //       : 0,
          // ),
          widget.feed!.postUserId == CurrentUser().currentUser.memberID &&
              widget.feed!.postPromotedSlider != null
              ? PromotePostFooter(
            feed: widget.feed,
          )
              : Container(),
          widget.feed!.postUserId == CurrentUser().currentUser.memberID
              ? Divider(
            thickness: 1,
          )
              : Container(),
          widget.feed!.postUserId != CurrentUser().currentUser.memberID &&
              widget.feed!.boostData! > 0 &&
              widget.feed!.boostedButton != "" &&
              widget.feed!.boostedButton != null &&
              widget.feed!.boostData != null
              ? GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebsiteView(
                          url: widget.feed!.boostedLink, heading: "")));
            },
            child: Container(
              height: 5.0.h,
              color: Color.fromRGBO(
                  int.parse(widget.feed!.color
                      .substring(4, widget.feed!.color.length - 1)
                      .split(",")[0]),
                  int.parse(widget.feed!.color
                      .substring(4, widget.feed!.color.length - 1)
                      .split(",")[1]),
                  int.parse(widget.feed!.color
                      .substring(4, widget.feed!.color.length - 1)
                      .split(",")[2]),
                  1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.feed!.boostedButton!, style: whiteBold),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          )
              : Container(),
          FeedBodyFooter(
            setNavBar: widget.setNavBar,
            isChannelOpen: widget.isChannelOpen,
            changeColor: widget.changeColor,
            feed: widget.feed,
            expandedFeed: () {
              print("click expanded");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpandedFeed(
                        setNavBar: widget.setNavBar!,
                        isChannelOpen: widget.isChannelOpen!,
                        changeColor: widget.changeColor!,
                        feed: widget.feed!,
                        logo: CurrentUser().currentUser.logo,
                        country: CurrentUser().currentUser.country,
                        memberID: CurrentUser().currentUser.memberID,
                        currentMemberImage: CurrentUser().currentUser.image,
                        currentMemberShortcode:
                        CurrentUser().currentUser.shortcode,
                      )));
            },
            like: () {
              setState(() {
                widget.feed!.isLiked = !widget.feed!.isLiked!;
              });
              likeUnlike(widget.feed!.postType, widget.feed!.postId!);
              if (widget.feed!.postLikeIcon !=
                  "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                setState(() {
                  widget.feed!.whiteHeartLogo = true;
                });
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    widget.feed!.whiteHeartLogo = false;
                  });
                });
              }
            },
            share: () {
              print("clickkk");
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  //isScrollControlled:true,
                  context: context,
                  builder: (BuildContext bc) {
                    return PostShare(
                      shortcode: widget.feed!.postShortcode,
                      postID: widget.feed!.postId,
                      image: widget.feed!.thumbnailUrl,
                      hasRebuzz: widget.feed!.hasRebuzzed,
                      shareUrl: () async {
                        Navigator.pop(context);
                        Uri uri = await DeepLinks.createPostDeepLink(
                            widget.feed!.postUserId!,
                            "post",
                            widget.feed!.postType! == "Image" ||
                                widget.feed!.postType! == "feedpost"
                                ? widget.feed!.postImgData!
                                .split("~~")[0]!
                                .replaceAll("/compressed", "")
                                .replaceAll(".mp4", ".jpg")!
                                : widget.feed!.postVideoThumb!,
                            widget.feed!.postContent != "" &&
                                widget.feed!.postContent!.length > 50
                                ? widget.feed!.postContent!.substring(0, 50) +
                                "..."
                                : widget.feed!.postContent!,
                            "${widget.feed!.postShortcode}",
                            widget.feed!.postId!);
                        Share.share(
                          '${uri.toString()}',
                        );
                      },
                      rebuzz: () {
                        postRebuzz(widget.feed!.postType, widget.feed!.postId!);

                        Navigator.pop(context);

                        Future.delayed(Duration(seconds: 1), () {
                          ScaffoldMessenger.of(
                              widget.sKey!.currentState!.context)
                              .showSnackBar(showSnackBar(AppLocalizations.of(
                              'Rebuzzed Successfully')));
                        });
                      },
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String? image;
  final BoxFit? fit;

  const ImageCard({Key? key, this.image, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image!,
      fit: fit == null ? BoxFit.cover : fit,
    );
  }
}

class SingleImageCard extends StatefulWidget {
  final NewsFeedModel? feed;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final List<Widget>? stack;

  const SingleImageCard(
      {Key? key, this.feed, this.onTap, this.onDoubleTap, this.stack})
      : super(key: key);

  @override
  _SingleImageCardState createState() => _SingleImageCardState();
}

class _SingleImageCardState extends State<SingleImageCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      onDoubleTap: widget.onDoubleTap ?? () {},
      child: Stack(children: widget.stack!),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
