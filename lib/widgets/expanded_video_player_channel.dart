import 'dart:async';

import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/autoplay_video_model.dart';
import 'package:bizbultest/models/video_comments_model.dart';
import 'package:bizbultest/models/video_quality_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_actions.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_comment_card.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_seek_controls.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_user_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../api/ApiRepo.dart' as ApiRepo;
import 'MainVideoWidgets/custom_video_controls.dart';
import 'MainVideoWidgets/quality_card.dart';
import 'autoplay_video_card.dart';
import '../api/ApiRepo.dart' as ApiRepo;
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
class ExpandedVideoCardChannel extends StatefulWidget {
  final VideoListModelData? video;
  final bool? showFullPlayer;
  final VoidCallback? onPressHide;
  final VoidCallback? expand;
  final VoidCallback? onPress;
  final String? from;
  final List? playlist;
  int? currentIndex;
  final Function? copied;
  final String? name;
  final Function? rebuzed;

  ExpandedVideoCardChannel({
    Key? key,
    this.showFullPlayer,
    this.video,
    this.onPressHide,
    this.expand,
    this.onPress,
    this.from,
    this.playlist,
    this.currentIndex,
    this.copied,
    this.name,
    this.rebuzed,
  }) : super(key: key);

  @override
  _ExpandedVideoCardChannelState createState() =>
      _ExpandedVideoCardChannelState();
}

class _ExpandedVideoCardChannelState extends State<ExpandedVideoCardChannel> {
  late FlickManager flickManager;
  late VideoComments commentList;
  late Qualities qualitiesList;
  bool areQualitiesLoaded = false;
  bool areCommentsLoaded = false;
  bool isDisposed = false;
  late int selectedIndex;
  String firstComment = "";
  String firstUserIcon = "";
  late AutoPlayVideos videoList;
  bool areVideosLoaded = false;
  bool? showAllComments = false;
  bool showPlaylist = false;
  late VideoListModelData data;
  var postID;
  var content;
  var video;
  var views;
  var timestamp;
  var username;
  var userImage;
  var comments;
  late int totalLikes;
  late int totalDislikes;
  late String shareUrl;
  TextEditingController _controller = TextEditingController();
  TextEditingController _embedController = TextEditingController();
  var likeStatus;
  var dislikeStatus;
  var followStatus;
  var thumbnail;
  var userID;
  bool isReply = false;

  Future<void> getVideoQualities(String postID) async {
    // var url = Uri.parse(
    // "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=post_resolutions&post_id=$postID");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video_quality_list.php",
        {"action": "post_resolutions", "post_id": postID});

    if (response != null && response!.success == 1) {
      Qualities qualityData = Qualities.fromJson(response!.data['data']);
      setState(() {
        qualitiesList = qualityData;
        areQualitiesLoaded = true;
      });
    }
    if (response == null || response!.data != 1 || response!.data) {
      setState(() {
        areQualitiesLoaded = false;
      });
    }
  }

  RefreshController _videoRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController _commentsRefreshController =
      RefreshController(initialRefresh: false);

  //!api updated
  Future<void> postMainComment(String comment,
      {String from = "unknown"}) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentAdd?action=write_comment_data&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comments=$comment&post_type=Video";

    var client = new dio.Dio();
    print("token called $from");

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

    print(response!.data);
    if (response!.statusCode == 200) {
      print("$comment is posted");
      getComments();
    }
  }

  //! api updated
  Future<void> postSubComment(String comment, String commentID) async {
    var url =
        "api/newsfeed/postCommentReplay?action=reply_to_main_comment&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comments=$comment&comment_id=$commentID&post_type=Video";

    var client = new dio.Dio();
    print("token called forom ");

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

    print('subcomment post response= ${response!.data}');
    if (response!.statusCode == 200) {
      setState(() {});
    }
  }

  Future<void> getComments() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?
    // action=video_page_comment_data&user_id=${CurrentUser().currentUser.memberID}&
    // post_id=$postID&country=${CurrentUser().currentUser.country}&comment_ids=");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/post_comment_data", {
      "action": "video_page_comment_data",
      "user_id": CurrentUser().currentUser.memberID,
      "post_id": postID,
      "country": CurrentUser().currentUser.country,
      "comment_ids": "",
      "post_type": "Video"
    });

    if (response!.success == 1) {
      VideoComments commentData =
          VideoComments.fromJson(response!.data['data']);
      print(commentData);

      setState(() {
        firstComment = commentData.comments[0].comment!;
        firstUserIcon = commentData.comments[0].upicture!;
        commentList = commentData;
        areCommentsLoaded = true;
      });
    }

    if (response!.success != 1 || response!.data['data'] == null) {
      setState(() {
        areCommentsLoaded = false;
      });
    }
  }

  void _onRefreshComments() {
    getComments();
    _commentsRefreshController.refreshCompleted();
  }

  Future<void> getAutoPlayList() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=video_page_autoplay_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&post_ids=");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video/videoAutoList", {
      "action": "video_page_autoplay_list",
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "post_id": postID,
      "post_ids": ""
    });

    if (response != null && response!.success == 1) {
      AutoPlayVideos videoData =
          AutoPlayVideos.fromJson(response!.data['data']);
      await Future.wait(videoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());
      setState(() {
        videoList = videoData;
        areVideosLoaded = true;
      });
    }
    print(commentList.comments.length.toString() + "  is comments length");
    print(commentList.comments[0].upicture! + "  is picture");

    if (response != null && response!.data['data'] == null ||
        response!.success != 200) {
      setState(() {
        areVideosLoaded = false;
      });
    }
  }

  void _onLoadingVideos() async {
    int len = videoList.videos.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += videoList.videos[i].postId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    try {
      // var url = Uri.parse(
      // "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=video_page_autoplay_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&post_ids=$urlStr");

      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/video/videoAutoList", {
        "action": "video_page_autoplay_list",
        "user_id": CurrentUser().currentUser.memberID,
        "country": CurrentUser().currentUser.country,
        "post_id": postID,
        "post_ids": urlStr
      });
      print(response!.data);
      if (response != null &&
          response!.data != null &&
          response!.data['data'] != null &&
          response!.success == 1) {
        AutoPlayVideos videoData =
            AutoPlayVideos.fromJson(response!.data['data']);
        await Future.wait(videoData.videos
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());
        AutoPlayVideos videosTemp = videoList;
        videosTemp.videos.addAll(videoData.videos);
        setState(() {
          videoList = videosTemp;
          areVideosLoaded = true;
        });
      }
      if (response!.data == null || response!.success != 1) {
        setState(() {
          areVideosLoaded = false;
        });
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(
          "Couldn't refresh",
        ),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _videoRefreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          // return object of type Dialog
          return Container();
        },
      );
    }
    _videoRefreshController.loadComplete();
  }

  void _onLoadingComments() async {
    int len = commentList.comments.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += commentList.comments[i].commentId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    if (urlStr.split(",").toList().length < widget.video!.totalComments!) {
      try {
        // var url = Uri.parse(
        //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=video_page_comment_data&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comment_ids=$urlStr");

        // var response = await http.get(url);

        var response = await ApiRepo.postWithToken("", {
          "user_id": CurrentUser().currentUser.memberID,
          "post_id": postID,
          "country": CurrentUser().currentUser.country,
          "comment_ids": urlStr
        });

        print(response!.data);
        if (response != null && response!.success == 1) {
          VideoComments commentData =
              VideoComments.fromJson(response!.data['data']);
          VideoComments videosTemp = commentList;
          videosTemp.comments.addAll(commentData.comments);
          setState(() {
            commentList = videosTemp;
            areCommentsLoaded = true;
          });
        }
        if (response!.data == null || response!.success != 1) {
          setState(() {
            areCommentsLoaded = false;
          });
        }
      } on SocketException catch (e) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(
            "Couldn't refresh comments",
          ),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 15.0,
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            _commentsRefreshController.loadFailed();
            Timer(Duration(seconds: 2), () {
              Navigator.pop(context);
            });

            // return object of type Dialog
            return Container();
          },
        );
      }
      _commentsRefreshController.loadComplete();
    } else {
      _commentsRefreshController.loadComplete();
    }
  }

  var quality;

  @override
  void initState() {
    getVideoQualities(widget.video!.postId.toString());
    super.initState();

    setState(() {
      quality = widget.video!.quality;
      _embedController = widget.video!.embedController;
      postID = widget.video!.postId;
      content = widget.video!.postContent;
      video = widget.video!.video;
      username = widget.video!.name;
      userImage = widget.video!.userImage;
      views = widget.video!.numViews;
      timestamp = widget.video!.timeStamp;
      comments = widget.video!.totalComments;
      totalDislikes = widget.video!.numberOfDislike!;
      totalLikes = widget.video!.numberOfLike!;
      shareUrl = widget.video!.shareUrl!;
      likeStatus = widget.video!.likeStatus;
      dislikeStatus = widget.video!.dislikeStatus;
      followStatus = widget.video!.followData;
      userID = widget.video!.userId;
      thumbnail = widget.video!.image;
    });
    getComments();
    data = widget.video!;

    getAutoPlayList();

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(video),
    );
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  bool isFullscreen = false;
  bool showControl = false;

  @override
  Widget build(BuildContext context) {
    if (isFullscreen == true) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    return Container(
      child: isFullscreen == false
          ? Container(
              height: widget.showFullPlayer == false ? 7.0.h : 100.0.h,
              color: widget.showFullPlayer == false
                  ? Colors.grey[900]!.withOpacity(0.9)
                  : Colors.grey[900],
              child: widget.showFullPlayer == true
                  ? Wrap(
                      children: [
                        Stack(
                          children: [
                            isDisposed == false
                                ? Container(
                                    height: 30.0.h,
                                    width: 100.0.w,
                                    child: VisibilityDetector(
                                      key: ObjectKey(flickManager),
                                      onVisibilityChanged: (visibility) {
                                        if (visibility.visibleFraction == 0 &&
                                            this.mounted) {
                                          flickManager.flickControlManager!
                                              .autoPause();
                                        } else if (visibility.visibleFraction ==
                                            1) {
                                          flickManager.flickControlManager!
                                              .autoResume();
                                          flickManager.flickDisplayManager!
                                              .addListener(() {
                                            if (flickManager.flickVideoManager!
                                                .isVideoEnded) {
                                              setState(() {
                                                getVideoQualities(widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .postId);
                                                widget.currentIndex =
                                                    widget.currentIndex! + 1;
                                                video = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .video;
                                                isDisposed = true;
                                                postID = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .postId;
                                                username = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .name;
                                                userImage = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .userImage;
                                                views = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .numViews;
                                                timestamp = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .timeStamp;
                                                content = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .postContent;
                                                comments = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .totalComments;
                                                totalLikes = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .numberOfLike;
                                                totalDislikes = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .numberOfDislike;
                                                likeStatus = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .likeStatus;
                                                userID = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .userID;
                                                thumbnail = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .index;
                                                followStatus = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .followData;
                                                dislikeStatus = widget
                                                    .playlist![
                                                        widget.currentIndex!]
                                                    .dislikeStatus;
                                              });

                                              Timer(Duration(seconds: 1), () {
                                                flickManager.flickVideoManager!
                                                    .dispose();
                                                setState(() {
                                                  flickManager =
                                                      new FlickManager(
                                                    videoPlayerController:
                                                        VideoPlayerController
                                                            .network(video),
                                                  );
                                                  isDisposed = false;
                                                });
                                                flickManager.flickVideoManager!
                                                    .videoPlayerController!
                                                    .play();
                                              });

                                              getAutoPlayList();
                                              getComments();
                                            }

                                            if (flickManager
                                                .flickDisplayManager!
                                                .showPlayerControls) {
                                              setState(() {
                                                showControl = true;
                                              });
                                            } else {
                                              setState(() {
                                                showControl = false;
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: FlickVideoPlayer(
                                          wakelockEnabled: true,
                                          wakelockEnabledFullscreen: false,
                                          flickManager: flickManager,
                                          flickVideoWithControls:
                                              FlickVideoWithControls(
                                            videoFit: BoxFit.contain,
                                            aspectRatioWhenLoading: 16 / 9,
                                            playerLoadingFallback: Center(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: thumbnail,
                                              ),
                                            ),
                                            controls: PotraitControls(
                                                forward: () async {
                                                  print(flickManager
                                                      .flickDisplayManager!
                                                      .showPlayerControls);
                                                  Duration? time =
                                                      await flickManager
                                                          .flickVideoManager!
                                                          .videoPlayerController!
                                                          .position;
                                                  time = time! +
                                                      Duration(seconds: 10);
                                                  flickManager
                                                      .flickVideoManager!
                                                      .videoPlayerController!
                                                      .seekTo(time);
                                                },
                                                backward: () async {
                                                  print(flickManager
                                                      .flickDisplayManager!
                                                      .showPlayerControls);
                                                  Duration? time =
                                                      await flickManager
                                                          .flickVideoManager!
                                                          .videoPlayerController!
                                                          .position;
                                                  if (time! >
                                                      Duration(seconds: 10)) {
                                                    time = time -
                                                        Duration(seconds: 10);
                                                  } else {
                                                    time = Duration(seconds: 0);
                                                  }

                                                  flickManager
                                                      .flickVideoManager!
                                                      .videoPlayerController!
                                                      .seekTo(time);
                                                },
                                                isFullscreen: isFullscreen,
                                                fullscreen: () {
                                                  setState(() {
                                                    isFullscreen =
                                                        !isFullscreen;
                                                  });
                                                }),
                                          ),
                                          flickVideoWithControlsFullscreen:
                                              FlickVideoWithControls(
                                            willVideoPlayerControllerChange:
                                                false,
                                            videoFit: BoxFit.contain,
                                            controls: LandscapeControls(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30.0.h,
                                    width: 100.0.w,
                                    child: Center(
                                        child: Image.network(
                                      thumbnail,
                                      fit: BoxFit.cover,

                                      // errorWidget: (context, url, error) => new Icon(Icons.error),
                                    )),
                                  ),
                            showControl == true
                                ? Positioned.fill(
                                    child: Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        print(postID);
                                        showModalBottomSheet(
                                            backgroundColor: Colors.grey[900],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            20.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            20.0))),
                                            //isScrollControlled:true,
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: qualitiesList
                                                      .qualities.length,
                                                  itemBuilder:
                                                      (content, index) {
                                                    return VideoQualityCard(
                                                      defaultQuality: quality,
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        var currentPosition =
                                                            await flickManager
                                                                .flickVideoManager!
                                                                .videoPlayerController!
                                                                .position;

                                                        setState(() {
                                                          video = qualitiesList
                                                              .qualities[index]
                                                              .video;
                                                          quality =
                                                              qualitiesList
                                                                  .qualities[
                                                                      index]
                                                                  .quality;
                                                          isDisposed = true;
                                                        });

                                                        Timer(
                                                            Duration(
                                                                seconds: 1),
                                                            () async {
                                                          flickManager
                                                              .flickVideoManager!
                                                              .dispose();
                                                          setState(() {
                                                            flickManager =
                                                                new FlickManager(
                                                              autoPlay: false,
                                                              autoInitialize:
                                                                  false,
                                                              videoPlayerController:
                                                                  VideoPlayerController
                                                                      .network(
                                                                          video),
                                                            );
                                                            isDisposed = false;
                                                          });
                                                          await flickManager
                                                              .flickVideoManager!
                                                              .videoPlayerController!
                                                              .initialize();
                                                          flickManager
                                                              .flickControlManager!
                                                              .seekTo(
                                                                  currentPosition!);
                                                          flickManager
                                                              .flickControlManager!
                                                              .play();
                                                        });
                                                      },
                                                      video: widget.video!,
                                                      quality: qualitiesList
                                                          .qualities[index],
                                                    );
                                                  });
                                            });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 2.0.h,
                                              right: 2.0.w,
                                              left: 2.0.w,
                                              bottom: 2.0.h),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 3.0.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                                : Container(),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showPlaylist = !showPlaylist;
                              if (showPlaylist == true) {
                                showAllComments = null;
                              } else {
                                showAllComments = false;
                              }
                            });

                            print(showPlaylist);
                          },
                          splashColor: Colors.grey.withOpacity(0.3),
                          child: Container(
                              color: Colors.black38,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0.w, vertical: 1.5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.from!,
                                          style: whiteNormal.copyWith(
                                              fontSize: 9.0.sp),
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.playlist!.length
                                                      .toString() +
                                                  " " +
                                                  AppLocalizations.of(
                                                    "videos",
                                                  ),
                                              style: greyNormal.copyWith(
                                                  fontSize: 9.0.sp),
                                            ),
                                            SizedBox(
                                              width: 3.0.w,
                                            ),
                                            // Text(
                                            //   widget.name,
                                            //   style: greyNormal.copyWith(
                                            //       fontSize: 9.0.sp),
                                            // )
                                          ],
                                        )
                                      ],
                                    ),
                                    showPlaylist == false
                                        ? Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            size: 3.5.h,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_up_sharp,
                                            size: 3.5.h,
                                            color: Colors.white,
                                          )
                                  ],
                                ),
                              )),
                        ),
                        showAllComments == false
                            ? Container(
                                height: 62.0.h,
                                child: SmartRefresher(
                                  enablePullDown: false,
                                  enablePullUp: true,
                                  header: CustomHeader(
                                    builder: (context, mode) {
                                      return Container(
                                        child: Center(
                                            child:
                                                loadingAnimationBlackBackground()),
                                      );
                                    },
                                  ),
                                  footer: CustomFooter(
                                    builder: (BuildContext context,
                                        LoadStatus? mode) {
                                      Widget body;

                                      if (mode == LoadStatus.idle) {
                                        body = Text("");
                                      } else if (mode == LoadStatus.loading) {
                                        body =
                                            loadingAnimationBlackBackground();
                                      } else if (mode == LoadStatus.failed) {
                                        body = Container(
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                  color: Colors.black,
                                                  width: 0.7),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Icon(CustomIcons.reload),
                                            ));
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
                                        body = Text(
                                          AppLocalizations.of(
                                              "release to load more"),
                                        );
                                      } else {
                                        body = Text(AppLocalizations.of(
                                            "No more Data"));
                                      }
                                      return Container(
                                        height: 55.0,
                                        child: Center(child: body),
                                      );
                                    },
                                  ),
                                  controller: _videoRefreshController,
                                  //  onRefresh: _onRefreshCategories,
                                  onLoading: () {
                                    _onLoadingVideos();
                                  },
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 1.5.h,
                                            left: 3.0.w,
                                            right: 3.0.w,
                                            bottom: 0.5.h),
                                        child: Text(
                                          content,
                                          style: whiteBold.copyWith(
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.0.w),
                                        child: Row(
                                          children: [
                                            views == 1
                                                ? Text(
                                                    "${views}",
                                                    style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: Colors.white
                                                            .withOpacity(0.7)),
                                                  )
                                                : Text(
                                                    "${views}",
                                                    style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: Colors.white
                                                            .withOpacity(0.7)),
                                                  ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.0.w),
                                              child: Text(
                                                timestamp,
                                                style: TextStyle(
                                                    fontSize: 9.0.sp,
                                                    color: Colors.white
                                                        .withOpacity(0.7)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      VideoActions(
                                        rebuzed: widget.rebuzed!,
                                        copied: widget.copied!,
                                        username: username,
                                        userID: userID,
                                        controller: _embedController,
                                        share: () {
                                          //  flickManager.flickVideoManager.videoPlayerController.setVolume(0);
                                          flickManager.flickControlManager!
                                              .pause();

                                          Timer(Duration(milliseconds: 300),
                                              () async {
                                            await Share.share(shareUrl);
                                          });
                                        },
                                        likeStatus: likeStatus is bool
                                            ? likeStatus
                                                ? 1
                                                : 0
                                            : likeStatus,
                                        dislikeStatus: dislikeStatus is bool
                                            ? dislikeStatus
                                                ? 1
                                                : 0
                                            : dislikeStatus,
                                        postID: postID.toString(),
                                        totalLikes: totalLikes,
                                        totalDislikes: totalDislikes,
                                        shareUrl: shareUrl,
                                        setLikes: (like_status, dislike_status,
                                            total_likes, total_dislikes) {
                                          setState(() {
                                            likeStatus = like_status;
                                            dislikeStatus = dislike_status;
                                            totalDislikes = total_dislikes;
                                            totalLikes = total_likes;
                                            widget.video!.likeStatus =
                                                like_status;
                                            widget.video!.dislikeStatus =
                                                dislike_status;
                                            widget.video!.numberOfLike =
                                                total_likes;
                                            widget.video!.numberOfDislike =
                                                total_dislikes;
                                          });
                                        },
                                      ),
                                      Divider(
                                        thickness: 0.2,
                                        color: Colors.white,
                                      ),
                                      VideoUserCard(
                                        userID: userID,
                                        userImage: userImage,
                                        username: username,
                                        followStatus:
                                            widget.video!.followStatus,
                                      ),
                                      Divider(
                                        thickness: 0.2,
                                        color: Colors.white,
                                      ),
                                      ElevatedButton(
                                        // :
                                        //     Colors.grey.withOpacity(0.3),
                                        onPressed: () {
                                          setState(() {
                                            showAllComments = true;
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0.0.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      areCommentsLoaded
                                                          ? AppLocalizations.of(
                                                                  "Comments") +
                                                              "    " +
                                                              commentList
                                                                  .comments
                                                                  .length
                                                                  .toString()
                                                          : AppLocalizations.of(
                                                                  "Comments") +
                                                              "    " +
                                                              "0",
                                                      style:
                                                          whiteNormal.copyWith(
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      color: Colors.white,
                                                      size: 2.5.h,
                                                    ),
                                                  ],
                                                ),
                                                areCommentsLoaded == true
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1.0.h),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border:
                                                                      new Border
                                                                          .all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 2.0.h,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          firstUserIcon),
                                                                )),
                                                            SizedBox(
                                                              width: 2.0.w,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.0
                                                                          .h),
                                                              child: Container(
                                                                width: 70.0.w,
                                                                child: Text(
                                                                  parse(firstComment)
                                                                      .documentElement!
                                                                      .text,
                                                                  style: whiteNormal
                                                                      .copyWith(
                                                                          fontSize:
                                                                              9.0.sp),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.2,
                                        color: Colors.white,
                                      ),
                                      areVideosLoaded == true
                                          ? ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  videoList.videos.length,
                                              itemBuilder: (context, index) {
                                                return AutoPlayVideoCard(
                                                  changeVideo: () {
                                                    setState(() {
                                                      getVideoQualities(
                                                          videoList
                                                              .videos[index]
                                                              .postId!);
                                                      video = videoList
                                                          .videos[index].video;
                                                      isDisposed = true;
                                                      postID = videoList
                                                          .videos[index].postId;
                                                      username = videoList
                                                          .videos[index].name;
                                                      userImage = videoList
                                                          .videos[index]
                                                          .userImage;
                                                      views = videoList
                                                          .videos[index]
                                                          .numViews;
                                                      timestamp = videoList
                                                          .videos[index]
                                                          .timeStamp;
                                                      content = videoList
                                                          .videos[index]
                                                          .postContent;
                                                      comments = videoList
                                                          .videos[index]
                                                          .totalComments;
                                                      totalLikes = videoList
                                                          .videos[index]
                                                          .numberOfLike!;
                                                      totalDislikes = videoList
                                                          .videos[index]
                                                          .numberOfDislike!;
                                                      likeStatus = videoList
                                                          .videos[index]
                                                          .likeStatus;
                                                      userID = videoList
                                                          .videos[index].userID;
                                                      thumbnail = videoList
                                                          .videos[index].image;
                                                      followStatus = videoList
                                                          .videos[index]
                                                          .followData;
                                                      dislikeStatus = videoList
                                                          .videos[index]
                                                          .dislikeStatus;
                                                    });

                                                    Timer(Duration(seconds: 1),
                                                        () {
                                                      flickManager
                                                          .flickVideoManager!
                                                          .dispose();
                                                      setState(() {
                                                        flickManager =
                                                            new FlickManager(
                                                          videoPlayerController:
                                                              VideoPlayerController
                                                                  .network(
                                                                      video),
                                                        );
                                                        isDisposed = false;
                                                      });
                                                      flickManager
                                                          .flickVideoManager!
                                                          .videoPlayerController!
                                                          .play();
                                                    });

                                                    getAutoPlayList();
                                                    getComments();
                                                  },
                                                  video:
                                                      videoList.videos[index],
                                                );
                                              })
                                          : Container()
                                    ],
                                  ),
                                ),
                              )
                            : showAllComments == true
                                ? Container(
                                    height: 62.0.h,
                                    color: Colors.grey[900],
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showAllComments = false;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 2.0.w,
                                                top: 1.5.h,
                                                right: 2.0.w,
                                                bottom: 1.5.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  areCommentsLoaded == true
                                                      ? AppLocalizations.of(
                                                              "Comments") +
                                                          "    " +
                                                          (commentList?.comments
                                                                      ?.length ??
                                                                  0)
                                                              .toString()
                                                      : AppLocalizations.of(
                                                              "Comments") +
                                                          "    " +
                                                          "0",
                                                  style: whiteNormal.copyWith(
                                                      fontSize: 13.0.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Icon(
                                                  Icons.clear,
                                                  size: 3.5.h,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        areCommentsLoaded == true
                                            ? Expanded(
                                                child: SmartRefresher(
                                                  enablePullDown: true,
                                                  enablePullUp: true,
                                                  header: CustomHeader(
                                                    builder: (context, mode) {
                                                      return Container(
                                                        child: Center(
                                                            child:
                                                                loadingAnimationBlackBackground()),
                                                      );
                                                    },
                                                  ),
                                                  footer: CustomFooter(
                                                    builder:
                                                        (BuildContext context,
                                                            LoadStatus? mode) {
                                                      Widget body;

                                                      if (mode ==
                                                          LoadStatus.idle) {
                                                        body = Text("");
                                                      } else if (mode ==
                                                          LoadStatus.loading) {
                                                        body =
                                                            loadingAnimationBlackBackground();
                                                      } else if (mode ==
                                                          LoadStatus.failed) {
                                                        body = Container(
                                                            decoration:
                                                                new BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: new Border
                                                                      .all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 0.7),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Icon(
                                                                  CustomIcons
                                                                      .reload),
                                                            ));
                                                      } else if (mode ==
                                                          LoadStatus
                                                              .canLoading) {
                                                        body = Text(
                                                          AppLocalizations.of(
                                                              "release to load more"),
                                                        );
                                                      } else {
                                                        body = Text(
                                                          AppLocalizations.of(
                                                              "No more Data"),
                                                        );
                                                      }
                                                      return Container(
                                                        height: 55.0,
                                                        child:
                                                            Center(child: body),
                                                      );
                                                    },
                                                  ),
                                                  controller:
                                                      _commentsRefreshController,
                                                  onRefresh: _onRefreshComments,
                                                  onLoading: _onLoadingComments,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: (commentList
                                                                  ?.comments
                                                                  ?.length ??
                                                              0) +
                                                          1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (index == 0) {
                                                          return Container(
                                                            color: Colors
                                                                .grey[850],
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3.0.w),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        border:
                                                                            new Border.all(
                                                                          color:
                                                                              Colors.grey,
                                                                          width:
                                                                              0.5,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            2.5.h,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        backgroundImage: NetworkImage(CurrentUser()
                                                                            .currentUser
                                                                            .image!),
                                                                      )),
                                                                  SizedBox(
                                                                    width:
                                                                        3.0.w,
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        72.0.w,
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 2.0
                                                                              .w,
                                                                          vertical:
                                                                              1.0.h),
                                                                      child:
                                                                          TextFormField(
                                                                        onTap:
                                                                            () {},
                                                                        maxLines:
                                                                            1,
                                                                        controller:
                                                                            _controller,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                        onChanged:
                                                                            (val) {},
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              InputBorder.none,
                                                                          focusedBorder:
                                                                              InputBorder.none,
                                                                          enabledBorder:
                                                                              InputBorder.none,
                                                                          errorBorder:
                                                                              InputBorder.none,
                                                                          disabledBorder:
                                                                              InputBorder.none,
                                                                          hintText:
                                                                              "Comment as ${CurrentUser().currentUser.fullName}",
                                                                          hintStyle: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10.0.sp),
                                                                          contentPadding:
                                                                              EdgeInsets.zero,

                                                                          // 48 -> icon width
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "reply clicked");
                                                                      print(
                                                                          "isreply =${isReply}");
                                                                      if (isReply) {
                                                                        postSubComment(
                                                                            _controller.text,
                                                                            commentList.comments[index].commentId!);
                                                                      } else {
                                                                        print(
                                                                            "called post subcomment");
                                                                        postMainComment(
                                                                            _controller
                                                                                .text,
                                                                            from:
                                                                                "here1");
                                                                      }

                                                                      _controller
                                                                          .clear();
                                                                      Timer(
                                                                          Duration(
                                                                              seconds: 2),
                                                                          () {
                                                                        getComments();
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .send,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.7),
                                                                      size:
                                                                          3.5.h,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return VideoCommentCard(
                                                            isReply: (reply) {
                                                              setState(() {
                                                                isReply = reply;
                                                              });
                                                            },
                                                            reportConfirmation:
                                                                () {
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
                                                                    return Container(
                                                                      child:
                                                                          ListTile(
                                                                        title: Text(
                                                                            AppLocalizations.of(
                                                                              "Report submitted successfully",
                                                                            ),
                                                                            style: whiteNormal.copyWith(fontSize: 12.0.sp)),
                                                                      ),
                                                                    );
                                                                  });

                                                              Timer(
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            refreshComments:
                                                                (index) {
                                                              print(index
                                                                      .toString() +
                                                                  "jfoqnqijfnqiuj");

                                                              setState(() {
                                                                commentList
                                                                    .comments
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            },
                                                            showSubComments:
                                                                () {
                                                              setState(() {
                                                                commentList
                                                                        .comments[
                                                                            index -
                                                                                1]
                                                                        .showSubcomments =
                                                                    !commentList
                                                                        .comments[
                                                                            index -
                                                                                1]
                                                                        .showSubcomments!;
                                                              });
                                                            },
                                                            index: index - 1,
                                                            editingController:
                                                                _controller,
                                                            postID: widget
                                                                .video!.postId
                                                                .toString(),
                                                            comment: commentList
                                                                    .comments[
                                                                index - 1],
                                                          );
                                                        }
                                                      }),
                                                ),
                                              )
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2.0.h),
                                                      child: Container(
                                                        color: Colors.grey[850],
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 3.0.w,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        new Border
                                                                            .all(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius:
                                                                        2.5.h,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    backgroundImage:
                                                                        NetworkImage(CurrentUser()
                                                                            .currentUser
                                                                            .image!),
                                                                  )),
                                                              SizedBox(
                                                                width: 3.0.w,
                                                              ),
                                                              Container(
                                                                width: 72.0.w,
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          2.0.w,
                                                                      vertical:
                                                                          1.0.h),
                                                                  child:
                                                                      TextFormField(
                                                                    onTap:
                                                                        () {},
                                                                    maxLines: 1,
                                                                    controller:
                                                                        _controller,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                    onChanged:
                                                                        (val) {},
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      focusedBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      enabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      errorBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      disabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      hintText:
                                                                          "Comment as ${CurrentUser().currentUser.fullName}",
                                                                      hintStyle: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10.0.sp),
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .zero,

                                                                      // 48 -> icon width
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print(
                                                                      "reply here");
                                                                  if (isReply ==
                                                                      false) {
                                                                    postMainComment(
                                                                        _controller
                                                                            .text,
                                                                        from:
                                                                            "here2");
                                                                  }

                                                                  _controller
                                                                      .clear();
                                                                  Timer(
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                      () {
                                                                    getComments();
                                                                  });

                                                                  Timer(
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      areCommentsLoaded =
                                                                          true;
                                                                    });
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.send,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.7),
                                                                  size: 3.5.h,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(
                                                        "No Comments",
                                                      ),
                                                      style:
                                                          whiteNormal.copyWith(
                                                              fontSize:
                                                                  15.0.sp),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                                  )
                                : showPlaylist == true
                                    ? Container(
                                        height: 60.0.h,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.playlist!.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    getVideoQualities(widget
                                                        .playlist![index]
                                                        .postId);
                                                    widget.currentIndex = index;
                                                    video = widget
                                                        .playlist![index].video;
                                                    quality = widget
                                                        .playlist![index]
                                                        .quality;
                                                    isDisposed = true;
                                                    postID = widget
                                                        .playlist![index]
                                                        .postId;
                                                    username = widget
                                                        .playlist![index].name;
                                                    userImage = widget
                                                        .playlist![index]
                                                        .userImage;
                                                    views = widget
                                                        .playlist![index]
                                                        .numViews;
                                                    timestamp = widget
                                                        .playlist![index]
                                                        .timeStamp;
                                                    content = widget
                                                        .playlist![index]
                                                        .postContent;
                                                    comments = widget
                                                        .playlist![index]
                                                        .totalComments;
                                                    totalLikes = widget
                                                        .playlist![index]
                                                        .numberOfLike;
                                                    totalDislikes = widget
                                                        .playlist![index]
                                                        .numberOfDislike;
                                                    likeStatus = widget
                                                        .playlist![index]
                                                        .likeStatus;
                                                    userID = widget
                                                        .playlist![index]
                                                        .userID;
                                                    thumbnail = widget
                                                        .playlist![index].image;
                                                    followStatus = widget
                                                        .playlist![index]
                                                        .followData;
                                                    dislikeStatus = widget
                                                        .playlist![index]
                                                        .dislikeStatus;
                                                  });

                                                  Timer(Duration(seconds: 1),
                                                      () {
                                                    flickManager
                                                        .flickVideoManager!
                                                        .dispose();
                                                    setState(() {
                                                      flickManager =
                                                          new FlickManager(
                                                        videoPlayerController:
                                                            VideoPlayerController
                                                                .network(video),
                                                      );
                                                      isDisposed = false;
                                                    });
                                                    flickManager
                                                        .flickVideoManager!
                                                        .videoPlayerController!
                                                        .play();
                                                  });

                                                  getAutoPlayList();
                                                  getComments();
                                                },
                                                child: Container(
                                                  color: widget.currentIndex ==
                                                          index
                                                      ? Colors.grey
                                                          .withOpacity(0.25)
                                                      : Colors.transparent,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 1.0.h,
                                                            horizontal: 3.0.w),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 25.0.w,
                                                          height: 8.0.h,
                                                          child: AspectRatio(
                                                              aspectRatio:
                                                                  16 / 9,
                                                              child: Image
                                                                  .network(widget
                                                                      .playlist![
                                                                          index]
                                                                      .image)),
                                                        ),
                                                        SizedBox(
                                                          width: 3.0.w,
                                                        ),
                                                        Container(
                                                          width: 55.0.w,
                                                          child: Text(
                                                            parse(widget
                                                                    .playlist![
                                                                        index]
                                                                    .postContent)
                                                                .documentElement!
                                                                .text,
                                                            style: whiteNormal
                                                                .copyWith(
                                                                    fontSize:
                                                                        10.0.sp),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        widget.currentIndex ==
                                                                index
                                                            ? Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Icon(
                                                                  Icons
                                                                      .play_circle_fill,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 4.0.h,
                                                                ))
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                    : Container(),
                      ],
                    )
                  : GestureDetector(
                      onTap: widget.expand ?? () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.white,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                child: VisibilityDetector(
                                  key: ObjectKey(flickManager),
                                  onVisibilityChanged: (visibility) {
                                    if (visibility.visibleFraction == 0 &&
                                        this.mounted) {
                                      flickManager.flickControlManager!
                                          .autoPause();
                                    } else if (visibility.visibleFraction ==
                                        1) {
                                      flickManager.flickControlManager!
                                          .autoResume();
                                      flickManager.flickDisplayManager!
                                          .addListener(() {
                                        if (flickManager.flickDisplayManager!
                                            .showPlayerControls) {
                                          setState(() {
                                            showControl = true;
                                          });
                                        } else {
                                          setState(() {
                                            showControl = false;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: FlickVideoPlayer(
                                      wakelockEnabled: true,
                                      wakelockEnabledFullscreen: false,
                                      flickManager: flickManager,
                                      flickVideoWithControls:
                                          FlickVideoWithControls(
                                        videoFit: BoxFit.contain,
                                        aspectRatioWhenLoading: 16 / 9,
                                        playerLoadingFallback: Center(
                                            child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.grey),
                                        )),
                                      ),
                                      flickVideoWithControlsFullscreen:
                                          FlickVideoWithControls(
                                        controls: FlickLandscapeControls(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 50.0.w,
                                    child: Text(
                                      content,
                                      style:
                                          whiteBold.copyWith(fontSize: 9.0.sp),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Text(
                                  username,
                                  style: whiteNormal.copyWith(fontSize: 8.0.sp),
                                ),
                              ],
                            ),
                          ),
                          flickManager.flickVideoManager!.isPlaying
                              ? GestureDetector(
                                  onTap: () {
                                    flickManager.flickControlManager!.pause();
                                  },
                                  child: Icon(
                                    Icons.pause,
                                    size: 4.0.h,
                                    color: Colors.white,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (flickManager
                                        .flickVideoManager!.isVideoEnded) {
                                      flickManager.flickControlManager!
                                          .replay();
                                    } else {
                                      flickManager.flickControlManager!.play();
                                    }
                                  },
                                  child: Icon(
                                    Icons.play_arrow,
                                    size: 4.0.h,
                                    color: Colors.white,
                                  ),
                                ),
                          GestureDetector(
                            onTap: widget.onPressHide ?? () {},
                            child: Icon(
                              Icons.clear,
                              size: 4.0.h,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
            )
          : Stack(
              children: [
                isDisposed == false
                    ? Container(
                        height: 100.0.w,
                        width: 100.0.h,
                        child: VisibilityDetector(
                          key: ObjectKey(flickManager),
                          onVisibilityChanged: (visibility) {
                            if (visibility.visibleFraction == 0 &&
                                this.mounted) {
                              flickManager.flickControlManager!.autoPause();
                            } else if (visibility.visibleFraction == 1) {
                              flickManager.flickControlManager!.autoResume();
                              flickManager.flickDisplayManager!.addListener(() {
                                // print(flickManager.flickVideoManager.isPlaying.toString() + " is playinggggggggggggggg");
                                // print(flickManager.flickVideoManager.errorInVideo.toString() + " errrorrrrrrrrrrrr");
                                //  print(flickManager.flickVideoManager.isVideoInitialized.toString() + " initializeddddddddddd");

                                if (flickManager
                                    .flickDisplayManager!.showPlayerControls) {
                                  setState(() {
                                    showControl = true;
                                  });
                                } else {
                                  setState(() {
                                    showControl = false;
                                  });
                                }
                              });
                            }
                          },
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: FlickVideoPlayer(
                              wakelockEnabled: true,
                              wakelockEnabledFullscreen: false,
                              flickManager: flickManager,
                              flickVideoWithControls: FlickVideoWithControls(
                                videoFit: BoxFit.contain,
                                aspectRatioWhenLoading: 16 / 9,
                                playerLoadingFallback: Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.grey),
                                )),
                                controls: PotraitControls(
                                    forward: () async {
                                      print(flickManager.flickDisplayManager!
                                          .showPlayerControls);
                                      Duration? time = await flickManager
                                          .flickVideoManager!
                                          .videoPlayerController!
                                          .position;
                                      time = time! + Duration(seconds: 10);
                                      flickManager.flickVideoManager!
                                          .videoPlayerController!
                                          .seekTo(time);
                                    },
                                    backward: () async {
                                      print(flickManager.flickDisplayManager!
                                          .showPlayerControls);
                                      Duration? time = await flickManager
                                          .flickVideoManager!
                                          .videoPlayerController!
                                          .position;
                                      if (time! > Duration(seconds: 10)) {
                                        time = time - Duration(seconds: 10);
                                      } else {
                                        time = Duration(seconds: 0);
                                      }

                                      flickManager.flickVideoManager!
                                          .videoPlayerController!
                                          .seekTo(time);
                                    },
                                    isFullscreen: isFullscreen,
                                    fullscreen: () {
                                      setState(() {
                                        isFullscreen = !isFullscreen;
                                      });
                                    }),
                              ),
                              flickVideoWithControlsFullscreen:
                                  FlickVideoWithControls(
                                willVideoPlayerControllerChange: false,
                                videoFit: BoxFit.cover,
                                controls: LandscapeControls(),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 100.0.w,
                        width: 100.0.h,
                        color: Colors.black,
                      ),
                showControl == true
                    ? Positioned.fill(
                        child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            print(postID);
                            showModalBottomSheet(
                                backgroundColor: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                //isScrollControlled:true,
                                context: context,
                                builder: (BuildContext bc) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: qualitiesList.qualities.length,
                                      itemBuilder: (content, index) {
                                        return VideoQualityCard(
                                          defaultQuality: quality,
                                          onTap: () async {
                                            Navigator.pop(context);
                                            var currentPosition =
                                                await flickManager
                                                    .flickVideoManager!
                                                    .videoPlayerController!
                                                    .position;

                                            setState(() {
                                              video = qualitiesList
                                                  .qualities[index].video;
                                              quality = qualitiesList
                                                  .qualities[index].quality;
                                              isDisposed = true;
                                            });

                                            Timer(Duration(seconds: 1),
                                                () async {
                                              flickManager.flickVideoManager!
                                                  .dispose();
                                              setState(() {
                                                flickManager = new FlickManager(
                                                  autoPlay: false,
                                                  autoInitialize: false,
                                                  videoPlayerController:
                                                      VideoPlayerController
                                                          .network(video),
                                                );
                                                isDisposed = false;
                                              });
                                              await flickManager
                                                  .flickVideoManager!
                                                  .videoPlayerController!
                                                  .initialize();
                                              flickManager.flickControlManager!
                                                  .seekTo(currentPosition!);
                                              flickManager.flickControlManager!
                                                  .play();
                                            });
                                          },
                                          video: widget.video!,
                                          quality:
                                              qualitiesList.qualities[index],
                                        );
                                      });
                                });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 2.0.h,
                                  right: 2.0.w,
                                  left: 2.0.w,
                                  bottom: 2.0.h),
                              child: Icon(
                                Icons.more_vert_rounded,
                                size: 3.0.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ))
                    : Container(),
                showControl == true
                    ? BackwardSeek10s(
                        backwardSeek: () async {
                          print(flickManager
                              .flickDisplayManager!.showPlayerControls);
                          Duration? time = await flickManager.flickVideoManager!
                              .videoPlayerController!.position;
                          if (time! > Duration(seconds: 10)) {
                            time = time - Duration(seconds: 10);
                          } else {
                            time = Duration(seconds: 0);
                          }

                          flickManager.flickVideoManager!.videoPlayerController!
                              .seekTo(time);
                        },
                      )
                    : Container(),
                showControl == true
                    ? ForwardSeek10s(
                        forwardSeek: () async {
                          print(flickManager
                              .flickDisplayManager!.showPlayerControls);
                          Duration? time = await flickManager.flickVideoManager!
                              .videoPlayerController!.position;
                          time = time! + Duration(seconds: 10);
                          flickManager.flickVideoManager!.videoPlayerController!
                              .seekTo(time);
                        },
                      )
                    : Container(),
              ],
            ),
    );
  }
}
