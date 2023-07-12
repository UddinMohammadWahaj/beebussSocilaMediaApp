import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Adverts/create_new_banner_ad.dart';
import 'package:bizbultest/widgets/Adverts/create_video_advert.dart';
import 'package:bizbultest/widgets/Adverts/view_banner_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/widgets/Adverts/user_advertisements.dart';

class BannerAds extends StatefulWidget {
  @override
  _BannerAdsState createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> with TickerProviderStateMixin {
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
                      "Banner Ads",
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
                    "Create Banner Ad",
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
                    "Banner Ads",
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
            CreateBannerAd(
              sKey: _scaffoldKey,
            ),
            UserAdvertisements(),
            ViewBannerAds(),
          ],
        ),
      ),
    );
  }
}
