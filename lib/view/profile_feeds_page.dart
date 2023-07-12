import 'dart:async';
import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_footer.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../api/ApiRepo.dart' as ApiRepo;
import 'discover_people_from_tags.dart';

class ProfileFeedsPage extends StatefulWidget {
  final String? logo;
  final NewsFeedModel? post;
  final String? memberID;
  final String? country;
  final String? currentMemberImage;
  final bool? isMemberLoaded;
  final String? postID;
  final String? listOfPostID;
  final String? otherMemberID;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? refresh;

  ProfileFeedsPage(
      {Key? key,
      this.logo,
      this.memberID,
      this.country,
      this.currentMemberImage,
      this.isMemberLoaded,
      this.postID,
      this.listOfPostID,
      this.post,
      this.otherMemberID,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.refresh})
      : super(key: key);

  @override
  _ProfileFeedsPageState createState() => _ProfileFeedsPageState();
}

class _ProfileFeedsPageState extends State<ProfileFeedsPage> {
  late AllFeeds feedsList;
   bool isFeedLoaded=false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var currentId;

//TODO :: inSheet 47
  Future<void> getProfileFeeds() async {
    print(currentId);

    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php");

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "current_user_id": currentId,
    //   "post_ids": "",
    //   "action": "profile_feed_data",
    //   "country": CurrentUser().currentUser.country,
    //   "post_id": widget.postID,
    //   "all_post_ids": widget.listOfPostID,
    // });

    var response = await ApiRepo.postWithToken("api/member_feed_data.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "current_user_id": currentId,
      "post_ids": "",
      "country": CurrentUser().currentUser.country,
      "post_id": widget.postID,
      // "all_post_ids": widget.listOfPostID,
    });
    print("===------- ${response!.data}");
    if (response!.success == 1) {
      AllFeeds feedData = AllFeeds.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          feedsList = feedData;
          isFeedLoaded = true;
          print("response true");
          print(feedData.feeds[0].postId);
          print(feedData.feeds[0].postType);
        });
      }
    }
    if (response!.success != 1 || response!.data['data'] == null) {
      print("no response");
      setState(() {
        isFeedLoaded = false;
      });
    }
  }

  void _onLoading() async {
    print("onLoading profile");
    int len = feedsList.feeds.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += feedsList.feeds[i].postId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    try {
      print(
          "onLodaing Profile feed = https://www.bebuzee.com/api/member_feed_data.php?user_id=${CurrentUser().currentUser.memberID}&current_user_id=$currentId&post_id=${widget.postID}&post_ids=${urlStr}&all_post_ids=${widget.listOfPostID}");
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php");

      // final response = await http.post(url, body: {
      //   "user_id": CurrentUser().currentUser.memberID,
      //   "current_user_id": currentId,
      //   "post_ids": urlStr,
      //   "action": "profile_feed_data",
      //   "country": CurrentUser().currentUser.country,
      //   "post_id": widget.postID,
      //   "all_post_ids": widget.listOfPostID,
      // });

      var response = await ApiRepo.postWithToken("api/member_feed_data.php", {
        "user_id": CurrentUser().currentUser.memberID,
        "current_user_id": currentId,
        "post_ids": urlStr,
        "country": CurrentUser().currentUser.country,
        "post_id": widget.postID,
        "all_post_ids": widget.listOfPostID,
      });
      if (response!.success == 1) {
        AllFeeds feedData = AllFeeds.fromJson(response!.data['data']);
        AllFeeds feedsTemp = feedsList;
        feedsTemp.feeds.addAll(feedData.feeds);
        if (mounted) {
          setState(() {
            feedsList = feedsTemp;
          });
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh feed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }

    _refreshController.loadComplete();
  }

  bool delete = false;
  bool feedEmpty = false;
  void _onRefresh() async {
    getProfileFeeds();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    if (widget.otherMemberID != null) {
      currentId = widget.otherMemberID;
    } else {
      currentId = CurrentUser().currentUser.memberID;
    }

    print(widget.listOfPostID! + " idssssssss");

    getProfileFeeds();
    // Timer(Duration(seconds: 15), () {
    //   if (feedsList.feeds. == null || widget.post.postImgData == "") {
    //     setState(() {
    //       feedEmpty = true;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: () async {
            print("back");
            Navigator.pop(context);
            //widget.refresh();
            return true;
          },
          child: Container(
            margin: EdgeInsets.only(top: 1.0.h),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: CustomHeader(
                builder: (context, mode) {
                  return Container(
                    child: Center(child: loadingAnimation()),
                  );
                },
              ),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;

                  if (mode == LoadStatus.idle) {
                    body = Text("");
                  } else if (mode == LoadStatus.loading) {
                    body = loadingAnimation();
                  } else if (mode == LoadStatus.failed) {
                    body = Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              new Border.all(color: Colors.black, width: 0.7),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(CustomIcons.reload),
                        ));
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("");
                  } else {
                    body = Text(
                      AppLocalizations.of("No more Data"),
                    );
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  itemCount:
                      isFeedLoaded == true ? feedsList.feeds.length + 1 : 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.5.h),
                        child: !delete
                            ? Column(
                                children: [
                                  FeedHeader(
                                    refresh: () {
                                      if (index == 0) {
                                        setState(() {
                                          delete = true;
                                        });
                                      }
                                    },
                                    setNavBar: widget.setNavBar,
                                    isChannelOpen: widget.isChannelOpen,
                                    changeColor: widget.changeColor,
                                    feed: widget.post,
                                    sKey: _scaffoldKey,
                                  ),
                                  FeedFooter(
                                    stickerList: widget.post!.stickers,
                                    positionList: widget.post!.position,
                                    setNavBar: widget.setNavBar,
                                    isChannelOpen: widget.isChannelOpen,
                                    changeColor: widget.changeColor,
                                    sKey: _scaffoldKey,
                                    feed: widget.post,
                                    onPressMatchText: (value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DiscoverFromTagsView(
                                              tag:
                                                  value.toString().substring(1),
                                            ),
                                          ));
                                    },
                                  ),
                                ],
                              )
                            : Container(),
                      );
                    } else if (isFeedLoaded == false) {
                      return Container(
                        child: loadingAnimation(),
                      );
                      // }
                      // if (feedsList.feeds[index - 1].postImgData == null ||
                      //     feedsList.feeds[index - 1].postImgData == "") {
                      //   Timer(Duration(seconds: 15), () {
                      //     (feedsList.feeds[index - 1].postImgData == null ||
                      //             feedsList.feeds[index - 1].postImgData ==
                      //                 "")
                      //         ? feedEmpty = true
                      //         : feedEmpty = false;
                      //   });
                      //   return feedEmpty ? Container() : loadingAnimation();
                    } else {
                      // Timer(Duration(seconds: 15), () {
                      //   (feedsList.feeds[index - 1].postImgData == null ||
                      //           feedsList.feeds[index - 1].postImgData == "")
                      //       ? feedsList.feeds[index - 1].hideFeed.value = true
                      //       : feedsList.feeds[index - 1].hideFeed.value = false;
                      // });
                      return Obx(
                          () => feedsList.feeds[index - 1].hideFeed!.isTrue
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 2.5.h),
                                  child: Column(
                                    children: [
                                      FeedHeader(
                                        setNavBar: widget.setNavBar,
                                        isChannelOpen: widget.isChannelOpen,
                                        changeColor: widget.changeColor,
                                        feed: feedsList.feeds[index - 1],
                                        sKey: _scaffoldKey,
                                        refresh: () {
                                          Timer(Duration(seconds: 2), () {
                                            getProfileFeeds();
                                          });
                                        },
                                      ),
                                      FeedFooter(
                                        stickerList:
                                            feedsList.feeds[index - 1].stickers,
                                        positionList:
                                            feedsList.feeds[index - 1].position,
                                        setNavBar: widget.setNavBar,
                                        isChannelOpen: widget.isChannelOpen,
                                        changeColor: widget.changeColor,
                                        sKey: _scaffoldKey,
                                        feed: feedsList.feeds[index - 1],
                                        onPressMatchText: (value) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DiscoverFromTagsView(
                                                  tag: value
                                                      .toString()
                                                      .substring(1),
                                                ),
                                              ));
                                        },
                                      ),
                                    ],
                                  ),
                                ));
                    }
                  }),
            ),
          ),
        ));
  }
}
