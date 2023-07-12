import 'dart:async';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/FeedAllApi/feed_likes_api_calls.dart';
import 'package:bizbultest/models/feeds_likes_user_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class FeedLikesPage extends StatefulWidget {
  final String? postID;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final String? postType;
  FeedLikesPage(
      {Key? key,
      this.postID,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.postType})
      : super(key: key);

  @override
  _FeedLikesPageState createState() => _FeedLikesPageState();
}

class _FeedLikesPageState extends State<FeedLikesPage> {
  LikedUsers userList = LikedUsers([]);
  bool areUsersLoaded = false;
  late TextEditingController _searchController;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late Future<LikedUsers> _userFuture;
  late LikedUsers _userList;

  void _onLoading() async {
    LikedUsers? userData = await FeedLikeApiCalls.onLoading(
        _userList, context, _refreshController, widget.postID!,
        postType: widget.postType!);
    if (userData != null) {
      setState(() {
        _userList.users.addAll(userData.users);
      });
    }
  }

  @override
  void initState() {
    print(widget.postID);

    _userFuture = FeedLikeApiCalls()
        .getUsers("", widget.postID!, context, postType: widget.postType)
        .then((value) {
      setState(() {
        _userList = value;
      });
      return value;
    });
    _searchController = new TextEditingController()
      ..addListener(() {
        setState(() {
          _userFuture = FeedLikeApiCalls().getUsers(
              _searchController.text, widget.postID!, context,
              postType: widget.postType);
        });
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white,
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
          AppLocalizations.of(
            "Likes",
          ),
          style: blackBold.copyWith(fontSize: 25),
        ),
      ),
      body: Container(
          child: FutureBuilder(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SmartRefresher(
                    enablePullDown: false,
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
                          body = Text(
                            AppLocalizations.of("No more Data"),
                          );
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: () {},
                    onLoading: () {
                      _onLoading();
                    },
                    child: _userList.users.length > 0
                        ? ListView.builder(
                            itemCount: _userList.users.length > 0
                                ? _userList.users.length + 1
                                : 0,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 10),
                                  child: Container(
                                    height: 35,
                                    decoration: new BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: TextFormField(
                                      maxLines: null,
                                      controller: _searchController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                          size: 25,
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: AppLocalizations.of('Search'),
                                        contentPadding: EdgeInsets.only(top: 1),
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                var user = _userList.users[index - 1];
                                return MemberCard(
                                  user: user,
                                  goToProfile: () {
                                    setState(() {
                                      OtherUser().otherUser.memberID =
                                          user.memberId;
                                      OtherUser().otherUser.shortcode =
                                          user.shortcode;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePageMain(
                                                  setNavBar: widget.setNavBar,
                                                  isChannelOpen:
                                                      widget.isChannelOpen,
                                                  changeColor:
                                                      widget.changeColor,
                                                  otherMemberID: user.memberId,
                                                )));
                                  },
                                  onTap: () {
                                    if (user.followData == "Follow") {
                                      setState(() {
                                        user.followData = "Following";
                                      });
                                      FeedLikeApiCalls.followUser(
                                          user.memberId!, index - 1);
                                    } else if (user.followData == "Requested") {
                                      setState(() {
                                        user.followData = "Follow";
                                      });
                                      FeedLikeApiCalls.cancelRequest(
                                          user.memberId!, index - 1);
                                    } else {
                                      FeedLikeApiCalls.unfollow(
                                          user.memberId!, index - 1);
                                      setState(() {
                                        user.followData = "Follow";
                                      });
                                    }
                                  },
                                );
                              }
                            })
                        : Center(
                            child: Container(
                              child: Text(
                                AppLocalizations.of(
                                  "No likes",
                                ),
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                  );
                } else {
                  print("no data");
                  return Container();
                }
              })),
    );
  }
}

class MemberCard extends StatelessWidget {
  final FeedLikedUsersModel? user;
  final VoidCallback? goToProfile;
  final VoidCallback? onTap;

  const MemberCard({Key? key, this.user, this.goToProfile, this.onTap})
      : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: goToProfile,
      visualDensity: VisualDensity(horizontal: 0, vertical: -1),
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(user!.image!),
        ),
      ),
      title: Text(
        user!.shortcode!,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 15),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        user!.name!,
        style: TextStyle(fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: user!.memberId != CurrentUser().currentUser.memberID
          ? GestureDetector(
              onTap: onTap,
              child: Container(
                  height: 30,
                  width: 80,
                  decoration: new BoxDecoration(
                    color: user!.followData == "Follow"
                        ? primaryBlueColor
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: Colors.black54,
                      width: user!.followData == "Follow" ? 0 : 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user!.followData!,
                      style: TextStyle(
                          fontSize: 14,
                          color: user!.followData == "Follow"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            )
          : Container(
              height: 0,
              width: 0,
            ),
    );
  }
}
