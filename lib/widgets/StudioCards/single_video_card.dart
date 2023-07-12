import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_playlist_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/create_new_playlist.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/playlist_card.dart';
import 'package:bizbultest/widgets/StudioCards/update_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class SingleVideoCardStudio extends StatefulWidget {
  final VideoStudioModel? playlists;
  final VideoModel? video;
  final Function? refresh;
  final Function? delete;
  final int? index;
  final int? lastIndex;
  final Function? sort;
  // ignore: non_constant_identifier_names
  final VoidCallback? play;
  final VoidCallback? loadMore;
  final int? totalVideos;

  SingleVideoCardStudio(
      {Key? key,
      this.playlists,
      this.refresh,
      this.delete,
      this.video,
      this.index,
      this.lastIndex,
      this.sort,
      this.play,
      this.loadMore,
      this.totalVideos})
      : super(key: key);

  @override
  _SingleVideoCardStudioState createState() => _SingleVideoCardStudioState();
}

class _SingleVideoCardStudioState extends State<SingleVideoCardStudio> {
  var filterList = [
    "Date added (newest)",
    "Date added (oldest)",
    "Most Popular",
    "Date created (oldest)",
    "Date created (newest)"
  ];
  var defaultFilter = "Date added (newest)";
  var selectedFilter;

  Future<void> changeThumbnail(
    String playlistID,
    String postID,
  ) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=set_playlist_thumb&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID&post_id=$postID");
//
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video/playlistThumb", {
      "user_id": CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
      "post_id": postID
    });

    if (response!.success == 1) {
      print(response!.data['data']);

      setState(() {
        widget.playlists!.allImage = response!.data['data']['video_file_name'];
      });
    }
  }

  late VideoPlaylist playlists;
  bool arePlaylistLoaded = false;

  Future<void> getPlayList() async {
    print("get Playlist called");
    // var newurl =
    //     'https://www.bebuzee.com/api/video/videoPlaylistData?action=get_playlist_and_watch_later_data&user_id=${CurrentUser().currentUser.memberID}';
    // var response = await ApiProvider().fireApi(newurl);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=get_playlist_and_watch_later_data&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video/videoPlaylistData", {
      "action": "get_playlist_and_watch_later_data",
      "user_id": CurrentUser().currentUser.memberID
    });

    print("playlist response=${response!.data}");
    if (response != null &&
        response!.success == 1 &&
        response!.data['data'] != null) {
      VideoPlaylist playlistData =
          VideoPlaylist.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          playlists = playlistData;
          arePlaylistLoaded = true;
        });
      }
    }
    if (response!.data == null || response!.success != 1) {
      if (mounted) {
        setState(() {
          arePlaylistLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    getPlayList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.index == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 100.0.w,
                      height: 25.0.h,
                      child: Image.network(
                        widget.playlists!.allImage!,
                        fit: BoxFit.cover,
                      )),
                  Container(
                    width: 100.0.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.0.w, vertical: 2.0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.playlists!.title!!,
                            style: whiteNormal.copyWith(fontSize: 14.0.sp),
                          ),
                          Text(
                            widget.playlists!.total.toString() +
                                " " +
                                AppLocalizations.of(
                                  "videos",
                                ),
                            style: whiteNormal.copyWith(fontSize: 10.0.sp),
                          ),
                          widget.playlists!.type == "public"
                              ? Icon(
                                  Icons.public,
                                  size: 2.5.h,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.lock_open,
                                  size: 2.5.h,
                                  color: Colors.white,
                                )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 0.0.h, bottom: 1.0.h, left: 3.0.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort,
                          color: Colors.white,
                          size: 3.5.h,
                        ),
                        SizedBox(
                          width: 5.0.w,
                        ),
                        DropdownButton(
                          dropdownColor: Colors.grey[900],
                          isExpanded: false,
                          //hint: Text("Select Category "),
                          items: filterList.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                (e.toString()),
                                style: whiteNormal.copyWith(fontSize: 12.0.sp),
                              ),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            if (val == "Date created (newest)") {
                              setState(() {
                                selectedFilter = "date_added_new";
                                widget.sort!(selectedFilter);
                              });
                            } else if (val == "Date created (oldest)") {
                              setState(() {
                                selectedFilter = "date_added_old";
                                widget.sort!(selectedFilter);
                              });
                            } else if (val == "Most Popular") {
                              setState(() {
                                selectedFilter = "most_popular";
                                widget.sort!(selectedFilter);
                              });
                            } else if (val == "Date added (newest)") {
                              setState(() {
                                selectedFilter = "date_published_oldest";
                                widget.sort!(selectedFilter);
                              });
                            } else {
                              setState(() {
                                selectedFilter = "date_published_new";
                                widget.sort!(selectedFilter);
                              });
                            }
                            setState(() {
                              defaultFilter = val!;
                            });
                          },
                          value: defaultFilter,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
        InkWell(
          onTap: widget.play ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w, vertical: 1.0.h),
                    child: Container(
                      child: Container(
                        width: 40.0.w,
                        height: 12.0.h,
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              widget.video!.image!,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.0.w,
                        child: Text(
                          widget.video!.postContent!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: whiteNormal.copyWith(fontSize: 11.0.sp),
                        ),
                      ),
                      Text(
                        widget.video!.name!,
                        style: greyNormal.copyWith(fontSize: 9.0.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      //  Text(widget.totalVideos.toString(),style: whiteBold,),
                      // Text(widget.index.toString(),style: whiteBold,),
                      // Text(widget.lastIndex.toString(),style: whiteBold,),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  FloatingActionButton(
                    splashColor: Colors.grey.withOpacity(0.3),
                    onPressed: () {
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
                            return Container(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      UpdateStudioDetails().addToWatchLater(
                                          widget.video!.postId!);
                                      Navigator.pop(context);
                                      widget.refresh!();
                                    },
                                    title: Text(
                                      AppLocalizations.of(
                                        "Save to Watch Later",
                                      ),
                                      style: whiteNormal.copyWith(
                                          fontSize: 12.0.sp),
                                    ),
                                    leading: Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.white,
                                      size: 3.0.h,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      if (arePlaylistLoaded) {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.grey[900],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            20.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            20.0))),
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return Wrap(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0.w,
                                                            vertical: 1.5.h),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                            "Save To",
                                                          ),
                                                          style: whiteNormal
                                                              .copyWith(
                                                                  fontSize:
                                                                      18.0.sp),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: playlists
                                                          .playlists
                                                          .asMap()
                                                          .map((i, value) =>
                                                              MapEntry(
                                                                  i,
                                                                  PlayListCard(
                                                                    refresh: widget
                                                                        .refresh!,
                                                                    postID: widget
                                                                        .video!
                                                                        .postId,
                                                                    index: i,
                                                                    playlists:
                                                                        playlists
                                                                            .playlists[i],
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
                                                          isScrollControlled:
                                                              true,
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
                                                          context: context,
                                                          builder: (BuildContext
                                                              bc) {
                                                            return CreateNewPlayList(
                                                              postID: widget
                                                                  .video!
                                                                  .postId,
                                                              refresh: widget
                                                                  .refresh!,
                                                            );
                                                          });
                                                    },
                                                    splashColor: Colors.grey
                                                        .withOpacity(0.3),
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            CustomIcons
                                                                .onlyplus,
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
                                                            style: whiteNormal
                                                                .copyWith(
                                                                    fontSize:
                                                                        13.0.sp),
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
                                                      style:
                                                          whiteNormal.copyWith(
                                                              fontSize:
                                                                  15.0.sp),
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
                                      style: whiteNormal.copyWith(
                                          fontSize: 12.0.sp),
                                    ),
                                    leading: Icon(
                                      Icons.playlist_add_sharp,
                                      color: Colors.white,
                                      size: 3.0.h,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      UpdateStudioDetails()
                                          .removeVideoFromPlaylist(
                                              widget.playlists!.playlistId!,
                                              widget.video!.postId!);
                                      Navigator.pop(context);
                                      widget.delete!();
                                    },
                                    title: Text(
                                      AppLocalizations.of(
                                            "Remove from",
                                          ) +
                                          " " +
                                          widget.playlists!.title!,
                                      style: whiteNormal.copyWith(
                                          fontSize: 12.0.sp),
                                    ),
                                    leading: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 3.0.h,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      UpdateStudioDetails().moveToTop(
                                          widget.playlists!.playlistId!,
                                          widget.video!.postId!);
                                      Navigator.pop(context);
                                      widget.refresh!();
                                    },
                                    title: Text(
                                      AppLocalizations.of(
                                        "Move to top",
                                      ),
                                      style: whiteNormal.copyWith(
                                          fontSize: 12.0.sp),
                                    ),
                                    leading: Icon(
                                      Icons.arrow_upward_outlined,
                                      color: Colors.white,
                                      size: 3.0.h,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      UpdateStudioDetails().moveToBottom(
                                          widget.playlists!.playlistId!,
                                          widget.video!.postId!);
                                      Navigator.pop(context);
                                      widget.refresh!();
                                    },
                                    title: Text(
                                      AppLocalizations.of(
                                        "Move to bottom",
                                      ),
                                      style: whiteNormal.copyWith(
                                          fontSize: 12.0.sp),
                                    ),
                                    leading: Icon(
                                      Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                      size: 3.0.h,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      changeThumbnail(
                                          widget.playlists!.playlistId!,
                                          widget.video!.postId!);
                                      Navigator.pop(context);
                                      widget.refresh!();
                                    },
                                    title: Text(
                                      AppLocalizations.of(
                                        "Set as playlist thumbnail",
                                      ),
                                      style: whiteNormal.copyWith(
                                          fontSize: 12.0.sp),
                                    ),
                                    leading: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 3.0.h,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    elevation: 0,
                    backgroundColor: Colors.grey[900],
                    isExtended: false,
                    child: Icon(
                      Icons.more_vert_rounded,
                      size: 2.5.h,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        widget.index == widget.lastIndex &&
                (widget.index! + 1) < widget.totalVideos!
            ? InkWell(
                onTap: widget.loadMore ?? () {},
                splashColor: Colors.grey.withOpacity(0.3),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0.7.h),
                  width: 100.0.w,
                  color: Colors.transparent,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 3.0.h,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
