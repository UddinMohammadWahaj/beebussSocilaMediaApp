import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_playlist_model.dart';
import 'package:bizbultest/models/video_section/check_follow_status_video_section.dart';
import 'package:bizbultest/models/video_section/post_like_dislike_video_section_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_likes_api_calls.dart';
import 'package:bizbultest/services/FeedAllApi/report_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/playlist_card.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/report_video_main_bottom_tile.dart';
import 'package:bizbultest/widgets/Newsfeeds/feeds_menu_otherMember.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import '../post_report_other_popup.dart';
import '../post_report_popup.dart';
import 'create_new_playlist.dart';

class VideoActions extends StatefulWidget {
  final String? postID;
  int? totalLikes;
  int? totalDislikes;
  final String? shareUrl;
  int? likeStatus;
  int? dislikeStatus;
  final Function? setLikes;
  final VoidCallback? share;
  final TextEditingController? controller;
  final String? userID;
  final String? username;
  final Function? copied;
  final Function? refresh;
  final Function? rebuzed;

  VideoActions(
      {Key? key,
      this.postID,
      this.totalLikes,
      this.totalDislikes,
      this.shareUrl,
      this.likeStatus,
      this.dislikeStatus,
      this.setLikes,
      this.share,
      this.controller,
      this.userID,
      this.username,
      this.copied,
      this.refresh,
      this.rebuzed})
      : super(key: key);

  @override
  _VideoActionsState createState() => _VideoActionsState();
}

class _VideoActionsState extends State<VideoActions> {
  bool showPlaylists = false;
  VideoPlaylist? playlists;
  bool? arePlaylistLoaded = false;
  var followStatus;

  Future<void> getPlayList() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=get_playlist_and_watch_later_data&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.postID}");

    // var response = await http.get(url);

    var newurl =
        'https://www.bebuzee.com/api/video/videoPlaylistData?action=get_playlist_and_watch_later_data&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.postID}';

    var response = await ApiProvider().fireApi(newurl);
    print("playlist response =${response.data} url=${newurl}");
    if (response.statusCode == 200) {
      VideoPlaylist playlistData =
          VideoPlaylist.fromJson(response.data['data']);
      if (mounted) {
        setState(() {
          playlists = playlistData;
          arePlaylistLoaded = true;
        });
      }
    }

    if (response.data == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          arePlaylistLoaded = false;
        });
      }
    }
  }

  Future<String> unfollow(String unfollowerID) async {
    var url =
        "https://www.bebuzee.com/api/member_unfollow.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID";

    var response = await ApiProvider().fireApi(url);
    print("unfollow api called");
    if (response.statusCode == 200) {
      print(response.data);
    }
    return "success";
  }

  //! api updated
  Future<void> likeVideo(String postID) async {
    var url =
        "https://www.bebuzee.com/api/newsfeed/postLikeUnlike?action=like_video&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.memberID}&post_type=Video";

    print("like Video called");

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );

    if (response.statusCode == 200) {
      PostLikeDislikeVideoSection _likeDislike =
          PostLikeDislikeVideoSection.fromJson(response.data);

      print("response of  postlike=${response.data} ${postID}");
      print("like data=${_likeDislike.totalLikes}");
      widget.setLikes!(_likeDislike.likeStatus, _likeDislike.dislikeStatus,
          _likeDislike.totalLikes, _likeDislike.totalDislikes);

      setState(() {
        widget.likeStatus = _likeDislike.likeStatus! ? 1 : 0;
        widget.dislikeStatus = _likeDislike.dislikeStatus! ? 1 : 0;
        widget.totalLikes = _likeDislike.totalLikes;
        widget.totalDislikes = _likeDislike.totalDislikes;
      });
    }
  }

  //! api updated
  Future<void> dislikeVideo(String postID) async {
    var url =
        "https://www.bebuzee.com/api/post_dislike_disunlike.php?action=unlikelike_video&user_id=${CurrentUser().currentUser.memberID}&post_id=$postID&country=${CurrentUser().currentUser.memberID}&post_type=Video";

    var client = new dio.Dio();
    print("token called");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );

    if (response.statusCode == 200) {
      print("response of dislikes= ${response.data}");
      PostLikeDislikeVideoSection _likeDislike =
          PostLikeDislikeVideoSection.fromJson(response.data);
      widget.setLikes!(_likeDislike.likeStatus, _likeDislike.dislikeStatus,
          _likeDislike.totalLikes, _likeDislike.totalDislikes);
      setState(() {
        widget.likeStatus = _likeDislike.likeStatus! ? 1 : 0;
        widget.dislikeStatus = _likeDislike.dislikeStatus! ? 1 : 0;
        widget.totalLikes = _likeDislike.totalLikes;
        widget.totalDislikes = _likeDislike.totalDislikes;
      });
    }
  }

  Widget _actionButton(
      IconData icon, VoidCallback onTap, String text, int turns) {
    return InkWell(
      onTap: (text == 'More') ? onTap : () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotatedBox(
            quarterTurns: turns,
            child: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: onTap),
          ),
          SizedBox(
            height: 6,
          ),
          (text == 'More')
              ? InkWell(
                  onTap: onTap,
                  child: Text(
                    text,
                    style: whiteNormal.copyWith(fontSize: 12),
                  ),
                )
              : Text(
                  text,
                  style: whiteNormal.copyWith(fontSize: 12),
                ),
        ],
      ),
    );
  }

  //! api updated
  checkFollowStatus(String memberID) async {
    var url =
        "https://www.bebuzee.com/api/member_follow_check.php?action=check_user_to_follow&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$memberID";
    var client = new dio.Dio();
    print("token called");
    print("followstatus url=${url}");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );

    if (response.statusCode == 200) {
      CheckFollowStatusVideoSection _status =
          CheckFollowStatusVideoSection.fromJson(response.data);

      followStatus = _status.message;
    }
  }

  //! updated
  @override
  void initState() {
    widget.controller!.text =
        '<iframe src="https://www.bebuzee.com/view-post-${widget.postID}" height="500" width="600"></iframe>';
    getPlayList();
    checkFollowStatus(widget.userID!);
    // FeedLikeApiCalls.checkFollowStatus(widget.userID).then((value) {
    //   followStatus = value;
    //   return value;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionButton(
              widget.likeStatus == 1 && widget.dislikeStatus == 0
                  ? CustomIcons.videolike2
                  : CustomIcons.videolike1, () {
            likeVideo(widget.postID!);
          }, widget.totalLikes.toString(), 0),
          _actionButton(
              widget.likeStatus == 0 && widget.dislikeStatus == 1
                  ? CustomIcons.videolike2
                  : CustomIcons.videolike1, () {
            // likeVideo(widget.postID);
            dislikeVideo(widget.postID!);
          }, widget.totalDislikes.toString(), 2),
          _actionButton(
              CustomIcons.sharevideo,
              widget.share!,
              AppLocalizations.of(
                "Share",
              ),
              0),
          _actionButton(CustomIcons.iconfinder_playlist_6792164, () {
            print("cliked on the save arePlayListLoaded=$arePlaylistLoaded");
            if (arePlaylistLoaded!) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  context: context,
                  builder: (BuildContext bc) {
                    return SingleChildScrollView(
                      child: Wrap(
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
                              children: playlists!.playlists
                                  .asMap()
                                  .map((i, value) => MapEntry(
                                      i,
                                      PlayListCard(
                                        refresh: widget.refresh!,
                                        postID: widget.postID!,
                                        index: i,
                                        playlists: playlists!.playlists[i],
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
                                      refresh: () {
                                        getPlayList();
                                      },
                                      postID: widget.postID,
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
                      ),
                    );
                  });
            }
          },
              AppLocalizations.of(
                "Save",
              ),
              0),
          _actionButton(CustomIcons.menu, () {
            print("clicked on save");
            showModalBottomSheet(
                backgroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                context: context,
                builder: (BuildContext bc) {
                  return Container(
                    child: Wrap(
                      children: [
                        ListTile(
                          onTap: () {
                            print("clicked of save");
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
                                return VideoReportMenu(
                                  followStatus: followStatus,
                                  other: () {
                                    Navigator.pop(context);

                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return PostReportOtherPopup(
                                          violence: () {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                              .circular(20.0))),
                                              //isScrollControlled:true,
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return ReportPostViolence(
                                                  reportViolence: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    ReportApiCalls()
                                                        .reportPostViolence(
                                                            "Video",
                                                            widget.postID!);

                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  20.0))),
                                                      //isScrollControlled:true,
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return ReportPostSpam();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          sale: () {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                              .circular(20.0))),
                                              //isScrollControlled:true,
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return ReportPostSale(
                                                  reportSale: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    ReportApiCalls()
                                                        .reportPostAsSale(
                                                            "Video",
                                                            widget.postID!);

                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  20.0))),
                                                      //isScrollControlled:true,
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return ReportPostSpam();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          harassment: () {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                              .circular(20.0))),
                                              //isScrollControlled:true,
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return ReportPostHarassment(
                                                  reportHarassment: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    ReportApiCalls()
                                                        .reportPostHarassment(
                                                            "Video",
                                                            widget.postID!);
                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  20.0))),
                                                      //isScrollControlled:true,
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return ReportPostSpam();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          intellectual: () {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                              .circular(20.0))),
                                              //isScrollControlled:true,
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return ReportPostIntellectual(
                                                  reportIntellectual: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    ReportApiCalls()
                                                        .reportPostIntellectual(
                                                            "Video",
                                                            widget.postID!);

                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  20.0))),
                                                      //isScrollControlled:true,
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return ReportPostSpam();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          injury: () {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                              .circular(20.0))),
                                              //isScrollControlled:true,
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return ReportPostInjury(
                                                  reportInjury: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    ReportApiCalls()
                                                        .reportPostInjury(
                                                            "Video",
                                                            widget.postID!);

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        // return object of type Dialog

                                                        return ReportPostSpam();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  dontLikeIt: () {
                                    Navigator.pop(context);
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return DontLikeReport(
                                          unfollow: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            unfollow(widget.userID!);

                                            /*  Future.delayed(Duration(seconds: 1), () {
                                                          _scaffoldKey.currentState.showSnackBar(
                                                              showSnackBar('Unfollowed' + " " + feedsList.feeds[feedIndex].postShortcode));
                                                        });*/
                                          },
                                          shortcode: widget.username,
                                          followStatus: followStatus,
                                        );
                                      },
                                    );
                                  },
                                  hateSpeech: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportHateSpeech(
                                          reportHateSpeech: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            ReportApiCalls()
                                                .reportPostHateSpeech(
                                                    "Video", widget.postID!);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog

                                                return ReportPostSpam();
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  spam: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportPostSpam();
                                      },
                                    );
                                  },
                                  nudity: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportPostNudity(
                                          reportNudity: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            ReportApiCalls().reportPostNudity(
                                                "Video", widget.postID!);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog

                                                return ReportPostSpam();
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  shortcode: widget.username!,
                                );
                              },
                            );
                          },
                          title: Text(
                            AppLocalizations.of("Report Inappropriate"),
                            style: whiteNormal.copyWith(fontSize: 12.0.sp),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);

                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20.0),
                                      topRight: const Radius.circular(20.0))),
                              context: context,
                              builder: (BuildContext bc) {
                                return EmbedPost(
                                  copyEmbed: () {
                                    Navigator.pop(context);

                                    Clipboard.setData(ClipboardData(
                                        text: widget.controller!.text));
                                    Future.delayed(Duration(seconds: 1), () {
                                      widget.copied!();
                                      // _scaffoldKey.currentState.showSnackBar(showSnackBar('URL Copied'));
                                    });
                                  },
                                  textEditingController: widget.controller,
                                );
                              },
                            );
                          },
                          title: Text(
                            AppLocalizations.of(
                              "Embed",
                            ),
                            style: whiteNormal.copyWith(fontSize: 12.0.sp),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);

                            Clipboard.setData(
                                ClipboardData(text: widget.shareUrl));
                            Future.delayed(Duration(seconds: 1), () {
                              widget.copied!();
                              //  _scaffoldKey.currentState.showSnackBar(showSnackBar('Link Copied'));
                            });
                          },
                          title: Text(
                            AppLocalizations.of(
                              "Copy Link",
                            ),
                            style: whiteNormal.copyWith(fontSize: 12.0.sp),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);

                            ReportApiCalls()
                                .postRebuzz("Video", widget.postID!);
                            Future.delayed(Duration(seconds: 1), () {
                              widget.rebuzed!();
                              //  _scaffoldKey.currentState.showSnackBar(showSnackBar('Link Copied'));
                            });
                          },
                          title: Text(
                            AppLocalizations.of(
                              "Rebuz",
                            ),
                            style: whiteNormal.copyWith(fontSize: 12.0.sp),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }, AppLocalizations.of('More'), 0),
        ],
      ),
    );
  }
}
