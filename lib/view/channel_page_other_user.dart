import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/personal_blog_model.dart';
import 'package:bizbultest/models/profile_posts_model.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/models/user_playlists_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/widgets/expanded_video_player_channel.dart';
import 'package:bizbultest/widgets/user_channel_card.dart';
import 'package:bizbultest/widgets/user_playlists_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../api/ApiRepo.dart' as ApiRepo;

class ChannelPageMainOtherUser extends StatefulWidget {
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final String? otherMemberID;

  ChannelPageMainOtherUser(
      {Key? key,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.otherMemberID})
      : super(key: key);

  @override
  _ChannelPageMainOtherUserState createState() =>
      _ChannelPageMainOtherUserState();
}

class _ChannelPageMainOtherUserState extends State<ChannelPageMainOtherUser>
    with TickerProviderStateMixin {
  late TabController _channelController;
  int selectedIndex = 0;
  final controller = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int initialPage;
  int currentPage = 1;
  late int totalPages;
  late String currentId;
  var from;
  var currentList;
  late int currentIndex;
  var watchLaterFilter = "date_added_new";
  var userImage;
  var totalPosts;
  var followers;
  var following;
  var bio;
  var name;
  var shortcode;
  bool profileLoaded = false;
  late Video watchLaterVideoList;
  bool areWatchLaterVideosLoaded = false;
  late Studio studioPlaylist;
  bool areStudioPlaylistsLoaded = false;
  late Video channelVideoList;
  bool areChannelVideosLoaded = false;
  var video;
  bool showNoPlayer = true;
  bool showMiniPlayer = false;
  bool showExpandedPlayer = false;
  late ProfilePosts? postsList;
  late PersonalBlogs blogsList;
  bool hasPosts = false;
  bool hasBlogs = false;
  var stringOfPostID;
  late UserPlaylists playlists;
  bool arePlaylistsLoaded = false;
  bool showChannel = false;
  String studioSort = "new";
//TODO:: inSheet  214
  Future<void> getPlaylists(String filter) async {

    var response = await ApiRepo.postWithToken("api/member_playlist_data.php", {
      "user_id": currentId,
      "current_user_id": currentId,
      "filter_data": filter,
      "all_ids": "",
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'].isNotEmpty) {
      UserPlaylists playlistsData =
          UserPlaylists.fromJson(response!.data['data']);
      await Future.wait(playlistsData.playlists
          .map((e) => Preload.cacheImage(context, e.playlistThumb!))
          .toList());

      if (this.mounted) {
        setState(() {
          playlists = playlistsData;
          arePlaylistsLoaded = true;
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("playlists", response!.data['data']);
    }
    if (response!.data['data'] == null ||
        response!.data['data'] == "" ||
        response!.success != 1) {
      setState(() {
        arePlaylistsLoaded = false;
      });
    }
  }

//TODO:: inSheet  214
  void _loadMorePlaylists(String filter) async {
    int len = playlists.playlists.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += playlists.playlists[i].playlistId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }


    var response = await ApiRepo.postWithToken("api/member_playlist_data.php", {
      "user_id": currentId,
      "current_user_id": currentId,
      "filter_data": filter,
      "all_ids": urlStr,
    });

    if (response!.success == 1) {
      UserPlaylists playlistsData =
          UserPlaylists.fromJson(response!.data['data']);
      await Future.wait(playlistsData.playlists
          .map((e) => Preload.cacheImage(context, e.playlistThumb!))
          .toList());

      if (mounted) {
        setState(() {
          playlists.playlists.addAll(playlistsData.playlists);
          arePlaylistsLoaded = true;
        });
      }
    }
    if (response!.data['data'] == null ||
        response!.data['data'] == "" ||
        response!.success != 1) {
      if (mounted) {
        setState(() {
          arePlaylistsLoaded = false;
        });
      }
    }
  }

//TODO:: inSheet  217
  Future<void> getPlaylistsStudio(String sort) async {

    var response = await ApiRepo.postWithToken("api/member_playlist_list.php", {
      "user_id": currentId,
      "filter_data": sort,
      "keyword": "",
      "all_ids": "",
    });

    if (response!.success == 1) {
      Studio studioData = Studio.fromJson(response!.data['data']);
      await Future.wait(studioData.playlists
          .map((e) => Preload.cacheImage(context, e.allImage!))
          .toList());
      if (mounted) {
        setState(() {
          studioPlaylist = studioData;
          areStudioPlaylistsLoaded = true;
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("studio", jsonEncode(response!.data['data']));
    }
    if (response!.data['data'] == null ||
        response!.data['data'] == "" ||
        response!.success != 1) {
      if (mounted) {
        setState(() {
          areStudioPlaylistsLoaded = false;
        });
      }
    }
  }

//TODO:: inSheet  216
  Future<void> getWatchLaterVideos(String filter) async {

    var response = await ApiRepo.postWithToken("api/member_playlist_data.php", {
      "user_id": currentId,
      "filter": filter,
      "all_ids": "",
    });

    if (response!.success == 1) {
      Video videoData = Video.fromJson(response!.data['data']);
      await Future.wait(videoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());

      if (mounted) {
        setState(() {
          watchLaterVideoList = videoData;
          areWatchLaterVideosLoaded = true;
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("watchlater", jsonEncode(response!.data['data']));
    }

    if (response!.data['data'] == null ||
        response!.data['data'] == "" ||
        response!.success != 1) {
      if (mounted) {
        setState(() {
          areWatchLaterVideosLoaded = false;
        });
      }
    }
  }

//TODO:: inSheet  219
  Future<void> getChannelVideo() async {
    print(currentId);

    var response = await ApiRepo.postWithToken("api/video/userVideoData", {
      "user_id": currentId,
      "country": CurrentUser().currentUser.country,
      "current_user_id": currentId,
      "all_ids": "",
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'].isNotEmpty) {
      Video channelVideoData = Video.fromJson(response!.data['data']);
      await Future.wait(channelVideoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());
      await Future.wait(channelVideoData.videos
          .map((e) => PreloadUserImage.cacheImage(context, e.userImage!))
          .toList());

      if (mounted) {
        setState(() {
          name = channelVideoData.videos[0].name;
          channelVideoList = channelVideoData;
          areChannelVideosLoaded = true;
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("channel", jsonEncode(response!.data['data']));
    }

    if (response!.data['data'] == null) {
      if (mounted) {
        setState(() {
          areChannelVideosLoaded = false;
        });
      }
    }
  }

//TODO:: inSheet  219
  void _loadMoreChannelVideos() async {
    int len = channelVideoList.videos.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += channelVideoList.videos[i].postId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    print(urlStr);

    var response = await ApiRepo.postWithToken("api/video/userVideoData", {
      "user_id": currentId,
      "country": CurrentUser().currentUser.country,
      "current_user_id": currentId,
      "all_ids": urlStr,
    });

    if (response!.success == 1) {
      Video channelVideoData = Video.fromJson(response!.data['data']);
      await Future.wait(channelVideoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());
      await Future.wait(channelVideoData.videos
          .map((e) => PreloadUserImage.cacheImage(context, e.userImage!))
          .toList());

      if (mounted) {
        setState(() {
          channelVideoList.videos.addAll(channelVideoData.videos);
          areChannelVideosLoaded = true;
        });
      }
    }
    if (response!.data['data'] == null ||
        response!.data['data'] == "" ||
        response!.success != 1) {
      if (mounted) {
        setState(() {
          areChannelVideosLoaded = false;
        });
      }
    }
  }

  void getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playlist = prefs.getString("playlists");
    String? studio = prefs.getString("studio");
    String? watchLater = prefs.getString("watchlater");
    String? channel = prefs.getString("channel");
    if (playlist != null &&
        studio != null &&
        watchLater != null &&
        channel != null) {
      print("locallllllllll");

      UserPlaylists playlistsData =
          UserPlaylists.fromJson(jsonDecode(playlist));
      Studio studioData = Studio.fromJson(jsonDecode(studio));
      Video videoData = Video.fromJson(jsonDecode(watchLater));
      Video channelVideoData = Video.fromJson(jsonDecode(channel));
      setState(() {
        playlists = playlistsData;
        arePlaylistsLoaded = true;
        studioPlaylist = studioData;
        areStudioPlaylistsLoaded = true;
        watchLaterVideoList = videoData;
        areWatchLaterVideosLoaded = true;
        channelVideoList = channelVideoData;
        areChannelVideosLoaded = true;
      });
    } else {
      getChannelVideo();
      getPlaylistsStudio("new");
      getPlaylists("desc");
      getWatchLaterVideos("date_added_new");
    }
  }

  @override
  void initState() {
    print(widget.otherMemberID! + "aaaaaaaaaaaaaa");

    if (widget.otherMemberID != null) {
      currentId = widget.otherMemberID!;
    } else {
      currentId = CurrentUser().currentUser.memberID!;
    }

    getChannelVideo();
    getPlaylistsStudio("new");
    getPlaylists("desc");
    getWatchLaterVideos("date_added_new");

    _channelController =
        new TabController(vsync: this, length: 2, initialIndex: selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: showExpandedPlayer == false
          ? AppBar(
              title: InkWell(
                splashColor: Colors.grey.withOpacity(0.3),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                  widget.changeColor!(false);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.white,
                      size: 3.5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.0.w),
                      child: Text(
                        OtherUser().otherUser.shortcode!,
                        style: whiteNormal.copyWith(fontSize: 14.0.sp),
                      ),
                    ),
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
              bottom: TabBar(
                labelPadding: EdgeInsets.only(right: 1.0.w, left: 1.0.w),
                indicatorColor: Colors.white,
                tabs: <Tab>[
                  Tab(
                    child: Text(
                      AppLocalizations.of(
                        "Channel",
                      ),
                      style: whiteNormal.copyWith(fontSize: 10.0.sp),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(
                        "PLAYLISTS",
                      ),
                      style: whiteNormal.copyWith(fontSize: 10.0.sp),
                    ),
                  ),
                ],
                controller: _channelController,
                onTap: (int index) {},
              ),
              backgroundColor: Colors.grey[900],
              elevation: 0,
              brightness: Brightness.dark,
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey[900],
                elevation: 0,
                brightness: Brightness.dark,
              ),
            ),
      body: Stack(
        children: [
          WillPopScope(
              onWillPop: () async {
                if (showExpandedPlayer == false) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  widget.changeColor!(false);
                  widget.isChannelOpen!(false);

                  return true;
                } else {
                  widget.setNavBar!(false);

                  setState(() {
                    showMiniPlayer = true;
                    showExpandedPlayer = false;
                  });
                  return false;
                }
              },
              child: Container(
                color: Colors.grey[900],
                child: TabBarView(
                  controller: _channelController,
                  children: <Widget>[
                    Container(
                        child: areChannelVideosLoaded == true
                            ? ListView.builder(
                                itemCount: channelVideoList.videos.length,
                                itemBuilder: (context, index) {
                                  return ChannelCard(
                                    refreshChannel: () {
                                      Timer(Duration(seconds: 2), () {
                                        getChannelVideo();
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(blackSnackBar(
                                          AppLocalizations.of('Updated'),
                                        ));
                                      });
                                    },
                                    delete: () {
                                      Timer(Duration(seconds: 2), () {
                                        getChannelVideo();
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(blackSnackBar(
                                          AppLocalizations.of('Video deleted'),
                                        ));
                                      });
                                    },
                                    play: () {
                                      widget.setNavBar!(true);
                                      setState(() {
                                        currentIndex = index;
                                        showNoPlayer = false;
                                        from = "Personal Channel";
                                        currentList = channelVideoList.videos;
                                      });
                                      Timer(Duration(milliseconds: 300), () {
                                        setState(() {
                                          showNoPlayer = false;
                                        });
                                      });
                                      setState(() {
                                        video = channelVideoList.videos[index];
                                        showExpandedPlayer = true;
                                        showMiniPlayer = false;
                                      });
                                    },
                                    loadMore: () {
                                      _loadMoreChannelVideos();
                                    },
                                    video: channelVideoList.videos[index],
                                    index: index,
                                    lastIndex:
                                        channelVideoList.videos.length - 1,
                                    totalVideos:
                                        channelVideoList.videos[0].totalVideos!,
                                  );
                                })
                            : Container()),
                    Container(
                      child: arePlaylistsLoaded == true
                          ? ListView.builder(
                              itemCount: playlists.playlists.length,
                              itemBuilder: (context, index) {
                                return UserPlaylistCard(
                                  setVideoList: (list, model, indexx) {
                                    currentList = list;
                                    video = model;
                                    currentIndex = indexx;
                                  },
                                  currentId: widget.otherMemberID,
                                  play: () {
                                    widget.setNavBar!(true);
                                    setState(() {
                                      currentIndex = index;
                                      showNoPlayer = false;
                                      from = playlists
                                          .playlists[index].playlistTitle;
                                    });
                                    Timer(Duration(milliseconds: 300), () {
                                      setState(() {
                                        showNoPlayer = false;
                                      });
                                    });
                                    setState(() {
                                      showExpandedPlayer = true;
                                      showMiniPlayer = false;
                                    });
                                  },
                                  sort: (sort) {
                                    getPlaylists(sort);
                                  },
                                  playlistLength:
                                      playlists.playlists[0].totalPlaylists,
                                  loadMore: () {
                                    _loadMorePlaylists("desc");
                                  },
                                  index: index,
                                  lastIndex: playlists.playlists.length - 1,
                                  playlist: playlists.playlists[index],
                                );
                              })
                          : Container(),
                    ),
                  ],
                ),
              )),
          showNoPlayer == false
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: ExpandedVideoCardChannel(
                      rebuzed: () {
                        ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                            .showSnackBar(blackSnackBar(
                          AppLocalizations.of('Rebuzed Successfully'),
                        ));
                      },
                      name: name,
                      copied: () {
                        ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                            .showSnackBar(blackSnackBar(
                          AppLocalizations.of('Copied'),
                        ));
                      },
                      currentIndex: currentIndex,
                      playlist: currentList,
                      from: from,
                      onPress: () {
                        setState(() {
                          // widget.setNavBar(false);
                          setState(() {
                            showMiniPlayer = true;
                            showExpandedPlayer = false;
                          });
                        });
                      },

                      // dispose: showNoPlayer,
                      video: VideoListModelData.fromJson(video.toJson()),
                      expand: () {
                        // widget.setNavBar(true);
                        setState(() {
                          showExpandedPlayer = true;
                          showMiniPlayer = false;
                        });
                      },
                      onPressHide: () {
                        setState(() {
                          showNoPlayer = true;
                        });
                      },
                      showFullPlayer: showExpandedPlayer,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
