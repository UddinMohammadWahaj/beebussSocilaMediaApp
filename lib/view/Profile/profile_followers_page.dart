import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/current_user_followings_model.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';

import 'package:bizbultest/widgets/user_followers_followings_card.dart';
import 'package:bizbultest/widgets/current_user_following.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/current_user_followers_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../profile_page_main.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

// ignore: must_be_immutable
class ProfileFollowersPage extends StatefulWidget {
  int? initialIndex;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final String? memberID;

  ProfileFollowersPage(
      {Key? key,
      this.initialIndex,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.memberID})
      : super(key: key);

  @override
  _ProfileFollowersPageState createState() => _ProfileFollowersPageState();
}

class _ProfileFollowersPageState extends State<ProfileFollowersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Users followersList;
  bool areFollowersLoaded = false;
  late CurrentUserFollowings followingList;
  bool areFollowingsLoaded = false;
  RefreshController _followersRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController _followingRefreshController =
      RefreshController(initialRefresh: false);

  Future<void> getFollowers() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followers_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=${widget.memberID}&all_user_ids=");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/user/followingData", {
      "user_id": CurrentUser().currentUser.memberID,
      "profile_user_id": widget.memberID,
      "all_user_ids": "",
    });

    if (response!.success == 1) {
      Users followerData = Users.fromJson(response!.data['data']);
      await Future.wait(followerData.usersList
          .map((e) => PreloadUserImage.cacheImage(context, e.userImage!))
          .toList());
      if (mounted) {
        setState(() {
          followersList = followerData;
          areFollowersLoaded = true;
        });
      }
    }

    if (response.data == null ||
        response.data['data'] == null ||
        response.data['data'] == "") {
      if (mounted) {
        setState(() {
          areFollowersLoaded = false;
        });
      }
    }
  }

  Future<void> getFollowing() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followings_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=${widget.memberID}&all_user_ids=");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      CurrentUserFollowings followingData =
          CurrentUserFollowings.fromJson(jsonDecode(response.body));
      await Future.wait(followingData.followers
          .map((e) => PreloadUserImage.cacheImage(context, e.userImage!))
          .toList());
      if (mounted) {
        setState(() {
          followingList = followingData;
          areFollowingsLoaded = true;
        });
      }
    }

    if (response.body == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areFollowingsLoaded = false;
        });
      }
    }
  }

  void _onLoadingFollowers() async {
    int len = followersList.usersList.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += followersList.usersList[i].memberId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    print(urlStr);
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followers_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=${widget.memberID}&all_user_ids=$urlStr");

      // var response = await http.get(url);

      var response = await ApiRepo.postWithToken("api/user/followingData", {
        "user_id": CurrentUser().currentUser.memberID,
        "profile_user_id": widget.memberID,
        "all_user_ids": urlStr,
      });

      if (response!.success == 1) {
        Users followerData = Users.fromJson(response.data['data']);
        await Future.wait(followerData.usersList
            .map((e) => PreloadUserImage.cacheImage(context, e.userImage!))
            .toList());
        // await Future.wait(feedData.feeds.map((e) => Preload.cacheImage(context, e.postVideoThumb)).toList());
        // await Future.wait(feedData.feeds.map((e) => PreloadUserImage.cacheImage(context, e.postVideoThumb)).toList());
        if (mounted) {
          setState(() {
            followersList.usersList.addAll(followerData.usersList);
            areFollowersLoaded = true;
          });
        }
      }
      if (response.data == null ||
          response.data['data'] == null ||
          response.data['data'] == "") {
        if (mounted) {
          setState(() {
            areFollowersLoaded = false;
          });
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _followersRefreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _followersRefreshController.loadComplete();
  }

  void _onLoadingFollowing() async {
    int len = followingList.followers.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += followingList.followers[i].memberId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=member_profile_followings_data&user_id=${CurrentUser().currentUser.memberID}&profile_user_id=${widget.memberID}&all_user_ids=$urlStr");

      var response = await http.get(url);

      if (response.statusCode == 200) {
        CurrentUserFollowings followingData =
            CurrentUserFollowings.fromJson(jsonDecode(response.body));
        await Future.wait(followingData.followers
            .map((e) => PreloadUserImage.cacheImage(context, e.userImage!))
            .toList());
        // await Future.wait(feedData.feeds.map((e) => Preload.cacheImage(context, e.postVideoThumb)).toList());
        // await Future.wait(feedData.feeds.map((e) => PreloadUserImage.cacheImage(context, e.postVideoThumb)).toList());
        if (mounted) {
          setState(() {
            followingList.followers.addAll(followingData.followers);
            areFollowingsLoaded = true;
          });
        }
      }
      if (response.body == null || response.statusCode != 200) {
        if (mounted) {
          setState(() {
            areFollowingsLoaded = false;
          });
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _followingRefreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _followingRefreshController.loadComplete();
  }

  @override
  void initState() {
    _tabController = new TabController(
        vsync: this, length: 2, initialIndex: widget.initialIndex!);
    super.initState();
    getFollowers();
    getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          splashColor: Colors.grey.withOpacity(0.3),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_backspace_outlined,
                  color: Colors.black,
                  size: 3.5.h,
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Text(
                  CurrentUser().currentUser.shortcode!,
                  style: blackBold.copyWith(fontSize: 14.0.sp),
                ),
              ],
            ),
          ),
        ),
        bottom: TabBar(
          indicatorColor: Colors.black,
          tabs: <Tab>[
            Tab(
              child: Text(
                AppLocalizations.of(
                  "Followers",
                ),
                style:
                    blackBold.copyWith(color: Colors.black, fontSize: 10.0.sp),
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(
                  "Following",
                ),
                style:
                    blackBold.copyWith(color: Colors.black, fontSize: 10.0.sp),
              ),
            ),
          ],
          controller: _tabController,
          onTap: (int index) {
            print(index);

            setState(() {
              widget.initialIndex = index;
            });
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: areFollowersLoaded == true
                ? SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: CustomHeader(
                      builder: (context, mode) {
                        return Container(
                          child: Center(child: loadingAnimation()),
                        );
                      },
                    ),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;

                        if (mode == LoadStatus.idle) {
                          body = Text("");
                        } else if (mode == LoadStatus.loading) {
                          body = loadingAnimation();
                        } else if (mode == LoadStatus.failed) {
                          body = Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                    color: Colors.black, width: 0.7),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(CustomIcons.reload),
                              ));
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("");
                        } else {
                          body = Text("");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _followersRefreshController,
                    // onRefresh: _onRefresh,
                    onLoading: () {
                      _onLoadingFollowers();
                    },
                    child: ListView.builder(
                        itemCount: followersList.usersList.length,
                        itemBuilder: (context, index) {
                          return FollowerFollowingCard(
                            onTap: () {
                              setState(() {
                                OtherUser().otherUser.memberID =
                                    followersList.usersList[index].memberId;
                                OtherUser().otherUser.shortcode =
                                    followersList.usersList[index].shortcode;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePageMain(
                                            setNavBar: widget.setNavBar,
                                            isChannelOpen: widget.isChannelOpen,
                                            changeColor: widget.changeColor,
                                            otherMemberID: followersList
                                                .usersList[index].memberId,
                                          )));
                            },
                            user: followersList.usersList[index],
                          );
                        }),
                  )
                : Container(),
          ),
          Container(
            child: areFollowingsLoaded == true
                ? SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: CustomHeader(
                      builder: (context, mode) {
                        return Container(
                          child: Center(child: loadingAnimation()),
                        );
                      },
                    ),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;

                        if (mode == LoadStatus.idle) {
                          body = Text("");
                        } else if (mode == LoadStatus.loading) {
                          body = loadingAnimation();
                        } else if (mode == LoadStatus.failed) {
                          body = Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                    color: Colors.black, width: 0.7),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(CustomIcons.reload),
                              ));
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("e");
                        } else {
                          body = Text("");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _followingRefreshController,
                    // onRefresh: _onRefresh,
                    onLoading: () {
                      _onLoadingFollowing();
                    },
                    child: ListView.builder(
                        itemCount: followingList.followers.length,
                        itemBuilder: (context, index) {
                          return CurrentUserFollowingPage(
                            onTap: () {
                              setState(() {
                                OtherUser().otherUser.memberID =
                                    followingList.followers[index].memberId;
                                OtherUser().otherUser.shortcode =
                                    followingList.followers[index].shortcode;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePageMain(
                                            setNavBar: widget.setNavBar,
                                            isChannelOpen: widget.isChannelOpen,
                                            changeColor: widget.changeColor,
                                            otherMemberID: followingList
                                                .followers[index].memberId,
                                          )));
                            },
                            followers: followingList.followers[index],
                          );
                        }),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
