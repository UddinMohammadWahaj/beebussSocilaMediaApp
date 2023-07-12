import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_playlist_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;
import 'MainVideoWidgets/create_new_playlist.dart';
import 'MainVideoWidgets/playlist_card.dart';

class ChannelBottomTile extends StatefulWidget {
  final VideoModel? video;
  final int? index;
  final Function? removeVideo;
  final Function? refreshWatchLater;

  ChannelBottomTile(
      {Key? key,
      this.video,
      this.index,
      this.removeVideo,
      this.refreshWatchLater})
      : super(key: key);

  @override
  _ChannelBottomTileState createState() => _ChannelBottomTileState();
}

class _ChannelBottomTileState extends State<ChannelBottomTile> {
  late VideoPlaylist playlists;
  bool arePlaylistLoaded = false;
//TODO:: inSheet 264
  Future<void> getPlayList() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=get_playlist_and_watch_later_data&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.video!.postId}");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      VideoPlaylist playlistData =
          VideoPlaylist.fromJson(jsonDecode(response!.body));
      if (mounted) {
        setState(() {
          playlists = playlistData;
          arePlaylistLoaded = true;
        });
      }
    }

    if (response!.body == null || response!.statusCode != 200) {
      if (mounted) {
        setState(() {
          arePlaylistLoaded = false;
        });
      }
    }
  }

//TODO:: inSheet 321
  Future<void> removeVideoFromWatchLater() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?
    //     action=remove_from_list_watch_later&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.video.postId}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/post_remove_to_watchlater.php", {
      "action": "remove_from_list_watch_later",
      "user_id": CurrentUser().currentUser.memberID,
      "post_id": widget.video!.postId,
    });

    if (response!.success == 1) {
      print(response!.data);
    }
  }

//TODO:: inSheet 322
  Future<void> moveToTop() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?"
    //         "action=move_top_video_watch_later&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.video.postId}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/post_top_to_watchlater.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "post_id": widget.video!.postId,
    });

    if (response!.success == 1) {
      print(response!.data);
    }
  }

//TODO:: inSheet 323
  Future<void> moveToBottom() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?"
    //         "action=move_bottom_video_watch_later&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.video.postId}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/post_bottom_to_watchlater.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "post_id": widget.video!.postId,
    });

    if (response!.success == 1) {
      print(response!.data);
    }
  }

  @override
  void initState() {
    getPlayList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            onTap: () {
              if (arePlaylistLoaded) {
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    context: context,
                    builder: (BuildContext bc) {
                      return Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.0.w, vertical: 1.5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    "Save To",
                                  ),
                                  style:
                                      whiteNormal.copyWith(fontSize: 18.0.sp),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: playlists.playlists
                                  .asMap()
                                  .map((i, value) => MapEntry(
                                      i,
                                      PlayListCard(
                                        postID: widget.video!.postId,
                                        index: i,
                                        playlists: playlists.playlists[i],
                                      )))
                                  .values
                                  .toList(),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 0.2,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                  backgroundColor: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20.0),
                                          topRight:
                                              const Radius.circular(20.0))),
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return CreateNewPlayList(
                                      postID: widget.video!.postId,
                                    );
                                  });
                            },
                            splashColor: Colors.grey.withOpacity(0.3),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CustomIcons.onlyplus,
                                    size: 2.5.h,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 4.0.w,
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                      "Create a new playlist",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 13.0.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 0.2,
                          ),
                          /*   Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:  EdgeInsets.only(right: 2.0.h,top: 1.5.h,bottom: 1.5.h),
                                child: RaisedButton(
                                  color: Colors.white,
                                  onPressed: () {},
                                  child: Text(
                                    "Save",
                                    style: TextStyle(fontSize: 15.0.sp),
                                  ),
                                ),
                              ),
                            )*/

                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            leading: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            title: Text(
                              AppLocalizations.of(
                                "Done",
                              ),
                              style: whiteNormal.copyWith(fontSize: 15.0.sp),
                            ),
                          )
                        ],
                      );
                    });
              }
            },
            title: Text(
              AppLocalizations.of(
                "Save to playlist",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            leading: Icon(
              Icons.playlist_add_sharp,
              color: Colors.white,
              size: 3.0.h,
            ),
          ),
          ListTile(
            onTap: () {
              removeVideoFromWatchLater();
              Navigator.pop(context);
              widget.removeVideo!();
            },
            title: Text(
              AppLocalizations.of(
                "Remove from Watch Later",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            leading: Icon(
              Icons.delete,
              color: Colors.white,
              size: 3.0.h,
            ),
          ),
          ListTile(
            onTap: () {
              moveToTop();
              Navigator.pop(context);
              widget.refreshWatchLater!();
            },
            title: Text(
              AppLocalizations.of(
                "Move to top",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            leading: Icon(
              Icons.arrow_upward_outlined,
              color: Colors.white,
              size: 3.0.h,
            ),
          ),
          ListTile(
            onTap: () {
              moveToBottom();
              Navigator.pop(context);
              widget.refreshWatchLater!();
            },
            title: Text(
              AppLocalizations.of(
                "Move to bottom",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            leading: Icon(
              Icons.arrow_downward_outlined,
              color: Colors.white,
              size: 3.0.h,
            ),
          ),
        ],
      ),
    );
  }
}
