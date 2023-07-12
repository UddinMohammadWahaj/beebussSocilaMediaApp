import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/user_playlists_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/widgets/MainPlaylists/single_video_card_playlists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class PlaylistVideosMain extends StatefulWidget {
  final UserPlaylistsModel? playlists;
  final Function? refresh;
  final Function? delete;
  final VoidCallback? play;
  final Function? setVideoList;

  PlaylistVideosMain(
      {Key? key,
      this.playlists,
      this.refresh,
      this.delete,
      this.play,
      this.setVideoList})
      : super(key: key);

  @override
  _PlaylistVideosMainState createState() => _PlaylistVideosMainState();
}

class _PlaylistVideosMainState extends State<PlaylistVideosMain> {
  Video? videoList;
  bool? areVideosLoaded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var video;
  bool? showNoPlayer = true;
  bool? showMiniPlayer = false;
  bool? showExpandedPlayer = false;
//TODO:: inSheet 328
  Future<void> getVideos(String filter) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?"
    //         "action=get_playlist_data&user_id=${CurrentUser().currentUser.memberID}&playlist_id=${widget.playlists.playlistId}");
    //
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/playlist_data.php", {
      "action": "get_playlist_data",
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": widget.playlists!.playlistId,
    });

    if (response!.success == 1) {
      Video videoData = Video.fromJson(response!.data['data']);
      await Future.wait(videoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());

      if (mounted) {
        setState(() {
          videoList = videoData;
          areVideosLoaded = true;
          widget!.setVideoList!(videoList!.videos);
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("videos", response!.data['data']);
    }

    if (response!.data['data'] == null || response!.success != 1) {
      if (mounted) {
        setState(() {
          areVideosLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    getVideos("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
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
      body: areVideosLoaded!
          ? Container(
              child: ListView.builder(
                  itemCount: videoList!.videos.length,
                  itemBuilder: (context, index) {
                    return SingleVideoCard(
                      play: widget.play,
                      playlists: widget.playlists,
                      index: index,
                      lastIndex: videoList!.videos.length - 1,
                      refresh: () {
                        Timer(Duration(seconds: 2), () {
                          getVideos("date_added_new");
                          ScaffoldMessenger.of(
                                  _scaffoldKey.currentState!.context)
                              .showSnackBar(blackSnackBar(
                                  AppLocalizations.of('Updated')));
                        });
                        widget.refresh!();
                      },
                      delete: () {
                        Timer(Duration(seconds: 2), () {
                          getVideos("date_added_new");
                          ScaffoldMessenger.of(
                                  _scaffoldKey.currentState!.context)
                              .showSnackBar(blackSnackBar(
                                  AppLocalizations.of('Video removed')));
                        });
                      },
                      sort: (val) {
                        getVideos(val);
                      },
                      video: videoList!.videos[index],
                    );
                  }),
            )
          : Container(),
    );
  }
}
