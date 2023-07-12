import 'dart:async';
import 'dart:convert';
// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/FeedAllApi/report_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/Chat/expanded_files_multiple.dart';
import 'package:bizbultest/view/edit_blog.dart';
import 'package:bizbultest/view/expanded_feed.dart';
import 'package:bizbultest/view/locations_page.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../post_report_other_popup.dart';
import '../post_report_popup.dart';
import 'feeds_menu_otherMember.dart';

class FeedHeader extends StatefulWidget {
  final NewsFeedModel? feed;
  final VoidCallback? onPressedMenu;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final GlobalKey<ScaffoldState>? sKey;
  final Function? refresh;

  FeedHeader(
      {Key? key,
      this.onPressedMenu,
      this.feed,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.sKey,
      this.refresh})
      : super(key: key);

  @override
  _FeedHeaderState createState() => _FeedHeaderState();
}

class _FeedHeaderState extends State<FeedHeader> {
  bool? hasFollowed = false;
  bool? showMore = false;
  String? followSuccess;
  RefreshProfile refreshProfile = new RefreshProfile();

  Future<void> commentOnOff(String postType, String postID) async {
    var newurl =
        'https://www.bebuzee.com/api/post_comment_on_off.php?post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}';

    var response = await ApiProvider().fireApi(newurl);
    print("turn of comment response=$response");

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=turn_off_on_comment_result&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);
    if (response.statusCode == 200) {
      widget.feed!.postCommentResult = response.data['result_text'];
    }
  }

  Future<String?> followUser(String otherMemberId, int index) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    var response = await http.get(url);

    setState(() {
      var convertJson = json.decode(response.body);
      followSuccess = convertJson['return_val'];
    });

    if (response.statusCode == 200) {
      setState(() {
        hasFollowed = true;
      });
    }

    return followSuccess;
  }

  Future<void> postDelete(String postType, String postID) async {
    print("Post delete called");
    String newurl =
        'https://www.bebuzee.com/api/delete_post.php?post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}';
    print("$newurl");
    var response = await ApiProvider().fireApi(newurl);

    print("Response is $response");
    //   var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=delete_post_data&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    if (response.statusCode == 200) {}
  }

  Future<void> postUpdate(String postID, String content) async {
    FeedController feedController = Get.put(FeedController());
    feedController.postUpdate(postID, content);
  }

  Future<String> unfollow(String unfollowerID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID");
    var response = await http.get(url);
    return "success";
  }

  @override
  void initState() {
    showMore = widget.feed!.postContent!.length > 80 ? false : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FeedTopHeader(
          onTapMenu: () {
            showMaterialModalBottomSheet(
              expand: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              context: context,
              builder: (BuildContext bc) {
                return FeedHeaderMenu(
                  feed: widget.feed,
                  skey: widget.sKey,
                  commentOnOff: () {
                    Navigator.pop(context);
                    commentOnOff(widget.feed!.postType, widget.feed!.postId!);
                    if (widget.feed!.postCommentResult ==
                        "Turn Off Commenting") {
                      Future.delayed(Duration(seconds: 1), () {
                        ScaffoldMessenger.of(widget.sKey!.currentState!.context)
                            .showSnackBar(showSnackBar(
                                AppLocalizations.of('Commenting turned off')));
                      });
                    } else {
                      Future.delayed(Duration(seconds: 1), () {
                        ScaffoldMessenger.of(widget.sKey!.currentState!.context)
                            .showSnackBar(showSnackBar(
                                AppLocalizations.of('Commenting turned on')));
                      });
                    }
                  },
                  embed: () {
                    Navigator.pop(context);
                    print("embed called");
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      context: context,
                      builder: (BuildContext bc) {
                        return EmbedPost(
                          embedData: widget.feed!.postEmbedData,
                          copyEmbed: () {
                            Navigator.pop(context);
                            Clipboard.setData(ClipboardData(
                                text: widget.feed!.emberController.text));
                            Future.delayed(Duration(seconds: 1), () {
                              ScaffoldMessenger.of(
                                      widget.sKey!.currentState!.context)
                                  .showSnackBar(showSnackBar(
                                      AppLocalizations.of('URL Copied')));
                            });
                          },
                          textEditingController: widget.feed!.emberController,
                        );
                      },
                    );
                  },
                  copy: () async {
                    Navigator.pop(context);
                    Uri uri = await DeepLinks.createPostDeepLink(
                        widget.feed!.postUserId!,
                        "post",
                        widget.feed!.postType == "Image" ||
                                widget.feed!.postType == "feedpost"
                            ? widget.feed!.postImgData!
                                .split("~~")[0]
                                .replaceAll("/compressed", "")
                                .replaceAll(".mp4", ".jpg")
                            : widget.feed!.postVideoThumb!,
                        widget.feed!.postContent != "" &&
                                widget.feed!.postContent!.length > 50
                            ? widget.feed!.postContent!.substring(0, 50) + "..."
                            : widget.feed!.postContent!,
                        "${widget.feed!.postShortcode!}",
                        widget.feed!.postId!);
                    Clipboard.setData(ClipboardData(text: uri.toString()));

                    Future.delayed(Duration(milliseconds: 300), () {
                      ScaffoldMessenger.of(widget.sKey!.currentState!.context)
                          .showSnackBar(showSnackBar(
                        AppLocalizations.of(
                          'Link Copied',
                        ),
                      ));
                    });
                  },
                  editPost: () {
                    Navigator.pop(context);
                    if (widget.feed!.postType != "blog") {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        //isScrollControlled:true,
                        context: context,
                        builder: (BuildContext bc) {
                          return EditPost(
                            content: widget.feed!.postContent,
                            updatePost: () {
                              Navigator.pop(context);
                              setState(() {
                                widget.feed!.postContent =
                                    widget.feed!.postUpdateController.text;
                              });
                              RefreshPostContent refresh =
                                  new RefreshPostContent();
                              ScaffoldMessenger.of(
                                      widget.sKey!.currentState!.context)
                                  .showSnackBar(showSnackBar(
                                AppLocalizations.of('Post Updated'),
                              ));
                              postUpdate(widget.feed!.postId!,
                                  widget.feed!.postUpdateController.text);
                              refresh.updatePost(true);
                            },
                            editingController:
                                widget.feed!.postUpdateController,
                          );
                        },
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditBlog(
                                    blogID: widget.feed!.blogId,
                                    blogCategory: widget.feed!.postBlogCategory,
                                    blogImage: widget.feed!.postImgData,
                                    blogTitle: widget.feed!.postContent,
                                    logo: CurrentUser().currentUser.logo,
                                    country: CurrentUser().currentUser.country,
                                    memberID:
                                        CurrentUser().currentUser.memberID,
                                    blogContent: widget.feed!.blogContent,
                                  )));
                    }
                  },
                  deletePost: () async {
                    postDelete(widget.feed!.postType, widget.feed!.postId!);
                    print("after post delete");
                    widget.refresh!();
                    refreshProfile.updateRefresh(true);
                    Navigator.pop(context);
                    Future.delayed(Duration(seconds: 2), () {
                      ScaffoldMessenger.of(widget.sKey!.currentState!.context)
                          .showSnackBar(showSnackBar(
                              AppLocalizations.of('Post Deleted')));
                    });
                  },
                  postUserId: widget.feed!.postUserId,
                  memberID: CurrentUser().currentUser.memberID,
                  share: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      //isScrollControlled:true,
                      context: context,
                      builder: (BuildContext bc) {
                        return PostShare(
                          shortcode: widget.feed!.postShortcode,
                          postID: widget.feed!.postId,
                          image: widget.feed!.thumbnailUrl,
                          hasRebuzz: widget.feed!.hasRebuzzed,
                          shareUrl: () async {
                            Navigator.pop(context);
                            Uri uri = await DeepLinks.createPostDeepLink(
                                widget.feed!.postUserId!,
                                "post",
                                widget.feed!.postType! == "Image" ||
                                        widget.feed!.postType! == "feedpost"
                                    ? widget.feed!.postImgData!
                                        .split("~~")[0]
                                        .replaceAll("/compressed", "")
                                        .replaceAll(".mp4", ".jpg")
                                    : widget.feed!.postVideoThumb!,
                                widget.feed!.postContent != "" &&
                                        widget.feed!.postContent!.length > 50
                                    ? widget.feed!.postContent!
                                            .substring(0, 50) +
                                        "..."
                                    : widget.feed!.postContent!,
                                "${widget.feed!.postShortcode}",
                                widget.feed!.postId!);
                            Share.share(
                              '${uri.toString()}',
                            );
                          },
                          rebuzz: () {
                            ReportApiCalls().postRebuzz(
                                widget.feed!.postType, widget.feed!.postId!);
                            Navigator.pop(context);
                            Future.delayed(Duration(seconds: 1), () {
                              ScaffoldMessenger.of(
                                      widget.sKey!.currentState!.context)
                                  .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Rebuzzed Successfully')));
                            });
                          },
                        );
                      },
                    );
                  },
                  shortcode: widget.feed!.postShortcode,
                  report: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      context: context,
                      builder: (BuildContext bc) {
                        return PostReportPopup(
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
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportPostViolence(
                                          reportViolence: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            ReportApiCalls().reportPostViolence(
                                                widget.feed!.postType,
                                                widget.feed!.postId!);
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
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportPostSale(
                                          reportSale: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            ReportApiCalls().reportPostAsSale(
                                                widget.feed!.postType,
                                                widget.feed!.postId!);

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
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportPostHarassment(
                                          reportHarassment: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            ReportApiCalls()
                                                .reportPostHarassment(
                                                    widget.feed!.postType,
                                                    widget.feed!.postId!);
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
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportPostIntellectual(
                                          reportIntellectual: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            ReportApiCalls()
                                                .reportPostIntellectual(
                                                    widget.feed!.postType,
                                                    widget.feed!.postId!);

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
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ReportPostInjury(
                                          reportInjury: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            ReportApiCalls().reportPostInjury(
                                                widget.feed!.postType,
                                                widget.feed!.postId!);

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
                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    unfollow(widget.feed!.postUserId!);

                                    Future.delayed(Duration(seconds: 1), () {
                                      ScaffoldMessenger.of(widget
                                              .sKey!.currentState!.context)
                                          .showSnackBar(showSnackBar(
                                              AppLocalizations.of('Unfollowed' +
                                                  " " +
                                                  widget
                                                      .feed!.postShortcode!)));
                                    });
                                  },
                                  shortcode: widget.feed!.postShortcode,
                                  followStatus: "Following",
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
                                        widget.feed!.postType,
                                        widget.feed!.postId!);

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
                                        widget.feed!.postType,
                                        widget.feed!.postId!);

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
                                );
                              },
                            );
                          },
                          shortcode: widget.feed!.postShortcode,
                        );
                      },
                    );
                  },
                  goToPost: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpandedFeed(
                                  setNavBar: widget.setNavBar!,
                                  isChannelOpen: widget.isChannelOpen!,
                                  changeColor: widget.changeColor!,
                                  feed: widget.feed!,
                                  logo: CurrentUser().currentUser.logo,
                                  country: CurrentUser().currentUser.country,
                                  memberID: CurrentUser().currentUser.memberID,
                                  currentMemberImage:
                                      CurrentUser().currentUser.image,
                                  currentMemberShortcode:
                                      CurrentUser().currentUser.shortcode,
                                )));
                  },
                );
              },
            );
          },
          onTap: () {
            setState(() {
              OtherUser().otherUser.memberID = widget.feed!.postUserId;
              OtherUser().otherUser.shortcode = widget.feed!.postShortcode;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePageMain(
                  setNavBar: widget.setNavBar!,
                  isChannelOpen: widget.isChannelOpen!,
                  changeColor: widget.changeColor!,
                  otherMemberID: widget.feed!.postUserId,
                ),
              ),
            );
          },
          feed: widget.feed!,
        ),
        widget.feed!.postType == "blog"
            ? FeedBlogHeader(
                feed: widget.feed!,
                showMore: showMore!,
                more: () {
                  setState(() {
                    showMore = !showMore!;
                  });
                },
              )
            : Container(),
      ],
    );
  }
}

class FeedTopHeader extends StatelessWidget {
  final NewsFeedModel? feed;
  final VoidCallback? onTap;
  final VoidCallback? onTapMenu;

  const FeedTopHeader({Key? key, this.feed, this.onTap, this.onTapMenu})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -3),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      onTap: onTap,
      leading: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(feed!.postUserPicture!),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            feed!.postShortcode!,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          feed!.verified != "" && feed!.verified != null
              ? Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Image.network(
                    feed!.verified!,
                    height: 12,
                  ),
                )
              : Container()
        ],
      ),
      subtitle: (feed!.postHeaderLocation != "") ||
              (feed!.postUserId != CurrentUser().currentUser.memberID &&
                  feed!.boostData != null &&
                  feed!.boostData! > 0)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                feed!.postHeaderLocation != ""
                    ? GestureDetector(
                        onTap: () {
                          print(feed!.postHeaderLocation);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationPage(
                                        latitude: feed!.postDataLat,
                                        longitude: feed!.postDataLong,
                                        feed: feed!,
                                        logo: CurrentUser().currentUser.logo,
                                        country:
                                            CurrentUser().currentUser.country,
                                        memberID:
                                            CurrentUser().currentUser.memberID,
                                        locationName: feed!.postHeaderLocation!,
                                      )));
                        },
                        child: Container(
                            width: 50.0.w,
                            child: Text(
                              feed!.postHeaderLocation != ""
                                  ? feed!.postHeaderLocation
                                  : "",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                            )),
                      )
                    : Container(),
                feed!.postUserId != CurrentUser().currentUser.memberID &&
                        feed!.boostData != null &&
                        feed!.boostData! > 0
                    ? Container(
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Sponsored",
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.public,
                              size: 15,
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            )
          : null,
      trailing: IconButton(
          onPressed: onTapMenu,
          splashRadius: 15,
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          )),
    );
  }
}

class FeedBlogHeader extends StatelessWidget {
  final bool? showMore;
  final NewsFeedModel? feed;
  final VoidCallback? more;

  const FeedBlogHeader({Key? key, this.showMore, this.feed, this.more})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              //width: 30.0.h,
              child: Text(
            showMore == null
                ? parse(feed!.postContent).documentElement!.text
                : showMore == true
                    ? parse(feed!.postContent).documentElement!.text
                    : parse(feed!.postContent)
                            .documentElement!
                            .text
                            .characters
                            .skipLast(feed!.postContent!.length - 80)
                            .toString() +
                        " ...",
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontFamily: 'Georgie'),
          )),
          GestureDetector(
            onTap: more ?? () {},
            child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.0.h,
                  ),
                  child: Text(
                    showMore == null
                        ? ""
                        : showMore == true
                            ? AppLocalizations.of('less')
                            : AppLocalizations.of('More'),
                    style: TextStyle(color: Colors.grey),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
