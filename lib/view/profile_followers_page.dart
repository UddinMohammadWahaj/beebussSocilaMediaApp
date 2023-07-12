import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/current_user_followings_model.dart';
import 'package:bizbultest/services/profile_api_calls.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/profile_page_main.dart';
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
import 'package:skeleton_text/skeleton_text.dart';

class ProfileFollowersPage extends StatefulWidget {
  final int? initialIndex;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final String? memberID;
  final String? shortCode;

  ProfileFollowersPage(
      {Key? key,
      this.initialIndex,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.memberID,
      this.shortCode})
      : super(key: key);

  @override
  _ProfileFollowersPageState createState() => _ProfileFollowersPageState();
}

class _ProfileFollowersPageState extends State<ProfileFollowersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Users followersList = Users([]);
  Users followingList = Users([]);
  RefreshController _followersRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController _followingRefreshController =
      RefreshController(initialRefresh: false);
  late int selectedIndex;

  void _getFollowers() {
    ProfileApiCalls.getFollowers(context, widget.memberID!).then((value) {
      if (mounted) {
        setState(() {
          followersList.usersList = value.usersList;
        });
      }
      return value;
    });
  }

  void _getFollowing() {
    ProfileApiCalls.getFollowing(context, widget.memberID!).then((value) {
      if (mounted) {
        setState(() {
          followingList.usersList = value.usersList;
        });
      }
      return value;
    });
  }

  void _onLoadingFollowers() async {
    Users? followersData = await ProfileApiCalls.onLoadingFollowers(
        followersList, context, _followersRefreshController, widget.memberID!);
    if (followersData != null) {
      if (mounted) {
        setState(() {
          followersList.usersList.addAll(followersData.usersList);
        });
      }
    }
  }

  void _onLoadingFollowing() async {
    Users? followingData = await ProfileApiCalls.onLoadingFollowing(
        followingList, context, _followingRefreshController, widget.memberID!);
    if (followingData != null) {
      if (mounted) {
        setState(() {
          followingList.usersList.addAll(followingData.usersList);
        });
      }
    }
  }

  Tab _tab(String text) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _placeHolderCard() {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -1),
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: SkeletonAnimation(
        child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.withOpacity(0.2),
            )),
      ),
      title: SkeletonAnimation(
        child: Container(
          height: 10,
          width: 30.0.w,
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      subtitle: SkeletonAnimation(
        child: Container(
          height: 10,
          width: 45.0.w,
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _placeHolderListView() {
    return ListView.builder(
        itemCount: 25,
        itemBuilder: (context, index) {
          return _placeHolderCard();
        });
  }

  @override
  void initState() {
    selectedIndex = widget.initialIndex!;
    _tabController = new TabController(
        vsync: this, length: 2, initialIndex: widget.initialIndex!);
    super.initState();
    _getFollowers();
    _getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          splashRadius: 28,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.shortCode!,
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          tabs: <Tab>[
            _tab(
              AppLocalizations.of("Followers"),
            ),
            _tab(
              AppLocalizations.of("Following"),
            ),
          ],
          controller: _tabController,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          followersList.usersList.length > 0
              ? Container(
                  child: SmartRefresher(
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
                ))
              : _placeHolderListView(),
          followingList.usersList.length > 0
              ? Container(
                  child: SmartRefresher(
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
                  controller: _followingRefreshController,
                  // onRefresh: _onRefresh,
                  onLoading: () {
                    _onLoadingFollowing();
                  },
                  child: ListView.builder(
                      itemCount: followingList.usersList.length,
                      itemBuilder: (context, index) {
                        return FollowerFollowingCard(
                          onTap: () {
                            setState(() {
                              OtherUser().otherUser.memberID =
                                  followingList.usersList[index].memberId;
                              OtherUser().otherUser.shortcode =
                                  followingList.usersList[index].shortcode;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePageMain(
                                          setNavBar: widget.setNavBar,
                                          isChannelOpen: widget.isChannelOpen,
                                          changeColor: widget.changeColor,
                                          otherMemberID: followingList
                                              .usersList[index].memberId,
                                        )));
                          },
                          user: followingList.usersList[index],
                        );
                      }),
                ))
              : _placeHolderListView(),
        ],
      ),
    );
  }
}
