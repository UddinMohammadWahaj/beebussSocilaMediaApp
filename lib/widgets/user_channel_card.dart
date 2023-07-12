import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/models/video_search_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'ChannelCards/edit_channel_video.dart';

class ChannelCard extends StatefulWidget {
  final VideoModel video;
  final int index;
  final int lastIndex;
  final int totalVideos;
  final VoidCallback loadMore;
  final VoidCallback play;
  final Function refreshChannel;
  final Function delete;
  final String? memberID;

  ChannelCard(
      {Key? key,
      required this.video,
      required this.index,
      required this.lastIndex,
      required this.totalVideos,
      required this.loadMore,
      required this.play,
      required this.refreshChannel,
      required this.delete,
      this.memberID})
      : super(key: key);

  @override
  _ChannelCardState createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {
  var followStatus;

  Future<void> checkFollowStatus() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=check_user_to_follow&user_id=${CurrentUser().currentUser.memberID}&user_id_to=${widget.video.userID}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      if (mounted) {
        setState(() {
          followStatus = jsonDecode(response.body)['return_val'];
        });
      }
    }
  }

  Future<String> followUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");
    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        followStatus = jsonDecode(response.body)['return_val'];
      });
    }

    return "success";
  }

  Future<String> unfollowUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");
    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      print("unfollowed");
      setState(() {
        followStatus = "Follow";
      });
    }

    return "success";
  }

  @override
  void initState() {
    checkFollowStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.play ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 3.0.h),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.index == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0.w,
                                  bottom: 3.0.h,
                                  right: 5.0.w,
                                  top: 2.0.h),
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 4.5.h,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      NetworkImage(widget.video.userImage!),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.video.name!,
                                  style:
                                      whiteNormal.copyWith(fontSize: 12.0.sp),
                                ),
                                SizedBox(
                                  height: 0.8.h,
                                ),
                                widget.memberID ==
                                        CurrentUser().currentUser.memberID
                                    ? Container()
                                    : Container(
                                        child: followStatus != null
                                            ? InkWell(
                                                splashColor: Colors.grey
                                                    .withOpacity(0.3),
                                                onTap: () {
                                                  if (followStatus !=
                                                      "Follow") {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.grey[900],
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                    const Radius
                                                                            .circular(
                                                                        20.0),
                                                                topRight:
                                                                    const Radius
                                                                            .circular(
                                                                        20.0))),
                                                        //isScrollControlled:true,
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return Container(
                                                            child: Wrap(
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            2.0.h),
                                                                    child: Container(
                                                                        decoration: new BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              new Border.all(
                                                                            color:
                                                                                Colors.grey,
                                                                            width:
                                                                                0.5,
                                                                          ),
                                                                        ),
                                                                        child: CircleAvatar(
                                                                          radius:
                                                                              4.0.h,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          backgroundImage: NetworkImage(widget
                                                                              .video
                                                                              .userImage!),
                                                                        )),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    unfollowUser(widget
                                                                        .video
                                                                        .userID!);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                      AppLocalizations.of(
                                                                              "Unfollow") +
                                                                          " " +
                                                                          widget
                                                                              .video
                                                                              .name!,
                                                                      style: whiteNormal.copyWith(
                                                                          fontSize:
                                                                              12.0.sp),
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                      AppLocalizations
                                                                          .of(
                                                                        "Cancel",
                                                                      ),
                                                                      style: whiteNormal.copyWith(
                                                                          fontSize:
                                                                              12.0.sp),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    followUser(
                                                        widget.video.userID!);
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      shape: BoxShape.rectangle,
                                                      border: new Border.all(
                                                        color: Colors.white,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0.3.h,
                                                              horizontal:
                                                                  3.0.w),
                                                      child: Text(
                                                        followStatus == "" ||
                                                                followStatus ==
                                                                    null
                                                            ? ""
                                                            : followStatus,
                                                        style:
                                                            whiteBold.copyWith(
                                                                fontSize:
                                                                    9.0.sp),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Container(
                                          child: Wrap(
                                            children: [
                                              ListTile(
                                                onTap: () async {
                                                  print(widget.video.userID);

                                                  Navigator.pop(context);
                                                  Uri uri = await DeepLinks
                                                      .createChannelDeepLink(
                                                    widget.video.userID!,
                                                    "channel",
                                                    widget.video.userImage!,
                                                    "",
                                                    "${widget.video.shortcode}",
                                                    "",
                                                  );
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text:
                                                              uri.toString()));
                                                  Fluttertoast.showToast(
                                                    msg: AppLocalizations.of(
                                                      "Link Copied",
                                                    ),
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.7),
                                                    textColor: Colors.white,
                                                    fontSize: 15.0,
                                                  );
                                                },
                                                title: Text(
                                                  AppLocalizations.of(
                                                    "Copy Link",
                                                  ),
                                                  style: whiteNormal.copyWith(
                                                      fontSize: 12.0.sp),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  Uri uri = await DeepLinks
                                                      .createChannelDeepLink(
                                                    widget.video.userID!,
                                                    "channel",
                                                    widget.video.userImage!,
                                                    "",
                                                    "${widget.video.shortcode}",
                                                    "",
                                                  );
                                                  Share.share(
                                                    '${uri.toString()}',
                                                  );
                                                },
                                                title: Text(
                                                  AppLocalizations.of(
                                                    "Share to",
                                                  ),
                                                  style: whiteNormal.copyWith(
                                                      fontSize: 12.0.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }),
                          ],
                        )
                      ],
                    )
                  : Container(),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  child: Image.network(
                    widget.video.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.5.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.5.h),
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 3.0.h,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  NetworkImage(widget.video.userImage!),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3.0.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1.5.h),
                              child: Container(
                                width: 60.0.w,
                                child: Text(
                                  parse(widget.video.postContent)
                                      .documentElement!
                                      .text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: whiteBold.copyWith(fontSize: 10.0.sp),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.5.h),
                              child: Row(
                                children: [
                                  Text(
                                    widget.video.name!,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 9.0.sp),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 1.5.w),
                                    child: Text(
                                      widget.video.numViews!,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 9.0.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 1.5.w),
                                    child: Text(
                                      widget.video.timeStamp!,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 9.0.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    widget.memberID == CurrentUser().currentUser.memberID
                        ? Row(
                            children: [
                              FloatingActionButton(
                                elevation: 0,
                                backgroundColor: Colors.grey[900],
                                splashColor: Colors.grey.withOpacity(0.3),
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.grey[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter mystate) {
                                          return EditChannelVideo(
                                            delete: widget.delete,
                                            refreshChannel:
                                                widget.refreshChannel,
                                            video: widget.video,
                                          );
                                        });
                                      });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0.w),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      size: 2.5.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              widget.index == widget.lastIndex &&
                      (widget.index + 1) < widget.totalVideos
                  ? InkWell(
                      onTap: widget.loadMore ?? () {},
                      splashColor: Colors.grey.withOpacity(0.3),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
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
          ),
        ),
      ),
    );
  }
}
