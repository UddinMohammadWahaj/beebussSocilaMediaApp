import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/story_user_views_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class UserViewsCard extends StatefulWidget {
  final StoryUserViewsModel user;
  final Function onTap;

  UserViewsCard({Key? key, required this.user, required this.onTap})
      : super(key: key);

  @override
  _UserViewsCardState createState() => _UserViewsCardState();
}

class _UserViewsCardState extends State<UserViewsCard> {
  late int followStatus;
  int hideStatus = 0;

  Future<void> hideStory() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_story_data.php?action=story_hide_data&user_id=${CurrentUser().currentUser.memberID}&user_id_story_to_hide=${widget.user.memberId}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  Future<void> unhideStory() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_story_data.php?action=story_unhide_hide_data&user_id=${CurrentUser().currentUser.memberID}&user_id_story_to_hide=${widget.user.memberId}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  HomepageRefreshState refresh = new HomepageRefreshState();

  Future<String> followUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      refresh.updateRefresh(true);
    }

    return "success";
  }

  Future<String> unfollow(String unfollowerID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      refresh.updateRefresh(true);
    }

    return "success";
  }

  @override
  void initState() {
    if (widget.user.followStatus == "Following") {
      followStatus = 1;
    } else {
      followStatus = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          widget.onTap(widget.user.memberId, widget.user.shortcode);
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(widget.user.image!),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 40.0.w,
                          child: Text(
                            widget.user.shortcode!,
                            style: TextStyle(
                                color: Colors.black, fontSize: 10.0.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      SizedBox(
                        height: 1.5,
                      ),
                      Container(
                          width: 40.0.w,
                          child: Text(
                            widget.user.userName!,
                            style: TextStyle(
                                color: Colors.grey, fontSize: 10.0.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
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
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Center(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.grey.withOpacity(0.3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            shape: BoxShape.rectangle,
                                          ),
                                          height: 4,
                                          width: 50,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                          child: Text(
                                        widget.user.shortcode!,
                                        style: blackBold.copyWith(
                                            fontSize: 12.0.sp),
                                      )),
                                    ),
                                    Container(
                                      height: 1,
                                      width: 100.0.w,
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              backgroundColor: Colors.white,
                                              elevation: 5,
                                              child: Container(
                                                child: Wrap(
                                                  children: [
                                                    Center(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 30,
                                                                horizontal: 30),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                "Block",
                                                              ) +
                                                              " ${widget.user.shortcode}?",
                                                          style: blackBold
                                                              .copyWith(
                                                                  fontSize:
                                                                      15.0.sp),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 60,
                                                                right: 60,
                                                                bottom: 20),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                            "They wont't be able to find your profile, posts or story on Bebuzee. We won't let them know you blocked them.",
                                                          ),
                                                          style: greyNormal
                                                              .copyWith(
                                                                  fontSize:
                                                                      10.0.sp),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100.0.w,
                                                      height: 0.3,
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                    ),
                                                    Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);

                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20.0))),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 5,
                                                                  child:
                                                                      Container(
                                                                    child: Wrap(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                                                                            child:
                                                                                Text(
                                                                              "${widget.user.shortcode} " +
                                                                                  AppLocalizations.of(
                                                                                    "Blocked",
                                                                                  ),
                                                                              style: blackBold.copyWith(fontSize: 15.0.sp),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsets.only(
                                                                                left: 60,
                                                                                right: 60,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text(
                                                                              AppLocalizations.of(
                                                                                "You can unblock them anytime from their profile.",
                                                                              ),
                                                                              style: greyNormal.copyWith(fontSize: 10.0.sp),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100.0.w,
                                                                          height:
                                                                              0.3,
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.4),
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: 20),
                                                                              child: Container(
                                                                                child: Text(
                                                                                  AppLocalizations.of(
                                                                                    "OK",
                                                                                  ),
                                                                                  style: TextStyle(fontSize: 12.0.sp, color: primaryBlueColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 20),
                                                          child: Container(
                                                            child: Text(
                                                              AppLocalizations
                                                                  .of("Block"),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  color:
                                                                      primaryBlueColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100.0.w,
                                                      height: 0.3,
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                    ),
                                                    Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 20),
                                                          child: Container(
                                                            child: Text(
                                                              AppLocalizations
                                                                  .of(
                                                                "Cancel",
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      title: Text(
                                        AppLocalizations.of("Block"),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);

                                        if (followStatus == 1) {
                                          setState(() {
                                            followStatus = 0;
                                          });
                                          unfollow(widget.user.memberId!);
                                          Fluttertoast.showToast(
                                            msg: AppLocalizations.of(
                                                  "Unfollowed",
                                                ) +
                                                " ${widget.user.shortcode}",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor:
                                                Colors.black.withOpacity(0.7),
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          setState(() {
                                            followStatus = 1;
                                          });
                                          followUser(widget.user.memberId!);
                                          Fluttertoast.showToast(
                                            msg: AppLocalizations.of(
                                                  "Followed",
                                                ) +
                                                " ${widget.user.shortcode}",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor:
                                                Colors.black.withOpacity(0.7),
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      },
                                      title: Text(
                                        followStatus == 1
                                            ? AppLocalizations.of(
                                                "Unfollow",
                                              )
                                            : AppLocalizations.of(
                                                "Follow",
                                              ),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        if (hideStatus == 0) {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.0))),
                                                  backgroundColor: Colors.white,
                                                  elevation: 5,
                                                  child: Container(
                                                    child: Wrap(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        30,
                                                                    horizontal:
                                                                        30),
                                                            child: Text(
                                                              AppLocalizations
                                                                      .of(
                                                                    "Hide your story from",
                                                                  ) +
                                                                  " ${widget.user.shortcode}?",
                                                              style: blackBold
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15.0.sp),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 60,
                                                                    right: 60,
                                                                    bottom: 20),
                                                            child: Text(
                                                              "${widget.user.shortcode} " +
                                                                  AppLocalizations
                                                                      .of(
                                                                    "wont't see any photos or videos you add to your story from now on.",
                                                                  ),
                                                              style: greyNormal
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10.0.sp),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 100.0.w,
                                                          height: 0.3,
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                        ),
                                                        Center(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                hideStatus = 1;
                                                              });
                                                              hideStory();
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg: AppLocalizations
                                                                        .of(
                                                                      "Story hidden from",
                                                                    ) +
                                                                    " ${widget.user.shortcode}",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                backgroundColor:
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.7),
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0,
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          20),
                                                              child: Container(
                                                                child: Text(
                                                                  AppLocalizations
                                                                      .of(
                                                                    "Hide",
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0
                                                                              .sp,
                                                                      color:
                                                                          primaryBlueColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 100.0.w,
                                                          height: 0.3,
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                        ),
                                                        Center(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          20),
                                                              child: Container(
                                                                child: Text(
                                                                  AppLocalizations
                                                                      .of(
                                                                    "Cancel",
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0
                                                                              .sp,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.0))),
                                                  backgroundColor: Colors.white,
                                                  elevation: 5,
                                                  child: Container(
                                                    child: Wrap(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        30,
                                                                    horizontal:
                                                                        30),
                                                            child: Text(
                                                              AppLocalizations
                                                                      .of(
                                                                    "Unhide your story from",
                                                                  ) +
                                                                  " ${widget.user.shortcode}?",
                                                              style: blackBold
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15.0.sp),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 100.0.w,
                                                          height: 0.3,
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                        ),
                                                        Center(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                hideStatus = 0;
                                                              });
                                                              unhideStory();
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg: AppLocalizations
                                                                        .of(
                                                                      "Story unhidden from",
                                                                    ) +
                                                                    " ${widget.user.shortcode}",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                backgroundColor:
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.7),
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0,
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          20),
                                                              child: Container(
                                                                child: Text(
                                                                  AppLocalizations
                                                                      .of(
                                                                    "Unhide",
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0
                                                                              .sp,
                                                                      color:
                                                                          primaryBlueColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 100.0.w,
                                                          height: 0.3,
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                        ),
                                                        Center(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          20),
                                                              child: Container(
                                                                child: Text(
                                                                  AppLocalizations
                                                                      .of(
                                                                    "Cancel",
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0
                                                                              .sp,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      },
                                      title: Text(
                                        hideStatus == 0
                                            ? AppLocalizations.of(
                                                "Hide Your Story")
                                            : AppLocalizations.of(
                                                "Unhide Your Story",
                                              ),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        widget.onTap(widget.user.memberId,
                                            widget.user.shortcode);
                                      },
                                      title: Text(
                                        AppLocalizations.of(
                                          "View Profile",
                                        ),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                        size: 22,
                        color: Colors.black,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () {},
                      icon: Icon(
                        CustomIcons.plane_thick,
                        size: 22,
                        color: Colors.black,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
