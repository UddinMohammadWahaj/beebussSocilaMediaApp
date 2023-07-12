import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/user_playlists_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class UserPlaylistCard extends StatefulWidget {
  final UserPlaylistsModel? playlist;
  final int? index;
  final int? lastIndex;
  final VoidCallback? loadMore;
  final int? playlistLength;
  final Function? sort;
  final Function? refresh;
  final Function? delete;
  final VoidCallback? play;
  final Function? setVideoList;
  var currentId;

  UserPlaylistCard(
      {Key? key,
      this.playlist,
      this.index,
      required this.lastIndex,
      this.loadMore,
      this.playlistLength,
      this.sort,
      this.refresh,
      this.delete,
      this.play,
      this.currentId,
      this.setVideoList})
      : super(key: key);

  @override
  _UserPlaylistCardState createState() => _UserPlaylistCardState();
}

class _UserPlaylistCardState extends State<UserPlaylistCard> {
  var filterList = ["Date created (oldest)", "Date created (newest)"];
  var defaultFilter = "Date created (oldest)";
  var selectedFilter;
  bool showVideos = false;
  late Video videoList;
  bool areVideosLoaded = false;
//TODO:: inSheet 324
  Future<void> getVideos(String playlistID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=get_playlist_data&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$playlistID");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/video/playlistVideo", {
      "action": "get_playlist_data",
      "user_id": widget.currentId ?? CurrentUser().currentUser.memberID,
      "playlist_id": playlistID,
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
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("videos", jsonEncode(response.data['data']));
    }

    if (response.success != 1 || response.data['data'] == null) {
      if (mounted) {
        setState(() {
          areVideosLoaded = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.index == 0
            ? Container(
                color: Colors.black38,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.0.h, bottom: 1.0.h, left: 3.0.w),
                      child: Text(
                        AppLocalizations.of(
                          "Created playlists",
                        ),
                        style: whiteNormal.copyWith(fontSize: 14.0.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.0.h, bottom: 1.0.h, left: 3.0.w),
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
                                  style:
                                      whiteNormal.copyWith(fontSize: 12.0.sp),
                                ),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val == "Date created (oldest)") {
                                setState(() {
                                  selectedFilter = "desc";
                                  widget.sort!(selectedFilter);
                                });
                              } else {
                                setState(() {
                                  selectedFilter = "asc";
                                  widget.sort!(selectedFilter);
                                });
                              }

                              print(selectedFilter);
                              setState(() {
                                defaultFilter = val.toString();
                              });
                            },
                            value: defaultFilter,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        InkWell(
          onTap: () {
            setState(() {
              widget.playlist!.showVideos = !widget.playlist!.showVideos!;
              if (widget.playlist!.showVideos == true) {
                print(widget.playlist!.playlistId);
                getVideos(widget.playlist!.playlistId!);
              }
            });
          },
          splashColor: Colors.grey.withOpacity(0.3),
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0.w, vertical: 1.0.h),
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                  width: 40.0.w,
                                  height: 12.0.h,
                                  child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        widget.playlist!.playlistThumb!,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.8),
                                      width: 15.0.w,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.playlist!.totalVideos
                                                .toString(),
                                            style: whiteBold.copyWith(
                                                fontSize: 12.0.sp),
                                          ),
                                          Icon(
                                            Icons.playlist_play_outlined,
                                            color: Colors.white,
                                            size: 3.5.h,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50.0.w,
                              child: Text(
                                widget.playlist!.playlistTitle,
                                maxLines: 2,
                                style: whiteNormal.copyWith(fontSize: 12.0.sp),
                              ),
                            ),
                            Text(
                              widget.playlist!.totalVideos.toString() +
                                  " videos",
                              style: greyNormal.copyWith(fontSize: 9.0.sp),
                            ),

                            /* Text(widget.playlistLength.toString(),style: whiteBold,),
                            Text(widget.index.toString(),style: whiteBold,),
                            Text(widget.lastIndex.toString(),style: whiteBold,),*/
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                widget.playlist!.showVideos!
                    ? Container(
                        child: areVideosLoaded
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: videoList.videos.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      widget.setVideoList!(videoList.videos,
                                          videoList.videos[index], index);
                                      widget.play!();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        index == 0
                                            ? Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              )
                                            : Container(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0.w,
                                                      vertical: 1.0.h),
                                                  child: Container(
                                                    child: Container(
                                                      width: 30.0.w,
                                                      height: 10.0.h,
                                                      child: AspectRatio(
                                                          aspectRatio: 16 / 9,
                                                          child: Image.network(
                                                            videoList
                                                                .videos[index]
                                                                .image!,
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40.0.w,
                                                      child: Text(
                                                        videoList.videos[index]
                                                            .postContent!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: whiteNormal
                                                            .copyWith(
                                                                fontSize:
                                                                    11.0.sp),
                                                      ),
                                                    ),
                                                    Text(
                                                      videoList
                                                          .videos[index].name!,
                                                      style:
                                                          greyNormal.copyWith(
                                                              fontSize: 9.0.sp),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),

                                                    //  Text(widget.totalVideos.toString(),style: whiteBold,),
                                                    // Text(widget.index.toString(),style: whiteBold,),
                                                    // Text(widget.lastIndex.toString(),style: whiteBold,),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.grey[900],
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: const Radius
                                                                .circular(20.0),
                                                            topRight: const Radius
                                                                    .circular(
                                                                20.0))),
                                                    //isScrollControlled:true,
                                                    context: context,
                                                    builder: (BuildContext bc) {
                                                      return Container(
                                                        child: Wrap(
                                                          children: [
                                                            ListTile(
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                Uri uri = await DeepLinks.createPlaylistDeepLink(
                                                                    widget
                                                                        .playlist!
                                                                        .memberId!,
                                                                    "playlist",
                                                                    widget
                                                                        .playlist!
                                                                        .playlistThumb!,
                                                                    widget
                                                                        .playlist!
                                                                        .playlistTitle,
                                                                    "${widget.playlist!.shortcode}",
                                                                    widget
                                                                        .playlist!
                                                                        .playlistTitle,
                                                                    widget
                                                                        .playlist!
                                                                        .playlistId!);
                                                                Share.share(
                                                                  '${uri.toString()}',
                                                                );
                                                              },
                                                              title: Text(
                                                                AppLocalizations
                                                                    .of(
                                                                  "Share",
                                                                ),
                                                                style: whiteNormal
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12.0.sp),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              onTap: () {},
                                                              title: Text(
                                                                AppLocalizations
                                                                    .of(
                                                                  "Copy Link",
                                                                ),
                                                                style: whiteNormal
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12.0.sp),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                  color: Colors.transparent,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.0.w,
                                                        top: 1.0.h,
                                                        bottom: 1.0.h),
                                                    child: Icon(
                                                      Icons.more_vert_rounded,
                                                      size: 3.0.h,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                        widget.index == widget.lastIndex
                                            ? Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  );
                                })
                            : Container(),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        widget.index == widget.lastIndex &&
                (widget.index! + 1) < widget.playlistLength!
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
