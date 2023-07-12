import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/ProfileSponorPage.dart';
import 'package:bizbultest/widgets/Adverts/create_video_advert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/widgets/Adverts/user_advertisements.dart';

import 'Profile/profile_feeds_page.dart';

class VideoAdverts extends StatefulWidget {
  @override
  _VideoAdvertsState createState() => _VideoAdvertsState();
}

class _VideoAdvertsState extends State<VideoAdverts>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 3, initialIndex: 0);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(12.0.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(top: 1.0.h),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              splashColor: Colors.grey.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(
                    Icons.keyboard_backspace,
                    size: 3.5.h,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 4.0.w,
                  ),
                  Text(
                    AppLocalizations.of(
                      "Video Advert",
                    ),
                    style: TextStyle(fontSize: 14.0.sp, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: <Tab>[
              Tab(
                child: Text(
                  AppLocalizations.of(
                    "Create Video Ad",
                  ),
                  style:
                      blackBold.copyWith(color: Colors.black, fontSize: 8.0.sp),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(
                    "My Advertisement",
                  ),
                  style:
                      blackBold.copyWith(color: Colors.black, fontSize: 8.0.sp),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(
                    "Sponsored Posts",
                  ),
                  style:
                      blackBold.copyWith(color: Colors.black, fontSize: 8.0.sp),
                ),
              ),
            ],
            controller: _tabController,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: TabBarView(
          controller: _tabController,
          children: [
            CreateVideoAdvert(
              sKey: _scaffoldKey,
              tabController: _tabController,
            ),
            UserAdvertisements(),
            ProfileSponsorPage(
              from: 'advert',
              // refresh: widget.refresh,
              // setNavBar: widget.setNavBar,
              // isChannelOpen: widget.isChannelOpen,
              // changeColor: widget.changeColor,
              otherMemberID: CurrentUser().currentUser.memberID,
              // post: widget.post,
              currentMemberImage: CurrentUser().currentUser.image,
              // listOfPostID: widget.stringOfPostID,
              // postID: widget.post.postId,

              logo: CurrentUser().currentUser.logo,
              country: CurrentUser().currentUser.country,
              memberID: CurrentUser().currentUser.memberID,
            )
          ],
        ),
      ),
    );
  }
}
