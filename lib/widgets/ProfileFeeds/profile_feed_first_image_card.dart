import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/expanded_user_tags_model.dart';
import 'package:bizbultest/models/profile_posts_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/discover_expanded_feed.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/Newsfeeds/feeds_menu_otherMember.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:transparent_image/transparent_image.dart';
import '../feeds_video_player.dart';

class ProfileFeedsFirstImageCard extends StatefulWidget {
  final ProfilePostModel post;
  final String? memberID;
  final String? memberImage;
  final String? logo;
  final String? country;
  final GlobalKey<ScaffoldState>? sKey;

  const ProfileFeedsFirstImageCard(
      {Key? key,
      required this.post,
      this.memberID,
      this.memberImage,
      this.logo,
      this.country,
      this.sKey})
      : super(key: key);

  @override
  _ProfileFeedsFirstImageCardState createState() =>
      _ProfileFeedsFirstImageCardState();
}

class _ProfileFeedsFirstImageCardState
    extends State<ProfileFeedsFirstImageCard> {
  late TaggedUsers usersList;
  bool areUsersLoaded = false;
  var followStatus;

  Future<void> getTaggedUsers() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=get_all_tagged_user&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.post.postId}");

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
        followStatus = jsonDecode(response.body)['return_val'];
      });
    }

    return "success";
  }

  List<Widget> getTaggedUsersIndex1() {
    List<Widget> tags = [];

    tags.add(Image.network(
      widget.post.postAllImage!,
      fit: BoxFit.cover,
    ));
    tags.add(widget.post.whiteHeartLogo == true
        ? Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/white_heart.png",
                  height: 100,
                )),
          )
        : Container());
    if (widget.post.postTaggedDataDetails != "" &&
        widget.post.showUserTags == true) {
      widget.post.postTaggedDataDetails!.split("~~~").forEach((e) {
        tags.add(Positioned.fill(
          child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: (double.parse(e.split("^^")[2]) / 100) *
                          (MediaQuery.of(context).size.width /
                              widget.post.postImageWidth!) *
                          widget.post.postImageHeight!,
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
    tags.add(widget.post.postTaggedDataDetails != ""
        ? Positioned.fill(
            bottom: 7,
            left: 10,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () {
                    print(widget.post.postId);
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
                                                child: InkWell(
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
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: new Border
                                                                  .all(
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
                                                                      followUser(
                                                                          user.memberId!);
                                                                      Timer(
                                                                          Duration(
                                                                              seconds: 3),
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
                                                                              seconds: 3),
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
                                                                          horizontal: 4.0
                                                                              .w,
                                                                          vertical:
                                                                              0.8.h),
                                                                      child:
                                                                          Text(
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
        widget.post.postLikeLogo = jsonDecode(response.body)['image_data'];
        widget.post.postTotalLikes = jsonDecode(response.body)['total_likes'];
      });
    }
  }

  Future<void> postRebuzz(String postType, String postID) async {
    var newurl =
        'https://www.bebuzee.com/api/post_rebuzz.php?post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}';

    print('url rebuz= ${newurl}');
    var response = await ApiProvider().fireApi(newurl);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=share_post_data&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);
    // if (response.statusCode == 200 &&
    //     response.data != null &&
    //     response.data != "") {
    //   print(response.data);
    //   print("rebuzzed success");
    // }

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=share_post_data&post_type=$postType&post_id=$postID&user_id=${widget.memberID}");

    // var response = await http.get(url);

    // print(response.body);
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
    return Column(
      children: [
        widget.post.dataMultiImage == 1 && widget.post.postType == "Image"
            ? GestureDetector(
                onDoubleTap: () {
                  print(widget.post.postLikeLogo);
                  if (widget.post.postLikeLogo !=
                      "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                    likeUnlike(widget.post.postType, widget.post.postId!);

                    setState(() {
                      widget.post.whiteHeartLogo = true;
                    });
                    Timer(Duration(seconds: 2), () {
                      setState(() {
                        widget.post.whiteHeartLogo = false;
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
                                  widget.post.pageIndex = val;
                                });
                              },
                              itemCount:
                                  widget.post.postAllImages!.split("~~").length,
                              itemBuilder: (context, indexImage) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      widget.post.postAllImages!
                                          .split("~~")[indexImage],
                                      fit: BoxFit.cover,
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
                                children: widget.post.postAllImages!
                                    .split("~~")
                                    .map((e) {
                                  var ind = widget.post.postAllImages!
                                      .split("~~")
                                      .indexOf(e);
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor:
                                          widget.post.pageIndex == ind
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
                                  padding:
                                      EdgeInsets.only(top: 1.0.h, right: 1.5.w),
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0.w, vertical: 1.0.w),
                                        child: Text(
                                          (widget.post.pageIndex! + 1)
                                                  .toString() +
                                              "/" +
                                              widget.post.postAllImages!
                                                  .split("~~")
                                                  .length
                                                  .toString(),
                                          style: whiteNormal.copyWith(
                                              fontSize: 10.0.sp),
                                        ),
                                      )))),
                        ),
                        widget.post.postDomainName != "" &&
                                widget.post.postDomainName != null
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
                                          print("clicked on not image");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebsiteView(
                                                        url: widget
                                                            .post.postUrlName,
                                                        heading: "",
                                                      )));
                                        },
                                        child: Container(
                                          color: Colors.grey[800],
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward_outlined,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                Text(
                                                  widget.post.postDomainName!,
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
                        widget.post.whiteHeartLogo == true
                            ? Positioned.fill(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/white_heart.png",
                                      height: 100,
                                    )),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              )
            : widget.post.postType == "Image"
                ? GestureDetector(
                    onTap: () {
                      print("clicked on image");
                      setState(() {
                        widget.post.showUserTags = true;
                      });

                      Timer(Duration(seconds: 2), () {
                        setState(() {
                          widget.post.showUserTags = false;
                        });
                      });
                    },
                    onDoubleTap: () {
                      if (widget.post.postLikeLogo !=
                          "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                        likeUnlike(widget.post.postType, widget.post.postId!);

                        setState(() {
                          widget.post.whiteHeartLogo = true;
                        });
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            widget.post.whiteHeartLogo = false;
                          });
                        });
                      }
                    },
                    child: Stack(children: getTaggedUsersIndex1()),
                  )
                : widget.post.postType == "Video" ||
                        widget.post.postType == "svideo" ||
                        widget.post.postType == "sVideo"
                    ? AspectRatio(
                        aspectRatio: widget.post.postVideoWidth! /
                            widget.post.postVideoHeight!,
                        child: FeedsVideoPlayer(
                          url: widget.post.postVideo,
                          aspect: widget.post.postVideoWidth! /
                              widget.post.postVideoHeight!,
                          image: widget.post.postAllImage,
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
          padding: EdgeInsets.only(
              top: widget.post.postType == "svideo" ||
                      widget.post.postType == "Svideo"
                  ? 2.0.h
                  : 1.0.h,
              left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        print("tapped");
                        likeUnlike(widget.post.postType, widget.post.postId!);

                        if (widget.post.postLikeLogo !=
                            "https://www.bebuzee.com/new_files/Like-Icon-715x715.png") {
                          setState(() {
                            widget.post.whiteHeartLogo = true;
                          });
                          Timer(Duration(seconds: 2), () {
                            setState(() {
                              widget.post.whiteHeartLogo = false;
                            });
                          });
                        }
                      },
                      child: Image.network(
                        widget.post.postLikeLogo!,
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
                                    logo: widget.logo!,
                                    country: widget.country!,
                                    memberID: widget.memberID!,
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
                                Share.share(widget.post.postUrl!);

                                print("shared");
                                // print(widget.feed.postUrlToShare);
                              },
                              rebuzz: () {
                                // print(widget.feed.hasRebuzzed);
                                postRebuzz(
                                    widget.post.postType, widget.post.postId!);
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
              widget.post.postType == "Video" ||
                      widget.post.postType == "svideo"
                  ? widget.post.postNumberOfViews.toString()
                  : widget.post.postTotalLikes.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          )),
        ),
      ],
    );
  }
}
