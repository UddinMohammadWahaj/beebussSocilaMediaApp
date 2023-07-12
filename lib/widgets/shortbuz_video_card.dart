import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/config/agora.config.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_like_unline_post_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_video_list_model.dart';
import 'package:bizbultest/models/shortbuz_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_likes_api_calls.dart';
import 'package:bizbultest/services/FeedAllApi/report_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/simple_web_view.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/create_a_shortbuz.dart';
import 'package:bizbultest/widgets/post_report_other_popup.dart';
import 'package:bizbultest/widgets/post_report_popup.dart';
import 'package:bizbultest/widgets/scolling_music.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/shortbuz_comment_page.dart';
import 'package:bizbultest/widgets/shortbuz_report_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'dart:math' as math;
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/shortbuz_video_player.dart';
import 'dart:ui' as ui;

import '../view/shortbuzsearch.dart';
import 'Newsfeeds/feeds_menu_otherMember.dart';
import 'Newsfeeds/publish_state.dart';

class ShortBuzVideoCard extends StatefulWidget {
  final Data? video;
  final int? index;
  final VoidCallback? onTap;
  final Function? hideNavbar;
  final Function? refresh;
  final List<StickerVideo>? stickerList;
  final List<Position>? positionList;
  final Function? notInterested;
  final Function? jumpToFeeds;
  final Function? jumpBack;
  var postid;
  String from;
  ShortBuzVideoCard(
      {Key? key,
      this.from = "",
      this.video,
      this.index,
      this.jumpBack,
      this.onTap,
      this.hideNavbar,
      this.refresh,
      this.stickerList,
      this.positionList,
      this.notInterested,
      this.postid,
      this.jumpToFeeds})
      : super(key: key);

  @override
  _ShortBuzVideoCardState createState() => _ShortBuzVideoCardState();
}

class _ShortBuzVideoCardState extends State<ShortBuzVideoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String followStatus = "";
  bool isLiked = false;
  late Uri uri;
  bool newShortbuz = false;
  RefreshShortbuz refresh = new RefreshShortbuz();

  void _createLink() async {
    uri = await DeepLinks.createShortbuzDeepLink(
        widget.video!.postUserId!,
        "shortbuz",
        widget.video!.postImgData!,
        widget.video!.postContent != "" &&
                widget.video!.postContent!.length > 50
            ? widget.video!.postContent!.substring(0, 50) + "..."
            : widget.video!.postContent!,
        "${widget.video!.postShortcode}",
        widget.video!.postId!);
  }

  void _checkLikeStatus() {
    if (widget.video!.postLikeIcon ==
        "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
      setState(() {
        isLiked = true;
      });
    } else {
      setState(() {
        isLiked = false;
      });
    }
  }

  void _shareVideo() async {
    //  Uri uri = await DeepLinks.createBlogDeepLink(
    //                       widget.,
    //                       "blog",
    //                       widget.image,
    //                       widget.blogTitle != "" && widget.blogTitle.length > 50
    //                           ? widget.blogTitle.substring(0, 50) + "..."
    //                           : widget.blogTitle,
    //                       "${widget.shortcode}",
    //                       widget.blogId);
    Share.share(
      '${uri.toString()}',
    );
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: uri.toString()));
    customToastBlack(
        AppLocalizations.of(
          "Link Copied",
        ),
        15,
        ToastGravity.CENTER);
  }

  void _openComments() {
    print("opened comments");
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        context: context,
        builder: (BuildContext bc) {
          return ShortbuzCommentPage(
            feed: widget.video!,
            refresh: (val) {
              print(val.toString() + " aaaaaaa");
              setState(() {
                widget.video!.postTotalComments = int.parse(val);
              });
            },
          );
        });
  }

  downloadVideo() async {
    var url =
        'https://www.bebuzee.com/api/download_video.php?post_id=${widget.video!.postId}';
    var response = await ApiProvider().fireApi(url);
    return response.data['data'];
  }

  void _openReportMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        context: context,
        builder: (BuildContext bc) {
          return ShortbuzReportMenu(
            postID: widget.video!.postId,
            image: widget.video!.postImgData,
            saveVideo: () async {
              Navigator.pop(bc);
              customToastBlack(
                  AppLocalizations.of("Saved video to this device."),
                  15,
                  ToastGravity.CENTER);
              var downloadurl = await downloadVideo();

              print("downloaded url=${downloadurl} ${widget.video!.video}");

              GallerySaver.saveVideo(downloadurl);
              // customToastBlack(
              //     AppLocalizations.of("Saved video to this device"),
              //     15,
              //     ToastGravity.CENTER);
            },
            notInterested: () async {
              Navigator.pop(bc);

              setState(() {
                print("not intereseted before=${widget.video!.notInterested}");
                widget.video!.notInterested = !widget.video!.notInterested!;
                print("not intereseted after=${widget.video!.notInterested}");
              });

              var url = 'https://www.bebuzee.com/api/post_not_intrested.php';
              var client = dio.Dio();
              var token = await ApiProvider()
                  .refreshToken(CurrentUser().currentUser.memberID!);
              print("hidden $url ${widget.video!.postId}");
              var response = await client.post(url,
                  options: Options(headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer $token',
                  }),
                  queryParameters: {
                    "post_id": widget.video!.postId,
                    "user_id": CurrentUser().currentUser.memberID
                  });
              print("hiddenresponse video=${response}");
            },
            copyLink: () {
              Navigator.pop(bc);
              _copyLink();
            },
            report: () {
              Navigator.pop(bc);
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                context: context,
                builder: (BuildContext reportContext) {
                  return PostReportPopup(
                    dontLikeIt: () {
                      Navigator.pop(reportContext);
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        //isScrollControlled:true,
                        context: context,
                        builder: (BuildContext bc) {
                          return DontLikeReport(
                            unfollow: () {
                              Navigator.pop(bc);

                              FeedLikeApiCalls.unfollow(
                                  widget.video!.postUserId!, 1);
                              Future.delayed(Duration(seconds: 1), () {
                                customToastBlack(
                                    "Unfollowed ${widget.video!.postShortcode}",
                                    15,
                                    ToastGravity.CENTER);
                              });
                            },
                            shortcode: widget.video!.postShortcode,
                            followStatus: "Following",
                          );
                        },
                      );
                    },
                    other: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        context: context,
                        builder: (BuildContext bc) {
                          return PostReportOtherPopup(
                            violence: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                //isScrollControlled:true,
                                context: context,
                                builder: (BuildContext bc) {
                                  return ReportPostViolence(
                                    reportViolence: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ReportApiCalls().reportPostViolence(
                                          widget.video!.postType!,
                                          widget.video!.postId!);
                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (BuildContext bc) {
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                //isScrollControlled:true,
                                context: context,
                                builder: (BuildContext bc) {
                                  return ReportPostSale(
                                    reportSale: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ReportApiCalls().reportPostAsSale(
                                          widget.video!.postType!,
                                          widget.video!.postId!);

                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (BuildContext bc) {
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                //isScrollControlled:true,
                                context: context,
                                builder: (BuildContext bc) {
                                  return ReportPostHarassment(
                                    reportHarassment: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ReportApiCalls().reportPostHarassment(
                                          widget.video!.postType!,
                                          widget.video!.postId!);
                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (BuildContext bc) {
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                //isScrollControlled:true,
                                context: context,
                                builder: (BuildContext bc) {
                                  return ReportPostIntellectual(
                                    reportIntellectual: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ReportApiCalls().reportPostIntellectual(
                                          widget.video!.postType!,
                                          widget.video!.postId!);

                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (BuildContext bc) {
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                //isScrollControlled:true,
                                context: context,
                                builder: (BuildContext bc) {
                                  return ReportPostInjury(
                                    reportInjury: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ReportApiCalls().reportPostInjury(
                                          widget.video!.postType!,
                                          widget.video!.postId!);

                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        context: context,
                                        builder: (BuildContext bc) {
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
                    hateSpeech: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        //isScrollControlled:true,
                        context: context,
                        builder: (BuildContext bc) {
                          return ReportHateSpeech(
                            reportHateSpeech: () {
                              Navigator.pop(context);
                              Navigator.pop(context);

                              ReportApiCalls().reportPostHateSpeech(
                                  widget.video!.postType!,
                                  widget.video!.postId!);

                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                context: context,
                                builder: (BuildContext bc) {
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
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
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
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext bc) {
                          return ReportPostNudity(
                            reportNudity: () {
                              Navigator.pop(context);
                              Navigator.pop(context);

                              ReportApiCalls().reportPostNudity(
                                  widget.video!.postType!,
                                  widget.video!.postId!);

                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20.0),
                                        topRight: const Radius.circular(20.0))),
                                context: context,
                                builder: (BuildContext bc) {
                                  return ReportPostSpam();
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    shortcode: widget.video!.postShortcode,
                  );
                },
              );
            },
          );
        });
  }

  //! api updated
  void _likeUnlike() async {
    setState(() {
      isLiked = !isLiked;
    });
    var url =
        "https://www.bebuzee.com/api/newsfeed/postLikeUnlike?action=post_like_data&user_id=${CurrentUser().currentUser.memberID}&post_type=${widget.video!.postType}&post_id=${widget.video!.postId}";
    print(url);
    print("Like re ${url}");
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
    print("Like response =${response.data}");
    if (response.statusCode == 200) {
      print("Like response =${response.data}");
      ShortbuzLikeUnlikePostModel _likeUnlikePost =
          ShortbuzLikeUnlikePostModel.fromJson(response.data);

      if (this.mounted) {
        setState(() {
          widget.video!.postLikeIcon = _likeUnlikePost.imageData;
          widget.video!.postTotalLikes = _likeUnlikePost.totalLike.toString();
        });
      }
    }
  }

  //! api updated
  Future<String> followUser(String otherMemberId) async {
    var url =
        "https://www.bebuzee.com/api/member_follow.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId";

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

    print(response.data);

    if (response.statusCode == 200) {
      if (jsonDecode(response.data)['status'] == 201) {
        setState(() {
          followStatus = "Following";
        });
      }
    }

    return "success";
  }

  //! api updated
  Future<String> unfollowUser(String otherMemberId) async {
    var url =
        "https://www.bebuzee.com/api/member_unfollow.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId";
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

    print(response.data);
    if (response.statusCode == 200) {
      print("unfollowed");
      if (jsonDecode(response.data)['status'] == 201) {
        setState(() {
          followStatus = "Follow";
        });
      }
    }

    return "success";
  }

  Widget _textCard(String text, double size, FontWeight weight) {
    return Text(
      text,
      style: TextStyle(fontSize: size, color: Colors.white, fontWeight: weight),
      maxLines: 2,
    );
  }

  Widget _positionedWidget(double left, double right, double top, double bottom,
      Alignment alignment, Widget wid) {
    if (!widget.video!.notInterested!) {
      return Positioned.fill(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
          child: Align(alignment: alignment, child: wid));
    } else {
      return Container();
    }
  }

  Widget _iconButton(
      IconData icon, VoidCallback onTap, String text, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            constraints: BoxConstraints(),
            icon: Icon(
              icon,
              size: 28,
              color: color,
            ),
            onPressed: () {
              onTap();
            }),
        SizedBox(
          height: 2,
        ),
        Text(
          text,
          style: whiteNormal,
        )
      ],
    );
  }

  Widget _header() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (widget.from == "discover" || widget.from == "hashtagpage")
                ? Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            print("jump back called ${widget.from}");
                            widget.jumpBack!();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                      Text(
                        "Shortbuz",
                        style: whiteBold.copyWith(fontSize: 25),
                      )
                    ],
                  )
                : Text(
                    "Shortbuz",
                    style: whiteBold.copyWith(fontSize: 25),
                  ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.hideNavbar!(true);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShortbuzSearchView(),
                    ));
                  },
                  child: Icon(Icons.search, color: Colors.white, size: 30),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    widget.hideNavbar!(true);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateShortbuz(
                                  setNavbar: widget.hideNavbar!,
                                  refresh: widget.refresh!,
                                  from: true,
                                  refreshFromShortbuz: () {
                                    widget.jumpToFeeds!();
                                    widget.hideNavbar!(false);
                                    setState(() {
                                      newShortbuz = true;
                                    });
                                  },
                                )));
                  },
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget sponsorCard() {
    return Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0.w)),
              color: Colors.black.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    child: Text(
                  'Sponsor Ad',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              ),
            ),
            widget.video!.boostedButton != ''
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SimpleWebView(
                            url: widget.video!.boostedLink!,
                            heading: widget.video!.boostedTitle),
                      ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0.w)),
                      color: Colors.white,
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 30.0.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.video!.boostedButton}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          )),
                    ),
                  )
                : Container()
          ],
        ));
  }

  Widget _videoDescription() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.video!.boostData == 1 ? sponsorCard() : Container(),
        _textCard(widget.video!.postShortcode!, 14, FontWeight.bold),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: _textCard(widget.video!.postContent!, 14, FontWeight.normal),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(
                CustomIcons.music,
                color: Colors.white,
                size: 12,
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.0.h),
                child: Container(
                  width: 40.0.w,
                  child: MarqueeWidget(
                    direction: Axis.horizontal,
                    child: Text(
                        AppLocalizations.of(
                          "Original Audio",
                        ),
                        style: whiteNormal.copyWith(fontSize: 14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _musicCard() {
    return Stack(
      children: [
        Image.asset(
          "assets/images/musicLoading.gif",
          height: 60,
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * math.pi,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(widget.video!.postUserPicture!),
                          ),
                        );
                      }),
                ],
              )),
        )
      ],
    );
  }

  void _refreshFeeds() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        newShortbuz = false;
      });
      widget.refresh!();
      refresh.updateRefresh(false);
    });
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    FeedLikeApiCalls.checkFollowStatus(widget.video!.postUserId!).then((value) {
      followStatus = value;
      return value;
    });

    _checkLikeStatus();
    _createLink();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> getToken() async {
      return await ApiProvider()
          .refreshToken(CurrentUser().currentUser.memberID!);
    }

    return StreamBuilder<Object>(
        initialData: refresh.currentSelect,
        stream: refresh.observableCart,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            _refreshFeeds();
            // print("not null shortbuz ${widget.video}");
          } else {
            // print("not null shortbuz ${widget.video}");
          }
          // return Center(
          //   child: Container(
          //     height: 200,
          //     width: 200,
          //     child: Text('Hello'),
          //   ),
          // );

          //  ShortbuzVideoPlayer(
          //   isHidden: widget.video!.notInterested ?? false,
          //   positionList: widget.positionList,
          //   stickerList: widget.stickerList,
          //   index: widget.index!,
          //   url: widget.video!.video!,
          //   image: widget.video!.postImgData,
          // );

          return Stack(
            children: [
              Container(
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                      sigmaY:
                          //  widget.video!.notInterested! ? 15 :
                          0,
                      sigmaX:
                          // widget.video!.notInterested! ? 15 :
                          0),
                  child: Container(
                    height: 100.0.h,
                    width: 100.0.w,
                    child: Stack(
                      children: [
                        ShortbuzVideoPlayer(
                          isHidden: widget.video!.notInterested,
                          positionList: widget.positionList,
                          stickerList: widget.stickerList,
                          index: widget.index!,
                          url: widget.video!.video!,
                          image: widget.video!.postImgData,
                        ),
                        _positionedWidget(
                            0, 0, 1.0.h, 0, Alignment.topLeft, _header()),
                        !widget.video!.notInterested!
                            ? Positioned.fill(
                                right: 1.5.h,
                                top: 40.0.h,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: widget.onTap ?? () {},
                                            child: Container(
                                              child: CircleAvatar(
                                                radius: 40,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        widget.video!
                                                            .postUserPicture!),
                                              ),
                                            ),
                                          ),
                                          followStatus != null
                                              ? Positioned.fill(
                                                  child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (followStatus ==
                                                              "Follow") {
                                                            followUser(widget
                                                                .video!
                                                                .postUserId!);
                                                          } else {
                                                            unfollowUser(widget
                                                                .video!
                                                                .postUserId!);
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border:
                                                                new Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Material(
                                                            // pause button (round)
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50), // change radius size
                                                            color:
                                                                primaryBlueColor, //button colour
                                                            child: SizedBox(
                                                              //customisable size of 'button'
                                                              child:
                                                                  followStatus ==
                                                                          "Follow"
                                                                      ? Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              16,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .check,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              16,
                                                                        ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    )),
                              )
                            : Container(),
                        _positionedWidget(
                            0,
                            1.5.h,
                            50.0.h,
                            0,
                            Alignment.topRight,
                            _iconButton(CustomIcons.like, () {
                              _likeUnlike();
                            }, widget.video!.postTotalLikes!.split(' ')[0],
                                isLiked ? Colors.red : Colors.white)),
                        _positionedWidget(
                            0,
                            1.5.h,
                            58.0.h,
                            0,
                            Alignment.topRight,
                            _iconButton(CustomIcons.chat, () {
                              print("clicked on open comments");
                              _openComments();
                            }, widget.video!.postTotalComments.toString(),
                                Colors.white)),
                        _positionedWidget(
                            0,
                            1.5.h,
                            66.0.h,
                            0,
                            Alignment.topRight,
                            _iconButton(CustomIcons.shareshortbuz, () {
                              _shareVideo();
                            }, "", Colors.white)),
                        _positionedWidget(
                            0,
                            1.5.h,
                            74.0.h,
                            0,
                            Alignment.topRight,
                            _iconButton(Icons.more_vert_outlined, () {
                              _openReportMenu();
                            }, "", Colors.white)),
                        _positionedWidget(1.5.h, 1.5.h, 0, 3.0.h,
                            Alignment.bottomLeft, _videoDescription()),
                        _positionedWidget(0, 1.5.h, 80.0.h, 0,
                            Alignment.topRight, _musicCard()),
                      ],
                    ),
                  ),
                ),
              ),
              widget.video!.notInterested!
                  ? Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    child: Text(
                                  AppLocalizations.of(
                                    "This post has been hidden. We will show fewer posts like this from now on",
                                  ),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                                InkWell(
                                    onTap: () async {
                                      setState(() {
                                        widget.video!.notInterested =
                                            !widget.video!.notInterested!;
                                      });
                                      var url =
                                          'https://www.bebuzee.com/api/post_not_intrested.php';
                                      var client = dio.Dio();
                                      var token = await getToken();
                                      var response = await client.post(url,
                                          options: Options(headers: {
                                            'Content-Type': 'application/json',
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          }),
                                          queryParameters: {
                                            "post_id": widget.video!.postId,
                                            "user_id": CurrentUser()
                                                .currentUser
                                                .memberID
                                          });
                                      print("hiddenresponse video=${response}");
                                    },
                                    child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 15),
                                          child: Text(
                                            AppLocalizations.of(
                                              "Undo",
                                            ),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: primaryBlueColor),
                                          ),
                                        )))
                              ],
                            ),
                          )),
                    )
                  : Container(),
              newShortbuz
                  ? Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 100.0.w,
                            color: Colors.black.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.videocam_sharp,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          "Sharing to Shortbuz",
                                        ),
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 0.8,
                                        color: Colors.white,
                                        width: 100.0.w - 60,
                                      )
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          )),
                    )
                  : Container()
            ],
          );
        });
  }
}
