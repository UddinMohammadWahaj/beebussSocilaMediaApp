import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_ads_model.dart';
import 'package:bizbultest/models/video_quality_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/utilities/simple_web_view.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/expanded_video_player_controller.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/quality_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:bizbultest/models/autoplay_video_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'dart:math' as math;
import 'package:bizbultest/models/video_comments_model.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_actions.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_comment_card.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_seek_controls.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/video_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:wakelock/wakelock.dart';
import '../autoplay_video_card.dart';
import 'custom_video_controls.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class ExpandedVideoPlayer extends StatefulWidget {
  final VideoListModelData video;
  final bool showFullPlayer;
  final VoidCallback onPressHide;
  final VoidCallback expand;
  final VoidCallback onPress;
  final Function copied;
  final VideoAds? adsList;
  final Function rebuzed;

  Function onPop;
  ExpandedVideoPlayer({
    Key? key,
    required this.onPop,
    required this.showFullPlayer,
    required this.video,
    required this.onPressHide,
    required this.expand,
    required this.onPress,
    required this.copied,
    this.adsList,
    required this.rebuzed,
  }) : super(key: key);

  @override
  _ExpandedVideoPlayerState createState() => _ExpandedVideoPlayerState();
}

class _ExpandedVideoPlayerState extends State<ExpandedVideoPlayer> {
  var expandedcontroller = Get.put(ExpandedVideoPlayerController());
  late FlickManager flickManager;
  late Qualities qualitiesList;
  bool areQualitiesLoaded = false;
  late VideoComments commentList;
  bool areCommentsLoaded = false;
  bool isDisposed = false;
  String firstComment = "";
  String firstUserIcon = "";
  late AutoPlayVideos videoList;
  bool areVideosLoaded = false;
  bool showAllComments = false;
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
  bool isLandscape = false;
  TextEditingController _controller = TextEditingController();
  var likeStatus;
  var dislikeStatus;
  var followStatus;
  var thumbnail;
  var userID;
  bool isReply = false;
  var isBannerAd = false;
  var isBannerNull = true;
  var bannerAdImage = '';
  var bannerAdUrl = '';
  var bannerAdButton = '';
  var embedData;
  var quality;
  late Duration currentPosition;
  bool skipIn = false;
  bool skipAd = false;
  bool skipped = false;
  late bool isAddPlaying;
  List<int> adArray = [
    6,
    16,
    26,
    36,
    46,
    56,
    66,
    76,
    86,
    96,
    106,
    116,
    126,
    136
  ];
  int adIndex = 0;
  Duration positionAfterAd = new Duration(seconds: 0);

  RefreshController _videoRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController _commentsRefreshController =
      RefreshController(initialRefresh: false);

  TextEditingController _embedController = TextEditingController();

  List<String> previousIDs = [];

  //! api updated
  Future<void> postMainComment(String comment) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postCommentAdd?action=write_comment_data&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comments=$comment&post_type=Video";

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
      setState(() {});
    }
  }

  //! api updated
  Future<void> postSubComment(String comment, String commentID) async {
    var url =
        "https://www.bebuzee.com/api/post_sub_comment.php?action=reply_to_main_comment&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comments=$comment&comment_id=$commentID&post_type=Video";
    print("post sub commenturl=${url}");
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
    print("post sub comment response=${response.data}");
    print(response.data);
    if (response.statusCode == 200) {
      setState(() {
        getComments();
      });
    }
  }

  void playAd() {
    setState(() {
      flickManager = FlickManager(
          autoPlay: true,
          autoInitialize: false,
          videoPlayerController: VideoPlayerController.network(
              widget.adsList!.ads[adIndex].video!));
    });
  }

  Future<void> getComments() async {
    var newurl =
        'https://www.bebuzee.com/api/post_comment_data?action=video_page_comment_data&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comment_ids=&post_type=Video';
    var response = await ApiProvider().fireApi(newurl);
    print("get comment url =$newurl");
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=video_page_comment_data&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comment_ids=");

    // var response = await http.get(url);
    try {
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "") {
        print("after post subcomment  getcomment =${response.data}");

        VideoComments commentData =
            VideoComments.fromJson(response.data['data']);
        print("after comment data big");
        if (mounted) {
          setState(() {
            firstComment = commentData.comments[0].comment!;
            firstUserIcon = commentData.comments[0].upicture!;
            commentList = commentData;
            print("Big video get comments mounted ");
            areCommentsLoaded = true;
          });
        }
      }

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          areCommentsLoaded = false;
        });
      }
    } catch (e) {
      print("comment loading catch $e");
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
    String urlStr = previousIDs.join(",");

    var newurl =
        'https://www.bebuzee.com/api/video/videoAutoList?action=video_page_autoplay_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&post_ids=$urlStr';

    print("getAutoPlaylistCalled $newurl");

    var response = await ApiProvider().fireApi(newurl);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=video_page_autoplay_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&post_ids=$urlStr");

    // var response = await http.get(url);

    if (response.statusCode == 200) {
      print("Autoplay videos url=${newurl} response=${response.data}");
      AutoPlayVideos videoData = AutoPlayVideos.fromJson(response.data['data']);
      await Future.wait(videoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());
      setState(() {
        videoList = videoData;
        areVideosLoaded = true;
      });
    }
    if (response.data == null || response.statusCode != 200) {
      setState(() {
        areVideosLoaded = false;
      });
    }
  }

  Future<void> getVideoQualities(String postID) async {
    var newurl =
        'https://www.bebuzee.com/api/video_quality_list.php?action=post_resolutions&post_id=$postID';
    print("quality url=$newurl ");
    var response = await ApiProvider().fireApi(newurl);

    // var url = Uri.parse(
    //   "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=post_resolutions&post_id=$postID",
    // );

    // var response = await http.get(url);
    print("response of quality api= ${response.data}");
    if (response.statusCode == 200) {
      Qualities qualityData = Qualities.fromJson(response.data['data']);
      setState(() {
        qualitiesList = qualityData;
        areQualitiesLoaded = true;
        print("response of quality api 2 = ${response.data}");
      });
    }
    if (response.data == null || response.statusCode != 200) {
      setState(() {
        areQualitiesLoaded = false;
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
      var newurl =
          'https://www.bebuzee.com/api/video/videoAutoList?action=video_page_autoplay_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&post_ids=$urlStr';
      print('url autoplay=${newurl}');
      // var url = Uri.parse(
      //   "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=video_page_autoplay_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&post_ids=$urlStr",
      // );

      var response = await ApiProvider().fireApi(newurl);

      // var response = await http.get(url);

      print('onLoading bigvideolist =${response.data}');
      if (response.statusCode == 200) {
        AutoPlayVideos videoData =
            AutoPlayVideos.fromJson(response.data['data']);
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
      if (response.data == null || response.statusCode != 200) {
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
    } catch (e) {
      _videoRefreshController.loadComplete();
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

    if (urlStr.split(",").toList().length < widget.video.totalComments!) {
      try {
        var url =
            "https://www.bebuzee.com/api/post_comment_data?action=video_page_comment_data&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.country}&comment_ids=$urlStr";

        var response = await ApiProvider().fireApi(url);

        print("Loading comments ${response.data}");
        if (response.statusCode == 200) {
          VideoComments commentData =
              VideoComments.fromJson(response.data['data']);
          VideoComments videosTemp = commentList;
          videosTemp.comments.addAll(commentData.comments);
          setState(() {
            commentList = videosTemp;
            areCommentsLoaded = true;
          });
        }
        if (response.data == data || response.statusCode != 200) {
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
      } catch (e) {
        _commentsRefreshController.loadComplete();
      }
      _commentsRefreshController.loadComplete();
    } else {
      _commentsRefreshController.loadComplete();
    }
  }

  late int videoWidth;
  late int videoHeight;

  void setVideoAds() {
    print("set ads called ${widget.adsList}");
    if (widget.adsList != null) {
      setState(() {
        adArray.length = widget.adsList!.ads.length;
      });
      print('response of get ads array =${adArray}');
    }
  }

  Future<void> videoListenerPotrait() async {
    if (!isFullscreen) {
      print(
          'flickr position=${await flickManager.flickVideoManager!.videoPlayerController!.position}');
      if (flickManager.flickVideoManager!.isPlaying) {
        print("flickr playing");
      }
      if (flickManager.flickVideoManager!.errorInVideo) {
        print("flickr error in video");
      }

      if (flickManager.flickVideoManager!.isPlaying &&
          widget.adsList != null &&
          _start == 15) {
        print("flickr postition playing ");
        setState(() {
          skipIn = true;
          isAddPlaying = true;
        });
        print("potrait");
        startTimer("potrait");
      }

      // if (widget.adsList != null) {
      //   var currentPosition =
      //       await flickManager.flickVideoManager.videoPlayerController.position;
      //   if (currentPosition > Duration(minutes: adArray[adIndex])) {
      //     setState(() {
      //       adIndex += 1;
      //       positionAfterAd = currentPosition;
      //       isDisposed = true;
      //       showAdControls = false;
      //       isAddPlaying = false;
      //       skipIn = false;
      //       _start = 10;
      //     });

      //     Timer(Duration(seconds: 1), () async {
      //       flickManager.flickVideoManager.dispose();
      //       setState(() {
      //         flickManager = new FlickManager(
      //           autoPlay: false,
      //           autoInitialize: false,
      //           videoPlayerController: VideoPlayerController.network(
      //               widget.adsList.ads[adIndex].video),
      //         );
      //         isDisposed = false;
      //       });
      //       await flickManager.flickVideoManager.videoPlayerController
      //           .initialize();
      //       flickManager.flickControlManager.play();
      //       setState(() {
      //         skipIn = true;
      //         skipped = false;
      //       });
      //     });
      //   }
      // }

      if (flickManager.flickVideoManager!.isVideoEnded) {
        print("flickr end");
        if (!skipped && widget.adsList != null) {
          print("flickr enddddddddd");
          var currentPosition = await flickManager
              .flickVideoManager!.videoPlayerController!.position;
          setState(() {
            positionAfterAd = currentPosition!;
          });
          setState(() {
            isBannerAd = true;
            _start = 0;
            skipIn = false;
            skipped = true;
            showAdControls = true;
          });
          setState(() {
            isDisposed = true;
          });
          Timer(Duration(seconds: 1), () async {
            flickManager.flickVideoManager!.dispose();
            setState(() {
              flickManager = new FlickManager(
                autoPlay: false,
                autoInitialize: false,
                videoPlayerController: VideoPlayerController.network(video),
              );
              isDisposed = false;
            });
            print(adIndex.toString() + " after first ad");
            await flickManager.flickVideoManager!.videoPlayerController!
                .initialize();
            flickManager.flickControlManager!.seekTo(
                adIndex == 0 ? new Duration(seconds: 0) : positionAfterAd);
            flickManager.flickControlManager!.play();
          });
        } else {
          print("skippppp");
          if (mounted) {
            setState(() {
              print("videolisr= ${videoList}");

              video = videoList.videos[0].video;
              isDisposed = true;
              postID = videoList.videos[0].postId;
              username = videoList.videos[0].name;
              userImage = videoList.videos[0].userImage;
              views = videoList.videos[0].numViews;
              timestamp = videoList.videos[0].timeStamp;
              content = videoList.videos[0].postContent;
              comments = videoList.videos[0].totalComments;
              totalLikes = videoList.videos[0].numberOfLike!;
              totalDislikes = videoList.videos[0].numberOfDislike!;
              likeStatus = videoList.videos[0].likeStatus;
              userID = videoList.videos[0].userID;
              thumbnail = videoList.videos[0].image;
              followStatus = videoList.videos[0].followData;
              dislikeStatus = videoList.videos[0].dislikeStatus;
            });
          }
          Timer(Duration(seconds: 1), () {
            flickManager.flickVideoManager!.dispose();
            setState(() {
              flickManager = new FlickManager(
                videoPlayerController: VideoPlayerController.network(video),
              );
              isDisposed = false;
            });
            flickManager.flickVideoManager!.videoPlayerController!.play();
          });

          getAutoPlayList();
          getComments();
        }
      }

      if (flickManager.flickDisplayManager!.showPlayerControls) {
        setState(() {
          showControl = true;
        });
      } else {
        setState(() {
          showControl = false;
        });
      }
    }
  }

  Future<void> videoListenerPotraitTestFinal() async {
    if (!isFullscreen) {}
  }

  Future<void> videoListenerPotraitTest() async {
    // if (!isFullscreen) {
    print(
        'flickr position=${await flickManager.flickVideoManager!.videoPlayerController!.position} ${widget.video.postId}');
    if (flickManager.flickVideoManager!.isPlaying &&
        widget.adsList != null &&
        _start == 15) {
      print("flickr postition playing and advertisement");
      setState(() {
        skipIn = true;
        isAddPlaying = true;
      });
      print("potrait");
      startTimer("potrait");
    }

    // if (widget.adsList != null) {
    //   var currentPosition =
    //       await flickManager.flickVideoManager.videoPlayerController.position;

    //   if (currentPosition > Duration(minutes: adArray[adIndex])) {
    //     print(
    //         "current pos of video =${currentPosition} && ad pos= ${Duration(minutes: adArray[adIndex])}");
    //     setState(() {
    //       adIndex += 1;
    //       positionAfterAd = currentPosition;
    //       isDisposed = true;
    //       showAdControls = false;
    //       isAddPlaying = false;
    //       skipIn = false;
    //       _start = 10;
    //     });

    //     Timer(Duration(seconds: 1), () async {
    //       flickManager.flickVideoManager.dispose();
    //       setState(() {
    //         flickManager = new FlickManager(
    //           autoPlay: false,
    //           autoInitialize: false,
    //           videoPlayerController: VideoPlayerController.network(
    //               widget.adsList.ads[adIndex].video),
    //         );
    //         isDisposed = false;
    //       });
    //       await flickManager.flickVideoManager.videoPlayerController
    //           .initialize();
    //       flickManager.flickControlManager.play();
    //       setState(() {
    //         skipIn = true;
    //         skipped = false;
    //       });
    //     });
    //   }
    // }
    if (flickManager.flickVideoManager!.isVideoInitialized) {
      print("flickr initialised already");
      // flickManager.flickControlManager.play();
    } else {
      setState(() {
        flickManager = FlickManager(
            videoPlayerController: VideoPlayerController.network(video));
      });
    }

    if (flickManager.flickVideoManager!.isPlaying) {
      print("flickr playing");
    } else {
      print("flickr paused");
    }
    if (flickManager.flickVideoManager!.errorInVideo) {
      print("flickr error in video ${widget.video.video}");
    }
    // if (flickManager.flickVideoManager.isVideoEnded) {
    //   //Switching from ad to video and vice versa
    //   if (expandedcontroller.type.value == "video") {
    //     expandedcontroller.type.value = 'ad';
    //   } else
    //     expandedcontroller.type.value = 'video';
    //   if (expandedcontroller.type.value == 'video') {
    //     setState(() {
    //       _start = 0;
    //       skipIn = false;
    //       skipped = true;
    //       showAdControls = true;
    //       Timer(Duration(seconds: 0), () async {
    //         flickManager.flickVideoManager.dispose();
    //         setState(() {
    //           flickManager = new FlickManager(
    //             videoPlayerController: VideoPlayerController.network(video),
    //           );
    //           isDisposed = false;

    //           print("position after ad=${positionAfterAd}");
    //         });

    //         flickManager.flickControlManager.play();
    //       });
    //     });
    //   } else {
    //     setState(() {
    //       _start = 15;
    //       skipIn = true;
    //       skipped = false;
    //       showAdControls = false;
    //     });
    //     Timer(Duration(seconds: 1), () {
    //       setState(() {
    //         flickManager = new FlickManager(
    //           videoPlayerController: VideoPlayerController.network(
    //               widget.adsList != null ? widget.adsList.ads[0].video : video),
    //         );
    //         isDisposed = false;
    //       });

    //       flickManager.flickVideoManager.videoPlayerController.play();
    //     });
    //   }
    // }

    // if (flickManager.flickVideoManager.isVideoEnded) {
    //   if (expandedcontroller.type.value == 'video') {
    //     //End of a normal video then start ad,
    //     print("expanded type=${expandedcontroller.type.value} ${video}");
    //     expandedcontroller.type.value = 'ad';
    //     setState(() {
    //       isAddPlaying = false;
    //       print("skip ad here");
    //       setState(() {
    //         _start = 0;
    //         skipIn = false;
    //         skipped = true;

    //         showAdControls = true;
    //         _timer.cancel();
    //       });
    //       setState(() {
    //         isDisposed = true;
    //       });
    //       Timer(Duration(seconds: 0), () async {
    //         flickManager.flickVideoManager.dispose();
    //         setState(() {
    //           flickManager = new FlickManager(
    //             videoPlayerController: VideoPlayerController.network(video),
    //           );
    //           isDisposed = false;

    //           print("position after ad=${positionAfterAd}");
    //         });

    //         flickManager.flickControlManager.play();
    //       });
    //     });

    //     return;
    //   } else {
    //     print("expanded typee=${expandedcontroller.type.value}");
    //     expandedcontroller.type.value = 'video';

    //     setState(() {
    //       isAddPlaying = false;
    //       print("skip ad here");
    //       setState(() {
    //         _start = 0;
    //         skipIn = false;
    //         skipped = true;

    //         showAdControls = true;
    //         _timer.cancel();
    //       });
    //       setState(() {
    //         isDisposed = true;
    //       });
    //       Timer(Duration(seconds: 0), () async {
    //         flickManager.flickVideoManager.dispose();
    //         setState(() {
    //           flickManager = new FlickManager(
    //             videoPlayerController: VideoPlayerController.network(video),
    //           );
    //           isDisposed = false;

    //           print("position after ad=${positionAfterAd}");
    //         });

    //         flickManager.flickControlManager.play();
    //       });
    //     });
    //   }

    //   //start video
    //   previousIDs.add(postID.toString());
    //   setState(() {
    //     if (widget.adsList != null) {
    //       _start = 15;
    //       skipIn = true;
    //       skipped = false;
    //     } else {
    //       _start = 0;
    //       skipIn = false;
    //       skipped = true;
    //       showAdControls = true;

    //       print("ads showcontrol test");
    //     }
    //     // getVideoQualities(
    //     //     videoList
    //     //         .videos[index]
    //     //         .postId);

    //     video = videoList.videos[0].video;
    //     isDisposed = true;
    //     shareUrl = videoList.videos[0].shareUrl;
    //     postID = videoList.videos[0].postId;
    //     username = videoList.videos[0].name;
    //     userImage = videoList.videos[0].userImage;
    //     views = videoList.videos[0].numViews;
    //     timestamp = videoList.videos[0].timeStamp;
    //     content = videoList.videos[0].postContent;
    //     comments = videoList.videos[0].totalComments;
    //     totalLikes = videoList.videos[0].numberOfLike;
    //     totalDislikes = videoList.videos[0].numberOfDislike;
    //     likeStatus = videoList.videos[0].likeStatus;
    //     userID = videoList.videos[0].userID;
    //     thumbnail = videoList.videos[0].image;
    //     followStatus = videoList.videos[0].followData;
    //     dislikeStatus = videoList.videos[0].dislikeStatus;
    //     quality = videoList.videos[0].quality;
    //   });
    //   Timer(Duration(seconds: 1), () {
    //     setState(() {
    //       flickManager = new FlickManager(
    //         videoPlayerController: VideoPlayerController.network(
    //             widget.adsList != null ? widget.adsList.ads[0].video : video),
    //       );
    //       isDisposed = false;
    //       if (widget.adsList != null)
    //         showAdControls = false;
    //       else
    //         showAdControls = true;
    //     });

    //     flickManager.flickVideoManager.videoPlayerController.play();
    //   });
    //   getAutoPlayList();
    //   getComments();
    // }
//Commented for testing
    // if (flickManager.flickVideoManager.isVideoEnded) {
    //   if (widget.adsList != null) {
    //     //IF ad ends
    //     if (!skipped && _start == 0) {
    //       print("skipped prev");

    //       setState(() {
    //         isAddPlaying = false;
    //         print("skip ad here");
    //         setState(() {
    //           _start = 0;
    //           skipIn = false;
    //           skipped = true;
    //           showControl = true;
    //           showAdControls = false;
    //           _timer.cancel();
    //         });
    //         print("i am here ad magia ahare");
    //         setState(() {
    //           isDisposed = true;
    //         });
    //         Timer(Duration(seconds: 0), () async {
    //           flickManager.flickVideoManager.dispose();
    //           setState(() {
    //             print("this is auto play");
    //             print(
    //                 "skip ad current vide=$video show fullplayer=${widget.showFullPlayer}");
    //             flickManager = new FlickManager(
    //               // autoPlay: false,
    //               // autoInitialize: true,
    //               videoPlayerController: VideoPlayerController.network(video),
    //             );
    //             isDisposed = false;
    //           });

    //           flickManager.flickControlManager.play();
    //         });
    //       });
    //     } else {
    //       previousIDs.add(postID.toString());
    //       print("i am here ad magia af");
    //       setState(() {
    //         _start = 15;
    //         skipIn = true;
    //         skipped = false;
    //         showAdControls = true;
    //         showControl = false;
    //         startTimer('potrait');
    //         // getVideoQualities(
    //         //     videoList
    //         //         .videos[index]
    //         //         .postId);

    //         video = videoList.videos[0].video;
    //         isDisposed = true;
    //         shareUrl = videoList.videos[0].shareUrl;
    //         postID = videoList.videos[0].postId;
    //         username = videoList.videos[0].name;
    //         userImage = videoList.videos[0].userImage;
    //         views = videoList.videos[0].numViews;
    //         timestamp = videoList.videos[0].timeStamp;
    //         content = videoList.videos[0].postContent;
    //         comments = videoList.videos[0].totalComments;
    //         totalLikes = videoList.videos[0].numberOfLike;
    //         totalDislikes = videoList.videos[0].numberOfDislike;
    //         likeStatus = videoList.videos[0].likeStatus;
    //         userID = videoList.videos[0].userID;
    //         thumbnail = videoList.videos[0].image;
    //         followStatus = videoList.videos[0].followData;
    //         dislikeStatus = videoList.videos[0].dislikeStatus;
    //         quality = videoList.videos[0].quality;
    //       });
    //       print("i am here ad magia");
    //       Timer(Duration(seconds: 0), () {
    //         setState(() {
    //           flickManager = new FlickManager(
    //             videoPlayerController: VideoPlayerController.network(
    //                 widget.adsList != null
    //                     ? widget.adsList.ads[0].video
    //                     : video),
    //           );

    //           isDisposed = false;
    //           if (widget.adsList != null)
    //             showAdControls = false;
    //           else
    //             showAdControls = true;
    //         });

    //         flickManager.flickVideoManager.videoPlayerController.play();
    //       });
    //       getAutoPlayList();
    //       getComments();
    //     }
    //   } else {
    //     // previousIDs.add(postID.toString());
    //     // setState(() {
    //     //   if (widget.adsList != null) {
    //     //     _start = 15;
    //     //     skipIn = true;
    //     //     skipped = false;
    //     //   } else {
    //     //     _start = 0;
    //     //     skipIn = false;
    //     //     skipped = true;
    //     //     showAdControls = true;

    //     //     print("ads showcontrol test");
    //     //   }
    //     //   // getVideoQualities(
    //     //   //     videoList
    //     //   //         .videos[index]
    //     //   //         .postId);

    //     //   video = videoList.videos[0].video;
    //     //   isDisposed = true;
    //     //   shareUrl = videoList.videos[0].shareUrl;
    //     //   postID = videoList.videos[0].postId;
    //     //   username = videoList.videos[0].name;
    //     //   userImage = videoList.videos[0].userImage;
    //     //   views = videoList.videos[0].numViews;
    //     //   timestamp = videoList.videos[0].timeStamp;
    //     //   content = videoList.videos[0].postContent;
    //     //   comments = videoList.videos[0].totalComments;
    //     //   totalLikes = videoList.videos[0].numberOfLike;
    //     //   totalDislikes = videoList.videos[0].numberOfDislike;
    //     //   likeStatus = videoList.videos[0].likeStatus;
    //     //   userID = videoList.videos[0].userID;
    //     //   thumbnail = videoList.videos[0].image;
    //     //   followStatus = videoList.videos[0].followData;
    //     //   dislikeStatus = videoList.videos[0].dislikeStatus;
    //     //   quality = videoList.videos[0].quality;
    //     // });
    //     // Timer(Duration(seconds: 1), () {
    //     //   setState(() {
    //     //     flickManager = new FlickManager(
    //     //       videoPlayerController: VideoPlayerController.network(
    //     //           widget.adsList != null ? widget.adsList.ads[0].video : video),
    //     //     );
    //     //     isDisposed = false;
    //     //   });

    //     //   flickManager.flickVideoManager.videoPlayerController.play();
    //     // });
    //     // getAutoPlayList();
    //     // getComments();
    //   }
    // }
    //--------------------
    if (flickManager.flickVideoManager!.isVideoEnded) {
      // flickManager.flickVideoManager.dispose();
      print("change video called");

      if (widget.adsList != null && !skipped) {
        print("didnot skipp the previous");
        if (isAddPlaying) {
          setState(() {
            isAddPlaying = false;
            print("skip ad here");
            setState(() {
              _start = 0;
              skipIn = false;
              skipped = true;

              showAdControls = true;
              _timer.cancel();
            });
            setState(() {
              isDisposed = true;
            });
            Timer(Duration(seconds: 0), () async {
              flickManager.flickVideoManager!.dispose();
              setState(() {
                print("this is auto play");
                print(
                    "skip ad current vide=$video show fullplayer=${widget.showFullPlayer}");
                // flickManager
                //     .handleChangeVideo(
                //         VideoPlayerController
                //             .network(video),
                //         videoChangeDuration:
                //             positionAfterAd);

                flickManager = new FlickManager(
                  // autoPlay: false,
                  // autoInitialize: true,
                  videoPlayerController: VideoPlayerController.network(video
                      // 'https://www.bebuzee.com/images/profile/wall-videos/2017_12_14_15_07_21_main.mp4'
                      // 'https://www.bebuzee.com/images/profile/wall-videos/m3u8/2017_12_14_15_07_21_main.m3u8'
                      ),
                );
                isDisposed = false;

                print("position after ad=${positionAfterAd}");
                // flickManager
                //     .flickControlManager
                //     .seekTo(positionAfterAd);
                // flickManager
                //     .flickControlManager
                //     .play();
              });
              // await flickManager
              //     .flickVideoManager
              //     .videoPlayerController
              //     .initialize();
              // flickManager.flickControlManager
              //     .seekTo(positionAfterAd);
              flickManager.flickControlManager!.play();
            });
          });
        } else {}
        return;
      } else {
        print("skipp the previous");
      }
      previousIDs.add(postID.toString());
      setState(() {
        if (widget.adsList != null) {
          _start = 15;
          skipIn = true;
          skipped = false;
        } else {
          _start = 0;
          skipIn = false;
          skipped = true;
          showAdControls = true;

          print("ads showcontrol test");
        }
        // getVideoQualities(
        //     videoList
        //         .videos[index]
        //         .postId);

        video = videoList.videos[0].video;
        isDisposed = true;
        shareUrl = videoList.videos[0].shareUrl!;
        postID = videoList.videos[0].postId;
        username = videoList.videos[0].name;
        userImage = videoList.videos[0].userImage;
        views = videoList.videos[0].numViews;
        timestamp = videoList.videos[0].timeStamp;
        content = videoList.videos[0].postContent;
        comments = videoList.videos[0].totalComments;
        totalLikes = videoList.videos[0].numberOfLike!;
        totalDislikes = videoList.videos[0].numberOfDislike!;
        likeStatus = videoList.videos[0].likeStatus;
        userID = videoList.videos[0].userID;
        thumbnail = videoList.videos[0].image;
        followStatus = videoList.videos[0].followData;
        dislikeStatus = videoList.videos[0].dislikeStatus;
        quality = videoList.videos[0].quality;
      });
      Timer(Duration(seconds: 1), () {
        setState(() {
          flickManager = new FlickManager(
            videoPlayerController: VideoPlayerController.network(
                widget.adsList != null ? widget.adsList!.ads[0].video : video),
          );
          isDisposed = false;
          if (widget.adsList != null)
            showAdControls = false;
          else
            showAdControls = true;
        });

        flickManager.flickVideoManager!.videoPlayerController!.play();
      });
      getAutoPlayList();
      getComments();
    }

    if (flickManager.flickDisplayManager!.showPlayerControls) {
      setState(() {
        showControl = true;
      });
    } else {
      setState(() {
        showControl = false;
      });
    }
    //-------------------------------------------------------------------------
    // }
  }

  Future<void> videoListenerLandscapeTest() async {
    if (isFullscreen) {
      // print("fullscreen here");
      // print(
      //     'flickr position=${await flickManager.flickVideoManager.videoPlayerController.position} ${widget.video.postId}');
      if (flickManager.flickVideoManager!.isPlaying &&
          widget.adsList != null &&
          _start == 15) {
        print("flickr postition playing and advertisement landscape");

        setState(() {
          skipIn = true;
          isAddPlaying = true;
        });
        print("potrait");
        startTimer("potrait");
      }

      // if (widget.adsList != null) {
      //   var currentPosition =
      //       await flickManager.flickVideoManager.videoPlayerController.position;

      //   if (currentPosition > Duration(minutes: adArray[adIndex])) {
      //     print(
      //         "current pos of video =${currentPosition} && ad pos= ${Duration(minutes: adArray[adIndex])}");
      //     setState(() {
      //       adIndex += 1;
      //       positionAfterAd = currentPosition;
      //       isDisposed = true;
      //       showAdControls = false;
      //       isAddPlaying = false;
      //       skipIn = false;
      //       _start = 10;
      //     });

      //     Timer(Duration(seconds: 1), () async {
      //       flickManager.flickVideoManager.dispose();
      //       setState(() {
      //         flickManager = new FlickManager(
      //           autoPlay: false,
      //           autoInitialize: false,
      //           videoPlayerController: VideoPlayerController.network(
      //               widget.adsList.ads[adIndex].video),
      //         );
      //         isDisposed = false;
      //       });
      //       await flickManager.flickVideoManager.videoPlayerController
      //           .initialize();
      //       flickManager.flickControlManager.play();
      //       setState(() {
      //         skipIn = true;
      //         skipped = false;
      //       });
      //     });
      //   }
      // }
      if (flickManager.flickVideoManager!.isVideoInitialized) {
        print("fullscreen here initialised already");
        // flickManager.flickControlManager.play();
      } else {
        print("skip ad video again ${video} ");
        setState(() {
          flickManager = FlickManager(
              videoPlayerController: VideoPlayerController.network(video));
        });
      }

      if (flickManager.flickVideoManager!.isPlaying) {
        print("fullscreen here playing ${video}");
      } else {
        print("fullscreen here playing paused");
      }
      if (flickManager.flickVideoManager!.errorInVideo) {
        print("fullscreen here in video ${widget.video.video}");
      }

      if (flickManager.flickVideoManager!.isVideoEnded) {
        // flickManager.flickVideoManager.dispose();
        print("video end landscape");

        if (widget.adsList != null && !skipped) {
          print("landscape skip is false");
          if (isAddPlaying) {
            setState(() {
              isAddPlaying = false;
              print("skip ad here");
              setState(() {
                _start = 0;
                skipIn = false;
                skipped = true;

                showAdControls = true;
                _timer.cancel();
              });
              setState(() {
                isDisposed = true;
              });
              Timer(Duration(seconds: 0), () async {
                flickManager.flickVideoManager!.dispose();
                setState(() {
                  print("this is auto play landscape ");
                  print("skip ad current vide=$video landscape");
                  // flickManager
                  //     .handleChangeVideo(
                  //         VideoPlayerController
                  //             .network(video),
                  //         videoChangeDuration:
                  //             positionAfterAd);

                  flickManager = new FlickManager(
                    // autoPlay: false,
                    // autoInitialize: true,
                    videoPlayerController: VideoPlayerController.network(video
                        // 'https://www.bebuzee.com/images/profile/wall-videos/2017_12_14_15_07_21_main.mp4'
                        // 'https://www.bebuzee.com/images/profile/wall-videos/m3u8/2017_12_14_15_07_21_main.m3u8'
                        ),
                  );
                  isDisposed = false;
                  print("position after ad=${positionAfterAd}");
                  // flickManager
                  //     .flickControlManager
                  //     .seekTo(positionAfterAd);
                  // flickManager
                  //     .flickControlManager
                  //     .play();
                });
                // await flickManager
                //     .flickVideoManager
                //     .videoPlayerController
                //     .initialize();
                // flickManager.flickControlManager
                //     .seekTo(positionAfterAd);
                flickManager.flickControlManager!.play();
              });
            });
          }
          return;
        }
        previousIDs.add(postID.toString());
        setState(() {
          if (widget.adsList != null) {
            print("skipped ad ladscape start-15 to play");
            _start = 15;
            skipIn = true;
            skipped = false;
          } else {
            _start = 0;
            skipIn = false;
            skipped = true;
            showAdControls = true;

            print("ads showcontrol test");
          }
          // getVideoQualities(
          //     videoList
          //         .videos[index]
          //         .postId);

          video = videoList.videos[0].video;
          isDisposed = true;
          shareUrl = videoList.videos[0].shareUrl!;
          postID = videoList.videos[0].postId;
          username = videoList.videos[0].name;
          userImage = videoList.videos[0].userImage;
          views = videoList.videos[0].numViews;
          timestamp = videoList.videos[0].timeStamp;
          content = videoList.videos[0].postContent;
          comments = videoList.videos[0].totalComments;
          totalLikes = videoList.videos[0].numberOfLike!;
          totalDislikes = videoList.videos[0].numberOfDislike!;
          likeStatus = videoList.videos[0].likeStatus;
          userID = videoList.videos[0].userID;
          thumbnail = videoList.videos[0].image;
          followStatus = videoList.videos[0].followData;
          dislikeStatus = videoList.videos[0].dislikeStatus;
          quality = videoList.videos[0].quality;
        });
        Timer(Duration(seconds: 1), () {
          setState(() {
            flickManager = new FlickManager(
              videoPlayerController: VideoPlayerController.network(
                  widget.adsList != null
                      ? widget.adsList!.ads[0].video
                      : video),
            );
            isDisposed = false;
            if (widget.adsList != null)
              showAdControls = false;
            else
              showAdControls = true;
          });

          flickManager.flickVideoManager!.videoPlayerController!.play();
        });
        getAutoPlayList();
        getComments();
      }

      if (flickManager.flickDisplayManager!.showPlayerControls) {
        setState(() {
          showControl = true;
        });
      } else {
        setState(() {
          showControl = false;
        });
      }
    }
  }

  Future<void> videoListenerLandscape() async {
    if (isFullscreen) {
      print("full screen");
      print(await flickManager
          .flickVideoManager!.videoPlayerController!.position);
      // if (flickManager.flickVideoManager.isPlaying &&
      //     widget.adsList != null &&
      //     _start == 15) {
      //   setState(() {
      //     skipIn = true;
      //     isAddPlaying = true;
      //   });
      //   print("landscape");
      //   startTimer("landscape");
      // }
      // // var currentPosition =
      // //     await flickManager.flickVideoManager.videoPlayerController.position;

      // if (currentPosition > Duration(minutes: adArray[adIndex])) {
      //   print(adIndex.toString() + " INDEXXX");
      //   setState(() {
      //     adIndex += 1;
      //     positionAfterAd = currentPosition;
      //     isDisposed = true;
      //     showAdControls = false;
      //     isAddPlaying = false;
      //     skipIn = false;
      //     _start = 15;
      //   });
      //   // print(adIndex);
      //   // print(widget.adsList.ads.length);
      //   Timer(Duration(seconds: 1), () async {
      //     flickManager.flickVideoManager.dispose();
      //     setState(() {
      //       flickManager = new FlickManager(
      //         autoPlay: false,
      //         autoInitialize: false,
      //         videoPlayerController: VideoPlayerController.network(
      //             widget.adsList.ads[adIndex].video),
      //       );
      //       isDisposed = false;
      //     });
      //     await flickManager.flickVideoManager.videoPlayerController
      //         .initialize();
      //     flickManager.flickControlManager.play();
      //     setState(() {
      //       skipIn = true;
      //       skipped = false;
      //     });
      //     //startTimer();
      //   });
      // }
      if (flickManager.flickVideoManager!.isPlaying &&
          widget.adsList != null &&
          _start == 15) {
        print("flickr postition landscape playing and advertisement");
        setState(() {
          skipIn = true;
          isAddPlaying = true;
        });
        print("potrait");
        startTimer("potrait");
      }
      if (flickManager.flickVideoManager!.isPlaying) {
        print("listen again full playing");
      }
      if (flickManager.flickVideoManager!.isVideoEnded) {
        if (widget.adsList != null && !skipped) {
          if (isAddPlaying) {
            setState(() {
              isAddPlaying = false;
              print("skip ad here");
              setState(() {
                _start = 0;
                skipIn = false;
                skipped = true;

                showAdControls = true;
                _timer.cancel();
              });
              setState(() {
                isDisposed = true;
              });
              Timer(Duration(seconds: 0), () async {
                flickManager.flickVideoManager!.dispose();
                setState(() {
                  print("this is auto play");
                  print("skip ad current vide=$video");
                  // flickManager
                  //     .handleChangeVideo(
                  //         VideoPlayerController
                  //             .network(video),
                  //         videoChangeDuration:
                  //             positionAfterAd);

                  flickManager = new FlickManager(
                    // autoPlay: false,
                    // autoInitialize: true,
                    videoPlayerController: VideoPlayerController.network(video
                        // 'https://www.bebuzee.com/images/profile/wall-videos/2017_12_14_15_07_21_main.mp4'
                        // 'https://www.bebuzee.com/images/profile/wall-videos/m3u8/2017_12_14_15_07_21_main.m3u8'
                        ),
                  );
                  isDisposed = false;
                  print("position after ad=${positionAfterAd}");
                  // flickManager
                  //     .flickControlManager
                  //     .seekTo(positionAfterAd);
                  // flickManager
                  //     .flickControlManager
                  //     .play();
                });
                // await flickManager
                //     .flickVideoManager
                //     .videoPlayerController
                //     .initialize();
                // flickManager.flickControlManager
                //     .seekTo(positionAfterAd);
                flickManager.flickControlManager!.play();
              });
            });
          } else {}
          return;
        }
        previousIDs.add(postID.toString());
        setState(() {
          if (widget.adsList != null) {
            _start = 15;
            skipIn = true;
            skipped = false;
          } else {
            _start = 0;
            skipIn = false;
            skipped = true;
            showAdControls = true;

            print("ads showcontrol test");
          }
          // getVideoQualities(
          //     videoList
          //         .videos[index]
          //         .postId);

          video = videoList.videos[0].video;
          isDisposed = true;
          shareUrl = videoList.videos[0].shareUrl!;
          postID = videoList.videos[0].postId;
          username = videoList.videos[0].name;
          userImage = videoList.videos[0].userImage;
          views = videoList.videos[0].numViews;
          timestamp = videoList.videos[0].timeStamp;
          content = videoList.videos[0].postContent;
          comments = videoList.videos[0].totalComments;
          totalLikes = videoList.videos[0].numberOfLike!;
          totalDislikes = videoList.videos[0].numberOfDislike!;
          likeStatus = videoList.videos[0].likeStatus;
          userID = videoList.videos[0].userID;
          thumbnail = videoList.videos[0].image;
          followStatus = videoList.videos[0].followData;
          dislikeStatus = videoList.videos[0].dislikeStatus;
          quality = videoList.videos[0].quality;
        });
        Timer(Duration(seconds: 1), () {
          setState(() {
            flickManager = new FlickManager(
              videoPlayerController: VideoPlayerController.network(
                  widget.adsList != null
                      ? widget.adsList!.ads[0].video
                      : video),
            );
            isDisposed = false;
            if (widget.adsList != null)
              showAdControls = false;
            else
              showAdControls = true;
          });

          flickManager.flickVideoManager!.videoPlayerController!.play();
        });
        getAutoPlayList();
        getComments();

        // print("video ended");
        // if (!skipped) {
        //   var currentPosition = await flickManager
        //       .flickVideoManager.videoPlayerController.position;
        //   setState(() {
        //     positionAfterAd = currentPosition;
        //   });
        //   setState(() {
        //     _start = 0;
        //     skipIn = false;
        //     skipped = true;
        //     showAdControls = true;
        //   });
        //   setState(() {
        //     isDisposed = true;
        //   });
        //   Timer(Duration(seconds: 1), () async {
        //     flickManager.flickVideoManager.dispose();
        //     setState(() {
        //       flickManager = new FlickManager(
        //         autoPlay: false,
        //         autoInitialize: false,
        //         videoPlayerController: VideoPlayerController.network(video),
        //       );
        //       isDisposed = false;
        //     });
        //     print(adIndex.toString() + " after first ad");
        //     await flickManager.flickVideoManager.videoPlayerController
        //         .initialize();
        //     flickManager.flickControlManager.seekTo(
        //         adIndex == 0 ? new Duration(seconds: 0) : positionAfterAd);
        //     flickManager.flickControlManager.play();
        //   });
        // } else {
        //   if (mounted) {
        //     setState(() {
        //       video = videoList.videos[0].video;
        //       isDisposed = true;
        //       postID = videoList.videos[0].postId;
        //       username = videoList.videos[0].name;
        //       userImage = videoList.videos[0].userImage;
        //       views = videoList.videos[0].numViews;
        //       timestamp = videoList.videos[0].timeStamp;
        //       content = videoList.videos[0].postContent;
        //       comments = videoList.videos[0].totalComments;
        //       totalLikes = videoList.videos[0].numberOfLike;
        //       totalDislikes = videoList.videos[0].numberOfDislike;
        //       likeStatus = videoList.videos[0].likeStatus;
        //       userID = videoList.videos[0].userID;
        //       thumbnail = videoList.videos[0].image;
        //       followStatus = videoList.videos[0].followData;
        //       dislikeStatus = videoList.videos[0].dislikeStatus;

        //       print(
        //           "videoka 2 quality = $quality videoWidth =${videoWidth}   videoHeight =$videoHeight  _embedController =$_embedController  postID = $postID  content = $content  video = $video  username =$username \n  userImage =$userImage \n   views = $views \n  timestamp = $timestamp \n    comments = $comments \n    totalDislikes = $totalDislikes \n   totalLikes = $totalLikes \n  shareUrl = $shareUrl \n likeStatus = $likeStatus \n  dislikeStatus =$dislikeStatus \n followStatus = $followStatus \n userID = $userID videofollowstatus=${widget.video.followStatus}}");
        //     });
        //   }
        //   Timer(Duration(seconds: 1), () {
        //     flickManager.flickVideoManager.dispose();
        //     setState(() {
        //       flickManager = new FlickManager(
        //         videoPlayerController: VideoPlayerController.network(video),
        //       );
        //       isDisposed = false;
        //     });
        //     flickManager.flickVideoManager.videoPlayerController.play();
        //   });

        //   getAutoPlayList();
        //   getComments();
        // }
      }

      if (flickManager.flickDisplayManager!.showPlayerControls) {
        setState(() {
          showControl = true;
        });
      } else {
        setState(() {
          showControl = false;
        });
      }
    }
  }

  void getBannerAds() async {
    var url =
        'https://www.bebuzee.com/api/campaign/singleBannerAds?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}';

    var response = await ApiProvider().fireApi(url).then((value) => value);
    print("get single banner called =${response.data}");
    try {
      if (response.data['data'] != null) {
        setState(() {
          isBannerAd = true;
          isBannerNull = false;
          bannerAdImage = response.data['data']['image'];
          bannerAdButton = response.data['data']['category_val'];
          bannerAdUrl = response.data['data']['url'];
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    print(
        "Expanded video called ${widget.video.postId} ${widget.video.totalComments} thumbnaiol=${widget.video.followStatus}");
    print("expanded video ads=${widget.adsList} ads=");
    print("skip ad show=${widget.showFullPlayer}");
    Wakelock.enable();
    checkWaleLock();
    getBannerAds();
    setVideoAds();
    if (widget.adsList != null) {
      setState(() {
        showAdControls = false;
      });
    }
    // getVideoQualities(widget.video.postId.toString());
    setState(() {
      quality = widget.video.quality;
      videoWidth = widget.video.videoWidth!;
      videoHeight = widget.video.videoHeight!;
      _embedController = widget.video.embedController;
      postID = widget.video.postId;
      content = widget.video.postContent;
      video = widget.video.video;
      username = widget.video.name;
      userImage = widget.video.userImage;
      views = widget.video.numViews;
      timestamp = widget.video.timeStamp;
      comments = widget.video.totalComments;
      totalDislikes = widget.video.numberOfDislike!;
      totalLikes = widget.video.numberOfLike!;
      shareUrl = widget.video.shareUrl!;
      likeStatus = widget.video.likeStatus;
      dislikeStatus = widget.video.dislikeStatus;
      followStatus = widget.video.followStatus;
      userID = widget.video.userId;

      thumbnail = widget.video.image;

      print(
          "videoka quality = $quality videoWidth =${videoWidth}   videoHeight =$videoHeight  _embedController =$_embedController  postID = $postID  content = $content  video = $video  username =$username \n  userImage =$userImage \n   views = $views \n  timestamp = $timestamp \n    comments = $comments \n    totalDislikes = $totalDislikes \n   totalLikes = $totalLikes \n  shareUrl = $shareUrl \n likeStatus = $likeStatus \n  dislikeStatus =$dislikeStatus \n followStatus = $followStatus \n userID = $userID usernamevideoka=${username}");
    });
    previousIDs.add(postID.toString());
    getComments();
    data = widget.video;

    getAutoPlayList();
    print("addlist =${widget.adsList} video=${video}");

    print("flickr initstate call");
    if (widget.adsList != null) {
      expandedcontroller.type.value = 'ad';
    }
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          widget.adsList != null ? widget.adsList!.ads[0].video : video),
    );

    super.initState();
  }

  void checkWaleLock() async {
    bool wakelockEnabled = await Wakelock.enabled;
    print(wakelockEnabled.toString() + " is enables");
  }

  @override
  void dispose() {
    checkWaleLock();
    Wakelock.disable();
    checkWaleLock();
    flickManager.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  bool isFullscreen = false;
  bool showControl = false;
  bool showAdControls = true;
  late Timer _timer;
  int _start = 15;
  void startTimer(String a) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              _timer.cancel();
            });
          }
        } else {
          print("minus " + a);
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  Widget bannerAd() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  SimpleWebView(url: bannerAdUrl, heading: ''),
            ));
          },
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              height: 7.0.h,
              width: 60.0.w,
              color: Colors.black.withOpacity(0.8),
              child:
                  CachedNetworkImage(fit: BoxFit.fill, imageUrl: bannerAdImage),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isBannerAd = !isBannerAd;
            });
          },
          icon: Icon(Icons.close, color: Colors.white, size: 2.0.h),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (isFullscreen == true) {
    //   print("landscape true $skipped");
    //   SystemChrome.setEnabledSystemUIOverlays([]);
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight,
    //   ]);
    //   SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    //       statusBarColor: Colors.transparent,
    //       statusBarIconBrightness: Brightness.dark,
    //       statusBarBrightness: Brightness.dark);
    //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    //   Wakelock.enable();
    // } else {
    //   print("landscape false $skipped");
    //   SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ]);

    //   SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    //       statusBarColor: Colors.transparent,
    //       statusBarIconBrightness: Brightness.dark,
    //       statusBarBrightness: Brightness.dark);
    //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    //   Wakelock.enable();
    // }

    Wakelock.enable();

    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        print("listen again will pop");
        if (expandedcontroller.isFullscreen.value) {
          expandedcontroller.toggleFullScreen();
        }
        // if (isFullscreen) {
        //   setState(() {
        //     isFullscreen = false;
        //   });
        // }

        else {
          widget.onPop();
        }
        return false;
      },
      child: Container(
          child:

              // isFullscreen == false
              //     ?

              Obx(
        () =>
            // expandedcontroller.isFullscreen.value
            // ? Stack(
            //     children: [
            //       isDisposed == false
            //           ? Container(
            //               height: 100.0.w,
            //               width: 100.0.h,
            //               // height: expandedcontroller.isFullscreen.value
            //               //     ? 100.0.w
            //               //     : 30.0.h,
            //               // width: expandedcontroller.isFullscreen.value
            //               //     ? 100.0.h
            //               //     : 100.0.w,
            //               child: VisibilityDetector(
            //                 key: ObjectKey(flickManager),
            //                 onVisibilityChanged: (visibility) async {
            //                   if (visibility.visibleFraction == 0 &&
            //                       this.mounted) {
            //                     flickManager.flickControlManager.autoPause();
            //                   } else if (visibility.visibleFraction == 1) {
            //                     // print("flickr here is play=${}");

            //                     flickManager.flickControlManager.autoResume();

            //                     // flickManager.flickDisplayManager
            //                     //     .removeListener(() {});
            //                     flickManager.flickDisplayManager
            //                         .addListener(() async {
            //                       print("fullscreen listener added");
            //                       videoListenerPotraitTest();
            //                     });
            //                   }
            //                 },
            //                 child: AspectRatio(
            //                   aspectRatio: 16 / 9,
            //                   child: FlickVideoPlayer(
            //                     preferredDeviceOrientation: [
            //                       DeviceOrientation.landscapeRight,
            //                       DeviceOrientation.landscapeLeft
            //                     ],
            //                     wakelockEnabled: true,
            //                     wakelockEnabledFullscreen: true,
            //                     flickManager: flickManager,
            //                     flickVideoWithControls: FlickVideoWithControls(
            //                       videoFit: BoxFit.contain,
            //                       aspectRatioWhenLoading: 16 / 9,
            //                       playerLoadingFallback:
            //                           Center(child: CircularProgressIndicator()
            //                               // child: CachedNetworkImage(
            //                               //   fit: BoxFit.cover,
            //                               //   imageUrl: thumbnail,
            //                               // ),
            //                               ),
            //                       controls: showAdControls
            //                           ? PotraitControls(
            //                               forward: () async {
            //                                 print(flickManager
            //                                     .flickDisplayManager
            //                                     .showPlayerControls);
            //                                 Duration time = await flickManager
            //                                     .flickVideoManager
            //                                     .videoPlayerController
            //                                     .position;
            //                                 time = time + Duration(seconds: 10);
            //                                 flickManager.flickVideoManager
            //                                     .videoPlayerController
            //                                     .seekTo(time);
            //                                 if (expandedcontroller
            //                                         .isFullscreen.value ==
            //                                     true) {
            //                                   print("landscape true ");
            //                                   SystemChrome
            //                                       .setEnabledSystemUIOverlays(
            //                                           []);
            //                                   SystemChrome
            //                                       .setPreferredOrientations([
            //                                     DeviceOrientation.landscapeLeft,
            //                                     DeviceOrientation
            //                                         .landscapeRight,
            //                                   ]);
            //                                   SystemUiOverlayStyle
            //                                       systemUiOverlayStyle =
            //                                       SystemUiOverlayStyle(
            //                                           statusBarColor:
            //                                               Colors.transparent,
            //                                           statusBarIconBrightness:
            //                                               Brightness.dark,
            //                                           statusBarBrightness:
            //                                               Brightness.dark);
            //                                   SystemChrome
            //                                       .setSystemUIOverlayStyle(
            //                                           systemUiOverlayStyle);
            //                                   Wakelock.enable();
            //                                 }
            //                               },
            //                               backward: () async {
            //                                 print(flickManager
            //                                     .flickDisplayManager
            //                                     .showPlayerControls);
            //                                 Duration time = await flickManager
            //                                     .flickVideoManager
            //                                     .videoPlayerController
            //                                     .position;
            //                                 if (time > Duration(seconds: 10)) {
            //                                   time =
            //                                       time - Duration(seconds: 10);
            //                                 } else {
            //                                   time = Duration(seconds: 0);
            //                                 }

            //                                 flickManager.flickVideoManager
            //                                     .videoPlayerController
            //                                     .seekTo(time);
            //                               },
            //                               isFullscreen: expandedcontroller
            //                                   .isFullscreen.value,
            //                               //  isFullscreen,
            //                               fullscreen: () {
            //                                 expandedcontroller
            //                                     .toggleFullScreen();
            //                                 // setState(() {
            //                                 //   print(
            //                                 //       'skip is $skipped');
            //                                 //   isFullscreen =
            //                                 //       !isFullscreen;
            //                                 // });
            //                               })
            //                           : Container(),
            //                     ),
            //                     flickVideoWithControlsFullscreen:
            //                         FlickVideoWithControls(
            //                       willVideoPlayerControllerChange: false,
            //                       videoFit: BoxFit.contain,
            //                       controls: LandscapeControls(),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             )
            //           : Container(
            //               height: 30.0.h,
            //               width: 100.0.w,
            //               child: Center(
            //                   child: Image.network(
            //                 thumbnail,
            //                 fit: BoxFit.cover,

            //                 // errorWidget: (context, url, error) => new Icon(Icons.error),
            //               )),
            //             ),
            //       isBannerAd && !isBannerNull
            //           ? Positioned(
            //               child: bannerAd(),
            //             )
            //           : Container(),
            //       showControl == true && showAdControls
            //           ? Positioned.fill(
            //               child: Align(
            //               alignment: Alignment.topRight,
            //               child: GestureDetector(
            //                 onTap: () {
            //                   print(postID);
            //                   showModalBottomSheet(
            //                       backgroundColor: Colors.grey[900],
            //                       shape: RoundedRectangleBorder(
            //                           borderRadius: BorderRadius.only(
            //                               topLeft: const Radius.circular(20.0),
            //                               topRight:
            //                                   const Radius.circular(20.0))),
            //                       //isScrollControlled:true,
            //                       context: context,
            //                       builder: (BuildContext bc) {
            //                         return ListView.builder(
            //                             shrinkWrap: true,
            //                             itemCount:
            //                                 qualitiesList.qualities.length,
            //                             itemBuilder: (content, index) {
            //                               return VideoQualityCard(
            //                                 defaultQuality: quality,
            //                                 onTap: () async {
            //                                   Navigator.pop(context);
            //                                   var currentPosition =
            //                                       await flickManager
            //                                           .flickVideoManager
            //                                           .videoPlayerController
            //                                           .position;
            //                                   print(qualitiesList
            //                                       .qualities[index].video);
            //                                   setState(() {
            //                                     video = qualitiesList
            //                                         .qualities[index].video;
            //                                     quality = qualitiesList
            //                                         .qualities[index].quality;
            //                                     isDisposed = true;
            //                                   });

            //                                   Timer(Duration(seconds: 1),
            //                                       () async {
            //                                     flickManager.flickVideoManager
            //                                         .dispose();
            //                                     setState(() {
            //                                       flickManager =
            //                                           new FlickManager(
            //                                         autoPlay: false,
            //                                         autoInitialize: false,
            //                                         videoPlayerController:
            //                                             VideoPlayerController
            //                                                 .network(video),
            //                                       );
            //                                       isDisposed = false;
            //                                     });
            //                                     await flickManager
            //                                         .flickVideoManager
            //                                         .videoPlayerController
            //                                         .initialize();
            //                                     flickManager.flickControlManager
            //                                         .seekTo(currentPosition);
            //                                     flickManager.flickControlManager
            //                                         .play();
            //                                   });
            //                                 },
            //                                 video: widget.video,
            //                                 quality:
            //                                     qualitiesList.qualities[index],
            //                               );
            //                             });
            //                       });
            //                 },
            //                 child: Container(
            //                   color: Colors.transparent,
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         top: 2.0.h,
            //                         right: 2.0.w,
            //                         left: 2.0.w,
            //                         bottom: 2.0.h),
            //                     child: Icon(
            //                       Icons.more_vert_rounded,
            //                       size: 3.0.h,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ))
            //           : Container(),
            //       skipIn && _start != 0
            //           ? Positioned.fill(
            //               child: Align(
            //                 alignment: Alignment.bottomRight,
            //                 child: InkWell(
            //                   onTap: () {},
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         bottom: 1.0.h, right: 2.0.w),
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                           color: Colors.black38,
            //                           border: Border(
            //                               right: BorderSide(
            //                                   width: 0.1.w,
            //                                   color: Colors.white),
            //                               top: BorderSide(
            //                                   width: 0.1.w,
            //                                   color: Colors.white),
            //                               bottom: BorderSide(
            //                                   width: 0.1.w,
            //                                   color: Colors.white),
            //                               left: BorderSide(
            //                                   width: 0.1.w,
            //                                   color: Colors.white))),
            //                       child: Padding(
            //                         padding: EdgeInsets.symmetric(
            //                             horizontal: 1.5.w, vertical: 0.6.h),
            //                         child: Text(
            //                           AppLocalizations.of(
            //                                 "Skip in",
            //                               ) +
            //                               " " +
            //                               _start.toString(),
            //                           style: whiteNormal.copyWith(
            //                               fontSize: 10.0.sp),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             )
            //           : !skipped && skipIn
            //               ? Positioned.fill(
            //                   child: Align(
            //                     alignment: Alignment.bottomRight,
            //                     child: InkWell(
            //                       onTap: () {
            //                         print("skip ad here");
            //                         setState(() {
            //                           _start = 0;
            //                           skipIn = false;
            //                           skipped = true;

            //                           showAdControls = true;
            //                           _timer.cancel();
            //                         });
            //                         setState(() {
            //                           isDisposed = true;
            //                         });
            //                         Timer(Duration(seconds: 0), () async {
            //                           flickManager.flickVideoManager.dispose();
            //                           setState(() {
            //                             print("this is auto play");
            //                             print("skip ad current vide=$video");
            //                             // flickManager
            //                             //     .handleChangeVideo(
            //                             //         VideoPlayerController
            //                             //             .network(video),
            //                             //         videoChangeDuration:
            //                             //             positionAfterAd);

            //                             flickManager = new FlickManager(
            //                               // autoPlay: false,
            //                               // autoInitialize: true,
            //                               videoPlayerController:
            //                                   VideoPlayerController.network(
            //                                       video
            //                                       // 'https://www.bebuzee.com/images/profile/wall-videos/2017_12_14_15_07_21_main.mp4'
            //                                       // 'https://www.bebuzee.com/images/profile/wall-videos/m3u8/2017_12_14_15_07_21_main.m3u8'
            //                                       ),
            //                             );
            //                             isDisposed = false;
            //                             print(
            //                                 "position after ad=${positionAfterAd}");
            //                             // flickManager
            //                             //     .flickControlManager
            //                             //     .seekTo(positionAfterAd);
            //                             // flickManager
            //                             //     .flickControlManager
            //                             //     .play();
            //                           });
            //                           // await flickManager
            //                           //     .flickVideoManager
            //                           //     .videoPlayerController
            //                           //     .initialize();
            //                           // flickManager.flickControlManager
            //                           //     .seekTo(positionAfterAd);
            //                           flickManager.flickControlManager.play();
            //                         });
            //                       },
            //                       child: Padding(
            //                         padding: EdgeInsets.only(
            //                             bottom: 1.0.h, right: 2.0.w),
            //                         child: Container(
            //                           decoration: BoxDecoration(
            //                               color: Colors.black38,
            //                               border: Border(
            //                                   right: BorderSide(
            //                                       width: 0.1.w,
            //                                       color: Colors.white),
            //                                   top: BorderSide(
            //                                       width: 0.1.w,
            //                                       color: Colors.white),
            //                                   bottom: BorderSide(
            //                                       width: 0.1.w,
            //                                       color: Colors.white),
            //                                   left: BorderSide(
            //                                       width: 0.1.w,
            //                                       color: Colors.white))),
            //                           child: Padding(
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 1.5.w,
            //                                   vertical: 0.8.h),
            //                               child: FittedBox(
            //                                 child: Row(children: [
            //                                   Text(
            //                                     AppLocalizations.of(
            //                                       "Skip Ad",
            //                                     ),
            //                                     style: whiteNormal.copyWith(
            //                                         fontWeight: FontWeight.w700,
            //                                         fontSize: 10.0.sp),
            //                                   ),
            //                                   SizedBox(
            //                                     width: 0.8.w,
            //                                   ),
            //                                   Icon(
            //                                     Icons.fast_forward_outlined,
            //                                     color: Colors.white,
            //                                     size: 2.0.h,
            //                                   )
            //                                 ]),
            //                               )),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 )
            //               : Container(),
            //       (skipIn && _start != 0) || (!skipped && skipIn)
            //           ? Positioned.fill(
            //               bottom: 2.0.w,
            //               left: 1.5.w,
            //               child: Align(
            //                   alignment: Alignment.bottomLeft,
            //                   child: widget.adsList.ads[adIndex].button !=
            //                               null &&
            //                           widget.adsList.ads[adIndex].button !=
            //                               "" &&
            //                           expandedcontroller.isFullscreen.value
            //                       ? GestureDetector(
            //                           onTap: () {
            //                             Navigator.push(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                     builder: (context) =>
            //                                         SimpleWebView(
            //                                             url: widget.adsList
            //                                                 .ads[adIndex].link,
            //                                             heading: "")));
            //                           },
            //                           child: Padding(
            //                             padding: const EdgeInsets.all(8.0),
            //                             child: Container(
            //                                 color: Colors.white,
            //                                 width: 80.0.w,
            //                                 height: 10.0.h,
            //                                 child: ListTile(
            //                                   contentPadding: EdgeInsets.all(8),
            //                                   leading: Container(
            //                                     height: 10.0.h,
            //                                     width: 10.0.w,
            //                                     decoration: BoxDecoration(
            //                                         shape: BoxShape.rectangle,
            //                                         image: DecorationImage(
            //                                             fit: BoxFit.cover,
            //                                             image:
            //                                                 CachedNetworkImageProvider(
            //                                                     widget
            //                                                         .adsList
            //                                                         .ads[
            //                                                             adIndex]
            //                                                         .poster))),
            //                                   ),
            //                                   isThreeLine: true,
            //                                   subtitle: Text('Sponsored',
            //                                       style: TextStyle(
            //                                           fontSize: 1.5.h)),
            //                                   title: Row(
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.start,
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment
            //                                             .spaceBetween,
            //                                     children: [
            //                                       FittedBox(
            //                                         child: Padding(
            //                                           padding:
            //                                               const EdgeInsets.all(
            //                                                   8.0),
            //                                           child: Text(
            //                                               '${widget.adsList.ads[adIndex].title}',
            //                                               style: TextStyle(
            //                                                   color:
            //                                                       Colors.grey)),
            //                                         ),
            //                                       ),
            //                                       ClipRRect(
            //                                         borderRadius:
            //                                             BorderRadius.circular(
            //                                                 5),
            //                                         child: Container(
            //                                           color: primaryBlueColor,
            //                                           child: Padding(
            //                                             padding:
            //                                                 const EdgeInsets
            //                                                     .all(8.0),
            //                                             child: Text(
            //                                                 '${widget.adsList.ads[adIndex].button}',
            //                                                 style: TextStyle(
            //                                                     fontSize: 1.2.h,
            //                                                     color: Colors
            //                                                         .white)),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                   // trailing:
            //                                 )),
            //                           ))
            //                       : Container()),
            //             )
            //           : Container()
            //     ],
            //   )
            // :
            Container(
          width: expandedcontroller.isFullscreen.value ? 100.0.h : 100.0.w,
          height: widget.showFullPlayer == false ? 7.0.h : 100.0.h,
          color: widget.showFullPlayer == false
              ? Colors.grey[900]!.withOpacity(0.9)
              : Colors.grey[900],
          child: widget.showFullPlayer == true
              ? Wrap(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        isDisposed == false
                            ? Container(
                                height: expandedcontroller.isFullscreen.value
                                    ? 99.0.w
                                    : 30.0.h,
                                width: expandedcontroller.isFullscreen.value
                                    ? 100.0.h
                                    : 100.0.w,
                                child: VisibilityDetector(
                                  key: ObjectKey(flickManager),
                                  onVisibilityChanged: (visibility) async {
                                    if (visibility.visibleFraction == 0 &&
                                        this.mounted) {
                                      flickManager.flickControlManager!
                                          .autoPause();
                                    } else if (visibility.visibleFraction ==
                                        1) {
                                      // print("flickr here is play=${}");

                                      flickManager.flickControlManager!
                                          .autoResume();

                                      // flickManager.flickDisplayManager
                                      //     .removeListener(() {});
                                      flickManager.flickDisplayManager!
                                          .addListener(() async {
                                        print("fullscreen listener added");
                                        videoListenerPotraitTest();
                                      });
                                    }
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: FlickVideoPlayer(
                                      preferredDeviceOrientation:
                                          expandedcontroller.isFullscreen.value
                                              ? [
                                                  DeviceOrientation
                                                      .landscapeRight,
                                                  DeviceOrientation
                                                      .landscapeLeft
                                                ]
                                              : [
                                                  DeviceOrientation.portraitUp,
                                                  DeviceOrientation.portraitDown
                                                ],
                                      wakelockEnabled: true,
                                      wakelockEnabledFullscreen: true,
                                      flickManager: flickManager,
                                      flickVideoWithControls:
                                          FlickVideoWithControls(
                                        videoFit: BoxFit.contain,
                                        aspectRatioWhenLoading: 16 / 9,
                                        playerLoadingFallback: Center(
                                            child: CircularProgressIndicator()
                                            // child: CachedNetworkImage(
                                            //   fit: BoxFit.cover,
                                            //   imageUrl: thumbnail,
                                            // ),
                                            ),
                                        controls: showAdControls
                                            ? PotraitControls(
                                                forward: () async {
                                                  print(flickManager
                                                      .flickDisplayManager!
                                                      .showPlayerControls);
                                                  Duration? time =
                                                      await flickManager
                                                          .flickVideoManager!
                                                          .videoPlayerController!
                                                          .position;
                                                  time = (time! +
                                                      Duration(seconds: 10));
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
                                                isFullscreen: expandedcontroller
                                                    .isFullscreen.value,
                                                //  isFullscreen,
                                                fullscreen: () {
                                                  expandedcontroller
                                                      .toggleFullScreen();
                                                  flickManager
                                                      .flickControlManager!
                                                      .pause();
                                                  // setState(() {
                                                  //   print(
                                                  //       'skip is $skipped');
                                                  //   isFullscreen =
                                                  //       !isFullscreen;
                                                  // });
                                                })
                                            : Container(),
                                      ),
                                      flickVideoWithControlsFullscreen:
                                          FlickVideoWithControls(
                                        willVideoPlayerControllerChange: false,
                                        videoFit: BoxFit.contain,
                                        controls: LandscapeControls(
                                            onPress: () async {
                                          print("landscape press");
                                          return true;
                                        }),
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
                        isBannerAd && !isBannerNull
                            ? Positioned(
                                child: bannerAd(),
                              )
                            : Container(
                                // height: 100,
                                // width: 100,
                                // color: Colors.pink,
                                ),
                        showControl == true && showAdControls
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
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: qualitiesList
                                                  .qualities.length,
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
                                                    print(qualitiesList
                                                        .qualities[index]
                                                        .video);
                                                    setState(() {
                                                      video = qualitiesList
                                                          .qualities[index]
                                                          .video;
                                                      quality = qualitiesList
                                                          .qualities[index]
                                                          .quality;
                                                      isDisposed = true;
                                                    });

                                                    Timer(Duration(seconds: 1),
                                                        () async {
                                                      flickManager
                                                          .flickVideoManager!
                                                          .dispose();
                                                      setState(() {
                                                        flickManager =
                                                            new FlickManager(
                                                          autoPlay: false,
                                                          autoInitialize: false,
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
                                                  video: widget.video,
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
                            : Container(
                                // height: 100,
                                // width: 100,
                                // child: Text(
                                //     '${skipIn && _start != 0} skipin=${skipIn} start= ${_start}'),
                                // color: Colors.white,
                                ),
                        skipIn && _start != 0
                            ? Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 1.0.h, right: 2.0.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            border: Border(
                                                right: BorderSide(
                                                    width: 0.1.w,
                                                    color: Colors.white),
                                                top: BorderSide(
                                                    width: 0.1.w,
                                                    color: Colors.white),
                                                bottom: BorderSide(
                                                    width: 0.1.w,
                                                    color: Colors.white),
                                                left: BorderSide(
                                                    width: 0.1.w,
                                                    color: Colors.white))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.5.w,
                                              vertical: 0.6.h),
                                          child: Text(
                                            AppLocalizations.of(
                                                  "Skip in",
                                                ) +
                                                " " +
                                                _start.toString(),
                                            style: whiteNormal.copyWith(
                                                fontSize: 10.0.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : !skipped && skipIn
                                ? Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: InkWell(
                                        onTap: () {
                                          print("skip ad here");
                                          setState(() {
                                            _start = 0;
                                            skipIn = false;
                                            skipped = true;

                                            showAdControls = true;
                                            _timer.cancel();
                                          });
                                          setState(() {
                                            isDisposed = true;
                                          });
                                          Timer(Duration(seconds: 0), () async {
                                            flickManager.flickVideoManager!
                                                .dispose();
                                            setState(() {
                                              print("this is auto play");
                                              print(
                                                  "skip ad current vide=$video");
                                              // flickManager
                                              //     .handleChangeVideo(
                                              //         VideoPlayerController
                                              //             .network(video),
                                              //         videoChangeDuration:
                                              //             positionAfterAd);

                                              flickManager = new FlickManager(
                                                // autoPlay: false,
                                                // autoInitialize: true,
                                                videoPlayerController:
                                                    VideoPlayerController.network(
                                                        video
                                                        // 'https://www.bebuzee.com/images/profile/wall-videos/2017_12_14_15_07_21_main.mp4'
                                                        // 'https://www.bebuzee.com/images/profile/wall-videos/m3u8/2017_12_14_15_07_21_main.m3u8'
                                                        ),
                                              );
                                              isDisposed = false;
                                              print(
                                                  "position after ad=${positionAfterAd}");
                                              // flickManager
                                              //     .flickControlManager
                                              //     .seekTo(positionAfterAd);
                                              // flickManager
                                              //     .flickControlManager
                                              //     .play();
                                            });
                                            // await flickManager
                                            //     .flickVideoManager
                                            //     .videoPlayerController
                                            //     .initialize();
                                            // flickManager.flickControlManager
                                            //     .seekTo(positionAfterAd);
                                            flickManager.flickControlManager!
                                                .play();
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 1.0.h, right: 2.0.w),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black38,
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 0.1.w,
                                                        color: Colors.white),
                                                    top: BorderSide(
                                                        width: 0.1.w,
                                                        color: Colors.white),
                                                    bottom: BorderSide(
                                                        width: 0.1.w,
                                                        color: Colors.white),
                                                    left: BorderSide(
                                                        width: 0.1.w,
                                                        color: Colors.white))),
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.5.w,
                                                    vertical: 0.8.h),
                                                child: FittedBox(
                                                  child: Row(children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                        "Skip Ad",
                                                      ),
                                                      style:
                                                          whiteNormal.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize:
                                                                  10.0.sp),
                                                    ),
                                                    SizedBox(
                                                      width: 0.8.w,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .fast_forward_outlined,
                                                      color: Colors.white,
                                                      size: 2.0.h,
                                                    )
                                                  ]),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                        (skipIn && _start != 0) || (!skipped && skipIn)
                            ? Positioned.fill(
                                bottom: 3.0.h,
                                left: 1.5.w,
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: widget.adsList!.ads[adIndex]
                                                    .button !=
                                                null &&
                                            widget.adsList!.ads[adIndex]
                                                    .button !=
                                                "" &&
                                            expandedcontroller
                                                .isFullscreen.value
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SimpleWebView(
                                                              url: widget
                                                                  .adsList!
                                                                  .ads[adIndex]
                                                                  .link!,
                                                              heading: "")));
                                            },
                                            child: Container(
                                                color: Colors.white,
                                                width: 70.0.w,
                                                height: 8.0.h,
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(2),
                                                  leading: Container(
                                                    height: 5.0.h,
                                                    width: 10.0.w,
                                                    decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: CachedNetworkImageProvider(
                                                                widget
                                                                    .adsList!
                                                                    .ads[
                                                                        adIndex]
                                                                    .poster!))),
                                                  ),
                                                  isThreeLine: true,
                                                  subtitle: Text('Sponsored',
                                                      style: TextStyle(
                                                          fontSize: 1.5.h)),
                                                  title: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      FittedBox(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              '${widget.adsList!.ads[adIndex].title}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        ),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: Container(
                                                          color:
                                                              primaryBlueColor,

                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                '${widget.adsList!.ads[adIndex].button}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        1.2.h,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          // child: ElevatedButton(
                                                          //     child: Text(
                                                          //         "${widget.adsList.ads[adIndex].button}"
                                                          //             .toUpperCase(),
                                                          //         style: TextStyle(
                                                          //             fontSize:
                                                          //                 14)),
                                                          //     style: ButtonStyle(
                                                          //         maximumSize: MaterialStateProperty.all<Size>(
                                                          //             Size.fromWidth(
                                                          //                 2.0.w)),
                                                          //         foregroundColor: MaterialStateProperty.all<Color>(
                                                          //             Colors.white),
                                                          //         backgroundColor:
                                                          //             MaterialStateProperty.all<Color>(
                                                          //                 primaryBlueColor),
                                                          //         shape:
                                                          //             MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: primaryBlueColor)))),
                                                          //     onPressed: () => null),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // trailing:
                                                ))

                                            //  Container(
                                            //   decoration: new BoxDecoration(
                                            //     color: primaryBlueColor
                                            //         .withOpacity(0.7),
                                            //     borderRadius:
                                            //         BorderRadius.all(
                                            //             Radius.circular(5)),
                                            //     shape: BoxShape.rectangle,
                                            //   ),
                                            //   child: Padding(
                                            //     padding:
                                            //         EdgeInsets.symmetric(
                                            //             vertical: 2.0.w,
                                            //             horizontal: 10.0.w),
                                            //     child: Text(
                                            //       widget
                                            //                   .adsList
                                            //                   .ads[adIndex]
                                            //                   .button !=
                                            //               null
                                            //           ? widget
                                            //               .adsList
                                            //               .ads[adIndex]
                                            //               .button
                                            //           : "",
                                            //       style: TextStyle(
                                            //           color: Colors.white,
                                            //           fontSize: 12.0.sp,
                                            //           fontWeight:
                                            //               FontWeight.bold),
                                            //     ),
                                            //   ),
                                            // ),
                                            )
                                        : Container(
                                            // height: 100,
                                            // width: 100,
                                            // color: Colors.pink,
                                            )),
                              )
                            : Container()
                      ],
                    ),
                    showAllComments == false
                        ? Container(
                            height: 70.0.h,
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
                                builder:
                                    (BuildContext context, LoadStatus? mode) {
                                  Widget body;

                                  if (mode == LoadStatus.idle) {
                                    body = Text("");
                                  } else if (mode == LoadStatus.loading) {
                                    body = loadingAnimationBlackBackground();
                                  } else if (mode == LoadStatus.failed) {
                                    body = Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                              color: Colors.black, width: 0.7),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Icon(CustomIcons.reload),
                                        ));
                                  } else if (mode == LoadStatus.canLoading) {
                                    body = Text(AppLocalizations.of(
                                      "release to load more",
                                    ));
                                  } else {
                                    body = Text(AppLocalizations.of(
                                      "No more Data",
                                    ));
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
                                  widget.adsList != null &&
                                          widget.adsList!.ads[adIndex].button !=
                                              null &&
                                          widget.adsList!.ads[adIndex].button !=
                                              ""
                                      ? Container(
                                          color:
                                              Color.fromARGB(255, 26, 24, 24),
                                          width: 70.0.w,
                                          height: 8.0.h,
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(2),
                                            leading: Container(
                                              height: 5.0.h,
                                              width: 10.0.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              widget
                                                                  .adsList!
                                                                  .ads[adIndex]
                                                                  .poster!))),
                                            ),
                                            isThreeLine: true,
                                            subtitle: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.0.w),
                                                  child: Container(
                                                    color: Colors.amber,
                                                    child: Text('AD',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 1.8.w,
                                                ),
                                                Text(
                                                    '${widget.adsList!.ads[adIndex].link}',
                                                    style: TextStyle(
                                                        fontSize: 1.5.h,
                                                        color: Colors.grey))
                                              ],
                                            ),
                                            trailing: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SimpleWebView(
                                                                  url: widget
                                                                      .adsList!
                                                                      .ads[
                                                                          adIndex]
                                                                      .link!,
                                                                  heading:
                                                                      "")));
                                                },
                                                child: Container(
                                                  color: primaryBlueColor,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        '${widget.adsList!.ads[adIndex].button}',
                                                        style: TextStyle(
                                                            fontSize: 1.2.h,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FittedBox(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        '${widget.adsList!.ads[adIndex].title}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                ),
                                                // ClipRRect(
                                                //   borderRadius:
                                                //       BorderRadius.circular(5),
                                                //   child: Container(
                                                //     color: primaryBlueColor,
                                                //     child: Padding(
                                                //       padding:
                                                //           const EdgeInsets.all(
                                                //               8.0),
                                                //       child: Text(
                                                //           '${widget.adsList.ads[adIndex].button}',
                                                //           style: TextStyle(
                                                //               fontSize: 1.2.h,
                                                //               color: Colors
                                                //                   .white)),
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            // trailing:
                                          ))
                                      : Container(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 1.5.h,
                                        left: 3.0.w,
                                        right: 3.0.w,
                                        bottom: 0.5.h),
                                    child: InkWell(
                                      onTap: () {
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
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 1.5.h,
                                                        bottom: 1.0.h),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      height: 5,
                                                      width: 10.0.w,
                                                    ),
                                                  )),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 2.0.h,
                                                      left: 3.0.w,
                                                      right: 3.0.w,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                            "Description",
                                                          ),
                                                          style: whiteNormal
                                                              .copyWith(
                                                                  fontSize:
                                                                      15.0.sp),
                                                        ),
                                                        IconButton(
                                                            splashColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.3),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 3.0
                                                                          .w),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 3.5.h,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 0.2,
                                                    color: Colors.grey,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.5.h,
                                                        left: 3.0.w,
                                                        right: 3.0.w,
                                                        bottom: 0.5.h),
                                                    child: Text(
                                                      parse(content)
                                                          .documentElement!
                                                          .text,
                                                      style: whiteBold.copyWith(
                                                          fontSize: 12.0.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 3.0.w),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          views,
                                                          style: TextStyle(
                                                              fontSize: 9.0.sp,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.7)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 2.0.w),
                                                          child: Text(
                                                            timestamp,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    9.0.sp,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.7)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      splashColor: Colors.grey.withOpacity(0.3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 85.0.w,
                                            child: Text(
                                              parse(content)
                                                  .documentElement!
                                                  .text,
                                              style: whiteBold.copyWith(
                                                  fontSize: 12.0.sp,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 3.0.h,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          views,
                                          style: TextStyle(
                                              fontSize: 9.0.sp,
                                              color: Colors.white
                                                  .withOpacity(0.7)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 2.0.w),
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
                                    rebuzed: widget.rebuzed,
                                    copied: widget.copied,
                                    username: username,
                                    userID: userID,
                                    controller: _embedController,
                                    share: () async {
                                      //  flickManager.flickVideoManager.videoPlayerController.setVolume(0);
                                      flickManager.flickControlManager!.pause();

                                      Uri uri =
                                          await DeepLinks.createPostDeepLink(
                                              userID,
                                              "video",
                                              thumbnail,
                                              content != "" &&
                                                      content.length > 50
                                                  ? content.substring(0, 50) +
                                                      "..."
                                                  : content,
                                              "$username",
                                              '$postID');
                                      Share.share(
                                        '${uri.toString()}',
                                      );
                                    },
                                    likeStatus: likeStatus ? 1 : 0,
                                    dislikeStatus: dislikeStatus ? 1 : 0,
                                    postID: postID.toString(),
                                    totalLikes: totalLikes,
                                    totalDislikes: totalDislikes,
                                    shareUrl: shareUrl,
                                    setLikes: (like_status, dislike_status,
                                        total_likes, total_dislikes) {
                                      setState(() {
                                        print("onsetState am here");

                                        likeStatus = like_status;
                                        dislikeStatus = dislike_status;
                                        totalDislikes = total_dislikes;
                                        totalLikes = total_likes;
                                        print(
                                            "like response total likes=${totalLikes}");

                                        widget.video.likeStatus = like_status;
                                        widget.video.dislikeStatus =
                                            dislike_status;
                                        widget.video.numberOfLike = total_likes;
                                        widget.video.numberOfDislike =
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
                                    followStatus: widget.video.followStatus,
                                    shortcode: widget.video.shortcode,
                                  ),
                                  Divider(
                                    thickness: 0.2,
                                    color: Colors.white,
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.grey.withOpacity(0.3))),
                                    // splashColor: Colors.grey.withOpacity(0.3),
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
                                                            "Comments",
                                                          ) +
                                                          "    " +
                                                          commentList
                                                              .comments.length
                                                              .toString()
                                                      : AppLocalizations.of(
                                                            "Comments",
                                                          ) +
                                                          "    " +
                                                          "$comments ",
                                                  style: whiteNormal.copyWith(
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                                    padding: EdgeInsets.only(
                                                        top: 1.0.h),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            decoration:
                                                                new BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: new Border
                                                                  .all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                            child: CircleAvatar(
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
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 1.0.h),
                                                          child: Text(
                                                            firstComment,
                                                            style: whiteNormal
                                                                .copyWith(
                                                                    fontSize:
                                                                        9.0.sp),
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
                                          itemCount: videoList.videos.length,
                                          itemBuilder: (context, index) {
                                            return AutoPlayVideoCard(
                                              changeVideo: () {
                                                print("change video called");
                                                previousIDs
                                                    .add(postID.toString());
                                                setState(() {
                                                  isBannerAd = true;
                                                  if (widget.adsList != null) {
                                                    _start = 15;
                                                    skipIn = true;
                                                    skipped = false;
                                                  } else {
                                                    _start = 0;
                                                    skipIn = false;
                                                    skipped = true;
                                                    showAdControls = true;

                                                    print(
                                                        "ads showcontrol test");
                                                  }
                                                  // getVideoQualities(
                                                  //     videoList
                                                  //         .videos[index]
                                                  //         .postId);
                                                  print(
                                                      "change video called i am here");
                                                  video = videoList
                                                      .videos[index].video;
                                                  isDisposed = true;
                                                  shareUrl = videoList
                                                      .videos[index].shareUrl!;
                                                  postID = videoList
                                                      .videos[index].postId;
                                                  username = videoList
                                                      .videos[index].name;
                                                  userImage = videoList
                                                      .videos[index].userImage;
                                                  views = videoList
                                                      .videos[index].numViews;
                                                  timestamp = videoList
                                                      .videos[index].timeStamp;
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
                                                      .videos[index].likeStatus;
                                                  userID = videoList
                                                      .videos[index].userID;
                                                  thumbnail = videoList
                                                      .videos[index].image;
                                                  followStatus = videoList
                                                      .videos[index].followData;
                                                  dislikeStatus = videoList
                                                      .videos[index]
                                                      .dislikeStatus;
                                                  quality = videoList
                                                      .videos[index].quality;
                                                });
                                                Timer(Duration(seconds: 1), () {
                                                  // flickManager
                                                  //     .flickVideoManager
                                                  //     .dispose();
                                                  setState(() {
                                                    // print(
                                                    //     "pressed auto play ${widget.adsList.ads[0].video} ${widget.adsList.ads[0].button} ${widget.adsList.ads[0].id}");
                                                    flickManager =
                                                        new FlickManager(
                                                      videoPlayerController:
                                                          VideoPlayerController
                                                              .network(widget
                                                                          .adsList !=
                                                                      null
                                                                  ? widget
                                                                      .adsList!
                                                                      .ads[0]
                                                                      .video
                                                                  : video),
                                                    );
                                                    isDisposed = false;
                                                    if (widget.adsList != null)
                                                      showAdControls = false;
                                                    else
                                                      showAdControls = true;
                                                  });

                                                  flickManager
                                                      .flickVideoManager!
                                                      .videoPlayerController!
                                                      .play();
                                                });

                                                // Timer(Duration(seconds: 12),
                                                //     () {
                                                //   flickManager
                                                //       .flickVideoManager
                                                //       .dispose();
                                                //   setState(() {
                                                //     flickManager =
                                                //         new FlickManager(
                                                //       videoPlayerController:
                                                //           VideoPlayerController
                                                //               .network(
                                                //                   video),
                                                //     );
                                                //     isDisposed = false;
                                                //   });

                                                //   flickManager
                                                //       .flickVideoManager
                                                //       .videoPlayerController
                                                //       .play();
                                                // });

                                                getAutoPlayList();
                                                getComments();
                                              },
                                              video: videoList.videos[index],
                                            );
                                          })
                                      : Container()
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 70.0.h,
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          areCommentsLoaded == true
                                              ? AppLocalizations.of(
                                                    "Comments",
                                                  ) +
                                                  "    " +
                                                  commentList.comments.length
                                                      .toString()
                                              : AppLocalizations.of(
                                                    "Comments",
                                                  ) +
                                                  "    " +
                                                  "0",
                                          style: whiteNormal.copyWith(
                                              fontSize: 13.0.sp,
                                              fontWeight: FontWeight.w600),
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
                                            builder: (BuildContext context,
                                                LoadStatus? mode) {
                                              Widget body;

                                              if (mode == LoadStatus.idle) {
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
                                                      shape: BoxShape.circle,
                                                      border: new Border.all(
                                                          color: Colors.black,
                                                          width: 0.7),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Icon(
                                                          CustomIcons.reload),
                                                    ));
                                              } else if (mode ==
                                                  LoadStatus.canLoading) {
                                                body = Text(AppLocalizations.of(
                                                  "release to load more",
                                                ));
                                              } else {
                                                body = Text(AppLocalizations.of(
                                                  "No more Data",
                                                ));
                                              }
                                              return Container(
                                                height: 55.0,
                                                child: Center(child: body),
                                              );
                                            },
                                          ),
                                          controller:
                                              _commentsRefreshController,
                                          onRefresh: _onRefreshComments,
                                          onLoading: _onLoadingComments,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  commentList.comments.length +
                                                      1,
                                              itemBuilder: (context, index) {
                                                if (index == 0) {
                                                  return Container(
                                                    color: Colors.grey[850],
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                                                    new Border
                                                                        .all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 2.5.h,
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
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2.0.w,
                                                                      vertical:
                                                                          1.0.h),
                                                              child:
                                                                  TextFormField(
                                                                onTap: () {},
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
                                                                  border:
                                                                      InputBorder
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
                                                                  hintText: AppLocalizations
                                                                          .of(
                                                                        "Comment as",
                                                                      ) +
                                                                      " ${CurrentUser().currentUser.fullName}",
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
                                                              if (isReply) {
                                                                print(
                                                                    "is reply=${isReply}");
                                                                postSubComment(
                                                                    _controller
                                                                        .text,
                                                                    commentList
                                                                        .comments[
                                                                            index]
                                                                        .commentId!);
                                                              } else {
                                                                postMainComment(
                                                                    _controller
                                                                        .text);
                                                              }

                                                              _controller
                                                                  .clear();
                                                              Timer(
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                                  () {
                                                                getComments();

                                                                isReply =
                                                                    !isReply;
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
                                                  );
                                                } else {
                                                  return VideoCommentCard(
                                                    isReply: (reply) {
                                                      print(
                                                          "video comment card is reply");
                                                      setState(() {
                                                        isReply = reply;
                                                      });
                                                    },
                                                    reportConfirmation: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors.grey[900],
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft:
                                                                      const Radius
                                                                              .circular(
                                                                          20.0),
                                                                  topRight: const Radius
                                                                          .circular(
                                                                      20.0))),
                                                          //isScrollControlled:true,
                                                          context: context,
                                                          builder: (BuildContext
                                                              bc) {
                                                            return Container(
                                                              child: ListTile(
                                                                title: Text(
                                                                    AppLocalizations
                                                                        .of(
                                                                      "Report submitted successfully",
                                                                    ),
                                                                    style: whiteNormal.copyWith(
                                                                        fontSize:
                                                                            12.0.sp)),
                                                              ),
                                                            );
                                                          });

                                                      Timer(
                                                          Duration(seconds: 2),
                                                          () {
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    refreshComments: (index) {
                                                      print(index.toString() +
                                                          "jfoqnqijfnqiuj");

                                                      setState(() {
                                                        commentList.comments
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    showSubComments: () {
                                                      setState(() {
                                                        commentList
                                                                .comments[index - 1]
                                                                .showSubcomments =
                                                            !commentList
                                                                .comments[
                                                                    index - 1]
                                                                .showSubcomments!;
                                                      });
                                                    },
                                                    index: index - 1,
                                                    editingController:
                                                        _controller,
                                                    postID: widget.video.postId
                                                        .toString(),
                                                    comment: commentList
                                                        .comments[index - 1],
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
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0.w,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border:
                                                                new Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          child: CircleAvatar(
                                                            radius: 2.5.h,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    CurrentUser()
                                                                        .currentUser
                                                                        .image!),
                                                          )),
                                                      SizedBox(
                                                        width: 3.0.w,
                                                      ),
                                                      Container(
                                                        width: 72.0.w,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      2.0.w,
                                                                  vertical:
                                                                      1.0.h),
                                                          child: TextFormField(
                                                            onTap: () {},
                                                            maxLines: 1,
                                                            controller:
                                                                _controller,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            onChanged: (val) {},
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
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
                                                                  AppLocalizations
                                                                          .of(
                                                                        "Comment as",
                                                                      ) +
                                                                      " ${CurrentUser().currentUser.fullName}",
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
                                                          if (isReply ==
                                                              false) {
                                                            postMainComment(
                                                                _controller
                                                                    .text);
                                                          }

                                                          _controller.clear();
                                                          Timer(
                                                              Duration(
                                                                  seconds: 1),
                                                              () {
                                                            getComments();
                                                          });

                                                          Timer(
                                                              Duration(
                                                                  seconds: 2),
                                                              () {
                                                            setState(() {
                                                              areCommentsLoaded =
                                                                  true;
                                                            });
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.send,
                                                          color: Colors.white
                                                              .withOpacity(0.7),
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
                                              style: whiteNormal.copyWith(
                                                  fontSize: 15.0.sp),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),
                  ],
                )
              :

              //  Container()
              GestureDetector(
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
                                  flickManager.flickControlManager!.autoPause();
                                } else if (visibility.visibleFraction == 1) {
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
                                  wakelockEnabledFullscreen: true,
                                  flickManager: flickManager,
                                  flickVideoWithControls:
                                      FlickVideoWithControls(
                                    videoFit: BoxFit.contain,
                                    aspectRatioWhenLoading: 16 / 9,
                                    playerLoadingFallback: Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.grey),
                                    )),
                                  ),
                                  flickVideoWithControlsFullscreen:
                                      FlickVideoWithControls(
                                    videoFit: BoxFit.contain,
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
                                  style: whiteBold.copyWith(fontSize: 9.0.sp),
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
                                  flickManager.flickControlManager!.replay();
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
        ),
      )
          // : Container()

          //  Stack(
          //     children: [
          //       isDisposed == false
          //           ? Container(
          // height: 100.0.w,
          // width: 100.0.h,
          //               child: VisibilityDetector(
          //                   key: ObjectKey(flickManager),
          //                   onVisibilityChanged: (visibility) {
          //                     if (visibility.visibleFraction == 0 &&
          //                         mounted) {
          //                       flickManager.flickControlManager.autoPause();
          //                     } else if (visibility.visibleFraction == 1) {
          //                       flickManager.flickControlManager.autoResume();
          //                       print("listen again full");
          //                       flickManager.flickDisplayManager
          //                           .addListener(() {
          //                         // flickManager.flickControlManager.autoResume();
          //                         print(
          //                             "on enter landscape skip is $skipped");
          //                         videoListenerLandscapeTest();
          //                         // videoListenerLandscape();
          //                       });
          //                     }
          //                   },
          //                   child: Stack(
          //                     children: [
          //                       AspectRatio(
          //                         aspectRatio: 16 / 9,
          //                         child: FlickVideoPlayer(
          //                           wakelockEnabled: true,
          //                           wakelockEnabledFullscreen: true,
          //                           flickManager: flickManager,
          //                           flickVideoWithControls:
          //                               FlickVideoWithControls(
          //                             videoFit: BoxFit.contain,
          //                             aspectRatioWhenLoading: 16 / 9,
          //                             playerLoadingFallback: Center(
          //                                 child: CircularProgressIndicator(
          //                               strokeWidth: 1,
          //                               valueColor: AlwaysStoppedAnimation(
          //                                   Colors.grey),
          //                             )),
          //                             controls: showAdControls
          //                                 ? PotraitControls(
          //                                     forward: () async {
          //                                       print(flickManager
          //                                           .flickDisplayManager
          //                                           .showPlayerControls);
          //                                       Duration time =
          //                                           await flickManager
          //                                               .flickVideoManager
          //                                               .videoPlayerController
          //                                               .position;
          //                                       time = time +
          //                                           Duration(seconds: 10);
          //                                       flickManager.flickVideoManager
          //                                           .videoPlayerController
          //                                           .seekTo(time);
          //                                     },
          //                                     backward: () async {
          //                                       print(flickManager
          //                                           .flickDisplayManager
          //                                           .showPlayerControls);
          //                                       Duration time =
          //                                           await flickManager
          //                                               .flickVideoManager
          //                                               .videoPlayerController
          //                                               .position;
          //                                       if (time >
          //                                           Duration(seconds: 10)) {
          //                                         time = time -
          //                                             Duration(seconds: 10);
          //                                       } else {
          //                                         time = Duration(seconds: 0);
          //                                       }

          //                                       flickManager.flickVideoManager
          //                                           .videoPlayerController
          //                                           .seekTo(time);
          //                                     },
          //                                     isFullscreen: isFullscreen,
          //                                     fullscreen: () {
          //                                       setState(() {
          //                                         print(
          //                                             'skip ad skipped=$skipped ');
          //                                         isFullscreen =
          //                                             !isFullscreen;
          //                                         flickManager
          //                                             .flickControlManager
          //                                             .pause();
          //                                         // flickManager
          //                                         //     .flickControlManager
          //                                         //     .play();
          //                                       });
          //                                     })
          //                                 : Container(),
          //                           ),
          //                           flickVideoWithControlsFullscreen:
          //                               FlickVideoWithControls(
          //                             willVideoPlayerControllerChange: false,
          //                             videoFit: BoxFit.contain,
          //                             controls: showAdControls
          //                                 ? PotraitControls(
          //                                     forward: () async {
          //                                       print(flickManager
          //                                           .flickDisplayManager
          //                                           .showPlayerControls);
          //                                       Duration time =
          //                                           await flickManager
          //                                               .flickVideoManager
          //                                               .videoPlayerController
          //                                               .position;
          //                                       time = time +
          //                                           Duration(seconds: 10);
          //                                       flickManager.flickVideoManager
          //                                           .videoPlayerController
          //                                           .seekTo(time);
          //                                     },
          //                                     backward: () async {
          //                                       print(flickManager
          //                                           .flickDisplayManager
          //                                           .showPlayerControls);
          //                                       Duration time =
          //                                           await flickManager
          //                                               .flickVideoManager
          //                                               .videoPlayerController
          //                                               .position;
          //                                       if (time >
          //                                           Duration(seconds: 10)) {
          //                                         time = time -
          //                                             Duration(seconds: 10);
          //                                       } else {
          //                                         time = Duration(seconds: 0);
          //                                       }

          //                                       flickManager.flickVideoManager
          //                                           .videoPlayerController
          //                                           .seekTo(time);
          //                                     },
          //                                     isFullscreen: isFullscreen,
          //                                     fullscreen: () {
          //                                       setState(() {
          //                                         print(
          //                                             'skip ad skipped=$skipped');
          //                                         isFullscreen =
          //                                             !isFullscreen;
          //                                         flickManager
          //                                             .flickControlManager
          //                                             .pause();
          //                                         // flickManager
          //                                         //     .flickControlManager
          //                                         //     .play();
          //                                       });
          //                                     })
          //                                 : Container(),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   )),
          //             )
          //           : Container(
          //               height: 100.0.w,
          //               width: 100.0.h,
          //               color: Colors.black,
          //             ),
          //       showControl == true
          //           ? Positioned.fill(
          //               child: Align(
          //               alignment: Alignment.topRight,
          //               child: GestureDetector(
          //                 onTap: () {
          //                   print('vert menu ${postID}');
          //                   showModalBottomSheet(
          //                       backgroundColor: Colors.grey[900],
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.only(
          //                               topLeft: const Radius.circular(20.0),
          //                               topRight:
          //                                   const Radius.circular(20.0))),
          //                       //isScrollControlled:true,
          //                       context: context,
          //                       builder: (BuildContext bc) {
          //                         return ListView.builder(
          //                             shrinkWrap: true,
          //                             itemCount:
          //                                 qualitiesList.qualities.length,
          //                             itemBuilder: (content, index) {
          //                               return VideoQualityCard(
          //                                 defaultQuality: quality,
          //                                 onTap: () async {
          //                                   Navigator.pop(context);
          //                                   var currentPosition =
          //                                       await flickManager
          //                                           .flickVideoManager
          //                                           .videoPlayerController
          //                                           .position;

          //                                   setState(() {
          //                                     video = qualitiesList
          //                                         .qualities[index].video;
          //                                     quality = qualitiesList
          //                                         .qualities[index].quality;
          //                                     isDisposed = true;
          //                                   });

          //                                   Timer(Duration(seconds: 1),
          //                                       () async {
          //                                     flickManager.flickVideoManager
          //                                         .dispose();

          //                                     setState(() {
          //                                       flickManager =
          //                                           new FlickManager(
          //                                         autoPlay: false,
          //                                         autoInitialize: false,
          //                                         videoPlayerController:
          //                                             VideoPlayerController
          //                                                 .network(video),
          //                                       );
          //                                       isDisposed = false;
          //                                     });
          //                                     await flickManager
          //                                         .flickVideoManager
          //                                         .videoPlayerController
          //                                         .initialize();
          //                                     flickManager.flickControlManager
          //                                         .seekTo(currentPosition);
          //                                     flickManager.flickControlManager
          //                                         .play();
          //                                   });
          //                                 },
          //                                 video: widget.video,
          //                                 quality:
          //                                     qualitiesList.qualities[index],
          //                               );
          //                             });
          //                       });
          //                 },
          //                 child: Container(
          //                   color: Colors.transparent,
          //                   child: Padding(
          //                     padding: EdgeInsets.only(
          //                         top: 2.0.h,
          //                         right: 2.0.w,
          //                         left: 2.0.w,
          //                         bottom: 2.0.h),
          //                     child: Icon(
          //                       Icons.more_vert_rounded,
          //                       size: 3.0.h,
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ))
          //           : Container(),
          //       skipIn && _start != 0
          //           ? Positioned.fill(
          //               child: Align(
          //                 alignment: Alignment.bottomRight,
          //                 child: InkWell(
          //                   onTap: () {},
          //                   child: Padding(
          //                     padding: EdgeInsets.only(
          //                         bottom: 1.0.h, right: 2.0.w),
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                           color: Colors.black38,
          //                           border: Border(
          //                               right: BorderSide(
          //                                   width: 0.1.w,
          //                                   color: Colors.white),
          //                               top: BorderSide(
          //                                   width: 0.1.w,
          //                                   color: Colors.white),
          //                               bottom: BorderSide(
          //                                   width: 0.1.w,
          //                                   color: Colors.white),
          //                               left: BorderSide(
          //                                   width: 0.1.w,
          //                                   color: Colors.white))),
          //                       child: Padding(
          //                         padding: EdgeInsets.symmetric(
          //                             horizontal: 1.5.w, vertical: 0.6.h),
          //                         child: Text(
          //                           AppLocalizations.of(
          //                                 "Skip in",
          //                               ) +
          //                               " " +
          //                               _start.toString(),
          //                           style: whiteNormal.copyWith(
          //                               fontSize: 10.0.sp),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             )
          //           : !skipped && skipIn
          //               ? Positioned.fill(
          //                   child: Align(
          //                     alignment: Alignment.bottomRight,
          //                     child: InkWell(
          //                       onTap: () {
          //                         print("flick test skip ad called");
          //                         setState(() {
          //                           _start = 0;
          //                           skipIn = false;
          //                           skipped = true;
          //                           showAdControls = true;
          //                           // _start = 0;
          //                           //           skipIn = false;
          //                           //           skipped = true;

          //                           //           showAdControls = true;
          //                           _timer.cancel();
          //                         });
          //                         setState(() {
          //                           isDisposed = true;
          //                         });
          //                         Timer(Duration(seconds: 1), () async {
          //                           flickManager.flickVideoManager.dispose();
          //                           setState(() {
          //                             flickManager = new FlickManager(
          //                               autoPlay: false,
          //                               autoInitialize: false,
          //                               videoPlayerController:
          //                                   VideoPlayerController.network(
          //                                       video),
          //                             );
          //                             isDisposed = false;
          //                           });
          //                           await flickManager.flickVideoManager
          //                               .videoPlayerController
          //                               .initialize();
          //                           flickManager.flickControlManager
          //                               .seekTo(positionAfterAd);
          //                           flickManager.flickControlManager.play();
          //                         });
          //                       },
          //                       child: Padding(
          //                         padding: EdgeInsets.only(
          //                             bottom: 1.0.h, right: 2.0.w),
          //                         child: Container(
          //                           color: Colors.black38,
          //                           child: Padding(
          //                             padding: EdgeInsets.symmetric(
          //                                 horizontal: 1.5.w, vertical: 0.6.h),
          //                             child: Text(
          //                               AppLocalizations.of(
          //                                 "Skip Ad",
          //                               ),
          //                               style: whiteNormal.copyWith(
          //                                   fontSize: 10.0.sp),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //               : Container(),
          //       (skipIn && _start != 0) || (!skipped && skipIn)
          //           ? Positioned.fill(
          //               bottom: 1.5.w,
          //               left: 1.5.w,
          //               child: Align(
          //                   alignment: Alignment.bottomLeft,
          //                   child: widget.adsList.ads[adIndex].button !=
          //                               null &&
          //                           widget.adsList.ads[adIndex].button !=
          //                               "" &&
          //                           isFullscreen
          //                       ? GestureDetector(
          //                           onTap: () {
          //                             print("clicked on ad landscape");
          //                             Navigator.push(
          //                                 context,
          //                                 MaterialPageRoute(
          //                                     builder: (context) =>
          //                                         SimpleWebView(
          //                                             url: widget.adsList
          //                                                 .ads[adIndex].link,
          //                                             heading: "")));
          //                           },
          //                           child: Container(
          //                             width: 50.0.w,
          //                             decoration: new BoxDecoration(
          //                                 color: primaryBlueColor
          //                                     .withOpacity(0.8),
          //                                 borderRadius: BorderRadius.all(
          //                                     Radius.circular(5)),
          //                                 shape: BoxShape.rectangle),
          //                             child: Padding(
          //                               padding: EdgeInsets.symmetric(
          //                                   vertical: 2.0.w,
          //                                   horizontal: 10.0.w),
          //                               child: Text(
          //                                 widget.adsList.ads[adIndex]
          //                                             .button !=
          //                                         null
          //                                     ? widget
          //                                         .adsList.ads[adIndex].button
          //                                     : "",
          //                                 style: TextStyle(
          //                                     color: Colors.white,
          //                                     fontSize: 12.0.sp,
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                             ),
          //                           ),
          //                         )
          //                       : Container()),
          //             )
          //           : Container()
          //     ],
          //   ),
          ),
    );
  }
}
