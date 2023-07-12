import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/WatchLater/video_from_url.dart';
import 'package:bizbultest/widgets/WatchLater/video_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'channel_videos_card.dart';

class WatchLaterAddVideos extends StatefulWidget {
  final Function refreshWatchLater;

  WatchLaterAddVideos({Key? key, required this.refreshWatchLater})
      : super(key: key);

  @override
  _WatchLaterAddVideosState createState() => _WatchLaterAddVideosState();
}

class _WatchLaterAddVideosState extends State<WatchLaterAddVideos>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    _tabController =
        new TabController(vsync: this, length: 3, initialIndex: selectedIndex);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.0.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.grey[900],
          bottom: TabBar(
            labelPadding: EdgeInsets.only(right: 1.0.w, left: 1.0.w),
            indicatorColor: Colors.white,
            tabs: <Tab>[
              Tab(
                child: Text(
                  AppLocalizations.of('Search'),
                  style: whiteNormal.copyWith(fontSize: 10.0.sp),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(
                    "URL",
                  ),
                  style: whiteNormal.copyWith(fontSize: 10.0.sp),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(
                    "Your videos",
                  ),
                  style: whiteNormal.copyWith(fontSize: 10.0.sp),
                ),
              ),
            ],
            controller: _tabController,
            onTap: (int index) {},
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          WatchLaterVideoSearch(
            refreshWatchLater: widget.refreshWatchLater,
          ),
          VideoFromUrl(
            refreshWatchLater: widget.refreshWatchLater,
          ),
          SearchedChannelVideoCard(
            refreshWatchLater: widget.refreshWatchLater,
          )
        ],
      ),
    );
  }
}
