import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/widgets/StudioCards/single_video_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiRepo.dart' as ApiRepo;

import '../expanded_video_player_channel.dart';

class PlaylistVideosStudio extends StatefulWidget {
  final VideoStudioModel playlists;
  final Function refresh;
  final Function delete;
  final Function changeColor;
  final Function isChannelOpen;
  final Function setNavBar;

  PlaylistVideosStudio(
      {Key? key,
      required this.playlists,
      required this.refresh,
      required this.delete,
      required this.changeColor,
      required this.isChannelOpen,
      required this.setNavBar})
      : super(key: key);

  @override
  _PlaylistVideosStudioState createState() => _PlaylistVideosStudioState();
}

class _PlaylistVideosStudioState extends State<PlaylistVideosStudio> {
  late Video videoList;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool areVideosLoaded = false;
  var video;
  bool showNoPlayer = true;
  bool showMiniPlayer = false;
  bool showExpandedPlayer = false;
  var from;
  var currentIndex;
  var currentList;

  Future<void> getVideos(String filter) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=get_playlist_videos&user_id=${CurrentUser().currentUser.memberID}&playlist_id=${widget.playlists.playlistId}&filter_data=date_added_new&all_ids=");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video/playlistVideo", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": widget.playlists.playlistId,
      "filter_data": filter,
      "all_ids": ""
    });

    if (response != null &&
        response!.success == 1 &&
        response!.data != null &&
        response!.data['data'] != null) {
      Video videoData = Video.fromJson(response!.data['data']);
      await Future.wait(videoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());

      if (mounted) {
        setState(() {
          videoList = videoData;
          areVideosLoaded = true;
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("videos", jsonEncode(response!.data['data']));
    }

    if (response!.success != 1 || response!.data['data'] == null) {
      if (mounted) {
        setState(() {
          areVideosLoaded = false;
        });
      }
    }
  }

  void _loadMoreVideos() async {
    int len = videoList.videos.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += videoList.videos[i].postId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    print(urlStr);

    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=get_playlist_videos&user_id=${CurrentUser().currentUser.memberID}&playlist_id=${widget.playlists.playlistId}&filter_data=date_added_new&all_ids=$urlStr");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      Video watchLaterData = Video.fromJson(jsonDecode(response!.body));
      await Future.wait(watchLaterData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());

      if (mounted) {
        setState(() {
          videoList.videos.addAll(watchLaterData.videos);
          areVideosLoaded = true;
        });
      }
    }
    if (response!.body == null || response!.statusCode != 200) {
      if (mounted) {
        setState(() {
          areVideosLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    print("Entered Studio");
    getVideos("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Entered Studio");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[900],
      appBar: showExpandedPlayer
          ? PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.grey[900],
                brightness: Brightness.dark,
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: InkWell(
                splashColor: Colors.grey.withOpacity(0.3),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.white,
                      size: 3.5.h,
                    ),
                    SizedBox(
                      width: 4.0.w,
                    ),
                    Text(
                      AppLocalizations.of(
                        "Your Videos",
                      ),
                      style: whiteBold.copyWith(fontSize: 16.0.sp),
                    ),
                  ],
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.grey[900],
              brightness: Brightness.dark,
            ),
      body: areVideosLoaded
          ? Stack(
              children: [
                WillPopScope(
                  // ignore: missing_return
                  onWillPop: () async {
                    if (showExpandedPlayer == false) {
                      Navigator.pop(context);
                      return true;
                    } else {
                      widget.setNavBar(false);

                      setState(() {
                        showMiniPlayer = true;
                        showExpandedPlayer = false;
                      });
                      return false;
                    }
                  },
                  child: Container(
                    child: ListView.builder(
                        itemCount: videoList.videos.length,
                        itemBuilder: (context, index) {
                          return SingleVideoCardStudio(
                            loadMore: _loadMoreVideos,
                            totalVideos: widget.playlists.total,
                            play: () {
                              widget.setNavBar(true);
                              setState(() {
                                showNoPlayer = false;
                                from = widget.playlists.title;
                                currentList = videoList.videos;
                                currentIndex = index;
                              });
                              Timer(Duration(milliseconds: 300), () {
                                setState(() {
                                  showNoPlayer = false;
                                });
                              });
                              setState(() {
                                video = videoList.videos[index];
                                showExpandedPlayer = true;
                                showMiniPlayer = false;
                              });
                            },
                            index: index,
                            lastIndex: videoList.videos.length - 1,
                            playlists: widget.playlists,
                            refresh: () {
                              Timer(Duration(seconds: 2), () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    blackSnackBar(
                                        AppLocalizations.of('Updated')));
                              });
                              getVideos("");
                              //widget.refresh();
                            },
                            delete: () {
                              Timer(Duration(seconds: 2), () {
                                getVideos("date_added_new");
                                widget.delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    blackSnackBar(
                                        AppLocalizations.of('Video removed')));
                              });
                            },
                            sort: (val) {
                              getVideos(val);
                            },
                            video: videoList.videos[index],
                          );
                        }),
                  ),
                ),
                showNoPlayer == false
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          child: ExpandedVideoCardChannel(
                            name: CurrentUser().currentUser.fullName,
                            copied: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  blackSnackBar(AppLocalizations.of('Copied')));
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
            )
          : Container(),
    );
  }
}
