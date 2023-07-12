import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_search_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/Discover/discover_expanded_feed.dart';
import 'package:bizbultest/view/discover_search_page.dart';
import 'package:bizbultest/view/expanded_feed.dart';
import 'package:bizbultest/view/video_page_main.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/expanded_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'discover_video_player.dart';

class VideosSearchPage extends StatefulWidget {
  final String search;
  final String memberID;
  final String country;
  final double? lat;
  final double? long;

  final bool? hasData;
  final DiscoverSearchPageState parent;

  VideosSearchPage(
      {Key? key,
      required this.search,
      required this.memberID,
      this.hasData,
      required this.parent,
      required this.country,
      this.lat,
      this.long})
      : super(key: key);

  @override
  _VideosSearchPageState createState() => _VideosSearchPageState();
}

class _VideosSearchPageState extends State<VideosSearchPage> {
  late List<VideoListModelData> videoList;
  bool hasData = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String searchCurrent = "";

  Future<void> getVideos(text) async {
    print("text is:" + text);
    var newUrl = Uri.parse(
        'https://www.bebuzee.com/api/video/videoData?user_id=${widget.memberID}&keyword=$text&post_ids=&country=WorldWide');
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("video url=${newUrl}");
    var response = await client
        .postUri(
          newUrl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=get_search_video_data&user_id=${widget.memberID}&keyword=$text&post_ids=&country=${CurrentUser().currentUser.country}"
        "");
    // var response = await http.get(url);
    //print(response.body);

    if (response.statusCode == 200) {
      print("video list=${response.data}");
      // Videos videoData = Videos.fromJson(response.data['data']);

      VideoListModel videoData = VideoListModel.fromJson(response.data);

      await Future.wait(videoData.data!
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());

      // await Future.wait(videoData.videos
      //     .map((e) => Preload.cacheImage(context, e.image))
      //     .toList());

      //print(peopleData.people[0].name);
      setState(() {
        videoList = videoData.data!;
        hasData = true;
      });

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          hasData = false;
        });
      }
    }
  }

  void _onLoading() async {
    // int len = videoList.videos.length;
    int len = videoList.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      // urlStr += videoList.videos[i].postId;
      urlStr += videoList[i].postId.toString();
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    try {
      print("onloding called popular");
      var newUrl = Uri.parse(
          'https://www.bebuzee.com/api/video/videoData?user_id=${widget.memberID}&keyword=${widget.parent.searchText}&post_ids=&country=WorldWide&post_ids=$urlStr');
      var client = Dio();
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
      print("video url=${newUrl}");
      var response = await client
          .postUri(
            newUrl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }),
          )
          .then((value) => value);

      print("onloading search video =${response.data}");
      if (response.statusCode == 200) {
        // Videos videoData = Videos.fromJson(response.data['data']);
        // await Future.wait(videoData.videos
        //     .map((e) => Preload.cacheImage(context, e.image))
        //     .toList());

        VideoListModel videoData = VideoListModel.fromJson(response.data);

        await Future.wait(videoData.data!
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());

        // Videos videosTemp = videoList;
        // videosTemp.videos.addAll(videoData.videos);
        List<VideoListModelData> videosTemp = videoList;
        videosTemp.addAll(videoData.data!);

        setState(() {
          videoList = videosTemp;
          hasData = true;
        });
      }

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          hasData = false;
        });
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
    } catch (e) {
      _refreshController.loadComplete();
    }
    print("end of loading video search");
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    getVideos(widget.parent.searchText);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    print(widget.memberID);
    print(widget.search);
    // videoList = Videos([]);
    videoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parent.searchText != "") {
      if (searchCurrent != widget.parent.searchText) {
        getVideos(widget.parent.searchText);
      }
      searchCurrent = widget.parent.searchText;
    } else {
      // videoList.videos = [];
      videoList = [];
    }
    return Container(
        color: Colors.black,
        child: hasData == true
            ? SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: CustomHeader(
                  builder: (context, mode) {
                    return Container(
                      child: Center(child: loadingAnimationBlackBackground()),
                    );
                  },
                ),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;

                    if (mode == LoadStatus.idle) {
                      body = Text("");
                    } else if (mode == LoadStatus.loading) {
                      body = loadingAnimationBlackBackground();
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
                      body = Text(
                        AppLocalizations.of("release to load more"),
                      );
                    } else {
                      body = Text(
                        AppLocalizations.of(
                          "No more Data",
                        ),
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
                child: StaggeredGridView.countBuilder(
                  // physics: NeverScrollableScrollPhysics(),

                  crossAxisCount: 3,
                  // itemCount: videoList.videos.length,
                  itemCount: videoList.length,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  itemBuilder: (context, index) {
                    // var video = videoList.videos[index];
                    var video = videoList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // ExpandedVideoPlayer(
                                  //   video: video.
                                  // )
                                  // Container(
                                  //   height: 200,
                                  //   child: DiscoverVideoPlayer(
                                  //       image: video.image,
                                  //       url: video.videoUrl),
                                  // )

                                  ExpandedVideoPlayer(
                                rebuzed: () {},
                                adsList: null,

                                copied: () {},
                                onPress: () {},

                                // dispose: showNoPlayer,
                                video: video,
                                expand: () {},
                                onPressHide: () {},
                                showFullPlayer: true, onPop: () {},
                              ),

                              // MainVideoPage(
                              //   adsList: null,
                              //   changeColor: () {},
                              //   video: video,
                              //   // video: popularVideosProvider
                              //   //     .videoList[index],
                              //   from: "Feeds",
                              //   // scrollController: widget.scrollController,
                              //   scrollController: ScrollController(),
                              //   setNavBar: () {},
                              // )

                              //     GestureDetector(
                              //   onTap: () {},
                              //   child: Container(
                              //     height: 500,
                              //     child: DiscoverVideoPlayer(
                              //       image: video.image,
                              //       url: video.video,
                              //     ),
                              //   ),
                              // ),

                              // DiscoverExpandedFeed(
                              //   from: "Location",
                              //   postImgData: video.videoUrl,
                              //   postMultiImage: 0,
                              //   postHeaderLocation: 'location',
                              //   timeStamp: video.timeStamp,
                              //   postRebuzData: '',
                              //   postContent: video.postContent,
                              //   postUserPicture: video.image,
                              //   postShortcode: video.usrShortcode,
                              //   //  feed: widget.feed,

                              //   postType: 'Video',
                              //   postID: video.postId,

                              //   country: widget.country,
                              //   memberID: widget.memberID,
                              // )
                              // ExpandedFeed(
                              //   from: "Location",
                              //   postImgData: posts.discoverPosts[index].postAllImages,
                              //   postMultiImage: posts.discoverPosts[index].dataMultiImage,
                              //   postHeaderLocation: posts.discoverPosts[index].postHeaderLocation,
                              //   timeStamp: posts.discoverPosts[index].timeStamp,
                              //   postRebuzData: posts.discoverPosts[index].postRebuzData,
                              //   postContent: posts.discoverPosts[index].postContent,
                              //   postUserPicture: posts.discoverPosts[index].postUserPicture,
                              //   postShortcode: posts.discoverPosts[index].postShortcode,
                              //   //  feed: widget.feed,
                              //   postType: posts.discoverPosts[index].postType,
                              //   postID: posts.discoverPosts[index].postId,
                              //   postUserId: posts.discoverPosts[index].postMemberId,
                              //   logo: widget.logo,
                              //   country: widget.country,
                              //   memberID: widget.memberID,
                              // )
                            ));
                      },
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 10 / 9,
                            child: Container(
                              child: Image.network(
                                video.image!,
                                fit: BoxFit.cover,

                                // errorWidget: (context, url, error) => new Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.fit(1);
                  },
                ),
              )
            : Container());
  }
}
