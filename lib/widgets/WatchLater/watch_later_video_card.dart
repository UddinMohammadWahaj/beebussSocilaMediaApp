import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/user_playlists_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/channel_page_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../channel_bottom_tile.dart';
import 'package:bizbultest/widgets/WatchLater/watch_later_add_videos.dart';

class WatchLaterVideosCard extends StatefulWidget {
  final VideoModel videos;
  final int index;
  final int lastIndex;
  final VoidCallback loadMore;
  final int totalVideos;
  final Function sort;
  final VoidCallback play;
  final List watchLaterList;
  final Function removeVideo;
  final Function refreshWatchLater;

  WatchLaterVideosCard(
      {Key? key,
      required this.videos,
      required this.index,
      required this.lastIndex,
      required this.loadMore,
      required this.totalVideos,
      required this.sort,
      required this.play,
      required this.watchLaterList,
      required this.removeVideo,
      required this.refreshWatchLater})
      : super(key: key);

  @override
  _WatchLaterVideosCardState createState() => _WatchLaterVideosCardState();
}

class _WatchLaterVideosCardState extends State<WatchLaterVideosCard> {
  var filterList = [
    "Date added (newest)",
    "Date added (oldest)",
    "Most Popular",
    "Date created (oldest)",
    "Date created (newest)"
  ];
  var defaultFilter = "Date added (newest)";
  var selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.index == 0
            ? Container(
                color: Colors.black38,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.0.h, bottom: 1.0.h, left: 3.0.w, right: 3.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      "Watch Later",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 14.0.sp),
                                  ),
                                  SizedBox(
                                    width: 3.0.w,
                                  ),
                                  Icon(
                                    Icons.lock_open,
                                    color: Colors.white,
                                    size: 2.5.h,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
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
                                          //isScrollControlled:true,
                                          context: context,
                                          builder: (BuildContext bc) {
                                            return WatchLaterAddVideos(
                                              refreshWatchLater:
                                                  widget.refreshWatchLater,
                                            );
                                          });
                                    },
                                    splashColor: Colors.grey.withOpacity(0.3),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        shape: BoxShape.rectangle,
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.5.w, vertical: 0.5.h),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 2.0.h,
                                            ),
                                            SizedBox(
                                              width: 3.0.w,
                                            ),
                                            Text(
                                              AppLocalizations.of(
                                                "Add videos",
                                              ),
                                              style: whiteNormal.copyWith(
                                                  fontSize: 12.0.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            AppLocalizations.of(
                                CurrentUser().currentUser.fullName!),
                            style: whiteNormal.copyWith(fontSize: 12.0.sp),
                          ),
                        ],
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
                                  AppLocalizations.of((e.toString())),
                                  style:
                                      whiteNormal.copyWith(fontSize: 12.0.sp),
                                ),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (String? val) {
                              if (val == "Date added (newest)") {
                                setState(() {
                                  selectedFilter = "date_added_new";
                                  widget.sort(selectedFilter);
                                });
                              } else if (val == "Date added (oldest)") {
                                setState(() {
                                  selectedFilter = "date_added_old";
                                  widget.sort(selectedFilter);
                                });
                              } else if (val == "Most Popular") {
                                setState(() {
                                  selectedFilter = "most_popular";
                                  widget.sort(selectedFilter);
                                });
                              } else if (val == "Date created (newest)") {
                                setState(() {
                                  selectedFilter = "date_published_oldest";
                                  widget.sort(selectedFilter);
                                });
                              } else {
                                setState(() {
                                  selectedFilter = "date_published_new";
                                  widget.sort(selectedFilter);
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
                ),
              )
            : Container(),
        InkWell(
          onTap: widget.play ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.0.w, vertical: 1.0.h),
                        child: Container(
                          child: Container(
                            width: double.infinity,
                            height: 12.0.h,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                widget.videos.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.0.w,
                          child: Text(
                            AppLocalizations.of(widget.videos.postContent!),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: whiteNormal.copyWith(fontSize: 11.0.sp),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(widget.videos.name!),
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
              ),
              Row(
                children: [
                  FloatingActionButton(
                    splashColor: Colors.grey.withOpacity(0.3),
                    onPressed: () async {
                      await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20.0),
                                  topRight: const Radius.circular(20.0))),
                          //isScrollControlled:true,
                          context: context,
                          builder: (BuildContext bc) {
                            return ChannelBottomTile(
                              removeVideo: widget.removeVideo,
                              video: widget.videos,
                              refreshWatchLater: widget.refreshWatchLater,
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
                (widget.index + 1) < widget.totalVideos
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
