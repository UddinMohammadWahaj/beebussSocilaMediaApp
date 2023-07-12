import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'StudioCards/create_blank_playlist_studio.dart';
import 'StudioCards/edit_playlist_studio.dart';
import 'StudioCards/playlist_videos_page.dart';

class StudioPlaylistCard extends StatefulWidget {
  final VideoStudioModel playlists;
  final int index;
  final int lastIndex;
  final VoidCallback loadMore;
  final int playlistLength;
  final Function sort;
  final Function refresh;
  final Function delete;
  final Function changeColor;
  final Function isChannelOpen;
  final Function setNavBar;

  StudioPlaylistCard({
    Key? key,
    required this.playlists,
    required this.index,
    required this.lastIndex,
    required this.loadMore,
    required this.playlistLength,
    required this.sort,
    required this.refresh,
    required this.delete,
    required this.changeColor,
    required this.isChannelOpen,
    required this.setNavBar,
  }) : super(key: key);

  @override
  _StudioPlaylistCardState createState() => _StudioPlaylistCardState();
}

class _StudioPlaylistCardState extends State<StudioPlaylistCard> {
  var filterList = ["Newest created", "Oldest created", "A-Z", "Z-A"];
  var defaultFilter = "Newest created";
  var selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.index == 0
            ? Padding(
                padding: EdgeInsets.only(
                    top: 2.0.h, bottom: 1.0.h, left: 3.0.w, right: 3.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(
                            "Playlists",
                          ),
                          style: whiteNormal.copyWith(fontSize: 15.0.sp),
                        ),
                        SizedBox(
                          width: 3.0.w,
                        ),
                        Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(1.0.w),
                              child: Text(
                                widget.playlists.totalCount.toString(),
                                style: TextStyle(
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            shape: BoxShape.rectangle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w, vertical: 0.5.h),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0))),
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return CreateBlankPlaylist(
                                        refresh: widget.refresh,
                                      );
                                    });
                              },
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
                                      "New Playlist",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 12.0.sp),
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
              )
            : Container(),
        widget.index == 0
            ? Padding(
                padding:
                    EdgeInsets.only(top: 2.0.h, bottom: 1.0.h, left: 3.0.w),
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
                      onChanged: (val) {
                        var filterList = [
                          "Newest created",
                          "Oldest created",
                          "A-Z",
                          "Z-A"
                        ];

                        if (val == "Newest created") {
                          setState(() {
                            selectedFilter = "new";
                            widget.sort(selectedFilter);
                          });
                        } else if (val == "Oldest created") {
                          setState(() {
                            selectedFilter = "old";
                            widget.sort(selectedFilter);
                          });
                        } else if (val == "A-Z") {
                          setState(() {
                            selectedFilter = "atoz";
                            widget.sort(selectedFilter);
                          });
                        } else {
                          setState(() {
                            selectedFilter = "ztoa";
                            widget.sort(selectedFilter);
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
              )
            : Container(),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlaylistVideosStudio(
                          setNavBar: widget.setNavBar,
                          isChannelOpen: widget.isChannelOpen,
                          changeColor: widget.changeColor,
                          refresh: widget.refresh,
                          delete: widget.delete,
                          playlists: widget.playlists,
                        )));
          },
          splashColor: Colors.grey.withOpacity(0.3),
          child: Container(
            color: Colors.transparent,
            child: Row(
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
                                  child: widget.playlists.allImage == null ||
                                          widget.playlists.allImage == ""
                                      ? Container(
                                          child: Text(
                                            AppLocalizations.of(
                                              "No Videos",
                                            ),
                                            style: whiteNormal.copyWith(
                                                fontSize: 10.0.sp),
                                          ),
                                        )
                                      : Image.network(
                                          widget.playlists.allImage!,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      /* Text(
                                       ,
                                        style: whiteBold.copyWith(fontSize: 12.0.sp),
                                      ),*/
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
                        Text(
                          widget.playlists.title!,
                          style: whiteNormal.copyWith(fontSize: 11.0.sp),
                        ),
                        SizedBox(
                          height: 0.8.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.video_library_sharp,
                              color: Colors.white,
                              size: 2.0.h,
                            ),
                            SizedBox(
                              width: 0.8.w,
                            ),
                            Text(
                              widget.playlists.total == null
                                  ? 0.toString()
                                  : widget.playlists.total.toString(),
                              style: whiteNormal.copyWith(fontSize: 11.0.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.8.h,
                        ),
                        widget.playlists.type == "private"
                            ? Icon(
                                Icons.lock_open,
                                color: Colors.white,
                                size: 2.0.h,
                              )
                            : Icon(
                                Icons.public,
                                color: Colors.white,
                                size: 2.0.h,
                              )

                        //Text(widget.playlistLength.toString(),style: whiteBold,),
                        //  Text(widget.index.toString(),style: whiteBold,),
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
                            context: context,
                            builder: (BuildContext bc) {
                              return EditPlaylistStudio(
                                delete: widget.delete,
                                refresh: widget.refresh,
                                playlists: widget.playlists,
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
        ),
        widget.index == widget.lastIndex &&
                (widget.index + 1) < widget.playlistLength
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
