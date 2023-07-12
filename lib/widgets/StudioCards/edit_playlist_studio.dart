import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/models/video_playlist_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/create_new_playlist.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/playlist_card.dart';
import 'package:bizbultest/widgets/StudioCards/studio_add_videos.dart';
import 'package:bizbultest/widgets/StudioCards/update_details.dart';
import 'package:bizbultest/widgets/WatchLater/watch_later_add_videos.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiRepo.dart' as ApiRepo;
import 'edit_privacy.dart';
import 'edit_title_and_description.dart';

class EditPlaylistStudio extends StatefulWidget {
  final VideoStudioModel? playlists;
  final Function? refresh;
  final Function? delete;

  EditPlaylistStudio({Key? key, this.playlists, this.refresh, this.delete})
      : super(key: key);

  @override
  _EditPlaylistStudioState createState() => _EditPlaylistStudioState();
}

class _EditPlaylistStudioState extends State<EditPlaylistStudio> {
  String? response;
  String? playlistId;
  String? dataTitle;
  bool? edit;
  String? type;
  bool? addVideos;
  bool? addAll;
  String? playlistSettings;
  bool? deletePlaylist;
  bool? reportPlaylist;
  String? totalCount;
  String? firstPost;
  String? date;
  String? description;
  String? fbUrl;
  String? twitterShare;
  String? reddit;
  String? tumbler;
  String? linkedin;
  String? pinterest;
  String? bkohtakt;
  String? mix;
  String? mailTo;
  String? url;
  String? shortcode;
  String? memberIdPlaylist;
  String? channel;
  String? embedUrl;
  String? allIds;
  bool dataLoaded = false;
  bool isEmbedSwitched = true;
  bool isSwitched = false;

  Future<void> getPlaylistInfo() async {
    //  var url = Uri.parse(
    //      "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=get_playlist_top_data&user_id=${CurrentUser().currentUser.memberID}&playlist_id=${widget.playlists.playlistId}");
    //  var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/playlist_details.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": widget.playlists!.playlistId
    });

    if (response!.success == 1) {
      if (mounted) {
        setState(() {
          dataLoaded = true;
          playlistId = (response!.data['data'])[0]["playlist_id"];
          dataTitle = (response!.data['data'])[0]["data_title"];
          edit = (response!.data['data'])[0]["edit"];
          type = (response!.data['data'])[0]["type"];
          addVideos = (response!.data['data'])[0]["add_videos"];
          addAll = (response!.data['data'])[0]["add_all"];
          playlistSettings = (response!.data['data'])[0]["playlist_settings"];
          deletePlaylist = (response!.data['data'])[0]["delete_playlist"];
          reportPlaylist = (response!.data['data'])[0]["report_playlist"];
          totalCount = (response!.data['data'])[0]["total_count"];
          firstPost = (response!.data['data'])[0]["first_post"];
          date = (response!.data['data'])[0]["date"];
          description = (response!.data['data'])[0]["description"];
          fbUrl = (response!.data['data'])[0]["fb_url"];
          twitterShare = (response!.data['data'])[0]["twitter_share"];
          reddit = (response!.data['data'])[0]["reddit"];
          tumbler = (response!.data['data'])[0]["tumbler"];
          linkedin = (response!.data['data'])[0]["linkedin"];
          pinterest = (response!.data['data'])[0]["pinterest"];
          bkohtakt = (response!.data['data'])[0]["bkohtakt"];
          mix = (response!.data['data'])[0]["mix"];
          mailTo = (response!.data['data'])[0]["mail_to"];
          url = (response!.data['data'])[0]["url"];
          shortcode = (response!.data['data'])[0]["shortcode"];
          memberIdPlaylist = (response!.data['data'])[0]["user_id_playlist"];
          channel = (response!.data['data'])[0]["channel"];
          embedUrl = (response!.data['data'])[0]["embed_url"];
          allIds = (response!.data['data'])[0]["all_ids"];
        });
      }
    }
  }

  late VideoPlaylist playlists;
  bool arePlaylistLoaded = false;

  Future<void> getPlayList() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=get_playlist_and_watch_later_data&user_id=${CurrentUser().currentUser.memberID}");
//
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video/videoPlaylistData",
        {"user_id": CurrentUser().currentUser.memberID});

    if (response!.success == 1) {
      VideoPlaylist playlistData =
          VideoPlaylist.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          playlists = playlistData;
          arePlaylistLoaded = true;
        });
      }
    }

    if (response!.data['data'] == null || response!.success != 1) {
      if (mounted) {
        setState(() {
          arePlaylistLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    getPlaylistInfo();
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
              if (dataLoaded) {
                Navigator.pop(context);
                showModalBottomSheet(
                    backgroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    context: context,
                    builder: (BuildContext bc) {
                      return EditTitleAndDescription(
                        refresh: widget.refresh!,
                        title: dataTitle!,
                        description: description!,
                        playlists: widget.playlists,
                      );
                    });
              }
            },
            leading: Icon(
              Icons.edit,
              color: Colors.white,
              size: 3.5.h,
            ),
            title: Text(
              AppLocalizations.of(
                "Edit",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: () {
              if (dataLoaded) {
                Navigator.pop(context);
                showModalBottomSheet(
                    backgroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    context: context,
                    builder: (BuildContext bc) {
                      return EditPlaylistPrivacy(
                        refresh: widget.refresh,
                        privacy: type,
                        playlists: widget.playlists,
                      );
                    });
              }
            },
            leading: Icon(
              Icons.lock_open,
              color: Colors.white,
              size: 3.5.h,
            ),
            title: Text(
              AppLocalizations.of(
                "Privacy",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.white,
              size: 3.5.h,
            ),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  //isScrollControlled:true,
                  context: context,
                  builder: (BuildContext bc) {
                    return StudioAddVideosToPlaylist(
                      playlists: widget.playlists,
                      refreshWatchLater: widget.refresh,
                    );
                  });
            },
            title: Text(
              AppLocalizations.of(
                "Add videos",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.playlist_add_sharp,
              color: Colors.white,
              size: 3.5.h,
            ),
            onTap: () {
              print(widget.playlists!.postId);

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
                                        refresh: widget.refresh!,
                                        postID: widget.playlists!.postId,
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
                                  isScrollControlled: true,
                                  backgroundColor: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20.0),
                                          topRight:
                                              const Radius.circular(20.0))),
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return CreateNewPlayList(
                                      postID: widget.playlists!.postId,
                                      refresh: widget.refresh!,
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
                "Add all to",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.white,
              size: 3.5.h,
            ),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                  backgroundColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  //isScrollControlled:true,
                  context: context,
                  builder: (BuildContext bc) {
                    return Container(
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter stateSetter) {
                        return Wrap(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0.w, right: 3.0.w, top: 2.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          "Allow embedding",
                                        ),
                                        style: whiteNormal.copyWith(
                                            fontSize: 12.0.sp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Switch(
                                        value: isEmbedSwitched,
                                        onChanged: (value) {
                                          // if (mounted) {
                                          stateSetter(() {
                                            isEmbedSwitched = value;
                                          });
                                          // }
                                          if (isEmbedSwitched == true) {
                                            UpdateStudioDetails()
                                                .allowEmbedding(
                                                    widget
                                                        .playlists!.playlistId!,
                                                    1);
                                          } else {
                                            UpdateStudioDetails()
                                                .allowEmbedding(
                                                    widget
                                                        .playlists!.playlistId!,
                                                    0);
                                          }
                                        },
                                        activeTrackColor:
                                            Colors.blue.withOpacity(0.4),
                                        activeColor: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0.w,
                                  right: 3.0.w,
                                  top: 0.0.h,
                                  bottom: 2.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          "Add new videos to top of playlist",
                                        ),
                                        style: whiteNormal.copyWith(
                                            fontSize: 12.0.sp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Switch(
                                        value: isSwitched,
                                        onChanged: (value) {
                                          // if (mounted) {
                                          stateSetter(() {
                                            isSwitched = value;
                                          });
                                          // }
                                          if (isSwitched == true) {
                                            UpdateStudioDetails()
                                                .addVideosToTop(
                                                    widget
                                                        .playlists!.playlistId!,
                                                    1);
                                          } else {
                                            UpdateStudioDetails()
                                                .addVideosToTop(
                                                    widget
                                                        .playlists!.playlistId!,
                                                    0);
                                          }
                                        },
                                        activeTrackColor:
                                            Colors.blue.withOpacity(0.4),
                                        activeColor: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  });
            },
            title: Text(
              AppLocalizations.of(
                "Playlist Settings",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.white,
              size: 3.5.h,
            ),
            onTap: () {
              UpdateStudioDetails()
                  .deletePlaylist(widget.playlists!.playlistId!);
              widget.delete!();
              Navigator.pop(context);
            },
            title: Text(
              AppLocalizations.of(
                "Delete Playlist",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
        ],
      ),
    );
  }
}
