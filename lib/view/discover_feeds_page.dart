import 'dart:async';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_feeds_first_card.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_footer.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_header.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_feed_card.dart';
import 'dart:convert';
import 'discover_people_from_tags.dart';

class DiscoverFeedsPage extends StatefulWidget {
  final NewsFeedModel? posts;
  final String? logo;
  final String? memberID;
  final String? country;
  final String? currentMemberImage;
  final bool? isMemberLoaded;
  final String? postID;
  final String? listOfPostID;
  final String? from;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  String fromPostId;
  DiscoverFeedsPage(
      {Key? key,
      this.logo,
      this.fromPostId = '',
      this.memberID,
      this.country,
      this.currentMemberImage,
      this.isMemberLoaded,
      this.postID,
      this.listOfPostID,
      this.from,
      this.posts,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  _DiscoverFeedsPageState createState() => _DiscoverFeedsPageState();
}

class _DiscoverFeedsPageState extends State<DiscoverFeedsPage> {
  late AllFeeds feedsList;
  bool isFeedLoaded = false;
  var currentPage = 1;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> getDiscoverFeeds() async {
    print("discover feeds called");
    print(widget.listOfPostID);
    String? token = await ApiProvider().getTheToken();

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/image/list?user_id=${CurrentUser().currentUser.memberID!}&post_id=${widget.postID}&country=${CurrentUser().currentUser.country}&page=1&from_post_id=${widget.fromPostId}');
    print("discover feed url= ${newurl}");
    var client = Dio();
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      print("loading discover feed ${value.data}");
      if (value.statusCode == 200) {
        AllFeeds feedData = AllFeeds.fromJson(value.data['data']);
        await Future.wait(feedData.feeds
            .map((e) => Preload.cacheImage(context, e.postImgData!))
            .toList());
        await Future.wait(feedData.feeds
            .map(
                (e) => PreloadUserImage.cacheImage(context, e.postUserPicture!))
            .toList());
        if (this.mounted) {
          setState(() {
            feedsList = feedData;
            isFeedLoaded = true;
          });
        }
      } else {
        setState(() {
          isFeedLoaded = false;
        });
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/people_images_api_call.php");

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "post_ids": "",
    //   "action": "people_images_feed_data",
    //   "country": CurrentUser().currentUser.country,
    //   "post_id": widget.postID,
    //   "all_post_ids": widget.listOfPostID,
    // });

    // if (response.statusCode == 200) {
    //   AllFeeds feedData = AllFeeds.fromJson(jsonDecode(response.body));
    //   await Future.wait(feedData.feeds
    //       .map((e) => Preload.cacheImage(context, e.postImgData))
    //       .toList());
    //   await Future.wait(feedData.feeds
    //       .map((e) => PreloadUserImage.cacheImage(context, e.postUserPicture))
    //       .toList());
    //   if (this.mounted) {
    //     setState(() {
    //       feedsList = feedData;
    //       isFeedLoaded = true;
    //     });
    //   }
    // }
    // if (response.body == null || response.statusCode != 200) {
    //   setState(() {
    //     isFeedLoaded = false;
    //   });
    // }
  }

  void _onLoading() async {
    int len;

    len = feedsList.feeds.length;

    String urlStr = "";
    // for (int i = 0; i < len; i++) {
    //   urlStr += feedsList.feeds[i].postId;
    //   if (i != len - 1) {
    //     urlStr += ",";
    //   }
    // }
    print(
        "loading called currentPage=${currentPage} already load page=${feedsList.feeds[len - 1].page}");
    var page = feedsList.feeds[len - 1].page;
    if (currentPage != page)
      return;
    else
      currentPage = page! + 1;
    String? token = await ApiProvider().getTheToken();
    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/image/list?user_id=${CurrentUser().currentUser.memberID!}&page=$page&post_id=${widget.postID}&country=${CurrentUser().currentUser.country}');
      print("discover url =${newurl} ");
      var client = Dio();
      await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("loading discover feed ${value.data}");
        if (value.statusCode == 200) {
          AllFeeds feedData = AllFeeds.fromJson(value.data['data']);
          await Future.wait(feedData.feeds
              .map((e) => Preload.cacheImage(context, e.postsmlImgData!))
              .toList());
          await Future.wait(feedData.feeds
              .map((e) =>
                  PreloadUserImage.cacheImage(context, e.postUserPicture!))
              .toList());
          AllFeeds feedsTemp = feedsList;
          feedsTemp.feeds.addAll(feedData.feeds);
          setState(() {
            feedsList = feedsTemp;
          });
        }
      });

      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/people_images_api_call.php");

      // final response = await http.post(url, body: {
      //   "user_id": widget.memberID,
      //   "post_ids": urlStr,
      //   "action": "people_images_feed_data",
      //   "post_id": widget.postID,
      //   "all_post_ids": widget.listOfPostID,
      //   "country": CurrentUser().currentUser.country
      // });

      // if (response.statusCode == 200) {
      //   AllFeeds feedData = AllFeeds.fromJson(jsonDecode(response.body));
      //   await Future.wait(feedData.feeds
      //       .map((e) => Preload.cacheImage(context, e.postImgData))
      //       .toList());
      //   await Future.wait(feedData.feeds
      //       .map((e) => PreloadUserImage.cacheImage(context, e.postUserPicture))
      //       .toList());
      //   AllFeeds feedsTemp = feedsList;
      //   feedsTemp.feeds.addAll(feedData.feeds);
      //   setState(() {
      //     feedsList = feedsTemp;
      //   });
      // }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh feed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          _refreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          // return object of type Dialog
          return Container();
        },
      );
    }
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    currentPage = 1;
    getDiscoverFeeds();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    CurrentUser().currentUser.changeNavbarColor = true;
    print("Entered the discover height and width page");
    getDiscoverFeeds();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        body: Container(
          margin: EdgeInsets.only(top: 1.0.h),
          child: NotificationListener<UserScrollNotification>(
            onNotification: (v) {
              // if (v.direction == ScrollDirection.reverse) {
              //   _onLoading();
              // }
              return true;
            },
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: isFeedLoaded == true ? true : false,
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
                onLoading: () {
                  _onLoading();
                },
                onRefresh: _onRefresh,
                child: ListView.builder(
                    itemCount:
                        isFeedLoaded == true ? feedsList.feeds.length : 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.keyboard_backspace_rounded,
                                      size: 30,
                                    ),
                                    constraints: BoxConstraints(),
                                    splashRadius: 25,
                                    iconSize: 30,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      AppLocalizations.of('Explore'),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.5.h),
                              child: Column(
                                children: [
                                  FeedHeader(
                                    setNavBar: widget.setNavBar,
                                    isChannelOpen: widget.isChannelOpen,
                                    changeColor: widget.changeColor,
                                    feed: widget.posts,
                                    sKey: _scaffoldKey,
                                  ),
                                  FeedFooter(
                                    stickerList: widget.posts!.stickers,
                                    positionList: widget.posts!.position,
                                    setNavBar: widget.setNavBar,
                                    isChannelOpen: widget.isChannelOpen,
                                    changeColor: widget.changeColor,
                                    sKey: _scaffoldKey,
                                    feed: widget.posts,
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
                              ),
                            ),
                            isFeedLoaded == false
                                ? Container(
                                    child: loadingAnimation(),
                                  )
                                : Container()
                          ],
                        );
                      } else if (isFeedLoaded == false) {
                        return Container();
                      } else {
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.5.h),
                            child: Column(
                              children: [
                                FeedHeader(
                                  setNavBar: widget.setNavBar,
                                  isChannelOpen: widget.isChannelOpen,
                                  changeColor: widget.changeColor,
                                  feed: feedsList.feeds[index],
                                  sKey: _scaffoldKey,
                                ),
                                FeedFooter(
                                  stickerList: feedsList.feeds[index].stickers,
                                  positionList: feedsList.feeds[index].position,
                                  setNavBar: widget.setNavBar,
                                  isChannelOpen: widget.isChannelOpen,
                                  changeColor: widget.changeColor,
                                  sKey: _scaffoldKey,
                                  feed: feedsList.feeds[index],
                                  onPressMatchText: (value) {
                                    print("clickeeeadada");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DiscoverFromTagsView(
                                            tag: value.toString().substring(1),
                                          ),
                                        ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    })),
          ),
        ));
  }
}
