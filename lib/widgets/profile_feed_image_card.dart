import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/expanded_user_tags_model.dart';
import 'package:bizbultest/models/profile_feed_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';

import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/discover_expanded_feed.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/discover_feed_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:transparent_image/transparent_image.dart';

import 'Newsfeeds/feeds_menu_otherMember.dart';
import 'feeds_video_player.dart';

class ProfileFeedsImageCard extends StatefulWidget {
  final ProfileFeedModel feed;
  final String memberID;
  final String? memberImage;
  final String logo;
  final String? country;
  final GlobalKey<ScaffoldState> sKey;

  const ProfileFeedsImageCard(
      {Key? key,
      required this.feed,
      required this.memberID,
      this.memberImage,
      required this.logo,
      this.country,
      required this.sKey})
      : super(key: key);

  @override
  _ProfileFeedsImageCardState createState() => _ProfileFeedsImageCardState();
}

class _ProfileFeedsImageCardState extends State<ProfileFeedsImageCard> {
  late TaggedUsers usersList;
  bool areUsersLoaded = false;
  var followStatus;

  Future<void> getTaggedUsers() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=get_all_tagged_user&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.feed.postId}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      TaggedUsers tagsData = TaggedUsers.fromJson(jsonDecode(response.body));

      if (this.mounted) {
        setState(() {
          usersList = tagsData;
          areUsersLoaded = true;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      setState(() {
        areUsersLoaded = false;
      });
    }
  }

//TODO :: inSheet 30
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

//TODO :: inSheet 38
  Future<String> unfollowUser(String otherMemberId) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    var response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      print("unfollowed");
      setState(() {
        followStatus = jsonDecode(response.body)['return_val'];
      });
    }

    return "success";
  }

  List<Widget> getTaggedUsersIndex1() {
    List<Widget> tags = [];

    tags.add(
      Image.network(
        widget.feed.postAllImage!,
        fit: BoxFit.cover,
      ),
    );
    tags.add(widget.feed.whiteHeartLogo == true
        ? Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/white_heart.png",
                  height: 100,
                )),
          )
        : Container());
    if (widget.feed.postTaggedDataDetails != "" &&
        widget.feed.showUserTags == true) {
      widget.feed.postTaggedDataDetails!.split("~~~").forEach((e) {
        tags.add(Positioned.fill(
          child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: (double.parse(e.split("^^")[2]) / 100) *
                          (MediaQuery.of(context).size.width /
                              widget.feed.postImageWidth!) *
                          widget.feed.postImageHeight!,
                      left: (double.parse(e.split("^^")[1]) / 100) *
                          MediaQuery.of(context).size.width),
                  child: Container(
                      color: Colors.black.withOpacity(0.8),
                      child: Padding(
                        padding: EdgeInsets.all(1.0.w),
                        child: Text(e.split("^^")[3],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                      )))),
        ));
      });
    }

    tags.add(widget.feed.postTaggedDataDetails != ""
        ? Positioned.fill(
            bottom: 7,
            left: 10,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () {
                    print(widget.feed.postId);
                    showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        //isScrollControlled:true,
                        context: context,
                        builder: (BuildContext bc) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter stateSetter) {
                            return Container(
                              child: areUsersLoaded
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: usersList.users.length,
                                      itemBuilder: (context, index) {
                                        var user = usersList.users[index];

                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.0.w,
                                              right: 4.0.h,
                                              top: 1.0.h,
                                              bottom: 2.0.h),
                                          child: Column(
                                            children: [
                                              index == 0
                                                  ? Container(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0.5.h,
                                                                    bottom:
                                                                        1.0.h),
                                                            child: Container(
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)),
                                                              ),
                                                              height: 0.7.h,
                                                              width: 8.0.w,
                                                            ),
                                                          ),
                                                          Text(
                                                            AppLocalizations.of(
                                                              "In This Photo",
                                                            ),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Divider(
                                                            thickness: 0.5,
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border:
                                                                new Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          child: CircleAvatar(
                                                            radius: 3.0.h,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            backgroundImage:
                                                                NetworkImage(user
                                                                    .imageUser!),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3.0.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              user.shortcode!,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.0.sp),
                                                            ),
                                                            Text(
                                                              user.name!,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.0.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        user.memberId !=
                                                                CurrentUser()
                                                                    .currentUser
                                                                    .memberID
                                                            ? InkWell(
                                                                splashColor: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.3),
                                                                onTap: () {
                                                                  if (user.followData ==
                                                                      "Follow") {
                                                                    followUser(user
                                                                        .memberId!);
                                                                    Timer(
                                                                        Duration(
                                                                            seconds:
                                                                                3),
                                                                        () {
                                                                      stateSetter(
                                                                          () {
                                                                        user.followData =
                                                                            followStatus;
                                                                      });
                                                                    });
                                                                  } else {
                                                                    unfollowUser(
                                                                        user.memberId!);
                                                                    Timer(
                                                                        Duration(
                                                                            seconds:
                                                                                3),
                                                                        () {
                                                                      stateSetter(
                                                                          () {
                                                                        user.followData =
                                                                            followStatus;
                                                                      });
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    color:
                                                                        primaryBlueColor,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5)),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4.0
                                                                                .w,
                                                                        vertical:
                                                                            0.8.h),
                                                                    child: Text(
                                                                      user.followData!,
                                                                      style: whiteBold.copyWith(
                                                                          fontSize:
                                                                              10.0.sp),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                  : Container(),
                            );
                          });
                        });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: new Border.all(
                          width: 0.1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/tag.png",
                          height: 14,
                        ),
                      )),
                )),
          )
        : Container());
    return tags;
  }

  Future<void> likeUnlike(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=post_like_data&user_id=${widget.memberID}&post_type=$postType&post_id=$postID");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        print(widget.feed.postId);
        print(widget.feed.postType);
        print(widget.feed.postLikeLogo);
        widget.feed.postLikeLogo = jsonDecode(response.body)['image_data'];
        widget.feed.postTotalLikes = jsonDecode(response.body)['total_likes'];
      });
    }
  }

  Future<void> postRebuzz(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=share_post_data&post_type=$postType&post_id=$postID&user_id=${widget.memberID}");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        print("rebuzz successful");
      });
    }
  }

  @override
  void initState() {
    getTaggedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.feed.postType == "svideo" ||
                  widget.feed.postType == "Svideo"
              ? 1.5.h
              : 0),
      child: Column(
        children: [
          widget.feed.dataMultiImage == 1 && widget.feed.postType == "Image"
              ? GestureDetector(
                  onDoubleTap: () {
                    print("you liked an image");
                    print(widget.feed.postLikeLogo);
                    if (widget.feed.postLikeLogo !=
                        "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                      likeUnlike(widget.feed.postType!, widget.feed.postId!);

                      setState(() {
                        widget.feed.whiteHeartLogo = true;
                      });
                      Timer(Duration(seconds: 2), () {
                        setState(() {
                          widget.feed.whiteHeartLogo = false;
                        });
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 70.0.h),
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (val) {
                                  setState(() {
                                    widget.feed.pageIndex = val;
                                  });
                                },
                                itemCount: widget.feed.postAllImage!
                                    .split("~~")
                                    .length,
                                itemBuilder: (context, indexImage) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        fit: BoxFit.cover,
                                        image: widget.feed.postAllImage!
                                            .split("~~")[indexImage],
                                      ));
                                },
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: widget.feed.postAllImage!
                                      .split("~~")
                                      .map((e) {
                                    var ind = widget.feed.postAllImage!
                                        .split("~~")
                                        .indexOf(e);
                                    return Container(
                                      margin: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        radius: 4,
                                        backgroundColor:
                                            widget.feed.pageIndex == ind
                                                ? Colors.white
                                                : Colors.grey.withOpacity(0.6),
                                      ),
                                    );
                                  }).toList()),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 1.0.h, right: 1.5.w),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0.w,
                                              vertical: 1.0.w),
                                          child: Text(
                                            (widget.feed.pageIndex! + 1)
                                                    .toString() +
                                                "/" +
                                                widget.feed.postAllImage!
                                                    .split("~~")
                                                    .length
                                                    .toString(),
                                            style: whiteNormal.copyWith(
                                                fontSize: 10.0.sp),
                                          ),
                                        )))),
                          ),
                          widget.feed.postDomainName != "" &&
                                  widget.feed.postDomainName != null
                              ? Positioned.fill(
                                  bottom: 5,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: GestureDetector(
                                          onTap: () {
                                            /* Navigator.pushNamed(
                                      context,
                                      WebsiteView.routeName,
                                      arguments:
                                      WebsiteViewArguments(url: widget.feed.postUrlNam, heading: ""),
                                    );*/
                                          },
                                          child: Container(
                                            color: Colors.grey[800],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  Text(
                                                    widget.feed.postDomainName,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          widget.feed.whiteHeartLogo == true
                              ? Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/white_heart.png",
                                        height: 100,
                                      )),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                )
              : widget.feed.postType == "Image"
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.feed.showUserTags = true;
                        });

                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            widget.feed.showUserTags = false;
                          });
                        });
                      },
                      onDoubleTap: () {
                        print("double click heart");
                        if (widget.feed.postLikeLogo !=
                            "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                          likeUnlike(
                              widget.feed.postType!, widget.feed.postId!);

                          setState(() {
                            widget.feed.whiteHeartLogo = true;
                          });
                          Timer(Duration(seconds: 2), () {
                            setState(() {
                              widget.feed.whiteHeartLogo = false;
                            });
                          });
                        }
                      },
                      child: Stack(children: getTaggedUsersIndex1()),
                    )
                  : widget.feed.postType == "Video" ||
                          widget.feed.postType == "svideo" ||
                          widget.feed.postType == "sVideo"
                      ? AspectRatio(
                          aspectRatio: widget.feed.postVideoWidth! /
                              widget.feed.postVideoHeight!,
                          child: FeedsVideoPlayer(
                            url: widget.feed.postVideo,
                            aspect: widget.feed.postVideoWidth! /
                                widget.feed.postVideoHeight!,
                            image: widget.feed.postAllImage,
                          ),
                        )
                      : Container(),
          /* widget.feed.postUserId != CurrentUser().currentUser.memberID && widget.feed.boostData > 0 && widget.feed.boostedLink != ""
              ? GestureDetector(
            onTap: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebsiteView(
                          url: widget.feed.boostedLink, heading: ""
                      )));

              print(widget.feed.boostedLink);

            },
            child: Container(
              height: 5.0.h,
              color: Color.fromRGBO(
                  int.parse(widget.feed.color.substring(4, widget.feed.color.length - 1).split(",")[0]),
                  int.parse(widget.feed.color.substring(4, widget.feed.color.length - 1).split(",")[1]),
                  int.parse(widget.feed.color.substring(4, widget.feed.color.length - 1).split(",")[2]),
                  1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.feed.boostButton, style: whiteBold),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          )
              : Container(),*/
          Padding(
            padding: EdgeInsets.only(top: 1.5.h, left: 1.5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          print("clicked Like unlikeeee");
                          likeUnlike(
                              widget.feed.postType!, widget.feed.postId!);

                          if (widget.feed.postLikeLogo !=
                              "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                            setState(() {
                              widget.feed.whiteHeartLogo = true;
                            });
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                widget.feed.whiteHeartLogo = false;
                              });
                            });
                          }
                        },
                        child: Image.network(
                          widget.feed.postLikeLogo!,
                          height: 25,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiscoverExpandedFeed(
                                      //  feed: widget.feed,
                                      logo: widget.logo,
                                      country: widget.country!,
                                      memberID: widget.memberID,
                                    )));
                      },
                      child: Image.asset(
                        "assets/images/comment.png",
                        height: 25,
                      ),
                    ),
                    SizedBox(
                      width: 19,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight: const Radius.circular(20.0))),
                            //isScrollControlled:true,
                            context: context,
                            builder: (BuildContext bc) {
                              return PostShare(
                                // hasRebuzz: widget.feed.hasRebuzzed,
                                shareUrl: () async {
                                  Share.share(widget.feed.postUrl!);

                                  print("shared");
                                  // print(widget.feed.postUrlToShare);
                                },
                                rebuzz: () {
                                  // print(widget.feed.hasRebuzzed);
                                  postRebuzz(widget.feed.postType!,
                                      widget.feed.postId!);
                                  print(widget.feed.postType);
                                  print(widget.feed.postId);
                                  print(widget.memberID);
                                  Navigator.pop(context);

                                  Future.delayed(Duration(seconds: 1), () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        showSnackBar(AppLocalizations.of(
                                            'Rebuzzed Successfully')));
                                  });
                                },
                              );
                            });
                      },
                      child: Image.asset(
                        "assets/images/share.png",
                        height: 25,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    CustomIcons.bookmark_thin,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 12),
            child: Container(
                child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.feed.postType == "Video" ||
                        widget.feed.postType == "svideo"
                    ? widget.feed.postNumberOfViews.toString()
                    : widget.feed.postTotalLikes.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
